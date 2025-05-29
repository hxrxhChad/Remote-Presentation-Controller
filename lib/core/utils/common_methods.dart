import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:projecto/main.dart';

void showSnack({
  BuildContext? context,
  Color backgroundColor = Colors.green,
  required String text,
  bool sticky = false,
}) {
  final BuildContext? buildContext = context ?? navigatorKey.currentContext;

  if (buildContext == null) {
    debugPrint("❌ ERROR: No valid context found for Snackbar!");
    return;
  }

  ScaffoldMessenger.of(buildContext).clearSnackBars();
  ScaffoldMessenger.of(buildContext).showSnackBar(
    SnackBar(
      backgroundColor: backgroundColor,
      elevation: 0,
      padding: EdgeInsets.zero,
      duration: sticky ? const Duration(days: 365) : const Duration(seconds: 3),
      content: Container(
        height: 30.h,
        alignment: Alignment.center,
        child: Center(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(buildContext).textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    ),
  );
}

void clearAllSnack({BuildContext? context}) {
  final BuildContext? buildContext = context ?? navigatorKey.currentContext;

  if (buildContext == null) {
    debugPrint("❌ ERROR: No valid context found to clear SnackBars!");
    return;
  }

  ScaffoldMessenger.of(buildContext).clearSnackBars();
}

enum CommonState { initial, loading, success, error }
