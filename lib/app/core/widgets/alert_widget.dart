import 'package:flutter/material.dart';

class AlertWidget extends StatelessWidget {
  final IconData icon;
  final String message;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? iconColor;

  const AlertWidget({
    required this.icon,
    required this.message,
    this.backgroundColor,
    this.textColor,
    this.iconColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: backgroundColor?.withOpacity(0.7),
      shadowColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 8,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.error,
              color: iconColor,
              size: 18,
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                message,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: textColor,
                      height: 1.15,
                    ),
                textAlign: TextAlign.start,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
