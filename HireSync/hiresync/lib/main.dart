import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hiresync/Routes/app_routes.dart';
import 'package:hiresync/util/wrapper.dart';
import 'firebase_options.dart';

class HIRESYNC extends StatefulWidget { 
  const HIRESYNC({super.key});

  @override
  State<HIRESYNC> createState() => _HIRESYNCState();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const HIRESYNC());
}

class _HIRESYNCState extends State<HIRESYNC> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HIRESYNC',
      theme: ThemeData(
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Color(0xff969292),
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xff0C0C0C)),
        dialogTheme: DialogThemeData(backgroundColor: Color(0xff0C0C0C)),
      ),
      darkTheme: ThemeData(brightness: Brightness.dark),
      debugShowCheckedModeBanner: false,
      initialRoute: Approutes.landingPage, // Set the initial route
      onGenerateRoute: Approutes.generateRoute,
    );
  }
}
