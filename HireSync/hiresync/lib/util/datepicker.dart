import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Datepicker {
  static Future<String?> selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(
              primary: Color(0xffffffff),
              onPrimary: Color(0xffFFA500),
              surface: Color(0xff0C0C0C),
              onSurface: Color(0xffFFA500),
            ),
            dialogBackgroundColor: Color(0xff0C0C0C),
          ),
          child: child!,
        );
      },
    );
    return DateFormat('yyyy-MM-dd').format(pickedDate!);
      return null;
  }
}
