import 'package:advices/models/service.dart';
import 'package:advices/screens/lawyers.dart';
import 'package:advices/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import '../services/database.dart';

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
    // Remove the observer    // WidgetsBinding.instance!.removeObserver(this);
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
              colors: [
                Color.fromARGB(255, 255, 255, 255),
                Color.fromARGB(255, 255, 255, 255),
              ],
              stops: [-1, 2],
            ),
          ),
          child: Column(
            children: [
              Flexible(
                child: Row(
                  children: <Widget>[
                    Flexible(child: _cardsList(2)),
                    Flexible(child: _cardsList(3)),
                    Flexible(child: _cardsList(4)),
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
              darkGreenColor,
              darkGreenColor,
            ],
            stops: [-1, 2],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(height: 10),
              ListTile(
                  leading: Icon(
                    openExpats
                        ? Icons.keyboard_arrow_down
                        : Icons.keyboard_arrow_right,
                    color: Color.fromARGB(255, 207, 223, 226),
                  ),
                  title: Text(
                    "Expats",
                    style: TextStyle(
                        fontSize: 25,
                        color: Color.fromARGB(255, 207, 223, 226)),
                  ),
                  subtitle: const Text(''),
                  onTap: () => {
                        setState(() {
                          openExpats = !openExpats;
                        })
                      }),
              // Container( height:openExpats ? 250 : 10, child: openExpats ? _buildGrid() : SizedBox()),
              Container(height: 200, child: _cardsList(2)),
              // SizedBox(height: 10),
              ListTile(
                  leading: Icon(
                    openContracts
                        ? Icons.keyboard_arrow_down
                        : Icons.keyboard_arrow_right,
                    color: Color.fromARGB(255, 207, 223, 226),
                  ),
                  title: Text(
                    "Contracts",
                    style: TextStyle(
                        fontSize: 25,
                        color: Color.fromARGB(255, 207, 223, 226)),
                  ),
                  subtitle: const Text(''),
                  onTap: () => {
                        setState(() {
                          openContracts = !openContracts;
                        })
                      }),
              // Flexible(child: openContracts ? _cardsList() : SizedBox()),
              Container(height: 200, child: _cardsList(3)),

              // SizedBox(height: 10),
              ListTile(
                  leading: Icon(
                    openCompanies
                        ? Icons.keyboard_arrow_down
                        : Icons.keyboard_arrow_right,
                    color: Color.fromARGB(255, 207, 223, 226),
                  ),
                  title: Text(
                    "Companies",
                    style: TextStyle(
                        fontSize: 25,
                        color: Color.fromARGB(255, 207, 223, 226)),
                  ),
                  subtitle: const Text(''),
                  onTap: () => {
                        setState(() {
                          openCompanies = !openCompanies;
                        })
                      }),
              // Flexible(child: openCompanies ? _cardsList() : SizedBox()),
              Container(height: 200, child: _cardsList(4)),
            ],
          ),
        ));
  }

  Widget _cardsList(int area) {
    return StreamBuilder<Iterable<Service>>(
      stream: DatabaseService.getAllServicesByArea(area),
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
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          PointerInterceptor(
            child: ListTile(
              leading:
                  // Image.network(
                  //   'data:image/png;base64,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',
                  // ),
                  //  Icon(IconData(61668, fontFamily: 'MaterialIcons')),

                  CircleAvatar(
                backgroundColor: Colors.white,
                radius: 60,
                child: ClipOval(
                  child: Image.network(
                    service.imageUrl.length > 20
                        ? service.imageUrl
                        :
                        // 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAANoAAAC1CAYAAAA5v+FUAAAAAXNSR0IArs4c6QAAIABJREFUeF7tnQu0VlPXx1evSySSpJJCRSpC95RwRKKE3EURpRIRSRnV+EqlEN2USLnmUulOiRBKodC9FCoU5XZUrt/4rc/qO+9xnvOsvdbe+5zneeYa4xnH+7Yva8+9/nuuOed/zlkkOzv7byVDJCASiFQCRQRokcpXLi4S0BIQoMlCEAnEIAEBWgxClluIBARosgZEAjFIQIAWg5DlFiKBWIG2e/dutXXrVrVw4UK1atUqtX37dvX777/LWxAJ7JVA0aJFValSpVSNGjVUw4YNVYUKFdT++++f8hKKDWg7d+5UK1asUHPmzFFLlixR69evVzt27BCgpfwSCvcBAFrJkiVVlSpVVKNGjVRWVpaqVauWKlasWLg3ivlqsQANrbV06VL1wgsvqPHjx6u//vpL/f23hO9iftcpdzsA17p1a9W+fXtVs2bNlJt/zgnHArRt27apsWPHqhEjRqjs7OyUFphMPj4JFClSRFWsWFG1aNFCDRkyJL4bR3CnWIA2e/ZsNXHiRMVftJkMkYCtBA444ABVt25dNWrUKFW+fHnF/07FEQvQhg8friZNmqSWL1+eijKSORewBKpWraoGDhyo6tevr+23VByxAK1v375qypQp6vPPP09FGcmcC1gClSpVUrfddptq2bKlKlOmTAHPxu32sQCtV69eaurUqerLL790m6WcldESOOaYY1Tnzp3VJZdcosqVK5eSshCgpeRry6xJA7ROnTppD6QALZ93Lxots4AR9tMK0CwlKkCzFJQclqcEBGiWC0OAZikoOUyA5rMGBGg+0pNzRaNZrgEXoOFhqlevnipdurTlXeSwVJAALKHXX39d811/+uknqykL0KzEpJQL0Pr166cuu+wyhZBlpI8EIJOPGTNGTZ48WQE6myFAs5GSEqBZiikjDhOgRfiaRaNFKNwUu7QALcIXJkCLULgpdmkBWoQvTIAWoXBT7NICtAhfmAAtQuGm2KUFaBG+MAFahMJNsUsL0CJ8YQK0CIWbYpcWoEX4wgRoEQo3xS4tQIvwhQnQIhRuil1agJbkhf3888/O9T769++vZsyYoTZv3my9LIQZYi2qlDpQgJbkdfXs2VNt2bLF6aV++umn+txff/3V+nwBmrWoUupA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',
                        'https://static.vecteezy.com/system/resources/previews/002/205/948/original/gift-box-icon-free-vector.jpg',
                  ),
                ),
              ),
              //  const Icon(
              //   Icons.account_balance_outlined,
              //   color: Color.fromARGB(255, 207, 223, 226),
              // ),
              title: Text(
                service.name.toString(),
                style: TextStyle(
                    fontSize: 20, color: Color.fromRGBO(3, 34, 41, 1)),
              ),
              subtitle: const Text(''),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Lawyers(service: service.id)),
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
                service.name,
                style: TextStyle(color: Colors.white, fontSize: 14),
              ))
            ],
          )),
    );
  }
}
