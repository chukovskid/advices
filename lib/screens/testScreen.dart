import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MessageList extends StatelessWidget {
  MessageList({required this.firestore});
  CollectionReference lawyers =
      FirebaseFirestore.instance.collection("lawyers");

  final FirebaseFirestore firestore;
  var _mySelection;
  var _category;
  var _queryCat;


  @override
  Widget build(BuildContext context) {

    return Text("in progress");
    // ignore: unnecessary_new
    // return new StreamBuilder<Iterable<Law>>(
    //     stream: DatabaseService.getAllLaws(),
    //     builder: (context, snapshot) {
    //       if (!snapshot.hasData) {
    //         return const Center(
    //           child: const CupertinoActivityIndicator(),
    //         );
    //       }
    //       if (snapshot.hasData) {
    //         // var length = snapshot.data!.length;
    //         // Iterable<Law>? ds = snapshot.data;
    //         // _queryCat = snapshot.data!;
    //         return new Container(
    //           padding: EdgeInsets.only(bottom: 16.0),
    //           width: 100 * 0.9, // _screenSize
    //           child: new Row(
    //             children: <Widget>[
    //               new Expanded(
    //                   flex: 2,
    //                   child: new Container(
    //                     padding: EdgeInsets.fromLTRB(12.0, 10.0, 10.0, 10.0),
    //                     child: new Text(
    //                       "Category",
    //                       // style: textStyleBlueBold,
    //                     ),
    //                   )),
    //               new Expanded(
    //                 flex: 4,
    //                 child: new InputDecorator(
    //                   decoration: const InputDecoration(
    //                     //labelText: 'Activity',
    //                     hintText: 'Choose an category',
    //                     hintStyle: TextStyle(
    //                       // color: primaryColor,
    //                       fontSize: 16.0,
    //                       fontFamily: "OpenSans",
    //                       fontWeight: FontWeight.normal,
    //                     ),
    //                   ),
    //                   isEmpty: _category == null,
    //                   child: new DropdownButton(
    //                     value: _category,
    //                     isDense: true,
    //                     onChanged: (String newValue) async {
    //                       // setState(() {
    //                       //   _category = newValue;
    //                       //   dropDown = false;
    //                       //   print(_category);
    //                       // });
    //                     },
    //                     items: snapshot.data!.documents
    //                         .map((DocumentSnapshot document) {
    //                       return new DropdownMenuItem<String>(
    //                           value: document.data.name,
    //                           child: new Container(
    //                             decoration: new BoxDecoration(
    //                                 // color: primaryColor,
    //                                 borderRadius:
    //                                     new BorderRadius.circular(5.0)),
    //                             height: 100.0,
    //                             padding:
    //                                 EdgeInsets.fromLTRB(10.0, 2.0, 10.0, 0.0),
    //                             //color: primaryColor,
    //                             child: new Text(document.data['title'],
    //                                 // style: textStyle
                                    
    //                                 ),
    //                           ));
    //                     }).toList(),
    //                   ),
    //                 ),
    //               ),
    //             ],
    //           ),
    //         );
    //       }
    //     });
 
 
 
  }
}
