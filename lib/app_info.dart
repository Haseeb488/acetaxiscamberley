
import 'package:flutter/cupertino.dart';
import 'Pages/directions.dart';

class AppInfo extends ChangeNotifier {
  Directions? userPickUpLocation,userDropOffLocation;


  void updatePickUpLocationAddress(Directions userPickUpAddress) {
    userPickUpLocation = userPickUpAddress;
    notifyListeners();
  }

  void updateDropOffLocationAddress(Directions dropOffAddress) {
    userDropOffLocation = dropOffAddress;
    notifyListeners();
  }

}
