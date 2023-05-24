import 'package:advices/assets/utilities/constants.dart';
import 'package:advices/screens/services/book_advice.dart';
import 'package:advices/screens/urgent/urgentEventsPage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

import '../call/calls.dart';
import '../webView/IframeWidget.dart';
import 'laws.dart';
import 'lawyers.dart';

class LawyerHomeWidget extends StatefulWidget {
  const LawyerHomeWidget({Key? key}) : super(key: key);

  @override
  State<LawyerHomeWidget> createState() => _LawyerHomeWidgetState();
}

class _LawyerHomeWidgetState extends State<LawyerHomeWidget>
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
                  child: _dates(
                      2, mkLanguage ? "Состаноци" : "Meets", expatsColor)),
              Expanded(
                  child: _docAi(
                      3,
                      mkLanguage
                          ? "Разговарајте со кој било документ"
                          : "Chat with any document",
                      contractsColor)),
              // Expanded(
              //     child: _urgentEvents(
              //         3,
              //         mkLanguage ? "Итни случаи" : "Chat with any document",
              //         urgentColor)),
            ],
          )),
    );
  }

  Widget _dates(int area, String name, Color color) {
    return InkWell(
      onTap: () => Navigator.push(
          context, MaterialPageRoute(builder: (context) => Calls())),
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
                        style: TextStyle(color: Colors.white, fontSize: 30),
                      ),
                      Text(
                        "______________________",
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                      Text(
                        mkLanguage
                            ? "Закажани состаноци со Вас"
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

  Widget _docAi(int area, String name, Color color) {
    return InkWell(
      onTap: () => {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    IframeWidget(src: 'http://advices.chat/'))),
      },
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
                        style: TextStyle(color: Colors.white, fontSize: 30),
                      ),
                      Text(
                        "______________________",
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                      Text(
                        mkLanguage
                            ? "Лесно и брзо добијте релевантни информации."
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

  Widget _urgentEvents(int area, String name, Color color) {
    return InkWell(
      onTap: () => {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => UrgentEvents())),
      },
      child: MouseRegion(
        onEnter: (PointerEvent details) {
          setState(() {
            urgentColor = Color.fromARGB(45, 26, 40, 23);
            heightFactorUrgent = 1;
          });
        },
        onExit: (PointerEvent details) {
          setState(() {
            urgentColor = Colors.transparent;
            heightFactorUrgent = 1;
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
                            ? "Најдете слободни случаи и контактирајте со клиент"
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
              // Expanded(
              //   child: MouseRegion(
              //     onEnter: (PointerEvent details) {
              //       setState(() {
              //         contractsColor = transperentBlackColor;
              //         heightFactorCompany = 2.0;
              //       });
              //     },
              //     onExit: (PointerEvent details) {
              //       setState(() {
              //         contractsColor = Colors.transparent;
              //         heightFactorCompany = 1.8;
              //       });
              //     },
              //     child: InkWell(
              //       onTap: () => {
              //         Navigator.push(
              //             context,
              //             MaterialPageRoute(
              //                 builder: (context) => IframeWidget(
              //                     src:
              //                         'https://advokat.mk/services/documents_iframe.html'))),
              //       },
              //       child: Card(
              //         color: advokatGreenColor,
              //         elevation: 5,
              //         child: Container(
              //           width: double.infinity,
              //           color: contractsColor,
              //           child: Column(
              //               mainAxisAlignment: MainAxisAlignment.center,
              //               children: [
              //                 Text(
              //                   mkLanguage ? "Договори" : "Contracts",
              //                   style: TextStyle(
              //                       fontSize: 25,
              //                       color: Color.fromARGB(255, 207, 223, 226)),
              //                 ),
              //                 Text(
              //                   mkLanguage ? "____________" : "Company",
              //                   style: TextStyle(
              //                       fontSize: 25,
              //                       color: Color.fromARGB(255, 207, 223, 226)),
              //                 ),
              //                 Text(
              //                   mkLanguage
              //                       ? "Лесно и брзо направете договор за вашата потреба."
              //                       : "Get the contract ready \n next week",
              //                   textAlign: TextAlign.center,
              //                   style: TextStyle(
              //                       fontSize: 14,
              //                       color: Color.fromARGB(255, 207, 223, 226)),
              //                 ),
              //               ]),
              //         ),
              //       ),
              //     ),
              //   ),
              // ),             
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
                            builder: (context) =>
                                Calls())),
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
                                    mkLanguage ? "Состаноци" : "Meets",
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.w600,
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
                                        ? "Закажани состаноци со Вас"
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
                            builder: (context) =>
                                IframeWidget(src: 'http://advices.chat/',))),
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
                                    mkLanguage ? "Комуницирај со документ" : "Meets",
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
                                        ? "Вештачка интелегенција која ќе го прочита дадениот документ и одговара на вашите праашања"
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
            ],
          ),
        ));
  }
}
