import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
import { sendEmail } from './services/email';


admin.initializeApp();

const db = admin.firestore();
const fcm = admin.messaging();


// function makeDynamicLongLink(postId, socialDescription, socialImageUrl) {
//   return urlBuilder(`${functions.config().applinks.link}`, {
//       queryParams: {
//           link: "https://www.arvana.io/code/" + postId,
//           apn: "io.arvana.blog",
//           dfl: "https://www.arvana.io",
//           st: "Arvana Blog - All you need to know about arvana",
//           sd: socialDescription,
//           si: socialImageUrl
//       }
//   });
// }


export const callUser = functions.https.onCall(async (data, context) => {

  // let callerId = context.auth?.uid;
  let receiverId = data.receiverId;
  let channelName = data.channelName;
  let displayName = "A user";
  const querySnapshot = await db
    .collection('users')
    .doc(receiverId)
    .collection('tokens')
    .get();
  const userRef = await db
    .collection('users')
    .doc(receiverId);
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
    data: {
      channelName: channelName
    }
  };
  return fcm.sendToDevice(tokens, payload);
});


export const notifyNewCalls = functions.firestore
  .document('users/{callerId}/pendingCalls/{channelName}')
  .onWrite(async (snapshot, context) => {
    let callerId = context.params.callerId;
    let channelName = context.params.channelName;
    let displayName = "A user";
    let data = snapshot.after.data();
    console.log("///// data", data)
    console.log("///// data.lawyerId", data?.lawyerId)
    console.log("///// other info ", callerId, channelName, displayName)

    // const querySnapshot = await db
    //   .collection('users')
    //   .doc(callerId)
    //   .collection('tokens')
    //   .get();
    // const userRef = await db
    //   .collection('users')
    //   .doc(callerId);
    // userRef.get().then((doc) => {
    //   if (doc.exists) {
    //     let data = doc.data()
    //     console.log("Document Id:", data!.uid);

    //     console.log("Document displayName:", data!.displayName);
    //     displayName = data!.displayName;
    //   } else {
    //     // doc.data() will be undefined in this case
    //     console.log("No such document!");
    //   }
    // }).catch((error) => {
    //   console.log("Error getting document:", error);
    // });
    // const tokens = querySnapshot.docs.map((snap: any) => snap.id); // TODO check the  token!
    // console.log("tokens ==== ", tokens);
    // const payload: admin.messaging.MessagingPayload = {
    //   notification: {
    //     title: 'Tap to join call!',
    //     body: `${displayName} has starter a call with you.`,
    //     icon: 'your-icon-url',
    //     click_action: 'FLUTTER_NOTIFICATION_CLICK',
    //   },
    //   data: {
    //     channelName: channelName
    //   }
    // };
    // return fcm.sendToDevice(tokens, payload);
    const userRef = await db
      .collection('users')
      .doc(callerId).get();
    const user = userRef.data();
    console.log("///// notifyNewCalls", user)
  });


// This is a PAID feature and be carefull with this
// export const scheduledFunctionCrontab = functions.pubsub.schedule('5 11 * * *').onRun((context) => {
//     console.log('This will be run every day at 11:05 AM UTC!');
// });


export const sendToTopic = functions.firestore.document('puppies/{puppyId}').onCreate(async snapshot => {
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

export const sendToDevice = functions.firestore.document('orders/{orderId}').onCreate(async snapshot => {


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


export const informUserForUpenCall = functions.firestore.document('orders/{orderId}').onCreate(async snapshot => {


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


export const helloWorld = functions.https.onRequest(async (request, response) => {
  console.log("Hello logs2!", { structuredData: true });

  const clientRef = await db
    .collection('users')
    .doc("69kDEqpjX7aeulnh6QsCt1uH8l23").get();
  const client = clientRef.data() as IUser;
  await sendEmail("cukovskidimitar@gmail.com", client.email, "body 123", "HTML Client 123");

  const lawyerRef = await db
    .collection('users')
    .doc("Lk37HV68oaPxOA8AHpNqcSoFgEA3").get();
  const lawyer = lawyerRef.data() as IUser;
  await sendEmail("cukovskidimitar@gmail.com", lawyer.email, "body 123", "HTML Lawyer 123");


  response.send("Hello from Firebase4!");
});


export const testFunction = functions.https.onCall(async (data) => {
  console.log("Hello logs3!", { structuredData: true });

  try {
    await sendEmail('cukovskidimitar@gmail.com', "test proba 1", "This is the body", "this is the HTML");

  } catch (error) {
    return error
  }
  console.log("data.receiverId: ", data.uid)

  return "Hello logs3"


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






