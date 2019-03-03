const functions = require('firebase-functions');
const admin = require('firebase-admin');

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//  response.send("Hello from Firebase!");
// });
//
//
//

admin.initializeApp(functions.config().firebase);
let db = admin.firestore();

exports.createLog = functions.firestore
  .document('logs/{logId}')
  .onCreate((snap, context) => {
    let date = new Date().toISOString().substring(0, 10);

    let dataRef = db.collection('data').doc(date);

    dataRef.get()
      .then(doc => {

        let data = {
          calories: snap.data().calories,
          carbs: snap.data().carbs,
          cholesterol: snap.data().cholesterol,
          fat: snap.data().fat,
          protein: snap.data().protein,
          saturated_fat: snap.data().saturated_fat,
          sodium: snap.data().sodium,
          sugar: snap.data().sugar,
          meal: snap.data().food_name,

        }

        if (doc.exists) {
          data.calories += doc.data().calories;
          data.carbs += doc.data().carbs;
          data.cholesterol += doc.data().cholesterol;
          data.fat += doc.data().fat;
          data.protein += doc.data().protein;
          data.saturated_fat += doc.data().saturated_fat;
          data.sodium += doc.data().sodium;
          data.sugar += doc.data().sugar;
        }

        dataRef.set(data);
      })
      .catch(err => {
      });

  });
