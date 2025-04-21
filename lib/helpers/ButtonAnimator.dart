import 'package:flutter/material.dart';

class ButtonAnimator extends StatefulWidget {
  final String imagePath;
  final VoidCallback onTap;
  final double width;
  final double height;

  const ButtonAnimator({
    required this.imagePath,
    required this.onTap,
    required this.width,
    required this.height,
    super.key,
  });

  @override
  _ButtonAnimatorState createState() => _ButtonAnimatorState();
}

class _ButtonAnimatorState extends State<ButtonAnimator> {
  double _scale = 1.0;

  void _animateTap() async {
    setState(() => _scale = 0.9);
    await Future.delayed(const Duration(milliseconds: 100));
    setState(() => _scale = 1.0);
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _animateTap,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOut,
        child: Image.asset(
            widget.imagePath,
            width: widget.width,
            height: widget.height,
        ),
      ),
    );
  }
}
