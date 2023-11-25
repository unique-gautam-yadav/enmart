import 'package:flutter/material.dart';

class NameAndProfile extends StatelessWidget {
  const NameAndProfile({
    super.key,
    required this.name,
    required this.iconData,
    required this.avatarColor,
  });

  final String name;
  final IconData iconData;
  final Color avatarColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 65,
          width: 65,
          decoration: BoxDecoration(
            color: avatarColor,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Icon(
              iconData,
              size: 33,
            ),
          ),
        ),
        const SizedBox(width: 15),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 15),
            const Text(
              "Hello,",
              style: TextStyle(
                fontSize: 22,
              ),
            ),
            FittedBox(
              child: Text(
                name,
                style: const TextStyle(
                  fontSize: 26,
                ),
              ),
            ),
          ],
        ),
        const Spacer(),
      ],
    );
  }
}
