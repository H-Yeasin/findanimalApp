import 'dart:async';
import 'package:flutter/material.dart';

enum AnimationType { fade, flip, bounce }

class ScrollAppearanceWrapper extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Duration delay;
  final AnimationType type;

  const ScrollAppearanceWrapper({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 800),
    this.delay = Duration.zero,
    this.type = AnimationType.fade,
  });

  @override
  State<ScrollAppearanceWrapper> createState() =>
      _ScrollAppearanceWrapperState();
}

class _ScrollAppearanceWrapperState extends State<ScrollAppearanceWrapper>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isVisible = false;
  final GlobalKey _key = GlobalKey();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkVisibility();
      _timer = Timer.periodic(const Duration(milliseconds: 300), (timer) {
        _checkVisibility();
      });
    });
  }

  void _checkVisibility() {
    if (!mounted) return;

    final renderObject = _key.currentContext?.findRenderObject() as RenderBox?;
    if (renderObject == null) return;

    final position = renderObject.localToGlobal(Offset.zero);
    final screenHeight = MediaQuery.of(context).size.height;

    bool currentlyInView =
        position.dy < screenHeight - 20 && position.dy > -200;

    if (currentlyInView && !_isVisible) {
      Future.delayed(widget.delay, () {
        if (mounted) {
          setState(() => _isVisible = true);
          _controller.forward();
        }
      });
    } else if (!currentlyInView && _isVisible) {
      setState(() {
        _isVisible = false;
      });
      _controller.reset();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        _checkVisibility();
        return false;
      },
      child: KeyedSubtree(
        key: _key,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            switch (widget.type) {
              case AnimationType.flip:
                return Transform(
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001)
                    ..rotateX((1 - _controller.value) * 1.5),
                  alignment: Alignment.center,
                  child: Opacity(opacity: _controller.value, child: child),
                );
              case AnimationType.bounce:
                return Transform.scale(
                  scale: Curves.elasticOut.transform(_controller.value),
                  child: Opacity(opacity: _controller.value, child: child),
                );
              case AnimationType.fade:
                return Transform.translate(
                  offset: Offset(0, 20 * (1 - _controller.value)),
                  child: Opacity(opacity: _controller.value, child: child),
                );
            }
          },
          child: widget.child,
        ),
      ),
    );
  }
}
