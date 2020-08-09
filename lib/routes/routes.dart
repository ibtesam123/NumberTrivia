import 'package:flutter/material.dart';

import '../ui/homepage/homepage.dart';
import '../ui/splashpage/splashpage.dart';

class Routes {
  static MaterialPageRoute makeRoute(Widget page) =>
      MaterialPageRoute(builder: (context) => page);

  static MaterialPageRoute splash() => makeRoute(SplashPage());

  static MaterialPageRoute home() => makeRoute(HomePage());
}
