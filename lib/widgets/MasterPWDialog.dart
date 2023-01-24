import 'package:flutter/material.dart';

class MasterPWDialog extends StatefulWidget {
  const MasterPWDialog({
    Key? key,
    required this.pwController,
    required this.onPasswordValidated,
    required this.isShowPasswordDialog
  }) : super(key: key);

  final TextEditingController pwController;
  final Function onPasswordValidated;
  final bool isShowPasswordDialog;

  static TextEditingController showPWController = TextEditingController();

  @override
  State<MasterPWDialog> createState() => _MasterPWDialogState();
}

class _MasterPWDialogState extends State<MasterPWDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        height: MediaQuery.of(context).size.height / 3,
        width: MediaQuery.of(context).size.width / 4,
        child: Column(
          children: [
            const Text("Enter your master password."),
            TextField(controller: widget.pwController),
            ElevatedButton(
                onPressed: () {
                  // TODO mabe check for master password
                   if (widget.pwController.text != "test") {
                    return;
                  } else {
                    debugPrint(MasterPWDialog.showPWController.text);
                    widget.onPasswordValidated();
                  }
                },
                child: const Text("Submit")),
                widget.isShowPasswordDialog?TextField(controller: MasterPWDialog.showPWController, enabled: false,): const Text(""),
                widget.isShowPasswordDialog?ElevatedButton(onPressed: ()=> setState(() {
                  MasterPWDialog.showPWController.text = "";
                  Navigator.pop(context);
                }), child: const Text("close")): const Text("")
          ],
        ),
      ),
    );
  }
}