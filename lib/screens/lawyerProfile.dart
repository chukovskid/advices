import 'package:advices/screens/call/call.dart';
import 'package:advices/screens/selectDateTime.dart';
import 'package:flutter/material.dart';
import 'package:advices/screens/laws.dart';
import '../utilities/constants.dart';
import 'authentication/authentication.dart';
import 'floating_footer_btns.dart';

class LawyerProfile extends StatefulWidget {
  const LawyerProfile({Key? key}) : super(key: key);

  @override
  State<LawyerProfile> createState() => _LawyerProfileState();
}

class _LawyerProfileState extends State<LawyerProfile> {
  @override
  void initState() {}

  _navigateToAuth() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Authenticate()),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(23, 34, 59, 1),
        elevation: 0.0,
        actions: <Widget>[
          FlatButton.icon(
            textColor: Colors.white,
            icon: Icon(Icons.person_outline_sharp),
            label: Text(''),
            onPressed: _navigateToAuth,
          ),
        ],
      ),
      floatingActionButton: _openProfileBtn(),
      body: Container(
        height: double.maxFinite,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromRGBO(107, 119, 141, 1),
              Color.fromRGBO(38, 56, 89, 1),
            ],
            stops: [-1, 2],
          ),
        ),
        child: _card(),
      ),
    );
  }

  Widget _openProfileBtn() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          flex: 10,
          child: Stack(
            children: [_next()],
          ),
        )
      ],
    );
  }

  Widget _card() {
    return SingleChildScrollView(
      child: Card(
        margin: const EdgeInsets.only(top: 35, left: 10, right: 10, bottom: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const SizedBox(height: 30),
            const ListTile(
              leading: Icon(Icons.person),
              title: Text("Ана Стаменова"),
              subtitle:
                  Text('8 години во фамијарно право и доктор за нешто битно'),
            ),
            const SizedBox(
              height: 30,
            ),
            _text()
          ],
        ),
      ),
    );
  }

  Widget _text() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text("About Ana:", style: helpTextStyle),
          Text(
              "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1",
              style: helpTextStyle),
          Text("", style: helpTextStyle),
          Text(
              "FIDIMI Sync bruges til at indhente skridtdata fra din enhed og overføre dem til din personlige profil på FIDIMI platformen. Der er to måder, hvorpå FIDIMI Sync kan indhente skridtdata; fra Google Fit eller enhedens egen skridttæller. Vi anbefaler, at du vælger, at dine skridtdata skal indhentes fra Google Fit, idet du så kan få skridtdata fra alle de enheder, som integrerer med Google Fit. Du behøver ikke installere Google Fit på den samme enhed, som du har installeret FIDIMI Sync - det er blot vigtigt, at du installerer Google Fit på den enhed, som registrerer dine skridtdata.",
              style: helpTextStyle),
          Text("", style: helpTextStyle),
          Text(
              "På hovedsiden kan du se historikken for de senest indhentede skridtdata, herunder hvor mange skridt, du har gået i dag og de seneste syv dage. På siden finder du også et ikon nede i højre hjørne, hvor du kan ændre dine indstillinger samt logge ud af applikationen. ",
              style: helpTextStyle),
          Text("", style: helpTextStyle),
          Text(
              "På hovedsiden kan du se historikken for de senest indhentede skridtdata, herunder hvor mange skridt, du har gået i dag og de seneste syv dage. På siden finder du også et ikon nede i højre hjørne, hvor du kan ændre dine indstillinger samt logge ud af applikationen. ",
              style: helpTextStyle),
          Text("", style: helpTextStyle),
          Text(
              "På hovedsiden kan du se historikken for de senest indhentede skridtdata, herunder hvor mange skridt, du har gået i dag og de seneste syv dage. På siden finder du også et ikon nede i højre hjørne, hvor du kan ændre dine indstillinger samt logge ud af applikationen. ",
              style: helpTextStyle),
          Text("", style: helpTextStyle),
          Text(
              "På hovedsiden kan du se historikken for de senest indhentede skridtdata, herunder hvor mange skridt, du har gået i dag og de seneste syv dage. På siden finder du også et ikon nede i højre hjørne, hvor du kan ændre dine indstillinger samt logge ud af applikationen. ",
              style: helpTextStyle),
        ],
      ),
    );
  }

  Widget _next() {
    return Align(
      alignment: Alignment.bottomRight,
      child: FloatingActionButton(
        heroTag: "settingsBtn",
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Call()),
        ),
        backgroundColor: Color.fromARGB(255, 226, 105, 105),
        elevation: 0,
        child: const Icon(Icons.keyboard_arrow_right_sharp),
      ),
    );
  }
}
