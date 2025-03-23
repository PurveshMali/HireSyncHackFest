import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hiresync/Routes/app_routes.dart';
import 'package:hiresync/util/elevatedbutton.dart';
import 'package:hiresync/util/textfield.dart';
import 'package:email_validator/email_validator.dart';

class SignupWorker extends StatefulWidget {
  const SignupWorker({super.key});

  @override
  State<SignupWorker> createState() => _SignupWorkerState();
}

class _SignupWorkerState extends State<SignupWorker> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  signUp() async {
    // Check if the email is in the correct format
    if (!EmailValidator.validate(email.text)) {
      AnimatedSnackBar.material(
        "Please enter a valid email address.",
        type: AnimatedSnackBarType.error,
        duration: const Duration(seconds: 2),
        mobilePositionSettings: const MobilePositionSettings(
          topOnAppearance: 100,
        ),
        mobileSnackBarPosition: MobileSnackBarPosition.top,
      ).show(context);
      return;
    }

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.text,
        password: password.text,
      );
      // ignore: use_build_context_synchronously
      Navigator.pushNamed(context, Approutes.wrapper);
    } on FirebaseAuthException catch (e) {
      String errorMessage = "Something went wrong. Please try again.";

      if (e.code == 'email-already-in-use') {
        errorMessage = "This email address is already in use.";
      } else if (e.code == 'weak-password') {
        errorMessage = "The password is too weak.";
      } else if (e.code == 'invalid-email') {
        errorMessage = "The email address is badly formatted.";
      }

      // Displaying error message with AnimatedSnackBar
      AnimatedSnackBar.material(
        errorMessage,
        type: AnimatedSnackBarType.error,
        duration: const Duration(seconds: 2),
        mobilePositionSettings: const MobilePositionSettings(
          topOnAppearance: 100,
        ),
        mobileSnackBarPosition: MobileSnackBarPosition.top,
      ).show(context);
    } catch (e) {
      // Handle any other errors
      String errorMessage = "An unexpected error occurred: $e";
      AnimatedSnackBar.material(
        errorMessage,
        type: AnimatedSnackBarType.error,
        duration: const Duration(seconds: 2),
        mobilePositionSettings: const MobilePositionSettings(
          topOnAppearance: 100,
        ),
        mobileSnackBarPosition: MobileSnackBarPosition.top,
      ).show(context);
    }
  }

  bool passWordVisible = false;
  // Define the boolean variable

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff0C0C0C),
        title: Text(
          "HireSync",
          style: TextStyle(
            fontFamily: 'Font1',
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),

      backgroundColor: const Color(0xff0C0C0C),
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text(
                      "Sign Up",
                      style: TextStyle(
                        fontFamily: 'Font1',
                        color: Color(0xffFFFFFF),
                        fontSize: 25,
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.07),
                  const Text(
                    "Email Address",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Font1',
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  TextField(
                    controller: email,
                    keyboardType: TextInputType.emailAddress,
                    decoration: TextfieldUtil.inputDecoration(
                      hintText: "Enter your Email address",
                      prefixIcon: Icons.email_outlined,
                      prefixIconColor: const Color(0xff969292),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  const Text(
                    "Password",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Font1',
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  TextField(
                    controller: password,
                    keyboardType: TextInputType.text,
                    obscureText: passWordVisible,
                    decoration: TextfieldUtil.inputDecoration(
                      hintText: "Enter your Password",

                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            passWordVisible = !passWordVisible;
                          });
                        },
                        icon: Icon(
                          passWordVisible
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: Color(0xff969292),
                        ),
                      ),
                      prefixIconColor: const Color(0xff969292),
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.04),
                  customElevatedButton(
                    buttonSize: Size(310, 55),
                    buttonColor: Color(0xffFFA500),
                    text: "Sign Up",
                    textStyle: TextStyle(
                      color: Color(0xff000000),
                      fontFamily: 'Font1',
                      fontSize: 15,
                    ),
                    onPressed: (() => signUp()),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}