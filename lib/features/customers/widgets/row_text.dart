import 'package:flutter/cupertino.dart';

class RowText extends StatelessWidget {
  const RowText({
    super.key,
    required this.title,
    required this.value,
    this.fontSize,
  });

  final String title;
  final String value;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: "$title : ",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize),
        children: [
          TextSpan(
            text: value,
            style: const TextStyle(fontWeight: FontWeight.normal),
          ),
        ],
      ),
    );
  }
}
