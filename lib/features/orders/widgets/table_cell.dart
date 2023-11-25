import 'package:flutter/cupertino.dart';

TableCell headCell(String title) {
  return TableCell(
      child: Text(
    title,
    style: const TextStyle(fontWeight: FontWeight.bold),
  ));
}
