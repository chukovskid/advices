import 'package:flutter/material.dart';
// import 'checkout_mobile.dart' as impl;

import 'checkout_stub.dart'
    // if (dart.library.io) 'checkout_mobile.dart'
    if (dart.library.js) 'checkout_web.dart' as impl;

void redirectToCheckout(BuildContext context) =>
    impl.redirectToCheckout(context);
