import 'dart:convert';

import 'package:advices/App/contexts/lawyersContext.dart';
import 'package:advices/screens/chat/screens/mobile_chat_screen.dart';
import 'package:advices/screens/profile/createEvent.dart';
import 'package:advices/screens/profile/workingHours.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';
import 'package:share_plus/share_plus.dart';
import '../../App/contexts/servicesContext.dart';
import '../../App/contexts/usersContext.dart';
import '../../App/helpers/CustomCircularProgressIndicator.dart';
import '../../App/models/service.dart';
import '../../App/models/user.dart';
import '../../App/providers/auth_provider.dart';
import '../../App/providers/chat_provider.dart';
import '../../App/services/firebase_dynamic_links.dart';
import '../../App/services/googleAuth.dart';
import '../../assets/utilities/constants.dart';
import '../authentication/sign_in.dart';
import '../chat/screens/web_layout_screen.dart';
import '../chat/utils/responsive_layout.dart';
import '../shared_widgets/base_app_bar.dart';

class LawyerProfile extends StatefulWidget {
  final String uid;
  final String serviceId;

  const LawyerProfile(this.uid, this.serviceId, {Key? key}) : super(key: key);

  @override
  State<LawyerProfile> createState() => _LawyerProfileState();
}

class _LawyerProfileState extends State<LawyerProfile> {
  final ChatProvider _chatProvider = ChatProvider();
  final AuthProvider _auth = AuthProvider();
  bool mkLanguage = true;
  FlutterUser? lawyer;
  String minPriceEuro = "30";
  bool loading = true;
  var imageUrl =
      "https://devshift.biz/wp-content/uploads/2017/04/profile-icon-png-898.png"; //you can use a image
  bool isLoggedUserTheLawyer = false;
  var selectedLawAreaName;
  List<Service?> selectedServices = [];
  var setDefaultMake = true;
  String? lawyerProfileURL = "";
  bool showCreateEvent = true;

  @override
  void initState() {
    _getLawyer();
    _isLoggedUserTheLawyer();
    super.initState();
  }

  Future<void> _getLawyer() async {
    lawyer = await LawyersContext.getLawyer(widget.uid);
    if (lawyer != null) {
      setState(() {
        minPriceEuro = lawyer!.minPriceEuro.toString().isEmpty
            ? minPriceEuro
            : lawyer!.minPriceEuro.toString();
        lawyer = lawyer;
        imageUrl = lawyer!.photoURL.isEmpty ? imageUrl : lawyer!.photoURL;
        loading = false;
      });
    }
  }

  Future<void> _updateServices() async {
    if (lawyer?.uid != null) {
      await ServicesContext.saveServicesForLawyer(
          lawyer!.uid, selectedServices);
    }
    selectedServices = [];
    initState();
  }

  Future<void> _startChatConversation() async {
    bool isLoggedIn = await _auth.getCurrentUser() != null ? true : false;
    if (!isLoggedIn)
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SignIn()),
      );
    String chatId = await _chatProvider.createNewChat([lawyer!.uid]);

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ResponsiveLayout(
                mobileScreenLayout: MobileChatScreen(chatId),
                webScreenLayout: WebLayoutScreen(chatId),
              )),
    );
  }

  Future<void> _signOut() async {
    await _auth.signOut();
    await GoogleAuthService.signOutWithGoogle(context: context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SignIn()),
    );
  }

  Future<void> _isLoggedUserTheLawyer() async {
    User? user = await _auth.getCurrentUser();
    if (user != null && user.uid == widget.uid) {
      setState(() {
        isLoggedUserTheLawyer = true;
      });
      lawyerProfileURL = (lawyer!.lawyerProfileURL.isNotEmpty)
          ? lawyer?.lawyerProfileURL
          : await FirebaseDynamicLinkService.createLawyerProfileDynamicLink(
              user.uid);
    }
  }

  void _shareLawyerProfileLink() async {
    final screenSize = MediaQuery.of(context).size;
    if (lawyerProfileURL != null && lawyerProfileURL!.isNotEmpty) {
      if (screenSize.width < 600) {
        Share.share(lawyerProfileURL!);
      } else {
        Clipboard.setData(ClipboardData(text: lawyerProfileURL.toString()));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Успешно го копиравте линкот од вашиот профил!"),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(
        appBar: AppBar(),
        redirectToHome: true,
      ),

      bottomSheet: Container(
        child: MediaQuery.of(context).size.width < 850.0
            ? (isLoggedUserTheLawyer
                ? WorkingHoursScreen(lawyerId: widget.uid)
                : CreateEvent(widget.uid, widget.serviceId, minPriceEuro))
            : SizedBox(),
      ),
      // floatingActionButton: _openProfileBtn(),
      body: Container(
          height: double.maxFinite,
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: backgroundColorReverse,
              stops: [-1, 1, 3],
            ),
          ),
          child: Row(
            children: [
              Flexible(flex: 3, child: _card()),
              // Flexible(child: _dateAndPrice())
              MediaQuery.of(context).size.width < 850.0
                  ? SizedBox()
                  : Flexible(
                      flex: 2,
                      child: isLoggedUserTheLawyer
                          ? WorkingHoursScreen(lawyerId: widget.uid)
                          : CreateEvent(
                              widget.uid, widget.serviceId, minPriceEuro))

              // ,: (showCreateEvent
              // ? CreateEvent(widget.uid, serviceId, minPriceEuro)
              // : SizedBox())),
            ],
          )),
    );
  }

  Widget _card() {
    return loading
        ? Center(
            child: CustomCircularProgressIndicator(
            color: darkGreenColor,
          ))
        : Container(
            height: 900,
            child: SingleChildScrollView(
              child: Card(
                elevation: 0,
                color: Colors.transparent,
                margin: const EdgeInsets.only(
                    top: 35, left: 30, right: 10, bottom: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(height: 30),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipOval(
                          child: _buildProfileImage(lawyer?.photoURL ?? ''),
                        ),
                        const SizedBox(width: 10),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${lawyer?.displayName}",
                                style: TextStyle(fontSize: 20),
                              ),
                              Text("${lawyer?.email}"),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        isLoggedUserTheLawyer
                            ? Row(
                                children: [
                                  ElevatedButton(
                                    onPressed: _signOut,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.logout,
                                          size: 15,
                                        ),
                                        Text("Одјави се"),
                                      ],
                                    ),
                                    style: ElevatedButton.styleFrom(
                                        textStyle:
                                            const TextStyle(fontSize: 15),
                                        backgroundColor: Colors.black),
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  ElevatedButton(
                                    onPressed: _shareLawyerProfileLink,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.share,
                                          size: 15,
                                        ),
                                        Text("Сподели"),
                                      ],
                                    ),
                                    style: ElevatedButton.styleFrom(
                                        textStyle:
                                            const TextStyle(fontSize: 15),
                                        backgroundColor: lightGreenColor),
                                  ),
                                ],
                              )
                            : ElevatedButton(
                                onPressed: _startChatConversation,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.mail,
                                      size: 15,
                                    ),
                                    Text(" Пораки"),
                                  ],
                                ),
                                style: ElevatedButton.styleFrom(
                                    textStyle: const TextStyle(fontSize: 15),
                                    backgroundColor: lightGreenColor),
                              ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    _text(),
                    const SizedBox(
                      height: 45,
                    ),
                  ],
                ),
              ),
            ),
          );
  }

  Widget _text() {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 10, right: 40, bottom: 10),
      // padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(mkLanguage ? "Правни области" : "Laws", style: profileHeader),
          const SizedBox(
            height: 5,
          ),
          SizedBox(
            child: _lawyerServices(),
            height: 140,
            width: 1000,
          ),
          const SizedBox(
            height: 5,
          ),
          isLoggedUserTheLawyer
              ? _dropdownLawSelect()
              : SizedBox(), // TODO: add this back
          const SizedBox(
            height: 5,
          ),
          SizedBox(height: 15),
          Text(mkLanguage ? "Кратко био" : "Short bio", style: profileHeader),
          SizedBox(height: 15),
          Text(
            "${lawyer?.description}",
            style: helpTextStyle,
            textAlign: TextAlign.justify,
          ),
          SizedBox(height: 15),
          Text(mkLanguage ? "Искуство" : "Experience", style: profileHeader),
          SizedBox(height: 15),
          Text("${lawyer?.experience}",
              style: helpTextStyle, textAlign: TextAlign.justify),
          SizedBox(height: 15),
          Text("", style: helpTextStyle),
          SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildProfileImage(String imagePath) {
    return FutureBuilder<String?>(
      future: UsersContext.getImageUrl(imagePath),
      builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data != null) {
            return Image.network(
              snapshot.data!,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            );
          } else {
            return CircleAvatar(
              backgroundColor: lightGreenColor,
              radius: 20,
              child: imagePath.isNotEmpty
                  ? Image.network(imagePath)
                  : Text(
                      " ${lawyer?.name[0].toUpperCase() ?? ''}  ${lawyer?.surname[0].toUpperCase() ?? ''}",
                      style: TextStyle(color: whiteColor),
                    ),
            );
          }
        } else {
          return CustomCircularProgressIndicator();
        }
      },
    );
  }

  Widget _dropdownLawSelect() {
    return Column(
      children: [
        DropdownButtonHideUnderline(
            child: StreamBuilder<Iterable<Service>>(
                stream: ServicesContext.getAllServices(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return Container();
                  if (setDefaultMake) {
                    selectedLawAreaName = snapshot.data?.first.name;
                  }
                  final laws = snapshot.data!;
                  return Container(
                      child: Column(
                    children: <Widget>[
                      MultiSelectDialogField(
                        dialogWidth: MediaQuery.of(context).size.width * 0.7,
                        decoration: const BoxDecoration(
                          border:
                              Border(bottom: BorderSide(color: Colors.black)),
                        ),
                        listType: MultiSelectListType.LIST,
                        searchable: true,
                        buttonText: const Text(
                          "Смени ги твоите правни области",
                          style: TextStyle(color: Color.fromARGB(192, 0, 0, 0)),
                        ),
                        title: const Text("Права"),
                        validator: (values) {
                          if (values == null || values.isEmpty) {
                            return "Required";
                          }
                          return null;
                        },
                        initialValue: [],
                        items: laws
                            .map((e) => MultiSelectItem(e, e.name))
                            .toList(),
                        onConfirm: (values) {
                          selectedServices.remove(values);
                          selectedServices.clear();
                          print(selectedServices);
                          for (int i = 0; i < values.length; i++) {
                            var val = values[i];
                            Service selectedService = Service.fromJson(
                                jsonDecode(values[i].toString()));
                            selectedServices.add(selectedService);
                          }
                          print(selectedServices);
                        },
                        chipDisplay: MultiSelectChipDisplay(
                          items: selectedServices
                              .map((e) => MultiSelectItem(e, e!.name))
                              .toList(),
                          onTap: (value) {
                            setState(() {
                              selectedServices.remove(value);
                              selectedServices.clear();
                            });
                            return selectedServices;
                          },
                        ),
                      ),
                    ],
                  ));
                })),
        const SizedBox(
          height: 20,
        ),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
            ),
            child: const Text(
              'Зачувај',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              setState(() {
                _updateServices();
              });
            })
      ],
    );
  }

  Widget _lawyerServices() {
    return FutureBuilder<List<Service>>(
      future: LawyersContext.getServicesForLawyer(widget.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CustomCircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Text("No services found for this lawyer.");
        } else {
          List<Service> services = snapshot.data!;

          return GridView.extent(
            maxCrossAxisExtent:
                200, // Each card will have a maximum width of 150
            childAspectRatio: 150 / 50, // width / height
            children: List.generate(services.length, (index) {
              return Card(
                elevation: 5.0, // Add shadow to the card
                child: Center(
                  child: Text(
                    services[index].nameMk,
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }),
          );
        }
      },
    );
  }
}
