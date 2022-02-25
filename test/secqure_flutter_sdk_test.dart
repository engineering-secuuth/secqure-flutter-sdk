library secqure_flutter_sdk;

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecuuthAuth extends StatefulWidget {
  const SecuuthAuth({Key? key, required this.keyId, required this.secretId}) : super(key: key);
  final String keyId, secretId;

  @override
  _SecuuthAuthState createState() => _SecuuthAuthState();
}

class _SecuuthAuthState extends State<SecuuthAuth> {

  late WebViewPlusController controller;
  final storage = new FlutterSecureStorage();

  @override
  Widget build(BuildContext context) => WillPopScope(
      onWillPop: () async{
        return true;
      },
      child:Scaffold(
        body: WebViewPlus(
          javascriptMode: JavascriptMode.unrestricted,
          initialUrl: 'https://test-api.secuuth.io/auth/getLoginWebview/?keyId=${widget.keyId}&profileName=Default&clientType=Flutter&secretKey=${widget.secretId}',
          onWebViewCreated: (controller){
            this.controller = controller;
          },
          javascriptChannels: {
            JavascriptChannel(
                name: 'JavascriptChannel',
                onMessageReceived: (message) async {
                  print('Javascript: "${message.message}" ');
                  // secureStorage.writeSecureData('token', message.toString());
                  await storage.write(key: 'token', value: message.message);
                  String? value = await storage.read(key: 'token');
                  await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        content: Text(
                          value.toString(),
                          style: TextStyle(fontSize: 16),
                        ),
                        actions: [
                          TextButton(
                            child: Text('OK'),
                            onPressed: () => Navigator.pop(context),
                          )
                        ],
                      )
                  );
                }
            )
          },
        ),
      )
  );
}