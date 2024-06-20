
import 'package:flutter/material.dart';


TextStyle getAlertDialogTitleStyle() {
  return const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.indigo);
}

TextStyle getAlertDialogContentStyle() {
  return const TextStyle(color: Colors.indigo, fontSize: 15.0);
}

TextStyle getMainFont() {
  return const TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold);
}

TextStyle getDetailTitleFont() {
  return const TextStyle(color: Colors.white, fontSize: 15.0, overflow: TextOverflow.ellipsis);
}

TextStyle getDetailFont() {
  return const TextStyle(color: Colors.black, fontSize: 20.0, overflow: TextOverflow.ellipsis);
}

TextStyle getSearchFont() {
  return const TextStyle(
    color: Colors.indigo,
    fontSize: 37.0,
    fontWeight: FontWeight.bold,
    overflow: TextOverflow.ellipsis
  );
}

TextStyle getMyPageFont() {
  return const TextStyle(
      color: Colors.indigo,
      fontSize: 37.0,
      fontWeight: FontWeight.bold,
      overflow: TextOverflow.ellipsis
  );
}

TextStyle getMyInfoFont() {
  return const TextStyle(
      color: Colors.indigo,
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
      overflow: TextOverflow.ellipsis
  );
}

TextStyle getMyInfoFont2() {
  return const TextStyle(
      color: Colors.black,
      fontSize: 20.0,
      overflow: TextOverflow.ellipsis
  );
}

TextStyle getButtonTextColor() {
  return const TextStyle(color: Colors.indigo);
}