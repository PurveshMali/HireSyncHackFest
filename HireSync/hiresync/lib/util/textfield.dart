import 'package:flutter/material.dart';

class TextfieldUtil {
  static InputDecoration inputDecoration({
    String? hintText,
    TextStyle? hintStyle,
    IconData? prefixIcon,
    Color? prefixIconColor,
    Widget? suffixIcon,
    Color? suffixIconColor,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle:
          hintStyle ??
          const TextStyle(
            color: Color(0xff969292),
            fontFamily: 'Font1',
            fontSize: 13,
          ),
      filled: true,
      fillColor: const Color(0xff312F2F),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: Color(0xff969292)),
      ),
      prefixIcon:
          prefixIcon != null
              ? Icon(
                prefixIcon,
                color: prefixIconColor ?? const Color(0xff969292),
              )
              : null,
      suffixIcon: suffixIcon,
    );
  }

  static TextField customTextField({
    required TextEditingController controller,
    String? hintText,
    TextStyle? hintStyle,
    IconData? prefixIcon,
    Color? prefixIconColor,
    IconData? suffixIcon,
    Color? suffixIconColor,
    VoidCallback? onSuffixIconPressed, // Optional IconButton function
    bool obscureText = false,
    Color cursorColor = const Color(0xff969292),
    TextInputType keyboardType = TextInputType.text,
    void Function(String)? onChanged,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      cursorColor: cursorColor,
      keyboardType: keyboardType,
      decoration: inputDecoration(
        hintText: hintText,
        hintStyle: hintStyle,
        prefixIcon: prefixIcon,
        prefixIconColor: prefixIconColor,
        suffixIcon:
            suffixIcon != null
                ? IconButton(
                  icon: Icon(
                    suffixIcon,
                    color: suffixIconColor ?? const Color(0xff969292),
                  ),
                  onPressed:
                      onSuffixIconPressed ??
                      () {}, // Calls the function when pressed
                )
                : null,
      ),
      onChanged: onChanged,
    );
  }
}