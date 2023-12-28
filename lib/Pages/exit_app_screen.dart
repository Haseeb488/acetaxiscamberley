import 'dart:io';
import 'package:acetaxiscamberley/Pages/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ExitAppScreen extends StatefulWidget {
  const ExitAppScreen({super.key});

  @override
  State<ExitAppScreen> createState() => _ExitAppScreenState();
}

class _ExitAppScreenState extends State<ExitAppScreen> {


  @override
  void initState() {
    // TODO: implement initState
    Future<void> delayedFunction() async {
    _showLogoutDialog(context);
      // Your function logic here
      print("Executed after 1 seconds");
    }

    Future.delayed(const Duration(milliseconds:300), delayedFunction);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black87,
      child: SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: Center(
                child: Text(
                  "Exit App",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              backgroundColor: Colors.black,
              automaticallyImplyLeading: false,
            ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.black87, Colors.orange],
            ),
          ),
        ),
          ),
      ),
    );

  }

  void _showLogoutDialog(BuildContext context) {
    showLogoutAlertDialog(
      context,
      "Exit App",
      "Are you sure to exit the app?",
    );
  }

  showLogoutAlertDialog(BuildContext context, String title, String message) {
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

    Widget cancelbtn = TextButton(
      child: Text("No", style: TextStyle(color: Colors.white)),
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) =>Home()));
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
            color: Colors.amber, fontSize: 16, fontWeight: FontWeight.bold),
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
      },
    );
  }
}
