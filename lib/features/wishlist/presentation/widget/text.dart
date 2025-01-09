import 'package:flutter/material.dart';

Widget productTitle(String text) {
  return Text(
    text,
    maxLines: 1,
    overflow: TextOverflow.ellipsis,
    style: const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w500,
    ),
  );
}

Widget favProductPrice(String text) {
  return Text(
    text,
    style: const TextStyle(
      fontSize: 16,
      color: Colors.black,
    ),
  );
}
