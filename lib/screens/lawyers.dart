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
                          (MediaQuery.of(context).size.width < 950.0 ? 3 : 6),
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.white,
                radius: 60,
                child: ClipOval(
                  child: Image.network(
                    fUser.photoURL.length > 20
                        ? fUser.photoURL
                        : 'https://st.depositphotos.com/2069323/2156/i/600/depositphotos_21568785-stock-photo-man-pointing.jpg',
                  ),
                ),
              ),

              // const Icon(
              //   Icons.person,
              //   size: 60,
              // ),
              title: Text(fUser.displayName.toString()),
              subtitle:
                  const Text('Music by Julie Gable. Lyrics by Sidney Stein.'),
            ),
            const SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}
