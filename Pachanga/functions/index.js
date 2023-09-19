// importing required Firebase modules
const functions = require("firebase-functions");
const admin = require("firebase-admin");

// initializing Firebase Admin SDK to access Firestore
admin.initializeApp();

// this function triggers when a 'sessions' document is updated.
exports.getUsersInSession = functions.firestore
  .document("sessions/{sessionId}")
  .onUpdate(async (change, context) => {
    // extract session ID from the event context.
    const sessionId = context.params.sessionId;

    // fetch the session document from Firestore.
    const sessionDoc = await admin
      .firestore()
      .collection("sessions")
      .doc(sessionId)
      .get();

    // list of user ids fetched from session
    const userIds = sessionDoc.data().members || [];

    // fetch FCM tokens for these users.
    const userTokens = await getUserTokens(userIds);

    // Call sendNotificationToUsers to send notification
    if (userTokens.length > 0) {
      await sendNotificationToUsers(
        userTokens,
        "Someone joined or left the session."
      );
    }
  });

// helper function to fetch FCM tokens for a list of user IDs.
const getUserTokens = async (userIds) => {
  const tokens = [];
  for (const userId of userIds) {
    const userDoc = await admin
      .firestore()
      .collection("users")
      .doc(userId)
      .get();
    if (userDoc.exists && userDoc.data().fcm_token) {
      tokens.push(userDoc.data().fcm_token);
    }
  }
  return tokens;
};

// helper function to send notifications to a list of user tokens.
const sendNotificationToUsers = async (userTokens, message) => {
  const messages = userTokens.map((token) => ({
    token,
    notification: {
      title: "Session Update",
      body: message,
    },
  }));

  return await admin.messaging().sendEach(messages);
};
