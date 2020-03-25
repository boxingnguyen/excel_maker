import 'dart:io';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simple_permissions/simple_permissions.dart';
import 'package:url_launcher/url_launcher.dart';

class QrScan extends StatefulWidget {
  @override
  _QrScanState createState() => _QrScanState();
}

class _QrScanState extends State<QrScan> {
  String result = "QR Scan now!";

  Future _scanQR() async {
    try {
      String qrResult = await BarcodeScanner.scan();
      setState(() {
        result = qrResult;
      });
    } on PlatformException catch (ex) {
      if (ex.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          result = "Camera permission was denied";
        });
      } else {
        setState(() {
          result = "Unknown Error $ex";
        });
      }
    } on FormatException {
      setState(() {
        result = "You pressed the back button before scanning anything";
      });
    } catch (ex) {
      setState(() {
        print(ex);
        result = "Unknown Error $ex";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("QR Scanner"),
      ),
      body: Column(
        children: <Widget>[
          RaisedButton(
            onPressed: convert,
            child: Text('Open facebook app'),
          ),
          Center(
            child: Text(
              result,
              style: new TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.camera_alt),
        label: Text("Scan"),
        onPressed: _scanQR,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  openFbApp() async {
    String fbProtocolUrl;
    if (Platform.isIOS) {
      fbProtocolUrl = 'fb://profile/103429924575464';
    } else {
      fbProtocolUrl = 'fb://page/103429924575464';
    }

    String fallbackUrl = 'https://www.facebook.com/tmhtechlab/';

    try {
      bool launched = await launch(fbProtocolUrl, forceSafariVC: false);

      if (!launched) {
        await launch(fallbackUrl, forceSafariVC: false);
      }
    } catch (e) {
      await launch(fallbackUrl, forceSafariVC: false);
    }
  }

  convert() {
    String first = 'sivaaa';
    String second = 'lovea';
    // output: siaaloe
    var firstnameArray = new List<String>.from(first.split(''));
    var secondnameArray = new List<String>.from(second.split(''));
    firstnameArray = first.split('');
    secondnameArray = second.split('');
    print(secondnameArray);

    for (int i = 0; i < first.length; i++) {
      for (int j = 0; j < second.length; j++) {
        if (firstnameArray[i] == secondnameArray[j]) {
          print(firstnameArray[i] + "" + " == " + secondnameArray[j]);
          firstnameArray.removeAt(i);
          secondnameArray.removeAt(i);

          break;
        }
      }
    }

    var finalList = new List.from(firstnameArray)..addAll(secondnameArray);
    print(finalList);
    print(finalList.length);
  }
}
