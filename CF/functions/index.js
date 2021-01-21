const functions = require('firebase-functions');

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
const admin = require('firebase-admin');
admin.initializeApp();
// import * as admin from 'firebase-admin';
// // Start writing Firebase Functions
// // https://firebase.google.com/docs/functions/typescript
//

exports.registerPolice = functions
  .region("asia-northeast1")
  .firestore.document("users/{users_requestsId}")
  .onCreate(async (snapshot) => {
    const values = snapshot.data();

    if (values.role === "police") {
        console.log("Creating new Police");
        const  displayName = values.firstName + " "+ values.lastName;
       
        admin.auth().createUser(
         {
           uid:snapshot.id,
        email: values.email,
         emailVerified: false,
         password: values.tempPassword,
         displayName: displayName,
         photoURL: "https://firebasestorage.googleapis.com/v0/b/sosmak-82380.appspot.com/o/police.png?alt=media&token=998171c7-a096-4442-9908-15bf9047b977",
         disabled: false}   
        )
        .then(function(userRecord) {
            // See the UserRecord reference doc for the contents of userRecord.
            console.log("Successfully created new Police:", userRecord.uid);
        })
        .catch(function(error) {
            console.log("Error creating new Police:", error);
        });
    }  
  });

  exports.deleteUser = functions
  .region("asia-northeast1")
  .firestore.document("users/{userId}")
  .onDelete(async (snap, context) => {
    const user = snap.data();
    const docID = context.params.userId;
    await admin
      .auth()
      .deleteUser(docID)
      .then(() => {
        console.log("Successfully deleted user");
      })
      .catch(error => {
        console.log("Error deleting user:", error);
      });
  });