// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:linkyou_task/config/app_color.dart';
import 'dart:convert';
import 'package:linkyou_task/features/user_list/presentation/users_list_view.dart';

final GoogleSignIn _googleSignIn = GoogleSignIn();
Future<void> signInWithGoogle(BuildContext context) async {
  try {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

    // Make a POST request to the API
    final response = await http.post(
      Uri.parse('https://reqres.in/api/users'),
      body: json.encode({
        'name': userCredential.user?.displayName,
        'email': userCredential.user?.email
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 201) {
      // Navigate to the User List Screen
    Get.to(() => const UserListView());
    } else {
      print('Failed to create user: ${response.body}');
    }
  } catch (e) {
    print("Error during Google Sign-In: $e");
  }
}

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Column(
        children: [
          Image.network(
            'https://www.linkyou.ca/wp-content/uploads/2023/10/cropped-Transparency-1-1024x281-1.png',
            height: 200,
          ),
          const SizedBox(
            height: 100,
          ),
          const Text(
            'LOGIN WITH GOOGLE',
            style: TextStyle(
              color: AppColor.primary,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          GestureDetector(
            onTap: () async {
              await signInWithGoogle(context);
            },
            child: Container(
              margin: const EdgeInsets.all(20.0),
              height: 50,
              width: MediaQuery.of(context).size.width * .8,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40.0),
                border: Border.all(
                  width: 1.0,
                  color: AppColor.primary,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    flex: 1,
                    child: SizedBox(
                      height: 20,
                      width: 20,
                      child: Image.network(
                          'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Google_%22G%22_logo.svg/768px-Google_%22G%22_logo.svg.png'),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Sign in with Google',
                      style: GoogleFonts.inter(
                        fontSize: 16.0,
                        color: AppColor.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
