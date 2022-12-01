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

  Future<void>addItemToStore(StoreItem item)async{
    const uuid = Uuid();
    String json = jsonEncode(item);
    debugPrint(json);
    await storage.write(key: uuid.v4(), value: json);
  }

  @override
  Widget build(BuildContext context) {

    List<String> selectedTags = [];

    //some mock data for developement
    List<StoreItem> allItems = [];
    StoreItem s1 = const StoreItem("amazon", "www.amazon.com", "richi", "passwort", []);
    StoreItem s2 = const StoreItem("instagram", "www.instagram.com", "richard.insta", "anderespasswort", []);
    StoreItem s3 = const StoreItem("cornhub", "www.cornhub.com", "cornlover", "itscorn", ["social media"]);

    allItems.add(s1);
    allItems.add(s2);
    allItems.add(s3);
    
    return Row(
      children:<Widget> [
        //left section of the key manager
        //in future, we have to wrap this on in a future builder to get the async stuff
        Expanded(
          flex: 1,
          child: Container(
            child: Column(
              children: <Widget>[
                //searchbar
                TextField(),
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
                ElevatedButton(onPressed: ()=> setState(() {
                  addItemToStore(s3);
                }), child: Text("add test entry"))
                //Listview.builder

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
                const TextField(decoration: InputDecoration(hintText: "Alias",)),
                const TextField(decoration: InputDecoration(hintText: "URL",)),
                const TextField(decoration: InputDecoration(hintText: "Username",)),
                const TextField(decoration: InputDecoration(hintText: "Password",)),
                //Tag section
                Row(
                  children:  [
                    TagContainer(title: "Shopping", selectedTags: selectedTags, isSelected: false),
                    TagContainer(title: "Social Media", selectedTags: selectedTags, isSelected: false),
                    TagContainer(title: "Other", selectedTags: selectedTags, isSelected: false),
                    TagContainer(title: "Porn", selectedTags: selectedTags, isSelected: false)
                  ],
                )


              ],
            )
          )
        )
      ],
    );
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
          widget.selectedTags.add(widget.title);
          debugPrint(widget.selectedTags.length.toString());
        }else{
          widget.isSelected = true;
          widget.selectedTags.remove(widget.title);
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



