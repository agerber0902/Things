import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:things_app/providers/reminder_provider.dart';
import 'package:things_app/providers/search_provider.dart';
import 'package:things_app/providers/thing_provider.dart';

class CollapsableSearchBar extends StatefulWidget{
  const CollapsableSearchBar({super.key, required this.expandedWidth, required this.isThingSearch});

  final bool isThingSearch;

  final double expandedWidth; 
  @override
  State<CollapsableSearchBar> createState() => _CollapsableSearchBarState();
}

class _CollapsableSearchBarState extends State<CollapsableSearchBar> {

  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  double _searchBarWidth = 0;

  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
    
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<SearchProvider, ReminderProvider, ThingProvider>(builder:(context, searchProvider, reminderProvider, thingProvider, child) {

      void search(){
        if(widget.isThingSearch){
          thingProvider.setSearchValue(_searchController.text.toLowerCase());
        }
        else{
          //Reminder Search
          reminderProvider.setSearchValue(_searchController.text.toLowerCase());
        }
      }

      return AnimatedCrossFade(
            duration: const Duration(milliseconds: 300),
            firstChild: IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                setState(() {
                  _isSearching = true;
                  _searchBarWidth = widget.expandedWidth;
                });
              },
            ),
            secondChild: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  width: _searchBarWidth,
                  child: TextField(
                    controller: _searchController,
                    autofocus: true,
                    decoration: const InputDecoration(
                      hintText: 'Search...',
                    ),
                    onSubmitted: (String query) {
                      // Handle the search query
                      setState(() {
                        _isSearching = false;
                        _searchBarWidth = 0;
                        //Add search value to the search bar to the provider and use that 
                        //TODO: need to reset on screen change
                        searchProvider.setSearchValue(_searchController.text.toLowerCase());
                        search();
                        //_searchController.clear();
                      });
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    setState(() {
                      _isSearching = false;
                      _searchController.clear();
                      _searchBarWidth = 0;
                      searchProvider.setSearchValue(_searchController.text.toLowerCase());
                      search();
                    });
                  },
                ),
              ],
            ),
            crossFadeState: _isSearching ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          );
    },);
  }
}