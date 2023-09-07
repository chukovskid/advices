import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
import { sendEmail } from './services/email';
import { payForMessage } from './services/stripe_payment';

const agora_access_token_1 = require('agora-access-token');
const crypto = require('crypto-js');

import axios from 'axios';
import Stripe from 'stripe';


admin.initializeApp();

const db = admin.firestore();
const fcm = admin.messaging();


const stripe = new Stripe(process.env.STRIPE_SECRET_KEY!, { apiVersion: '2022-08-01' });

// export const handlePaymentIntentSucceeded = functions.https.onRequest((req, res) => {
//  NOT USED
//   const data = req.body; // This is the data sent in the POST request

//   console.log('Data received: ', data);

//   const event = stripe.webhooks.constructEvent(
//     req.rawBody,
//     req.headers['stripe-signature'] || '',
//     'YOUR_WEBHOOK_SECRET'
//   );

//   if (event.type === 'payment_intent.succeeded') {
//     const paymentIntent = event.data.object as Stripe.PaymentIntent;
//     console.log('PaymentIntent was successful!');
//     console.log('PaymentIntent data: ', data);
//     console.log('PaymentIntent : ', paymentIntent);
//   }

//   res.sendStatus(200);
// });


// export const createCheckoutSession = functions.https.onCall(async (data, context) => {
//  NOT USED
//console.log('Creating checkout session...');
//   const session = await stripe.checkout.sessions.create({
//     payment_method_types: ['card'],
//     line_items: [
//       {
//         price: 'price_1LrkUPH6waKuk26ucUMu99hm', // this is the price ID
//         quantity: 1,
//       },
//     ],
//     mode: 'payment',
//     success_url: 'https://advices.page.link/success_payment',
//     cancel_url: 'https://advices.page.link/cancel_payment',
//   });
//   console.log('Checkout session created: ', session.id);
//   const sessionResponse = await stripe.checkout.sessions.retrieve(session.id);
//   if (sessionResponse) {
//     console.log('Session exists:', sessionResponse.id);
//     console.log('Session status:', sessionResponse.payment_status);
//     // You can check more properties here if needed
//     // For example, you might want to check if the session has been paid
//     return { id: sessionResponse.id };
//   } else {
//     console.log('Session does not exist');
//   }
//   return { id: session.id };
// });

export const stripeWebhook = functions.https.onRequest(async (request, response) => {
  const sig = request.headers['stripe-signature'];
  let event = request.body;

  if (!sig || !process.env.STRIPE_SECRET_KEY) {
    response.status(400).send('Missing Stripe Signature');
    return;
  }

  console.log('request.body.type', event.type);
  switch (event.type) {
    case 'payment_intent.created':
      // const paymentIntent = event.data.object;
      console.log('PaymentIntent was created!');
      break;
    case 'payment_link.created':
      // const paymentLink = event.data.object;
      console.log('PaymentLink was created!');
      break;
    case 'charge.succeeded':
      // const chargeSuccess = event.data.object;
      console.log('Charge was successful!');
      break;
    case 'payment_intent.succeeded':
      // const paymentIntentSucess = event.data.object;
      console.log('PaymentIntent was successful!');
      break;
    case 'payment_intent.created':
      // const paymentIntentCreated = event.data.object;
      console.log('PaymentIntent was created!');
      break;
    case 'checkout.session.completed':
      const paymentSuccess = event.data.object;
      console.log('Payment was successful!');
      const bytes = crypto.AES.decrypt(paymentSuccess.metadata.messagePath, process.env.STRIPE_SECRET_KEY);
      const originalProductId = bytes.toString(crypto.enc.Utf8);
      await payForMessage(admin, originalProductId);
      break;
    case 'payment_method.attached':
      const paymentMethod = event.data.object;
      console.log('PaymentMethod was attached to a Customer!', paymentMethod);
      // Then define and call a method to handle the successful attachment of a PaymentMethod.
      // handlePaymentMethodAttached(paymentMethod);
      break;
    // ... handle other event types
    default:
      console.log(`Unhandled event type ${event.type}`);
  }

  response.json({ received: true });
});

export const createPaymentLink = functions.https.onCall(async (data, context) => {
  const path = data.path;
  const encryptedProductId = crypto.AES.encrypt(path, process.env.STRIPE_SECRET_KEY).toString();
  const paymentLink = await stripe.paymentLinks.create({
    currency: 'usd',
    line_items: [
      {
        price: 'price_1LrkUPH6waKuk26ucUMu99hm', // this is the price ID
        quantity: 1,
      },
    ],
    metadata: {
      messagePath: encryptedProductId
    }
  });
  return paymentLink.url;
});

export const createLawyerProfileDynamicLink = functions.https.onCall(async (data, context) => {
  // This function is not used, but it WORKS
  const lawyerId = data.lawyerId;
  const link = `http://localhost:8000/#/lawyers/${lawyerId}`;

  const dynamicLink = {
    dynamicLinkInfo: {
      domainUriPrefix: 'https://advices.page.link',
      link: link,
      androidInfo: {
        androidPackageName: 'com.yourcompany.yourappname',//TODO dev and prod 
      },
      iosInfo: {
        iosBundleId: 'com.yourcompany.yourappname',
      },
    },
    suffix: {
      option: 'SHORT',
    },
  }

  const requestUri = `https://firebasedynamiclinks.googleapis.com/v1/shortLinks?key=${process.env.APP_ID_FIREBASE}`;

  try {
    const response = await axios.post(requestUri, dynamicLink);
    console.log('Dynamic link created: ', response.data.shortLink);
    return { dynamicLink: response.data.shortLink };
  } catch (error) {
    console.error('Error creating dynamic link: ', error);
    throw error;
  }
});

// export const createDynamicLink = functions.https.onCall(async (data, context) => {
//   // This function is not used, but it WORKS
//   const productId = data.productId;
//   const link = `http://localhost:8000/#/success_payment/${productId}`;

//   const dynamicLink = {
//     dynamicLinkInfo: {
//       domainUriPrefix: 'https://advices.page.link',
//       link: link,
//       androidInfo: {
//         androidPackageName: 'com.yourcompany.yourappname',//TODO dev and prod 
//       },
//       iosInfo: {
//         iosBundleId: 'com.yourcompany.yourappname',
//       },
//     },
//     suffix: {
//       option: 'SHORT',
//     },
//   }

//   const requestUri = `https://firebasedynamiclinks.googleapis.com/v1/shortLinks?key=AIzaSyAMiXYCdnUTqZItvme_QYds_TTNCLXGmac`;

//   try {
//     const response = await axios.post(requestUri, dynamicLink);
//     console.log('Dynamic link created: ', response.data.shortLink);
//     return { dynamicLink: response.data.shortLink };
//   } catch (error) {
//     console.error('Error creating dynamic link: ', error);
//     throw error;
//   }
// });

export const getCustomToken = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError('unauthenticated', 'User must be authenticated');
  }

  const uid = context.auth.uid;
  try {
    console.log('Creating custom token for UID ', uid);
    const customToken = await admin.auth().createCustomToken(uid);
    return { token: customToken };
  } catch (error) {
    console.log('Error creating custom token:', error);
    throw new functions.https.HttpsError('internal', 'Error creating custom token');
  }
});

export const callUser = functions.https.onCall(async (data, context) => {
  // let callerId = context.auth?.uid;
  let receiverId = data.receiverId;
  let channelName = data.channelName;
  let displayName = "Некој";
  const querySnapshot = await db.collection('users').doc(receiverId).collection('tokens').get();
  const userRef = await db.collection('users').doc(receiverId);
  await userRef.get().then((doc) => {
    if (doc.exists) {
      let data = doc.data()
      displayName = data!.displayName;
    } else {
      console.log("No such document!");
    }
  }).catch((error) => {
    console.log("Error getting document:", error);
  });
  const tokens = querySnapshot.docs.map((snap: any) => snap.id); // TODO check the  token!
  console.log("tokens ==== ", tokens);
  const payload: admin.messaging.MessagingPayload = {
    notification: {
      title: 'Отвори повик',
      body: `${displayName} ти ѕвони`,
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
    const userRef = await db
      .collection('users')
      .doc(callerId).get();
    const user = userRef.data();
    console.log("///// notifyNewCalls", user)
  });

export const notificationForNewMessage = functions.firestore.document('/conversation/groups/chats/{chatId}').onWrite(async snapshot => {
  let data = snapshot.after.data();
  if (!data) return "no data";
  let members = data!.members ? data!.members : [];
  const senderId = data!.senderId ? data!.senderId : '';
  let lastMessageTime = data!.lastMessageTime ? new Date(data!.lastMessageTime.toMillis()).toISOString() : '';
  let receiverId = members.filter((member: any) => member !== senderId)[0];
  let lastMessage = data!.lastMessage ? data!.lastMessage : '';
  let senderName;
  let senderPhotoURL;
  const senderRef = await db.collection('users').doc(senderId);
  await senderRef.get().then((doc) => {
    if (doc.exists) {
      let data = doc.data()
      senderName = data!.displayName;
      senderPhotoURL = data!.photoURL;
    } else {
      console.log("No such document!");
    }
  }).catch((error) => {
    console.log("Error getting document:", error);
  });
  const querySnapshot = await db.collection('users').doc(receiverId).collection('tokens').get();
  const tokens = querySnapshot.docs.map((snap: any) => snap.id); // TODO check the  token!
  const payload: admin.messaging.MessagingPayload = {
    notification: {
      title: senderName,
      body: lastMessage,
      icon: senderPhotoURL,
      click_action: 'FLUTTER_NOTIFICATION_CLICK',
    },
    data: {
      senderId: senderId,
      receiverId: receiverId,
      lastMessage: lastMessage,
      lastMessageTime: lastMessageTime,
      senderName: senderName ? senderName : '',
      senderPhotoURL: senderPhotoURL ? senderPhotoURL : '',
    }
  };
  //senderName, lastMessage, lastMessageTime, senderPhotoURL
  let receaverData : any;

  const receaverRef = await db.collection('users').doc(receiverId);
  await receaverRef.get().then((doc) => {
    if (doc.exists) {
      receaverData = doc.data()
      console.log("receaverData: ", receaverData);
    } else {
      console.log("No such document!");
    }
  }).catch((error) => {
    console.log("Error getting document:", error);
  });
  
await sendEmail(receaverData!.email, "advokat.mk: Имате нова порака!", "Имате нова порака од " + senderName + ":\n  " + lastMessage, "");
  return fcm.sendToDevice(tokens, payload);
});

async function callGPT(prompt: string) {
  const apiKey = 'sk----this key is removed for security reasons---- add new one';
  const url = 'https://api.openai.com/v1/engines/text-davinci-003/completions';

  const headers = {
    'Content-Type': 'application/json',
    'Authorization': `Bearer ${apiKey}`
  };

  const data = {
    'prompt': prompt,
    'max_tokens': 50,
    'temperature': 0.7
  };

  try {
    const response = await axios.post(url, data, { headers: headers });
    return response.data.choices[0].text.trim();
  } catch (error) {
    console.error('Error calling GPT API:', error);
    return null;
  }
}

async function extractKeyClausesAndTerms(preprocessedText: string) {
  const prompt = `Given the following contract text, extract key clauses and terms in Macedonian language : "${preprocessedText}"`;
  return await callGPT(prompt);
}

async function identifyIssuesAndRisks(preprocessedText: string) {
  const prompt = `Given the following contract text, identify potential issues, risks, or discrepancies in Macedonian language: "${preprocessedText}"`;
  return await callGPT(prompt);
}

async function generateExplanationsAndRecommendations(issuesAndRisks: string) {
  const prompt = `Given the following issues and risks found in a contract, provide plain-English explanations and recommendations in Macedonian language: "${issuesAndRisks}"`;
  return await callGPT(prompt);
}

async function compareWithTemplates(preprocessedText: string) {
  const prompt = `Given the following contract text, compare it with standard templates or best practices in Macedonian language: "${preprocessedText}"`;
  return await callGPT(prompt);
}

async function processContract(contractText: string) {
  const preprocessedText = preprocess(contractText);
  const keyClausesAndTerms = await extractKeyClausesAndTerms(preprocessedText);
  const issuesAndRisks = await identifyIssuesAndRisks(preprocessedText);
  const explanationsAndRecommendations = await generateExplanationsAndRecommendations(issuesAndRisks);
  const comparisonResults = await compareWithTemplates(preprocessedText);

  const analysisResults = {
    summary: keyClausesAndTerms,
    issues: issuesAndRisks,
    explanations: explanationsAndRecommendations,
    comparison: comparisonResults
  };

  return analysisResults;
}

function preprocess(contractText: string) {
  // Simple preprocessing: Convert to lowercase and remove extra spaces
  return contractText.toLowerCase().replace(/\s+/g, ' ').trim();
}


export const analyzeContract = functions.https.onRequest(async (req, res) => {
  const contractText = req.body.contractText as string;

  if (!contractText) {
    res.status(400).json({ error: 'Missing contractText parameter.' });
    return;
  }

  try {
    const analysisResults = await processContract(contractText);
    res.status(200).json({ analysisResults });
  } catch (error) {
    res.status(500).json({ error: 'An error occurred during contract analysis.' });
  }
});



/////// VERY IMPORTANT
export const createCallsWithTokens = functions.https.onCall((data, context) => {
  // console.log("context.auth.uid===========: ", context.auth.uid);
  console.log("context.auth.data=========: ", data);
  try {
    const appId = "03f0c2c7973949b3afe5e475f15a350e";
    const appCertificate = "3c274947f08447ebb0a83f1ecc43beda";
    const role = agora_access_token_1.RtcRole.PUBLISHER;
    const expirationTimeInSeconds = 3600;
    const currentTimestamp = Math.floor(Date.now() / 1000);
    const privilegeExpired = currentTimestamp + expirationTimeInSeconds;
    const uid = 0;
    // const channelName = Math.floor(Math.random() * 100).toString();
    const channelName = data.channelName.toString();
    const token = agora_access_token_1.RtcTokenBuilder.buildTokenWithUid(appId, appCertificate, channelName, uid, role, privilegeExpired);
    return {
      data: {
        token: token,
        channelId: channelName,
      },
    };
  }
  catch (error) {
    console.log(error);
  }
  return null;
});

//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
//
//
//Test function - remove it
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

//Test function - remove it
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

//Test function - remove it
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

//Test function - remove it
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

//Test function - remove it
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

// This is a PAID feature and be carefull with this
// export const scheduledFunctionCrontab = functions.pubsub.schedule('5 11 * * *').onRun((context) => {
//     console.log('This will be run every day at 11:05 AM UTC!');
// });




