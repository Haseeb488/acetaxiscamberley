import 'package:acetaxiscamberley/Pages/home.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class NoInternetConnectionScreen extends StatefulWidget {
  const NoInternetConnectionScreen({super.key});

  @override
  State<NoInternetConnectionScreen> createState() => _NoInternetConnectionScreenState();
}

class _NoInternetConnectionScreenState extends State<NoInternetConnectionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold (
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container (
            child: Image.asset("assets/noInternet.gif"),
          ),

          Container(
            margin: EdgeInsets.only(top: 300),
            child: ElevatedButton(
              onPressed: () {
                checkInternetConnection();
              },
              child: Text("Try Again"),

            ),

          )

        ],
      ),
    );
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
    else
      {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Home (
            ),
          ),
        );
      }
  }
}
