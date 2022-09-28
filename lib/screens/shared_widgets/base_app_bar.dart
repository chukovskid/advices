import 'package:advices/screens/profile.dart';
import 'package:flutter/material.dart';
import '../../utilities/constants.dart';
import '../home.dart';

class BaseAppBar extends StatelessWidget implements PreferredSizeWidget {
  final AppBar appBar;
  bool redirectToHome;

  /// you can add more fields that meet your needs

  BaseAppBar({required this.appBar, this.redirectToHome = false});

  @override
  Widget build(BuildContext context) {
    _navigate() {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => redirectToHome ? Home() : Profile()),
      );
    }

    return AppBar(
      backgroundColor: darkGreenColor,
      elevation: 10.0,
      actions: <Widget>[
        FlatButton.icon(
          textColor: Colors.white,
          icon: Icon(redirectToHome ? Icons.home : Icons.person),
          label: Text(''),
          onPressed: _navigate,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => new Size.fromHeight(appBar.preferredSize.height);
}
