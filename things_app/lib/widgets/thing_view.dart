import 'package:flutter/material.dart';
import 'package:things_app/models/thing.dart';

import 'package:http/http.dart' as http;

final String kBaseFirebaseUrl = 'things-a-default-rtdb.firebaseio.com';

class ThingView extends StatefulWidget {
  const ThingView({
    super.key,
    required this.thing,
  });

  final Thing thing;

  @override
  State<ThingView> createState() => _ThingViewState();
}

class _ThingViewState extends State<ThingView>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  
  late final Animation<double> _animation;

  @override
  void dispose() {
    super.dispose();

    _controller.dispose();
  }

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(_controller);

    _controller.forward();

  }

  void _deleteThing(Thing thingToDelete) async{
    final url = Uri.https(kBaseFirebaseUrl, 'things-list/${thingToDelete.id}.json');

    final response = await http.delete(url);

    print(response.statusCode);

  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Opacity(
          opacity: _animation.value,
          child: Dismissible(
            onDismissed: (direction) {
              _deleteThing(widget.thing);
            },
            key: Key(widget.thing.id),
            child: SizedBox(
              height: 100,
              width: double.infinity,
              child: Container(
                padding: const EdgeInsets.all(10),
                child: Card(
                  margin: const EdgeInsets.only(left: 20, right: 20),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(widget.thing.title),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
