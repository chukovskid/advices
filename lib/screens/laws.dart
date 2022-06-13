import 'package:advices/models/law.dart';
import 'package:advices/screens/call/call.dart';
import 'package:advices/screens/lawyerProfile.dart';
import 'package:advices/screens/lawyers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/user.dart';
import '../services/database.dart';
import 'authentication/authentication.dart';
import 'floating_footer_btns.dart';

class Laws extends StatefulWidget {
  const Laws({Key? key}) : super(key: key);

  @override
  State<Laws> createState() => _LawsState();
}

class _LawsState extends State<Laws>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late AnimationController controller;

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    controller.repeat(reverse: true);
    super.initState();
    WidgetsBinding.instance!.removeObserver(this);
  }

  @override
  void dispose() {
    // Remove the observer
    WidgetsBinding.instance!.removeObserver(this);

    super.dispose();
  }

  _navigateToAuth() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Call()),
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
        child: _cardsList(),
      ),
    );
  }

  Widget _cardsList() {
    return StreamBuilder<Iterable<Law>>(
      stream: DatabaseService.getAllLaws(),
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
          return ListView(
              padding: const EdgeInsets.symmetric(
                horizontal: 10.0,
                vertical: 40.0,
              ),
              children: laws.map(_card).toList());
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

  Widget _card(Law law) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: const Icon(Icons.person),
            title: Text(law.name.toString()),
            subtitle:
                const Text('Music by Julie Gable. Lyrics by Sidney Stein.'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Lawyers(lawArea: law.id)),
            ),
          ),
          const SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }
}








































































// import 'package:advices/models/lawAreaEnum.dart';
// import 'package:advices/screens/authentication/authentication.dart';
// import 'package:advices/screens/lawyers.dart';
// import 'package:flutter/material.dart';

// import 'floating_footer_btns.dart';

// class Laws extends StatefulWidget {
//   const Laws({Key? key}) : super(key: key);

//   @override
//   State<Laws> createState() => _LawsState();
// }

// class _LawsState extends State<Laws> {
//   @override
//   void initState() {
//     super.initState();
//     getAreas();
//   }

//   getAreas(){
//     print(LawArea.family.name);
//     print(LawArea.home.index);
//     print(LawArea.public.name);

//   }

//   _navigateToLawyers() {
//     Navigator.push( 
//       context,
//       MaterialPageRoute(builder: (context) => Lawyers()),
//     );
//   }

//   _navigateToAuth() {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => Authenticate()),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Color.fromRGBO(23, 34, 59, 1),
//         elevation: 0.0,
//         actions: <Widget>[
//           FlatButton.icon(
//             textColor: Colors.white,
//             icon: Icon(Icons.person_outline_sharp),
//             label: Text(''),
//             onPressed: _navigateToAuth,
//           ),
//         ],
//       ),
//       body: Container(
//         height: double.maxFinite,
//         width: double.infinity,
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//             colors: [
//               Color.fromRGBO(107, 119, 141, 1),
//               Color.fromRGBO(38, 56, 89, 1),
//             ],
//             stops: [-1, 2],
//           ),
//         ),
//         child: _cardsList(),
//       ),
//     );
//   }

//   Widget _cardsList() {
//     return ListView(
//       padding: const EdgeInsets.symmetric(
//         horizontal: 10.0,
//         vertical: 40.0,
//       ),
//       children: <Widget>[
//         _card("Меѓународно право "),
//         _card("Уставно и управно право"),
//         _card("Кривично право "),
//         _card("Општо право"),
//         _card("Прекршочно право"),
//         _card("Имотно право"),
//         _card("Еднаквост и доверба"),
//         _card("Закон за облигациони односи"),
//       ],
//     );
//   }

//   Widget _card(String titleName) {
//     return Card(
//       color: Color.fromARGB(255, 243, 243, 243),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(15.0),
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: <Widget>[
//           ListTile(
//             leading: const Icon(Icons.family_restroom),
//             title: Text("$titleName  "),
//             subtitle:
//                 const Text('Music by Julie Gable. Lyrics by Sidney Stein.'),
//             onTap: () => Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => Lawyers()),
//             ),
//           ),
//           const SizedBox(
//             height: 20,
//           )
//         ],
//       ),
//     );
//   }
// }
