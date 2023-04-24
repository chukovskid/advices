import 'package:advices/screens/authentication/authentication.dart';
import 'package:flutter/material.dart';
import '../../assets/utilities/constants.dart';
import '../home/home.dart';

class BaseAppBar extends StatelessWidget implements PreferredSizeWidget {
  final AppBar appBar;
  bool redirectToHome;
  bool openChat;
  final VoidCallback? onChatPressed;

  /// you can add more fields that meet your needs

  BaseAppBar({required this.appBar, this.redirectToHome = false, this.openChat = false, this.onChatPressed});

  @override
  Widget build(BuildContext context) {
    _navigate() {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => redirectToHome ? Home() : Authenticate()),
      );
    }

    _navigateBack() {
      if (Navigator.canPop(context)) {
        Navigator.pop(context, true);
      } else if (redirectToHome) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Home()),
        );
      }
    }

    _returnLeading() {
      if (Navigator.canPop(context)) {
        return IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: _navigateBack,
        );
      } else {
        return null;
      }
    }

    return AppBar(
      leading: _returnLeading(),
      backgroundColor: darkGreenColor,
      // automaticallyImplyLeading : appBar.automaticallyImplyLeading,
      elevation: 10.0,
      actions: <Widget>[
        TextButton.icon(
          style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.white)),
          // textColor: Colors.white,
          icon: openChat ? Icon(Icons.chat) : Icon(Icons.person),
          label: Text(''),
          onPressed: openChat ? onChatPressed : _navigate,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => new Size.fromHeight(appBar.preferredSize.height);
}
