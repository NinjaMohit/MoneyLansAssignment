import 'package:flutter/material.dart';
import '../model/user.dart';

class UserDetailsScreen extends StatelessWidget {
  final User user;

  const UserDetailsScreen({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent.shade200,
        title: const Text(
          ' User Details',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 30),
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
          side: BorderSide(width: 2, color: Colors.black),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.fromARGB(255, 0, 0, 0),
              ],
              transform: GradientRotation(900),
            ),
          ),
        ),
      ),
      body: Center(
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(20),
          height: 300,
          width: 300,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(width: 2),
            color: const Color.fromARGB(255, 238, 169, 250),
            boxShadow: [
              BoxShadow(
                color: Colors.greenAccent.shade200,
                offset: const Offset(
                  5.0,
                  5.0,
                ),
                blurRadius: 10.0,
                spreadRadius: 4.0,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(
                flex: 1,
              ),
              Text(
                'Name : ${user.name}',
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
              ),
              const Spacer(
                flex: 1,
              ),
              Text(
                'Age : ${user.age ?? 'Not provided'}',
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
              ),
              const Spacer(
                flex: 1,
              ),
              Text(
                'Gender : ${user.gender ?? 'Not provided'}',
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
              ),
              const Spacer(
                flex: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
