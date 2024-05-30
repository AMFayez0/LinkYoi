import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:linkyou_task/features/login/model/user_model.dart';
import 'package:linkyou_task/features/login/model/user_page_model.dart';
import 'package:linkyou_task/features/user_list/view/users_list_view.dart';
import 'dart:convert';

class UserController extends GetxController {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  // var users = <UserModel>[].obs;
  var isLoading = false.obs;
  var hasMore = true.obs;
  var isSigningIn = false.obs;

  PagingController pagingController =
      PagingController<int, UserModel>(firstPageKey: 1);

  Future<void> signInWithGoogle() async {
    isSigningIn.value = true;
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      final response = await http.post(
        Uri.parse('https://reqres.in/api/users'),
        body: json.encode({
          'name': userCredential.user?.displayName,
          'email': userCredential.user?.email
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 201) {
        final newUser = UserModel(
          id: userCredential.user?.uid ?? '',
          firstName: userCredential.user?.displayName?.split(' ').first ?? '',
          lastName: userCredential.user?.displayName?.split(' ').last ?? '',
          email: userCredential.user?.email ?? '',
          avatar: userCredential.user?.photoURL ?? '',
        );

        Get.to(() => const UserListView());

        Get.snackbar(
            'Login Successful', 'Welcome, ${userCredential.user?.displayName}!',
            snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green);
      } else {
        print('Failed to create user: ${response.body}');
      }
    } catch (e) {
      print("Error during Google Sign-In: $e");
    } finally {
      isSigningIn.value = false;
    }
  }

  Future<UserPageModel?> fetchUsers(int page) async {
    final response =
        await http.get(Uri.parse('https://reqres.in/api/users?page=$page'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      UserPageModel userPageModel = UserPageModel.fromMap(data);
      return userPageModel;
    }
    return null;
  }

  Future<void> fetchPage(int page) async {
    final result = await fetchUsers(page);
    if (result != null) {
      if (result.lastPage == page) {
        pagingController.appendLastPage(result.users);
      } else {
        int next = page + 1;
        pagingController.appendPage(result.users, next++);
      }
    }
  }

  @override
  void onInit() {
    super.onInit();
    pagingController.addPageRequestListener((pageKey) {
      fetchPage(pageKey);
    });
  }
}
