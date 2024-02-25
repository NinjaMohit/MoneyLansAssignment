import 'user_details_screen.dart';
import 'package:flutter/material.dart';
import '../model/user.dart';

class SignInDialog extends StatefulWidget {
  final User user;

  const SignInDialog({Key? key, required this.user}) : super(key: key);

  @override
  State<SignInDialog> createState() => _SignInDialogState();
}

class _SignInDialogState extends State<SignInDialog> {
  late TextEditingController _ageController;
  late TextEditingController _genderController;

  @override
  void initState() {
    super.initState();
    _ageController = TextEditingController();
    _genderController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color.fromRGBO(181, 171, 244, 1),
      title: const Text(
        'Fill in your details',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _ageController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
                hintText: " Age",
                fillColor: Colors.black,
                hintStyle: TextStyle(fontWeight: FontWeight.w500),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(30),
                  ),
                ),
                labelText: 'Enter a Age',
                labelStyle: TextStyle(fontWeight: FontWeight.bold)),
            cursorColor: Colors.black,
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            controller: _genderController,
            decoration: const InputDecoration(
                hintText: "Gender",
                hintStyle: TextStyle(fontWeight: FontWeight.w500),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(30),
                  ),
                ),
                prefixIconColor: Colors.black,
                suffixIconColor: Colors.red,
                labelText: 'Enter a Gender',
                labelStyle: TextStyle(fontWeight: FontWeight.bold)),
            cursorColor: Colors.black,
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            final age = int.tryParse(_ageController.text);
            final gender = _genderController.text;
            if (age != null && gender.isNotEmpty) {
              widget.user.age = age;
              widget.user.gender = gender;
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserDetailsScreen(user: widget.user),
                ),
              );
            }
          },
          style: const ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(
              Color.fromRGBO(183, 225, 166, 1),
            ),
          ),
          child: const Text(
            'Submit',
            style: TextStyle(fontWeight: FontWeight.w400),
          ),
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
