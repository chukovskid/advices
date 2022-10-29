import 'dart:convert';
import 'package:advices/App/models/service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ServicesContext {
  
  static Future<Service> getService(String seviceId) async {
    CollectionReference services =
        FirebaseFirestore.instance.collection('services');
    final snapshot = await services.doc(seviceId).get();
    var service = Service.fromJson(snapshot.data()!);
    return service;
  }

  static Stream<Iterable<Service>> getAllServices() {
    CollectionReference services =
        FirebaseFirestore.instance.collection('services');
    var filteredServices = services.where("area", isNotEqualTo: 2).snapshots();

    // final snapshots = filteredservices.orderBy('name').snapshots();
    var flutterLaw = filteredServices.map(
        (snapshot) => snapshot.docs.map((doc) => Service.fromJson(doc.data())));
    return flutterLaw;
  }

  static Stream<Iterable<Service>> getAllServicesByArea(int area) {
    CollectionReference services =
        FirebaseFirestore.instance.collection('services');
    var filteredServices = services.where("area", isEqualTo: area).snapshots();

    // final snapshots = filteredservices.orderBy('name').snapshots();
    var flutterLaw = filteredServices.map(
        (snapshot) => snapshot.docs.map((doc) => Service.fromJson(doc.data())));
    return flutterLaw;
  }

  static Future<void> saveServicesForLawyer(String uid, List<Service?> newServices) async {
    CollectionReference services = FirebaseFirestore.instance
        .collection('lawyers')
        .doc(uid)
        .collection("services");

    if (newServices.isNotEmpty) {
      List<String> selectedServicesIds = [];
      for (int i = 0; i < newServices.length; i++) {
        Service selectedService =
            Service.fromJson(jsonDecode(newServices[i].toString()));
        print(selectedService);
        selectedServicesIds.add(selectedService.id);

        // TODO delete the collection before adding the this
        await services.doc(selectedService.id).set({
          "id": selectedService.id,
          "area": selectedService.area,
          "name": selectedService.name,
        });
      }
      print(selectedServicesIds);
      await saveServicesForLawyerAsArray(selectedServicesIds, uid);
    }
  }

  static Future<void> saveServicesForLawyerAsArray(List<String> servicesIds, String uid) async {
    DocumentReference lawyerRef =
        FirebaseFirestore.instance.collection('lawyers').doc(uid);
    await lawyerRef.update({"services": servicesIds});
  }




}
