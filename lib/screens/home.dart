import 'package:advices/screens/laws.dart';
import 'package:advices/screens/authentication/authentication.dart';
import 'package:advices/screens/authentication/sign_in.dart';
import 'package:advices/services/auth.dart';
import 'package:flutter/material.dart';
import '../services/database.dart';
import 'floating_footer_btns.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
  }

  final AuthService _auth = AuthService();

  Future<void> _checkIfLogedIn() async {
    String? token = await _auth.getToken();
    print("token: $token");
    if (token != null) {
      setState(() {});
    }
  }

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
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
      floatingActionButton: _next(),
      body: Container(
        // image
        height: double.infinity,
        width: double.infinity,
        child: Image.network(
            "https://images.unsplash.com/photo-1505664063603-28e48ca204eb?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=870&q=80",
            height: 45,
            width: 45,
            fit: BoxFit.fitHeight),
      ),
    );
  }

  Widget _next() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        width: 250,
        height: 80,
        child: FittedBox(
          child: FloatingActionButton.extended(
            label: Text('      Lets talk...    '),
            heroTag: "settingsBtn",
            onPressed: () => {
              // DatabaseService.saveLawAreasForLawyerAsArray();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Laws()),
              )
            },
            backgroundColor: Color.fromRGBO(107, 119, 141, 1),
            elevation: 0,
          ),
        ),
      ),
    );
  }
}
