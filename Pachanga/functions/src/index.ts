import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

admin.initializeApp();

// triggered when anything in a session document changes
exports.notifySessionChange = functions.firestore
.document('sessions/{sessionId}')
.onUpdate(async (change, context) => {
    const sessionId = context.params.sessionId;
    const beforeMembers = change.before.data()?.members || [];
    const afterMembers = change.after.data()?.members || [];

    // find members who joined
    const joinedMembers = afterMembers.filter((user_id: string) => !beforeMembers.includes(user_id))

    // find members who left
    const leftMembers = beforeMembers.filter((user_id: string) => !afterMembers.includes(user_id))

    const tokens: string[] = [];

    // fetch fcm tokens
    if (joinedMembers.length > 0 || leftMembers.length > 0) {
        const snapshot = await admin.firestore().collection('users').where('user_id', 'in', afterMembers).get();
        snapshot.forEach((doc) => {
            const fcmToken = doc.data().fcm_token;
            if (fcmToken) {
                tokens.push(fcmToken)
            }
        });
    }

    // send notifications
    for (const userId of joinedMembers) {
        const userDoc = await admin.firestore().collection('users').where('user_id', '==', userId).limit(1).get();
        const userName = userDoc.docs[0]?.data()?.name || 'Someone';

        await admin.messaging().sendToTopic(sessionId, {
            notification: {
                title: 'Someone joined the session',
                body: '${userName} is attending the session',
            },
        });
    }

    for (const userId of leftMembers) {
        const userDoc = await admin.firestore().collection('users').where('user_id', '==', userId).limit(1).get();
        const userName = userDoc.docs[0]?.data()?.name || 'Someone';

        await admin.messaging().sendToTopic(sessionId, {
            notification: {
                title: 'Someone left the session',
                body: '${userName} can no longer attend the session',
            },
        });
    }
});