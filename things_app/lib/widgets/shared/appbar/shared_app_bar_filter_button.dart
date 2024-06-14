import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:things_app/providers/things_provider.dart';
import 'package:things_app/utils/icon_data.dart';
import 'package:things_app/widgets/shared/filter_dialog.dart';

class SharedAppBarFilterButton extends StatefulWidget {
  const SharedAppBarFilterButton({super.key});

  @override
  State<SharedAppBarFilterButton> createState() =>
      _SharedAppBarFilterButtonState();
}

class _SharedAppBarFilterButtonState extends State<SharedAppBarFilterButton> {
  
  Icon? _filterIconData;
  
  @override
  void initState() {
    super.initState();

    _filterIconData = filterListIcon;
  }

  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return const FilterDialog();
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    void openFilters() {
      _dialogBuilder(context);
    }

    return Consumer<ThingsProvider>(
      builder: (context, thingsProvider, child) {
        void _setFilterImage() {
          int filterCount = thingsProvider.availableFilters
              .where((filter) => filter.entries.first.value)
              .length;

          setState(() {
            switch (filterCount) {
              case 0:
                _filterIconData = filterListIcon;
                break;
              case 1:
                _filterIconData = filter1Icon;
                break;
              case 2:
                _filterIconData = filter2Icon;
                break;
              case 3:
                _filterIconData = filter3Icon;
                break;
              case 4:
                _filterIconData = filter4Icon;
                break;
              case 5:
                _filterIconData = filter5Icon;
                break;
              case 6:
                _filterIconData = filter6Icon;
                break;
              case 7:
                _filterIconData = filter7Icon;
                break;
              default:
                _filterIconData = filterAltIcon;
            }
          });
        }

        return IconButton(
          onPressed: () {
            openFilters();
          },
          icon: _filterIconData ?? filterListIcon,
        );
      },
    );
  }
}
