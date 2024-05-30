import 'package:linkyou_task/features/login/model/user_model.dart';

class UserPageModel {
  final int lastPage;
  final List<UserModel> users;
  UserPageModel({
    required this.lastPage,
    required this.users,
  });

  factory UserPageModel.fromMap(Map<String, dynamic> map) {
    return UserPageModel(
      lastPage: map['total_pages']?.toInt() ?? 0,
      users:
          List<UserModel>.from(map['data']?.map((x) => UserModel.fromJson(x))),
    );
  }
}
