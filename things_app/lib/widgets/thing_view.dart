import 'package:flutter/material.dart';
import 'package:things_app/models/category.dart';
import 'package:things_app/models/thing.dart';
import 'package:things_app/widgets/add_thing.dart';

const double initHeight = 150;

class ThingView extends StatefulWidget {
  const ThingView({
    super.key,
    required this.thing,
    required this.deleteThing,
    required this.addThing,
    required this.editThing,
  });

  final Thing thing;
  final void Function(Thing thing) deleteThing;
  final void Function(Thing thing) addThing;
  final void Function(Thing thing) editThing;

  @override
  State<ThingView> createState() => _ThingViewState();
}

class _ThingViewState extends State<ThingView> with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;
  late final double _height;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _height = initHeight;

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

  void _changeHeight(bool expand){
    const double heightChange = 50;

    setState(() {
      _height = expand ? _height + heightChange : _height - heightChange;
    });
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
              widget.deleteThing(widget.thing);
            },
            key: Key(widget.thing.id),
            child: SizedBox(
              height: initHeight,
              width: double.infinity,
              child: Container(
                padding: const EdgeInsets.all(10),
                child: ThingCard(widget: widget, changeHeight : _changeHeight),
              ),
            ),
          ),
        );
      },
    );
  }
}

class ThingCard extends StatefulWidget {
  const ThingCard({
    super.key,
    required this.widget, required this.changeHeight,
  });

  final ThingView widget;
  final void Function(bool expand) changeHeight;

  @override
  State<ThingCard> createState() => _ThingCardState();
}

class _ThingCardState extends State<ThingCard> {
  
  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    bool isExpanded = false;

    return GestureDetector(
      onTap: () {
        widget.changeHeight(!isExpanded);
      },
      onDoubleTap: () {
        showModalBottomSheet(
            context: context,
            builder: (ctx) {
              return AddThing(
                addThing: widget.widget.addThing,
                editThing: widget.widget.editThing,
                thing: widget.widget.thing,
              );
            });
      },
      child: Card(
        color: colorScheme.primaryContainer,
        margin: const EdgeInsets.only(left: 20, right: 20),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      child: Text(
                    widget.widget.thing.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.displaySmall!.copyWith(
                        fontSize: textTheme.displaySmall!.fontSize! - 5.0),
                  )),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  //Display Categories
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Row(
                        children:
                            widget.widget.thing.categories.map((category) {
                          return Padding(
                            padding: const EdgeInsets.only(left: 0, right: 8),
                            child: Icon(
                              categoryIcons[category]!.iconData,
                              color: categoryIcons[category]!.iconColor,
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                      child: Text(
                    widget.widget.thing.description ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.fade,
                    style: textTheme.bodySmall,
                  )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
