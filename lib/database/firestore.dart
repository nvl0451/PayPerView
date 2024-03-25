import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreDatabase {
  User? user = FirebaseAuth.instance.currentUser;

  final CollectionReference events =
      FirebaseFirestore.instance.collection('events');
  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');

  Future<void> addEvent(String eventName, int eventPrice) {
    return events.doc(eventName).set({
      'adminID': user!.uid,
      'adminEmail': user!.email,
      'eventName': eventName,
      'eventPrice': eventPrice,
      'buyers': ['sample_buyer'],
      'timestamp': Timestamp.now()
    });
  }

  Future<void> buyEvent(
      QueryDocumentSnapshot<Object?> event, String? buyerEmail) async {
    if (buyerEmail == null) {
      return;
    }

    String eventID = event.reference.id;
    String eventAdmin = event['adminEmail'];
    String adminID = event['adminID'];
    int eventPrice = event['eventPrice'];

    await users
        .doc(eventAdmin)
        .update({'balance': FieldValue.increment(eventPrice)});

    await events.doc(eventID).update({
      'buyers': FieldValue.arrayUnion([buyerEmail])
    });
  }

  Stream<QuerySnapshot> getEventsStream() {
    final eventsStream = FirebaseFirestore.instance
        .collection('events')
        .orderBy('timestamp', descending: true)
        .snapshots();

    return eventsStream;
  }
}
