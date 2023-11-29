import 'dart:io';

import 'package:acetaxiscamberley/NoInternetConnectionScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:connectivity/connectivity.dart';

class WebViewPage extends StatefulWidget {
  WebViewPage({super.key});

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  bool isLoading = true;
  bool whatsAppIconVisibility = false;

  @override
  void initState() {
    super.initState();
    checkInternetConnection();
  }

  checkInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      // No internet connection, show error message
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NoInternetConnectionScreen (
          ),
        ),
      );
      Fluttertoast.showToast(
        msg: "No Internet Connection",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        showLogoutAlertDialog(context, "Exit App", "Are you sure to exit the app?");
        return false;
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            children: [
              Container(
                child: WebView(
                  initialUrl: "https://acetaxiscamberley.com",
                  javascriptMode: JavascriptMode.unrestricted,
                  debuggingEnabled: true,
                  onPageFinished: (String url) {
                    // Page has finished loading, hide the progress dialog
                    setState(() {
                      whatsAppIconVisibility = true;
                    });
                    hideCircularProgress();
                  },
                ),
              ),
              if (isLoading)
                Center(
                  child: CircularProgressIndicator(
                    color: Colors.amber,
                  ),
                ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        openWhatsAppLink();
                      },
                      child: Visibility(
                        visible: whatsAppIconVisibility,
                        child: Container(
                          margin: EdgeInsets.only(bottom: 18),
                          height: 60,
                          width: 60,
                          child: Image.asset("assets/whatsapp.png"),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  showLogoutAlertDialog(BuildContext context, String title, String message) {
    //Set Button
    Widget okbtn = TextButton(
      onPressed: () {
        if (Platform.isAndroid) {
          SystemNavigator.pop();
        } else if (Platform.isIOS) {
          exit(0);
        }
      },
      style: TextButton.styleFrom(
        backgroundColor: Colors.green,
      ),
      child: const Text("Yes", style: TextStyle(color: Colors.white)),
    );
//Set Button
    Widget cancelbtn = TextButton(
      child: Text("No", style: TextStyle(color: Colors.white)),
      onPressed: () {
        Navigator.pop(context);
      },
      style: TextButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.deepOrange,
      ),
    );

    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.black,
      title: Text(
        title,
        style: const TextStyle(
            color: Colors.amber,
            fontSize: 16,
            fontWeight: FontWeight.bold
        ),
      ),
      content: Text(
        message,
        style: const TextStyle(fontSize: 20, color: Colors.white),
      ),
      actions: [
        cancelbtn,
        okbtn,
      ],
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        });
  }

  void hideCircularProgress() {
    setState(() {
      isLoading = false;
    });
  }

  Future<void> openWhatsAppLink() async {
    final String whatsappLink = "https://api.whatsapp.com/send/?phone=447778228427";
    try {
      await launch(whatsappLink);
    } catch (e) {
      print("Error launching WhatsApp link: $e");
    }
  }
}
