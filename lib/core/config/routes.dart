import 'package:flutter/material.dart';
import 'package:projecto/components/body/body.dart';
import 'package:projecto/components/slides/slide_body.dart';

class AppRoutes {
  static const String pin = '/';
  static const String slideBody = '/slideBody';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case pin:
        return MaterialPageRoute(builder: (_) => const Body());
      case slideBody:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => SlideBody(slide: args?['slide']),
        );

      // default
      default:
        return MaterialPageRoute(builder: (_) => const Scaffold());
    }
  }
}
