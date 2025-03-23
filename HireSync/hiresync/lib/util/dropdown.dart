import 'package:flutter/material.dart';

Future<String?> showDropdownDialog(
  BuildContext context,
  String title,
  List<String> options,
) async {
  if (options.isEmpty) return null;

  return await showDialog<String>(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: const Color(0xff0C0C0C),
        title: Text(
          title,
          style: TextStyle(
            fontFamily: 'Font1',
            fontWeight: FontWeight.bold,
            color: Color(0xffffffff),
            fontSize: 20,
          ),
        ),
        content: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: options.length * 50.0, // Adjust height dynamically
            minHeight: 50.0, // Set a minimum height
            maxWidth: double.infinity,
          ),
          child: ListView.separated(
            shrinkWrap: true, // Important to make it adjust to content
            itemCount: options.length,
            separatorBuilder:
                (context, index) => Divider(
                  color: Colors.white24, // Light divider for better visibility
                  thickness: 1,
                  height: 1,
                ),
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(
                  options[index],
                  style: TextStyle(
                    fontFamily: 'Font1',
                    color: Color(0xffFFA500),
                    fontSize: 16,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context, options[index]);
                },
              );
            },
          ),
        ),
      );
    },
  );
}