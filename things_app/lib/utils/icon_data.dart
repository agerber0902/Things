import 'package:flutter/material.dart';
import 'package:things_app/main.dart';

class AppBarIcons{

  FilterIcons filterIcons = FilterIcons();
  Icon addIcon = Icon(Icons.add, color: kColorScheme.primary,);

}

class FilterIcons{
  final Icon defaultFilterIcon = const Icon(Icons.filter_alt_outlined);
  final Icon filterInUseIcon = const Icon(Icons.filter_alt);
}