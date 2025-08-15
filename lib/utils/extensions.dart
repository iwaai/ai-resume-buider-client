import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

extension TextThemeExtension on BuildContext {
  TextTheme get textTheme => Theme.of(this).textTheme;
}

extension GoRouterExt on GoRouter {
  String get _currentRoute =>
      routerDelegate.currentConfiguration.matches.last.matchedLocation;

  /// Pop until the route with the given [path] is reached.
  /// Example
  /// ``` dart
  ///  GoRouter.of(context).popUntil(SettingsScreen.route);
  /// ```
  ///  dart
  ///  GoRouter.of(context).popUntil(SettingsScreen.route);
  ///

  void popUntil(String path) {
    var currentRoute = _currentRoute;
    while (currentRoute != path && canPop()) {
      pop();
      currentRoute = _currentRoute;
    }
  }
}

extension StringExtensions on String {
  String getInitials() {
    List<String> words = trim().split(' ');
    String initials = words.map((word) => word[0].toUpperCase()).join();
    if (initials.length > 2) {
      return initials.substring(0, 2);
    }
    return initials;
  }

  String toLower() {
    return toLowerCase();
  }

  String capitalizeFirst() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }

  String capitalizeByWord() {
    if (trim().isEmpty) {
      return '';
    }
    return split(' ')
        .map((element) =>
            "${element[0].toUpperCase()}${element.substring(1).toLowerCase()}")
        .join(" ");
  }

  String toUSPhoneNumber() {
    if (isEmpty) return "";

    // Ensure it starts with '+1'
    String sanitized = startsWith("+1") ? substring(2) : this;

    if (sanitized.length <= 3) return "+1 ( $sanitized";
    if (sanitized.length <= 6) {
      return "( ${sanitized.substring(0, 3)} ) ${sanitized.substring(3)}";
    }
    if (sanitized.length <= 10) {
      return "( ${sanitized.substring(0, 3)} ) ${sanitized.substring(3, 6)}-${sanitized.substring(6)}";
    }

    return "( ${sanitized.substring(0, 3)} ) ${sanitized.substring(3, 6)}-${sanitized.substring(6)}";
  }
}
