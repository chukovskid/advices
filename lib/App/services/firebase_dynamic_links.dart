import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../models/service.dart';

FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

class FirebaseDynamicLinkService {



  
  static Future<String> createDynamicLink(bool short) async {
    String _linkMessage;
    // final DynamicLinkParameters parameters = DynamicLinkParameters(
    //   uriPrefix: 'https://advices.page.link',
    //   link: Uri.parse('https://advices.web.app/#/register?id=123321'),
    //   androidParameters: AndroidParameters(
    //     packageName: 'com.chukovski.advices',
    //     minimumVersion: 125,
    //   ),
    // );

    String? url;
    if (short) {
      final String? shortLink = await buildDynamicLinks("123_ID");
      // final ShortDynamicLink shortLink = await parameters.buildShortLink();
      url = shortLink;
      print("/// SHORT LINK // $shortLink ");
      // url = Uri.encodeFull(shortLink);
    } else {
      // url = await parameters.link.();
      final String? shortLink = await buildDynamicLinks("123_ID");
      url = shortLink;
      print("//ELSE/ SHORT LINK // $shortLink ");
    }
    _linkMessage = url.toString();
    return _linkMessage;
  }

  static Future<String>? buildDynamicLinks(String theID) async {
    var urlToReturn;
    final String postUrl =
        'https://firebasedynamiclinks.googleapis.com/v1/shortLinks?key='+ dotenv.env['GOOGLE_API_KEY'].toString();
    String theUrl =
        "https://advices.page.link/?link=https://advices.web.app/lawyers/123/&apn=com.chukovski.advices&isi=125&ibi=com.chukovski.advices&imv=1.0.1&lid=lawyerID123";
        // "https://advices.web.app/#/register/?isi=125&ibi=com.chukovski.advices&imv=1.0.1&apn=com.chukovski.advices&lawyerId=$theID";
    await http.post(Uri.tryParse(postUrl)!, body: {
      'longDynamicLink': theUrl,
    }).then(
      (http.Response response) {
        final int statusCode = response.statusCode;
        if (statusCode < 200 || statusCode > 400 || response == null) {
          throw new Exception("Error while fetching data");
        }
        var decoded = json.decode(response.body);
        urlToReturn = decoded['shortLink'];
        return decoded['shortLink'];
      },
    ).catchError((e) => debugPrint('error $e'));
    return urlToReturn;
  }




  // static Future<void> initDynamicLink(BuildContext context) async {
  //   FirebaseDynamicLinks.instance.onLink(
  //       onSuccess: (PendingDynamicLinkData dynamicLink) async {
  //     final Uri deepLink = dynamicLink.link;

  //     var isStory = deepLink.pathSegments.contains('storyData');
  //     // TODO :Modify Accordingly
  //     if (isStory) {
  //       String id = deepLink.queryParameters['id'];
  //       // TODO :Modify Accordingly

  //       if (deepLink != null) {
  //         // TODO : Navigate to your pages accordingly here

  //         // try{
  //         //   await firebaseFirestore.collection('Stories').doc(id).get()
  //         //       .then((snapshot) {
  //         //         StoryData storyData = StoryData.fromSnapshot(snapshot);
  //         //
  //         //         return Navigator.push(context, MaterialPageRoute(builder: (context) =>
  //         //           StoryPage(story: storyData,)
  //         //         ));
  //         //   });
  //         // }catch(e){
  //         //   print(e);
  //         // }
  //       } else {
  //         return null;
  //       }
  //     }
  //   }, onError: (OnLinkErrorException e) async {
  //     print('link error');
  //   });

  //   final PendingDynamicLinkData data =
  //       await FirebaseDynamicLinks.instance.getInitialLink();
  //   try {
  //     final Uri deepLink = data.link;
  //     var isStory = deepLink.pathSegments.contains('storyData');
  //     if (isStory) {
  //       // TODO :Modify Accordingly
  //       String id = deepLink.queryParameters['id']; // TODO :Modify Accordingly

  //       // TODO : Navigate to your pages accordingly here

  //       // try{
  //       //   await firebaseFirestore.collection('Stories').doc(id).get()
  //       //       .then((snapshot) {
  //       //     StoryData storyData = StoryData.fromSnapshot(snapshot);
  //       //
  //       //     return Navigator.push(context, MaterialPageRoute(builder: (context) =>
  //       //         StoryPage(story: storyData,)
  //       //     ));
  //       //   });
  //       // }catch(e){
  //       //   print(e);
  //       // }
  //     }
  //   } catch (e) {
  //     print('No deepLink found');
  //   }
  // }
}
