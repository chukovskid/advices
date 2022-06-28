import 'package:advices/config/agora.config.dart';
import 'package:advices/screens/call/call.dart';
import 'package:advices/screens/selectDateTime.dart';
import 'package:advices/services/database.dart';
import 'package:flutter/material.dart';
import 'package:advices/screens/laws.dart';
import '../models/user.dart';
import '../utilities/constants.dart';
import 'authentication/authentication.dart';
import 'floating_footer_btns.dart';

class LawyerProfile extends StatefulWidget {
  final String uid;

  const LawyerProfile(this.uid, {Key? key}) : super(key: key);

  @override
  State<LawyerProfile> createState() => _LawyerProfileState();
}

class _LawyerProfileState extends State<LawyerProfile> {
  FlutterUser? lawyer;
  var imageUrl =
      "https://devshift.biz/wp-content/uploads/2017/04/profile-icon-png-898.png"; //you can use a image

  @override
  void initState() {
    _getLawyer();
  }

  Future<void> _getLawyer() async {
    lawyer = await DatabaseService.getLawyer(widget.uid);
    print(lawyer?.displayName);

    //  FlutterUser? user = await _auth.getMyProfileInfo();
    print(lawyer?.education);
    if (lawyer != null) {
      setState(() {
        lawyer = lawyer;
        imageUrl = (lawyer!.photoURL.isEmpty ? imageUrl : lawyer!.photoURL);
      });
    }
  }

  _redirectToCall() async{
    if (lawyer != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Call(widget.uid)),
      );
    } 
  }

  _navigateToAuth() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Authenticate()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(23, 34, 59, 1),
        elevation: 0.0,
        actions: <Widget>[
          FlatButton.icon(
            textColor: Colors.white,
            icon: Icon(Icons.person_outline_sharp),
            label: Text(''),
            onPressed: _navigateToAuth,
          ),
        ],
      ),
      floatingActionButton: _openProfileBtn(),
      body: Container(
        height: double.maxFinite,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromRGBO(107, 119, 141, 1),
              Color.fromRGBO(38, 56, 89, 1),
            ],
            stops: [-1, 2],
          ),
        ),
        child: _card(),
      ),
    );
  }

  Widget _openProfileBtn() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          flex: 10,
          child: Stack(
            children: [_next()],
          ),
        )
      ],
    );
  }

  // Widget _lawyerProfile() {
  //   return StreamBuilder<FlutterUser>(
  //     stream: DatabaseService.getUser(widget.uid),
  //     builder: ((context, snapshot) {
  //       if (!snapshot.hasData) return Text("loading data ...");
  //       if (snapshot.hasData) {
  //         final firebaseUser = snapshot.data!;
  //         return Text(firebaseUser.displayName);
  //       } else {
  //         _navigateToAuth();
  //         return Text("something wrong");
  //       }
  //     }),
  //   );
  // }

  Widget _card() {
    return SingleChildScrollView(
      child: Card(
        margin: const EdgeInsets.only(top: 35, left: 10, right: 10, bottom: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const SizedBox(height: 30),
            ListTile(
              leading: Icon(Icons.person),
              title: Text("${lawyer?.displayName}"),
              subtitle: Text("${lawyer?.education}"),
            ),
            const SizedBox(
              height: 30,
            ),
            _text()
          ],
        ),
      ),
    );
  }

  Widget _text() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Кратко био", style: helpTextStyle),
          Text("${lawyer?.description}", style: helpTextStyle),
          Text("Уште нешто", style: helpTextStyle),
          Text("${lawyer?.experience}", style: helpTextStyle),
          Text("", style: helpTextStyle),
        ],
      ),
    );
  }

  Widget _next() {
    return Align(
      alignment: Alignment.bottomRight,
      child: FloatingActionButton(
        heroTag: "settingsBtn",
        onPressed: () => {_redirectToCall()},
        backgroundColor: Color.fromARGB(255, 226, 105, 105),
        elevation: 0,
        child: const Icon(Icons.keyboard_arrow_right_sharp),
      ),
    );
  }

  
}
