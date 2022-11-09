import 'package:flutter/material.dart';
import 'package:practi_sun/theme/palettes.dart';
// import 'package:front/config/palette.dart';

class Loader extends StatefulWidget {
  final double size;
  const Loader({Key? key, required this.size}) : super(key: key);

  @override
  State<Loader> createState() => _LoaderState();
}

class _LoaderState extends State<Loader> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  )..repeat(reverse: true);
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeInCirc,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(0.3),
        child: RotationTransition(
          turns: _animation,
          child: Icon(
            Icons.sunny,
            color: primary[500],
            size: widget.size,
          ),
        ));
  }
}
