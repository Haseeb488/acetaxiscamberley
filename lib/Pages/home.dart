import 'package:acetaxiscamberley/Pages/BookTaxi.dart';
import 'package:acetaxiscamberley/Pages/exit_app_screen.dart';
import 'package:acetaxiscamberley/Pages/fareCalculator.dart';
import 'package:flutter/material.dart';
import 'contactPage.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home>


{
  int currentTab =0;
  final List<Widget> screens = [
    FareCalculatorScreen(),
    TaxiBookingForm(),
    ContactPage(),
    ExitAppScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: screens[currentTab],
      bottomNavigationBar: BottomNavigationBar(
         iconSize: 27,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.black87, // Set the background color here
        selectedItemColor: Colors.orangeAccent,
        unselectedItemColor: Colors.grey,

        currentIndex: currentTab,
        onTap: (index) {
          setState(() {
            currentTab = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.currency_pound),
            label: 'Est Fare Calculator',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_taxi),
            label: 'Book Ride',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.call),
            label: 'Contact',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.exit_to_app),
            label: 'Exit',
          ),
        ],
      ),
    );
  }
}
