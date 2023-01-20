import 'dart:convert';
import 'package:desktop_webapp/ModelClasses/StoreItem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uuid/uuid.dart';
import 'dart:io' show Platform;


final storage = FlutterSecureStorage();
List<String> selectedFilterTags = [];
String searchCredential = "";

class MainScreen extends StatefulWidget {
  const MainScreen({ Key? key }) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  //final storage = FlutterSecureStorage();


  TextEditingController aliasController = TextEditingController();
  TextEditingController urlController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  TextEditingController searchCredentialController = TextEditingController();

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

  Set activeListItems = {};

  void setActive(index){
    setState(() {
      activeListItems.contains(index) ? activeListItems.remove(index) : activeListItems.add(index);
    });
  }

  @override
  Widget build(BuildContext context) {

     void updateParentState(){
      setState(() {
        debugPrint("updated State");
      });
    }
 
    List<String> selectedTags = [];
    List<Widget> allTags = [];
    allTags.add(TagContainer(title: "Shopping", selectedTags: selectedTags, isSelected: selectedTags.contains("Shopping"), isFilterItem: false ,updateParentState: () => updateParentState()));
    allTags.add(TagContainer(title: "Social Media", selectedTags: selectedTags, isSelected: selectedTags.contains("Social Media"), isFilterItem: false, updateParentState: () => updateParentState()));
    allTags.add(TagContainer(title: "Other", selectedTags: selectedTags, isSelected: selectedTags.contains("Other"), isFilterItem: false, updateParentState: () => updateParentState()));
    allTags.add(TagContainer(title: "Porn", selectedTags: selectedTags, isSelected: selectedTags.contains("Porn"), isFilterItem: false, updateParentState: () => updateParentState()));

    List<Widget> filterTags = [];
    filterTags.add(TagContainer(title: "Shopping", selectedTags: selectedFilterTags, isSelected: selectedFilterTags.contains("Shopping"), isFilterItem: true, updateParentState: () => updateParentState()));
    filterTags.add(TagContainer(title: "Social Media", selectedTags: selectedFilterTags, isSelected: selectedFilterTags.contains("Social Media"),  isFilterItem: true, updateParentState: () => updateParentState()));
    filterTags.add(TagContainer(title: "Other", selectedTags: selectedFilterTags, isSelected: selectedFilterTags.contains("Other"),  isFilterItem: true, updateParentState: () => updateParentState()));
    filterTags.add(TagContainer(title: "Porn", selectedTags: selectedFilterTags, isSelected: selectedFilterTags.contains("Porn"), isFilterItem: true, updateParentState: () => updateParentState()));

   
    return Scaffold(
      body: Row(
        children:<Widget> [
          //left section of the key manager
          //in future, we have to wrap this on in a future builder to get the async stuff
          Expanded(
            child: Container(
              child: Column(
                children: <Widget>[
                  //searchbar
                  Row(
                    children: <Widget>[
                      Expanded( flex: 9, child: TextField(controller: searchCredentialController,)),
                      IconButton(onPressed: (() {
                        debugPrint(searchCredentialController.text);
                        searchCredential = searchCredentialController.text;
                        debugPrint("pressss");
                        updateParentState();
                      }), icon: const Icon(Icons.search))
                    ],
                  ),
                  Row(
                    children: 
                      filterTags,
                  ),
                  Expanded(
                    child: FutureBuilder(
                      future: getAllFromStorage(selectedFilterTags),
                      builder: ((BuildContext context, AsyncSnapshot snapshot) {
                        if(snapshot.hasData){
                          return ListView.builder(
                            shrinkWrap: true,        
                            itemCount: snapshot.data.length,
                            itemBuilder: (BuildContext context, int index){
                              return GestureDetector(
                                onTap: (){
                                  if(activeListItems.contains(index)){
                                    setActive(index);
                                  }else{
                                  showDialog(context: context, builder: (BuildContext context){
                                    TextEditingController pwController = TextEditingController();
                                    return Dialog(
                                      child: SizedBox(
                                        height: MediaQuery.of(context).size.height/3,
                                        width: MediaQuery.of(context).size.width/4,
                                        child: Column(
                                          children: [
                                            const Text("Enter your master password."),
                                            TextField(controller: pwController),
                                            ElevatedButton(onPressed: (){
                                              String pwText = pwController.text;
                                              if(pwText != "test"){
                                                return;
                                              }else{
                                                setActive(index);
                                                pwController.text = "";
                                                Navigator.of(context).pop();
                                              }
                                            }, child: const Text("Submit"))
                                          ],
                                        ),
                                      ),
                                    );
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
                                              flex: 8,
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(snapshot.data[index].identifier, style: const TextStyle(fontWeight: FontWeight.bold)),
                                                  Text(snapshot.data[index].url),
                                                  Text("usermame: " + snapshot.data[index].username),
                                                  activeListItems.contains(index)?  
                                                    Text("password: " + snapshot.data[index].password):Container(height: 0),

                                                ],
                                              )
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: IconButton(
                                                icon: const Icon(Icons.delete),
                                                onPressed: (){
                                                  setState (() {
                                                    debugPrint("item deleted");
                                                    storage.delete(key: snapshot.data[index].uid);
                                                  });
                                                },
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: activeListItems.contains(index)? const Icon(Icons.visibility_off): const Icon(Icons.visibility),
                                            ),
                                            
                                          ],
                                        ),
                                      )
                                     
                                    ],
                                  ),
                                ),
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
                  const Text("Neues Passwort hinzufügen"),
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
            const uuid = Uuid();
            String alias = aliasController.text;
            String url = urlController.text;
            String username = usernameController.text;
            String password = passwordController.text;

            StoreItem newItem = StoreItem(uuid.v4(), alias, url, username, password, selectedTags);
            showDialog(context: context, builder: (BuildContext context) {
                                    TextEditingController pwController = TextEditingController();
                                    return Dialog(
                                      child: SizedBox(
                                        height: MediaQuery.of(context).size.height/3,
                                        width: MediaQuery.of(context).size.width/4,
                                        child: Column(
                                          children: [
                                            const Text("Enter your master password."),
                                            TextField(controller: pwController),
                                            ElevatedButton(onPressed: (){
                                              String pwText = pwController.text;
                                              if(pwText != "test"){
                                                return;
                                              }else{
                                                pwController.text = "";
                                                Navigator.of(context).pop();
                                                addItemToStore(newItem);
                                                setState(() {
                                                  selectedTags = [];
                                                  aliasController.text = "";
                                                  usernameController.text = "";
                                                  urlController.text = "";
                                                  passwordController.text = "";            
                                                });
                                              }
                                            }, child: const Text("Submit"))
                                          ],
                                        ),
                                      ),
                                    );
                                  });
            //await addItemToStore(newItem);
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
  
  Widget openMasterPWDialog(BuildContext context, VoidCallback function){
    
    TextEditingController pwController = TextEditingController();
    return Dialog(
      child: SizedBox(
        height: MediaQuery.of(context).size.height/3,
        width: MediaQuery.of(context).size.width/4,
        child: Column(
          children: [
            const Text("Enter your master password."),
            TextField(controller: pwController),
            ElevatedButton(onPressed: (){
              String pwText = pwController.text;
              if(pwText != "test"){

                return;
              }else{
                function();
                pwController.text = "";
                Navigator.of(context).pop();
              }
            }, child: const Text("Submit"))
          ],
        ),
      ),
    );
}


}

class TagContainer extends StatefulWidget {
  final String title;
  final List<String> selectedTags;
  bool isSelected;
  bool isFilterItem;
  Function updateParentState;
  TagContainer({
    required this.title,
    required this.selectedTags,
    required this.isSelected,
    required this.isFilterItem,
    required this.updateParentState,
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
          widget.selectedTags.remove(widget.title);

          if(widget.isFilterItem){
              selectedFilterTags.remove(widget.title);
              widget.updateParentState();
          }
          

        }else{
          widget.isSelected = true;
          widget.selectedTags.add(widget.title);
          if(widget.isFilterItem){
              selectedFilterTags.add(widget.title);
              widget.updateParentState();
          }

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



Future<void>addItemToStore(StoreItem item)async{
    var json = jsonEncode(item);
    await storage.write(key: item.uid, value: json.toString());
}

//Diese funktion ist sehr schrecklich geschrieben, tut mir leid :-(
Future<List<StoreItem>> getAllFromStorage(List<String>selectedFilterTags)async{
    
   List<StoreItem> fetchedStoreItems = [];
    //await storage.deleteAll();
   final all = await storage.readAll();
    debugPrint("store fetch "  + all.toString());

    all.forEach((key, value) {

      StoreItem item = StoreItem.fromJson(jsonDecode(value));

      if(selectedFilterTags.isEmpty && (searchCredential == "" || searchCredential.isEmpty)){
        fetchedStoreItems.add(item);
      }else if(searchCredential != ""){
        debugPrint("hier komi nei");
        if(item.identifier.contains(searchCredential) && !fetchedStoreItems.contains(item)){
          fetchedStoreItems.add(item);
        }
      }else{
        //fetchedStoreItems = [];
        for (var selectedFilter in selectedFilterTags) {
            if(item.tags.contains(selectedFilter) && !fetchedStoreItems.contains(item)){
              fetchedStoreItems.add(item); 
            }
        }
      }
    });

    return fetchedStoreItems;
  }

  




