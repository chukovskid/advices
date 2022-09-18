import 'package:advices/models/law.dart';
import 'package:advices/screens/call/call.dart';
import 'package:advices/screens/profile/lawyerProfile.dart';
import 'package:advices/screens/lawyers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

import '../models/user.dart';
import '../services/database.dart';
import 'authentication/authentication.dart';
import 'floating_footer_btns.dart';

class Laws extends StatefulWidget {
  const Laws({Key? key}) : super(key: key);

  @override
  State<Laws> createState() => _LawsState();
}

class _LawsState extends State<Laws>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late AnimationController controller;
  bool openExpats = false;
  bool openContracts = false;
  bool openCompanies = false;

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    controller.repeat(reverse: true);
    super.initState();
    // WidgetsBinding.instance!.removeObserver(this);
  }

  @override
  void dispose() {
    // Remove the observer
    // WidgetsBinding.instance!.removeObserver(this);

    super.dispose();
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
          backgroundColor: Color.fromARGB(255, 255, 255, 255),
          elevation: 0.0,
          actions: <Widget>[
            FlatButton.icon(
              textColor: Color.fromARGB(255, 70, 52, 52),
              icon: Icon(Icons.person_outline_sharp),
              label: Text(''),
              onPressed: _navigateToAuth,
            ),
          ],
        ),
        body: MediaQuery.of(context).size.width < 850.0
            ? _mobileView()
            : _webView());
  }

  Widget _webView() {
    return PointerInterceptor(
      intercepting: true,
      child: Container(
          height: double.maxFinite,
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.fromARGB(255, 255, 255, 255),
                Color.fromARGB(255, 255, 255, 255),
              ],
              stops: [-1, 2],
            ),
          ),
          child: Column(
            children: [
              // Container(
              //     alignment: Alignment.topLeft,
              //     child: Text(
              //       "  First get the advice then pay the advice",
              //       style: TextStyle(fontSize: 25, fontFamily: 'Hindi'),
              //     )),
              //     SizedBox(height: 30,),
              Flexible(
                child: Row(
                  children: <Widget>[
                    Flexible(child: _cardsList()),
                    Flexible(child: _cardsList()),
                    Flexible(child: _cardsList()),
                    // Flexible(
                    //   flex: 2,
                    //   child: Container(
                    //     color: Color.fromRGBO(3, 34, 41, 1),
                    //     child: Center(
                    //         child: Container(
                    //             decoration: BoxDecoration(
                    //                 border: Border.all(
                    //                     color: Color.fromRGBO(185, 195, 115, 1))),
                    //             child: SizedBox(
                    //               height: 400,
                    //               width: 500,
                    //             ))),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ],
          )),
    );
  }

  Widget _mobileView() {
    return Container(
        height: double.maxFinite,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 255, 255, 255),
              Color.fromARGB(255, 255, 255, 255),
            ],
            stops: [-1, 2],
          ),
        ),
        child: Column(
          children: [
            ListTile(
                leading: Icon(
                  openExpats
                      ? Icons.keyboard_arrow_down
                      : Icons.keyboard_arrow_right,
                  color: Color.fromRGBO(3, 34, 41, 1),
                ),
                title: Text(
                  "Expats",
                  style: TextStyle(
                      fontSize: 25, color: Color.fromRGBO(3, 34, 41, 1)),
                ),
                subtitle: const Text(''),
                onTap: () => {
                      setState(() {
                        openExpats = !openExpats;
                      })
                    }),
            Flexible(child: openExpats ? _cardsList() : SizedBox()),
            SizedBox(height: 10),
            ListTile(
                leading: Icon(
                  openContracts
                      ? Icons.keyboard_arrow_down
                      : Icons.keyboard_arrow_right,
                  color: Color.fromRGBO(3, 34, 41, 1),
                ),
                title: Text(
                  "Contracts",
                  style: TextStyle(
                      fontSize: 25, color: Color.fromRGBO(3, 34, 41, 1)),
                ),
                subtitle: const Text(''),
                onTap: () => {
                      setState(() {
                        openContracts = !openContracts;
                      })
                    }),
            Flexible(child: openContracts ? _cardsList() : SizedBox()),
            SizedBox(height: 10),
            ListTile(
                leading: Icon(
                  openCompanies
                      ? Icons.keyboard_arrow_down
                      : Icons.keyboard_arrow_right,
                  color: Color.fromRGBO(3, 34, 41, 1),
                ),
                title: Text(
                  "Companies",
                  style: TextStyle(
                      fontSize: 25, color: Color.fromRGBO(3, 34, 41, 1)),
                ),
                subtitle: const Text(''),
                onTap: () => {
                      setState(() {
                        openCompanies = !openCompanies;
                      })
                    }),
            Flexible(child: openCompanies ? _cardsList() : SizedBox()),
          ],
        ));
  }

  Widget _cardsList() {
    return StreamBuilder<Iterable<Law>>(
      stream: DatabaseService.getAllLaws(),
      builder: ((context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              value: controller.value,
              valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
              semanticsLabel: 'Linear progress indicator',
            ),
          );
        }
        if (snapshot.hasData) {
          final laws = snapshot.data!;
          return Column(
            children: [
              Flexible(
                child: ListView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10.0,
                      vertical: 10.0,
                    ),
                    children: laws.map(_card).toList()),
              ),
            ],
          );
          // return GridView.extent(
          //     padding: const EdgeInsets.symmetric(
          //       horizontal: 10.0,
          //       vertical: 40.0,
          //     ),
          //     maxCrossAxisExtent: 250.0,
          //     mainAxisSpacing: 10.0,
          //     children: laws.map(_card).toList());
        } else {
          return Center(
            child: CircularProgressIndicator(
              value: controller.value,
              valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
              semanticsLabel: 'Linear progress indicator',
            ),
          );
        }
      }),
    );
  }

  Widget _card(Law law) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          PointerInterceptor(
            child: ListTile(
              leading: const Icon(
                Icons.account_balance_outlined,
                color: Color.fromRGBO(3, 34, 41, 1),
              ),
              title: Text(
                law.name.toString(),
                style: TextStyle(
                    fontSize: 17, color: Color.fromRGBO(3, 34, 41, 1)),
              ),
              subtitle: const Text(''),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Lawyers(lawArea: law.id)),
              ),
            ),
          ),
          const SizedBox(
              // height: 10,
              )
        ],
      ),
    );
  }
}
