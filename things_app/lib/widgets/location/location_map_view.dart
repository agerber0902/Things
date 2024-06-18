import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:things_app/providers/location_provider.dart';

class LocationMapView extends StatelessWidget {
  const LocationMapView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LocationProvider>(
      builder: (context, locationProvider, child) {
        return locationProvider.location != null
                ? MapView(
                    locationProvider: locationProvider,
                  )
                : const NoLocationView();
      },
    );
  }
}

class MapView extends StatelessWidget {
  const MapView({
    super.key,
    required this.locationProvider,
  });

  final LocationProvider locationProvider;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      locationProvider.locationImage,
      fit: BoxFit.cover,
    );
  }
}

class NoLocationView extends StatelessWidget {
  const NoLocationView({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Text('No Location Choosen.',
        style: textTheme.displaySmall!.copyWith(
            fontSize: textTheme.displaySmall!.fontSize! - 15.0,
            color: colorScheme.primary));
  }
}
