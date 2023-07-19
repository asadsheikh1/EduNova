import 'package:edu_nova/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

int? initScreen;
String? id;

void cacheData() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  id = pref.getString("user_id");
}

Size size(BuildContext context) {
  var size = MediaQuery.of(context).size;
  return size;
}

Future<bool?> flutterToast(value) {
  return Fluttertoast.showToast(
    msg: value,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: kTextColor,
    textColor: kLightColor,
    fontSize: 16.0,
  );
}
