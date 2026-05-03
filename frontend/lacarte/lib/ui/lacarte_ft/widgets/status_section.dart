import 'package:flutter/material.dart';
import 'package:lacarte/data/model/models.dart';
import 'package:lacarte/ui/lacarte_ft/widgets/pulsing_dot.dart';
import 'package:lacarte/ui/lacarte_ft/widgets/status_chip.dart';
import 'package:lacarte/ui/lacarte_ft/widgets/status_progress_bar.dart';

class StatusSection extends StatelessWidget {
  final Order order;
  final OrderStatus liveStatus;
  const StatusSection({
    super.key,
    required this.order,
    required this.liveStatus,
  });

  static const _steps = [
    OrderStatus.pending,
    OrderStatus.preparing,
    OrderStatus.served,
    OrderStatus.paid,
    OrderStatus.cancelled,
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black.withOpacity(0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Pulsing dot
              PulsingDot(status: liveStatus),
              const SizedBox(width: 8),
              Text(
                'Order #${order.id}',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // Status chips row
          if (liveStatus == OrderStatus.cancelled)
            StatusChip(
              label: 'Cancelled',
              color: Colors.red.shade600,
              bgColor: Colors.red.shade50,
              active: true,
            )
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _steps.map((s) {
                final reached = _steps.indexOf(s) <= _steps.indexOf(liveStatus);
                return StatusChip(
                  label: _label(s),
                  color: reached ? _color(s) : Colors.black26,
                  bgColor: reached
                      ? _bgColor(s)
                      : Colors.black.withOpacity(0.04),
                  active: liveStatus == s,
                );
              }).toList(),
            ),
          // Progress bar
          if (liveStatus != OrderStatus.cancelled) ...[
            const SizedBox(height: 14),
            StatusProgressBar(status: liveStatus, steps: _steps),
          ],
        ],
      ),
    );
  }

  String _label(OrderStatus s) {
    switch (s) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.preparing:
        return 'Preparing';
      case OrderStatus.served:
        return 'Served';
      case OrderStatus.paid:
        return 'Paid';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }

  Color _color(OrderStatus s) {
    switch (s) {
      case OrderStatus.pending:
        return const Color(0xFF854F0B);
      case OrderStatus.preparing:
        return const Color(0xFF185FA5);
      case OrderStatus.served:
        return const Color(0xFF3B6D11);
      case OrderStatus.paid:
        return const Color(0xFF3B6D11);
      case OrderStatus.cancelled:
        return Colors.red;
    }
  }

  Color _bgColor(OrderStatus s) {
    switch (s) {
      case OrderStatus.pending:
        return const Color(0xFFFAEEDA);
      case OrderStatus.preparing:
        return const Color(0xFFE6F1FB);
      case OrderStatus.served:
        return const Color(0xFFEAF3DE);
      case OrderStatus.paid:
        return const Color(0xFFEAF3DE);
      default:
        return Colors.black.withOpacity(0.04);
    }
  }
}
