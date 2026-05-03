import 'package:flutter/material.dart';

class RatingSlider extends StatelessWidget {
  final String label;
  final double value;
  final ValueChanged<double>? onChanged;

  const RatingSlider({
    super.key,
    required this.label,
    required this.value,
    this.onChanged,
  });

  String get _emoji {
    if (value <= 1) return '😞';
    if (value <= 2) return '😕';
    if (value <= 3) return '😐';
    if (value <= 4) return '😊';
    return '😍';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          SizedBox(
            width: 90,
            child: Text(
              label,
              style: const TextStyle(fontSize: 13, color: Colors.black54),
            ),
          ),
          Expanded(
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: Colors.black87,
                inactiveTrackColor: Colors.black.withOpacity(0.1),
                thumbColor: Colors.black87,
                overlayColor: Colors.black.withOpacity(0.08),
                trackHeight: 3,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
              ),
              child: Slider(
                value: value,
                min: 1,
                max: 5,
                divisions: 4,
                onChanged: onChanged,
              ),
            ),
          ),
          Text(_emoji, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
