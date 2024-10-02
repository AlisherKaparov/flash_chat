import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat/model/chat_model.dart';
import 'package:flash_chat/model/user_model.dart';
import 'package:flutter/material.dart';

class ChatView extends StatefulWidget {
  final UserModel userModel;
  const ChatView({
    Key? key,
    required this.userModel,
  }) : super(key: key);

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final smsController = TextEditingController();
  final List<ChatModel> chatList = [];
  final message = FirebaseFirestore.instance.collection('message');

  Future<DocumentReference<Map<String, dynamic>>> addSms() {
    final chatModel = ChatModel(
        messageId: widget.userModel.userId,
        message: smsController.text,
        userName: widget.userModel.userName);
    final messageCollection = message.add(
      chatModel.toMap(),
    );

    return messageCollection;
  }

  Stream<List<ChatModel>> getmessage() {
    return message.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return ChatModel.fromMap(doc.data());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('User Name: ${widget.userModel.userName}'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              StreamBuilder<List<ChatModel>>(
                  stream: getmessage(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<ChatModel>> snapshot) {
                    if (snapshot.hasError) {
                      return Text('Something went wrong');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    final chatList = snapshot.data!;

                    return Expanded(
                      child: ListView.builder(
                          itemCount: chatList.length,
                          itemBuilder: (context, index) {
                            //final chat = chatList[index];

                            return ListTile(
                              title: Text(chatList[index].userName ?? ""),
                              subtitle: Text(chatList[index].message ?? ''),
                            );
                          }),
                    );
                  }),
              Expanded(
                child: TextField(
                  controller: smsController,
                  onChanged: (value) {
                    smsController.text = value;
                    log('Sms Controller --> ${smsController.text}');
                  },
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(
                        borderSide: BorderSide(
                      color: Colors.blue,
                    )),
                    suffixIcon: IconButton(
                      onPressed: () {
                        if (smsController.text.isEmpty) {
                          log('Sms bosh turat');
                        } else {
                          addSms();
                          log('Sms koshuldu');
                          smsController.clear();
                          FocusManager.instance.primaryFocus?.unfocus();
                          setState(() {});
                        }
                      },
                      icon: const Icon(
                        Icons.send,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
