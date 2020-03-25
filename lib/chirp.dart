import 'dart:typed_data';

import 'package:chirp_flutter/chirp_flutter.dart';
import 'package:flutter/material.dart';
import 'package:simple_permissions/simple_permissions.dart';

/// Enter Chirp application credentials below
String _appKey = 'B9DbeE1c5f2Ed0fc160B0e36F';
String _appSecret = '4a28ad3aBb00F7a32AaEDEf2E7FC7e0EF0E799c5Bef47Aa992';
String _appConfig =
    'DRmdH6UCGamn0bcUu5hIAanoQ59EyubCzo4G3fpu50J8gc8y1+opcxFtet+9jyEKO6J4gr+OECzSttGS0Z5nkfGTpMBbZPYetolPmbjuyJaZo7SLMfoNMRxei7BKrrSdvUx6Feb5lL+Pg8paQQVdvnXjqkYBdlMdQFiMWuWx0CrbhRbATslg3uRyPoeAR7zJGve+Q1HwSDmcaks9otywOjsYTxorfi8FHBHG4QH/PxEVZCA8UkzJrTHK8sGfTZWmS6zjIZSt4TAq/MJP3X25y20JT9lX+C3Jsw2A38l+235AP0NsNAmPY5LnrCcfYbBkMhBN0rbRnCAqOnK4LSRlL6uyzcabtFQRDoJ0QSE93IfhH68AB87mZ6B2hTUXr/wsOp0CiGdjG8S/b7bQAEUysTi8KM7RfbNwKQNBaIuuia1G06cya1SCV3zpkQHrD41RGftsuiJngetGxXXbMEsyQCMRJg+W7RAgVk6fnEp38aU3UGSV4AARoUH/DOBRc5C0dbX+Tq8NR26JwV57udAjUxpI8g2K/NpEc0sZVeK2GdqtImaZOSM7v+hRvX06VzdvifdKWvKwvnLmENC8FVgaSP7sbzSUNLB81hDQW/BjwWCQkhqCokkjJfAu2rTsY41bj8gE3wWtx/SwbMDSDz4ioqUFD/ubNUVirdwEhFWLeL2rYqobwDdtw0TUwIUvEPATZNFU9VYAKVZWrFs9rX4XmSohe75nuPYRPWtCbnyqK9tDaLeDOX1kdbHlmGzHWGfUiB15SANeXFO09mZNTDTCKPerCXE1v+bXUA+NsB5kOzwmhh5+y7KSO4HaohiwHuKN8LqWJsGjgiF5OL1h1g/XWDKn81+oRMlJnoCPO3F56d5rQBPpf4KJLGaXjaGWWVMQI+R3oK7/ASWyPfaBBUUJaWhEEJiQvhfrhrXIz/layhD0JAwdj2NhvVqPpNvoxI8vv2dLqSNyu741bjFMiEsdjZNcY22SZCRpe0LUCuQMeIIeg6MeNPpOZ8D+lEqPzuo+bIFYJFtXIYuoe7oNvKCOHV9pAm/R/PWdrgo+QbFKcak=';

class Chirp extends StatefulWidget {
  @override
  _ChirpState createState() => _ChirpState();
}

class _ChirpState extends State<Chirp> {
  ChirpState _chirpState = ChirpState.not_created;

  String _chirpErrors = '';

  String _chirpVersion = 'Unknown';

  String _startStopBtnText = 'START';

  Uint8List _chirpData = Uint8List(0);

  void setPayload(Uint8List payload) {
    setState(() {
      _chirpData = payload;
    });
  }

  void setErrorMessage(String error) {
    setState(() {
      _chirpErrors = error;
    });
  }

  Future<void> _initChirp() async {
    try {
      // Init ChirpSDK
      await ChirpSDK.init(_appKey, _appSecret);

      // Get and print SDK version
      final String chirpVersion = await ChirpSDK.version;
      setState(() {
        _chirpVersion = "$chirpVersion";
      });

      // Set SDK config
      await ChirpSDK.setConfig(_appConfig);
      _setChirpCallbacks();
    } catch (err) {
      setErrorMessage("Error initialising Chirp.\n${err.message}");
    }
  }

  void _startStopSDK() async {
    try {
      var state = await ChirpSDK.state;
      if (state == ChirpState.stopped) {
        _startSDK();
      } else {
        _stopSDK();
      }
    } catch (err) {
      setErrorMessage("${err.message}");
    }
  }

  void _startSDK() async {
    try {
      await ChirpSDK.start();
      setState(() {
        _startStopBtnText = "STOP";
      });
    } catch (err) {
      setErrorMessage("Error starting the SDK.\n${err.message};");
    }
  }

  void _stopSDK() async {
    try {
      await ChirpSDK.stop();
      setState(() {
        _startStopBtnText = "START";
      });
    } catch (err) {
      setErrorMessage("Error stopping the SDK.\n${err.message};");
    }
  }

  void _sendRandomPayload() async {
    try {
      // Uint8List payload = await ChirpSDK.randomPayload();

      String identifier = "hello";
      var payload = new Uint8List.fromList(identifier.codeUnits);

      setPayload(payload);
      await ChirpSDK.send(payload);
    } catch (err) {
      setErrorMessage("Error sending random payload: ${err.message};");
    }
  }

  Future<void> _setChirpCallbacks() async {
    ChirpSDK.onStateChanged.listen((e) {
      setState(() {
        _chirpState = e.current;
      });
    });
    ChirpSDK.onSending.listen((e) {
      setState(() {
        _chirpData = e.payload;
      });
    });
    ChirpSDK.onSent.listen((e) {
      setState(() {
        _chirpData = e.payload;
      });
    });
    ChirpSDK.onReceived.listen((e) {
      setState(() {
        _chirpData = e.payload;
      });
    });
  }

  Future<void> _requestPermissions() async {
    bool permission =
        await SimplePermissions.checkPermission(Permission.RecordAudio);
    if (!permission) {
      await SimplePermissions.requestPermission(Permission.RecordAudio);
    }
  }

  @override
  void initState() {
    super.initState();
    try {
      _requestPermissions();
      _initChirp();
    } catch (e) {
      _chirpErrors = e.toString();
    }
  }

  @override
  void dispose() {
    _stopSDK();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _stopSDK();
    } else if (state == AppLifecycleState.resumed) {
      _startSDK();
    }
  }

  @override
  Widget build(BuildContext context) {
    final chirpYellow = const Color(0xffffd659);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: chirpYellow,
        title: const Text("Test Chirp send data by sound",
            style: TextStyle(fontFamily: 'MarkPro')),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(
                height: 300.0,
                fit: BoxFit.cover,
                image: new AssetImage('images/chirp_logo.png')),
            Text('$_chirpVersion\n', textAlign: TextAlign.center),
            Text('$_chirpState\n', textAlign: TextAlign.center),
            Text('$_chirpData\n',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold)),
            RaisedButton(
              child: Text('SEND', style: TextStyle(fontFamily: 'MarkPro')),
              color: chirpYellow,
              onPressed: _sendRandomPayload,
            ),
            RaisedButton(
              child: Text(_startStopBtnText,
                  style: TextStyle(fontFamily: 'MarkPro')),
              color: chirpYellow,
              onPressed: _startStopSDK,
            ),
            Text('$_chirpErrors\n',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.red)),
          ],
        ),
      ),
    );
  }
}
