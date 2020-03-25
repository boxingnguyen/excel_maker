import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:chirp_flutter/chirp_flutter.dart';
import 'package:my_app/qr_scan.dart';
import 'package:simple_permissions/simple_permissions.dart';

import 'chirp.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Calibre',
      ),
      home: Scaffold(body: QrScan()),
    );
  }
}
