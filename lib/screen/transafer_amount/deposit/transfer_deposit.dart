import 'package:devbynasirulahmed/models/deposit_tnx.dart';
import 'package:devbynasirulahmed/services/deposits_tnx/depost_tnx.services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:progress_indicators/progress_indicators.dart';

class TransferDeposit extends StatefulWidget {
  static const String id = 'TransferDeposit';
  @override
  _TransferDepositState createState() => _TransferDepositState();
}

class _TransferDepositState extends State<TransferDeposit> {
  // handlePress() async {
  //   showLoadingDialog(context);
  //   DateTime date = DateTime.now();
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? token = prefs.getString('token');
  //   int? id = prefs.getInt('collectorId');

  //   Uri url = Uri.parse("$janaklyan/api/collector/create/deposit/tnx");

  //   try {
  //     var res = await http.post(
  //       url,
  //       body: jsonEncode(<String, dynamic>{
  //         "collectorId": id,
  //         "date": "${date.year}-${date.month}-${date.day}",
  //       }),
  //       headers: {
  //         'Content-Type': 'application/json',
  //         "Authorization": "Bearer $token"
  //       },
  //     );

  //     if (200 == res.statusCode) {
  //       Navigator.pop(context);
  //       Fluttertoast.showToast(msg: 'Sent to manager');
  //     } else {
  //       Navigator.pop(context);
  //       showErrorDialog(context);
  //     }
  //   } catch (e) {}
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Deposit History"),
        backgroundColor: Colors.amber[800],
      ),
      body: Column(
        children: [
          Flexible(
            child: Card(
              color: Colors.grey[300],
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      width: 5,
                      color: Colors.grey.shade300,
                    ),
                  ),
                ),
                child: FutureBuilder<List<DepositTnxModel>>(
                  future: getDepositsTnx(),
                  builder: (_, snap) {
                    if (snap.hasError) {
                      return Center(
                        child: Text('Somthing Wrong'),
                      );
                    }
                    if (snap.hasData) {
                      return ListView.builder(
                        //controller: _scrollController,
                        //shrinkWrap: true,
                        itemCount: snap.data!.length,
                        itemBuilder: (_, i) {
                          return customViews(snap.data?[i]);
                        },
                      );
                    }
                    return Center(child: FadingText('Loading...'));
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget customViews(DepositTnxModel? doc) {
    const IconData check = IconData(0xe156, fontFamily: 'MaterialIcons');
    DateTime date = DateTime.parse(doc!.createdAt!);
    return Padding(
      padding: EdgeInsets.only(top: 10, left: 5, right: 5, bottom: 5),
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(children: [
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              width: MediaQuery.of(context).size.width - 20,
              height: 20,
              color: Colors.red,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: Text(
                    'Tnx Id- ${doc.id}',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 5),
          Expanded(
            child: Row(
              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Collector id : " + "${doc.collectorId}",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Amount : " + "${doc.amount}",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Flexible(
                  child: Container(
                    //color: Colors.amber,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Row(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                //child: Text(name.toString())),
                                child: RichText(
                                  text: TextSpan(
                                    text: doc.currentStatus == 0
                                        ? "Status: pending"
                                        : "Status: succes",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Container(
                                height: 15,
                                width: 15,
                                child: CircleAvatar(
                                  backgroundColor: doc.currentStatus == 0
                                      ? Colors.red
                                      : Colors.green,
                                  child: Icon(
                                    doc.currentStatus == 0
                                        ? Icons.watch_later
                                        : check,
                                    size: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            //child: Text(name.toString())),
                            child: RichText(
                              text: TextSpan(
                                text: "Date : " +
                                    "${date.day}-${date.month}-${date.year}",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
