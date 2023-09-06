const functions = require("firebase-functions");

const admin = require("firebase-admin");
admin.initializeApp();

const db = admin.firestore();

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions

exports.updatePoints = functions.firestore
    .document("users/{userId}/topics/{topicId}/reviews/{reviewId}")
    .onCreate((snap, context) => {
        const rating = snap.data().rating;
        const userId = context.params.userId;
        const topicId = context.params.topicId;
        db.doc(`users/${userId}/topics/${topicId}`).get().then(res => {
            const points = res.get('points');
            if (rating === 1) {
                db.doc(`users/${userId}/topics/${topicId}`).update({ points: points - 20 });
            }
            else if (rating === 2) {
                db.doc(`users/${userId}/topics/${topicId}`).update({ points: points - 10 });
            }
            else if (rating === 3) {
                db.doc(`users/${userId}/topics/${topicId}`).update({ points: points + 10 });
            }
            else if (rating === 4) {
                db.doc(`users/${userId}/topics/${topicId}`).update({ points: points + 40 });
            }
            else if (rating === 5) {
                db.doc(`users/${userId}/topics/${topicId}`).update({ points: points + 50 });
            }
        });
        return null;
    });

exports.updateRating = functions.firestore
    .document("users/{userId}/topics/{topicId}")
    .onUpdate((change, context) => {
        const newPoints = change.after.data().points;
        const previousPoints = change.before.data().points;
        const rating = change.after.data().rating;
        db.doc(`users/${userId}/topics/${topicId}/reviews`).get()
        
        //no change to points -> prevent infinite loop
        if (newPoints == previousPoints) { 
            return null;
        }

        if (rating == 1) {
            if (newPoints > 150) {
                return change.after.ref.update({ rating: 2 });
            } else {
                return null;
            }
        }
        else if (rating == 2) { 
            if (newPoints > 350) { //150 + 200
                return change.after.ref.update({ rating: 3 });
            } else if (newPoints < 150){
                return change.after.ref.update({ rating: 1 });
            } else {
                return null;
            }
        }
        else if (rating == 3) {
            if (newPoints > 600) { //350 + 250
                return change.after.ref.update({ rating: 4 });
            } else if (newPoints < 350){
                return change.after.ref.update({ rating: 2 });
            } else {
                return null;
            }
        }   
        else if (rating == 4) {
            if (newPoints > 900) { //600 + 300
                return change.after.ref.update({ rating: 5 });
            } else if (newPoints < 600){
                return change.after.ref.update({ rating: 3 });
            } else {
                return null;
            }
        }   
        else if (rating == 5) {
            if (newPoints < 900) { //600 + 300
                return change.after.ref.update({ rating: 4 });
            } else {
                return null;
            }
        }   
        return null;
    });