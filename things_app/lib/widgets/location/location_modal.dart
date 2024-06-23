import 'package:flutter/material.dart';
import 'package:google_place/google_place.dart';
import 'package:provider/provider.dart';
import 'package:things_app/models/thing_location.dart';
import 'package:things_app/providers/location_provider.dart';
import 'package:things_app/providers/thing_provider.dart';

class LocationModal extends StatefulWidget {
  const LocationModal({super.key});

  @override
  State<LocationModal> createState() => _LocationModalState();
}

class _LocationModalState extends State<LocationModal> {
  final TextEditingController _controller = TextEditingController();
  late GooglePlace googlePlace;
  DetailsResult? _detailsResult;
  List<AutocompletePrediction> predictions = [];
  ThingLocation? _selectedLocation;
  bool isGettingLocation = false;

  @override
  void initState() {
    super.initState();
    googlePlace = GooglePlace('AIzaSyBbJiOdFcwZoGuTc7L9B2pMlFpGaTBnoF0');

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final activeThing = Provider.of<ThingProvider>(context, listen: false).activeThing;
      if (activeThing != null) {
        setState(() {
          _controller.text = activeThing.locationForDisplay;
          _selectedLocation = activeThing.location;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> autoCompleteSearch(String value) async {
    final result = await googlePlace.autocomplete.get(value);
    if (result != null && result.predictions != null) {
      setState(() {
        predictions = result.predictions!;
      });
    }
  }

  String get locationImage {
    final lat = _selectedLocation!.latitude;
    final lng = _selectedLocation!.longitude;
    return "https://maps.googleapis.com/maps/api/staticmap?center=$lat,$lng&zoom=16&size=600x300&maptype=roadmap&markers=color:blue%7Clabel:S%7C$lat,$lng&key=AIzaSyBbJiOdFcwZoGuTc7L9B2pMlFpGaTBnoF0";
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    Widget previewContent = const Text('No Location Chosen.');
    if (_selectedLocation != null) {
      previewContent = Image.network(locationImage, fit: BoxFit.cover);
    }
    if (isGettingLocation) {
      previewContent = const CircularProgressIndicator();
    }

    return Consumer<ThingProvider>(
      builder: (context, thingProvider, child) {
        return AlertDialog(
          title: Text(
            thingProvider.activeThing?.location != null ? 'Edit Location' : 'Add Location',
            style: textTheme.displaySmall!.copyWith(fontSize: textTheme.displaySmall!.fontSize! - 15.0, color: colorScheme.primary),
          ),
          content: SizedBox(
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
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _controller.clear();
                                predictions = [];
                                setState(() {
                                  _selectedLocation = null;
                                });
                                //set provider location
                                Provider.of<LocationProvider>(context, listen: false).setLocation(null);
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
                        title: Text(predictions[index].description ?? ''),
                        onTap: () async {
                          final placeId = predictions[index].placeId;
                          if (placeId != null) {
                            final details = await googlePlace.details.get(placeId);
                            if (details != null && details.result != null) {
                              setState(() {
                                _detailsResult = details.result;
                                _controller.text = _detailsResult!.formattedAddress ?? '';
                                _selectedLocation = ThingLocation(
                                  name: _detailsResult!.name,
                                  latitude: _detailsResult!.geometry?.location?.lat ?? 0,
                                  longitude: _detailsResult!.geometry?.location?.lng ?? 0,
                                  address: _detailsResult!.formattedAddress ?? '',
                                );
                                Provider.of<LocationProvider>(context, listen: false).setLocation(_detailsResult);
                                predictions = [];
                              });
                            }
                          }
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: colorScheme.onPrimaryContainer),
                      onPressed: () {
                        final locationProvider = Provider.of<LocationProvider>(context, listen: false);
                        final thingProvider = Provider.of<ThingProvider>(context, listen: false);

                        thingProvider.setThingLocation(locationProvider.location);

                        if (thingProvider.activeThing != null) {
                          thingProvider.setActiveThingLocation(_selectedLocation);
                        }

                        Navigator.of(context).pop();
                      },
                      child: Text(
                        thingProvider.activeThing?.location != null ? 'Edit' : 'Add',
                        style: textTheme.bodyLarge!.copyWith(color: Colors.white),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
