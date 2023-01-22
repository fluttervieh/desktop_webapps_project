import 'dart:convert';
import 'package:desktop_webapp/ModelClasses/StoreItem.dart';
import 'package:desktop_webapp/widgets/EditPasswordDialog.dart';
import 'package:desktop_webapp/widgets/MasterPWDialog.dart';
import 'package:desktop_webapp/widgets/TagContainer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uuid/uuid.dart';
import 'package:desktop_webapp/encryptdecrypt.dart';
import 'dart:io' show Platform;

final storage = FlutterSecureStorage();
List<String> selectedFilterTags = [];
String searchCredential = "";

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  TextEditingController aliasController = TextEditingController();
  TextEditingController urlController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  TextEditingController searchCredentialController = TextEditingController();

  String? get _aliasErrorText {
    final aliasText = aliasController.text;
    if (aliasText.isEmpty || aliasText == "") {
      return 'Can\'t be empty';
    }
    return null;
  }

  String? get _urlErrorText {
    final urlText = urlController.value.text;

    if (urlText.isEmpty || urlText == "") {
      return 'Can\'t be empty';
    }
    return null;
  }

  String? get _usernameErrorText {
    final usernameText = usernameController.value.text;
    if (usernameText.isEmpty || usernameText == "") {
      return 'Can\'t be empty';
    }
    return null;
  }

  String? get _passwordErrorText {
    final passwordText = passwordController.value.text;

    if (passwordText.isEmpty || passwordText == "") {
      return 'Can\'t be empty';
    }
    return null;
  }

  var _text = '';

  Set activeListItems = {};

  void setActive(index) {
    setState(() {
      activeListItems.contains(index) ? activeListItems.remove(index) : activeListItems.add(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    void updateParentState() {
      setState(() {
        debugPrint("updated State");
      });
    }


    List<String> tagNames = ["Shopping", "Social Media", "Other", "Porn"];
    List<String> selectedTags = [];
    List<Widget> allTags = [];
    List<Widget> filterTags = [];


    tagNames.forEach((tag) {
      allTags.add(TagContainer(
        title: tag, 
        selectedTags: selectedTags, 
        isSelected: selectedTags.contains(tag), 
        isFilterItem: false, 
        selectedFilterTags: [],
        updateParentState: ()=> updateParentState()));
      filterTags.add(TagContainer(
        title: tag,
        selectedTags: selectedFilterTags,
        isSelected: selectedFilterTags.contains(tag),
        isFilterItem: true,
        selectedFilterTags: selectedFilterTags,
        updateParentState: () => updateParentState()));
    });


    
    return Scaffold(
      body: Row(
        children: <Widget>[
          //left section of the key manager
          //in future, we have to wrap this on in a future builder to get the async stuff
          Expanded(
              child: Container(
            child: Column(
              children: <Widget>[
                //searchbar
                Row(
                  children: <Widget>[
                    Expanded(
                        flex: 9,
                        child: TextField(
                          controller: searchCredentialController,
                        )),
                    IconButton(
                        onPressed: (() {
                          debugPrint(searchCredentialController.text);
                          searchCredential = searchCredentialController.text;
                          debugPrint("pressss");
                          updateParentState();
                        }),
                        icon: const Icon(Icons.search))
                  ],
                ),
                Row(
                  children: filterTags,
                ),
                Expanded(
                  child: FutureBuilder(
                    future: getAllFromStorage(selectedFilterTags),
                    builder: ((BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data.length,
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: () {
                                  if (activeListItems.contains(index)) {
                                    setActive(index);
                                  } else {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          TextEditingController pwController = TextEditingController();
                                          return MasterPWDialog(pwController: pwController, onPasswordValidated: ()=> makePasswordVisibleIfValidatedAndPop(pwController, index));
                                        });
                                  }
                                },
                                child: Container(
                                  color: Colors.white,
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                                        child: Row(
                                          children: [
                                            Expanded(
                                                flex: 7,
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(snapshot.data[index].identifier,
                                                        style: const TextStyle(fontWeight: FontWeight.bold)),
                                                    Text(snapshot.data[index].url),
                                                    Text("username: " + snapshot.data[index].username),

                                                    // TODO use decrypt instead of decryptLocal
                                                    // TODO use master password instead of test
                                                    activeListItems.contains(index)
                                                        ? Text("password: " +
                                                            (Encryptdecrypt.decryptLocal(
                                                                "test", snapshot.data[index].password)))
                                                        : Container(height: 0),
                                                  ],
                                                )),
                                            Expanded(
                                              flex: 1,
                                              child: IconButton(
                                                icon: const Icon(Icons.edit),
                                                onPressed: () {
                                                  //alert fenster
                                                  //editen
                                                  showDialog(
                                                      context: context,
                                                      builder: (BuildContext context) {
                                                        return EditPasswordDialog(
                                                            item: snapshot.data[index],
                                                            updateParentState: () => updateParentState());
                                                      });
                                                },
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: IconButton(
                                                icon: const Icon(Icons.delete),
                                                onPressed: () {
                                                  setState(() {
                                                    debugPrint("item deleted");
                                                    storage.delete(key: snapshot.data[index].uid);
                                                  });
                                                },
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: activeListItems.contains(index)
                                                  ? const Icon(Icons.visibility_off)
                                                  : const Icon(Icons.visibility),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            });
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    }),
                  ),
                ),
              ],
            ),
          )),
          //right section
          //here we can view our passwords or create a new entry
          Expanded(
              flex: 1,
              child: Container(
                  child: Column(
                children: <Widget>[
                  const Text("Neues Passwort hinzufügen"),
                  TextField(
                    controller: aliasController,
                    decoration: InputDecoration(hintText: "Alias", errorText: _aliasErrorText),
                    onChanged: (text) => setState(() => _text),
                  ),
                  TextField(
                    controller: urlController,
                    decoration: InputDecoration(hintText: "URL", errorText: _urlErrorText),
                    onChanged: (text) => setState(() => _text),
                  ),
                  TextField(
                    controller: usernameController,
                    decoration: InputDecoration(hintText: "Username", errorText: _usernameErrorText),
                    onChanged: (text) => setState(() => _text),
                  ),
                  TextField(
                    controller: passwordController,
                    decoration: InputDecoration(hintText: "Password", errorText: _passwordErrorText),
                    onChanged: (text) => setState(() => _text),
                  ),
                  //Tag section
                  Row(
                    children: allTags,
                  )
                ],
              )))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (validateInputs()) {
            const uuid = Uuid();
            String alias = aliasController.text;
            String url = urlController.text;
            String username = usernameController.text;
            String password = passwordController.text;

            StoreItem newItem = StoreItem(uuid.v4(), alias, url, username, password, selectedTags);
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  TextEditingController pwController = TextEditingController();
                  return MasterPWDialog(pwController: pwController, onPasswordValidated: ()=> resetInputFieldsAndPop(newItem, pwController, selectedTags),);
                });
            //await addItemToStore(newItem);
          } else {
            return;
          }
        },
        tooltip: 'add new entry',
        child: const Icon(Icons.add),
      ),
    );
  }

  //for adding a new storeitem
  void resetInputFieldsAndPop(StoreItem item, TextEditingController masterPwController, List<String> selectedTags){
    Navigator.of(context).pop();
    addItemToStore(item, masterPwController.text);
    masterPwController.text = "";
    setState(() {
      selectedTags = [];
      aliasController.text = "";
      usernameController.text = "";
      urlController.text = "";
      passwordController.text = "";
    });
  }

  //for making a pw visible
  void makePasswordVisibleIfValidatedAndPop(TextEditingController masterPwController, int index){
    setState(() {
      setActive(index);
      masterPwController.text = "";
      debugPrint(masterPwController.text);
      Navigator.of(context).pop();
    });
  }


  bool validateInputs() {
    if (_aliasErrorText != null) {
      return false;
    }
    if (_usernameErrorText != null) {
      return false;
    }
    if (_urlErrorText != null) {
      return false;
    }
    if (_passwordErrorText != null) {
      return false;
    }
    return true;
  }


}



Future<void> addItemToStore(StoreItem item, String masterPassword) async {
  // encrypt the password with the master password

  // TODO check encryption
  // item.password = await Encryptdecrypt.encrypt(masterPassword, item.password);
  var json = jsonEncode(item);
  await storage.write(key: item.uid, value: json.toString());
}

//Diese funktion ist sehr schrecklich geschrieben, tut mir leid :-(
Future<List<StoreItem>> getAllFromStorage(List<String> selectedFilterTags) async {
  List<StoreItem> fetchedStoreItems = [];
  //await storage.deleteAll();
  final all = await storage.readAll();

  all.forEach((key, value) {
    StoreItem item = StoreItem.fromJson(jsonDecode(value));

    if (selectedFilterTags.isEmpty && (searchCredential == "" || searchCredential.isEmpty)) {
      fetchedStoreItems.add(item);
    } else if (searchCredential != "") {
      debugPrint("hier komi nei");
      if ((item.identifier.contains(searchCredential) || item.url.contains(searchCredential)) &&
          !fetchedStoreItems.contains(item)) {
        fetchedStoreItems.add(item);
      }
    } else {
      //fetchedStoreItems = [];
      for (var selectedFilter in selectedFilterTags) {
        if (item.tags.contains(selectedFilter) && !fetchedStoreItems.contains(item)) {
          fetchedStoreItems.add(item);
        }
      }
    }
  });
  return fetchedStoreItems;
}
