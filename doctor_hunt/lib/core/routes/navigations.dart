import 'package:flutter/material.dart';

/// Push a new route onto the navigation stack.
void pushTo(BuildContext context, String routeName, {Object? arguments}) {
  Navigator.of(context).pushNamed(routeName, arguments: arguments);
}

/// Push a route and remove all previous routes (root navigation).
void pushToBase(BuildContext context, String routeName, {Object? arguments}) {
  Navigator.of(context).pushNamedAndRemoveUntil(
    routeName,
    (route) => false,
    arguments: arguments,
  );
}

/// Pop the current route from the navigation stack.
void pop(BuildContext context) {
  Navigator.of(context).pop();
}

/// Push a MaterialPageRoute with a widget directly.
void pushWidget(BuildContext context, Widget page) {
  Navigator.of(context).push(
    MaterialPageRoute(builder: (_) => page),
  );
}
