import 'package:advices/screens/calendar/add_event.dart';
import 'package:advices/screens/call/call.dart';
import 'package:advices/screens/profile/createEvent.dart';
import 'package:advices/services/database.dart';
import 'package:flutter/material.dart';
import '../../models/user.dart';
import '../../utilities/constants.dart';
import '../authentication/authentication.dart';
import '../call/calls.dart';
import '../shared_widgets/base_app_bar.dart';

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
    if (lawyer != null) {
      setState(() {
        lawyer = lawyer;
        imageUrl = (lawyer!.photoURL.isEmpty ? imageUrl : lawyer!.photoURL);
      });
    }
  }

  _redirectToCall() async {
    if (lawyer != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Call(widget.uid)),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(appBar: AppBar(),),

       bottomSheet: Container(
            child:  MediaQuery.of(context).size.width < 850.0 ? CreateEvent(widget.uid): SizedBox() ,
        ),
      // floatingActionButton: _openProfileBtn(),
      body: Container(
          height: double.maxFinite,
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.fromARGB(255, 214, 223, 243),
                Color.fromARGB(255, 187, 199, 222),
              ],
              stops: [-1, 2],
            ),
          ),
          child: Row(
            children: [
              Flexible(flex: 3, child: _card()),
              // Flexible(child: _dateAndPrice())
              MediaQuery.of(context).size.width < 850.0 ? SizedBox(): Flexible(flex: 2, child: CreateEvent(widget.uid)),
            ],
          )),
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
        ),
        Expanded(
          flex: 1,
          child: Stack(
            children: [_calendar()],
          ),
        )
      ],
    );
  }

  Widget _card() {
    return Container(
      height: 800,
      child: SingleChildScrollView(
        child: Card(
          elevation: 0,
          color: Colors.transparent,
          margin:
              const EdgeInsets.only(top: 35, left: 30, right: 10, bottom: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 30),
              ListTile(
                leading: Icon(
                  Icons.person,
                  size: 100.0,
                ),
                title: Text(
                  "${lawyer?.displayName}",
                  style: TextStyle(fontSize: 35),
                ),
                subtitle: Text("${lawyer?.education}"),
              ),
              const SizedBox(
                height: 30,
              ),
              SizedBox(
                height: 15,
              ),
              _text()
            ],
          ),
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
          Text("Кратко био", style: profileHeader),
          SizedBox(height: 15),
          Text("${lawyer?.description}", style: helpTextStyle),
          SizedBox(height: 15),
          Text("Уште нешто", style: profileHeader),
          SizedBox(height: 15),
          Text("${lawyer?.experience}", style: helpTextStyle),
          SizedBox(height: 15),
          Text("", style: helpTextStyle),
          SizedBox(height: 40),

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

  Widget _calendar() {
    return Align(
      alignment: Alignment.bottomRight,
      child: FloatingActionButton(
        heroTag: "settingsBtn",
        onPressed: () => {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Calls()),
      )

          // showDialog(
          //     context: context,
          //     builder: (context) => AlertDialog(
          //           content: Column(
          //             mainAxisAlignment: MainAxisAlignment.center,
          //             children: [
          //               Flexible(child: AddEventPage(widget.uid)),
          //             ],
          //           ),
          //         ))

          // // showModalBottomSheet<void>(
          // //   backgroundColor: Colors.amber,
          // //   context: context,
          // //   builder: (BuildContext context) {
          // //     return Container(
          // //         // height: 200,

          // //         color: Colors.amber,
          //         child: AddEventPage());
          //   },
          // )
        },
        backgroundColor: Color.fromARGB(255, 226, 105, 105),
        elevation: 0,
        child: const Icon(Icons.calendar_month),
      ),
    );
  }
}
