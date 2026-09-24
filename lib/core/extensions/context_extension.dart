import 'package:flutter/material.dart';

/// Convenient extensions on [BuildContext] to simplify boilerplate retrieval.
extension BuildContextExtension on BuildContext {
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => Theme.of(this).textTheme;
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  
  Size get mediaQuerySize => MediaQuery.sizeOf(this);
  EdgeInsets get mediaQueryPadding => MediaQuery.paddingOf(this);
  
  void showSnackBar(String message) {
    ScaffoldMessenger.of(this)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}
