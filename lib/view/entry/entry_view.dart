import 'package:flash_chat/view/login/login_view.dart';
import 'package:flash_chat/view/register/register_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class EntryView extends StatelessWidget {
  const EntryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Entry View"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustonButonWidget(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LoginView()));
            },
            text: "Sign In",
          ),
          CustonButonWidget(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => RegisterView()));
            },
            text: "Sign Up",
          ),
        ],
      ),
    );
  }
}

class CustonButonWidget extends StatelessWidget {
  CustonButonWidget({
    super.key,
    required this.text,
    required this.onPressed,
  });
  final String text;
  final void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
            padding: const EdgeInsets.symmetric(horizontal: 150, vertical: 5),
            textStyle:
                const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          onPressed: onPressed,
          child: Text(text)),
    );
  }
}
