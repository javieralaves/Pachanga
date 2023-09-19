const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

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
