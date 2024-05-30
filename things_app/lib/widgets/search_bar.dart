import 'package:flutter/material.dart';

class CollapsableSearchBar extends StatefulWidget{
  const CollapsableSearchBar({super.key, required this.searchThings, required this.expandedWidth});

  final void Function(String searchValue) searchThings;
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

                        widget.searchThings(_searchController.text.toLowerCase());
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
                      widget.searchThings(_searchController.text.toLowerCase());
                    });
                  },
                ),
              ],
            ),
            crossFadeState: _isSearching ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          );
  }
}