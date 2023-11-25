import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NoUserColumn extends StatelessWidget {
  const NoUserColumn({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 250,
          height: 250,
          child: SvgPicture.asset('assets/svg/empty.svg'),
        ),
        const SizedBox(height: 25),
        const Text(
          "No users till now",
          style: TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: 28,
          ),
        ),
        const SizedBox(height: 25),
      ],
    );
  }
}
