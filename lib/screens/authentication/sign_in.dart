// ignore_for_file: deprecated_member_use

import 'package:advices/screens/authentication/register.dart';
import 'package:advices/screens/home.dart';
import 'package:advices/utilities/constants.dart';
import 'package:flutter/material.dart';
import '../../models/user.dart';
import '../../services/auth.dart';
import '../shared_widgets/base_app_bar.dart';
import 'authentication.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SignIn extends StatefulWidget {
  final Function? toggleView;
  SignIn({this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  // final FocusNode _nameFocusNode = FocusNode();
  // final FocusNode _phoneFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  // final TextEditingController _nameController = TextEditingController();
  // final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  _nextFocus(FocusNode focusNode) {
    FocusScope.of(context).requestFocus(focusNode);
  }

  _submitForm() async {
    // if (_formKey.currentState!.validate()) {
    var user = {
      'email': _emailController.text,
      'password': _passwordController.text,
    };
    FlutterUser fUser = FlutterUser(
        email: _emailController.text, password: _passwordController.text);
    print(user.toString());

    await _signInUser(fUser);

    // If the form passes validation, display a Snackbar.
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Registration sent')));

    _formKey.currentState?.save();
    _formKey.currentState?.reset();
    _nextFocus(_emailFocusNode);
    // }
  }

  String? _validateInput(String value) {
    if (value.trim().isEmpty) {
      return 'Field required';
    }
    return null;
  }

  // text field state
  String email = '';
  String password = '';
  bool _showEmailInputs = false;
  FlutterUser? user;

  void goBack() {
    Navigator.pop(context);
  }

  _navigateToAuth() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Authenticate()),
    );
  }

  _navigateToHome() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Home()),
    );
  }

  _navigateToRegister() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Register()),
    );
  }

  Future<void> _signInUser(FlutterUser flutUser) async {
    var user = await _auth.signInWithEmailAndPassword(flutUser);
    if (user != null) {
      Navigator.pop(context);
    }
  }

  Future<void> _googleSignIn() async {
    await _auth.signInWithGoogle(context: context);
    // await _auth.googleSignIn();
    Navigator.pop(context);

    // await _navigateToAuth();
    print(email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: BaseAppBar(
        appBar: AppBar(),
        redirectToHome: true,
      ),
      backgroundColor: Color.fromARGB(255, 226, 146, 100),
      body: Container(
        height: double.maxFinite,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: backgroundColor,
            stops: [-1, 2],
          ),
        ),
        child: _form(),
      ),
    );
  }

  Widget _form() {
    return Form(
      child: Container(
        height: 60,
        margin: EdgeInsets.all(35),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              "Sign In",
              style: TextStyle(
                fontWeight: FontWeight.normal,
                color: Colors.white,
                fontSize: 30,
              ),
            ),
            const SizedBox(height: 35.0),
            _showEmailSignIn(),
            // _showEmailInputs ? _showEmailSignIn() : SizedBox(),
            // !_showEmailInputs
            //     ? ElevatedButton(
            //         style: ButtonStyle(
            //             backgroundColor:
            //                 MaterialStateProperty.all<Color>(orangeColor)),
            //         child: const Text(
            //           ' Email log In ',
            //           style: TextStyle(color: Colors.white),
            //         ),
            //         onPressed: () async {
            //           setState(() {
            //             _showEmailInputs = true;
            //           });
            //         })
            //     : SizedBox(),
            const SizedBox(height: 50.0),
            const Text(
              "Or Sign up using social media",
              style: TextStyle(
                fontWeight: FontWeight.normal,
                color: Colors.white,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 10.0),
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.center, //Center Row contents horizontally,
              children: [
                Container(
                  height: 60,
                  width: 60,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        onPrimary: Color.fromARGB(255, 184, 15, 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(40.0),
                        ),
                      ),
                      // textColor: Color.fromARGB(255, 184, 15, 15),
                      // shape: RoundedRectangleBorder(
                      //   borderRadius: new BorderRadius.circular(40.0),
                      // ),
                      // color: Color.fromARGB(255, 255, 255, 255),
                      child: const Center(
                          child: FaIcon(FontAwesomeIcons.googlePlusG)),
                      onPressed: () async {
                        _googleSignIn();
                      }),
                ),
                const SizedBox(width: 15.0),
                Container(
                  height: 60,
                  width: 60,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        onPrimary: Color.fromARGB(255, 184, 15, 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(40.0),
                        ),
                      ),
                      // shape: RoundedRectangleBorder(
                      //   borderRadius: new BorderRadius.circular(40.0),
                      // ),
                      // color: Color.fromARGB(255, 255, 255, 255),
                      child: const Center(
                        child:
                            // FaIcon(FontAwesomeIcons.arrowLeft)

                            Icon(
                          Icons.facebook,
                          size: 30.0,
                          color: Color.fromARGB(255, 22, 28, 87),
                        ),
                      ),
                      onPressed: () async {
                        _googleSignIn();
                      }),
                ),
                const SizedBox(width: 15.0),
                Container(
                  height: 60,
                  width: 60,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        onPrimary: Color.fromARGB(255, 54, 107, 187),
                        shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(40.0),
                        ),
                      ),
                      // textColor: Color.fromARGB(255, 54, 107, 187),
                      // shape: RoundedRectangleBorder(
                      //   borderRadius: new BorderRadius.circular(40.0),
                      // ),
                      // color: Color.fromARGB(255, 255, 255, 255),
                      child:
                          const Center(child: FaIcon(FontAwesomeIcons.twitter)),
                      onPressed: () async {
                        _googleSignIn();
                      }),
                ),
              ],
            ),
            const SizedBox(height: 50.0),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(40.0),
                  ),
                  elevation: 0.0,
                ),
                // color: Colors.transparent,
                child: const Text(
                  'No account? Create one!',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: _navigateToRegister),
          ],
        ),
      ),
    );
  }

  Widget _showEmailSignIn() {
    return Column(children: <Widget>[
      const SizedBox(height: 20.0),
      TextFormField(
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        focusNode: _emailFocusNode,
        onFieldSubmitted: (String value) {
          //Do anything with value
          _nextFocus(_passwordFocusNode);
        },
        controller: _emailController,
        validator: (value) => _validateInput(value.toString()),
        style: const TextStyle(color: Colors.white),
        decoration: const InputDecoration(
            fillColor: Colors.orange,
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color.fromRGBO(225, 103, 104, 1)),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color.fromARGB(255, 255, 255, 255)),
            ),
            labelText: "Email",
            labelStyle: TextStyle(
              color: Color.fromARGB(209, 255, 255, 255),
            )),
      ),
      const SizedBox(height: 20.0),
      TextFormField(
        keyboardType: TextInputType.visiblePassword,
        textInputAction: TextInputAction.next,
        focusNode: _passwordFocusNode,
        onFieldSubmitted: (String value) {
          _submitForm();
        },
        controller: _passwordController,
        validator: (value) => _validateInput(value.toString()),
        style: const TextStyle(color: Colors.white),
        obscureText: true,
        decoration: const InputDecoration(
            fillColor: Colors.orange,
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color.fromRGBO(225, 103, 104, 1)),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color.fromARGB(255, 255, 255, 255)),
            ),
            labelText: "Password",
            labelStyle: TextStyle(
              color: Color.fromARGB(209, 255, 255, 255),
            )),
      ),
      SizedBox(height: 30.0),
      ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: orangeColor,
          ),

          // color: Color.fromRGBO(225, 103, 104, 1),
          child: const Text(
            ' Log In ',
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () async {
            await _submitForm();
          })
    ]);
  }
}
