import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
admin.initializeApp();

const db = admin.firestore();
const fcm = admin.messaging();



export const notifyNewCalls = functions.firestore
  .document('calls/{callerId}/open/{channelName}')
  // .document('users/{userId}/tokens/{tokenId}')
  .onUpdate(async (snapshot, context) => {

    // let { userId, tokenId }
    let callerId = context.params.callerId;
    let displayName = "A user";
    // const token = snapshot.after.data() 

    // const tokens = token!.docs.map((snap: any) => snap.id); // TODO check the  token!

    console.log("context.params.callerId ==== ", callerId);


    /////
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
        channelId: "ChannelId_Test_123"

      }
    };

    return fcm.sendToDevice(tokens, payload);
  });





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