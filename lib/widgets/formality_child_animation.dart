part of '../formality.dart';

class FormalityChildAnimation extends StatefulWidget {
  final Widget child;
  final ValidationController controller;

  const FormalityChildAnimation({
    super.key,
    required this.child,
    required this.controller,
  });

  @override
  DefaultShakeAnimationState createState() => DefaultShakeAnimationState();
}

class DefaultShakeAnimationState extends State<FormalityChildAnimation>
    with TickerProviderStateMixin {
  late final _tintAnimationController = AnimationController(vsync: this);
  late final _shakeAnimationController = AnimationController(vsync: this);
  late final ValidationListener _listener;

  @override
  void initState() {
    _listener = widget.controller.addListener((valid) {
      if (!valid) {
        _shakeAnimationController.reset();
        _shakeAnimationController.forward();
        _tintAnimationController.forward().then((_) {
          _tintAnimationController.reverse();
        });
      }
    });
    super.initState();
  }

  @override
  dispose() {
    widget.controller.removeListener(_listener);
    super.dispose();
  }

  @override
  build(context) {
    return widget.child
        .animate(controller: _tintAnimationController, autoPlay: false)
        .tint(color: Colors.red, end: 0.8, duration: 400.ms)
        .animate(controller: _shakeAnimationController, autoPlay: false)
        .shakeX(duration: 500.ms, hz: 5);
  }
}
