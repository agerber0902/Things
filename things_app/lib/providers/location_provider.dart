import 'package:flutter/material.dart';
import 'package:things_app/models/thing_location.dart';

final String API_KEY = 'AIzaSyBbJiOdFcwZoGuTc7L9B2pMlFpGaTBnoF0';

class LocationProvider extends ChangeNotifier{

  ThingLocation? _location;
  ThingLocation? get location => _location;

  
}