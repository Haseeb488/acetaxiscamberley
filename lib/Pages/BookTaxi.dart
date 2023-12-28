import 'package:acetaxiscamberley/Pages/assistant_methods.dart';
import 'package:acetaxiscamberley/Pages/confirmationScreen.dart';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import '../progress_dialog.dart';
import 'NoInternetConnectionScreen.dart';

class TaxiBookingForm extends StatefulWidget {
  @override
  _TaxiBookingFormState createState() => _TaxiBookingFormState();
}

class _TaxiBookingFormState extends State<TaxiBookingForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passengersController = TextEditingController();
  final TextEditingController _dropOffAddressController =
      TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  String pickUpLocationText = "Pickup Address";
  String dropOffLocationText = "DropOff Address";

  String selectedPickUpLocation = "";
  String selectedDropOffLocation = "";

  Position? _position;

  DateTime _pickupDate = DateTime.now();
  TimeOfDay _pickupTime = TimeOfDay.now();

  String locationSelected = "Select Current Location";

  String completeAddress = "";

  String name = "";
  String telephone = "";
  String email = "";
  String numberOfPassengers = "";
  String pickUpLocation = "";

  bool pickUpLocationErrorVisibility = false;
  bool dropOffLocationErrorVisibility = false;
  bool paymentTypeErrorVisibility = false;
  bool jobTypeErrorVisibility = false;

  String? selectedPaymentType;
  String? selectedJobType;

  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your name';
    }
    return null;
  }

  String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your phone number';
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Please enter your email';
    if (!RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(value)) {
      return 'Invalid email format';
    }
    return null;
  }

  String? validatePassengers(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the number of passengers';
    }
    if (int.tryParse(value) == null || int.tryParse(value)! <= 0) {
      return 'Please enter a valid number of passengers';
    }
    return null;
  }

  String? validateDropOffAddress(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your drop-off address';
    }
    return null;
  }

/*
  showBookingConfirmationDialog(BuildContext context, String title, String message) {
    Widget okbtn = TextButton(
      onPressed: () {

      },
      style: TextButton.styleFrom(
        backgroundColor: Colors.green,
      ),
      child: const Text("Confirm Booking", style: TextStyle(color: Colors.white)),
    );

    Widget cancelbtn = TextButton(
      child: Text("Cancel", style: TextStyle(color: Colors.white)),
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
        style: const TextStyle(fontSize: 15, color: Colors.white),
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
*/

  showBookingConfirmationDialog(
      BuildContext context, String title, String message) {
    Widget okbtn = TextButton(
      onPressed: () {
        sendEmail();
        // Add your logic here for Confirm Booking
      },
      style: TextButton.styleFrom(
        backgroundColor: Colors.green,
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(8.0), // Adjust the radius as needed
        ),
      ),
      child:
          const Text("Confirm Booking", style: TextStyle(color: Colors.white)),
    );

    Widget cancelbtn = TextButton(
      child: Text("Cancel", style: TextStyle(color: Colors.white)),
      onPressed: () {
        Navigator.pop(context);
      },
      style: TextButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.deepOrange,
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(8.0), // Adjust the radius as needed
        ),
      ),
    );

    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.black,
      title: Center(
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.amber,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      content: Text(
        message,
        style: const TextStyle(fontSize: 15, color: Colors.white),
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

  @override
  void initState() {
    // TODO: implement initState
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top]);
    checkInternetConnection();
    super.initState();
  }

  checkInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      // No internet connection, show error message
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NoInternetConnectionScreen(),
        ),
      );
    }
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
                'Taxi Booking Form',
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
            child: Padding(
              padding: EdgeInsets.only(left: 16.0, right: 16, top: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.only(
                    // Set the circular radius
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: TextFormField(
                              controller: _nameController,
                              keyboardType: TextInputType.name,
                              textInputAction: TextInputAction.next,
                              validator: validateName,
                              style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 18,
                                  fontFamily: "Georgia"),
                              decoration: InputDecoration(
                                labelText: 'Your Name*',
                                labelStyle: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 20,
                                    fontFamily: 'Georgia'
                                ),

                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(
                                      color:
                                          Colors.red), // Set the border color
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(
                                      color: Colors
                                          .orange), // Set the border color for enabled state
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(
                                      color: Colors
                                          .green), // Set the border color for focused state
                                ),
                                fillColor: Colors.white12,
                                filled: true,
                              ),
                              autofillHints: [AutofillHints.name],
                            ),
                          ),

                          SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: TextFormField(
                              textInputAction: TextInputAction.next,
                              controller: _phoneController,
                              validator: validatePhone,
                              style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 18,
                                  fontFamily: "Georgia"),
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                labelText: 'Telephone*',
                                labelStyle: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 20,
                                    fontFamily: 'Georgia'),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(
                                      color:
                                          Colors.red), // Set the border color
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(
                                      color: Colors
                                          .orange), // Set the border color for enabled state
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(
                                      color: Colors
                                          .green), // Set the border color for focused state
                                ),
                                fillColor: Colors.white12,
                                filled: true,
                              ),
                            ),
                          ),

                          SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: TextFormField(
                              textInputAction: TextInputAction.next,
                              controller: _emailController,
                              validator: validateEmail,
                              style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 18,
                                  fontFamily: "Georgia"),
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                labelText: 'Email*',
                                labelStyle: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 20,
                                    fontFamily: 'Georgia'),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(
                                      color:
                                          Colors.red), // Set the border color
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(
                                      color: Colors
                                          .orange), // Set the border color for enabled state
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(
                                      color: Colors
                                          .green), // Set the border color for focused state
                                ),
                                fillColor: Colors.white12,
                                filled: true,
                              ),
                            ),
                          ),

                          SizedBox(height: 10),

                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: TextFormField(
                              textInputAction: TextInputAction.next,
                              controller: _passengersController,
                              validator: validatePassengers,
                              style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 18,
                                  fontFamily: "Georgia"),
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: 'Total Number of Passengers*',
                                labelStyle: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 18,
                                    fontFamily: 'Georgia'),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(
                                      color:
                                          Colors.red), // Set the border color
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(
                                      color: Colors
                                          .orange), // Set the border color for enabled state
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(
                                      color: Colors
                                          .green), // Set the border color for focused state
                                ),
                                fillColor: Colors.white12,
                                filled: true,
                              ),
                            ),
                          ),

                          SizedBox(height: 10),

                          GestureDetector(
                            onTap: () async {
                              dynamic result = await Navigator.pushNamed(
                                  context, '/PickUpSearchScreen');

                              if (result != null &&
                                  result is Map<String, dynamic>) {
                                String status = result['status'];
                                String selectedLocation =
                                    result['selectedLocation'];
                                // Handle the values as needed

                                // print("status is: "+status);
                                // print("selectedLocation is: "+selectedLocation);

                                if (status == "obtainedPickUp") {
                                  print(
                                      "PickUp location obtained successfully");

                                  setState(() {
                                    if (selectedLocation.length <= 25) {
                                      // If the length is less than or equal to 20, use the whole string
                                      pickUpLocationText = selectedLocation;
                                      pickUpLocation = selectedLocation;
                                    } else {
                                      // If the length is greater than 30, create a substring with the first 30 characters
                                      pickUpLocationText =
                                          selectedLocation.substring(0, 25) +
                                              "...";
                                      pickUpLocation = selectedLocation;
                                    }

                                    pickUpLocationErrorVisibility = false;
                                  });
                                } else {
                                  print("not found " + status.toString());
                                }
                              }
                            },
                            child: Container(
                              height: 60,
                              decoration: BoxDecoration(
                                color: Colors.white24,
                                border: Border.all(color: Colors.orange),
                                // Use Border instead of OutlineInputBorder

                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10.0),
                                  // Set the top-left corner radius
                                  topRight: Radius.circular(10.0),
                                ), // Use Border instead of OutlineInputBorder
                              ),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(10.0),
                                    child: Container(
                                      child: Text(
                                        pickUpLocationText,
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.white70,
                                            fontFamily: "Georgia"),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          InkWell(
                            onTap: () {
                              _getCurrentLocation();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white24,
                                border: Border.all(color: Colors.orange),
                                // Use Border instead of OutlineInputBorder

                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(10.0),
                                  // Set the top-left corner radius
                                  bottomRight: Radius.circular(10.0),
                                ), // Use Border instead of OutlineInputBorder
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 6.0, top: 3.0),
                                child: Text(
                                  "Use my current location",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white70,
                                      fontFamily: "Georgia",
                                      fontSize: 15),
                                ),
                              ),
                            ),
                          ),

                          Visibility(
                            visible: pickUpLocationErrorVisibility,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 9.0, top: 3),
                              child: Text(
                                "Please select pickup Address",
                                style:
                                    TextStyle(color: Colors.red, fontSize: 11),
                              ),
                            ),
                          ),
                          SizedBox(height: 12),

                          GestureDetector(
                            onTap: () async {
                              dynamic result = await Navigator.pushNamed(
                                  context, '/DropOffSearchScreen');

                              if (result != null &&
                                  result is Map<String, dynamic>) {
                                String dropOffStatus = result['DropOffStatus'];
                                String selectedDropOff =
                                    result['selectedDropOff'];
                                // Handle the values as needed

                                // print("status is: "+status);
                                // print("selectedLocation is: "+selectedLocation);

                                if (dropOffStatus == "obtainedDropOff") {
                                  print(
                                      "Drop Off location obtained successfully");

                                  setState(() {
                                    if (selectedDropOff.length <= 25) {
                                      // If the length is less than or equal to 20, use the whole string
                                      dropOffLocationText = selectedDropOff;
                                      selectedDropOffLocation = selectedDropOff;
                                    } else {
                                      // If the length is greater than 30, create a substring with the first 30 characters
                                      dropOffLocationText =
                                          selectedDropOff.substring(0, 25) +
                                              "...";
                                      selectedDropOffLocation = selectedDropOff;
                                    }
                                    dropOffLocationErrorVisibility = false;
                                  });
                                } else {
                                  print("not found " +
                                      selectedDropOff.toString());
                                }
                              }
                            },
                            child: Container(
                              height: 60,
                              decoration: BoxDecoration(
                                color: Colors.white24,
                                border: Border.all(color: Colors.orange),
                                // Use Border instead of OutlineInputBorder
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                              ), // Use Border instead of OutlineInputBorder
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10.0),
                                    child: Center(
                                      child: Text(
                                        dropOffLocationText,
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontFamily: "Georgia",
                                            color: Colors.white70),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          Visibility(
                            visible: dropOffLocationErrorVisibility,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 9.0, top: 3),
                              child: Text(
                                "Please select DropOff Address",
                                style:
                                    TextStyle(color: Colors.red, fontSize: 11),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),

                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white24,
                              border: Border.all(color: Colors.orange),
                              // Use Border instead of OutlineInputBorder
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Date of Travel: ${DateFormat('yyyy-MM-dd').format(_pickupDate)}',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white70,
                                        fontFamily: "Georgia",
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.calendar_today,
                                      color: Colors.white70,
                                    ),
                                    onPressed: () async {
                                      DateTime? pickedDate =
                                          await showDatePicker(
                                        context: context,
                                        initialDate: _pickupDate,
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime.now()
                                            .add(Duration(days: 365)),
                                      );
                                      if (pickedDate != null &&
                                          pickedDate != _pickupDate) {
                                        setState(() {
                                          _pickupDate = pickedDate;
                                        });
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white24,
                              border: Border.all(color: Colors.orange),
                              // Use Border instead of OutlineInputBorder
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Time of Travel: ${_pickupTime.format(context)}',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white70,
                                        fontFamily: "Georgia",
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.access_time,
                                      color: Colors.white70,
                                    ),
                                    onPressed: () async {
                                      TimeOfDay? pickedTime =
                                          await showTimePicker(
                                        context: context,
                                        initialTime: _pickupTime,
                                      );
                                      if (pickedTime != null &&
                                          pickedTime != _pickupTime) {
                                        setState(() {
                                          _pickupTime = pickedTime;
                                        });
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),

// Inside your Column widget, add the following code after the "Time of Travel" TextFormField

                          SizedBox(height: 10),

// Payment Type Dropdown

           Container(
             decoration: BoxDecoration(
               border: Border.all(color: Colors.orange),
               borderRadius: BorderRadius.all(Radius.circular(10.0)),
               color: Colors.white24,
             ),
             child: Padding(
               padding: const EdgeInsets.only(left: 8.0,right: 5.0,top: 5.0,bottom: 5.0),
               child: DropdownButton<String>(
                 value: selectedPaymentType,
                 alignment: Alignment.centerRight, // Align items to the left
                 isExpanded: true,
                 hint: Text(
                   'Select Payment Type*',
                   style: TextStyle(
                     backgroundColor: Colors.red,
                   ),
                 ),
                 underline: Container(),
                 dropdownColor: Colors.black87,
                 items: [
                   // Initial hint item
                   DropdownMenuItem<String>(
                     value: null,
                     child: Text(
                       'Select Payment Type*',
                       style: TextStyle(
                         fontFamily: "Georgia",
                         fontSize: 18,
                         color: Colors.white70,
                       ),
                     ),
                   ),
                   DropdownMenuItem<String>(
                     value: 'Pay in car',
                     child: Padding(
                       padding: EdgeInsets.zero, // No padding
                       child: Container(
                         child: Row(
                           mainAxisAlignment: MainAxisAlignment.start,
                           children: [
                             Text(
                               'Pay in car',
                               style: TextStyle(
                                 fontFamily: "Georgia",
                                 fontSize: 18,
                                 color: Colors.white,
                               ),
                             ),
                           ],
                         ),
                       ),
                     ),
                   ),
                   DropdownMenuItem<String>(
                     value: 'Account',
                     child: Padding(
                       padding: EdgeInsets.zero, // No padding
                       child: Container(
                         child: Row(
                           mainAxisAlignment: MainAxisAlignment.start,
                           children: [
                             Text(
                               'Account',
                               style: TextStyle(
                                 fontFamily: "Georgia",
                                 fontSize: 18,
                                 color: Colors.white,
                               ),
                             ),

                           ],
                         ),
                       ),
                     ),
                   ),
                 ],
                 onChanged: (value) {
                   setState(() {
                     selectedPaymentType = value;
                     paymentTypeErrorVisibility = false;
                   });
                 },
                 icon: Icon(
                   Icons.arrow_drop_down, // Add the dropdown icon
                   color: Colors.white,
                 ),
               ),
             ),
           ),


                          Visibility(
                            visible: paymentTypeErrorVisibility,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 9.0, top: 3),
                              child: Text(
                                "Please Select Payment Type",
                                style:
                                TextStyle(color: Colors.red, fontSize: 11),
                              ),
                            ),
                          ),

                          SizedBox(height: 10),


                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.orange),
                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                              color: Colors.white24,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0,right: 5.0,top: 5.0,bottom: 5.0),
                              child: DropdownButton<String>(
                                value: selectedJobType,
                                alignment: Alignment.centerRight, // Align items to the left
                                isExpanded: true,
                                hint: Text(
                                  'Select Job Type*',
                                  style: TextStyle(
                                    backgroundColor: Colors.red,
                                  ),
                                ),
                                underline: Container(),
                                dropdownColor: Colors.black87,
                                items: [
                                  // Initial hint item
                                  DropdownMenuItem<String>(
                                    value: null,
                                    child: Text(
                                      'Select Job Type*',
                                      style: TextStyle(
                                        fontFamily: "Georgia",
                                        fontSize: 18,
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ),
                                  DropdownMenuItem<String>(
                                    value: 'One Way',
                                    child: Padding(
                                      padding: EdgeInsets.zero, // No padding
                                      child: Container(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              'OneWay',
                                              style: TextStyle(
                                                fontFamily: "Georgia",
                                                fontSize: 18,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  DropdownMenuItem<String>(
                                    value: 'Return',
                                    child: Padding(
                                      padding: EdgeInsets.zero, // No padding
                                      child: Container(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Return',
                                              style: TextStyle(
                                                fontFamily: "Georgia",
                                                fontSize: 18,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    selectedJobType = value;
                                    jobTypeErrorVisibility = false;
                                  });
                                },
                                icon: Icon(
                                  Icons.arrow_drop_down, // Add the dropdown icon
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),

                          Visibility(
                            visible: jobTypeErrorVisibility,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 9.0, top: 3),
                              child: Text(
                                "Please Select Job Type",
                                style:
                                TextStyle(color: Colors.red, fontSize: 11),
                              ),
                            ),
                          ),


                          SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: TextFormField(
                              textInputAction: TextInputAction.next,
                              controller: _notesController,
                              style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 18,
                                  fontFamily: "Georgia"),
                              decoration: InputDecoration(
                                labelText: 'Notes (Luggage, Flight No etc)',
                                labelStyle: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 17,
                                    fontFamily: 'Georgia'),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(
                                      color:
                                          Colors.red), // Set the border color
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(
                                      color: Colors
                                          .orange), // Set the border color for enabled state
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(
                                      color: Colors
                                          .green), // Set the border color for focused state
                                ),
                                fillColor: Colors.white12,
                                filled: true,
                              ),
                            ),
                          ),

                          SizedBox(height: 20),

                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                // Form is valid, perform your action

                                if (pickUpLocationText == "Pickup Address") {
                                  setState(() {
                                    pickUpLocationErrorVisibility = true;
                                  });
                                  return;
                                } else {
                                  setState(() {
                                    pickUpLocationErrorVisibility = false;
                                  });
                                }

                                if (dropOffLocationText == "DropOff Address") {
                                  setState(() {
                                    dropOffLocationErrorVisibility = true;
                                  });
                                  return;
                                }

                                else {
                                  setState(() {
                                    dropOffLocationErrorVisibility = false;
                                  });

                                  if(selectedPaymentType ==null)
                                    {
                                      setState(() {
                                        paymentTypeErrorVisibility = true;
                                      });
                                      return;
                                    }

                                  if(selectedJobType ==null)
                                    {
                                      setState(() {
                                        jobTypeErrorVisibility = true;
                                      });
                                      return;
                                    }
                                  showBookingConfirmationDialog(
                                      context,
                                      "Booking Summary",
                                      "Here is summary of your order\n"
                                          "Pick Up Date: ${DateFormat('dd-MM-yyyy').format(_pickupDate)} \n"
                                          "Pick Up Time: ${_pickupTime.format(context)} \n"
                                          "Pick Up Location: ${pickUpLocationText} \n"
                                          "Drop Off Location: ${dropOffLocationText}");
                                }
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.local_taxi, color: Colors.amber),
                                  // You can change the icon
                                  SizedBox(width: 8.0),
                                  Text(
                                    'Book Taxi Now',
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.amber,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.black,
                              onPrimary: Colors.amber,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> sendEmail() async {
    try {
      showDialog(
        context: context,
        builder: (BuildContext context) => ProgressDialog(
          message: "Booking Confirmation..",
        ),
      );

    name = _nameController.text;
    email = _emailController.text;
    telephone = _phoneController.text;
    numberOfPassengers = _passengersController.text;

      // Make a POST request to your PHP API
      final response = await http.post(
        Uri.parse(
            "https://securenet.justyes.co.uk/Prod/camberfield/sendEmail.php"),
        body: {
          'name': name,
          'telephone': telephone,
          'email': email,
          'numberOfPassengers': numberOfPassengers,
          'pickUpLocation': pickUpLocation,
          'dropOffLocation': selectedDropOffLocation,
          'pickUpDate': DateFormat('yyyy-MM-dd').format(_pickupDate),
          'pickUpTime': _pickupTime.format(context),
          'paymentType': selectedPaymentType,
          'jobType': selectedJobType,
          'notes': _notesController.text,
        },
      );
      // Check the response status code
      if (response.statusCode == 200) {
        // Request was successful
        print('Email sent successfully.');
        addRecordToDatabase();
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ConfirmationScreen(),
          ),
        );
        //
      } else {
        // Request failed
        print('Failed to update attempts. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle any exceptions that may occur
      print('Error: $e');
    }
  }

  Future<void> addRecordToDatabase() async {
    try {
      name = _nameController.text;
      email = _emailController.text;
      telephone = _phoneController.text;
      numberOfPassengers = _passengersController.text;
      // Make a POST request to your PHP API
      final response = await http.post(
        Uri.parse(
            "https://securenet.justyes.co.uk/Prod/camberfield/addRides.php"),
        body: {
          'name': name,
          'telephone': telephone,
          'email': email,
          'numberOfPassengers': numberOfPassengers,
          'pickUpLocation': pickUpLocation,
          'dropOffLocation': selectedDropOffLocation,
          'pickUpDate': DateFormat('yyyy-MM-dd').format(_pickupDate).toString(),
          'pickUpTime': _pickupTime.format(context),
          'paymentType': selectedPaymentType,
          'jobType': selectedJobType,
          'notes': _notesController.text,
        },
      );
      // Check the response status code
      if (response.statusCode == 200) {
        // Request was successful
        print('Data inserted into database successfully.');
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ConfirmationScreen(),
          ),
        );
        //
      } else {
        // Request failed
        print('Failed to update attempts. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle any exceptions that may occur
      print('Error: $e');
    }
  }



  void _getCurrentLocation() async {
    showDialog(
      context: context,
      builder: (BuildContext context) => ProgressDialog(
        message: "Fetching Location..",
      ),
    );

    Position position = await _determinePosition();
    // Get the human-readable address from the coordinates
    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    // Assuming you want to use the first found placemark
    Placemark? firstPlacemark = placemarks.isNotEmpty ? placemarks[0] : null;

    setState(() {
      _position = position;
      locationSelected = firstPlacemark != null
          ? "${firstPlacemark.locality}, ${firstPlacemark.administrativeArea}"
          : "Unknown Location";
    });

    completeAddress =
        await AssistantMethods.searchAddressForGeographicCoOrdinates(
            position!, context);

    // print("Current position: ${_position.toString()}");
    print("Human-readable address: $locationSelected");
    print("Complete address:" + completeAddress);
    setState(() {
      pickUpLocationText = completeAddress.substring(0, 25) + "...";
      pickUpLocation = completeAddress;
      pickUpLocationErrorVisibility = false;
      Navigator.pop(context);
    });
  }

  Future<Position> _determinePosition() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    return await Geolocator.getCurrentPosition();
  }
}

void main() {
  runApp(MaterialApp(
    home: TaxiBookingForm(),
    theme: ThemeData(
      fontFamily: 'Roboto',
    ),
  ));
}
