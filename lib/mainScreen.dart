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
            color: Colors.red,
          )
        )
      ],
    );
  }
}