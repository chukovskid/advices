import 'dart:math';

import 'package:advices/screens/profile/lawyerProfile.dart';
import 'package:advices/screens/shared_widgets/base_app_bar.dart';
import 'package:advices/utilities/constants.dart';
import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/database.dart';
import 'authentication/authentication.dart';
import 'shared_widgets/BottomBar.dart';

class Lawyers extends StatefulWidget {
  final String service;
  const Lawyers({Key? key, required this.service}) : super(key: key);

  @override
  State<Lawyers> createState() => _LawyersState();
}

class _LawyersState extends State<Lawyers>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late AnimationController controller;

  @override
  void initState() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(
        appBar: AppBar(),
      ),
      bottomNavigationBar: BottomBar(
        fabLocation: FloatingActionButtonLocation.endDocked,
        shape: CircularNotchedRectangle(),
      ),
      body: Container(
        height: double.maxFinite,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: backgroundColor,
            stops: [-1, 2],
          ),
        ),
        child: _cardsList(),
      ),
    );
  }

  Widget _cardsList() {
    return StreamBuilder<Iterable<FlutterUser>>(
      stream: DatabaseService.getFilteredLawyers(widget.service),
      builder: ((context, snapshot) {
        if (!snapshot.hasData) return Text("loading data ...");
        if (snapshot.hasData) {
          final users = snapshot.data!;
          return Container(
              margin: const EdgeInsets.only(
                  top: 35, left: 30, right: 50, bottom: 10),
              child: MediaQuery.of(context).size.width < 850.0
                  ? ListView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 50.0,
                      ),
                      children: users.map(_card).toList())
                  : GridView.count(
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      crossAxisCount:
                          (MediaQuery.of(context).size.width < 1050.0 ? 3 : 4),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      primary: false,
                      children: users.map(_card).toList(),
                    ));
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
    //   var img = imageBytes != null ? Image.memory(
    //   imageBytes,
    //   fit: BoxFit.cover,
    // ) : Text(errorMsg != null ? errorMsg : "Loading...");
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LawyerProfile(fUser.uid)),
      ),
      child: Card(
        elevation: 30,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              // height: 500,
              child: SingleChildScrollView(
                child: Card(
                  elevation: 0,
                  color: Colors.transparent,
                  // margin: const EdgeInsets.only(
                  //     top: 35, left: 30, right: 10, bottom: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(height: 8),
                      ListTile(
                        leading: ClipOval(
                          child: Image.network(
                            fUser.photoURL.length > 20
                                ? fUser.photoURL
                                : 'https://st.depositphotos.com/2069323/2156/i/600/depositphotos_21568785-stock-photo-man-pointing.jpg',
                          ),
                        ),
                        title: Text(
                          "${fUser.displayName}",
                          style: TextStyle(fontSize: 25),
                        ),
                        subtitle: Row(
                          children: [
                            Text("${fUser.minPriceEuro}€"),
                            SizedBox(
                              width: 20,
                            ),
                            Icon(
                              Icons.star_half,
                              size: 20,
                              color: Color.fromARGB(255, 214, 214, 126),
                            ),
                            Text((Random().nextDouble() + 4)
                                .toString()
                                .substring(0, 4)),
                          ],
                        ),
                        // subtitle: Text("${fUser?.education}"),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      _text(fUser)
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _text(FlutterUser fUser) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Short bio", style: lawyersCardHeader),
          SizedBox(height: 12),
          Text("${fUser.description}", style: lawyersCardTextStyle),
          SizedBox(height: 15),
          Text("Experience", style: lawyersCardHeader),
          SizedBox(height: 15),
          Text("${fUser.experience}", style: lawyersCardTextStyle),
          // SizedBox(height: 15),
          // Text("", style: lawyersCardTextStyle),
          // SizedBox(height: 40),
        ],
      ),
    );
  }
}
