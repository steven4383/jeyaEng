import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:jeya_engineering/Controllers/auth_controller.dart';
import 'package:jeya_engineering/firebase.dart';
import 'package:jeya_engineering/models/response.dart';

class Job {
  Job({
    required this.number,
    required this.customer,
    required this.description,
    this.quantity = '0',
    required this.unit,
    required this.marketIsssuedDate,
    required this.area,
    required this.targetDate,
    required this.remarks,
    required this.priority,
    this.zone,
    required this.docId,
    //------------------DesignSTATUS----------------
    this.design = true,
    this.machining,
    this.fabricationDrawing,
    this.billOfMaterials,
    //---------------------------------------production----------
    required this.productionLathe,
    required this.productionFabrication,
    required this.productionAssembly,
    this.onsiteErection,
    //------------purchase----------------
    required this.purchaseBroughtItems,
    this.purchaseElectricalItems,
    this.purchaseFasteners,
    required this.purchaseRawMaterial,
    this.purchaseStatus,
    this.purchasefabrication,
    this.purchaselathe,
    this.purchaseFittings,
    this.purchaseBearings,
    this.purchaseBelts,
    this.purchaseGears,
    //-----------------store--------------
    this.storeStatus,
    this.srawMaterial,
    this.srawFabrication,
    this.srawLathe,
    this.sboughtOutItems,
    this.sfasteners,
    this.sfittings,
    this.sbearings,
    this.selectricals,
    this.sBelts,
    this.sGears,
  });

  CollectionReference get logs => jobs.doc(docId).collection('logs');

  String docId;
  String number;
  String customer;
  String description;
  String? zone;
  String quantity;
  String unit;
  DateTime? marketIsssuedDate;
  String area;
  DateTime? targetDate;
  String remarks;
  int priority;
//------------------------------designSTATUS--------------------------
  bool design;
  bool? machining;
  bool? fabricationDrawing;
  bool? billOfMaterials;

  //---------------production----------------------
  bool? productionLathe;
  bool? productionFabrication;
  bool? productionAssembly;
  bool? onsiteErection;
  //--------------------purchase--------------------------
  bool? purchaseStatus;
  bool purchaseRawMaterial;
  bool? purchasefabrication;
  bool? purchaselathe;
  bool purchaseBroughtItems;
  bool? purchaseFittings;
  bool? purchaseBearings;
  bool? purchaseFasteners;
  bool? purchaseElectricalItems;
  bool? purchaseBelts;
  bool? purchaseGears;
  //-----------------------store-------------------------
  bool? storeStatus;
  bool? srawMaterial;
  bool? srawFabrication;
  bool? srawLathe;
  bool? sboughtOutItems;
  bool? sfasteners;
  bool? sfittings;
  bool? sbearings;
  bool? selectricals;
  bool? sBelts;
  bool? sGears;
  factory Job.fromJson(Map<String, dynamic> json) => Job(
        docId: json["docId"],
        number: json["number"],
        customer: json["customer"],
        description: json["description"],
        quantity: json["quantity"].toString(),
        zone: json["zone"],
        unit: json["unit"],
        marketIsssuedDate: json["marketIsssuedDate"].toDate(),
        area: json["area"],
        targetDate: json["targetDate"].toDate(),
        remarks: json["remarks"],
        priority: json["priority"],
        //------------------------------DesignSTATUS-----------
        design: json["design"],
        machining: json['machining'],
        fabricationDrawing: json['fabricationDrawing'],
        billOfMaterials: json['billOfMaterials'],

        //---------------------production----------------------
        productionLathe: json["productionLathe"],
        productionFabrication: json["productionFabrication"],
        productionAssembly: json['productionAssembly'],
        onsiteErection: json[''],

        // ------------purchase--------------------------------
        purchaseBroughtItems: json['purchaseBroughtItems'],
        purchaseElectricalItems: json['purchaseElectricalItems'],
        purchaseFasteners: json['purchaseFasteners'],
        purchaseRawMaterial: json['purchaseRawMaterial'],
        purchaseStatus: json['purchaseStatus'],
        purchasefabrication: json['purchasefabrication'],
        purchaselathe: json['purchaselathe'],
        purchaseFittings: json['purchaseFittings'],
        purchaseBearings: json['purchaseBearings'],
        purchaseBelts: json['purchaseBelts'],
        purchaseGears: json["purchaseGears"],

        //  ---------------------stores------------------------

        storeStatus: json['storeStatus'],
        srawMaterial: json['srawMaterial'],
        srawFabrication: json['srawFabrication'],
        srawLathe: json['srawLathe'],
        sboughtOutItems: json['sboughtOutItems'],
        sfasteners: json['sfasteners'],
        sfittings: json['sfittings'],
        sbearings: json['sbearings'],
        selectricals: json['selectricals'],
        sBelts: json['sBelts'],
        sGears: json['sGears'],
      );

  Map<String, dynamic> toJson() => {
        "number": number,
        "customer": customer,
        "description": description,
        "quantity": quantity,
        "unit": unit,
        "docId": docId,
        "marketIsssuedDate": marketIsssuedDate,
        "area": area,
        "targetDate": targetDate,
        "remarks": remarks,
        "priority": priority,
        "search": search,
        "zone": zone,
        "year": marketIsssuedDate?.year,
        //-------------------purchaseSTATUS----------------------------
        "purchaseRawMaterial": purchaseRawMaterial,
        "purchaseBroughtItems": purchaseBroughtItems,
        "purchaseFasteners": purchaseFasteners,
        "purchaseElectricalItems": purchaseElectricalItems,
        "purchaseStatus": purchaseStatus,
        "purchasefabrication": purchasefabrication,
        "purchaselathe": purchaselathe,
        "purchaseFittings": purchaseFittings,
        "purchaseBearings": purchaseBearings,
        "purchaseBelts": purchaseBelts,
        "purchaseGears": purchaseGears,

        //-------------------design-------------------------------
        "design": design,
        "machining": machining,
        "fabricationDrawing": fabricationDrawing,
        "billOfMaterials": billOfMaterials,

        //-------------------- production-------------------------
        "productionLathe": productionLathe,
        "productionFabrication": productionFabrication,
        "productionAssembly": productionAssembly,
        "onsiteErection": onsiteErection,
        //----------------------------------store----------------
        "storeStatus": storeStatus,
        "srawMaterial": srawMaterial,
        "srawFabrication": srawFabrication,
        "srawLathe": srawLathe,
        "sboughtOutItems": sboughtOutItems,
        "sfasteners": sfasteners,
        "sfittings": sfittings,
        "sbearings": sbearings,
        "selectricals": selectricals,
        "sBelts": sBelts,
        "sGears": sGears,

        //--------log--------------------------------------------
        'changedBy': auth.currentUser?.displayName,
      };

  get search {
    List<String> strings = [];
    strings.addAll(makeSearchString(number.split('/').last));
    strings.addAll(makeSearchString(number));
    strings.addAll(makeSearchString(customer));
    strings.addAll(makeSearchString(description));

    var textArray = description.split(' ');
    strings.addAll(textArray.map((e) => e.toLowerCase()));
    for (int i = 0; i < textArray.length; i++) {
      for (int j = i + 1; j < textArray.length; j++) {}
    }

    return strings;
  }

  makeSearchString(String text) {
    List<String> returns = [];
    var length = text.length;
    if (text.length >= 3) {
      for (int i = 0; i < length; i++) {
        var string = text.substring(0, i).toLowerCase();
        if (string.length > 2) {
          returns.add(string);
        }
      }
      returns.add(text.toLowerCase());
    }

    return returns;
  }

  Future<Result> add() async {
    try {
      var snaps = await jobs.where("number", isEqualTo: number).get();
      if (snaps.docs.isNotEmpty) {
        return Result.error("Duplicate Job Number, Please enter a new one");
      }
    } catch (e) {
      print(e.toString());
      return Result.error("Unknown error");
    }
    print(docId);
    return jobs
        .doc(docId)
        .set(toJson())
        .then((value) => Result.success("Added successfully"))
        .onError((error, stackTrace) => Result.error(error));
  }

  Future<Result> update({required bool nameCheck}) async {
    try {
      var snaps = await jobs.where("number", isEqualTo: number).get();
      if (snaps.docs.isNotEmpty && snaps.docs.first.id != docId) {
        return Result.error("Duplicate Job Number, Please enter a new one");
      }
    } catch (e) {
      print(e.toString());
      return Result.error("Unknown error");
    }
    return jobs
        .doc(docId)
        .update(toJson())
        .then((value) => Result.success("Updated successfully"))
        .onError((error, stackTrace) => Result.error(error));
  }
}
