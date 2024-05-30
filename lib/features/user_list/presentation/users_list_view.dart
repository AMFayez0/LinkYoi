import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class UserListView extends StatefulWidget {
  const UserListView({super.key});

  @override
  UserListViewState createState() => UserListViewState();
}

class UserListViewState extends State<UserListView> {
  List<dynamic> users = [];
  int _currentPage = 1;
  bool _isLoading = false;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    final response = await http
        .get(Uri.parse('https://reqres.in/api/users?page=$_currentPage'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _currentPage++;
        _isLoading = false;
        users.addAll(data['data']);
        if (_currentPage > data['total_pages']) {
          _hasMore = false;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Users List')),
      body: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (!_isLoading &&
              _hasMore &&
              scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
            _fetchUsers();
          }
          return false;
        },
        child: ListView.builder(
          itemCount: users.length + 1,
          itemBuilder: (context, index) {
            if (index == users.length) {
              return _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : const SizedBox.shrink();
            }
            final user = users[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(user['avatar']),
              ),
              title: Text('${user['first_name']} ${user['last_name']}'),
              subtitle: Text(user['email']),
            );
          },
        ),
      ),
    );
  }
}
