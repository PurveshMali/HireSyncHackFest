import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:nexacare/Routes/app_routes.dart';
// import 'package:nexacare/user/homepage_user.dart';
// import 'package:nexacare/utils/elevatedbutton.dart';
// import 'package:nexacare/utils/textfield.dart';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hiresync/Routes/app_routes.dart';
import 'package:hiresync/util/elevatedbutton.dart';
import 'package:hiresync/util/textfield.dart';

class SignupEmployeer extends StatefulWidget {
  const SignupEmployeer({super.key});

  @override
  State<SignupEmployeer> createState() => _SignupEmployeerState();
}

class _SignupEmployeerState extends State<SignupEmployeer> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool isLoading = false;
  login() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        // The user canceled the login
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      // Navigate to home page or wherever you need after successful login
      Navigator.pushReplacementNamed(context, Approutes.wrapperEmployeer);
    } catch (e) {
      // Handle the error
      print("Error during Google sign-in: $e");
      AnimatedSnackBar.material(
        "Google Sign-in failed",
        type: AnimatedSnackBarType.error,
        duration: const Duration(seconds: 2),
        mobilePositionSettings: const MobilePositionSettings(
          topOnAppearance: 100,
        ),
        mobileSnackBarPosition: MobileSnackBarPosition.top,
      ).show(context);
    }
  }

  Future<void> signIn() async {
    setState(() {
      isLoading = true;
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.text,
        password: password.text,
      );
      Navigator.pushNamed(context, Approutes.wrapperEmployeer);
    } on FirebaseAuthException catch (e) {
      String errorMessage = "Something went wrong. Please try again.";

      if (e.code == 'user-not-found') {
        errorMessage = "No user found for that email.";
      } else if (e.code == 'wrong-password') {
        errorMessage = "Wrong password provided for that user.";
      } else if (e.code == 'invalid-email') {
        errorMessage = "The email address is badly formatted.";
      }

      AnimatedSnackBar.material(
        errorMessage,
        type: AnimatedSnackBarType.error,
        duration: const Duration(seconds: 2),
        mobilePositionSettings: const MobilePositionSettings(
          topOnAppearance: 100,
        ),
        mobileSnackBarPosition: MobileSnackBarPosition.top,
        desktopSnackBarPosition: DesktopSnackBarPosition.bottomLeft,
      ).show(context);
    } catch (e) {
      String errorMessage = "Something went wrong: $e";

      AnimatedSnackBar.material(
        errorMessage,
        type: AnimatedSnackBarType.error,
        duration: const Duration(seconds: 2),
        mobilePositionSettings: const MobilePositionSettings(
          topOnAppearance: 100,
        ),
        mobileSnackBarPosition: MobileSnackBarPosition.top,
        desktopSnackBarPosition: DesktopSnackBarPosition.bottomLeft,
      ).show(context);
    }

    setState(() {
      isLoading = false;
    });
  }

  bool passWordVisible = false; // Define the boolean variable

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return isLoading
        ? Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xffFFA500)),
          ),
        )
        : Scaffold(
          backgroundColor: const Color(0xff0C0C0C),
          resizeToAvoidBottomInset: true,
          body: SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: screenHeight * 0.18),
                    const Center(
                      child: Text(
                        "NexaCare",
                        style: TextStyle(
                          fontFamily: 'Font1',
                          color: Color(0xffFFFFFF),
                          fontSize: 30,
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.08),
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
                            color: const Color(0xff969292),
                          ),
                        ),
                        prefixIconColor: const Color(0xff969292),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    InkWell(
                      child: const Padding(
                        padding: EdgeInsets.only(left: 180.0),
                        child: Text(
                          "Forgot Password?",
                          style: TextStyle(
                            fontFamily: 'Font1',
                            fontSize: 13,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.pushNamed(context, Approutes.forgotPswd);
                      },
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    customElevatedButton(
                      buttonSize: const Size(310, 55),
                      buttonColor: const Color(0xffFFA500),
                      text: "Sign In",
                      textStyle: const TextStyle(
                        color: Color(0xff000000),
                        fontFamily: 'Font1',
                        fontSize: 15,
                      ),
                      onPressed: signIn,
                    ),
                    SizedBox(height: screenHeight * 0.15),
                    customElevatedButton(
                      buttonSize: const Size(310, 55),
                      buttonColor: Color(0xff312F2F),
                      text: "Sign in with Google",
                      textStyle: TextStyle(
                        fontFamily: 'Font1',
                        color: Colors.white,
                      ),
                      onPressed: (() => login()),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Padding(
                      padding: const EdgeInsets.only(left: 40.0),
                      child: Row(
                        children: [
                          const Text(
                            "Don't have an account?",
                            style: TextStyle(
                              fontFamily: 'Font1',
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 3),
                          InkWell(
                            child: const Text(
                              "Sign up",
                              style: TextStyle(
                                fontFamily: 'Font1',
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xffFFA500),
                              ),
                            ),
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                Approutes.signupworker,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
  }
}