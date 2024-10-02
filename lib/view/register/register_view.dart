import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/model/user_model.dart';
import 'package:flash_chat/view/chat/chat_view.dart';
import 'package:flash_chat/view/entry/entry_view.dart';
import 'package:flutter/material.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  Future<void> addUser(String uid) {
    final userModel = UserModel(
      userId: uid,
      userName: nameController.text,
      email: emailController.text,
    );
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .set(userModel.toMap())
        // .add({

        // })
        .then((value) => {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatView(
                    userModel: userModel,
                  ),
                ),
              ),
            })
        .catchError((error) => log('Failed to add user:$error'));
  }

  Future signUp() async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        //name: nameController.text,
        email: emailController.text,
        password: passwordController.text,
      );
      addUser(credential.user!.uid);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        log('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        log('The account already exists for that email.');
      }
    } catch (e) {
      log(' ');
    }
  }
  //CRUD!!!
  //Create
  //Read
  //Update
  //Delete

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Singn up'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 70),
            child: TextField(
              controller: nameController,
              onChanged: (value) {
                log('name controller --> ${nameController}');
                nameController.text;
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30))),
                isDense: true,
                labelText: 'Name',
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
              text: 'Sign Up',
              onPressed: () {
                FocusManager.instance.primaryFocus?.unfocus();
                signUp();
              })
          //CustomButtonWidget(text: '', on)
        ],
      ),
    );
  }
}
