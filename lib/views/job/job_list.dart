import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jeya_engineering/Controllers/auth_controller.dart';
import 'package:jeya_engineering/firebase.dart';
import 'package:jeya_engineering/mailer.dart';
import 'package:jeya_engineering/main.dart';

import 'package:jeya_engineering/models/job.dart';
import 'package:jeya_engineering/views/job/job_form.dart';
import 'package:jeya_engineering/views/job/new_job_list.dart';
import 'package:jeya_engineering/views/job/utilitiees/query_controller.dart';

import 'package:jeya_engineering/views/profile/profile_list.dart';
import 'package:jeya_engineering/widgets/date_picker.dart';
import 'package:jeya_engineering/widgets/utilities.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xl;

import '../../models/customer.dart';
import '../../widgets/drop_down.dart';
import './utilitiees/paginated_data_table.dart' as customTable;

import 'dart:io';
import 'package:whatsapp_share2/whatsapp_share2.dart';

import 'logs.dart';
// import 'dart:io';
// import 'dart:html' as html;
import 'package:open_filex/open_filex.dart';

import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

// import 'dart:convert';

//Local imports

bool isArchive = false;
String? filePath;

class JobList extends StatefulWidget {
  const JobList({Key? key}) : super(key: key);

  @override
  State<JobList> createState() => _JobListState();

  static Future<void> createExcel(List<Job> joblist) async {
    final xl.Workbook workbook = xl.Workbook();
    final xl.Worksheet worksheet = workbook.worksheets[0];
    worksheet.getRangeByName('A1:M1').columnWidth = 20;
    worksheet.getRangeByName('A1').setText('Sino');
    worksheet.getRangeByName('B1').setText('JOB no');
    worksheet.getRangeByName('C1').setText('CUST Name');
    worksheet.getRangeByName('D1').setText('JOB Name');
    worksheet.getRangeByName('E1').setText('Qty');
    worksheet.getRangeByName('F1').setText('ISSUE Date');
    worksheet.getRangeByName('G1').setText('DESIGN Status');
    worksheet.getRangeByName('H1').setText('PURCHASE Status');
    worksheet.getRangeByName('I1').setText('PROD-LATH Status');
    worksheet.getRangeByName('J1').setText('PROD Fabrication');
    worksheet.getRangeByName('K1').setText('SITE Location');
    worksheet.getRangeByName('L1').setText('TARGET Date');
    worksheet.getRangeByName('M1').setText('Remarks');

    int lenght = joblist.length;

    // joblist.forEach((element,) {
    //
    //
    //
    //
    //   worksheet.getRangeByName('A$lenght').setText(element.number);
    //
    //
    //
    //
    // });

    for (var i = 2; i <= joblist.length + 1; i++) {
      worksheet.getRangeByName('A$i').setText('${i - 1}');

      worksheet.getRangeByName('B$i').setText('${joblist[i - 2].number}');
      worksheet.getRangeByName('C$i').setText('${joblist[i - 2].customer}');
      worksheet.getRangeByName('D$i').setText('${joblist[i - 2].description}');
      worksheet
          .getRangeByName('E$i')
          .setText('${joblist[i - 2].quantity + joblist[i - 2].unit}');
      worksheet
          .getRangeByName('F$i')
          .setText('${format.format(joblist[i - 2].marketIsssuedDate!)}');
      worksheet.getRangeByName('G$i').setText('${joblist[i - 2].design}');
      worksheet.getRangeByName('H$i').setText(
          (joblist[i - 2].purchaseElectricalItems == true &&
                  joblist[i - 2].purchaseFasteners == true &&
                  joblist[i - 2].purchaseRawMaterial == true &&
                  joblist[i - 2].purchaseBroughtItems == true &&
                  joblist[i - 2].purchaseElectricalItems == true)
              ? 'true'
              : 'false');
      worksheet
          .getRangeByName('I$i')
          .setText('${joblist[i - 2].productionLathe}');
      worksheet
          .getRangeByName('J$i')
          .setText('${joblist[i - 2].productionFabrication}');
      worksheet.getRangeByName('K$i').setText('${joblist[i - 2].area}');
      worksheet
          .getRangeByName('L$i')
          .setText('${format.format(joblist[i - 2]!.targetDate!)}');
      worksheet.getRangeByName('M$i').setText('${joblist[i - 2].remarks}');
    }

    worksheet.getRangeByName('A1:M1').cellStyle.backColor = '#f0f4c3';

    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();

    if (Platform.isAndroid) {
      final directory = await getExternalStorageDirectory();

// Get directory path
      final path = directory?.path;

// Create an empty file to write Excel data
      File file = File('$path/pendingJobs.xlsx');
      filePath = file.path;

// Write Excel data
      await file.writeAsBytes(bytes, flush: true);
      // sendMail(file.path);

      excel = file;

// Open the Excel document in mobile
//
    }
    // if (kIsWeb) {
    //   html.AnchorElement(
    //       href:
    //           "data:application/octet-stream;charset=utf-16le;base64,${base64.encode(bytes)}")
    //     ..setAttribute("download", "Joblist.xlsx")
    //     ..click();
    // }
    // {
    //   final String path = (await getApplicationSupportDirectory()).path;
    //   final String fileName = '$path/Joblist.xlsx';
    //   final File file = File(fileName);
    //   await file.writeAsBytes(bytes, flush: true);
    // }
  }
}

Future<void> isInstalled() async {
  final val = await WhatsappShare.isInstalled(package: Package.whatsapp);
  // print('Whatsapp Business is installed: $val');
}

class _JobListState extends State<JobList> {
  QueryFormController controller = QueryFormController();

  @override
  void initState() {
    super.initState();
    if (kIsWeb == false) {
      FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
              alert: true, sound: true)
          .then((value) {
        FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                  message.notification?.title ?? 'Notification Received.')));
        });
      });
      FirebaseMessaging.onMessageOpenedApp.listen((event) {
        var reference = event.data['reference'];
        if (reference != null) {
          FirebaseFirestore.instance.doc(reference).get().then((value) {
            var job = Job.fromJson(value.data()!);
            Get.to(() => JobForm(job: job));
          });
        }
        // print(event.data);
      });
    }
  }

  // @override
  // void didChangeDependencies() {
  //   Future.delayed(const Duration(seconds: 1)).then((value) {
  //     _showMyDialog();
  //   });
  //   super.didChangeDependencies();
  // }

  bool isOpen = false;
  final ScrollController _scrollController = ScrollController();

  getDrawer() {
    return Drawer(
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.maxFinite,
                  child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          controller.clear();
                        });
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 15.0),
                        child: Text('Clear'),
                      )),
                ),
              ),
              CheckboxListTile(
                  title: const Text("Priority Jobs only"),
                  value: controller.priorityJobsOnly,
                  onChanged: (val) {
                    setState(() {
                      controller.priorityJobsOnly =
                          val ?? controller.priorityJobsOnly;
                    });
                  }),
              CustomDropdown<String>(
                  title: 'Zone',
                  onChanged: (String? val) {
                    setState(() {
                      controller.zone = val;
                      // print('Zone is ${controller.zone}');
                    });
                  },
                  items: [
                    'Kolkata/Odisha',
                    'Andhra/Telungana',
                    'Tamilnadu',
                    'Kerala/Karnataka',
                    "ABROAD/OTHERS",
                    'ALL'
                  ]
                      .map((e) => DropdownMenuItem(
                            child: Text(e.toUpperCase()),
                            value: e == 'ALL' ? null : e,
                          ))
                      .toList(),
                  value: controller.zone),
              CustomDropdown<int>(
                title: 'Year',
                onChanged: (int? val) {
                  controller.year = val;

                  setState(() {});
                },
                items: controller.years,
                value: controller.year,
              ),
              CustomDropdown<String>(
                title: 'SITE Location',
                onChanged: (String? val) {
                  controller.area = val;
                  setState(() {});
                },
                items: [
                  'SIPCOT',
                  'KORAMPALLAM',
                  'KOLKATA',
                  'KAKINADA',
                  'CHENNAI',
                  "ON-SITE",
                  "ALL"
                ]
                    .map((e) => DropdownMenuItem(
                          child: Text(e.toUpperCase()),
                          value: e == 'ALL' ? null : e,
                        ))
                    .toList(),
                value: controller.area,
              ),
              CustomDropdown<int>(
                title: 'Priority',
                onChanged: (int? val) {
                  controller.priority = val;

                  setState(() {});
                },
                items: controller.prioritys,
                value: controller.priority,
              ),
              CustomDropdown<bool>(
                  title: 'DESIGN Status',
                  onChanged: (bool? val) {
                    controller.design = val;
                    setState(() {});
                  },
                  items: controller.statusItems,
                  value: controller.design),
              CustomDropdown<bool>(
                title: 'PURCHASE Status',
                onChanged: (bool? val) {
                  setState(() {
                    controller.purchaseStatus = val;
                  });
                },
                items: controller.statusItems,
                value: controller.purchaseStatus,
              ),
              CustomDropdown<bool>(
                title: 'PRODUCTION LATHE',
                onChanged: (bool? val) {
                  setState(() {
                    controller.productionLathe = val;
                  });
                },
                items: controller.statusItems,
                value: controller.productionLathe,
              ),
              CustomDropdown<bool>(
                title: 'PRODUCTION FABRICATION',
                onChanged: (bool? val) {
                  controller.productionFabrication = val;
                  setState(() {});
                },
                items: controller.statusItems,
                value: controller.productionFabrication,
              ),
              CustomDropdown<bool>(
                title: 'PRODUCTION ASSEMBLY',
                onChanged: (bool? val) {
                  controller.productionAssembly = val;
                  setState(() {});
                },
                items: controller.statusItems,
                value: controller.productionAssembly,
              ),
              CustomDropdown<bool>(
                title: 'RAW-MATERIALS PURCHASE',
                onChanged: (bool? val) {
                  controller.purchaseRawMaterial = val;
                  setState(() {});
                },
                items: controller.statusItems,
                value: controller.purchaseRawMaterial,
              ),
              CustomDropdown<bool>(
                title: 'BOUGHT-OUT ITEMS',
                onChanged: (bool? val) {
                  controller.purchaseBroughtItems = val;
                  setState(() {});
                },
                items: controller.statusItems,
                value: controller.purchaseBroughtItems,
              ),
              CustomDropdown<bool>(
                title: 'ELECTRICAL ITEMS',
                onChanged: (bool? val) {
                  controller.purchaseElectricalItems = val;
                  setState(() {});
                },
                items: controller.statusItems,
                value: controller.purchaseElectricalItems,
              ),
              CustomDropdown<bool>(
                title: 'FASTNERS',
                onChanged: (bool? val) {
                  controller.purchaseFasteners = val;
                  setState(() {});
                },
                items: controller.statusItems,
                value: controller.purchaseFasteners,
              ),
              const SizedBox(
                height: 60,
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<String> searchList = [];
  List<String> descriptionSearch = [];
  List<String> customerSearch = [];
  @override
  Widget build(BuildContext context) {
    if (auth.sales || auth.admin) {
      // print("object");
    }

    return Scaffold(
      drawer: getDrawer(),
      appBar: AppBar(
        // centerTitle: true,
        title: const Text("JEYA ENGINEERING"),
        actions: [
          IconButton(
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const NewJobList())),
              icon: Icon(Icons.accessible_sharp)),
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Text(
              auth.currentUser?.displayName ?? '',
              style: const TextStyle(
                  color: Colors.lightGreenAccent,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          ),
          auth.admin
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const ProfileList()));
                      },
                      icon: const Icon(Icons.people)),
                )
              : const Text(''),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Do You Want To Logout?'),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  auth.signOut();
                                },
                                child: Text("Okay")),
                            TextButton(
                                onPressed: Navigator.of(context).pop,
                                child: Text("Cancel"))
                          ],
                        );
                      });
                },
                icon: const Icon(Icons.logout)),
          ),
        ],
      ),
      body: SizedBox(
        height: isOpen == true ? getHeight(context) : getHeight(context) * 1.15,
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: controller.query.snapshots(),
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            List<Job> joblist = [];

            if (snapshot.hasError) {
              // print(snapshot.error.toString());
            }
            if (snapshot.connectionState == ConnectionState.active &&
                snapshot.hasData) {
              // print(snapshot.data?.docs.length);
              var docs = snapshot.data?.docs ?? [];
              // print(docs.length);
              try {
                joblist = docs.map((e) => Job.fromJson(e.data())).toList();
                // print(joblist[0].toJson());

                searchList =
                    joblist.map((e) => e.customer.toLowerCase()).toList() +
                        joblist.map((e) => e.number.toLowerCase()).toList() +
                        joblist.map((e) => e.description).toList();

                descriptionSearch = joblist.map((e) => e.description).toList();
                customerSearch = joblist.map((e) => e.customer).toList();

                if (controller.priorityJobsOnly) {
                  joblist = joblist
                      .where((element) => element.priority != 0)
                      .toList()
                      .reversed
                      .toList();
                  joblist.sort((a, b) => a.priority!.compareTo(b.priority!));
                }

                if ((auth.admin || auth.sales) && isFirsttime) {
                  Future.delayed(Duration.zero).then((value) {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text("Send Mail"),
                            content: const Text(
                                "Kindly ignore this, If you have already sent the mail"),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    isFirsttime = false;
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text("Ignore")),
                              TextButton(
                                  onPressed: () async {
                                    Future<String> jobs = Future(() => '');

                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            backgroundColor: Colors.transparent,
                                            content: FutureBuilder(
                                                future: jobs,
                                                builder: (BuildContext context,
                                                    AsyncSnapshot snapshot) {
                                                  if (snapshot.hasData) {
                                                    return Text('Mail sent');
                                                  } else if (snapshot
                                                      .hasError) {
                                                    return Icon(
                                                        Icons.error_outline);
                                                  } else {
                                                    return Center(
                                                        child: SizedBox(
                                                            height: Get.height *
                                                                0.05,
                                                            child:
                                                                CircularProgressIndicator()));
                                                  }
                                                }),
                                          );
                                        });

                                    jobs = JobList.createExcel(joblist)
                                        .then((value) => sendMail(excel!.path))
                                        .then((value) {
                                      isFirsttime = false;
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pop();
                                      return value.toString();
                                    });
                                    // Navigator.of(context).pop();
                                  },
                                  child: const Text("Okay")),
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text("Cancel")),
                            ],
                          );
                        });
                  });
                }
                // JobList.createExcel(joblist);
              } catch (e) {
                // print(e.toString());
                joblist = [];
              }
              var source = JobDataSource(joblist, context);
              return Listener(
                onPointerSignal: (event) {
                  if (event is PointerScrollEvent) {
                    final offset = event.scrollDelta.dy;
                    _scrollController.jumpTo(_scrollController.offset + offset);
                  }
                },
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                      minWidth: 1980,
                      maxWidth: (getWidth(context) < 1980
                          ? 1980
                          : getWidth(context))),
                  child: GetBuilder(
                      init: auth,
                      builder: (_) {
                        return customTable.PaginatedDataTable(
                          header: controller.queryValue == jobs
                              ? const Text(
                                  "JOB LIST",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )
                              : const Text(
                                  "ARCHIVED JOB LIST",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                          actions: [
                            Container(
                              padding: const EdgeInsets.only(top: 10),
                              height: 60,
                              width: 250,
                              child: Autocomplete<String>(
                                fieldViewBuilder: (BuildContext context,
                                    TextEditingController textEditingController,
                                    FocusNode focusNode,
                                    VoidCallback onFieldSubmitted) {
                                  return TextField(
                                    controller: textEditingController,
                                    decoration: const InputDecoration(
                                      labelText:
                                          'CustomerName/JobNumber/JobName',
                                      labelStyle: TextStyle(fontSize: 15),
                                      border: OutlineInputBorder(),
                                    ),
                                    focusNode: focusNode,
                                    onChanged: (String value) {},
                                  );
                                },
                                displayStringForOption: (String option) =>
                                    option,
                                optionsBuilder:
                                    (TextEditingValue textEditingValue) {
                                  if (textEditingValue.text == '') {
                                    return const Iterable<String>.empty();
                                  }
                                  return searchList.where((String option) {
                                    return option
                                        .contains(textEditingValue.text);
                                  });
                                },
                                onSelected: (String selection) {
                                  setState(() {
                                    // print('[${selection.toLowerCase()}]');

                                    if (descriptionSearch.contains(selection)) {
                                      // print('description');
                                      controller.searchController.text =
                                          selection + 'description';

                                      // print(selection + 'description');
                                    } else {
                                      controller.searchController.text =
                                          selection.toLowerCase();
                                    }
                                  });
                                },
                              ),
                            ),
                            ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.green),
                                ),
                                onPressed: () {
                                  setState(() {
                                    controller.clear();
                                  });
                                },
                                child: const Text('Clear')),
                            ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.green),
                                ),
                                onPressed: () {
                                  setState(() {
                                    controller.queryValue == jobs
                                        ? controller.queryValue = archivedJobs
                                        : controller.queryValue = jobs;
                                    isArchive = !isArchive;
                                  });
                                },
                                child: controller.queryValue == jobs
                                    ? Text('Archived Jobs')
                                    : Text('Jobs')),
                            ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.green),
                                ),
                                onPressed: () async {
                                  await JobList.createExcel(joblist);
                                  OpenFilex.open(
                                    excel!.path!,
                                  );
                                },
                                child: const Text('Export')),
                            auth.sales
                                ? ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.green),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const JobForm()));
                                    },
                                    child: const Text('Add'))
                                : const Text(''),
                            ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.green),
                                ),
                                onPressed: () async {
                                  Future<String> jobs = Future(() => '');

                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          backgroundColor: Colors.transparent,
                                          content: FutureBuilder(
                                              future: jobs,
                                              builder: (BuildContext context,
                                                  AsyncSnapshot snapshot) {
                                                if (snapshot.hasData) {
                                                  return Text('Mail sent');
                                                } else if (snapshot.hasError) {
                                                  return Icon(
                                                      Icons.error_outline);
                                                } else {
                                                  return Center(
                                                      child: SizedBox(
                                                          height:
                                                              Get.height * 0.05,
                                                          child:
                                                              CircularProgressIndicator()));
                                                }
                                              }),
                                        );
                                      });

                                  jobs = JobList.createExcel(joblist)
                                      .then((value) async {
                                    await sendMail(excel!.path!).then((value) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text('Mail sent')));

                                      return 'Mail Sent';
                                    });
                                    Navigator.of(context).pop();
                                    return 'Mail sent';
                                  });
                                },
                                child: const Text('Send Mail')),
                            IconButton(
                                onPressed: () async {
                                  await JobList.createExcel(joblist);
                                  await isInstalled();
                                  await WhatsappShare.shareFile(
                                      filePath: [filePath!],
                                      phone: '918940189013');
                                },
                                icon: Image.network(
                                    'https://cdn-icons-png.flaticon.com/512/1377/1377218.png'))
                          ],
                          showCheckboxColumn: true,
                          showFirstLastButtons: true,
                          rowsPerPage:
                              (getHeight(context) ~/ kMinInteractiveDimension) -
                                  5,
                          sortAscending: (controller.toDate != null ||
                              controller.fromDate != null),
                          sortColumnIndex: 3,
                          columnSpacing: 30,
                          columns: const [
                            DataColumn(
                                label: Center(
                                    child: Text(
                              'SINO',
                              textAlign: TextAlign.center,
                            ))),
                            DataColumn(
                                label: Center(
                                    widthFactor: 2, child: Text('JOB NO'))),
                            DataColumn(
                                label: Center(child: Text('Remaining\nDays'))),
                            DataColumn(label: Center(child: Text('Priority'))),

                            DataColumn(label: Text('CUST Name')),
                            DataColumn(
                                label: Text(
                              'JOB Name',
                            )),
                            DataColumn(label: Text('Qty')),
                            DataColumn(
                                label: Text(
                              'ISSUE\nDate',
                              textAlign: TextAlign.center,
                            )),
                            DataColumn(
                                label: Text(
                              'DESIGN\nStatus',
                              textAlign: TextAlign.center,
                            )),
                            DataColumn(
                                label: Text(
                              'PURCHASE\nStatus',
                              textAlign: TextAlign.center,
                            )),
                            DataColumn(
                                label: Text(
                              'STORE \n Status',
                              textAlign: TextAlign.center,
                            )),
                            DataColumn(
                                label: Text(
                              'PROD-LATH\nStatus',
                              textAlign: TextAlign.center,
                            )),
                            DataColumn(
                                label: Text(
                              'PROD\nFabrication',
                              textAlign: TextAlign.center,
                            )),

                            DataColumn(
                                label: Text(
                              'SITE\nLocation',
                              textAlign: TextAlign.center,
                            )),
                            DataColumn(
                                label: Text(
                              'TARGET\n  Date',
                              textAlign: TextAlign.center,
                            )),
                            // DataColumn(label: Text('Logs')),
                            DataColumn(label: Text('Remarks')),
                            DataColumn(label: Text('Archive')),
                          ],
                          source: source,
                        );
                      }),
                ),
              );
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}

class JobDataSource extends DataTableSource {
  final List<Job> quoteList;
  final BuildContext context;

  JobDataSource(this.quoteList, this.context);

  @override
  DataRow? getRow(int index) {
    assert(index >= 0);
    if (index >= quoteList.length) return null;
    final e = quoteList[index];
    return DataRow.byIndex(
      color: MaterialStateProperty.all((e.productionLathe == true &&
              e.productionFabrication == true &&
              e.productionAssembly == true &&
              e.purchaseStatus == true &&
              e.storeStatus == true &&
              e.purchaseStatus == true &&
              e.design)
          ? Colors.lightGreen.shade100
          : index % 2 == 0
              ? Colors.grey.shade100
              : Colors.white),
      index: index,
      cells: [
        DataCell(SizedBox(width: 50, child: Text('${index + 1}'))),
        DataCell(SizedBox(
          width: getWidth(context) * 0.10,
          child: Center(
            child: TextButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => JobForm(
                          job: e,
                        )));
              },
              child: Text(e.number),
            ),
          ),
        )),
        DataCell(SizedBox(
            width: 100,
            child: Text(
              // e.targetDate!.difference(DateTime.now()).inDays >= 0
              e.targetDate!.difference(DateTime.now()).inDays.toString(),
              // : '0',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  color: e.targetDate!.difference(DateTime.now()).inDays >= 7
                      ? Colors.green
                      : e.targetDate!.difference(DateTime.now()).inDays >= 4
                          ? Colors.orange
                          : Colors.red),
            ))),

        DataCell(customTooltip(
          message:
              '${e.number}, Remaning days-${e.targetDate!.difference(DateTime.now()).inDays.toString()}',
          child: SizedBox(
              width: getWidth(context) * 0.03,
              child: Center(child: Text(e.priority.toString()))),
        )),
        DataCell(customTooltip(
            child: SizedBox(
                width: getWidth(context) * 0.12, child: Text(e.customer)),
            message:
                '${e.number}, Remaning days-${e.targetDate!.difference(DateTime.now()).inDays.toString()}')),
        DataCell(SingleChildScrollView(
            child: customTooltip(
          message:
              '${e.number}, Remaning days-${e.targetDate!.difference(DateTime.now()).inDays.toString()}',
          child: SizedBox(
              width: getWidth(context) * 0.20, child: Text(e.description)),
        ))),
        DataCell(customTooltip(
          message:
              '${e.number}, Remaning days-${e.targetDate!.difference(DateTime.now()).inDays.toString()}',
          child: SizedBox(
              width: getWidth(context) * 0.05,
              child: Text(e.quantity.toString() + ' ' + e.unit)),
        )),
        DataCell(customTooltip(
          message:
              '${e.number}, Remaning days-${e.targetDate!.difference(DateTime.now()).inDays.toString()}',
          child: SizedBox(
              width: getWidth(context) * 0.08,
              child: Text(e.marketIsssuedDate == null
                  ? ''
                  : format.format(e.marketIsssuedDate!))),
        )),
        DataCell(GetBuilder(
            init: auth,
            builder: (_) {
              return auth.design
                  ? customTooltip(
                      message:
                          '${e.number}, Remaning days-${e.targetDate!.difference(DateTime.now()).inDays.toString()}',
                      child: SizedBox(
                        width: getWidth(context) * 0.02,
                        child: Switch(
                            value: e.design,
                            onChanged: (val) {
                              e.design = val;
                              e.update(nameCheck: false);
                            }),
                      ),
                    )
                  : customTooltip(
                      message:
                          '${e.number}, Remaning days-${e.targetDate!.difference(DateTime.now()).inDays.toString()}',
                      child: SizedBox(
                          width: getWidth(context) * 0.02,
                          child: getIcon(e.design)),
                    );
            })),
        DataCell(GetBuilder(
            init: auth,
            builder: (_) {
              return Center(
                child: customTooltip(
                  message:
                      '${e.number}, Remaning days-${e.targetDate!.difference(DateTime.now()).inDays.toString()}',
                  child: SizedBox(
                      width: getWidth(context) * 0.02,
                      child: getIcon(e.purchaseStatus == true)),
                ),
              );
            })),
        //store
        DataCell(GetBuilder(
            init: auth,
            builder: (_) {
              return customTooltip(
                message:
                    '${e.number}, Remaning days-${e.targetDate!.difference(DateTime.now()).inDays.toString()}',
                child: SizedBox(
                  width: getWidth(context) * 0.05,
                  child: (auth.store)
                      ? Switch(
                          value: e.storeStatus ?? false,
                          onChanged: (val) {
                            e.storeStatus = val;
                            e.update(nameCheck: false);
                          })
                      : getIcon(e.storeStatus ?? false),
                ),
              );
            })),
        DataCell(GetBuilder(
            init: auth,
            builder: (_) {
              return customTooltip(
                message:
                    '${e.number}, Remaning days-${e.targetDate!.difference(DateTime.now()).inDays.toString()}',
                child: SizedBox(
                  width: getWidth(context) * 0.05,
                  child: (auth.productionLathe)
                      ? Switch(
                          value: e.productionLathe ?? false,
                          onChanged: (val) {
                            e.productionLathe = val;
                            e.update(nameCheck: false);
                          })
                      : getIcon(e.productionLathe ?? false),
                ),
              );
            })),

        DataCell(GetBuilder(
            init: auth,
            builder: (_) {
              return customTooltip(
                message:
                    '${e.number}, Remaning days-${e.targetDate!.difference(DateTime.now()).inDays.toString()}',
                child: SizedBox(
                  width: getWidth(context) * 0.05,
                  child: (auth.productionFab)
                      ? Switch(
                          value: e.productionFabrication ?? false,
                          onChanged: (val) {
                            e.productionFabrication = val;
                            e.update(nameCheck: false);
                          })
                      : getIcon(e.productionFabrication ?? false),
                ),
              );
            })),

        DataCell(customTooltip(
          message:
              '${e.number}, Remaning days-${e.targetDate!.difference(DateTime.now()).inDays.toString()}',
          child: SizedBox(
              width: 120,
              child: Text(
                e.area,
                overflow: TextOverflow.ellipsis,
              )),
        )),
        DataCell(customTooltip(
          message:
              '${e.number}, Remaning days-${e.targetDate!.difference(DateTime.now()).inDays.toString()}',
          child: SizedBox(
              width: getWidth(context) * 0.08,
              child: Text(
                  e.targetDate == null ? '' : format.format(e.targetDate!))),
        )),

        DataCell(customTooltip(
            message:
                'Job ${e.number}, Remaning days-${e.targetDate!.difference(DateTime.now()).inDays.toString()}',
            child: SizedBox(
                width: getWidth(context) * 0.10, child: Text(e.remarks)))),
        DataCell((auth.sales || auth.admin) == true
            ? ElevatedButton(
                onPressed: auth.sales && isArchive == false
                    ? () {
                        archivedJobs
                            .add(e.toJson())
                            .then((value) => jobs.doc(e.docId).delete());
                      }
                    : () {
                        Job tempJob = e;

                        tempJob.add().then((value) {
                          archivedJobs.doc(e.docId).delete();
                        });
                      },
                child: Text((auth.admin ||
                            auth.ProductionAll ||
                            auth.sales ||
                            auth.design ||
                            auth.delivery ||
                            auth.productionFab ||
                            auth.productionFabassembly ||
                            auth.productionLathe ||
                            auth.finance ||
                            auth.purchase ||
                            auth.sales) &&
                        isArchive == false
                    ? 'Move to Archive'
                    : 'Move to jobs'),
              )
            : ElevatedButton(
                onPressed: null,
                child: Text((auth.admin ||
                            auth.ProductionAll ||
                            auth.sales ||
                            auth.design ||
                            auth.delivery ||
                            auth.productionFab ||
                            auth.productionFabassembly ||
                            auth.productionLathe ||
                            auth.finance ||
                            auth.purchase ||
                            auth.sales) &&
                        isArchive == false
                    ? 'Move to Archive'
                    : 'Move to jobs'),
              )),
      ],
    );
  }

  Icon getIcon(bool val) =>
      Icon(Icons.flag, color: val ? Colors.green : Colors.red);
  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => quoteList.length;

  @override
  int get selectedRowCount => 0;

  Tooltip customTooltip({required String message, required Widget child}) {
    return Tooltip(
      waitDuration: const Duration(seconds: 1),
      showDuration: const Duration(seconds: 1),
      textStyle: const TextStyle(
          fontWeight: FontWeight.normal, color: Colors.white, fontSize: 15),
      message: message,
      child: child,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: Colors.blue),
    );
  }
}
