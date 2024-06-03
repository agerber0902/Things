import 'package:flutter/material.dart';
import 'package:things_app/models/category.dart';
import 'package:things_app/models/thing.dart';
import 'package:things_app/widgets/add_thing.dart';
import 'package:things_app/widgets/notes_modal.dart';

const double initHeight = 200;

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

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
                child: ThingCard(widget: widget),
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
    required this.widget,
  });

  final ThingView widget;

  @override
  State<ThingCard> createState() => _ThingCardState();
}

class _ThingCardState extends State<ThingCard> {
  bool? _isFavorite;
  late bool _isCompleted;

  @override
  void initState() {
    super.initState();

    _isFavorite = widget.widget.thing.categoriesContainsFavorite;
    _isCompleted = widget.widget.thing.isMarkedComplete;
  }

  Future<void> _notesDialogBuilder(
    BuildContext context,
    String text
  ) {
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return NotesModal(
              title: widget.widget.thing.title,
              notes: widget.widget.thing.notes,
              onAdd: (notes) {
                widget.widget.thing.notes = notes;
                widget.widget.editThing(widget.widget.thing);
              },
              onEdit: (notes) {
                widget.widget.thing.notes = notes;
                widget.widget.editThing(widget.widget.thing);
              },
            );
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () {
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
                    ),
                  ),
                  _isFavorite ?? false
                      ? IconButton(
                          onPressed: () {
                            widget.widget.thing.categories.remove('favorite');
                            widget.widget.editThing(widget.widget.thing);

                            setState(() {
                              _isFavorite = false;
                            });
                          },
                          icon: Icon(
                            categoryIcons['favorite']!.iconData,
                            color: categoryIcons['favorite']!.iconColor,
                          ),
                        )
                      : IconButton(
                          onPressed: () {
                            widget.widget.thing.categories.add('favorite');
                            widget.widget.editThing(widget.widget.thing);

                            setState(() {
                              _isFavorite = true;
                            });
                          },
                          icon: const Icon(
                            Icons.favorite_outline,
                          ),
                        ),
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
                        children: widget.widget.thing.categories
                            .where((c) => c != 'favorite')
                            .map((category) {
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  GestureDetector(
                    onTap: () {
                      _notesDialogBuilder(context, 'test');
                    },
                    child: widget.widget.thing.notes == null || widget.widget.thing.notes!.isEmpty ? Icon(Icons.note_add_outlined) : Icon(Icons.sticky_note_2),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.check_box,
                      color:
                          _isCompleted ? Colors.green : colorScheme.onPrimary,
                    ),
                    onPressed: () {
                      //edit thing
                      widget.widget.thing.isMarkedComplete = !_isCompleted;
                      widget.widget.editThing(widget.widget.thing);

                      setState(() {
                        _isCompleted = !_isCompleted;
                      });
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
