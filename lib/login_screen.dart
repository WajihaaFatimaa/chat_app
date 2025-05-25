import 'dart:developer';

import 'package:chat_app/chat_list.dart';
import 'package:chat_app/models/users.dart';
import 'package:chat_app/services/firebase_services.dart';
import 'package:chat_app/services/storage.dart';
import 'package:chat_app/signup_screen.dart';
import 'package:chat_app/utils/my_textfield.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    //getLogin();
  }

  // void getLogin() {
  //   User? myUser = Storage().getUser();
  //   if (myUser != null) {
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => ChatListScreen(mydata: myUser),
  //       ),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 241, 237, 237),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadiusDirectional.only(
                      bottomEnd: Radius.circular(25),
                      bottomStart: Radius.circular(25)),
                  gradient: LinearGradient(colors: [
                    Color(0xff000080),
                    const Color(0xff01579b),
                  ], begin: Alignment.topRight, end: Alignment.topLeft)),
              height: 250,
              width: double.infinity,
              child: Center(
                child: Text(
                  "Login!",
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 10,
              children: [
                MyTextField(placeholder: "Email", controller: emailController),
                MyTextField(
                    placeholder: "Password", controller: passwordController),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(Color(0xff000080),),
                          elevation: WidgetStatePropertyAll(9.0),
                          padding: WidgetStatePropertyAll(EdgeInsets.all(15))),
                      onPressed: () async {
                        if (emailController.text.isNotEmpty &&
                            passwordController.text.isNotEmpty) {
                          User? loggedInUser = await FirebaseServices()
                              .loginUser(passwordController.text,
                                  emailController.text);
                          if (loggedInUser != null) {
                            log("User Login :$loggedInUser");

                            // Saved User to Local Storage
                            await Storage().saveUser(loggedInUser);

                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChatListScreen(
                                    mydata: loggedInUser,
                                  ),
                                ));
                          }
                        }
                      },
                      child: Text(
                        "Login",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.bold),
                      )),
                )
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(19.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text("Don't have an Account"),
                  GestureDetector(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SignUpScreen())),
                    child: Text("Sign In",
                        style: TextStyle(
                            color: Color(0xff000080),
                            fontWeight: FontWeight.bold,
                            fontSize: 16)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
