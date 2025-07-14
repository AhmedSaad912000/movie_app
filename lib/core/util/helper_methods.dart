import 'package:flutter/material.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void navigateTo(Widget page, {withHistory = true}) {
  Navigator.push(
      navigatorKey.currentContext!,
      MaterialPageRoute(
        builder: (context) => page,
      ),
    );
}
