import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:linkyou_task/features/controllers/user_controller.dart';

class UserListView extends StatefulWidget {
  const UserListView({super.key});

  @override
  State<UserListView> createState() => _UserListViewState();
}

class _UserListViewState extends State<UserListView> {
  @override
  Widget build(BuildContext context) {
    final UserController userController = Get.find();

    return Scaffold(
        appBar: AppBar(
          title: const Text('Users List'),
          automaticallyImplyLeading: false, 
        ),
        body: PagedListView.separated(
          pagingController: userController.pagingController,
          builderDelegate: PagedChildBuilderDelegate<dynamic>(
            itemBuilder: (context, item, index) {
              print(item.runtimeType);
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(item.avatar),
                ),
                title: Text('${item.firstName} ${item.lastName}'),
                subtitle: Text(item.email),
              );
            },
          ),
          separatorBuilder: (context, index) {
            return const SizedBox();
          },
        ));
  }
}
