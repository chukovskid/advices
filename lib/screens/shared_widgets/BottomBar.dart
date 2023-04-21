import 'package:advices/App/providers/navigation_provider.dart';
import 'package:advices/screens/authentication/authentication.dart';
import 'package:advices/screens/authentication/lawyerBasedRedirect.dart';
import 'package:advices/screens/call/calls.dart';
import 'package:advices/assets/utilities/constants.dart';
import 'package:flutter/material.dart';
import '../chat/screens/mobile_layout_screen.dart';
import '../chat/screens/web_layout_screen.dart';
import '../chat/utils/responsive_layout.dart';
import '../home/home.dart';
import '../urgent/urgentEventsPage.dart';

class BottomBar extends StatelessWidget {
  final NavigationProvider _navigationProvider = NavigationProvider();

  BottomBar({
    this.fabLocation = FloatingActionButtonLocation.endDocked,
    this.shape = const CircularNotchedRectangle(),
  });

  final FloatingActionButtonLocation fabLocation;
  final NotchedShape? shape;

  static final List<FloatingActionButtonLocation> centerLocations =
      <FloatingActionButtonLocation>[
    FloatingActionButtonLocation.centerDocked,
    FloatingActionButtonLocation.centerFloat,
  ];

  @override
  Widget build(BuildContext context) {
    _navigationProvider.setContext(context);

    showMenu() {
      showModalBottomSheet(
          backgroundColor: Colors.transparent,
          context: context,
          builder: (BuildContext context) {
            return Container(
              // color: Color(0xff232f34),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.0),
                  topRight: Radius.circular(16.0),
                ),
                color: Color(0xff232f34),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Container(
                    height: 36,
                  ),
                  SizedBox(
                      height: (50 * 6).toDouble(),
                      child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(16.0),
                              topRight: Radius.circular(16.0),
                            ),
                            color: Color(0xff344955),
                          ),
                          child: Stack(
                            alignment: Alignment(0, 0),
                            clipBehavior: Clip.none,
                            fit: StackFit.loose,
                            children: <Widget>[
                              Positioned(
                                top: -36,
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(50)),
                                      border: Border.all(
                                          color: Color(0xff232f34), width: 10)),
                                  child: Center(
                                    child: ClipOval(
                                      child: Image.network(
                                        "https://i.stack.imgur.com/S11YG.jpg?s=64&g=1",
                                        fit: BoxFit.cover,
                                        height: 36,
                                        width: 36,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                child: ListView(
                                  physics: NeverScrollableScrollPhysics(),
                                  children: <Widget>[
                                    ListTile(
                                      title: Text(
                                        "Profile",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      leading: Icon(
                                        Icons.person,
                                        color: Colors.white,
                                      ),
                                      onTap: () {
                                        NavigationProvider()
                                            .navigateTo(Authenticate());
                                        // Navigator.push(
                                        //   context,
                                        //   MaterialPageRoute(
                                        //       builder: (context) =>
                                        //           Authenticate()),
                                        // );
                                      },
                                    ),
                                    ListTile(
                                      title: Text(
                                        "Laws",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      leading: Icon(
                                        Icons.balance,
                                        color: Colors.white,
                                      ),
                                      onTap: () {
                                        NavigationProvider().navigateTo(Home());
                                      },
                                    ),
                                    ListTile(
                                      title: Text(
                                        "Lawyers",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      leading: Icon(
                                        Icons.groups_sharp,
                                        color: Colors.white,
                                      ),
                                      onTap: () {
                                        NavigationProvider().navigateTo(Home());
                                      },
                                    ),
                                    ListTile(
                                      title: Text(
                                        "Calls",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      leading: Icon(
                                        Icons.call,
                                        color: Colors.white,
                                      ),
                                      onTap: () {
                                        NavigationProvider()
                                            .privateNav(Calls());
                                      },
                                    ),
                                    ListTile(
                                      title: Text(
                                        "Пораки",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      leading: Icon(
                                        Icons.chat,
                                        color: Colors.white,
                                      ),
                                      onTap: () {
                                        NavigationProvider()
                                            .privateNav(Calls());
                                      },
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ))),
                  Container(
                    height: 56,
                    color: Color(0xff4a6572),
                  )
                ],
              ),
            );
          });
    }

    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      color: darkGreenColor,
      child: IconTheme(
        data: IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            // IconButton(
            //   iconSize: 32.0,
            //   tooltip: 'Open navigation menu',
            //   icon: const Icon(Icons.menu),
            //   onPressed: () {
            //     showMenu();
            //   },
            // ),
            // IconButton(
            //     iconSize: 32.0,
            //     tooltip: 'Состаноци',
            //     icon: const Icon(Icons.web),
            //     onPressed: () => context.read<Counter>().increment()
            //     // await FirebaseDynamicLinkService.buildDynamicLinks("opopID");

            //     ),
            LawyerBasedRedirect(
              lawyerWidget: IconButton(
                iconSize: 32.0,
                tooltip: 'Нови случаи',
                icon: const Icon(Icons.notification_important_outlined),
                onPressed: () {
                  _navigationProvider.privateNav(UrgentEvents());
                },
              ),
              nonLawyerWidget: IconButton(
                iconSize: 32.0,
                tooltip: 'Состаноци',
                icon: const Icon(Icons.call),
                onPressed: () {
                  _navigationProvider.privateNav(Calls());
                },
              ),
            ),
            IconButton(
              iconSize: 32.0,
              tooltip: 'Пораки',
              icon: const Icon(Icons.chat),
              onPressed: () {
                _navigationProvider.privateNav(ResponsiveLayout(
                    mobileScreenLayout: MobileLayoutScreen(null),
                    webScreenLayout: WebLayoutScreen(null)));
              },
            ),
            if (centerLocations.contains(fabLocation)) const Spacer(),
            IconButton(
              tooltip: 'Профил',
              icon: const Icon(Icons.person),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Authenticate()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
