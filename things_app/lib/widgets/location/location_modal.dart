import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_place/google_place.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:things_app/models/thing_location.dart';
import 'package:things_app/utils/icon_data.dart';

class LocationModal extends StatefulWidget {
  const LocationModal({super.key});

  @override
  State<LocationModal> createState() => _LocationModalState();
}

class _LocationModalState extends State<LocationModal> {
  TextEditingController _controller = TextEditingController();
  late GooglePlace googlePlace;
  DetailsResult? _detailsResult;

  List<AutocompletePrediction> predictions = [];
  ThingLocation? _selectedLocation;
  bool isGettingLocation = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    googlePlace = GooglePlace('AIzaSyBbJiOdFcwZoGuTc7L9B2pMlFpGaTBnoF0');
  }

  autoCompleteSearch(String value) async {
    var result = await googlePlace.autocomplete.get(value);

    if (result != null && result.predictions != null) {
      print(result.predictions!.first.description);
      setState(() {
        predictions = result.predictions!;
      });
    }
  }

  String get locationImage {
    final lat = _selectedLocation!.latitude;
    final lng = _selectedLocation!.longitude;
    return "https://maps.googleapis.com/maps/api/staticmap?center=$lat,$lng&zoom=16&size=600x300&maptype=roadmap&markers=color:blue%7Clabel:S%7C$lat,$lng&markers=color:green%7Clabel:G%7C40.711614,-74.012318&markers=color:red%7Clabel:C%7C40.718217,-73.998284&key=AIzaSyBbJiOdFcwZoGuTc7L9B2pMlFpGaTBnoF0";
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

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
      title: Text(
        'Add Location',
        style: textTheme.displaySmall!.copyWith(
            fontSize: textTheme.displaySmall!.fontSize! - 15.0,
            color: colorScheme.primary),
      ),
      content: Container(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              alignment: Alignment.center,
              width: 300,
              height: 200,
              child: previewContent,
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //   children: [
            //     TextButton.icon(
            //       onPressed: getCurrentLocation,
            //       label: const Text('Current Location'),
            //       icon: const Icon(Icons.location_on),
            //     ),
            //     TextButton.icon(
            //       onPressed: () {},
            //       label: const Text('Select on Map'),
            //       icon: const Icon(Icons.map),
            //     ),
            //   ],
            // ),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Enter address',
                      suffixIcon: Opacity(
                        opacity: 0.4,
                        child: IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: () {
                            _controller.clear();
                            _controller.text = '';
                            predictions = [];
                            setState(() {
                              _selectedLocation = null;
                            });
                          },
                        ),
                      ),
                    ),
                    controller: _controller,
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        autoCompleteSearch(value);
                      }
                    },
                  ),
                ),
              ],
            ),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: predictions.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(predictions[index].description.toString()),
                    onTap: () async {
                      final placeId = predictions[index].placeId;
                      //Get details
                      if (placeId != null) {
                        final details = await googlePlace.details.get(placeId);

                        if (details != null && details.result != null) {
                          setState(() {
                            _detailsResult = details.result;
                            _controller.text =
                                _detailsResult!.formattedAddress ?? '';

                            _selectedLocation = ThingLocation(
                                latitude:
                                    _detailsResult!.geometry!.location!.lat ??
                                        0,
                                longitude:
                                    _detailsResult!.geometry!.location!.lng ??
                                        0,
                                address:
                                    _detailsResult!.formattedAddress ?? '');

                            //clear predictions
                            predictions = [];
                          });
                        }
                      }
                    },
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.onPrimaryContainer),
                  onPressed: () {},
                  child: Text(
                    'Add',
                    style: textTheme.bodyLarge!.copyWith(color: Colors.white),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
