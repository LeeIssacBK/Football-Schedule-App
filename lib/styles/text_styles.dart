
import 'package:flutter/material.dart';


TextStyle getAlertDialogTitleStyle() {
  return const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.indigo);
}

TextStyle getAlertDialogContentStyle() {
  return const TextStyle(color: Colors.indigo, fontSize: 15.0);
}

TextStyle getMainFont() {
  return const TextStyle(color: Colors.white, fontSize: 17.0, fontWeight: FontWeight.bold);
}

TextStyle getDetailFont() {
  return const TextStyle(color: Colors.black, fontSize: 15.0);
}

TextStyle getSearchFont() {
  return const TextStyle(
    color: Colors.indigo,
    fontSize: 30.0,
    fontWeight: FontWeight.bold,
    overflow: TextOverflow.ellipsis
  );
}