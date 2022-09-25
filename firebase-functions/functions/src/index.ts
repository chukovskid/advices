import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
admin.initializeApp();

const db = admin.firestore();
const fcm = admin.messaging();



export const notifyNewCalls = functions.firestore
  .document('users/{callerId}/pendingCalls/{channelName}')
  .onWrite(async (snapshot, context) => {
    let callerId = context.params.callerId;
    let channelName = context.params.channelName;
    let displayName = "A user";
    const querySnapshot = await db
      .collection('users')
      .doc(callerId)
      .collection('tokens')
      .get();
    const userRef = await db
      .collection('users')
      .doc(callerId);
    userRef.get().then((doc) => {
      if (doc.exists) {
        let data = doc.data()
        console.log("Document Id:", data!.uid);

        console.log("Document displayName:", data!.displayName);
        displayName = data!.displayName;
      } else {
        // doc.data() will be undefined in this case
        console.log("No such document!");
      }
    }).catch((error) => {
      console.log("Error getting document:", error);
    });
    const tokens = querySnapshot.docs.map((snap: any) => snap.id); // TODO check the  token!
    console.log("tokens ==== ", tokens);
    const payload: admin.messaging.MessagingPayload = {
      notification: {
        title: 'Tap to join call!',
        body: `${displayName} has starter a call with you.`,
        icon: 'your-icon-url',
        click_action: 'FLUTTER_NOTIFICATION_CLICK',
      },
      data : {
        channelName: channelName
      }
    };
    return fcm.sendToDevice(tokens, payload);
  });


// This is a PAID feature and be carefull with this
  // export const scheduledFunctionCrontab = functions.pubsub.schedule('5 11 * * *').onRun((context) => {
  //     console.log('This will be run every day at 11:05 AM UTC!');
  // });
  





export const sendToTopic = functions.firestore
  .document('puppies/{puppyId}')
  .onCreate(async snapshot => {
    const puppy = snapshot.data();

    const payload: admin.messaging.MessagingPayload = {
      notification: {
        title: 'New Puppy!',
        body: `${puppy.name} is ready for adoption`,
        icon: 'your-icon-url',
        click_action: 'FLUTTER_NOTIFICATION_CLICK'
      }
    };

    return fcm.sendToTopic('puppies', payload);
  });

export const sendToDevice = functions.firestore
  .document('orders/{orderId}')
  .onCreate(async snapshot => {


    const order = snapshot.data();

    const querySnapshot = await db
      .collection('users')
      .doc(order.seller)
      .collection('tokens')
      .get();

    const tokens = querySnapshot.docs.map((snap: any) => snap.id);

    const payload: admin.messaging.MessagingPayload = {
      notification: {
        title: 'New Order!',
        body: `you sold a ${order.product} for ${order.total}`,
        icon: 'your-icon-url',
        click_action: 'FLUTTER_NOTIFICATION_CLICK'
      }
    };

    return fcm.sendToDevice(tokens, payload);
  });



export const informUserForUpenCall = functions.firestore
  .document('orders/{orderId}')
  .onCreate(async snapshot => {


    const order = snapshot.data();

    const querySnapshot = await db
      .collection('users')
      .doc(order.seller)
      .collection('tokens')
      .get();

    const tokens = querySnapshot.docs.map((snap: any) => snap.id); // it seems like we give the receaverId here

    const payload: admin.messaging.MessagingPayload = {
      notification: {
        title: 'New Order!',
        body: `you sold a ${order.product} for ${order.total}`,
        icon: 'your-icon-url',
        click_action: 'FLUTTER_NOTIFICATION_CLICK'
      }
    };

    return fcm.sendToDevice(tokens, payload);
  });


export const helloWorld = functions.https.onRequest((request, response) => {
  console.log("Hello logs2!", { structuredData: true });
  response.send("Hello from Firebase2!");
});


export const testFunction = functions.https.onCall((data) => {
  console.log("Hello logs2!", { structuredData: true });
  console.log("data.receiverId: ", data.receiverId)

  return data


});




/////// VERY IMPORTANT
// exports.createCallsWithTokens = functions.https.onCall((data, context) => {

//   // console.log("context.auth.uid===========: ", context.auth.uid);
//   console.log("context.auth.data=========: ", data);

//   try {
//       const appId = "03f0c2c7973949b3afe5e475f15a350e";
//       const appCertificate = "3c274947f08447ebb0a83f1ecc43beda";
//       const role = agora_access_token_1.RtcRole.PUBLISHER;
//       const expirationTimeInSeconds = 3600;
//       const currentTimestamp = Math.floor(Date.now() / 1000);
//       const privilegeExpired = currentTimestamp + expirationTimeInSeconds;
//       const uid = 0;
//       // const channelName = Math.floor(Math.random() * 100).toString();
//       const channelName = data.channelName.toString();
//       const token = agora_access_token_1.RtcTokenBuilder.buildTokenWithUid(appId, appCertificate, channelName, uid, role, privilegeExpired);
//       return {
//           data: {
//               token: token,
//               channelId: channelName,
//           },
//       };
//   }
//   catch (error) {
//       console.log(error);
//   }
// });






