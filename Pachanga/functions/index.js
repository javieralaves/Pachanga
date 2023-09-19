const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

async function getUsersInSession(sessionId) {
  const sessionRef = admin.firestore().collection("sessions").doc(sessionId);
  const sessionDoc = await sessionRef.get();

  if (!sessionDoc.exists) {
    console.log("No such session!");
    return [];
  }

  return sessionDoc.data().userIds || [];
}

async function sendNotificationToUsers(userIds, sessionData) {
  // Fetch tokens of the users
  const tokens = [];
  for (const userId of userIds) {
    const userRef = admin.firestore().collection("users").doc(userId);
    const userDoc = await userRef.get();

    if (userDoc.exists && userDoc.data().token) {
      tokens.push(userDoc.data().token);
    }
  }

  // Prepare the message
  const message = {
    notification: {
      title: "Session Update",
      body: `Someone joined or left the session: ${sessionData.name}`,
    },
    tokens: tokens,
  };

  // Send the message
  await admin.messaging().sendMulticast(message);
}

exports.notifySessionChange = functions.firestore
  .document("sessions/{sessionId}")
  .onWrite(async (change, context) => {
    const sessionData = change.after.data();
    const sessionId = context.params.sessionId;

    // fetch users within session
    const usersToNotify = await getUsersInSession(sessionId);

    // send notification to users
    sendNotificationToUsers(usersToNotify, sessionData);
  });
