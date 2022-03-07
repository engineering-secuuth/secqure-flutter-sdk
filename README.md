<!-- 
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages). 

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages). 
-->

SecQure Passwordless Library For Validate Auth Token - Email Magiclink, SMS OTP

## Features

Passwordless Login and Custom Branding
Make users login smooth and secure with emailed magic links.

## Getting started

TODO: List prerequisites and provide or point to information on how to
start using the package.

## Usage

TODO: Include short and useful examples for package users. Add longer examples
to `/example` folder. 

```dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:secqure_flutter_sdk/secqure_flutter_sdk.dart';

void main() {
  runApp(const MaterialApp(
    title: 'Navigation Basics',
    home: FirstRoute(),
  ));
}

class FirstRoute extends StatelessWidget {
  const FirstRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('First Route'),
        backgroundColor: Colors.pink,
      ),
      body: Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.pink, // background
            onPrimary: Colors.white, // foreground
          ),
          child: const Text('Sign in'),
          onPressed: () {
            Navigator.push(
              context,
              //Replace placeholders with your API key and Secret key from dashboard
                MaterialPageRoute(builder: (context) => const SecqureAuth(keyId: 'XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXX', secretId: 'XXXXXXXXXX')),
            );
          },
        ),
      ),
    );
  }
}

```

