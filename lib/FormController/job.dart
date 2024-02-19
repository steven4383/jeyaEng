import 'package:flutter/cupertino.dart';

import '../models/job.dart';

class JobFormController {
  String? docId;

  TextEditingController number = TextEditingController();
  TextEditingController customer = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController quantity = TextEditingController(text: '0');

  String? zone;
  String? unit = 'Set';
  DateTime? marketIsssuedDate;

  String? area;
  DateTime? targetDate;
  DateTime? year;
  TextEditingController remarks = TextEditingController();
  int priority = 0;

  //-------designstatus-------

  bool design = false;
  bool? machining;
  bool? fabricationDrawing;

  bool? billOfMaterials;

  //-------------purchase-------------

  bool purchaseBoughtoutItems = false;
  bool? purchaseElectricalItems;
  bool? purchaseFasteners;
  bool purchaseRawMaterial = false;
  bool? purchaseStatus = false;
  bool? purchasefabrication;
  bool? purchaselathe;
  bool? purchaseFittings;
  bool? purchaseBearings;

  bool? purchaseBelts;
  bool? purchaseGears;

  //------------production--------------

  bool? productionAssembly;

  bool? productionFabrication;

  bool? productionLathe;
  bool? onsiteErection;

  //--------------------store---------------
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

  JobFormController(this.docId);

  clear() {}

  factory JobFormController.fromJob(Job job) {
    var form = JobFormController(job.docId);
    form.number.text = job.number;
    form.customer.text = job.customer;
    form.description.text = job.description;
    form.quantity.text = job.quantity.toString();
    form.unit = job.unit;
    form.marketIsssuedDate = job.marketIsssuedDate;
    form.area = job.area;
    form.targetDate = job.targetDate;
    form.remarks.text = job.remarks;
    form.priority = job.priority;
    form.zone = job.zone;
    //-----------------------designstatus----------------------
    form.design = job.design;

    form.machining = job.machining;
    form.fabricationDrawing = job.fabricationDrawing;

    form.billOfMaterials = job.billOfMaterials;
    // -------------purchaseStatus-------------------------
    form.purchaseBoughtoutItems = job.purchaseBroughtItems;
    form.purchaseElectricalItems = job.purchaseElectricalItems;
    form.purchaseFasteners = job.purchaseFasteners;
    form.purchaseRawMaterial = job.purchaseRawMaterial;

    form.purchaseStatus = job.purchaseStatus;
    form.purchasefabrication = job.purchasefabrication;
    form.purchaselathe = job.purchaselathe;
    form.purchaseFittings = job.purchaseFittings;
    form.purchaseBearings = job.purchaseBearings;
    form.purchaseGears = job.purchaseGears;
    form.purchaseBelts = job.purchaseBelts;

    //----------------------production---------------------

    form.productionLathe = job.productionLathe;
    form.productionFabrication = job.productionFabrication;
    form.productionAssembly = job.productionAssembly;
    form.onsiteErection = job.onsiteErection;
    //-------------------store----------------------------

    form.storeStatus = job.storeStatus;
    form.srawMaterial = job.srawMaterial;
    form.srawFabrication = job.srawFabrication;
    form.srawLathe = job.srawLathe;
    form.sboughtOutItems = job.sboughtOutItems;
    form.sfasteners = job.sfasteners;
    form.sfittings = job.sfittings;
    form.sbearings = job.sbearings;
    form.selectricals = job.selectricals;
    form.sBelts = job.sBelts;
    form.sGears = job.sGears;

    return form;
  }

  Job get object {
    return Job(
        docId: (docId ?? '').isNotEmpty
            ? docId!
            : DateTime.now().millisecondsSinceEpoch.toString(),
        number: number.text,
        customer: customer.text,
        description: description.text,
        unit: unit!,
        marketIsssuedDate: marketIsssuedDate!,
        area: area!,
        targetDate: targetDate!,
        remarks: remarks.text,
        quantity: quantity.text,
        priority: priority,
        zone: zone,

        //----------------------designstatus----------------------
        design: design,
        machining: machining,
        fabricationDrawing: fabricationDrawing,
        billOfMaterials: billOfMaterials,

        //------------------purchase---------------------
        purchaseBroughtItems: purchaseBoughtoutItems,
        purchaseElectricalItems: purchaseElectricalItems,
        purchaseFasteners: purchaseFasteners,
        purchaseRawMaterial: purchaseRawMaterial,
        purchaseStatus: purchaseStatus,
        purchasefabrication: purchasefabrication,
        purchaselathe: purchaselathe,
        purchaseFittings: purchaseFittings,
        purchaseBearings: purchaseBearings,
        purchaseBelts: purchaseBelts,
        purchaseGears: purchaseGears,
        //----------------productio---------------------
        productionAssembly: productionAssembly,
        productionFabrication: productionFabrication,
        productionLathe: productionLathe,
        onsiteErection: onsiteErection,

        //  ---------store-----------------
        storeStatus: storeStatus,
        srawMaterial: srawMaterial,
        srawFabrication: srawFabrication,
        srawLathe: srawLathe,
        sboughtOutItems: sboughtOutItems,
        sfasteners: sfasteners,
        sfittings: sfittings,
        sbearings: sbearings,
        selectricals: selectricals,
        sBelts: sBelts,
        sGears: sGears);
  }
}
