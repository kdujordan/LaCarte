import 'package:flutter/material.dart';
import 'package:lacarte/data/model/models.dart';

class PulsingDot extends StatefulWidget {
  final OrderStatus status;
  const PulsingDot({super.key, required this.status});

  @override
  State<PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<PulsingDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _anim = Tween(begin: 0.3, end: 1.0).animate(_ctrl);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final active =
        widget.status != OrderStatus.served &&
        widget.status != OrderStatus.cancelled;
    final color = widget.status == OrderStatus.cancelled
        ? Colors.red
        : const Color(0xFF639922);
    return FadeTransition(
      opacity: active ? _anim : const AlwaysStoppedAnimation(1.0),
      child: Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      ),
    );
  }
}
