import 'package:advices/App/models/service.dart';
import 'package:advices/screens/lawAreas/selected_services.dart';
import 'package:advices/assets/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import '../../App/contexts/servicesContext.dart';
import '../../App/services/database.dart';
import '../shared_widgets/BottomBar.dart';
import 'lawyers.dart';

class Laws extends StatefulWidget {
  const Laws({Key? key}) : super(key: key);

  @override
  State<Laws> createState() => _LawsState();
}

class _LawsState extends State<Laws>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  bool mkLanguage = true;
  late AnimationController controller;
  bool openExpats = false;
  bool openContracts = false;
  bool openCompanies = false;

  Color urgentColor = Colors.transparent;
  Color expatsColor = Colors.transparent;
  Color contractsColor = Colors.transparent;
  Color companyColor = Colors.transparent;
  double heightFactorUrgent = 1.8;
  double heightFactorExpats = 1.8;
  double heightFactorContracts = 1.8;
  double heightFactorCompany = 1.8;

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
    // Remove the observer    // WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomBar(
          fabLocation: FloatingActionButtonLocation.endDocked,
          shape: CircularNotchedRectangle(),
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
              colors: backgroundColorLaws,
              stops: [-3, 3],
            ),
          ),
          child: Row(
            // mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              // Expanded(
              //     child: _scrollable(
              //         1, (mkLanguage ? "Итно" : "Urgent"), urgentColor)),
              Flexible(
                  child: _scrollableExpats(
                      2, mkLanguage ? "Иселеници" : "Expats", expatsColor)),
              Flexible(
                  child: _scrollableContracts(3,
                      mkLanguage ? "Договори" : "Contracts", contractsColor)),
              Flexible(
                  child: _scrollableCompany(4,
                      mkLanguage ? "Фирми" : "Business firms", companyColor)),
            ],
          )),
    );
  }

  Widget _scrollable(int area, String name, Color color) {
    return MouseRegion(
      onEnter: (PointerEvent details) {
        setState(() {
          // urgentColor = Color.fromARGB(243, 242, 103, 34);
          heightFactorUrgent = 2.0;
        });
      },
      onExit: (PointerEvent details) {
        setState(() {
          // urgentColor = Color.fromARGB(243, 242, 58, 34);
          heightFactorUrgent = 1.8;
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        curve: Curves.linear,
        color: color,
        child: new SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              AnimatedContainer(
                duration: Duration(seconds: 1),
                curve: Curves.linear,
                height: MediaQuery.of(context).size.height / heightFactorUrgent,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      name,
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                    Text(
                      "______________________",
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    Text(
                      mkLanguage
                          ? "Оваа секција е за во итни случаи. Во наредните 5-15мин. ќе добиете емаил со адвокати кои се достапни во моментот за консултација."
                          : "This section is for calling a lawyer immediately \n instead of arranging a date",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.keyboard_double_arrow_down_outlined,
                size: 30,
                color: Color.fromARGB(255, 255, 255, 255),
              ),
              _cardsList(area),
              // Container(width: double.infinity,height: MediaQuery.of(context).size.height / 1.8 , child: _cardsList(area)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _scrollableExpats(int area, String name, Color color) {
    return MouseRegion(
      onEnter: (PointerEvent details) {
        setState(() {
          // expatsColor = transperentBlackColor;
          heightFactorExpats = 2.0;
        });
      },
      onExit: (PointerEvent details) {
        setState(() {
          // expatsColor = Colors.transparent;
          heightFactorExpats = 1.8;
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 600),
        curve: Curves.linear,
        color: color,
        child: new SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              AnimatedContainer(
                duration: Duration(seconds: 1),
                curve: Curves.linear,
                height: MediaQuery.of(context).size.height / heightFactorExpats,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      name,
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                    Text(
                      "______________________",
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    Text(
                      mkLanguage
                          ? "Сервиси фокусирани за експати на кои им е потребна авокатска консултација или договор"
                          : "Schedule a date with your lawyer \n and get the full service",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.keyboard_double_arrow_down_outlined,
                size: 30,
                color: Color.fromARGB(255, 255, 255, 255),
              ),
              _cardsList(area),
            ],
          ),
        ),
      ),
    );
  }

  Widget _scrollableContracts(int area, String name, Color color) {
    return MouseRegion(
      onEnter: (PointerEvent details) {
        setState(() {
          // contractsColor = transperentBlackColor;
          // contractsColor = Color.fromARGB(255, 124, 159, 169);
          heightFactorContracts = 2.0;
        });
      },
      onExit: (PointerEvent details) {
        setState(() {
          // contractsColor = Colors.transparent;
          heightFactorContracts = 1.8;
        });
      },
      child: AnimatedContainer(
        duration: Duration(seconds: 1),
        curve: Curves.linear,
        color: color,
        child: new SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              AnimatedContainer(
                duration: Duration(seconds: 1),
                curve: Curves.linear,
                height:
                    MediaQuery.of(context).size.height / heightFactorContracts,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      name,
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                    Text(
                      "______________________",
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    Text(
                      mkLanguage
                          ? "Заврши се онлајн"
                          : "Get the contract ready \n next week",
                      textAlign: TextAlign.center,
                      // "Explain your needs in the description part and the lawyer will be more prepared",
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.keyboard_double_arrow_down_outlined,
                size: 30,
                color: Color.fromARGB(255, 255, 255, 255),
              ),
              _cardsList(area),
            ],
          ),
        ),
      ),
    );
  }

  Widget _scrollableCompany(int area, String name, Color color) {
    return MouseRegion(
      onEnter: (PointerEvent details) {
        setState(() {
          // companyColor = transperentBlackColor;
          heightFactorCompany = 2.0;
        });
      },
      onExit: (PointerEvent details) {
        setState(() {
          // companyColor = Colors.transparent;
          heightFactorCompany = 1.8;
        });
      },
      child: AnimatedContainer(
        duration: Duration(seconds: 1),
        curve: Curves.linear,
        color: color,
        child: new SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              AnimatedContainer(
                duration: Duration(seconds: 1),
                curve: Curves.linear,
                height:
                    MediaQuery.of(context).size.height / heightFactorCompany,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      name,
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                    Text(
                      "______________________",
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    Text(
                      mkLanguage
                          ? "Сервиси за отварање, затварање и промени на фирма"
                          : "Explain your problem and let the lawyer advice \n you and fix it together",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.keyboard_double_arrow_down_outlined,
                size: 30,
                color: Color.fromARGB(255, 255, 255, 255),
              ),
              _cardsList(area),
            ],
          ),
        ),
      ),
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
            colors: backgroundColor,
            stops: [-1, 1, 2],
          ),
        ),
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(height: 10),
              Expanded(
                child: MouseRegion(
                  onEnter: (PointerEvent details) {
                    setState(() {
                      expatsColor = transperentBlackColor;
                      heightFactorCompany = 2.0;
                    });
                  },
                  onExit: (PointerEvent details) {
                    setState(() {
                      expatsColor = Colors.transparent;
                      heightFactorCompany = 1.8;
                    });
                  },
                  child: InkWell(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SelectedServices(areaId: 2))),
                    child: Container(
                      width: double.infinity,
                      color: expatsColor,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              mkLanguage ? "Иселеници" : "Expats",
                              style: TextStyle(
                                  fontSize: 25,
                                  color: Color.fromARGB(255, 207, 223, 226)),
                            ),
                            Text(
                              "____________",
                              style: TextStyle(
                                  fontSize: 25,
                                  color: Color.fromARGB(255, 207, 223, 226)),
                            ),
                            Text(
                              mkLanguage
                                  ? "Сервиси фокусирани за иселеници на кои им е потребна авокатска консултација или договор"
                                  : "Company",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Color.fromARGB(255, 207, 223, 226)),
                            ),
                          ]),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: MouseRegion(
                  onEnter: (PointerEvent details) {
                    setState(() {
                      contractsColor = transperentBlackColor;
                      heightFactorCompany = 2.0;
                    });
                  },
                  onExit: (PointerEvent details) {
                    setState(() {
                      contractsColor = Colors.transparent;
                      heightFactorCompany = 1.8;
                    });
                  },
                  child: InkWell(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SelectedServices(areaId: 3))),
                    child: Container(
                      width: double.infinity,
                      color: contractsColor,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              mkLanguage ? "Договори" : "Contracts",
                              style: TextStyle(
                                  fontSize: 25,
                                  color: Color.fromARGB(255, 207, 223, 226)),
                            ),
                            Text(
                              mkLanguage ? "____________" : "Company",
                              style: TextStyle(
                                  fontSize: 25,
                                  color: Color.fromARGB(255, 207, 223, 226)),
                            ),
                            Text(
                              mkLanguage ? "Заврши се онлајн" : "Company",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Color.fromARGB(255, 207, 223, 226)),
                            ),
                          ]),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: MouseRegion(
                  onEnter: (PointerEvent details) {
                    setState(() {
                      companyColor = transperentBlackColor;
                      heightFactorCompany = 2.0;
                    });
                  },
                  onExit: (PointerEvent details) {
                    setState(() {
                      companyColor = Colors.transparent;
                      heightFactorCompany = 1.8;
                    });
                  },
                  child: InkWell(
                    onHover: (value) => {},
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SelectedServices(areaId: 4))),
                    child: Container(
                      width: double.infinity,
                      color: companyColor,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                Text(
                                  mkLanguage ? "Фирми" : "Company",
                                  style: TextStyle(
                                      fontSize: 25,
                                      color:
                                          Color.fromARGB(255, 207, 223, 226)),
                                ),
                                Text(
                                  mkLanguage ? "____________" : "Company",
                                  style: TextStyle(
                                      fontSize: 25,
                                      color:
                                          Color.fromARGB(255, 207, 223, 226)),
                                ),
                                Text(
                                  mkLanguage
                                      ? "Сервиси за отварање, затварање и промени на фирма"
                                      : "Company",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 14,
                                      color:
                                          Color.fromARGB(255, 207, 223, 226)),
                                ),
                              ],
                            )
                          ]),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: MouseRegion(
                  onEnter: (PointerEvent details) {
                    setState(() {
                      urgentColor = transperentBlackColor;
                      heightFactorUrgent = 2.0;
                    });
                  },
                  onExit: (PointerEvent details) {
                    setState(() {
                      urgentColor = Colors.transparent;
                      heightFactorUrgent = 1.8;
                    });
                  },
                  child: InkWell(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SelectedServices(areaId: 1))),
                    child: Container(
                      height: double.maxFinite,
                      width: double.infinity,
                      color: urgentColor, // height: 200,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Text(
                            //   mkLanguage ? "Итно" : "Urgent",
                            //   style: TextStyle(
                            //       fontSize: 25,
                            //       fontWeight: FontWeight.bold,
                            //       color: Colors.white),
                            // ),
                            Text(
                              mkLanguage ? "____________" : "Company",
                              style: TextStyle(
                                  fontSize: 25,
                                  color: Color.fromARGB(255, 207, 223, 226)),
                            ),
                            Text(
                              mkLanguage
                                  ? "Оваа секција е за во итни случаи. Во наредните 5-15мин. ќе добиете емаил со адвокати кои се достапни во моментот за консултација"
                                  : "Company",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Color.fromARGB(255, 207, 223, 226)),
                            ),
                          ]),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget _cardsList(int area) {
    return StreamBuilder<Iterable<Service>>(
      stream: ServicesContext.getAllServicesByArea(area),
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
          return MediaQuery.of(context).size.width < 850.0
              ? GridView.count(
                  scrollDirection: Axis.horizontal,
                  primary: false,
                  padding: const EdgeInsets.all(20),
                  crossAxisSpacing: 1,
                  mainAxisSpacing: 1,
                  crossAxisCount: 1,
                  children: laws.map(_gridCard).toList())
              : Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    ListView(
                        shrinkWrap: true, children: laws.map(_card).toList()),
                  ],
                );
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

  Widget _card(Service service) {
    return Container(
      width: double.infinity,
      height: 140,
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey, width: 0.2)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          PointerInterceptor(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.white,
                radius: 40,
                child: ClipOval(
                  child: Image.network(
                    service.imageUrl.length > 20
                        ? service.imageUrl
                        : 'https://static.vecteezy.com/system/resources/previews/002/205/948/original/gift-box-icon-free-vector.jpg',
                  ),
                ),
              ),
              title: Text(
                mkLanguage
                    ? service.nameMk.toString()
                    : service.name.toString(),
                style: TextStyle(
                    fontSize: 16, color: Color.fromRGBO(3, 34, 41, 1)),
              ),
              // subtitle: const Text(
              //     'Lorem Ipsum is simply dummy text of the printing and typesetting industry.'),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Lawyers(service: service.id)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _gridCard(Service service) {
    const double avatarRadius = 40.0;
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Lawyers(service: service.id)),
      ),
      child: Container(
          padding: const EdgeInsets.all(2),
          color: Colors.transparent,
          child: Column(
            children: [
              CircleAvatar(
                radius: avatarRadius,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: avatarRadius,
                  backgroundImage: NetworkImage(
                    service.imageUrl.length > 20
                        ? service.imageUrl
                        : 'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b6/Image_created_with_a_mobile_phone.png/640px-Image_created_with_a_mobile_phone.png',
                  ),
                ),
              ),
              Flexible(
                  child: Text(
                mkLanguage
                    ? service.nameMk.toString()
                    : service.name.toString(),
                style: TextStyle(color: Colors.white, fontSize: 14),
              ))
            ],
          )),
    );
  }
}
