library secqure_flutter_sdk;

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:flutter/services.dart';

class SecqureAuth extends StatefulWidget {
  const SecqureAuth({Key? key, required this.keyId, required this.secretId}) : super(key: key);
  final String keyId, secretId;

  @override
  _SecqureAuthState createState() => _SecqureAuthState();
}

Future<dynamic> login(String pubKey, String refreshToken, String keyId, String userId) async {

  final uri = Uri.parse('https://api.secuuth.io/auth/renewTokens');

  Map<String, String> headers = {
    "keyId": keyId,
    'Content-type': 'application/json',
    'Accept': 'application/json',
  };

  Map<dynamic, dynamic> body = {
    "refreshToken": refreshToken,
    "publicKey": pubKey,
    "userSubId": userId,
    "renewRefreshToken": false,
  };

  var response = await http
      .post(
      uri,
      headers: headers,
      body: jsonEncode(body)
  );

  return response;
}

class _SecqureAuthState extends State<SecqureAuth> {

  final storage = new FlutterSecureStorage();
  final Completer<WebViewController> _controller = Completer<WebViewController>();

  @override
  Widget build(BuildContext context) => WillPopScope(
      onWillPop: () async{
        return true;
      },
      child:Scaffold(
        body: WebView(
          javascriptMode: JavascriptMode.unrestricted,
          initialUrl: 'https://test-api.secuuth.io/auth/getLoginWebview/?keyId=${widget.keyId}&profileName=Default&clientType=Flutter&secretKey=${widget.secretId}',
          onWebViewCreated: (WebViewController webViewController) {
            _controller.complete(webViewController);
            final cookieManager = CookieManager();
            cookieManager.clearCookies();
          },
          javascriptChannels: {
            JavascriptChannel(
                name: 'JavascriptChannel',
                onMessageReceived: (payload) async {
                  print('Javascript: "${payload.message}" ');

                  // await storage.deleteAll();
                  await storage.write(key: 'SecqureRefreshToken', value: payload.message);
                  await storage.write(key: 'SecqureUserPubKey', value: payload.message);
                  await storage.write(key: 'SecqureUserId', value: payload.message);

                  String? refreshToken = await storage.read(key: 'SecqureRefreshToken');
                  String? pubKey = await storage.read(key: 'SecqureUserPubKey');
                  String? userId = await storage.read(key: 'SecqureUserId');



                  if (refreshToken != null && pubKey != null && userId != null) {
                    try{
                      var token = login(pubKey, refreshToken, widget.keyId, userId);
                      return token;
                    }
                    catch (err){
                        throw Exception(err);
                    }
                  }
                }
            ),
          },
          gestureNavigationEnabled: true,
          backgroundColor: const Color(0x00000000),
        ),
      )
  );
}


