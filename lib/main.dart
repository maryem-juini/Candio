import 'package:flutter/material.dart';
import 'app.dart';
import 'init.dart';

void main() async {
  // Initialize app before running
  await AppInit.init();

  runApp(const AppWidget());
}
