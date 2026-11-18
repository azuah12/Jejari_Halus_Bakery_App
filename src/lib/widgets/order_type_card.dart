
import 'package:flutter/material.dart';

class OrderTypeCard extends StatelessWidget {
  final String title;
  final String description;
  final List<String> details;
  final IconData icon;
  final bool isSelected;
  final String? badge;
  final String? footer;
  final VoidCallback onTap;

  const OrderTypeCard({
    super.key,
    required this.title,
    required this.description,
    required this.details,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    this.badge,
    this.footer,
  });

  static const Color rose = Color(0xFFD7375A);
  static const Color muted = Color(0xFF806D70);
  static const Color dark = Color(0xFF654A50);
  static const Color green = Color(0xFF98CEAA);
  static const Color greenBg = Color(0xFFEAF5ED);
  static const Color pinkLine = Color(0xFFF0D9DE);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: const EdgeInsets.all(17),
        decoration: BoxDecoration(
          color: isSelected ? greenBg : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? green : pinkLine,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: dark, size: 27),

                if (isSelected)
                  const Text(
                    'Selected',
                    style: TextStyle(
                      color: Color(0xFF426D51),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                else if (badge != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFDE8ED),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      badge!,
                      style: const TextStyle(
                        color: rose,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 10),

            Text(
              title,
              style: const TextStyle(
                color: rose,
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 7),

            Text(
              description,
              style: const TextStyle(
                color: dark,
                fontSize: 13,
              ),
            ),

            const SizedBox(height: 12),

            ...details.map(
              (detail) => Padding(
                padding: const EdgeInsets.only(bottom: 3),
                child: Text(
                  '• $detail',
                  style: const TextStyle(
                    color: muted,
                    fontSize: 12,
                  ),
                ),
              ),
            ),

            if (footer != null) ...[
              const SizedBox(height: 7),
              Text(
                footer!,
                style: const TextStyle(
                  color: dark,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
