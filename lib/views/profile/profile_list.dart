import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:jeya_engineering/Controllers/auth_controller.dart';
import 'package:jeya_engineering/enum.dart';
import 'package:jeya_engineering/firebase.dart';
import 'package:jeya_engineering/models/profile.dart';

import 'package:jeya_engineering/widgets/utilities.dart';
import 'package:cloud_functions/cloud_functions.dart';

import 'profileform.dart';

class ProfileList extends StatefulWidget {
  const ProfileList({Key? key}) : super(key: key);

  @override
  State<ProfileList> createState() => _ProfileListState();
}

class _ProfileListState extends State<ProfileList> {
  @override
  void initState() {
    filter();
    super.initState();
  }

  final searchController = TextEditingController();
  final fromDateController = TextEditingController();
  final toDateController = TextEditingController();
  DateTime? fromDate;
  DateTime? toDate;

  List<Profile> profilelist = [];

  late Query<Map<String, dynamic>> query;

  filter() {
    query = profiles;
    if (fromDate != null) {
      query = query.where('marketIsssuedDate', isGreaterThanOrEqualTo: fromDate);
    }
    if (toDate != null) {
      query = query.where('marketIsssuedDate', isLessThanOrEqualTo: toDate);
    }
    if (searchController.text.isNotEmpty) {
      var splits = searchController.text.toLowerCase().split(' ');
      int end = splits.length - 1;
      end = end < 5 ? end : 5;
      query = query.where('search', arrayContainsAny: end != 0 ? splits.sublist(0, end) : splits);
    }
    setState(() {});
  }

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Users List"),
        actions: [
          IconButton(

              onPressed: () {
                auth.signOut();
              },
              icon: const Icon(Icons.logout)),

        ],
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  return const Dialog(child: ProfileForm(
                    isEdit: false,
                  ));
                });
          },
          child: const Icon(Icons.add)),
      body: Listener(
        onPointerSignal: (event) {
          if (event is PointerScrollEvent) {
            final offset = event.scrollDelta.dy;
            _scrollController.jumpTo(_scrollController.offset + offset);
          }
        },
        child: SingleChildScrollView(
          child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: query.snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              if (snapshot.connectionState == ConnectionState.active && snapshot.hasData) {
                var docs = snapshot.data?.docs ?? [];

                try {
                  profilelist = docs.map((e) => Profile.fromJson(e.data())).toList();
                } catch (e) {
                  profilelist = [];
                }

                var source = ProfileDataSource(profilelist, context);
                var width = getWidth(context);

                return Theme(
                  data: Theme.of(context).copyWith(
                    cardTheme: const CardTheme(color: Colors.white),
                    cardColor: Colors.white,
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: width, minWidth: width),
                    child: PaginatedDataTable(
                      showCheckboxColumn: true,
                      showFirstLastButtons: true,
                      rowsPerPage: (MediaQuery.of(context).size.height ~/ kMinInteractiveDimension) - 5,
                      sortAscending: (toDate != null || fromDate != null),
                      sortColumnIndex: 3,
                      columnSpacing: 24,
                      columns: const [

                        DataColumn(label: Text('Name')),
                        DataColumn(label: Text('Email')),
                        DataColumn(label: Text('Phone Number')),
                        DataColumn(label: Text('Role')),
                        DataColumn(label: Text('')),
                        DataColumn(label: Text('')),
                      ],
                      source: source,
                    ),
                  ),
                );
              }
              if (snapshot.hasError) {
                if (kDebugMode) {
                  print(snapshot.error);
                }
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ),
      ),
    );
  }
}

class ProfileDataSource extends DataTableSource {
  final List<Profile> quoteList;
  final BuildContext context;

  ProfileDataSource(this.quoteList, this.context);

  @override
  DataRow? getRow(int index) {
    assert(index >= 0);
    if (index >= quoteList.length) return null;
    final e = quoteList[index];
    return DataRow.byIndex(
      color: MaterialStateProperty.all((e.role == Role.admin) ? Colors.lightGreen.shade100 : Colors.white),
      index: index,
      cells: [

        DataCell(Text(e.name)),
        DataCell(Text(e.email)),
        DataCell(Text(e.phone ?? '')),
        DataCell(Text(e.role.name)),
        DataCell(
          TextButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return Dialog(child: ProfileForm(
                      profile: e,
                      isEdit: true,
                    ));
                  });
            },
            child: const Text("Edit"),
          ),
        ),
        DataCell(TextButton(
          onPressed: () async {
            HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('deleteUser');
            try {
              var token = await auth.currentUser?.getIdToken();
              await callable.call({
                "token": token,
                "uid": e.uid.toString()





              }).then((value)  {

                profiles.doc(e.uid).delete().whenComplete(() => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${e.name } was deleted')))).catchError((err)=>ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err.toString()))));


                if (kDebugMode) {
                  print(value.data.toString());
                }
              }).catchError((error) {
                if (kDebugMode) {
                  print(error.toString());
                }
              });
            } catch (e) {
              if (kDebugMode) {
                print(e.toString());
              }
            };



          },
          child: const Text("Delete"),
        )),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => quoteList.length;

  @override
  int get selectedRowCount => 0;
}
