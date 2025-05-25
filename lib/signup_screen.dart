import 'package:chat_app/models/users.dart';
import 'package:chat_app/services/firebase_services.dart';
import 'package:chat_app/utils/my_textfield.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController phNumController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
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
                   const Color(0xff000080),
                   const Color(0xff01579b),
                    // const Color.fromARGB(179, 243, 122, 217)
                  ], begin: Alignment.topRight, end: Alignment.topLeft)),
              height: 220,
              width: double.infinity,
              child: Center(
                child: Text(
                  "Sign Up!",
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
                MyTextField(
                    placeholder: "Full Name", controller: fullNameController),
                MyTextField(
                    placeholder: "Phone Number", controller: phNumController),
                MyTextField(placeholder: "Email", controller: emailController),
                MyTextField(
                    placeholder: "Password", controller: passwordController),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(Color(0xff000080)),
                          elevation: WidgetStatePropertyAll(9.0),
                          padding: WidgetStatePropertyAll(EdgeInsets.all(15))),
                      onPressed: () async {
                        var phNum = int.parse(phNumController.text);
                        var currentDate = DateTime.now();
                        var id = phNum +
                            currentDate.day +
                            currentDate.hour +
                            currentDate.millisecond +
                            currentDate.year;
                        User registerUser = User(
                            id: id,
                            userName: fullNameController.text,
                            userEmail: emailController.text,
                            userPassword: passwordController.text,
                            phNumber: phNum,
                            status: 1);

                        String resultRegister =
                            await FirebaseServices().registerUser(registerUser);
                        print("USer Register Result:  $resultRegister");
                        if (resultRegister=="User Registered Sucessfully") {
                         if (context.mounted) {
                           Navigator.pop(context);
                         }
                          
                        }
                      },
                      child: Text(
                        "SignUp",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.bold),
                      )),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
