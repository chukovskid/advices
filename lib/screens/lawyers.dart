import 'package:advices/screens/lawyerProfile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/user.dart';
import '../services/database.dart';
import 'authentication/authentication.dart';
import 'floating_footer_btns.dart';

class Lawyers extends StatefulWidget {
 final String lawArea;
  const Lawyers({Key? key, required this.lawArea}) : super(key: key);

  @override
  State<Lawyers> createState() => _LawyersState();
}

class _LawyersState extends State<Lawyers>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late AnimationController controller;

  @override
  void initState() {
    // controller = AnimationController(
    //   vsync: this,
    //   duration: const Duration(seconds: 2),
    // );
    // controller.repeat(reverse: true);
    //     super.initState();
    // WidgetsBinding.instance!.removeObserver(this);


  }

  // @override
  // void dispose() {
  //   // Remove the observer
  //   WidgetsBinding.instance!.removeObserver(this);

  //   super.dispose();
  // }

  // _navigateToLawyers() {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(builder: (context) => Lawyers()),
  //   );
  // }

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
        child: _cardsList(),
      ),
    );
  }

  Widget _cardsList() {
    return StreamBuilder<Iterable<FlutterUser>>(
      stream: DatabaseService.getFilteredLawyers(widget.lawArea),
      builder: ((context, snapshot) {
        if (!snapshot.hasData) return Text("loading data ...");
        if (snapshot.hasData) {
          final users = snapshot.data!;
          return ListView(
              padding: const EdgeInsets.symmetric(
                horizontal: 10.0,
                vertical: 40.0,
              ),
              children: users.map(_card).toList());
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

  Widget _card(FlutterUser fUser) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: const Icon(Icons.person),
            title: Text(fUser.displayName.toString()),
            subtitle:
                const Text('Music by Julie Gable. Lyrics by Sidney Stein.'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LawyerProfile(fUser.uid)),
            ),
          ),
          const SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }
}
