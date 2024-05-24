import 'package:flutter/material.dart';
import 'package:things_app/helpers/firebase_helper.dart';
import 'package:things_app/models/thing.dart';

import 'package:http/http.dart' as http;

final ThingsFirebaseHelper _firebaseHelper = ThingsFirebaseHelper();
const double height = 150;

class ThingView extends StatefulWidget {
  const ThingView({
    super.key,
    required this.thing, required this.deleteThing,
  });

  final Thing thing;
  final void Function(Thing thing) deleteThing;

  @override
  State<ThingView> createState() => _ThingViewState();
}

class _ThingViewState extends State<ThingView> with TickerProviderStateMixin {
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

  // void _deleteThing(Thing thingToDelete) async {
  //   // final url =
  //   //     Uri.https(kBaseFirebaseUrl, 'things-list/${thingToDelete.id}.json');

  //   // final response = await http.delete(url);

  //   await _firebaseHelper.deleteThing(thingToDelete);
    
  //   return;
  // }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Opacity(
          opacity: _animation.value,
          child: Dismissible(
            onDismissed: (direction) {
              widget.deleteThing(widget.thing);
            },
            key: Key(widget.thing.id),
            child: SizedBox(
              height: height,
              width: double.infinity,
              child: Container(
                padding: const EdgeInsets.all(10),
                child: ThingCard(widget: widget),
              ),
            ),
          ),
        );
      },
    );
  }
}

class ThingCard extends StatelessWidget {
  const ThingCard({
    super.key,
    required this.widget,
  });

  final ThingView widget;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(left: 20, right: 20),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: Text(widget.thing.title, maxLines: 1, overflow: TextOverflow.ellipsis,)),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                    child: Text(
                  widget.thing.description ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.fade,
                )),
              ],
            )
          ],
        ),
      ),
    );
  }
}
