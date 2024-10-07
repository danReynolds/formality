part of '../formality.dart';

class FormalityErrorAnimation extends StatelessWidget {
  final Widget child;

  const FormalityErrorAnimation({
    super.key,
    required this.child,
  });

  @override
  build(context) {
    return child
        .animate()
        .fadeIn(duration: 200.ms)
        .slideY(begin: 1, end: 0, duration: 200.ms);
  }
}
