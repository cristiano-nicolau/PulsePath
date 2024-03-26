import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final String subtitle;
  final String unit;

  const CustomCard({
    Key? key,
    required this.title,
    required this.icon,
    required this.color,
    required this.subtitle,
    required this.unit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(12),
      width: 160,
      height: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: color
            .withOpacity(0.1), // Defina a opacidade da cor de fundo do card
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Icon(icon, color: color, size: 30),
                SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold, color: color),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    subtitle,
                    style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        color: color),
                  ),
                  SizedBox(width: 4),
                  Text(
                    unit,
                    style: TextStyle(fontSize: 28, color: color),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
