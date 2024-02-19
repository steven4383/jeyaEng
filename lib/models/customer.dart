



import 'package:jeya_engineering/firebase.dart';

class Customer {


  String? name;
  String? location;
  String? area;
  String? addressLine1;
  String? addressLine2;


  Customer({
     this.name,
    this.area,
    this.location,
    this.addressLine1,
    this.addressLine2,

});



  factory Customer.fromJson(Map<String,dynamic> json)=> Customer(name: json["name"],



  location: json["location"],
    area: json["area"],
    addressLine1: json["addressLine1"],
    addressLine2: json["addressLine2"]

  );


  Map<String,dynamic> toJson()=>{


    "name": name,
    "location":location,
    "area":area,
    "addressLine1":addressLine1,
    "addressLine2": addressLine2,




  };


  Future add()async=> customers.add(toJson());









}