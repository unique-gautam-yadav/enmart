import 'package:flutter/material.dart';

class OptionChip extends StatefulWidget {
  const OptionChip({
    super.key,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.title,
    required this.icon,
    this.onTap,
  });

  final MaterialColor backgroundColor;
  final Color foregroundColor;
  final String title;
  final IconData icon;
  final VoidCallback? onTap;

  @override
  State<OptionChip> createState() => _OptionChipState();
}

class _OptionChipState extends State<OptionChip> {
  bool isPressed = false;
  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: isPressed ? .9 : 1,
      duration: const Duration(milliseconds: 200),
      child: GestureDetector(
        onTap: widget.onTap,
        onTapCancel: () {
          setState(() {
            isPressed = false;
          });
        },
        onTapUp: (_) {
          setState(() {
            isPressed = false;
          });
        },
        onTapDown: (_) {
          setState(() {
            isPressed = true;
          });
        },
        child: Container(
          padding: const EdgeInsets.all(22),
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  widget.backgroundColor.shade500,
                  widget.backgroundColor.shade300,
                  widget.backgroundColor.shade100,
                ]),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(widget.icon, color: widget.foregroundColor, size: 35),
              FittedBox(
                child: Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: 222,
                    color: widget.foregroundColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
