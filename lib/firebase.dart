import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore get firestore => FirebaseFirestore.instance;

CollectionReference<Map<String, dynamic>> jobs = FirebaseFirestore.instance.collection('Jobs');
CollectionReference<Map<String,dynamic>> archivedJobs=FirebaseFirestore.instance.collection('archivedJobs');
CollectionReference<Map<String,dynamic>>customers=firestore.collection('Customers');
CollectionReference<Map<String, dynamic>> profiles = FirebaseFirestore.instance.collection('Profile');
DocumentReference<Map<String, dynamic>> get myProfile => profiles.doc('id');
DocumentReference<Map<String, dynamic>> counters = FirebaseFirestore.instance.collection('Dashboard').doc('Counters');

Future<int> getNextJobId() {
  int jobid = 0;
  return FirebaseFirestore.instance.runTransaction((transaction) async {
    await transaction.get(counters).then((snapshot) {
      var map = snapshot.data();
      jobid = (map?['job'] ?? 0) + 1;
    });
    transaction.update(counters, {'job': jobid});
    return transaction;
  }).then((value) => jobid);
}
