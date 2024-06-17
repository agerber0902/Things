import 'package:flutter/material.dart';
import 'package:location/location.dart';

class LocationModal extends StatefulWidget {
  const LocationModal({super.key});

  @override
  State<LocationModal> createState() => _LocationModalState();
}

class _LocationModalState extends State<LocationModal> {
  Location? _selectedLocation;
  bool isGettingLocation = false;

  void getCurrentLocation() async {
    Location location = new Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData _locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    //set loading
    setState(() {
      isGettingLocation = true;
    });
    
    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
    print(_locationData.latitude);

    //set loading
    setState(() {
      isGettingLocation = false;
    });
  }

  @override
  Widget build(BuildContext context) {

    Widget previewContent = Text('No Location Choosen.');

    if(isGettingLocation){
      previewContent = CircularProgressIndicator();
    }

    return AlertDialog(
      content: Column(
        children: [
          Container(
            alignment: Alignment.center,
            width: 170,
            //TODO: style this
            child: previewContent,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton.icon(
                onPressed: getCurrentLocation,
                //TODO: remove current location
                label: const Text('Current Location'),
                icon: const Icon(Icons.location_on),
              ),
              TextButton.icon(
                onPressed: () {},
                //TODO:
                label: const Text('Select on Map'),
                icon: const Icon(Icons.map),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
