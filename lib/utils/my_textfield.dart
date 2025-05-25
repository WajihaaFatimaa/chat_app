import 'package:flutter/material.dart';

class MyTextField extends StatefulWidget {
  final String placeholder;
  final Widget? suffixIcon;
  final TextEditingController controller;
  const MyTextField(
      {super.key,
      required this.placeholder,
      required this.controller,
      this.suffixIcon});

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      decoration: InputDecoration(
          suffixIcon: widget.suffixIcon,
          focusColor:Color(0xff000080),
          // Colors.pink,
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(17),
              borderSide: BorderSide(color: Color(0xff000080), width: 2.5)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(17),
              borderSide: BorderSide(color: Color(0xff000080), width: 2.5)),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(17),
              borderSide: BorderSide(color: Color(0xff000080), width: 2.5)),
          labelText: widget.placeholder,
          labelStyle: TextStyle(color: Color(0xff000080),)),
    );
  }
}
