import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jeya_engineering/Controllers/auth_controller.dart';
import 'package:jeya_engineering/firebase.dart';
import 'package:jeya_engineering/mailer.dart';
import 'package:jeya_engineering/main.dart';
import 'package:jeya_engineering/models/job.dart';
import 'package:jeya_engineering/views/job/job_form.dart';
import 'package:jeya_engineering/views/job/job_list.dart';
import 'package:jeya_engineering/views/job/utilitiees/query_controller.dart';
import 'package:jeya_engineering/views/job/utilitiees/structure.dart';
import 'package:jeya_engineering/views/profile/profile_list.dart';
import 'package:jeya_engineering/widgets/date_picker.dart';
import 'package:jeya_engineering/widgets/drop_down.dart';
import 'package:jeya_engineering/widgets/utilities.dart';
import 'package:open_filex/open_filex.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:whatsapp_share2/whatsapp_share2.dart';

class NewJobList extends StatefulWidget {
  const NewJobList({Key? key}) : super(key: key);

  @override
  State<NewJobList> createState() => _NewJobListState();
}

class _NewJobListState extends State<NewJobList> {
  QueryFormController controller = QueryFormController();
  BuildContext? plutoBuildContext;
  bool isArchive = false;
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

  bool search = false;

  List<PlutoRow> rows = [];
  List<Job> joblists = [];

//Convert JobList To Pluto Data Grid
  convertJobListToPluto(List<Job> jobList) {
    rows = jobList.map((data) {
      PlutoCell cellSiNo = PlutoCell();
      PlutoCell jobNo = PlutoCell(value: data.number);
      PlutoCell cell = PlutoCell(value: data);

      PlutoCell cell1 = PlutoCell(
          value: data.targetDate!.difference(DateTime.now()).inDays.toString());
      PlutoCell cell3 = PlutoCell(value: data.priority);
      PlutoCell cell4 = PlutoCell(value: data.customer.toString());
      PlutoCell cell5 = PlutoCell(value: data.description.toString());
      PlutoCell cell6 = PlutoCell(
          value: data.quantity.toString() + '' + data.unit.toString());
      PlutoCell cell7 = PlutoCell(
          value: data.marketIsssuedDate == null
              ? ''
              : format.format(data.marketIsssuedDate!));

      PlutoCell cell8 = PlutoCell(value: data);
      PlutoCell cell9 = PlutoCell(value: data);
      PlutoCell cell10 = PlutoCell(value: data);
      PlutoCell cell11 = PlutoCell(value: data);
      PlutoCell cell12 = PlutoCell(value: data);
      PlutoCell cell13 = PlutoCell(value: data.area);
      PlutoCell cell14 = PlutoCell(
          value:
              data.targetDate == null ? '' : format.format(data.targetDate!));
      PlutoCell cell15 = PlutoCell(value: data.remarks);
      PlutoCell cell16 = PlutoCell(value: data);

      return PlutoRow(cells: {
        'SINO': cellSiNo,
        'JOB NO': jobNo,
        'Edit Job': cell,
        'Remaining Days': cell1,
        'Priority': cell3,
        'CUST Name': cell4,
        'JOB Name': cell5,
        'Qty': cell6,
        'ISSUE Date': cell7,
        'DESIGN Status': cell8,
        'PURCHASE Status': cell9,
        'STORE Status': cell10,
        'PROD-LATH Status': cell11,
        'PROD Fabrication': cell12,
        'SITE Location': cell13,
        'TARGET Date': cell14,
        'Remarks': cell15,
        'Archive': cell16
      });
    }).toList();
  }

  int rowIndex = 0;
  @override
  Widget build(BuildContext context) {
    //PlutoColumn
    final List<PlutoColumn> columns = <PlutoColumn>[
      PlutoColumn(
        enableFilterMenuItem: false,
        width: 100,
        enableColumnDrag: false,
        enableSorting: false,
        title: 'SINO',
        field: 'SINO',
        enableContextMenu: false,
        titleTextAlign: PlutoColumnTextAlign.center,
        // frozen: PlutoColumnFrozen.start,
        readOnly: true,
        type: PlutoColumnType.text(),
        renderer: (rendererContext) {
          int rowIndex = rendererContext.rowIdx + 1;

          return Center(child: Text('$rowIndex'));
        },
      ),
      PlutoColumn(
        sort: PlutoColumnSort.descending,
        enableColumnDrag: false,
        readOnly: true,
        titleTextAlign: PlutoColumnTextAlign.center,
        // frozen: PlutoColumnFrozen.start,
        title: 'JOB NO',
        field: 'JOB NO',
        type: PlutoColumnType.text(),
        renderer: (rendererContext) {
          return Center(
            child: Text(
              rendererContext.cell.value,
              style: const TextStyle(
                  color: Colors.blue, fontWeight: FontWeight.bold),
            ),
          );
        },
      ),
      PlutoColumn(
        enableFilterMenuItem: false,
        enableColumnDrag: false,
        width: 110,
        readOnly: true,
        enableContextMenu: false,
        titleTextAlign: PlutoColumnTextAlign.center,
        // frozen: PlutoColumnFrozen.start,
        title: 'Edit Job',
        field: 'Edit Job',
        type: PlutoColumnType.text(),
        renderer: ((rendererContext) {
          return TextButton(
            // job: rendererContext.cell.value as Job,
            onPressed: () {
              if (plutoBuildContext != null) {
                Navigator.of(plutoBuildContext!).push(MaterialPageRoute(
                    builder: (context) => JobForm(
                          job: rendererContext.cell.value as Job,
                        )));
              }
            },
            child: const Text('Edit Job'),
          );
        }),
      ),
      PlutoColumn(
          enableColumnDrag: false,
          width: 160,
          readOnly: true,
          titleTextAlign: PlutoColumnTextAlign.center,

          // frozen: PlutoColumnFrozen.start,
          title: 'Remaining Days',
          field: 'Remaining Days',
          type: PlutoColumnType.number(),
          renderer: (renderContex) {
            return Center(
              child: Text(
                renderContex.cell.value.toString(),
                style: TextStyle(
                    color: renderContex.cell.value >= 7
                        ? Colors.green
                        : renderContex.cell.value >= 4
                            ? Colors.orange
                            : Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 30),
              ),
            );
          }),
      PlutoColumn(
        width: 120,
        readOnly: true,
        titleTextAlign: PlutoColumnTextAlign.center,
        title: 'Priority',
        field: 'Priority',
        type: PlutoColumnType.number(),
        renderer: (rendererContext) {
          return Center(child: Text('${rendererContext.cell.value}'));
        },
      ),
      PlutoColumn(
        readOnly: true,
        titleTextAlign: PlutoColumnTextAlign.center,
        title: 'CUST Name',
        field: 'CUST Name',
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        width: 250,
        readOnly: true,
        titleTextAlign: PlutoColumnTextAlign.center,
        title: 'JOB Name',
        field: 'JOB Name',
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        titleTextAlign: PlutoColumnTextAlign.center,
        readOnly: true,
        title: 'Qty',
        field: 'Qty',
        type: PlutoColumnType.text(),
        renderer: (rendererContext) {
          return Center(
            child: Text(rendererContext.cell.value),
          );
        },
      ),
      PlutoColumn(
        titleTextAlign: PlutoColumnTextAlign.center,
        readOnly: true,
        title: 'ISSUE Date',
        field: 'ISSUE Date',
        type: PlutoColumnType.text(),
        renderer: (rendererContext) =>
            Center(child: Text(rendererContext.cell.value)),
      ),
      PlutoColumn(
          enableFilterMenuItem: false,
          titleTextAlign: PlutoColumnTextAlign.center,
          readOnly: true,
          width: 160,
          enableContextMenu: false,
          title: 'DESIGN Status',
          field: 'DESIGN Status',
          type: PlutoColumnType.text(),
          renderer: (rendererContext) => DesignStatus(
                job: rendererContext.cell.value as Job,
              )),
      PlutoColumn(
          enableFilterMenuItem: false,
          titleTextAlign: PlutoColumnTextAlign.center,
          readOnly: true,
          width: 160,
          enableContextMenu: false,
          title: 'PURCHASE Status',
          field: 'PURCHASE Status',
          type: PlutoColumnType.text(),
          renderer: (rendererContext) =>
              PurchaseStatus(job: rendererContext.cell.value as Job)),
      PlutoColumn(
          enableFilterMenuItem: false,
          titleTextAlign: PlutoColumnTextAlign.center,
          readOnly: true,
          width: 160,
          enableContextMenu: false,
          title: 'STORE Status',
          field: 'STORE Status',
          type: PlutoColumnType.text(),
          renderer: (rendererContext) =>
              StoreStatus(job: rendererContext.cell.value as Job)),
      PlutoColumn(
          enableFilterMenuItem: false,
          titleTextAlign: PlutoColumnTextAlign.center,
          readOnly: true,
          width: 160,
          enableContextMenu: false,
          title: 'PROD-LATH Status',
          field: 'PROD-LATH Status',
          type: PlutoColumnType.text(),
          renderer: (rendererContext) =>
              ProductionLathe(job: rendererContext.cell.value as Job)),
      PlutoColumn(
          enableFilterMenuItem: false,
          titleTextAlign: PlutoColumnTextAlign.center,
          readOnly: true,
          width: 160,
          enableContextMenu: false,
          title: 'PROD Fabrication',
          field: 'PROD Fabrication',
          type: PlutoColumnType.text(),
          renderer: (rendererContext) =>
              ProductionFab(job: rendererContext.cell.value as Job)),
      PlutoColumn(
          titleTextAlign: PlutoColumnTextAlign.center,
          readOnly: true,
          width: 160,
          title: 'SITE Location',
          field: 'SITE Location',
          type: PlutoColumnType.text(),
          renderer: (rendererContext) =>
              Center(child: Text(rendererContext.cell.value))),
      PlutoColumn(
        titleTextAlign: PlutoColumnTextAlign.center,
        readOnly: true,
        title: 'TARGET Date',
        field: 'TARGET Date',
        type: PlutoColumnType.text(),
        renderer: (rendererContext) =>
            Center(child: Text(rendererContext.cell.value)),
      ),
      PlutoColumn(
        width: 300,
        titleTextAlign: PlutoColumnTextAlign.center,
        readOnly: true,
        title: 'Remarks',
        field: 'Remarks',
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
          cellPadding: const EdgeInsets.only(right: 20, left: 20),
          enableFilterMenuItem: false,
          titleTextAlign: PlutoColumnTextAlign.center,
          title: 'Archive',
          field: 'Archive',
          type: PlutoColumnType.text(),
          renderer: (rendererContext) => ArchiveButton(
                job: rendererContext.cell.value,
                isArchive: isArchive,
              )),
    ];
    if (auth.sales || auth.admin) {
      // print("object");
    }
    plutoBuildContext = context;
    return Scaffold(
      drawer: getDrawer(),
      appBar: AppBar(
        // centerTitle: true,
        title: const Text("JEYA ENGINEERING"),
        actions: [
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
                          title: const Text('Do You Want To Logout?'),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  auth.signOut();
                                },
                                child: const Text("Okay")),
                            TextButton(
                                onPressed: Navigator.of(context).pop,
                                child: const Text("Cancel"))
                          ],
                        );
                      });
                },
                icon: const Icon(Icons.logout)),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: controller.query.snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          List<Job> joblists = [];

          if (snapshot.hasError) {
            // print(snapshot.error.toString());
          }
          if (snapshot.connectionState == ConnectionState.active &&
              snapshot.hasData) {
            // print(snapshot.data?.docs.length);
            var docs = snapshot.data?.docs ?? [];
            // print(docs.length);

            try {
              joblists = docs.map((e) => Job.fromJson(e.data())).toList();
              // print(joblists);
              convertJobListToPluto(joblists);
              if (controller.priorityJobsOnly) {
                joblists = joblists
                    .where((element) => element.priority != 0)
                    .toList()
                    .reversed
                    .toList();
                joblists.sort((a, b) => a.priority!.compareTo(b.priority!));
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
                                                  return const Text(
                                                      'Mail sent');
                                                } else if (snapshot.hasError) {
                                                  return const Icon(
                                                      Icons.error_outline);
                                                } else {
                                                  return Center(
                                                      child: SizedBox(
                                                          height:
                                                              Get.height * 0.05,
                                                          child:
                                                              const CircularProgressIndicator()));
                                                }
                                              }),
                                        );
                                      });

                                  jobs = JobList.createExcel(joblists)
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
              joblists = [];
            }
//Data Table
            return PlutoGrid(

                // rowColorCallback: (rowColorContext) {
                //   if (rowColorContext.rowIdx % 2 == 0) {
                //     return Colors.grey.shade100;
                //   } else {
                //     return Colors.white;
                //   }
                // },

                onLoaded: (event) {
                  event.stateManager.setShowColumnFilter(true);
                },
                configuration: PlutoGridConfiguration(
                    style: PlutoGridStyleConfig(

                        // enableColumnBorderHorizontal: false,
                        // enableColumnBorderVertical: false,
                        enableCellBorderVertical: false,
                        oddRowColor: Colors.grey.shade100),
                    columnFilter: PlutoGridColumnFilterConfig(
                      filters: [
                        ...FilterHelper.defaultFilters,
                        ClassYouImplemented(),
                      ],
                      resolveDefaultColumnFilter: (column, resolver) {
                        if (column.field == 'text') {
                          return resolver<PlutoFilterTypeContains>()
                              as PlutoFilterType;
                        }

                        return resolver<PlutoFilterTypeContains>()
                            as PlutoFilterType;
                      },
                    )),
                createHeader: (stateManager) {
                  return SizedBox(
                    height: 70,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: controller.queryValue == jobs
                              ? const Text(
                                  "JOB LIST",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25),
                                )
                              : const Text(
                                  "ARCHIVED JOB LIST",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25),
                                ),
                        ),
                        const Spacer(),
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
                        const Padding(padding: EdgeInsets.only(right: 20)),
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
                                ? const Text('Archived Jobs')
                                : const Text('Jobs')),
                        const Padding(padding: EdgeInsets.only(right: 20)),
                        ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.green),
                            ),
                            onPressed: () async {
                              await JobList.createExcel(joblists);
                              OpenFilex.open(
                                excel!.path!,
                              );
                            },
                            child: const Text('Export')),
                        auth.sales
                            ? Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: ElevatedButton(
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
                                    child: const Text('Add')),
                              )
                            : const Text(''),
                        const Padding(padding: EdgeInsets.only(right: 20)),
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
                                              return const Text('Mail sent');
                                            } else if (snapshot.hasError) {
                                              return const Icon(
                                                  Icons.error_outline);
                                            } else {
                                              return Center(
                                                  child: SizedBox(
                                                      height: Get.height * 0.05,
                                                      child:
                                                          const CircularProgressIndicator()));
                                            }
                                          }),
                                    );
                                  });

                              jobs = JobList.createExcel(joblists)
                                  .then((value) async {
                                await sendMail(excel!.path!).then((value) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text('Mail sent')));

                                  return 'Mail Sent';
                                });
                                Navigator.of(context).pop();
                                return 'Mail sent';
                              });
                            },
                            child: const Text('Send Mail')),
                        const Padding(padding: EdgeInsets.only(right: 20)),
                        IconButton(
                            onPressed: () async {
                              await JobList.createExcel(joblists);
                              await isInstalled();
                              await WhatsappShare.shareFile(
                                  filePath: [filePath!], phone: '918940189013');
                            },
                            icon: Image.network(
                                'https://cdn-icons-png.flaticon.com/512/1377/1377218.png')),
                        const Padding(padding: EdgeInsets.only(right: 20)),
                      ],
                    ),
                  );
                },
                columns: columns,
                rows: rows);
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

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
}

class ClassYouImplemented implements PlutoFilterType {
  @override
  String get title => 'Custom contains';

  @override
  get compare => ({
        required String? base,
        required String? search,
        required PlutoColumn? column,
      }) {
        var keys = search!.split(',').map((e) => e.toUpperCase()).toList();

        return keys.contains(base!.toUpperCase());
      };

  const ClassYouImplemented();
}
