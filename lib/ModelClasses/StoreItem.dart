
import 'package:json_annotation/json_annotation.dart';


@JsonSerializable()
class StoreItem{
  final String uid;
  final String identifier;
  final String url;
  final String username;
  final String password;
  final List<String> tags;


  const StoreItem(
    this.uid,
    this.identifier, 
    this.url, 
    this.username, 
    this.password, 
    this.tags
  );

  factory StoreItem.fromJson(Map<String,dynamic> json){
    return StoreItem(
      json['uid'] as String,
      json['identifier'] as String, 
      json['url'] as String,
      json['username'] as String,
      json['password'] as String,
      (json['tags'] as List).map((e) =>  e as String).toList());
  }

  Map<String, dynamic> toJson() =>{
    'uid': uid.toString(),
    'identifier': identifier.toString(),
    'url': url.toString(),
    'username': username.toString(),
    'password': password.toString(),
    'tags' : tags,
  };
 
  

}
