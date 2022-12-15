import 'dart:convert';

class StoreItem{
  final String identifier;
  final String url;
  final String username;
  final String password;
  final List<String> tags;


  const StoreItem(
    this.identifier, 
    this.url, 
    this.username, 
    this.password, 
    this.tags
  );

  factory StoreItem.fromJson(Map<String,dynamic> json){
    return StoreItem(
      json['identifier'], 
      json['url'],
      json['username'],
      json['password'],
      json['tags']==null?[]:json['tags']);
  }

  Map<String, dynamic> toJson() =>{
    'identifier': identifier.toString(),
    'url': url.toString(),
    'username': username.toString(),
    'password': password.toString(),
    'tags:' : tags
  };
  

}
