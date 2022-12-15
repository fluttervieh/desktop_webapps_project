import 'dart:convert';

import 'package:desktop_webapp/ModelClasses/StoreItem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uuid/uuid.dart';


class MainScreen extends StatefulWidget {
  const MainScreen({ Key? key }) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  final storage = FlutterSecureStorage();

  TextEditingController aliasController = TextEditingController();
  TextEditingController urlController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String? get _aliasErrorText {
    final aliasText = aliasController.text;
    if(aliasText.isEmpty || aliasText == ""){
      return 'Can\'t be empty';
    }
    return null;
  }
  String? get _urlErrorText {
    final urlText = urlController.value.text;
   
    if(urlText.isEmpty || urlText == ""){
      return 'Can\'t be empty';
    }
    return null;
  }
  String? get _usernameErrorText {
    final usernameText = usernameController.value.text;
    if(usernameText.isEmpty || usernameText == ""){
      return 'Can\'t be empty';
    }
    return null;
  }
  String? get _passwordErrorText {
    
    final passwordText = passwordController.value.text;

    if(passwordText.isEmpty || passwordText == ""){
      return 'Can\'t be empty';
    }
    return null;
  }

  var _text = '';

  Future<List<StoreItem>> getAllFromStorage()async{
    List<StoreItem> fetchedStoreItems = [];
    final all = await storage.readAll();

    all.forEach((key, value) {
      //parse JSON
      //StoreItem item = StoreItem.fromJson(value);
      debugPrint(value);
      StoreItem item = StoreItem.fromJson(jsonDecode(value));
      fetchedStoreItems.add(item);
    });

    return fetchedStoreItems;
  }

  //parses json
  Future<void>addItemToStore(StoreItem item)async{
    const uuid = Uuid();
    String json = jsonEncode(item);
    debugPrint(json);
    await storage.write(key: uuid.v4(), value: json);
  }

  @override
  Widget build(BuildContext context) {

 
    List<String> selectedTags = [];
    List<Widget> allTags = [];
    allTags.add(TagContainer(title: "Shopping", selectedTags: selectedTags, isSelected: selectedTags.contains("Shopping")));
    allTags.add(TagContainer(title: "Social Media", selectedTags: selectedTags, isSelected: selectedTags.contains("Social Media")));
    allTags.add(TagContainer(title: "Other", selectedTags: selectedTags, isSelected: selectedTags.contains("Other")));
    allTags.add(TagContainer(title: "Porn", selectedTags: selectedTags, isSelected: selectedTags.contains("Porn")));
  
    return Scaffold(
      body: Row(
        children:<Widget> [
          //left section of the key manager
          //in future, we have to wrap this on in a future builder to get the async stuff
          Expanded(
            flex: 1,
            child: Container(
              child: Column(
                children: <Widget>[
                  //searchbar
                  const TextField(),
                  Expanded(
                    child: FutureBuilder(
                      future: getAllFromStorage(),
                      builder: ((BuildContext context, AsyncSnapshot snapshot) {
                        if(snapshot.hasData){
                          return ListView.builder(
                            shrinkWrap: true,        
                            itemCount: snapshot.data.length,
                            itemBuilder: (BuildContext context, int index){
                              return ListTile(
                                title: Text(snapshot.data[index].url),
                                subtitle: Text(snapshot.data[index].username),
                                tileColor: Colors.white,
                                hoverColor: Colors.grey,
                              );
                            }
                          );
                        }else{
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      }),
                    ),
                  ),
                ],
              ),
            )
          ),
          //right section
          //here we can view our passwords or create a new entry
          Expanded(
            flex: 1,
            child: Container(
              child: Column(
                children:  <Widget>[
                 
                  TextField(
                    controller:aliasController, 
                    decoration: InputDecoration(
                      hintText: "Alias", 
                      errorText: _aliasErrorText),
                      onChanged: (text) => setState(() => _text),

                  ),
                  TextField(
                    controller: urlController, 
                    decoration: InputDecoration(
                      hintText: "URL", 
                      errorText: _urlErrorText),
                      onChanged: (text) => setState(() => _text),
                    ),
                  TextField(
                    controller: usernameController, 
                    decoration: InputDecoration(
                      hintText: "Username", 
                      errorText: _usernameErrorText),
                    onChanged: (text) => setState(() => _text),
                    ),
                  TextField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      hintText: "Password",
                      errorText: _passwordErrorText),
                      onChanged: (text) => setState(() => _text),

                    ),
                  //Tag section
                  Row(
                    children: allTags,
                  )
                ],
              )
            )
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()async{
          if(validateInputs()){
            debugPrint("hier komm ich rein");
            debugPrint(selectedTags.toString());
            String alias = aliasController.text;
            String url = urlController.text;
            String username = usernameController.text;
            String password = passwordController.text;
            StoreItem newItem = StoreItem(alias, url, username, password, selectedTags);
            await addItemToStore(newItem);

            setState(() {
              selectedTags = [];
              aliasController.text = "";
              usernameController.text = "";
              urlController.text = "";
              passwordController.text = "";            
            });
          }else{
            return;
          }
          
        },
        tooltip: 'add new entry',
        child: const Icon(Icons.add),
      ),
    );
  }

  bool validateInputs(){
    if(_aliasErrorText != null){
      return false;
    }
    if(_usernameErrorText != null){
      return false;
    }
    if(_urlErrorText != null){
      return false;
    }
    if(_passwordErrorText != null){
      return false;
    }
    return true;
  }
}

class TagContainer extends StatefulWidget {
  final String title;
  final List<String> selectedTags;
  bool isSelected;
  TagContainer({
    required this.title,
    required this.selectedTags,
    required this.isSelected,

    Key? key,
  }) : super(key: key);

  
  @override
  State<TagContainer> createState() => _TagContainerState();
}

class _TagContainerState extends State<TagContainer> {


 
  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () => setState(() {
        if(widget.isSelected){
          widget.isSelected = false;
          debugPrint(widget.selectedTags.toString());
          widget.selectedTags.remove(widget.title);

        }else{
          widget.isSelected = true;
          widget.selectedTags.add(widget.title);

        }
      }),
      child: Container(
        
        decoration: BoxDecoration(
          color: widget.isSelected? Colors.green: Colors.grey,
          borderRadius: BorderRadius.circular(16)
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(child: Text(widget.title)),
        ),
      ),
    );
  }
}




