import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Utility functions for Firebase auth

Future<bool> signIn(String email, String password) async {
  try {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    return true;
  } catch (e) {
    print(e);
    return false;
  }
}

Future<bool> register(String email, String password) async {
  try {
    // copied and pasted directly from docs
    // https://firebase.flutter.dev/docs/auth/usage#emailpassword-registration--sign-in
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    return true;
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      print('The password provided is too weak.');
    } else if (e.code == 'email-already-in-use') {
      print('The account already exists for that email.');
    }
    return false;
  } catch (e) {
    print(e);
    return false;
  }
}

Future<bool> addCoin(String id, String amount) async {
  try {
    // Get the current user's id
    String uid = FirebaseAuth.instance.currentUser!.uid;
    var value = double.parse(amount);
    // Reference of the document we want to update
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .collection('Coins')
        .doc(id);

    // Capture the data within the reference document using a Firebase tranasction
    // Firebase transaction is how we'll update documents
    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(documentReference);
      if (!snapshot.exists) {
        // in the document (which is apparently like a JSON object) we set the
        // a amount data we want to store to a value
        documentReference.set({'amount': value});
        return true;
      }

      // snapshot.data() retrieves all the data inside the document
      // we tell dart that it is a Map so we can then access the 'amount' key
      double newAmount = (snapshot.data() as Map)['amount'] + value;
      transaction.update(documentReference, {'amount': newAmount});
      return true;
    });
    return true;
  } catch (e) {
    return false;
  }
}

Future<bool> removeCoin(String id) async {
  // get current uid of user
  String uid = FirebaseAuth.instance.currentUser!.uid;
  await FirebaseFirestore.instance
      .collection('Users')
      .doc(uid)
      .collection('Coins')
      .doc(id)
      .delete();
  return true;
}
