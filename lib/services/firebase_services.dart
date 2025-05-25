import 'dart:developer';

import 'package:chat_app/models/message.dart';
import 'package:chat_app/models/users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

const userCollection = "users";
const userEmail = 'userEmail';
const userPass = 'userPassword';
const messageCollection = "messages";

class FirebaseServices {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> registerUser(User user) async {
    try {
      var databaseuser = await _firestore
          .collection(userCollection)
          .where(userEmail, isEqualTo: user.userEmail)
          .get();

      if (databaseuser.docs.isNotEmpty) {
        return "User Already Exist";
      }
      await _firestore.collection(userCollection).doc().set(user.toJson());
      return "User Registered Sucessfully";
    } on Exception catch (e) {
      print("Error occurs while register user $e");
      return "Error occurs while register user $e";
    }
  }

  Future<User?> loginUser(String pass, String email) async {
    try {
      var databaseuser = await _firestore
          .collection(userCollection)
          .where(userEmail, isEqualTo: email)
          .where(userPass, isEqualTo: pass)
          .get();
      if (databaseuser.docs.isEmpty) {
        debugPrint("User is Empty in DataBase");
      }
      var loginuser = databaseuser.docs.first;

      User myLoginData = User.fromJson(loginuser.data());
      return myLoginData;
    } catch (e) {
      print("Error occurs while Login user $e");
    }
  }

  Future<List<User>?> allUsers() async {
    var data = await _firestore.collection(userCollection).get();

    try {
      if (data.docs.isNotEmpty) {
        log("User Loading and not empty");
        return data.docs.map((user) {
          return User.fromJson(user.data());
        }).toList();
      } else {
        log("User List is Empty");
      }
    } on Exception catch (e) {
      log("Error while Getting Chat Users: $e");
    }
  }

  Future<void> sendMesage(Message message) async {
    try {
      await _firestore
          .collection(messageCollection)
          .doc()
          .set(message.toJson());
    } catch (e) {
      log("Error while Adding Message: $e");
    }
  }

  Stream<List<Message>> fetchMessage() {
    return _firestore.collection(messageCollection).snapshots().map((doc) {
      return doc.docs.map((data) {
        return Message.fromJson(data.data());
      }).toList();
    });
  }
}
