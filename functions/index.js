const functions = require("firebase-functions");
const admin     = require('firebase-admin');


admin.initializeApp();
const db = admin.firestore();
const fcm = admin.messaging();
const name;

export const notifyNewMessage = functions.firestore
    .document('chats/{messageId}')
    .onCreate(async snapshot => {
        const message = snapshot.data()['AllChats'][0];

        const querySnapshot = await db
            .collection('users')
            .doc(message.recieverId)
            .collection('tokens')
            .get();

        const tokens = querySnapshot.docs.map(snap => snap.id);

        const ref = db.collection('users').doc(message.recieverId);
        ref.get().then((snap)=>{
            name = snap.data()['name'];
        })

        const payload = {
            notification: {
                title: `WOC | ${name}`,
                body: message.message,
                clickAction: 'FLUTTER_NOTIFICATION_CLICK',
            }
        }
        return fcm.sendToDevice(tokens, payload);

    });
