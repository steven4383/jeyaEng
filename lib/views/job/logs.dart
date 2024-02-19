import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jeya_engineering/models/job.dart';


class LogsPage extends StatefulWidget {
  const LogsPage({Key? key, required this.currentjob}) : super(key: key);
  
  
  final Job currentjob;

  @override
  State<LogsPage> createState() => _LogsPageState();
}

class _LogsPageState extends State<LogsPage> {
  @override
  Widget build(BuildContext context) {
    Future<QuerySnapshot<Object?>> logsref= widget.currentjob.logs.get();
    return Scaffold(
      
      appBar: AppBar(title: Text('Logs Of ${widget.currentjob.number}'),centerTitle: true,),
      
      
      body: StreamBuilder<QuerySnapshot<Object?>>(
          stream: widget.currentjob.logs.snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
            List<QueryDocumentSnapshot<Object?>>? data= snapshot.data?.docs ;

            // print(data?.docs.first.toString());
            // print(data![0]['changedBy']);
            if (snapshot.hasData) {
              return ListView.builder(itemCount: data!.isNotEmpty?data.length:0, itemBuilder: (BuildContext context, int index1) {


                List < dynamic>logs=data![index1]['logs'];
                ;
                Timestamp date1=data![index1]['date'];
                print(date1 );
                DateTime date2 = date1.toDate();

                return Card(
                  elevation: 5,
                  child: ExpansionTile(
                    onExpansionChanged: (value){
                      setState(() {

                      });
                    },


                    leading: SizedBox(child:Text('${index1+1}')),
                    title: Text('      ${data[index1]['changedBy']}'),
               trailing: Text(' Date ${date2.day}-${date2.month}-${date2.year} \n Hours:${date2.hour}:${date2.minute}'),
               children: [
                   SizedBox(
                     height: Get.height*0.10*logs.length,
                     child: ListView.builder(
                       physics: NeverScrollableScrollPhysics(),
                            itemCount: logs.isNotEmpty?logs.length:0,
                            itemBuilder: (BuildContext context, int index) {

                              return ListTile(
                                leading: SizedBox(),
                                title: Row(children: [
                                  SizedBox(
                                      width:Get.width*0.25,
                                      child: Text('      ${data![index1]['logs'][index]['entry']}',style: TextStyle(color: Colors.green),)),
                                  // SizedBox(
                                  //     width:Get.width*0.25,
                                  //     child: Text('      ${data![index1]['logs'][index]['OldValue']??'Nodata'}',)),
                                  SizedBox(
                                      width:Get.width*0.25,child: Text('      ${data![index1]['logs'][index]['newValue']}',)),
                                ],)

                              );
                            },
                          ),
                   ),
                      ],
                  ),
                );
              },);

            } else if (snapshot.hasError) {
              return Icon(Icons.error_outline);
            } else {
              return CircularProgressIndicator();
            }
          }),
      
    );
  }
}
