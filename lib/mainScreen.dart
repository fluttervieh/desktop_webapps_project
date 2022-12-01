import 'package:desktop_webapp/ModelClasses/StoreItem.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({ Key? key }) : super(key: key);

  


  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  @override
  Widget build(BuildContext context) {

    List<String> selectedTags = [];

    //some mock data for developement
    List<StoreItem> allItems = [];
    StoreItem s1 = const StoreItem("amazon", "www.amazon.com", "richi", "passwort", []);
    StoreItem s2 = const StoreItem("instagram", "www.instagram.com", "richard.insta", "anderespasswort", []);
    StoreItem s3 = const StoreItem("cornhub", "www.cornhub.com", "cornlover", "itscorn", []);

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
                  child: ListView.builder(
                      shrinkWrap: true,
                
                    itemCount: allItems.length,
                    itemBuilder: (BuildContext context, int index){
                      return ListTile(
                        title: Text(allItems[index].url),
                        subtitle: Text(allItems[index].username),
                        tileColor: Colors.white,
                        hoverColor: Colors.grey,
                      );
                    }),
                )
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



