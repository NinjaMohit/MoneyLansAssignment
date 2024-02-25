import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/user.dart';
import 'signin_dialog.dart';
import 'user_details_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});
  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  late SharedPreferences _prefs;
  late List<User> _users;
  late List<String> _signedInUsers;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    _prefs = await SharedPreferences.getInstance();
    const jsonData =
        '[{"users":[{"name":"Krishna","id":"1","atype":"Permanent"},{"name":"Sameera","id":"2","atype":"Permanent"},{"name":"Radhika","id":"3","atype":"Permanent"},{"name":"Yogesh","id":"4","atype":"Permanent"},{"name":"Radhe","id":"5","atype":"Permanent"},{"name":"Anshu","id":"6","atype":"Permanent"},{"name":"Balay","id":"7","atype":"Permanent"},{"name":"Julie","id":"8","atype":"Permanent"},{"name":"Swaminathan","id":"9","atype":"Permanent"},{"name":"Charandeep","id":"10","atype":"Permanent"},{"name":"Sankaran","id":"11","atype":"Permanent"},{"name":"Alpa","id":"12","atype":"Permanent"},{"name":"Sheth","id":"13","atype":"Temproary"},{"name":"Sabina","id":"14","atype":"Temproary"}]}]';
    final decodedData = jsonDecode(jsonData);
    final usersData = decodedData[0]['users'] as List<dynamic>;
    _users = usersData
        .map((userData) => User(
              id: userData['id'].toString(),
              name: userData['name'],
              atype: userData['atype'],
            ))
        .toList();
    _signedInUsers = _prefs.getStringList('signedInUsers') ?? [];
    setState(() {});
  }

  Future<void> _handleSignIn(User user) async {
    if (!_signedInUsers.contains(user.id)) {
      await showDialog(
        context: context,
        builder: (context) => SignInDialog(user: user),
      );
      _signedInUsers.add(user.id);
      await _prefs.setStringList('signedInUsers', _signedInUsers);
      setState(() {});
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UserDetailsScreen(user: user),
        ),
      );
    }
  }

  void _handleSignOut(User user) async {
    _signedInUsers.remove(user.id);
    await _prefs.setStringList('signedInUsers', _signedInUsers);
    setState(() {});
  }

  List<Color> allcolor = [
    const Color.fromRGBO(250, 232, 232, 1),
    const Color.fromARGB(255, 205, 246, 240),
    const Color.fromRGBO(232, 237, 250, 1),
    const Color.fromRGBO(250, 249, 232, 1),
    const Color.fromARGB(255, 226, 182, 227),
    const Color.fromRGBO(250, 232, 250, 1),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(197, 239, 247, 1),
      appBar: AppBar(
        backgroundColor: Colors.greenAccent.shade200,
        title: const Text(
          ' User Sign In / Out',
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 26),
        ),
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.menu),
        ),
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
          side: BorderSide(width: 1, color: Colors.black),
        ),
        bottom: const PreferredSize(
            preferredSize: Size.fromHeight(20), child: SizedBox()),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
          ),
        ),
      ),
      body: ListView.separated(
        itemCount: _users.length,
        itemBuilder: (context, index) {
          final user = _users[index];
          return Container(
            height: 100,
            padding: const EdgeInsets.only(top: 17),
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(width: 0.5),
              color: allcolor[index % allcolor.length],
            ),
            child: ListTile(
              title: GestureDetector(
                  child: Row(
                    children: [
                      const SizedBox(
                        height: 8,
                      ),
                      Container(
                        color: allcolor[index % allcolor.length],
                        height: 50,
                        width: 145,
                        child: Center(
                          child: Text(
                            user.name,
                            style: const TextStyle(
                                fontSize: 24, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    if (_signedInUsers.contains(user.id)) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserDetailsScreen(user: user),
                        ),
                      );
                    }
                  }),
              trailing: _signedInUsers.contains(user.id)
                  ? ElevatedButton(
                      onPressed: () => _handleSignOut(user),
                      style: const ButtonStyle(
                          fixedSize: MaterialStatePropertyAll(Size(135, 35)),
                          backgroundColor: MaterialStatePropertyAll(
                            Color.fromRGBO(181, 171, 244, 1),
                          ),
                          side:
                              MaterialStatePropertyAll(BorderSide(width: 0.5))),
                      child: const Text(
                        'Sign Out',
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                            color: Colors.black),
                      ),
                    )
                  : ElevatedButton(
                      onPressed: () => _handleSignIn(user),
                      style: const ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(
                          Color.fromRGBO(181, 171, 244, 1),
                        ),
                        side: MaterialStatePropertyAll(BorderSide(width: 0.5)),
                        fixedSize: MaterialStatePropertyAll(Size(130, 35)),
                      ),
                      child: const Text(
                        'Sign In',
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                            color: Colors.black),
                      ),
                    ),
            ),
          );
        },
        separatorBuilder: (context, index) {
          return const SizedBox(
            height: 10,
          );
        },
      ),
    );
  }
}
