import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class User {
  final String id;
  final String name;
  final String atype;
  int? age;
  String? gender;

  User({
    required this.id,
    required this.name,
    required this.atype,
    this.age,
    this.gender,
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User Sign In/Out',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SignInScreen(),
    );
  }
}

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);
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
        '[{"users":[{"name":"Krishna","id":"1","atype":"Permanent"},{"name":"Sameera","id":"2","atype":"Permanent"},{"name":"Radhika","id":"3","atype":"Permanent"},{"name":"Yogesh","id":"4","atype":"Permanent"},{"name":"Radhe","id":"5","atype":"Permanent"},{"name":"Anshu","id":"6","atype":"Permanent"},{"name":"Balay","id":"7","atype":"Permanent"},{"name":"Julie","id":"8","atype":"Permanent"},{"name":"Swaminathan","id":"9","atype":"Permanent"},{"name":"Charandeep","id":"10","atype":"Permanent"},{"name":"Sankaran","id":"11","atype":"Permanent"},{"name":"Alpa","id":"12","atype":"Permanent"},{"name":"Sheth","id":"13","atype":"Temporary"},{"name":"Sabina","id":"14","atype":"Temporary"}]}]';
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
          builder: (context) => UserDetailsScreen(user: user, prefs: _prefs),
        ),
      );
    }
  }

  void _handleSignOut(User user) async {
    _signedInUsers.remove(user.id);
    await _prefs.remove(user.id); // Remove user-specific data
    await _prefs.setStringList('signedInUsers', _signedInUsers);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Sign In/Out'),
      ),
      body: ListView.builder(
        itemCount: _users.length,
        itemBuilder: (context, index) {
          final user = _users[index];
          return ListTile(
            title: GestureDetector(
              child: Text(user.name),
              onTap: () {
                if (_signedInUsers.contains(user.id)) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          UserDetailsScreen(user: user, prefs: _prefs),
                    ),
                  );
                }
              },
            ),
            trailing: _signedInUsers.contains(user.id)
                ? ElevatedButton(
                    onPressed: () => _handleSignOut(user),
                    child: const Text('Sign Out'),
                  )
                : ElevatedButton(
                    onPressed: () => _handleSignIn(user),
                    child: const Text('Sign In'),
                  ),
          );
        },
      ),
    );
  }
}

// ... (existing code)

class SignInDialog extends StatefulWidget {
  final User user;

  const SignInDialog({Key? key, required this.user}) : super(key: key);

  @override
  State<SignInDialog> createState() => _SignInDialogState();
}

class _SignInDialogState extends State<SignInDialog> {
  late TextEditingController _ageController;
  late TextEditingController _genderController;
  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _ageController = TextEditingController();
    _genderController = TextEditingController();
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    _ageController.text =
        _prefs.getInt('${widget.user.id}_age')?.toString() ?? '';
    _genderController.text = _prefs.getString('${widget.user.id}_gender') ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Fill in your details'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _ageController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Age'),
          ),
          TextField(
            controller: _genderController,
            decoration: const InputDecoration(labelText: 'Gender'),
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () async {
            final age = int.tryParse(_ageController.text);
            final gender = _genderController.text;
            if (age != null && gender.isNotEmpty) {
              widget.user.age = age;
              widget.user.gender = gender;

              // Save user details to SharedPreferences
              await _prefs.setInt('${widget.user.id}_age', age);
              await _prefs.setString('${widget.user.id}_gender', gender);

              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      UserDetailsScreen(user: widget.user, prefs: _prefs),
                ),
              );
            }
          },
          child: const Text('Submit'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _ageController.dispose();
    _genderController.dispose();
    super.dispose();
  }
}

// ... (existing code)

class UserDetailsScreen extends StatelessWidget {
  final User user;
  final SharedPreferences? prefs;

  const UserDetailsScreen({Key? key, required this.user, this.prefs})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Details'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Name: ${user.name}'),
            Text('Age: ${user.age ?? 'Not provided'}'),
            Text('Gender: ${user.gender ?? 'Not provided'}'),
          ],
        ),
      ),
    );
  }
}
