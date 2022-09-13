import 'package:advices/screens/calendar/add_event.dart';
import 'package:advices/screens/call/call.dart';
import 'package:advices/services/database.dart';
import 'package:flutter/material.dart';
import '../models/user.dart';
import '../utilities/constants.dart';
import 'authentication/authentication.dart';

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
                Color.fromRGBO(107, 119, 141, 1),
                Color.fromRGBO(38, 56, 89, 1),
              ],
              stops: [-1, 2],
            ),
          ),
          child: Row(
            children: [
              Flexible(flex: 2, child: _card()),
              Flexible(child: _dateAndPrice())
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

  Widget _dateAndPrice() {
    return SingleChildScrollView(
      child: Card(
          margin:
              const EdgeInsets.only(top: 35, left: 10, right: 10, bottom: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
          child: Table(
            border: TableBorder.all(
                color: Colors.red, borderRadius: BorderRadius.circular(20.0)),
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
                    child: Text(
                      "VISA",
                      style: TextStyle(color: Colors.white),
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
                    child: Text(
                      "VISA",
                      style: TextStyle(color: Colors.white),
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
                    height: 50,
                    child: Center(
                      child: Text("Service"),
                    ),
                  ),
                  Center(
                    child: Text("Service"),
                  ),
                ],
              ),
              TableRow(
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(1, 38, 65, 1),
                ),
                children: <Widget>[
                  Container(
                    height: 50,
                    child: Center(
                      child: Text("Service"),
                    ),
                  ),
                  Center(
                    child: Text("Service"),
                  ),
                ],
              ),
              TableRow(
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(1, 38, 65, 1),
                ),
                children: <Widget>[
                  Container(
                    height: 50,
                    child: Center(
                      child: Text("Service"),
                    ),
                  ),
                  Center(
                    child: Text("Service"),
                  ),
                ],
              ),
            ],
          )),
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

  Widget _calendar() {
    return Align(
      alignment: Alignment.bottomRight,
      child: FloatingActionButton(
        heroTag: "settingsBtn",
        onPressed: () => {
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    content: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(child: AddEventPage(widget.uid)),
                      ],
                    ), 
                  ))

          // showModalBottomSheet<void>(
          //   backgroundColor: Colors.amber,
          //   context: context,
          //   builder: (BuildContext context) {
          //     return Container(
          //         // height: 200,

          //         color: Colors.amber,
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
