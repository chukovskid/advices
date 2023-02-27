import 'package:advices/assets/utilities/constants.dart';
import 'package:advices/screens/services/book_advice.dart';
import 'package:advices/screens/webView/IframeScreen.dart';
import 'package:flutter/material.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({Key? key}) : super(key: key);

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget>
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
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(
                  child: _urgent(
                      1,
                      (mkLanguage ? "Итни консултации" : "Urgent"),
                      urgentColor)),
              Expanded(
                  child: _advices(
                      2, mkLanguage ? "Консултации" : "Expats", expatsColor)),
              Expanded(
                  child: _contracts(
                      3,
                      mkLanguage ? "Договори/Преддоговори" : "Contracts",
                      contractsColor)),
            ],
          )),
    );
  }

  Widget _urgent(int area, String name, Color color) {
    return InkWell(
      onTap: () => Navigator.push(
          context, MaterialPageRoute(builder: (context) => BookAdvice())),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (PointerEvent details) {
          setState(() {
            urgentColor = Color.fromARGB(45, 26, 40, 23);
            heightFactorUrgent = 1.0;
          });
        },
        onExit: (PointerEvent details) {
          setState(() {
            urgentColor = Color.fromARGB(0, 242, 103, 34);
            heightFactorUrgent = 1.0;
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
                  height:
                      MediaQuery.of(context).size.height / heightFactorUrgent,
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _advices(int area, String name, Color color) {
    return InkWell(
      onTap: () => Navigator.push(
          context, MaterialPageRoute(builder: (context) => BookAdvice())),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (PointerEvent details) {
          setState(() {
            expatsColor = Color.fromARGB(45, 26, 40, 23);
            heightFactorExpats = 1;
          });
        },
        onExit: (PointerEvent details) {
          setState(() {
            expatsColor = Colors.transparent;
            heightFactorExpats = 1;
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
                  height:
                      MediaQuery.of(context).size.height / heightFactorExpats,
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
                            ? "Закажете состанок со адвокат и добијте совет/консултаација"
                            : "Schedule a date with your lawyer \n and get the full service",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _contracts(int area, String name, Color color) {
    return InkWell(
      onTap: () => Navigator.push(
          context, MaterialPageRoute(builder: (context) => IframeScreen())),
      child: MouseRegion(
        onEnter: (PointerEvent details) {
          setState(() {
            contractsColor = Color.fromARGB(45, 26, 40, 23);
            heightFactorContracts = 1;
          });
        },
        onExit: (PointerEvent details) {
          setState(() {
            contractsColor = Colors.transparent;
            heightFactorContracts = 1;
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
                  height: MediaQuery.of(context).size.height /
                      heightFactorContracts,
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
                            ? "Лесно и брзо направете договор за вашата потреба."
                            : "Get the contract ready \n next week",
                        textAlign: TextAlign.center,
                        // "Explain your needs in the description part and the lawyer will be more prepared",
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ],
                  ),
                ),
              ],
            ),
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
            colors: backgroundColorLawsMobile,
            stops: [-3, 3],
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
                            builder: (context) => IframeScreen())),
                    child: Card(
                      color: advokatGreenColor,
                      elevation: 5,
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
                                mkLanguage
                                    ? "Лесно и брзо направете договор за вашата потреба."
                                    : "Get the contract ready \n next week",
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
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (context) => BookAdvice())),
                    child: Card(
                      color: advokatGreenColor,
                      elevation: 5,
                      child: Container(
                        width: double.infinity,
                        color: companyColor,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    mkLanguage ? "Консултации" : "Company",
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
                                        ? "Оваа секција е за во итни случаи. Во наредните 5-15мин. ќе добиете емаил со адвокати кои се достапни во моментот за консултација"
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
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (context) => BookAdvice())),
                    child: Card(
                      color: advokatGreenColor,
                      elevation: 5,
                      child: Container(
                        height: double.maxFinite,
                        width: double.infinity,
                        color: urgentColor, // height: 200,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                mkLanguage ? "Итно" : "Urgent",
                                style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
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
              ),
            ],
          ),
        ));
  }
}
