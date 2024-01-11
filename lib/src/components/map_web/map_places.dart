import 'package:benji/src/providers/keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places_web/flutter_google_places_web.dart';

const kGoogleApiKey = googlePlacesApiKey;

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  String test = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Container(
          padding: const EdgeInsets.only(top: 150),
          width: 500,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text(
                'Address autocomplete',
              ),
              FlutterGooglePlacesWeb(
                apiKey: kGoogleApiKey,
                proxyURL: 'https://cors-anywhere.herokuapp.com/',
                required: true,
              ),
              TextButton(
                onPressed: () {
                  print(FlutterGooglePlacesWeb.value[
                      'name']); // '1600 Amphitheatre Parkway, Mountain View, CA, USA'
                  print(FlutterGooglePlacesWeb
                      .value['streetAddress']); // '1600 Amphitheatre Parkway'
                  print(FlutterGooglePlacesWeb.value['city']); // 'CA'
                  print(FlutterGooglePlacesWeb.value['country']);
                  setState(() {
                    test = FlutterGooglePlacesWeb.value['name'] ?? '';
                  });
                },
                child: const Text('Press to test'),
              ),
              Text(test),
            ],
          ),
        ),
      ),
    );
  }
}
