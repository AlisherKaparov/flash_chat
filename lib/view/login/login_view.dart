import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/model/user_model.dart';
import 'package:flash_chat/view/chat/chat_view.dart';
import 'package:flash_chat/view/entry/entry_view.dart';
import 'package:flutter/material.dart';

class LoginView extends StatelessWidget {
  LoginView({Key? key}) : super(key: key);
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  Future login(BuildContext context) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      getUser(credential.user!.uid, context);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        log('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        log('Wrong password provided for that user.');
      }
    }
  }

  Future<UserModel> getUser(String uid, BuildContext context) async {
    final userData =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    final userModel = UserModel.fromMap(userData.data()!);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatView(
          userModel: userModel,
        ),
      ),
    );
    return userModel;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Singn up'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 70),
            child: TextField(
              controller: emailController,
              onChanged: (value) {
                log('name controller --> ${emailController}');
                emailController.text;
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30))),
                isDense: true,
                labelText: 'Email',
                labelStyle: TextStyle(fontSize: 14),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 70),
            child: TextField(
              controller: passwordController,
              onChanged: (value) {
                log('password controller --> ${passwordController}');
                passwordController.text;
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30))),
                isDense: true,
                labelText: 'Password',
                labelStyle: TextStyle(fontSize: 14),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          CustonButonWidget(
              text: 'Login',
              onPressed: () {
                login(context);
                FocusManager.instance.primaryFocus?.unfocus();
              })
          //CustomButtonWidget(text: '', on)
        ],
      ),
    );
  }
}
