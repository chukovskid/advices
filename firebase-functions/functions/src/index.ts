import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
admin.initializeApp();

// // Start writing Firebase Functions
// // https://firebase.google.com/docs/functions/typescript
//
export const helloWorld = functions.https.onRequest((request, response) => {
  functions.logger.info("Hello logs2!", {structuredData: true});
  response.send("Hello from Firebase2!");
});


































//////////////
////////////
//////////////
////////////
//////////////
////////////
/// PRACTISE >>>>>>>



// const db = admin.firestore();
// const fcm = admin.messaging();

/// To fix TSC and  ESLINT
// npm install -g npx
// npm i tupescript -g
// cd functions/
// npm -g i eslint-cli
// npm i eslint --save-dev
// eslint .\
// ./node_modules/.bin/eslint src --fix


// export const newUserSignUp = functions.auth.user().onCreate((user) => {
//   console.log("user created", user.email, user.uid);
//   return admin.firestore().collection("users").doc(user.uid).set({
//     email: user.email,
//     someNewRandomValue: "random value for testing",
//   });
// });

// export const userDeleted = functions.auth.user().onDelete((user) => {
//   console.log("user deleted", user.email, user.uid);
//   const doc = admin.firestore().collection("users").doc(user.uid);
//   doc.delete();
// });

// // Request call
// export const addRequest = functions.https.onCall((data, context) => {
//   if (!context.auth) {
//     throw new functions.https.HttpsError(
//       "unauthenticated",
//       "Only authenticated users can add requests"
//     );
//   }
//   if (data.text.length > 30) {
//     throw new functions.https.HttpsError(
//       "invalid-argument",
//       "Request must be under 30 characters long"
//     );
//   }
//   return admin.firestore().collection("request").add({
//     text: data.text,
//   });
// });


// // firestore trigger for tracking activity
// exports.logActivities = functions.firestore
//   .document("/{collection}/{id}")
//   .onCreate((snap, context) => {
//     console.log(snap.data());

//     const activities = admin.firestore().collection("activities");
//     const collection = context.params.collection;

//     if (collection === "requests") {
//       return activities.add({ text: "a new tutorial request was added" });
//     }
//     if (collection === "users") {
//       return activities.add({ text: "a new user signed up" });
//     }

//     return null;
//   });

//   // Cloud Messaging, Notifications
//   export const sendToTopic = functions.firestore
//   .document("puppies/{puppyId}")
//   .onCreate(async (snapshot) => {
//     const puppy = snapshot.data();

//     const payload: admin.messaging.MessagingPayload = {
//       notification: {
//         title: "New Puppy!",
//         body: `${puppy.name} is ready for adoption`,
//         icon: "your-icon-url",
//         click_action: "FLUTTER_NOTIFICATION_CLICK",
//       },
//     };

//     return fcm.sendToTopic("puppies", payload);
//   });

// export const sendToDevice = functions.firestore
//   .document("orders/{orderId}")
//   .onCreate(async (snapshot) => {
//     const order = snapshot.data();

//     const querySnapshot = await db
//       .collection("users")
//       .doc(order.seller)
//       .collection("tokens")
//       .get();

//     const tokens = querySnapshot.docs.map((snap) => snap.id);

//     const payload: admin.messaging.MessagingPayload = {
//       notification: {
//         title: "New Order!",
//         body: `you sold a ${order.product} for ${order.total}`,
//         icon: "your-icon-url",
//         click_action: "FLUTTER_NOTIFICATION_CLICK",
//       },
//     };

//     return fcm.sendToDevice(tokens, payload);
//   });
