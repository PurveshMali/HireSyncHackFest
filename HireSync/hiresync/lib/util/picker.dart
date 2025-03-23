
import 'package:flutter/material.dart';
import 'package:flutter_picker_plus/flutter_picker_plus.dart';

class CustomPicker {
  static void showPicker(
    BuildContext context, {
    required String title,
    required int minValue,
    required int maxValue,
    required String unit,
    required Function(String) onSelected,
    int defaultValue = 0,
  }) {
    List<String> options = List.generate(
      maxValue - minValue + 1,
      (index) => "${minValue + index} $unit",
    );
    Picker(
      adapter: PickerDataAdapter<String>(pickerData: options),
      selecteds: [defaultValue - minValue],
      textStyle: TextStyle(color: Color((0xffFFA500)), fontFamily: 'Font1'),
      backgroundColor: Color(0xff0C0C0C),
      containerColor: Color(0xff0C0C0C),
      confirmText: "OK",
      confirmTextStyle: TextStyle(
        fontFamily: 'Font1',
        color: Color(0xffFFA500),
        fontWeight: FontWeight.bold,
        fontSize: 13,
      ),
      cancelText: "Cancel",
      cancelTextStyle: TextStyle(
        fontFamily: 'Font1',
        color: Color(0xffFFA500),
        fontSize: 13,
        //fontWeight: FontWeight.bold,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          // fontWeight: FontWeight.bold,
          fontFamily: 'Font1',
          fontSize: 13,
        ),
      ),
      onConfirm: (Picker picker, List<int> selected) {
        onSelected(options[selected[0]]);
      },
    ).showDialog(context);
  }
}