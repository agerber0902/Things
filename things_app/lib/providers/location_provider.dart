import 'package:flutter/material.dart';
import 'package:google_place/google_place.dart';
import 'package:things_app/models/thing_location.dart';

//final String API_KEY = 'AIzaSyBbJiOdFcwZoGuTc7L9B2pMlFpGaTBnoF0';

class LocationProvider extends ChangeNotifier {
  ThingLocation? _location;
  ThingLocation? get location => _location;

  void setLocation(DetailsResult? detailResult) {  
    // if(!validateDetailsResult()){
    //   return;
    // }

    if(detailResult == null){
      _location = null;
      notifyListeners();
      return;
    }

    _location = ThingLocation(
        name: detailResult.name,
        latitude: detailResult.geometry!.location!.lat ?? 0,
        longitude: detailResult.geometry!.location!.lng ?? 0,
        address: detailResult.formattedAddress ?? '');
    
    notifyListeners();
  }
  
  void setLocationForEdit(ThingLocation? thingLocation){
    _location = thingLocation;
    notifyListeners();
  }

  void clearLocation(){
    _location = null;
    notifyListeners();
  }

  String get locationImage {
    
    final lat = location!.latitude;
    final lng = location!.longitude;
    return "https://maps.googleapis.com/maps/api/staticmap?center=$lat,$lng&zoom=16&size=600x300&maptype=roadmap&markers=color:blue%7Clabel:S%7C$lat,$lng&markers=color:green%7Clabel:G%7C40.711614,-74.012318&markers=color:red%7Clabel:C%7C40.718217,-73.998284&key=AIzaSyBbJiOdFcwZoGuTc7L9B2pMlFpGaTBnoF0";
  }
  

  DetailsResult? _detailsResult;
  DetailsResult? get detailsResult => _detailsResult;
  bool get detailsResultIsNotNull => _detailsResult != null;
  bool get detailsResultHasGeometry => detailsResultIsNotNull && _detailsResult!.geometry != null;
  bool get detailsResultHasLocation => detailsResultHasGeometry && _detailsResult!.geometry!.location != null;

  void setDetailsResult(String placeId, GooglePlace googlePlace) async{
    final details = await googlePlace.details.get(placeId);

    if (details != null && details.result != null){
      _detailsResult = details.result;
    }
  }

  bool validateDetailsResult(){
    if(!detailsResultIsNotNull){
      return false;
    }
    if(!detailsResultHasGeometry){
      return false;
    }
    if(!detailsResultHasLocation){
      return false;
    }
    return true;
  }

}
