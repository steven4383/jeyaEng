import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jeya_engineering/firebase.dart';

class QueryFormController {
  String? zone;
  int? year;
  bool? design;
  bool? orderBy;
  int? priority;
  bool priorityJobsOnly = true;
  Query<Map<String, dynamic>> queryValue = jobs;
  bool? purchaseStatus;
  String? description;

  final searchController = TextEditingController();
  final fromDateController = TextEditingController();
  final toDateController = TextEditingController();

  DateTime? fromDate;
  DateTime? toDate;

  List<bool?> purchase = [null, null, null, null];

  String? area;

  bool? get purchaseBroughtItems => purchase[0];
  set purchaseBroughtItems(val) => purchase[0] = val;

  bool? get purchaseElectricalItems => purchase[1];
  set purchaseElectricalItems(val) => purchase[1] = val;

  bool? get purchaseFasteners => purchase[2];
  set purchaseFasteners(val) => purchase[2] = val;

  bool? get purchaseRawMaterial => purchase[3];
  set purchaseRawMaterial(val) => purchase[3] = val;

  List<bool?> production = [null, null, null];

  bool? get productionAssembly => production[0];
  set productionAssembly(val) => production[0] = val;

  bool? get productionFabrication => production[1];
  set productionFabrication(val) => production[1] = val;

  bool? get productionLathe => production[2];
  set productionLathe(val) => production[2] = val;

  List<DropdownMenuItem<int>> get years {
    List<DropdownMenuItem<int>> items = [];
    items.add(const DropdownMenuItem(
      child: Text("ALL"),
      value: null,
    ));
    for (int i = 2015; i < 2030; i++) {
      items.add(DropdownMenuItem(
        child: Text("$i"),
        value: i,
      ));
    }
    return items;
  }

  List<DropdownMenuItem<int>> get prioritys {
    List<DropdownMenuItem<int>> items = [];
    items.add(const DropdownMenuItem(
      child: Text("ALL"),
      value: null,
    ));
    for (int i = 1; i < 11; i++) {
      items.add(DropdownMenuItem(
        child: Text("$i"),
        value: i,
      ));
    }
    return items;
  }

  List<DropdownMenuItem<bool>> get statusItems {
    return [
      const DropdownMenuItem(child: Text("COMPLETED"), value: true),
      const DropdownMenuItem(child: Text("INCOMPLETE"), value: false),
      const DropdownMenuItem(child: Text("ALL"), value: null),
    ];
  }

  // List<DropdownMenuItem<bool>> get orderByItems {
  //   return [
  //     const DropdownMenuItem(child: Text("ASCENDING"), value: false),
  //     const DropdownMenuItem(child: Text("DESCENDING"), value: true),
  //     const DropdownMenuItem(child: Text("ALL"), value: null),
  //   ];
  // }

  clear() {
    design = null;

    production[0] = null;
    production[1] = null;
    production[2] = null;

    purchase[0] = null;
    purchase[1] = null;
    purchase[2] = null;
    purchase[3] = null;

    searchController.clear();
    fromDateController.clear();
    toDateController.clear();
    year = null;
    fromDate = null;
    toDate = null;
    zone = null;
    orderBy = null;
    area = null;
    priority = null;
    purchaseStatus = null;
    description = null;
  }

  Query<Map<String, dynamic>> get query {
    Query<Map<String, dynamic>> query = queryValue;

    if (fromDate != null) {
      query = query.where('marketIsssuedDate', isEqualTo: fromDate);
    }
    if (toDate != null) {
      query = query.where('targetDate', isEqualTo: toDate);
    }
    if (searchController.text.isNotEmpty) {
      var splits = searchController.text;

      // print(splits.contains('description'));

      // print('${splits.substring(0, splits.length - 11)}');

      // int end = splits.length - 1;
      if (splits.contains('description')) {
        query = query.where('description',
            isEqualTo: splits.substring(0, splits.length - 11));
      } else if (splits.contains('theva & co')) {
        print('hello');
        query = query.where('customer', isEqualTo: 'Theva & Co');
      } else {
        query = query.where('search', arrayContains: splits);
      }
    }
    if (zone != null) {
      query = query.where('zone', isEqualTo: zone?.toUpperCase());
    }
    if (area != null) {
      query = query.where('area', isEqualTo: area?.toUpperCase());
    }
    if (year != null) {
      query = query.where('year', isEqualTo: year);
    }
    if (priority != null) {
      query = query.where('priority', isEqualTo: priority);
    }
    if (purchaseBroughtItems != null) {
      query =
          query.where('purchaseBroughtItems', isEqualTo: purchaseBroughtItems);
    }
    if (purchaseRawMaterial != null) {
      query =
          query.where('purchaseRawMaterial', isEqualTo: purchaseRawMaterial);
    }
    if (purchaseFasteners != null) {
      query = query.where('purchaseFasteners', isEqualTo: purchaseFasteners);
    }
    if (purchaseElectricalItems != null) {
      query = query.where('purchaseElectricalItems',
          isEqualTo: purchaseElectricalItems);
    }
    if (productionAssembly != null) {
      query = query.where('productionAssembly', isEqualTo: productionAssembly);
    }
    if (productionFabrication != null) {
      query = query.where('productionFabrication',
          isEqualTo: productionFabrication);
    }
    if (productionLathe != null) {
      query = query.where('productionLathe', isEqualTo: productionLathe);
    }
    if (design != null) {
      query = query.where('design', isEqualTo: design);
    }
    // if(priorityJobsOnly) {
    //   query = query.where('priotity', isNotEqualTo: 0);
    // }

    // if (orderBy != null) {
    //   if (orderBy == true) {
    //     print(orderBy);
    //     query = query.orderBy('targetDate', descending: true);
    //   } else {
    //     print('${orderBy} ascending');
    //     query = query.orderBy('targetDate');
    //   }
    // }
    if (purchaseStatus != null) {
      query = query.where('purchaseStatus', isEqualTo: purchaseStatus);
    }
    return query;
  }
}
