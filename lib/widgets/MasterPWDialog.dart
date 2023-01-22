import 'package:flutter/material.dart';

class MasterPWDialog extends StatelessWidget {
  const MasterPWDialog({
    Key? key,
    required this.pwController,
    required this.onPasswordValidated
  }) : super(key: key);

  final TextEditingController pwController;
  final Function onPasswordValidated;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        height: MediaQuery.of(context).size.height / 3,
        width: MediaQuery.of(context).size.width / 4,
        child: Column(
          children: [
            const Text("Enter your master password."),
            TextField(controller: pwController),
            ElevatedButton(
                onPressed: () {
                  // TODO mabe check for master password
                   if (pwController.text != "test") {
                    return;
                  } else {
                    onPasswordValidated();
                  }
                },
                child: const Text("Submit"))
          ],
        ),
      ),
    );
  }
}