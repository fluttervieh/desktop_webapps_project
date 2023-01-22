import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../ModelClasses/StoreItem.dart';
import 'TagContainer.dart';

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

    void safeNewEntry() {
      //TODO: some validation
      String alias = aliasController.text;
      String url = urlController.text;
      String username = usernameController.text;
      String password = passwordController.text;
      List<String> tags = item.tags;

      StoreItem updatedItem = StoreItem(item.uid, alias, url, username, password, tags);
      var updatedItemJson = jsonEncode(updatedItem);
      storage.write(key: item.uid, value: updatedItemJson.toString());

      Navigator.pop(context);
      updateParentState();
    }

    return Dialog(
        child: Column(
      children: [
        TextField(controller: aliasController),
        TextField(controller: urlController),
        TextField(controller: usernameController),
        TextField(controller: passwordController),
        Row(
          children: [
            TagContainer(
                title: "Shopping",
                selectedTags: item.tags,
                isSelected: item.tags.contains("Shopping"),
                isFilterItem: false,
                selectedFilterTags: [],
                updateParentState: () => () {}),
            TagContainer(
                title: "Social Media",
                selectedTags: item.tags,
                isSelected: item.tags.contains("Social Media"),
                isFilterItem: false,
                selectedFilterTags: [],
                updateParentState: () => () {}),
            TagContainer(
                title: "Other",
                selectedTags: item.tags,
                isSelected: item.tags.contains("Other"),
                isFilterItem: false,
                selectedFilterTags: [],
                updateParentState: () => () {}),
            TagContainer(
                title: "Porn",
                selectedTags: item.tags,
                isSelected: item.tags.contains("Porn"),
                isFilterItem: false,
                selectedFilterTags: [],
                updateParentState: () => () {}),
          ],
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