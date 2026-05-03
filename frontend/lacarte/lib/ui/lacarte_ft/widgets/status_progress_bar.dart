import 'package:flutter/material.dart';
import 'package:lacarte/data/model/models.dart';

class StatusProgressBar extends StatelessWidget {
  final OrderStatus status;
  final List<OrderStatus> steps;
  const StatusProgressBar({
    super.key,
    required this.status,
    required this.steps,
  });

  @override
  Widget build(BuildContext context) {
    final idx = steps.indexOf(status);
    final progress = (idx + 1) / steps.length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 4,
            backgroundColor: Colors.black.withOpacity(0.08),
            color: const Color(0xFF639922),
          ),
        ),
      ],
    );
  }
}
