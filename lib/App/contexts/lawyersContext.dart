import 'package:advices/App/models/service.dart';
import 'package:advices/App/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LawyersContext {
  static Future<FlutterUser?> getLawyer(String lawyerId) async {
    CollectionReference users =
        FirebaseFirestore.instance.collection('lawyers');
    final snapshot = await users.doc(lawyerId).get();
    // if (snapshot.exists) {
    var flutterUser = await FlutterUser.fromJson(snapshot.data()!);
    return flutterUser;
    // }
    // return null;
  }

  static Future<void> saveServicesForLawyerAsArray(
      List<String> servicesIds, String uid) async {
    DocumentReference lawyerRef =
        FirebaseFirestore.instance.collection('lawyers').doc(uid);
    await lawyerRef.update({"services": servicesIds});
  }

  static Stream<Iterable<FlutterUser>> getFilteredLawyers(String lawId) {
    CollectionReference lawyers =
        FirebaseFirestore.instance.collection("lawyers");
    print("lawId: $lawId");
    var filteredLawyers = lawyers.where("public", isNotEqualTo: false);
    filteredLawyers = lawId == "allFields"
        ? filteredLawyers
        : filteredLawyers.where("services", arrayContains: lawId);
    final snapshots = filteredLawyers.snapshots();
    var flutterUsers = snapshots.map((snapshot) =>
        snapshot.docs.map((doc) => FlutterUser.fromJson(doc.data())));
    return flutterUsers;
  }

  static Future<List<Service>> getServicesForLawyer(String uid) async {
    List<Service> servicesList = [];
    CollectionReference services = FirebaseFirestore.instance
        .collection('lawyers')
        .doc(uid)
        .collection("services");

    QuerySnapshot snapshot = await services.get();
    for (QueryDocumentSnapshot document in snapshot.docs) {
      Service service =
          Service.fromJson(document.data() as Map<String, dynamic>);
      servicesList.add(service);
    }
    return servicesList;
  }
}
