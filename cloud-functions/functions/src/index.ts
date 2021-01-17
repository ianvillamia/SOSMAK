import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
// // Start writing Firebase Functions
// // https://firebase.google.com/docs/functions/typescript
//

export const registry = functions
  .region("asia-northeast1")
  .firestore.document("users/{users_requestsId}")
  .onCreate(async (snap, context) => {
    const values = snap.data();

    if (values.role === "police") {
        console.log("Creating new Police");
        const  displayName = values.firstName + " "+ values.lastName;
        admin.auth().createUser(
         {
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