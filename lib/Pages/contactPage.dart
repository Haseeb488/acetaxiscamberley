import 'dart:io';

import 'package:acetaxiscamberley/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactPage extends StatefulWidget {
  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        showLogoutAlertDialog(
            context, "Exit App", "Are you sure to exit the app?");
        return false;
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black87, Colors.orange],
          ),
        ),
        child: SafeArea(
          child: Scaffold(
            appBar: AppBar(
              title: Center(
                child: Text(
                  "Contact Us",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              backgroundColor: Colors.black,
              automaticallyImplyLeading: false,
            ),
            backgroundColor: Colors.black54,
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     _buildContactSection(
                      title: 'Office Address',
                      icon: Icons.location_on,
                      iconColor: Colors.deepOrangeAccent,
                      content: '4 Winding Wood Drive\nFrimley Surrey GU15 1EP',
                    ),
                    SizedBox(height: 5),
                    _buildContactSection(
                      title: 'Phone Number',
                      icon: Icons.phone,
                      iconColor: Colors.green,
                      content: '(+44)1276 685000',
                      onTap: () => launch('tel:+44127685000'),
                    ),

                    SizedBox(height: 5),
                    _buildContactSection(
                      title: 'WhatsApp Number',
                      icon: MyFlutterApp.whatsapp,
                      iconColor: Colors.green,
                      content: '(+44)7778228427',
                      onTap: () => launch('https://wa.me/447778228427'),
                    ),
                    SizedBox(height: 5),
                    _buildContactSection(
                      title: 'Email Address',
                      icon: Icons.email,
                      iconColor: Colors.yellow.shade800,
                      content: 'bookings@acetaxiscamberley.com',
                      onTap: () =>
                          launch('mailto:bookings@acetaxiscamberley.com'),
                    ),
                    SizedBox(height: 5),
                    _buildContactSection(
                      title: 'Website',
                      icon: Icons.link,
                      iconColor: Colors.blue,
                      content: 'https://acetaxiscamberley.com',
                      onTap: () => launch('https://acetaxiscamberley.com'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
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

  Widget _buildContactSection({
    required String title,
    required IconData icon,
    Color iconColor = Colors.grey,
    required String content,
    VoidCallback? onTap,
  }) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.black38,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        children: [
          Icon(icon, size: 24.0, color: iconColor),
          SizedBox(width: 10.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white70,
                  ),
                ),
                SizedBox(height: 5.0),
                if (onTap != null)
                  InkWell(
                    onTap: onTap,
                    child: Text(
                      content,
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                if (onTap == null)
                  InkWell(
                    onTap: () => launch(content),
                    child: Text(
                      content,
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.grey[600],
                        // Change this color to match the others
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
