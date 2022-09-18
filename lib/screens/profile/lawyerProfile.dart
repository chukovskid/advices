import 'package:advices/screens/calendar/add_event.dart';
import 'package:advices/screens/call/call.dart';
import 'package:advices/screens/profile/createEvent.dart';
import 'package:advices/services/database.dart';
import 'package:flutter/material.dart';
import '../../models/user.dart';
import '../../utilities/constants.dart';
import '../authentication/authentication.dart';
import '../call/calls.dart';

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
                Color.fromARGB(255, 214, 223, 243),
                Color.fromARGB(255, 187, 199, 222),
              ],
              stops: [-1, 2],
            ),
          ),
          child: Row(
            children: [
              Flexible(flex: 2, child: _card()),
              // Flexible(child: _dateAndPrice())
              Flexible(child: CreateEvent(widget.uid))
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

  Widget _dateAndPrice() {
    return SingleChildScrollView(
        child: Card(
      shadowColor: Color(0xff5bc9bf),
      elevation: 10.0,
      color: Color.fromRGBO(1, 38, 65, 1),
      margin: const EdgeInsets.only(top: 35, left: 30, right: 50, bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25.0),
      ),
      child: Column(
        children: [
          Table(
            columnWidths: const <int, TableColumnWidth>{
              // 0: IntrinsicColumnWidth(),
              0: FlexColumnWidth(),
              1: FlexColumnWidth(),
              // 2: FixedColumnWidth(154),
            },
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: <TableRow>[
              TableRow(
                decoration: BoxDecoration(
                  color: Color.fromRGBO(1, 38, 65, 1),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                ),
                children: <Widget>[
                  Container(
                    height: 100,
                    child: Center(
                      child: Text(
                        "Service",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ),
                  // TableCell(
                  //   verticalAlignment: TableCellVerticalAlignment.top,
                  //   child: Container(
                  //     height: 32,
                  //     width: 32,
                  //     color: Colors.red,
                  //   ),
                  // ),
                  Center(
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.white)),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  content: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Flexible(child: AddEventPage(widget.uid)),
                                    ],
                                  ),
                                ));
                      },
                      child: Text(
                        "VISA",
                        style: TextStyle(
                            color: Color.fromRGBO(1, 38, 65, 1),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
              TableRow(
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(1, 38, 65, 1),
                ),
                children: <Widget>[
                  Container(
                    height: 100,
                    child: Center(
                      child: Text(
                        "Select a date",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ),
                  Center(
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.white)),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  content: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Flexible(child: AddEventPage(widget.uid)),
                                    ],
                                  ),
                                ));
                      },
                      child: Text(
                        "23.11.2022 13:00",
                        style: TextStyle(
                            color: Color.fromRGBO(1, 38, 65, 1),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
              TableRow(
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(1, 38, 65, 1),
                ),
                children: <Widget>[
                  Container(
                    height: 100,
                    child: Center(
                      child: Text(
                        "+2 days urgency",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      "",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 35,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              TableRow(
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(1, 38, 65, 1),
                ),
                children: <Widget>[
                  Container(
                    height: 100,
                    child: Center(
                      child: Text(
                        "Total",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      "30 €",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 35,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 60,
          ),
          ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Color(0xff5bc9bf))),
            onPressed: () {},
            child: Text(
              "Submit",
              style: TextStyle(
                  color: Color.fromRGBO(1, 38, 65, 1),
                  fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 20,
          )
        ],
      ),
    ));
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
