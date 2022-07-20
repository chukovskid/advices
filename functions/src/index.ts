import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
admin.initializeApp();

const db = admin.firestore();
const fcm = admin.messaging();

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


  export const helloWorld = functions.https.onRequest((request, response) => {
    console.log("Hello logs2!", {structuredData: true});
    response.send("Hello from Firebase2!");
  });
  

  export const testFunction = functions.https.onCall((data) => {
    console.log("Hello logs2!", {structuredData: true});
    console.log("data: ", data)


  });