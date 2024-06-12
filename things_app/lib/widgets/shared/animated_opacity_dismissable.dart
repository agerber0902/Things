import 'package:flutter/material.dart';

class AnimatedOpacityDismissable extends StatefulWidget {
  const AnimatedOpacityDismissable({super.key, required this.child, required this.onDissmissed, required this.childKey});

  final Widget child;
  final Key childKey;
  final void Function(DismissDirection) onDissmissed;

  @override
  State<AnimatedOpacityDismissable> createState() =>
      _AnimatedOpacityDismissableState();
}

class _AnimatedOpacityDismissableState extends State<AnimatedOpacityDismissable>
    with SingleTickerProviderStateMixin {
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
            key: widget.childKey,
            child: widget.child,
            onDismissed: (direction) {
              widget.onDissmissed(direction);
            },
          ),
        );
      },
    );
  }
}
