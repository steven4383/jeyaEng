import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jeya_engineering/Controllers/auth_controller.dart';
import 'package:jeya_engineering/FormController/job.dart';
import 'package:jeya_engineering/enum.dart';
import 'package:jeya_engineering/firebase.dart';
import 'package:jeya_engineering/models/customer.dart';
import 'package:jeya_engineering/models/response.dart';
import 'package:jeya_engineering/widgets/date_picker.dart';
import 'package:jeya_engineering/widgets/drop_down.dart';
import 'package:jeya_engineering/widgets/switch.dart';
import 'package:jeya_engineering/widgets/text_box.dart';
import 'package:jeya_engineering/widgets/utilities.dart';
import 'package:searchfield/searchfield.dart';

import '../../models/job.dart';

class JobForm extends StatefulWidget {
  const JobForm({Key? key, this.job}) : super(key: key);

  final Job? job;

  @override
  State<JobForm> createState() => JobFormState();
}

class JobFormState extends State<JobForm> {
  Job? get job => widget.job;
  Customer _customer = Customer();
  TextEditingController customerController = TextEditingController();

  final marketIsssuedDate = TextEditingController();
  final bool? maxConstraints = true;

  @override
  void initState() {
    super.initState();
    if (widget.job == null) {
      _controller = JobFormController(null);
      _formMode = FormMode.add;
      _controller.number.text =
          DateFormat(DateFormat.YEAR + '/' + DateFormat.ABBR_MONTH)
                  .format(DateTime.now()) +
              "/";
    } else {
      _controller = JobFormController.fromJob(widget.job!);
      // _controller.number.text.replaceAll('/', '\\');
      _formMode = FormMode.edit;
    }
  }

  late FormMode _formMode;
  late JobFormController _controller;
  final _formKey = GlobalKey<FormState>();

  getDesign() {
    return SizedBox(
      height: 120,
      child: ExpansionTile(
        initiallyExpanded: true,
        title: const Text('DESIGN'),
        children: [
          CustomSwitch(
            title: 'DESIGN Status',
            value: _controller.design,
            onChanged: (val) {
              setState(() {
                _controller.design = val;
              });
            },
          ),
        ],
      ),
    );
  }

  getProductionA() {
    return SizedBox(
      height: 300,
      child: ExpansionTile(
        initiallyExpanded: true,
        title: const Text('PRE-FABRICATION'),
        children: [
          CustomSwitch(
            title: 'LATHE',
            value: _controller.productionLathe ?? false,
            onChanged: (val) {
              setState(() {
                _controller.productionLathe = val;
              });
            },
          ),
        ],
      ),
    );
  }

  getProductionB() {
    return SizedBox(
      height: 120,
      child: ExpansionTile(
        initiallyExpanded: true,
        title: const Text('PRODUCTION'),
        children: [
          CustomSwitch(
            title: 'Fabrication',
            value: _controller.productionFabrication ?? false,
            onChanged: (val) {
              setState(() {
                _controller.productionFabrication = val;
              });
            },
          ),
          CustomSwitch(
            title: 'Assembly',
            value: _controller.productionAssembly ?? false,
            onChanged: (val) {
              setState(() {
                _controller.productionAssembly = val;
              });
            },
          ),
        ],
      ),
    );
  }

  getPurchase() {
    return SizedBox(
      height: 180,
      child: ExpansionTile(
        initiallyExpanded: true,
        title: const Text('PURCHASE MATERIAL'),
        children: [
          CustomSwitch(
            title: 'RAW MATERIAL',
            value: _controller.purchaseRawMaterial,
            onChanged: (val) {
              setState(() {
                _controller.purchaseRawMaterial = val;
              });
            },
          ),
          CustomSwitch(
            title: 'BROUGHT OUT ITEMS',
            value: _controller.purchaseBoughtoutItems,
            onChanged: (val) {
              setState(() {
                _controller.purchaseBoughtoutItems = val;
              });
            },
          ),
          // CustomSwitch(
          //   title: 'FASTNERS',
          //   value: _controller.purchaseFasteners,
          //   onChanged: (val) {
          //     setState(() {
          //       _controller.purchaseFasteners = val;
          //     });
          //   },
          // ),
          CustomSwitch(
            title: 'ELECTRICAL ITEMS',
            value: _controller.purchaseElectricalItems == true ? true : false,
            onChanged: (val) {
              setState(() {
                _controller.purchaseElectricalItems = val;
              });
            },
          ),
        ],
      ),
    );
  }

  // final GlobalKey expansionTile =  GlobalKey<Expansi>();
  final GlobalKey<ExpansionTileCardState> designCard = new GlobalKey();

  @override
  Widget build(BuildContext context) {
    print(auth.admin);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(_controller.number.text),
        actions: [
          (auth.admin || auth.sales)
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.green)),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                content: CustomTextBox(
                                  controller: customerController,
                                  hintText: 'Enter customer name',
                                  onChanged: (String val) {
                                    _customer.name = val;
                                  },
                                ),
                                actions: [
                                  ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Close')),
                                  ElevatedButton(
                                      onPressed: () async {
                                        if (_customer.name != null) {
                                          await _customer.add().then((value) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                              content: Text(
                                                  'Customer added successfully'),
                                              action: SnackBarAction(
                                                label: '',
                                                onPressed: () {},
                                              ),
                                            ));
                                            customerController.clear();
                                          }).catchError((e) =>
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                content: Text(e.toString()),
                                                action: SnackBarAction(
                                                  label: '',
                                                  onPressed: () {},
                                                ),
                                              )));
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            content:
                                                Text('please enter some text'),
                                            action: SnackBarAction(
                                              label: '',
                                              onPressed: () {
                                                // Some code to undo the change.
                                              },
                                            ),
                                          ));
                                        }
                                      },
                                      child: Text('Ok'))
                                ],
                              );
                            });
                      },
                      child: Text('Add Customer')),
                )
              : Text('')
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            Job tempJob = _controller.object;

            Future<Result> future;
            if (_formMode == FormMode.add) {
              future = tempJob.add();
            } else {
              bool nameCheck = false;
              if (widget.job!.number != _controller.number.text) {
                nameCheck = true;
              }
              future = tempJob.update(nameCheck: nameCheck);
            }

            bool clearData = false;
            showFutureDialog(context: context, future: future, actions: [
              ButtonBar(
                children: [
                  StatefulBuilder(builder: (context, setState) {
                    return SizedBox(
                      width: 150,
                      child: CheckboxListTile(
                          controlAffinity: ListTileControlAffinity.leading,
                          value: clearData,
                          title: const Text("Clear?"),
                          onChanged: (value) {
                            _controller = JobFormController(null);
                            setState(() {
                              clearData = value ?? clearData;
                            });
                          }),
                    );
                  }),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        if (clearData) {
                          setState(() {
                            _controller = JobFormController(null);
                          });
                        }
                        _controller.docId = null;
                        _formMode = FormMode.add;
                      },
                      child: const Text("NEW ENTRY")),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        setState(() {
                          _formMode = FormMode.edit;
                        });
                      },
                      child: const Text("OKAY")),
                ],
              ),
            ]);
          }
          // }else{
          //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("You Don't Have required permission to update job")));
          // }
        },
        child: const Icon(Icons.save),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              (auth.sales || auth.admin)
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: CustomTextBox(
                                hintText: 'JOB NO',
                                controller: _controller.number,
                                validator: (val) {
                                  if ((val ?? '').isEmpty) {
                                    return "Please enter a job number";
                                  }
                                  if ((val ?? '').split('/').isNotEmpty) {
                                    return (val ?? '').split('/').last.length !=
                                            4
                                        ? "Job Number should be 4 charachters"
                                        : null;
                                  } else {
                                    return "Please check the job number";
                                  }
                                },
                                suffixicon: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: IconButton(
                                      onPressed: () {
                                        getNextJobId().then((value) {
                                          setState(() {
                                            _controller.number.text =
                                                _controller.number.text +
                                                    value
                                                        .toString()
                                                        .padLeft(4, '0');
                                          });
                                        });
                                      },
                                      icon:
                                          const Icon(Icons.next_plan_outlined)),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: StreamBuilder<
                                      QuerySnapshot<Map<String, dynamic>>>(
                                  stream: customers.snapshots(),
                                  builder: (context,
                                      AsyncSnapshot<
                                              QuerySnapshot<
                                                  Map<String, dynamic>>>
                                          snapshot) {
                                    List<Customer>? docs = snapshot.data?.docs
                                            .map((e) =>
                                                Customer.fromJson(e.data()))
                                            .toList() ??
                                        [];

                                    return SizedBox(
                                        width: getWidth(context) * 0.25,
                                        child: ListTile(
                                            title: Padding(
                                              padding:
                                                  const EdgeInsets.all(4.0),
                                              child: Text('CUST name'),
                                            ),
                                            subtitle: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: SearchField(
                                                  validator: (val) {
                                                    if ((val ?? '').isEmpty) {
                                                      return 'Customer is required';
                                                    }
                                                  },
                                                  controller:
                                                      _controller.customer,
                                                  searchInputDecoration: InputDecoration(
                                                      fillColor: Colors.white,
                                                      hintText: 'Customer name',
                                                      border: const OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius.circular(
                                                                      4.0))),
                                                      errorBorder: const OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius.circular(
                                                                      4.0)),
                                                          borderSide:
                                                              BorderSide(
                                                                  color: Colors
                                                                      .red))),
                                                  suggestions: docs
                                                      .map((e) => SearchFieldListItem(e.name ?? 'nodata'))
                                                      .toList()),
                                            )));
                                  }),
                            ),
                            Expanded(
                              flex: 1,
                              child: CustomTextBox(
                                hintText: 'Description',
                                controller: _controller.description,
                              ),
                            ),
                            Expanded(
                                flex: 1,
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: CustomTextBox(
                                        hintText: 'Quantity',
                                        controller: _controller.quantity,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: ListTile(
                                        title: Text(''),
                                        subtitle: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: CustomDropdown1<String>(
                                            title: 'QTY',
                                            onChanged: (String? val) {
                                              _controller.unit =
                                                  val ?? _controller.unit;
                                            },
                                            items: ["Nos", "Set", "Mtr"]
                                                .map((e) => DropdownMenuItem(
                                                      child: Text(e),
                                                      value: e,
                                                    ))
                                                .toList(),
                                            value: _controller.unit,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                )),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: QuoteDateBox(
                                title: 'ISSUE Date',
                                date: _controller.marketIsssuedDate,
                                onPressed: () async {
                                  _controller.marketIsssuedDate =
                                      await showDatePicker(
                                    context: context,
                                    initialDate:
                                        _controller.marketIsssuedDate ??
                                            DateTime.now(),
                                    firstDate: DateTime.utc(2000),
                                    lastDate: DateTime.utc(2100),
                                  );
                                  setState(() {});
                                },
                                nullable: false,
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: QuoteDropdown<int>(
                                title: 'Priority',
                                onChanged: (int? val) {
                                  _controller.priority = val ?? 0;
                                },
                                items: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
                                    .map((e) => DropdownMenuItem<int>(
                                          child: Text(e == 0
                                              ? "NONE"
                                              : e.toString().toUpperCase()),
                                          value: e,
                                        ))
                                    .toList(),
                                value: _controller.priority,
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: QuoteDropdown<String>(
                                title: 'SITE LOCATION',
                                onChanged: (String? val) {
                                  _controller.area = val ?? _controller.area;
                                },
                                items: [
                                  'SIPCOT',
                                  'KORAMPALLAM',
                                  'KOLKATA',
                                  'KAKINADA',
                                  'CHENNAI',
                                  "ON-SITE",
                                  "NONE"
                                ]
                                    .map((e) => DropdownMenuItem(
                                          child: Text(e.toUpperCase()),
                                          value: e == "NONE" ? null : e,
                                        ))
                                    .toList(),
                                validator: (val) {
                                  if (val == null) {
                                    return "Please select a value";
                                  }
                                },
                                value: _controller.area,
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: QuoteDateBox(
                                title: 'TARGET Date',
                                nullable: false,
                                date: _controller.targetDate,
                                onPressed: () {
                                  showDatePicker(
                                    context: context,
                                    initialDate: _controller.targetDate ??
                                        DateTime.now(),
                                    firstDate: DateTime.utc(2000),
                                    lastDate: DateTime.utc(2100),
                                  ).then((value) {
                                    setState(() {
                                      _controller.targetDate = value;
                                    });
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        QuoteDropdown<String>(
                          title: 'Zone',
                          onChanged: (String? val) {
                            _controller.zone = val ?? _controller.zone;
                          },
                          validator: (val) {
                            if (val == null) {
                              return "Please select a zone";
                            }
                          },
                          items: [
                            'ANDHRA/TELUNGANA',
                            'TAMILNADU',
                            'KERALA/KARNATAKA',
                            'KOLKATA/ODISHA',
                            "ABROAD/OTHERS",
                            "NONE"
                          ]
                              .map((e) => DropdownMenuItem(
                                    child: Text(e.toUpperCase()),
                                    value: e == "NONE" ? null : e,
                                  ))
                              .toList(),
                          value: _controller.zone,
                        ),
                      ],
                    )
                  : Stack(
                      children: [
                        SizedBox(
                          height: Get.height * 0.55,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: CustomTextBox(
                                      hintText: 'JOB NO',
                                      controller: _controller.number,
                                      validator: (val) {
                                        if ((val ?? '').isEmpty) {
                                          return "Please enter a job number";
                                        }
                                        if ((val ?? '').split('/').isNotEmpty) {
                                          return (val ?? '')
                                                      .split('/')
                                                      .last
                                                      .length !=
                                                  4
                                              ? "Job Number should be 4 charachters"
                                              : null;
                                        } else {
                                          return "Please check the job number";
                                        }
                                      },
                                      suffixicon: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: IconButton(
                                            onPressed: () {
                                              getNextJobId().then((value) {
                                                setState(() {
                                                  _controller.number.text =
                                                      _controller.number.text +
                                                          value
                                                              .toString()
                                                              .padLeft(4, '0');
                                                });
                                              });
                                            },
                                            icon: const Icon(
                                                Icons.next_plan_outlined)),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: StreamBuilder<
                                            QuerySnapshot<
                                                Map<String, dynamic>>>(
                                        stream: customers.snapshots(),
                                        builder: (context,
                                            AsyncSnapshot<
                                                    QuerySnapshot<
                                                        Map<String, dynamic>>>
                                                snapshot) {
                                          List<Customer>? docs = snapshot
                                                  .data?.docs
                                                  .map((e) => Customer.fromJson(
                                                      e.data()))
                                                  .toList() ??
                                              [];
                                          // List customerList= docs.map((e) {
                                          //   e["name"];
                                          //   print(e.toString());
                                          //
                                          // } ).toList();

                                          return SizedBox(
                                              width: getWidth(context) * 0.25,
                                              child: ListTile(
                                                  title: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            4.0),
                                                    child: Text('CUST name'),
                                                  ),
                                                  subtitle: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: SearchField(
                                                        validator: (val) {
                                                          if ((val ?? '')
                                                              .isEmpty) {
                                                            return 'Customer is required';
                                                          }
                                                        },
                                                        controller: _controller
                                                            .customer,
                                                        searchInputDecoration: InputDecoration(
                                                            fillColor:
                                                                Colors.white,
                                                            hintText:
                                                                'Customer name',
                                                            border: const OutlineInputBorder(
                                                                borderRadius: BorderRadius.all(
                                                                    Radius.circular(
                                                                        4.0))),
                                                            errorBorder: const OutlineInputBorder(
                                                                borderRadius: BorderRadius.all(
                                                                    Radius.circular(
                                                                        4.0)),
                                                                borderSide: BorderSide(
                                                                    color: Colors
                                                                        .red))),
                                                        suggestions: docs
                                                            .map((e) =>
                                                                SearchFieldListItem(e.name ?? 'nodata'))
                                                            .toList()),
                                                  )));
                                        }),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: CustomTextBox(
                                      hintText: 'Description',
                                      controller: _controller.description,
                                    ),
                                  ),
                                  Expanded(
                                      flex: 1,
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: CustomTextBox(
                                              hintText: 'Quantity',
                                              controller: _controller.quantity,
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: ListTile(
                                              title: Text(''),
                                              subtitle: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: CustomDropdown1<String>(
                                                  title: 'QTY',
                                                  onChanged: (String? val) {
                                                    _controller.unit =
                                                        val ?? _controller.unit;
                                                  },
                                                  items: ["Nos", "Set", "Mtr"]
                                                      .map((e) =>
                                                          DropdownMenuItem(
                                                            child: Text(e),
                                                            value: e,
                                                          ))
                                                      .toList(),
                                                  value: _controller.unit,
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      )),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: QuoteDateBox(
                                      title: 'ISSUE Date',
                                      date: _controller.marketIsssuedDate,
                                      onPressed: () async {
                                        _controller.marketIsssuedDate =
                                            await showDatePicker(
                                          context: context,
                                          initialDate:
                                              _controller.marketIsssuedDate ??
                                                  DateTime.now(),
                                          firstDate: DateTime.utc(2000),
                                          lastDate: DateTime.utc(2100),
                                        );
                                        setState(() {});
                                      },
                                      nullable: false,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: QuoteDropdown<int>(
                                      title: 'Priority',
                                      onChanged: (int? val) {
                                        _controller.priority = val ?? 0;
                                      },
                                      items: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
                                          .map((e) => DropdownMenuItem<int>(
                                                child: Text(e == 0
                                                    ? "NONE"
                                                    : e
                                                        .toString()
                                                        .toUpperCase()),
                                                value: e,
                                              ))
                                          .toList(),
                                      value: _controller.priority,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: QuoteDropdown<String>(
                                      title: 'SITE LOCATION',
                                      onChanged: (String? val) {
                                        _controller.area =
                                            val ?? _controller.area;
                                      },
                                      items: [
                                        'SIPCOT',
                                        'KORAMPALLAM',
                                        'KOLKATA',
                                        'KAKINADA',
                                        'CHENNAI',
                                        "ON-SITE",
                                        "NONE"
                                      ]
                                          .map((e) => DropdownMenuItem(
                                                child: Text(e.toUpperCase()),
                                                value: e == "NONE" ? null : e,
                                              ))
                                          .toList(),
                                      // validator: (val) {
                                      //   if (val == null) {
                                      //     return "Please select a value";
                                      //   }
                                      // },
                                      value: _controller.area,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: QuoteDateBox(
                                      title: 'TARGET Date',
                                      nullable: false,
                                      date: _controller.targetDate,
                                      onPressed: () {
                                        showDatePicker(
                                          context: context,
                                          initialDate: _controller.targetDate ??
                                              DateTime.now(),
                                          firstDate: DateTime.utc(2000),
                                          lastDate: DateTime.utc(2100),
                                        ).then((value) {
                                          setState(() {
                                            _controller.targetDate = value;
                                          });
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              QuoteDropdown<String>(
                                title: 'Zone',
                                onChanged: (String? val) {
                                  _controller.zone = val ?? _controller.zone;
                                },
                                validator: (val) {
                                  if (val == null) {
                                    return "Please select a zone";
                                  }
                                },
                                items: [
                                  'KOLKATA/ODISHA',
                                  'ANDHRA/TELUNGANA',
                                  'TAMILNADU',
                                  'KERALA/KARNATAKA',
                                  "ABROAD/OTHERS",
                                  "NONE"
                                ]
                                    .map((e) => DropdownMenuItem(
                                          child: Text(e.toUpperCase()),
                                          value: e == "NONE" ? null : e,
                                        ))
                                    .toList(),
                                value: _controller.zone,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          color: Colors.transparent,
                          height: Get.height * 0.55,
                          width: Get.width,
                        ),
                      ],
                    ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Divider(),
              ),
              //------------------designcolumn----------

              Card(
                color: Colors.lightGreen.withOpacity(0.2),
                elevation: 3,
                child: ExpansionTile(
                  trailing: CustomSwitch(
                    title: '',
                    value: _controller.design,
                    onChanged: (val) {
                      auth.design
                          ? setState(() {
                              _controller.design = val;
                            })
                          : ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content:
                                  Text("You don't have permission to update")));
                    },
                  ),
                  collapsedBackgroundColor:
                      _controller.design ? Colors.greenAccent : Colors.white,
                  title: Text('Design Status'),
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Card(
                            elevation: 3,
                            child: ListTile(
                              title: Text('Machining'),
                              subtitle: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  ChoiceChip(
                                    label: Text('completed'),
                                    selected: _controller.machining ?? false,
                                    onSelected: (value) {
                                      auth.design
                                          ? setState(() {
                                              _controller.machining = value;
                                            })
                                          : ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      "You don't have permission to update")));
                                    },
                                    selectedColor: Colors.green,
                                  ),
                                  ChoiceChip(
                                    label: Text('Processing'),
                                    selected: _controller.machining == false,
                                    onSelected: (value) {
                                      print(value);

                                      auth.design
                                          ? setState(() {
                                              _controller.machining = false;
                                            })
                                          : ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      "You don't have permission to update")));
                                    },
                                    selectedColor: Colors.orangeAccent,
                                  ),
                                  ChoiceChip(
                                    label: Text('Not Applicable'),
                                    selected: _controller.machining == null,
                                    onSelected: (value) {
                                      print(value);

                                      auth.design
                                          ? setState(() {
                                              _controller.machining = null;
                                            })
                                          : ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      "You don't have permission to update")));
                                    },
                                    selectedColor: Colors.redAccent,
                                  ),
                                ],
                              ),
                              leading: Image.network(
                                  'https://cdn-icons-png.flaticon.com/512/3401/3401762.png',
                                  height: getHeight(context) * 0.05),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Card(
                            elevation: 3,
                            child: ListTile(
                              title: Text('FabricationDrawing'),
                              subtitle: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  ChoiceChip(
                                    label: Text('completed'),
                                    selected:
                                        _controller.fabricationDrawing ?? false,
                                    onSelected: (value) {
                                      print(value);

                                      auth.design
                                          ? setState(() {
                                              _controller.fabricationDrawing =
                                                  value;
                                            })
                                          : ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      "You don't have permission to update")));
                                    },
                                    selectedColor: Colors.green,
                                  ),
                                  ChoiceChip(
                                    label: Text('Processing'),
                                    selected:
                                        _controller.fabricationDrawing == false,
                                    onSelected: (value) {
                                      print(value);

                                      auth.design
                                          ? setState(() {
                                              _controller.fabricationDrawing =
                                                  false;
                                            })
                                          : ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      "You don't have permission to update")));
                                    },
                                    selectedColor: Colors.orangeAccent,
                                  ),
                                  ChoiceChip(
                                    label: Text('Not Applicable'),
                                    selected:
                                        _controller.fabricationDrawing == null,
                                    onSelected: (value) {
                                      print(value);

                                      auth.design
                                          ? setState(() {
                                              _controller.fabricationDrawing =
                                                  null;
                                            })
                                          : ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      "You don't have permission to update")));
                                    },
                                    selectedColor: Colors.redAccent,
                                  ),
                                ],
                              ),
                              leading: Image.network(
                                  'https://cdn-icons-png.flaticon.com/512/7817/7817608.png',
                                  height: getHeight(context) * 0.05),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          leading: Image.network(
                              'https://cdn-icons-png.flaticon.com/512/6953/6953015.png',
                              height: getHeight(context) * 0.05),
                          title: Text('Bill of Materials'),
                          trailing: CustomSwitch(
                            title: '',
                            value: _controller.billOfMaterials ?? false,
                            onChanged: (val) {
                              auth.design
                                  ? setState(() {
                                      _controller.billOfMaterials = val;
                                    })
                                  : ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              "You don't have permission to update")));
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              //-------------------store colum----------------
              Card(
                color: Colors.purpleAccent.withOpacity(0.4),
                elevation: 3,
                child: ExpansionTile(
                  trailing: CustomSwitch(
                    title: '',
                    value: _controller.storeStatus ?? false,
                    onChanged: (val) {
                      auth.store
                          ? setState(() {
                              _controller.storeStatus = val;
                            })
                          : ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content:
                                  Text("You don't have permission to update")));
                    },
                  ),
                  expandedCrossAxisAlignment: CrossAxisAlignment.start,
                  expandedAlignment: Alignment.bottomRight,
                  collapsedBackgroundColor: _controller.storeStatus == true
                      ? Colors.greenAccent
                      : Colors.white,
                  title: Text('Store'),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Raw Materials',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Card(
                            elevation: 3,
                            child: ListTile(
                              title: Text('Fabrication'),
                              subtitle: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  ChoiceChip(
                                    label: Text('completed'),
                                    selected:
                                        _controller.srawFabrication ?? false,
                                    onSelected: (value) {
                                      print(value);

                                      auth.store
                                          ? setState(() {
                                              _controller.srawFabrication =
                                                  value;
                                            })
                                          : ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      "You don't have permission to update")));
                                    },
                                    selectedColor: Colors.green,
                                  ),
                                  ChoiceChip(
                                    label: Text('Processing'),
                                    selected:
                                        _controller.srawFabrication == false,
                                    onSelected: (value) {
                                      print(value);

                                      auth.store
                                          ? setState(() {
                                              _controller.srawFabrication =
                                                  false;
                                            })
                                          : ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      "You don't have permission to update")));
                                    },
                                    selectedColor: Colors.orangeAccent,
                                  ),
                                  ChoiceChip(
                                    label: Text('Not Applicable'),
                                    selected:
                                        _controller.srawFabrication == null,
                                    onSelected: (value) {
                                      print(value);

                                      auth.store
                                          ? setState(() {
                                              _controller.srawFabrication =
                                                  null;
                                            })
                                          : ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      "You don't have permission to update")));
                                    },
                                    selectedColor: Colors.redAccent,
                                  ),
                                ],
                              ),
                              leading: Image.network(
                                  'https://cdn-icons-png.flaticon.com/512/2299/2299224.png',
                                  height: getHeight(context) * 0.05),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Card(
                            elevation: 3,
                            child: ListTile(
                              title: Text('Lathe'),
                              subtitle: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  ChoiceChip(
                                    label: Text('completed'),
                                    selected: _controller.srawLathe ?? false,
                                    onSelected: (value) {
                                      print(value);

                                      auth.store
                                          ? setState(() {
                                              _controller.srawLathe = value;
                                            })
                                          : ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      "You don't have permission to update")));
                                    },
                                    selectedColor: Colors.green,
                                  ),
                                  ChoiceChip(
                                    label: Text('Processing'),
                                    selected: _controller.srawLathe == false,
                                    onSelected: (value) {
                                      print(value);

                                      auth.store
                                          ? setState(() {
                                              _controller.srawLathe = false;
                                            })
                                          : ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      "You don't have permission to update")));
                                    },
                                    selectedColor: Colors.orangeAccent,
                                  ),
                                  ChoiceChip(
                                    label: Text('Not Applicable'),
                                    selected: _controller.srawLathe == null,
                                    onSelected: (value) {
                                      print(value);

                                      auth.store
                                          ? setState(() {
                                              _controller.srawLathe = null;
                                            })
                                          : ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      "You don't have permission to update")));
                                    },
                                    selectedColor: Colors.redAccent,
                                  ),
                                ],
                              ),
                              leading: Image.network(
                                  'https://cdn-icons-png.flaticon.com/512/1799/1799865.png',
                                  height: getHeight(context) * 0.05),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Bought Out Items',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Card(
                            elevation: 3,
                            child: ListTile(
                              title: Text('Fasteners'),
                              subtitle: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  ChoiceChip(
                                    label: Text('completed'),
                                    selected: _controller.sfasteners ?? false,
                                    onSelected: (value) {
                                      print(value);

                                      auth.store
                                          ? setState(() {
                                              _controller.sfasteners = value;
                                            })
                                          : ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      "You don't have permission to update")));
                                    },
                                    selectedColor: Colors.green,
                                  ),
                                  ChoiceChip(
                                    label: Text('Processing'),
                                    selected: _controller.sfasteners == false,
                                    onSelected: (value) {
                                      print(value);

                                      auth.store
                                          ? setState(() {
                                              _controller.sfasteners = false;
                                            })
                                          : ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      "You don't have permission to update")));
                                    },
                                    selectedColor: Colors.orangeAccent,
                                  ),
                                  ChoiceChip(
                                    label: Text('Not Applicable'),
                                    selected: _controller.sfasteners == null,
                                    onSelected: (value) {
                                      print(value);

                                      auth.store
                                          ? setState(() {
                                              _controller.sfasteners = null;
                                            })
                                          : ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      "You don't have permission to update")));
                                    },
                                    selectedColor: Colors.redAccent,
                                  ),
                                ],
                              ),
                              leading: Image.network(
                                  'https://cdn-icons-png.flaticon.com/512/6695/6695344.png',
                                  height: getHeight(context) * 0.05),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Card(
                            elevation: 3,
                            child: ListTile(
                              title: Text('Fittings'),
                              subtitle: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  ChoiceChip(
                                    label: Text('completed'),
                                    selected: _controller.sfittings ?? false,
                                    onSelected: (value) {
                                      print(value);

                                      auth.store
                                          ? setState(() {
                                              _controller.sfittings = value;
                                            })
                                          : ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      "You don't have permission to update")));
                                    },
                                    selectedColor: Colors.green,
                                  ),
                                  ChoiceChip(
                                    label: Text('Processing'),
                                    selected: _controller.sfittings == false,
                                    onSelected: (value) {
                                      print(value);

                                      auth.store
                                          ? setState(() {
                                              _controller.sfittings = false;
                                            })
                                          : ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      "You don't have permission to update")));
                                    },
                                    selectedColor: Colors.orangeAccent,
                                  ),
                                  ChoiceChip(
                                    label: Text('Not Applicable'),
                                    selected: _controller.sfittings == null,
                                    onSelected: (value) {
                                      print(value);

                                      auth.store
                                          ? setState(() {
                                              _controller.sfittings = null;
                                            })
                                          : ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      "You don't have permission to update")));
                                    },
                                    selectedColor: Colors.redAccent,
                                  ),
                                ],
                              ),
                              leading: Image.network(
                                  'https://cdn-icons-png.flaticon.com/512/2593/2593065.png',
                                  height: getHeight(context) * 0.05),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Card(
                            elevation: 3,
                            child: ListTile(
                              title: Text('Bearings'),
                              subtitle: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  ChoiceChip(
                                    label: Text('completed'),
                                    selected: _controller.sbearings ?? false,
                                    onSelected: (value) {
                                      print(value);

                                      auth.store
                                          ? setState(() {
                                              _controller.sbearings = value;
                                            })
                                          : ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      "You don't have permission to update")));
                                    },
                                    selectedColor: Colors.green,
                                  ),
                                  ChoiceChip(
                                    label: Text('Processing'),
                                    selected: _controller.sbearings == false,
                                    onSelected: (value) {
                                      print(value);

                                      auth.store
                                          ? setState(() {
                                              _controller.sbearings = false;
                                            })
                                          : ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      "You don't have permission to update")));
                                    },
                                    selectedColor: Colors.orangeAccent,
                                  ),
                                  ChoiceChip(
                                    label: Text('Not Applicable'),
                                    selected: _controller.sbearings == null,
                                    onSelected: (value) {
                                      print(value);

                                      auth.store
                                          ? setState(() {
                                              _controller.sbearings = null;
                                            })
                                          : ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      "You don't have permission to update")));
                                    },
                                    selectedColor: Colors.redAccent,
                                  ),
                                ],
                              ),
                              leading: Image.network(
                                  'https://cdn-icons-png.flaticon.com/512/3872/3872446.png',
                                  height: getHeight(context) * 0.05),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Card(
                            elevation: 3,
                            child: ListTile(
                              title: Text('Electricals'),
                              subtitle: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  ChoiceChip(
                                    label: Text('completed'),
                                    selected: _controller.selectricals ?? false,
                                    onSelected: (value) {
                                      print(value);

                                      auth.store
                                          ? setState(() {
                                              _controller.selectricals = value;
                                            })
                                          : ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      "You don't have permission to update")));
                                    },
                                    selectedColor: Colors.green,
                                  ),
                                  ChoiceChip(
                                    label: Text('Processing'),
                                    selected: _controller.selectricals == false,
                                    onSelected: (value) {
                                      print(value);

                                      auth.store
                                          ? setState(() {
                                              _controller.selectricals = false;
                                            })
                                          : ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      "You don't have permission to update")));
                                    },
                                    selectedColor: Colors.orangeAccent,
                                  ),
                                  ChoiceChip(
                                    label: Text('Not Applicable'),
                                    selected: _controller.selectricals == null,
                                    onSelected: (value) {
                                      print(value);

                                      auth.store
                                          ? setState(() {
                                              _controller.selectricals = null;
                                            })
                                          : ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      "You don't have permission to update")));
                                    },
                                    selectedColor: Colors.redAccent,
                                  ),
                                ],
                              ),
                              leading: Image.network(
                                  'https://cdn-icons-png.flaticon.com/512/2781/2781885.png',
                                  height: getHeight(context) * 0.05),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Divider(),
                    Row(
                      children: [
                        Expanded(
                          child: Card(
                            elevation: 3,
                            child: ListTile(
                              title: Text('Belt'),
                              subtitle: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  ChoiceChip(
                                    label: Text('completed'),
                                    selected: _controller.sBelts ?? false,
                                    onSelected: (value) {
                                      print(value);

                                      auth.store
                                          ? setState(() {
                                              _controller.sBelts = value;
                                            })
                                          : ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      "You don't have permission to update")));
                                    },
                                    selectedColor: Colors.green,
                                  ),
                                  ChoiceChip(
                                    label: Text('Processing'),
                                    selected: _controller.sBelts == false,
                                    onSelected: (value) {
                                      print(value);

                                      auth.store
                                          ? setState(() {
                                              _controller.sBelts = false;
                                            })
                                          : ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      "You don't have permission to update")));
                                    },
                                    selectedColor: Colors.orangeAccent,
                                  ),
                                  ChoiceChip(
                                    label: Text('Not Applicable'),
                                    selected: _controller.sBelts == null,
                                    onSelected: (value) {
                                      print(value);

                                      auth.store
                                          ? setState(() {
                                              _controller.sBelts = null;
                                            })
                                          : ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      "You don't have permission to update")));
                                    },
                                    selectedColor: Colors.redAccent,
                                  ),
                                ],
                              ),
                              leading: Image.network(
                                  'https://cdn-icons-png.flaticon.com/512/8169/8169073.png',
                                  height: getHeight(context) * 0.05),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Card(
                            elevation: 3,
                            child: ListTile(
                              title: Text('Gear Boxes'),
                              subtitle: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  ChoiceChip(
                                    label: Text('completed'),
                                    selected: _controller.sGears ?? false,
                                    onSelected: (value) {
                                      print(value);

                                      auth.store
                                          ? setState(() {
                                              _controller.sGears = value;
                                            })
                                          : ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      "You don't have permission to update")));
                                    },
                                    selectedColor: Colors.green,
                                  ),
                                  ChoiceChip(
                                    label: Text('Processing'),
                                    selected: _controller.sGears == false,
                                    onSelected: (value) {
                                      print(value);

                                      auth.store
                                          ? setState(() {
                                              _controller.sGears = false;
                                            })
                                          : ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      "You don't have permission to update")));
                                    },
                                    selectedColor: Colors.orangeAccent,
                                  ),
                                  ChoiceChip(
                                    label: Text('Not Applicable'),
                                    selected: _controller.sGears == null,
                                    onSelected: (value) {
                                      print(value);

                                      auth.store
                                          ? setState(() {
                                              _controller.sGears = null;
                                            })
                                          : ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      "You don't have permission to update")));
                                    },
                                    selectedColor: Colors.redAccent,
                                  ),
                                ],
                              ),
                              leading: Image.network(
                                  'https://cdn-icons-png.flaticon.com/512/3374/3374550.png',
                                  height: getHeight(context) * 0.05),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              //-----------------PurchaseColumn-------------------

              Card(
                color: Colors.tealAccent.withOpacity(0.4),
                elevation: 3,
                child: ExpansionTile(
                  trailing: CustomSwitch(
                    title: '',
                    value: _controller.purchaseStatus ?? false,
                    onChanged: (val) {
                      auth.purchase
                          ? setState(() {
                              _controller.purchaseStatus = val;
                            })
                          : ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content:
                                  Text("You don't have permission to update")));
                    },
                  ),
                  expandedCrossAxisAlignment: CrossAxisAlignment.start,
                  expandedAlignment: Alignment.bottomRight,
                  collapsedBackgroundColor: _controller.purchaseStatus == true
                      ? Colors.greenAccent
                      : Colors.white,
                  title: Text('Purchase'),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Raw Materials',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Card(
                            elevation: 3,
                            child: ListTile(
                              title: Text('Fabrication'),
                              subtitle: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  ChoiceChip(
                                    label: Text('completed'),
                                    selected: _controller.purchasefabrication ??
                                        false,
                                    onSelected: (value) {
                                      print(value);

                                      auth.purchase
                                          ? setState(() {
                                              _controller.purchasefabrication =
                                                  value;
                                            })
                                          : ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      "You don't have permission to update")));
                                    },
                                    selectedColor: Colors.green,
                                  ),
                                  ChoiceChip(
                                    label: Text('Processing'),
                                    selected: _controller.purchasefabrication ==
                                        false,
                                    onSelected: (value) {
                                      print(value);

                                      auth.purchase
                                          ? setState(() {
                                              _controller.purchasefabrication =
                                                  false;
                                            })
                                          : ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      "You don't have permission to update")));
                                    },
                                    selectedColor: Colors.orangeAccent,
                                  ),
                                  ChoiceChip(
                                    label: Text('Not Applicable'),
                                    selected:
                                        _controller.purchasefabrication == null,
                                    onSelected: (value) {
                                      print(value);

                                      auth.purchase
                                          ? setState(() {
                                              _controller.purchasefabrication =
                                                  null;
                                            })
                                          : ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      "You don't have permission to update")));
                                    },
                                    selectedColor: Colors.redAccent,
                                  ),
                                ],
                              ),
                              leading: Image.network(
                                  'https://cdn-icons-png.flaticon.com/512/2299/2299224.png',
                                  height: getHeight(context) * 0.05),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Card(
                            elevation: 3,
                            child: ListTile(
                              title: Text('Lathe'),
                              subtitle: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  ChoiceChip(
                                    label: Text('completed'),
                                    selected:
                                        _controller.purchaselathe ?? false,
                                    onSelected: (value) {
                                      print(value);

                                      auth.purchase
                                          ? setState(() {
                                              _controller.purchaselathe = value;
                                            })
                                          : ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      "You don't have permission to update")));
                                    },
                                    selectedColor: Colors.green,
                                  ),
                                  ChoiceChip(
                                    label: Text('Processing'),
                                    selected:
                                        _controller.purchaselathe == false,
                                    onSelected: (value) {
                                      print(value);

                                      auth.purchase
                                          ? setState(() {
                                              _controller.purchaselathe = false;
                                            })
                                          : ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      "You don't have permission to update")));
                                    },
                                    selectedColor: Colors.orangeAccent,
                                  ),
                                  ChoiceChip(
                                    label: Text('Not Applicable'),
                                    selected: _controller.purchaselathe == null,
                                    onSelected: (value) {
                                      print(value);

                                      auth.purchase
                                          ? setState(() {
                                              _controller.purchaselathe = null;
                                            })
                                          : ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      "You don't have permission to update")));
                                    },
                                    selectedColor: Colors.redAccent,
                                  ),
                                ],
                              ),
                              leading: Image.network(
                                  'https://cdn-icons-png.flaticon.com/512/1799/1799865.png',
                                  height: getHeight(context) * 0.05),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Bought Out Items',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Card(
                            elevation: 3,
                            child: ListTile(
                              title: Text('Fasteners'),
                              subtitle: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  ChoiceChip(
                                    label: Text('completed'),
                                    selected:
                                        _controller.purchaseFasteners ?? false,
                                    onSelected: (value) {
                                      print(value);

                                      auth.purchase
                                          ? setState(() {
                                              _controller.purchaseFasteners =
                                                  value;
                                            })
                                          : ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      "You don't have permission to update")));
                                    },
                                    selectedColor: Colors.green,
                                  ),
                                  ChoiceChip(
                                    label: Text('Processing'),
                                    selected:
                                        _controller.purchaseFasteners == false,
                                    onSelected: (value) {
                                      print(value);

                                      auth.purchase
                                          ? setState(() {
                                              _controller.purchaseFasteners =
                                                  false;
                                            })
                                          : ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      "You don't have permission to update")));
                                    },
                                    selectedColor: Colors.orangeAccent,
                                  ),
                                  ChoiceChip(
                                    label: Text('Not Applicable'),
                                    selected:
                                        _controller.purchaseFasteners == null,
                                    onSelected: (value) {
                                      print(value);

                                      auth.purchase
                                          ? setState(() {
                                              _controller.purchaseFasteners =
                                                  null;
                                            })
                                          : ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      "You don't have permission to update")));
                                    },
                                    selectedColor: Colors.redAccent,
                                  ),
                                ],
                              ),
                              leading: Image.network(
                                  'https://cdn-icons-png.flaticon.com/512/6695/6695344.png',
                                  height: getHeight(context) * 0.05),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Card(
                            elevation: 3,
                            child: ListTile(
                              title: Text('Fittings'),
                              subtitle: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  ChoiceChip(
                                    label: Text('completed'),
                                    selected:
                                        _controller.purchaseFittings ?? false,
                                    onSelected: (value) {
                                      print(value);

                                      auth.purchase
                                          ? setState(() {
                                              _controller.purchaseFittings =
                                                  value;
                                            })
                                          : ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      "You don't have permission to update")));
                                    },
                                    selectedColor: Colors.green,
                                  ),
                                  ChoiceChip(
                                    label: Text('Processing'),
                                    selected:
                                        _controller.purchaseFittings == false,
                                    onSelected: (value) {
                                      print(value);

                                      auth.purchase
                                          ? setState(() {
                                              _controller.purchaseFittings =
                                                  false;
                                            })
                                          : ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      "You don't have permission to update")));
                                    },
                                    selectedColor: Colors.orangeAccent,
                                  ),
                                  ChoiceChip(
                                    label: Text('Not Applicable'),
                                    selected:
                                        _controller.purchaseFittings == null,
                                    onSelected: (value) {
                                      print(value);

                                      auth.purchase
                                          ? setState(() {
                                              _controller.purchaseFittings =
                                                  null;
                                            })
                                          : ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      "You don't have permission to update")));
                                    },
                                    selectedColor: Colors.redAccent,
                                  ),
                                ],
                              ),
                              leading: Image.network(
                                  'https://cdn-icons-png.flaticon.com/512/2593/2593065.png',
                                  height: getHeight(context) * 0.05),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Card(
                            elevation: 3,
                            child: ListTile(
                              title: Text('Bearings'),
                              subtitle: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  ChoiceChip(
                                    label: Text('completed'),
                                    selected:
                                        _controller.purchaseBearings ?? false,
                                    onSelected: (value) {
                                      print(value);

                                      auth.purchase
                                          ? setState(() {
                                              _controller.purchaseBearings =
                                                  value;
                                            })
                                          : ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      "You don't have permission to update")));
                                    },
                                    selectedColor: Colors.green,
                                  ),
                                  ChoiceChip(
                                    label: Text('Processing'),
                                    selected:
                                        _controller.purchaseBearings == false,
                                    onSelected: (value) {
                                      print(value);

                                      auth.purchase
                                          ? setState(() {
                                              _controller.purchaseBearings =
                                                  false;
                                            })
                                          : ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      "You don't have permission to update")));
                                    },
                                    selectedColor: Colors.orangeAccent,
                                  ),
                                  ChoiceChip(
                                    label: Text('Not Applicable'),
                                    selected:
                                        _controller.purchaseBearings == null,
                                    onSelected: (value) {
                                      print(value);

                                      auth.purchase
                                          ? setState(() {
                                              _controller.purchaseBearings =
                                                  null;
                                            })
                                          : ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      "You don't have permission to update")));
                                    },
                                    selectedColor: Colors.redAccent,
                                  ),
                                ],
                              ),
                              leading: Image.network(
                                  'https://cdn-icons-png.flaticon.com/512/3872/3872446.png',
                                  height: getHeight(context) * 0.05),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Card(
                            elevation: 3,
                            child: ListTile(
                              title: Text('Electricals'),
                              subtitle: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  ChoiceChip(
                                    label: Text('completed'),
                                    selected:
                                        _controller.purchaseElectricalItems ??
                                            false,
                                    onSelected: (value) {
                                      print(value);

                                      auth.purchase
                                          ? setState(() {
                                              _controller
                                                      .purchaseElectricalItems =
                                                  value;
                                            })
                                          : ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      "You don't have permission to update")));
                                    },
                                    selectedColor: Colors.green,
                                  ),
                                  ChoiceChip(
                                    label: Text('Processing'),
                                    selected:
                                        _controller.purchaseElectricalItems ==
                                            false,
                                    onSelected: (value) {
                                      print(value);

                                      auth.purchase
                                          ? setState(() {
                                              _controller
                                                      .purchaseElectricalItems =
                                                  false;
                                            })
                                          : ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      "You don't have permission to update")));
                                    },
                                    selectedColor: Colors.orangeAccent,
                                  ),
                                  ChoiceChip(
                                    label: Text('Not Applicable'),
                                    selected:
                                        _controller.purchaseElectricalItems ==
                                            null,
                                    onSelected: (value) {
                                      print(value);

                                      auth.purchase
                                          ? setState(() {
                                              _controller
                                                      .purchaseElectricalItems =
                                                  null;
                                            })
                                          : ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      "You don't have permission to update")));
                                    },
                                    selectedColor: Colors.redAccent,
                                  ),
                                ],
                              ),
                              leading: Image.network(
                                  'https://cdn-icons-png.flaticon.com/512/2781/2781885.png',
                                  height: getHeight(context) * 0.05),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Divider(),
                    Row(
                      children: [
                        Expanded(
                          child: Card(
                            elevation: 3,
                            child: ListTile(
                              title: Text('Belt'),
                              subtitle: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  ChoiceChip(
                                    label: Text('completed'),
                                    selected:
                                        _controller.purchaseBelts ?? false,
                                    onSelected: (value) {
                                      print(value);

                                      auth.purchase
                                          ? setState(() {
                                              _controller.purchaseBelts = value;
                                            })
                                          : ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      "You don't have permission to update")));
                                    },
                                    selectedColor: Colors.green,
                                  ),
                                  ChoiceChip(
                                    label: Text('Processing'),
                                    selected:
                                        _controller.purchaseBelts == false,
                                    onSelected: (value) {
                                      print(value);

                                      auth.purchase
                                          ? setState(() {
                                              _controller.purchaseBelts = false;
                                            })
                                          : ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      "You don't have permission to update")));
                                    },
                                    selectedColor: Colors.orangeAccent,
                                  ),
                                  ChoiceChip(
                                    label: Text('Not Applicable'),
                                    selected: _controller.purchaseBelts == null,
                                    onSelected: (value) {
                                      print(value);

                                      auth.purchase
                                          ? setState(() {
                                              _controller.purchaseBelts = null;
                                            })
                                          : ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      "You don't have permission to update")));
                                    },
                                    selectedColor: Colors.redAccent,
                                  ),
                                ],
                              ),
                              leading: Image.network(
                                  'https://cdn-icons-png.flaticon.com/512/8169/8169073.png',
                                  height: getHeight(context) * 0.05),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Card(
                            elevation: 3,
                            child: ListTile(
                              title: Text('Gear Boxes'),
                              subtitle: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  ChoiceChip(
                                    label: Text('completed'),
                                    selected:
                                        _controller.purchaseGears ?? false,
                                    onSelected: (value) {
                                      print(value);

                                      auth.purchase
                                          ? setState(() {
                                              _controller.purchaseGears = value;
                                            })
                                          : ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      "You don't have permission to update")));
                                    },
                                    selectedColor: Colors.green,
                                  ),
                                  ChoiceChip(
                                    label: Text('Processing'),
                                    selected:
                                        _controller.purchaseGears == false,
                                    onSelected: (value) {
                                      print(value);

                                      auth.purchase
                                          ? setState(() {
                                              _controller.purchaseGears = false;
                                            })
                                          : ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      "You don't have permission to update")));
                                    },
                                    selectedColor: Colors.orangeAccent,
                                  ),
                                  ChoiceChip(
                                    label: Text('Not Applicable'),
                                    selected: _controller.purchaseGears == null,
                                    onSelected: (value) {
                                      print(value);

                                      auth.purchase
                                          ? setState(() {
                                              _controller.purchaseGears = null;
                                            })
                                          : ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      "You don't have permission to update")));
                                    },
                                    selectedColor: Colors.redAccent,
                                  ),
                                ],
                              ),
                              leading: Image.network(
                                  'https://cdn-icons-png.flaticon.com/512/3374/3374550.png',
                                  height: getHeight(context) * 0.05),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // ---------------------ProductionColumn-------------------

              Card(
                color: Colors.cyanAccent.withOpacity(0.4),
                elevation: 3,
                child: ExpansionTile(
                  collapsedBackgroundColor:
                      (_controller.productionAssembly == true &&
                              _controller.productionFabrication == true &&
                              _controller.productionLathe == true)
                          ? Colors.greenAccent
                          : Colors.white,
                  // backgroundColor:   (_controller.productionAssembly&&_controller.productionFabrication&&_controller.productionLathe)? Colors.greenAccent : Colors.white,
                  trailing: CustomSwitch(
                    title: '',
                    value: _controller.productionLathe == true &&
                            _controller.productionFabrication == true &&
                            _controller.productionAssembly == true
                        ? true
                        : false,
                    onChanged: (val) {
                      (auth.productionLathe && auth.productionFab)
                          ? setState(() {
                              _controller.productionLathe = val;
                              _controller.productionFabrication = val;
                              _controller.productionAssembly = val;
                            })
                          : ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content:
                                  Text("You don't have permission to update")));
                    },
                  ),
                  expandedCrossAxisAlignment: CrossAxisAlignment.start,
                  expandedAlignment: Alignment.bottomRight,
                  // collapsedBackgroundColor: (_controller.productionAssembly&&_controller.productionFabrication&&_controller.productionLathe)? Colors.greenAccent : Colors.white,
                  title: Text('Production'),
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: CustomSwitch(
                            subtitle: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ChoiceChip(
                                  label: Text('Not Applicable'),
                                  selected: _controller.productionLathe == null,
                                  onSelected: (value) {
                                    print(value);

                                    (auth.productionLathe || auth.ProductionAll)
                                        ? setState(() {
                                            _controller.productionLathe = null;
                                          })
                                        : ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: Text(
                                                    "You don't have permission to update")));
                                  },
                                  selectedColor: Colors.redAccent,
                                ),
                                SizedBox(width: 10),

                                //Partially Completed Chip
                                ChoiceChip(
                                  label: Text('Partially completed'),
                                  selected:
                                      _controller.productionLathe == false,
                                  onSelected: (value) {
                                    print(value);

                                    (auth.productionLathe || auth.ProductionAll)
                                        ? setState(() {
                                            _controller.productionLathe = false;
                                          })
                                        : ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: Text(
                                                    "You don't have permission to update")));
                                  },
                                  selectedColor: Colors.redAccent,
                                ),
                              ],
                            ),
                            leading: Image.network(
                              'https://cdn-icons-png.flaticon.com/512/1697/1697613.png',
                              height: getHeight(context) * 0.05,
                            ),
                            title: 'PRODUCTION LATHE',
                            value: _controller.productionLathe ?? false,
                            onChanged: (val) {
                              (auth.productionLathe || auth.ProductionAll)
                                  ? setState(() {
                                      _controller.productionLathe = val;
                                    })
                                  : ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              "You don't have permission to update")));
                            },
                          ),
                        ),
                        Expanded(
                          child: CustomSwitch(
                            leading: Image.network(
                              'https://cdn-icons-png.flaticon.com/512/3676/3676522.png',
                              height: getHeight(context) * 0.05,
                            ),
                            title: 'PRODCTION FABRICATION',
                            value: _controller.productionFabrication ?? false,
                            onChanged: (val) {
                              (auth.productionFab ||
                                      auth.productionFabassembly ||
                                      auth.ProductionAll)
                                  ? setState(() {
                                      _controller.productionFabrication = val;
                                    })
                                  : ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              "You don't have permission to update")));
                            },
                          ),
                        ),
                        Expanded(
                          child: CustomSwitch(
                            leading: Image.network(
                              'https://cdn-icons-png.flaticon.com/512/1166/1166813.png',
                              height: getHeight(context) * 0.05,
                            ),
                            title: 'PRODUCTION ASSEMBLY',
                            value: _controller.productionAssembly ?? false,
                            onChanged: (val) {
                              (auth.productionFab ||
                                      auth.productionFabassembly ||
                                      auth.ProductionAll ||
                                      auth.productionLathe)
                                  ? setState(() {
                                      _controller.productionAssembly = val;
                                    })
                                  : ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              "You don't have permission to update")));
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              Card(
                elevation: 5,
                child: CustomSwitch(
                  leading: Image.network(
                    'https://cdn-icons-png.flaticon.com/512/8716/8716731.png',
                    height: getHeight(context) * 0.05,
                  ),
                  title: 'Onsite Erection',
                  value: _controller.onsiteErection ?? false,
                  onChanged: (val) {
                    (auth.sales || auth.admin)
                        ? setState(() {
                            _controller.onsiteErection = val;
                          })
                        : ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content:
                                Text("You don't have permission to update")));
                  },
                ),
              ),

              Divider(),
              CustomTextBox(
                hintText: 'Remarks',
                controller: _controller.remarks,
                maxConstraints: true,
                maxLines: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomDropdown1<T> extends StatelessWidget {
  const CustomDropdown1(
      {Key? key,
      this.items,
      this.onChanged,
      this.value,
      required this.title,
      this.validator,
      this.selectedItemBuilder,
      this.hintText})
      : super(key: key);

  final List<DropdownMenuItem<T>>? items;
  final void Function(T?)? onChanged;
  final T? value;
  final String title;
  final String? Function(T?)? validator;
  final List<Widget> Function(BuildContext)? selectedItemBuilder;
  final String? hintText;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      decoration: const InputDecoration(
        hintText: '',
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(4.0))),
      ),
      validator: validator,
      items: items,
      onChanged: onChanged,
      value: value,
      isExpanded: true,
    );
  }
}
