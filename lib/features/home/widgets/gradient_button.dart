import 'package:flutter/material.dart';

class GradientButton extends StatefulWidget {
  const GradientButton({
    super.key,
    required this.onTap,
    required this.title,
    this.onLongPress,
  });

  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  final String title;

  @override
  State<GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<GradientButton> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) {
        setState(() {
          isLoading = true;
        });
      },
      onTapUp: (_) {
        setState(() {
          isLoading = false;
        });
      },
      onTapCancel: () {
        setState(() {
          isLoading = false;
        });
      },
      onLongPress: widget.onLongPress,
      child: AnimatedContainer(
        margin: const EdgeInsets.symmetric(horizontal: 50),
        height: 55,
        constraints: const BoxConstraints(
          minWidth: 350,
          maxWidth: 550,
        ),
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: isLoading
                ? [
                    Colors.deepPurple,
                    Colors.deepPurple.shade400,
                    Colors.indigo.shade500,
                    Colors.indigo.shade700,
                  ]
                : [
                    Colors.indigo.shade700,
                    Colors.indigo.shade500,
                    Colors.deepPurple.shade400,
                    Colors.deepPurple,
                  ],
          ),
        ),
        child: Center(
          child: FittedBox(
            fit: BoxFit.cover,
            child: Text(
              widget.title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 40,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
