import 'package:flutter/material.dart';
import 'package:lacarte/ui/lacarte_ft/widgets/rating_slider.dart';

class FeedbackSection extends StatelessWidget {
  final double foodRating;
  final double speedRating;
  final double valueRating;
  final TextEditingController commentCtrl;
  final bool submitted;
  final ValueChanged<double> onFoodChanged;
  final ValueChanged<double> onSpeedChanged;
  final ValueChanged<double> onValueChanged;
  final VoidCallback onSubmit;

  const FeedbackSection({
    super.key,
    required this.foodRating,
    required this.speedRating,
    required this.valueRating,
    required this.commentCtrl,
    required this.submitted,
    required this.onFoodChanged,
    required this.onSpeedChanged,
    required this.onValueChanged,
    required this.onSubmit,
  });

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
          const Text(
            'Rate your experience',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          RatingSlider(
            label: 'Food quality',
            value: foodRating,
            onChanged: submitted ? null : onFoodChanged,
          ),
          RatingSlider(
            label: 'Service speed',
            value: speedRating,
            onChanged: submitted ? null : onSpeedChanged,
          ),
          RatingSlider(
            label: 'Value',
            value: valueRating,
            onChanged: submitted ? null : onValueChanged,
          ),
          const SizedBox(height: 8),
          TextField(
            controller: commentCtrl,
            enabled: !submitted,
            maxLines: 3,
            style: const TextStyle(fontSize: 13),
            decoration: InputDecoration(
              hintText: 'Any comments? Tell the kitchen...',
              hintStyle: const TextStyle(fontSize: 13, color: Colors.black38),
              filled: true,
              fillColor: const Color(0xFFF8F8F8),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.black.withOpacity(0.1)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.black.withOpacity(0.1)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.black54),
              ),
              contentPadding: const EdgeInsets.all(12),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: submitted ? Colors.black26 : Colors.black87,
                side: BorderSide(
                  color: submitted ? Colors.black12 : Colors.black26,
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: const StadiumBorder(),
              ),
              onPressed: submitted ? null : onSubmit,
              child: Text(
                submitted ? 'Feedback sent ✓' : 'Submit feedback',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
