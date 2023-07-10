import 'dart:convert';
import 'dart:io';

import 'package:advices/App/models/event.dart';
import 'package:advices/App/models/service.dart';
import 'package:advices/App/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/rendering.dart';

import '../models/call.dart';

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
        // await services.doc(selectedService.id).set({
        //   "id": selectedService.id,
        //   "area": selectedService.area,
        //   "name": selectedService.name,
        // });
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

  static Stream<Iterable<FlutterUser>> getFilteredLawyers(String lawId) {
    CollectionReference lawyers =
        FirebaseFirestore.instance.collection("lawyers");
    // var filteredLawyers = lawyers.where("services", arrayContains: lawId);
    // var filteredLawyers = lawyers.where("public", isEqualTo: true);
    var filteredLawyers = lawyers;
    final snapshots = filteredLawyers.snapshots();
    var flutterUsers = snapshots.map((snapshot) =>
        snapshot.docs.map((doc) => FlutterUser.fromJson(doc.data())));
    return flutterUsers;
  }

}
