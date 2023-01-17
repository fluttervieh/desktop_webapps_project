
import 'package:json_annotation/json_annotation.dart';


@JsonSerializable()
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
      json['identifier'] as String, 
      json['url'] as String,
      json['username'] as String,
      json['password'] as String,
      (json['tags'] as List).map((e) =>  e as String).toList());
  }

  Map<String, dynamic> toJson() =>{
    'identifier': identifier.toString(),
    'url': url.toString(),
    'username': username.toString(),
    'password': password.toString(),
    'tags' : tags,
  };
  // factory StoreItem.fromJson(Map<String, dynamic> json) => _$StoreItemFromJson(json);

  // /// Connect the generated [_$StoreItemToJson] function to the `toJson` method.
  // Map<String, dynamic> toJson() => _$StoreItemToJson(this);
  

}
