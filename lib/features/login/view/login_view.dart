// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:linkyou_task/config/app_color.dart';
import 'package:linkyou_task/features/controllers/user_controller.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final UserController userController = Get.put(UserController());

    return Scaffold(body: SafeArea(
      child: Obx(() {
        if (userController.isSigningIn.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return Column(
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
                await userController.signInWithGoogle();
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
        );
      }),
    ));
  }
}
