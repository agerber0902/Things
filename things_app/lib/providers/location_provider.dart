import 'package:flutter/material.dart';
import 'package:location/location.dart';

class LocationProvider extends ChangeNotifier{
  
  // LocationData _locationData;
  // LocationData get locationData => _locationData;

  Location _location = new Location();
  Location get location => _location;
  
}