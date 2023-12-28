import 'package:acetaxiscamberley/Pages/assistant_methods.dart';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../app_info.dart';
import '../golobal.dart';
import '../progress_dialog.dart';
import 'NoInternetConnectionScreen.dart';

class FareCalculatorScreen extends StatefulWidget {
  @override
  _FareCalculatorScreenState createState() => _FareCalculatorScreenState();
}

class _FareCalculatorScreenState extends State<FareCalculatorScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passengersController = TextEditingController();
  final TextEditingController _dropOffAddressController =
  TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  String pickUpLocationText = "Select Pickup Address";
  String dropOffLocationText = "Select DropOff Address";

  String selectedPickUpLocation = "";
  String selectedDropOffLocation = "";

  Position? _position;

  DateTime _pickupDate = DateTime.now();
  TimeOfDay _pickupTime = TimeOfDay.now();

  String locationSelected = "Select Current Location";

  String pickUpLocation = "";

  bool pickUpLocationErrorVisibility = false;
  bool dropOffLocationErrorVisibility = false;
  bool passengersErrorVisibility = false;

  String totalDistance = "";
  String totalTime = "";
  String fareAmount = "";
  bool visibilityStatus = false;


  FocusNode _focusNode = FocusNode();

  late double taxiFare;

  int totalPassengers = 0;

  String totalPassengersText = "Enter Total Passengers";

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
                'Fare Calculator',
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
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(

              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 16.0, right: 16, top: 16),
                    child: Container(

                   //   height: MediaQuery.of(context).size.height-100,
                      decoration: BoxDecoration(
                        color: Colors.black38,
                        borderRadius: BorderRadius.only(
                          // Set the circular radius
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                          bottomLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15),
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
                                      color: Colors.black12,
                                      border: Border.all(color: Colors.orange),
                                      // Use Border instead of OutlineInputBorder

                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10.0),
                                        topRight: Radius.circular(10.0),
                                        bottomRight: Radius.circular(10.0),
                                        bottomLeft: Radius.circular(10.0),
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
                                      color: Colors.black12,
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
                                    color: Colors.black12,
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
                                            'Date of Travel: ${DateFormat(
                                                'yyyy-MM-dd').format(_pickupDate)}',
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
                                    color: Colors.black12,
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
                                            'Time of Travel: ${_pickupTime.format(
                                                context)}',
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

                                SizedBox(height:10,),
                                TextFormField(
                                  focusNode: _focusNode,
                                  controller: _passengersController,
                                  validator: validatePassengers,
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 18,
                                    fontFamily: "Georgia",
                                  ),

                                  keyboardType: TextInputType.number,

                                  decoration: InputDecoration(
                                    hintText: totalPassengersText,
                                    hintStyle: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 18,
                                      fontFamily: 'Georgia',
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical: 10.0,
                                      horizontal: 12.0,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: BorderSide(color: Colors.red),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: BorderSide(color: Colors.orange),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: BorderSide(color: Colors.green),
                                    ),
                                    fillColor: Colors.black45,
                                    filled: true,
                                  ),
                                ),

                                Visibility(
                                  visible: passengersErrorVisibility,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 9.0,top: 3),
                                    child: Text("Please Enter Number of Passengers",
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 13
                                      ),),
                                  ),
                                ),


                                SizedBox(height: 10,),
                                Visibility(
                                  visible: visibilityStatus,
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .spaceEvenly,
                                        children: [
                                          Container(
                                            height: 90,
                                            width: 150,
                                            decoration: BoxDecoration(
                                              border: Border.all(color: Colors.orange),
                                              color: Colors.black45,
                                              borderRadius: BorderRadius.circular(
                                                  15.0), // Adjust the value to change the roundness
                                            ),
                                            child: Align(
                                              alignment: Alignment.topCenter,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 8.0),
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      "Distance",
                                                      style: TextStyle(
                                                          color: Colors.white70,
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 22
                                                      ),
                                                    ),

                                                    SizedBox(height: 8,),
                                                    Text(
                                                      totalDistance,
                                                      style: TextStyle(
                                                          color: Colors.white70,
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 20
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),

                                          Container(
                                            height: 90,
                                            width: 150,
                                            decoration: BoxDecoration(
                                              color: Colors.black54,
                                              border: Border.all(color: Colors.orange),
                                              borderRadius: BorderRadius.circular(
                                                  15.0), // Adjust the value to change the roundness
                                            ),
                                            child: Align(
                                              alignment: Alignment.topCenter,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 8.0),
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      "Time",
                                                      style: TextStyle(
                                                          color: Colors.white70,
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 22
                                                      ),
                                                    ),
                                                    SizedBox(height: 10,),
                                                    Text(
                                                      totalTime,
                                                      style: TextStyle(
                                                          color: Colors.white70,
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 18
                                                      ),
                                                    ),

                                                  ],
                                                ),

                                              ),
                                            ),

                                          ),
                                        ],

                                      ),

                                    ],
                                  ),
                                ),


                                SizedBox(height: 5,),
                                Visibility(
                                  visible: visibilityStatus,
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Container(
                                      height: 90,
                                      width: 200,
                                      decoration: BoxDecoration(
                                        color: Colors.black54,
                                        border: Border.all(color: Colors.orange),
                                        borderRadius: BorderRadius.circular(
                                            15.0), // Adjust the value to change the roundness
                                      ),
                                      child: Align(
                                        alignment: Alignment.topCenter,
                                        child: Padding(
                                          padding: const EdgeInsets.only(top: 8.0),
                                          child: Column(
                                            children: [
                                              Text(
                                                "Estimated Fare",
                                                style: TextStyle(
                                                    color: Colors.white70,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20
                                                ),
                                              ),
                                              SizedBox(height: 5,),
                                              Text(
                                                "£" + fareAmount,
                                                style: TextStyle(
                                                    color: Colors.white70,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 24
                                                ),
                                              ),

                                            ],
                                          ),

                                        ),
                                      ),

                                    ),
                                  ),
                                ),


                                SizedBox(height:20,),

                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      getRideDetails();
                                      // Add your button's onPressed logic here
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.black,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 16.0, vertical: 12.0),
                                      elevation: 4.0, // Adjust the elevation for a subtle shadow
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.currency_pound, color: Colors.amber),
                                        SizedBox(width: 8.0),
                                        Text(
                                          'Calculate Fare',
                                          style: TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.amber,
                                          ),
                                        ),
                                      ],
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }



  bool isChristmasSpecialTime(DateTime currentTime) {
    // Christmas special period: 24th Dec 11:00 PM to 26th Dec 7:30 AM
    DateTime startDateTime = DateTime(currentTime.year, 12, 24, 23, 0);
    DateTime endDateTime = DateTime(currentTime.year, 12, 26, 7, 30);

    // Check if the current time is within the Christmas special period
    return currentTime.isAfter(startDateTime) &&
        currentTime.isBefore(endDateTime);
  }


  bool isNewYearSpecialTime(DateTime currentTime) {
    // New Year's special period: 31st Dec 7:30 PM to 1st Jan 7:30 AM
    DateTime startDateTime = DateTime(currentTime.year, 12, 31, 19, 30);
    DateTime endDateTime = DateTime(currentTime.year + 1, 1, 1, 7, 30);

    // Check if the current time is within the New Year's special period
    return currentTime.isAfter(startDateTime) &&
        currentTime.isBefore(endDateTime);
  }

  bool isNightTime(DateTime selectedDateTime) {
    // DateTime now = DateTime.now();
    // print("here wo go "+now.toString());
    int currentHour = selectedDateTime.hour;

    // Night time is considered between 11:00 PM (23:00) and 7:00 AM (7:00)
    bool isNight = currentHour >= 23 || currentHour < 7;

    // Night time is considered between 7:00 PM  and 7:00 PM (7:00)
    //     bool isNight = currentHour >= 7 || currentHour < 19;
    return isNight;
  }


  bool isSunday() {
    DateTime now = _pickupDate;
    return now.weekday == DateTime.sunday;
  }


  Future<void> getRideDetails() async
  {
    if (pickUpLocationText == "Select Pickup Address") {
      setState(() {
        pickUpLocationErrorVisibility = true;
      });
      return;
    }

    if (dropOffLocationText == "Select DropOff Address") {
      setState(() {
        dropOffLocationErrorVisibility = true;
      });
      return;
    }

    if (_passengersController.text.isEmpty) {
      setState(() {
        passengersErrorVisibility = true;
      });
      return;
    }

    var originPosition = Provider
        .of<AppInfo>(context, listen: false)
        .userPickUpLocation;
    var destinationPosition = Provider
        .of<AppInfo>(context, listen: false)
        .userDropOffLocation;

    var originLatLng = LatLng(
        originPosition!.locationLatitude!, originPosition.locationLongitude!);
    var destinationLatLng = LatLng(destinationPosition!.locationLatitude!,
        destinationPosition.locationLongitude!);

    showDialog(context: context,
      builder: (BuildContext context) =>
          ProgressDialog(message: "Please wait..",),
    );

    var directionsDetailsInfo = await AssistantMethods
        .obtainOriginToDestinationDirectionDetails(
        originLatLng, destinationLatLng);

    print("here is details for directions");
    print(directionsDetailsInfo!.distance_text.toString());
    print(directionsDetailsInfo!.duration_text);


    totalPassengers = int.parse(_passengersController.text.trim().toString());

    setState(() {
      passengersErrorVisibility = false;

      totalDistance = directionsDetailsInfo!.distance_text.toString();
      totalTime = directionsDetailsInfo!.duration_text.toString();


// Remove non-numeric characters from the distance string
      String numericValueString = totalDistance.replaceAll(
          RegExp(r'[^0-9.]'), '');

// Convert the numeric string to a double
      double distanceValue = double.tryParse(numericValueString) ?? 0.0;

      print("total distance: " + totalDistance);

// Multiply the distance value by 2

      double totalDistanceInMiles = (distanceValue * 0.621371);


      totalDistance = totalDistanceInMiles.toStringAsFixed(2) + " mi";


      print("total distance in miles " + totalDistanceInMiles.toString());

      double extraPassengerCharges = 0.0;


      _focusNode.unfocus();


      DateTime combinedDateTime = DateTime(
        _pickupDate.year,
        _pickupDate.month,
        _pickupDate.day,
        _pickupTime.hour,
        _pickupTime.minute,
      );

      if (isChristmasSpecialTime(combinedDateTime)) {
        print("today is christmas");

        if (totalPassengers >= 5 && totalPassengers <= 6) {
          extraPassengerCharges = 5.0;
        }

        if (totalPassengers > 6) {
          extraPassengerCharges = 10.0;
        }

        double christmasTimeTaxiFare = 9.20 + extraPassengerCharges;
        double christmasTimePerMileFare = 6.40;

        fareAmount = (christmasTimeTaxiFare +
            (totalDistanceInMiles * christmasTimePerMileFare)).toStringAsFixed(
            2);

        print("Fare amount: " + fareAmount);
        visibilityStatus = true;
        return;
      }

      if (isNewYearSpecialTime(combinedDateTime)) {
        print(("Today is new year"));

        if (totalPassengers >= 5 && totalPassengers <= 6) {
          extraPassengerCharges = 5.0;
        }

        if (totalPassengers > 6) {
          extraPassengerCharges = 10.0;
        }


        double newYearTaxiFare = 9.20 + extraPassengerCharges;
        double newYearPerMileFare = 6.40;
        fareAmount =
            (newYearTaxiFare + (totalDistanceInMiles * newYearPerMileFare))
                .toStringAsFixed(2);
        print("Fare amount: " + fareAmount);
        visibilityStatus = true;
        return;
      }

      if (isSunday()) {
        print("today is Sunday");

        if (totalPassengers >= 5 && totalPassengers <= 6) {
          extraPassengerCharges = 5.0;
        }

        if (totalPassengers > 6) {
          extraPassengerCharges = 10.0;
        }

        double taxiFare = 5.8 + extraPassengerCharges;
        double farePerMile = 4.00;
        fareAmount = (taxiFare + (totalDistanceInMiles * farePerMile))
            .toStringAsFixed(2);
        print("Fare amount: " + fareAmount);

        visibilityStatus = true;
        return;
      }

      if (isNightTime(combinedDateTime)) {
        print("it is night time");

        if (totalPassengers >= 5 && totalPassengers <= 6) {
          extraPassengerCharges = 5.0;
        }

        if (totalPassengers > 6) {
          extraPassengerCharges = 10.0;
        }

        double nightTimeTaxiFare = 6.90 + extraPassengerCharges;
        double nightTimePerMileFare = 4.60;

        fareAmount =
            (nightTimeTaxiFare + (totalDistanceInMiles * nightTimePerMileFare))
                .toStringAsFixed(2);
        print("Fare amount: " + fareAmount);
        visibilityStatus = true;
        return;
      }

      else {
        print("total passengers " + totalPassengers.toString());


        if (totalPassengers >= 5 && totalPassengers <= 6) {
          extraPassengerCharges = 5.0;
        }

        if (totalPassengers > 6) {
          extraPassengerCharges = 10.0;
        }

        taxiFare = 4.60 + extraPassengerCharges;
        double dayTimePerMileFare = 3.30;
        print("It is day time");

        fareAmount = (taxiFare + (totalDistanceInMiles * dayTimePerMileFare))
            .toStringAsFixed(2);
        print("Fare amount: " + fareAmount);
      }

      tripDirectionDetailsInfo = directionsDetailsInfo;

      visibilityStatus = true;
    });

    Navigator.pop(context);
  }


  void main() {
    runApp(MaterialApp(
      home: FareCalculatorScreen(),
      theme: ThemeData(
        fontFamily: 'Roboto',
      ),
    ));
  }
}
