import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_place/google_place.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:things_app/models/thing_location.dart';

class LocationModal extends StatefulWidget {
  const LocationModal({super.key});

  @override
  State<LocationModal> createState() => _LocationModalState();
}

class _LocationModalState extends State<LocationModal> {
  TextEditingController _controller = TextEditingController();
  late GooglePlace googlePlace;
  List<AutocompletePrediction> predictions = [];
  ThingLocation? _selectedLocation;
  bool isGettingLocation = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    googlePlace = GooglePlace('AIzaSyBbJiOdFcwZoGuTc7L9B2pMlFpGaTBnoF0');
  }

  autoCompleteSearch(String value) async{
    var result = await googlePlace.autocomplete.get(value);

    if(result != null && result.predictions != null){
      print(result.predictions!.first.description);
      setState(() {
        predictions = result.predictions!;
      });
    }
  }

  void getCurrentLocation() async {
    // Location location = new Location();

    // bool serviceEnabled;
    // PermissionStatus permissionGranted;
    // LocationData _locationData;

    // serviceEnabled = await location.serviceEnabled();
    // if (!serviceEnabled) {
    //   serviceEnabled = await location.requestService();
    //   if (!serviceEnabled) {
    //     return;
    //   }
    // }

    // //set loading
    // setState(() {
    //   isGettingLocation = true;
    // });

    // permissionGranted = await location.hasPermission();
    // if (permissionGranted == PermissionStatus.denied) {
    //   permissionGranted = await location.requestPermission();
    //   if (permissionGranted != PermissionStatus.granted) {
    //     return;
    //   }
    // }

    // _locationData = await location.getLocation();
    // print(_locationData.latitude);

    // //set loading
    // setState(() {
    //   isGettingLocation = false;
    // });

    // if (_locationData.latitude == null || _locationData.longitude == null) {
    //   return;
    // }

    // final url = Uri.parse(
    //     'https://maps.googleapis.com/maps/api/geocode/json?latlng=${_locationData.latitude},${_locationData.longitude}&key=AIzaSyBbJiOdFcwZoGuTc7L9B2pMlFpGaTBnoF0');

    // //get location
    // final response = await http.get(url);

    // //decode
    // final data = json.decode(response.body);

    // final address = data['results'][0]['formatted_address'];

    // setState(() {
    //   _selectedLocation = ThingLocation(
    //       latitude: _locationData.latitude!,
    //       longitude: _locationData.longitude!,
    //       address: address);
    // });
  }

  String get locationImage {
    final lat = _selectedLocation!.latitude;
    final lng = _selectedLocation!.longitude;
    return "https://maps.googleapis.com/maps/api/staticmap?center=$lat,$lng&zoom=16&size=600x300&maptype=roadmap&markers=color:blue%7Clabel:S%7C$lat,$lng&markers=color:green%7Clabel:G%7C40.711614,-74.012318&markers=color:red%7Clabel:C%7C40.718217,-73.998284&key=AIzaSyBbJiOdFcwZoGuTc7L9B2pMlFpGaTBnoF0";
  }

  @override
  Widget build(BuildContext context) {
    Widget previewContent = Text('No Location Choosen.');

    if (_selectedLocation != null) {
      previewContent = Image.network(
        locationImage,
        fit: BoxFit.cover,
      );
    }

    if (isGettingLocation) {
      previewContent = CircularProgressIndicator();
    }

    return AlertDialog(
      content: Column(
        children: [
          Container(
            alignment: Alignment.center,
            width: 300,
            height: 400,
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
          Expanded(
            child: TextField(
              decoration: InputDecoration(hintText: 'Enter address'),
              controller: _controller,
              onChanged: (value){
                if(value.isNotEmpty){
                  autoCompleteSearch(value);
                }
              },
            ),
            
          ),
          SingleChildScrollView(
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: predictions.length, 
                itemBuilder: (context, index){
                  return ListTile(
                    title: Text(predictions[index].description.toString(),),
                  );
              }),
          ),
        ],
      ),
    );
  }
}
