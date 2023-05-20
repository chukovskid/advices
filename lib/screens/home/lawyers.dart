import 'dart:math';
import 'package:advices/screens/profile/lawyerProfile.dart';
import 'package:advices/screens/shared_widgets/base_app_bar.dart';
import 'package:advices/assets/utilities/constants.dart';
import 'package:flutter/material.dart';
import '../../App/contexts/lawyersContext.dart';
import '../../App/models/user.dart';
import '../shared_widgets/BottomBar.dart';

const List<String> list = <String>[
  'Сите области',
  'Уставно и управно право',
  'Прекршочно право',
  'Подароци',
  'Распределба на имот',
  "Општо право",
  "Закон за облигациони односи",
  "Меѓународно право",
  "Купо-продажба",
  "Кривично право",
  "Имотно право",
  "Закон за деца и млади",
  "Семејно право",
  "Еднаквост и доверба",
  "Закон за приватизација",
  "Друго",
];

class Lawyers extends StatefulWidget {
  final String service;
  const Lawyers({Key? key, required this.service}) : super(key: key);

  @override
  State<Lawyers> createState() => _LawyersState();
}

class _LawyersState extends State<Lawyers> {
  bool mkLanguage = true;
  List<String> filterOptions = ['Option 1', 'Option 2', 'Option 3'];
  String? selectedFilter = list.first;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(
        redirectToHome: true,
        appBar: AppBar(),
      ),
      bottomNavigationBar: BottomBar(
        fabLocation: FloatingActionButtonLocation.endDocked,
        shape: const CircularNotchedRectangle(),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: backgroundColor,
            stops: [-1, 1, 2],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 5,
                  ),
                  Icon(
                    Icons.filter_alt_rounded,
                    color: darkGreenColor,
                  ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: DropdownButton<String>(
                      value: selectedFilter,
                      icon: const Icon(Icons.arrow_drop_down),
                      iconSize: 24,
                      elevation: 16,
                      style: const TextStyle(color: darkGreenColor),
                      underline: Container(
                        height: 2,
                        color: darkGreenColor,
                      ),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedFilter = newValue;
                        });
                      },
                      items: list.map<DropdownMenuItem<String>>(
                        (String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        },
                      ).toList(),
                    ),
                  ),
                ],
              ),
              _cardsList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _cardsList() {
    return StreamBuilder<Iterable<FlutterUser>>(
      stream: LawyersContext.getFilteredLawyers(widget.service),
      builder: ((context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: Icon(
              Icons.hourglass_bottom,
              color: Colors.white,
              size: 100,
            ),
          );
        }
        if (snapshot.hasData) {
          final users = snapshot.data!;
          return Container(
            margin:
                const EdgeInsets.only(top: 35, left: 30, right: 50, bottom: 10),
            child: MediaQuery.of(context).size.width < 850.0
                ? ListView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10.0,
                      vertical: 50.0,
                    ),
                    shrinkWrap: true,
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
                  ),
          );
        } else {
          return Center(
            child: Icon(
              Icons.hourglass_bottom,
              color: Colors.white,
              size: 100,
            ),
          );
        }
      }),
    );
  }

  Widget _card(FlutterUser fUser) {
    return SizedBox(
      height: 300,
      width: 300,
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => LawyerProfile(fUser.uid, widget.service)),
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
                child: SingleChildScrollView(
                  child: Card(
                    elevation: 0,
                    color: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        ListTile(
                          leading: CircleAvatar(
                            backgroundColor: lightGreenColor,
                            radius: 20,
                            child: fUser.photoURL != null &&
                                    fUser.photoURL.isNotEmpty
                                ? Image.network(fUser.photoURL)
                                : Text(
                                    fUser.name[0].toUpperCase() +  fUser.surname[0].toUpperCase(),
                                    style: TextStyle(color: whiteColor),
                                  ),
                          ),
                          //  ClipOval(
                          //   child: Image.network(
                          //     // fUser.photoURL.length > 20
                          //     //     ? fUser.photoURL
                          //     //     :
                          //     'https://st.depositphotos.com/2069323/2156/i/600/depositphotos_21568785-stock-photo-man-pointing.jpg',
                          //   ),
                          // ),
                          title: Text(
                            "${fUser.displayName}",
                            style: const TextStyle(fontSize: 25),
                          ),
                          subtitle: Row(
                            children: [
                              Text("${fUser.minPriceEuro}€"),
                              const SizedBox(
                                width: 20,
                              ),
                              Icon(
                                Icons.star_half,
                                size: 20,
                                color: const Color.fromARGB(255, 214, 214, 126),
                              ),
                              Text((Random().nextDouble() + 4)
                                  .toString()
                                  .substring(0, 4)),
                            ],
                          ),
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
      ),
    );
  }

  Widget _text(FlutterUser fUser) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        height: 200,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(mkLanguage ? "Кратко био" : "Short bio",
                  style: lawyersCardHeader),
              const SizedBox(height: 12),
              Text("${fUser.description}", style: lawyersCardTextStyle),
              const SizedBox(height: 15),
              Text(mkLanguage ? "Искуство" : "Experience",
                  style: lawyersCardHeader),
              const SizedBox(height: 15),
              Text("${fUser.experience}", style: lawyersCardTextStyle),
            ],
          ),
        ),
      ),
    );
  }
}
