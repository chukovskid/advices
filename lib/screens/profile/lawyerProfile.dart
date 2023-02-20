import 'package:advices/App/contexts/lawyersContext.dart';
import 'package:advices/screens/chat/screens/mobile_chat_screen.dart';
import 'package:advices/screens/profile/createEvent.dart';
import 'package:flutter/material.dart';
import '../../App/models/user.dart';
import '../../App/providers/chat_provider.dart';
import '../../assets/utilities/constants.dart';
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

  bool mkLanguage = true;
  FlutterUser? lawyer;
  String minPriceEuro = "30";
  bool loading = true;

  var imageUrl =
      "https://devshift.biz/wp-content/uploads/2017/04/profile-icon-png-898.png"; //you can use a image

  @override
  void initState() {
    _getLawyer();
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

  Future<void> _startChatConversation() async {
    print("_startChatConversation");
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(
        appBar: AppBar(),
      ),

      bottomSheet: Container(
        child: MediaQuery.of(context).size.width < 850.0
            ? CreateEvent(widget.uid, widget.serviceId, minPriceEuro)
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
              colors: [
                Colors.white60,
                Color.fromARGB(255, 211, 218, 228),
                darkGreenColor
              ],
              stops: [-1, 1, 1.1],
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
                      child: CreateEvent(
                          widget.uid, widget.serviceId, minPriceEuro)),
            ],
          )),
    );
  }

  Widget _card() {
    return loading
        ? Center(
            child: CircularProgressIndicator(
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
                      children: [
                        ClipOval(
                          child: Image.network(
                              (lawyer?.photoURL != null &&
                                      lawyer!.photoURL.isNotEmpty)
                                  ? lawyer!.photoURL
                                  : 'https://st.depositphotos.com/2069323/2156/i/600/depositphotos_21568785-stock-photo-man-pointing.jpg',
                              // scale: 1,
                              cacheWidth: 1,
                              width: 100,
                              height: 100),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${lawyer?.displayName}",
                              style: TextStyle(fontSize: 20),
                            ),
                            Text("${lawyer?.email}"),
                          ],
                        ),
                      ],
                    ),
                    ElevatedButton(
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
                    //how to get ElevatedButton backgroundColor?

                    const SizedBox(
                      height: 45,
                    ),
                    _text()
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
}
