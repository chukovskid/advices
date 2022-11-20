import 'package:advices/App/contexts/lawyersContext.dart';
import 'package:advices/screens/calendar/add_event.dart';
import 'package:advices/screens/call/call.dart';
import 'package:advices/screens/profile/createEvent.dart';
import 'package:advices/App/services/database.dart';
import 'package:flutter/material.dart';
import '../../App/models/user.dart';
import '../../assets/utilities/constants.dart';
import '../authentication/authentication.dart';
import '../call/calls.dart';
import '../shared_widgets/base_app_bar.dart';

class LawyerProfile extends StatefulWidget {
  final String uid;
  final String serviceId;

  const LawyerProfile(this.uid, this.serviceId, {Key? key}) : super(key: key);

  @override
  State<LawyerProfile> createState() => _LawyerProfileState();
}

class _LawyerProfileState extends State<LawyerProfile> {
  bool mkLanguage = true;
  FlutterUser? lawyer;
  String minPriceEuro = "30";

  var imageUrl =
      "https://devshift.biz/wp-content/uploads/2017/04/profile-icon-png-898.png"; //you can use a image

  @override
  void initState() {
    _getLawyer();
    super.initState();
  }

  Future<void> _getLawyer() async {
    lawyer = await LawyersContext.getLawyer(widget.uid);
    if (lawyer != null) {
      setState(() {
        minPriceEuro = lawyer!.minPriceEuro.toString().isEmpty
            ? minPriceEuro
            : lawyer!.minPriceEuro.toString();
        lawyer = lawyer;
        imageUrl = lawyer!.photoURL.isEmpty ? imageUrl : lawyer!.photoURL;
      });
    }
  }

  Widget? returnCreateEventWidget() {
    _getLawyer();
    return CreateEvent(widget.uid, widget.serviceId, minPriceEuro);
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
      appBar: BaseAppBar(
        appBar: AppBar(),
      ),

      bottomSheet: Container(
        child: MediaQuery.of(context).size.width < 850.0
            ? CreateEvent(widget.uid, widget.serviceId, minPriceEuro)
            : SizedBox(),
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
              MediaQuery.of(context).size.width < 850.0
                  ? SizedBox()
                  : Flexible(
                      flex: 2,
                      child: CreateEvent(
                          widget.uid, widget.serviceId, minPriceEuro)),
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
      height: 900,
      child: 
      SingleChildScrollView(
        child: Card(
          elevation: 0,
          color: Colors.transparent,
          margin:
              const EdgeInsets.only(top: 35, left: 30, right: 10, bottom: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: 
          
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 30),
              Row(
                children: [
                  ClipOval(
                    child: Image.network(
                        (lawyer?.photoURL != null && lawyer!.photoURL.isNotEmpty)
                            ? lawyer!.photoURL
                            : 'https://st.depositphotos.com/2069323/2156/i/600/depositphotos_21568785-stock-photo-man-pointing.jpg',
                        // scale: 1,
                        cacheWidth: 1,
                        width: 100,
                        height: 100),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${lawyer?.displayName}",
                        style: TextStyle(fontSize: 35),
                      ),
                      Text("${lawyer?.email}"),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 45,
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
          Text(mkLanguage ? "Кратко био" :"Short bio", style: profileHeader),
          SizedBox(height: 15),
          Text("${lawyer?.description}", style: helpTextStyle),
          SizedBox(height: 15),
          Text(mkLanguage ? "Искуство" :"Experience", style: profileHeader),
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
