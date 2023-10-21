import 'package:advices/App/providers/auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../App/helpers/CustomCircularProgressIndicator.dart';

class LawyerBasedRedirect extends StatefulWidget {
  final Widget lawyerWidget;
  final Widget nonLawyerWidget;

  LawyerBasedRedirect({
    required this.lawyerWidget,
    required this.nonLawyerWidget,
  });

  @override
  _LawyerBasedRedirectState createState() => _LawyerBasedRedirectState();
}

class _LawyerBasedRedirectState extends State<LawyerBasedRedirect> {
  final AuthProvider _auth = AuthProvider();
  bool isLawyer = false;
  bool dataLoaded = false;

  @override
  void initState() {
    super.initState();
    _fetchUserAndLawyerStatus();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchUserAndLawyerStatus();
  }

  Future<void> _fetchUserAndLawyerStatus() async {
    User? user = await _auth.getCurrentUser();
    if (user != null) {
      isLawyer = await _auth.isUserLawyer(user);
    } else {
      isLawyer = false;
    }
    setState(() {
      dataLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!dataLoaded) {
      return CustomCircularProgressIndicator();
    } else {
      return isLawyer ? widget.lawyerWidget : widget.nonLawyerWidget;
    }
  }
}
