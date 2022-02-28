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
                onMessageReceived: (payload) async {
                  // print('Javascript: "${payload.message}" ');

                  await storage.write(key: 'SecqureRefreshToken', value: payload.message);
                  await storage.write(key: 'SecqureUserPubKey', value: payload.message);
                  await storage.write(key: 'SecqureUserId', value: payload.message);

                  String? refreshToken = await storage.read(key: 'SecqureRefreshToken');
                  String? pubKey = await storage.read(key: 'SecqureUserPubKey');
                  String? userId = await storage.read(key: 'SecqureUserId');

                  if (refreshToken != null && pubKey != null && userId != null) {
                    try{
                      final uri = Uri.parse('https://api.secuuth.io/auth/renewTokens');
                      Map<String, String> headers = {"Accept": 'application/json', "Content-type": "application/json", "keyId": widget.keyId};
                      Map<dynamic, dynamic> JsonBody = {
                        "refreshToken": refreshToken,
                        "publicKey": pubKey,
                        "userSubId": userId,
                        "renewRefreshToken": false,
                      };

                      http.Response tokens = await http.post(uri, headers: headers, body: JsonBody);
                      String res = tokens.toString();
                    }
                    catch (e) {
                      throw Exception(e);
                    }
                  }
                }
            )
          },
        ),
      )
  );
}



//           javascriptChannels: {
//             JavascriptChannel(
//                 name: 'JavascriptChannel',
//                 onMessageReceived: (message) async {
//                   print('Javascript: "${message.message}" ');
//                   await storage.write(key: 'token', value: message.message);
//                   String? value = await storage.read(key: 'token');
//                 }
//             )
