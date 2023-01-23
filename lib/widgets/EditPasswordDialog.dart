import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../ModelClasses/StoreItem.dart';
import 'TagContainer.dart';
import 'dart:io' show Platform;

class EditPasswordDialog extends StatelessWidget {
  const EditPasswordDialog({
    Key? key,
    required this.item,
    required this.updateParentState,
  }) : super(key: key);
  final StoreItem item;
  final Function updateParentState;

  @override
  Widget build(BuildContext context) {
    TextEditingController aliasController = TextEditingController();
    TextEditingController urlController = TextEditingController();
    TextEditingController usernameController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    aliasController.text = item.identifier;
    urlController.text = item.url;
    usernameController.text = item.username;
    passwordController.text = item.password;

    FlutterSecureStorage storage = const FlutterSecureStorage();

    Future<void> safeNewEntry() async {
      //TODO: some validation
      String alias = aliasController.text;
      String url = urlController.text;
      String username = usernameController.text;
      String password = passwordController.text;
      List<String> tags = item.tags;

      StoreItem updatedItem = StoreItem(item.uid, alias, url, username, password, tags);
      var updatedItemJson = jsonEncode(updatedItem);

      if (!kIsWeb && Platform.isMacOS) {
        // use alternative storage
        final SharedPreferences macStorage = await SharedPreferences.getInstance();
        macStorage.setString(item.uid, updatedItemJson.toString());
      } else {
        await storage.write(key: item.uid, value: updatedItemJson.toString());
      }

      Navigator.pop(context);
      updateParentState();
    }

    List<String> tagNames = ["Shopping", "Social Media", "Other", "Porn"];
    List<Widget> allTags = [];

    tagNames.forEach((tag) {
      allTags.add(TagContainer(
          title: tag,
          selectedTags: item.tags,
          isSelected: item.tags.contains(tag),
          isFilterItem: false,
          selectedFilterTags: [],
          updateParentState: () => () {}));
    });

    return Dialog(
        child: Column(
      children: [
        TextField(controller: aliasController),
        TextField(controller: urlController),
        TextField(controller: usernameController),
        TextField(controller: passwordController),
        Row(
          children: allTags,
        ),
        Row(
          children: [
            ElevatedButton(onPressed: () => Navigator.of(context).pop(), child: const Text("cancel")),
            ElevatedButton(onPressed: () => safeNewEntry(), child: const Text("save"))
          ],
        )
      ],
    ));
  }
}
