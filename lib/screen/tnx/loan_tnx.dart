import 'dart:convert';
import 'package:devbynasirulahmed/constants/api_url.dart';
import 'package:devbynasirulahmed/models/loan_transaction.dart';
import 'package:devbynasirulahmed/models/transactions.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoanTransactionsView extends StatefulWidget {
  static const String id = 'LoanTransactionsView';
  @override
  _LoanTransactionsViewState createState() => _LoanTransactionsViewState();
}

class _LoanTransactionsViewState extends State<LoanTransactionsView> {
  Future<List<LoanTransactionsModel>> getTnx() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    Uri url = Uri.parse(
        "$janaklyan/api/collector/loan/transactions/${_prefs.getInt("collectorId")}");

    // var body = jsonEncode(<String, dynamic>{
    //   "id": _prefs.getInt('collectorId'),
    // });
    print(_prefs.getInt('collectorId').toString());
    print(_prefs.getString('token'));
    try {
      var res = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Accept': "*/*",
        "Authorization": "Bearer ${_prefs.getString('token')}",
      });
      if (200 == res.statusCode) {
        // return compute(parseTransactions, res.body);
        final parsed = jsonDecode(res.body).cast<Map<String, dynamic>>();

        return parsed
            .map<LoanTransactionsModel>(
                (json) => LoanTransactionsModel.fromJson(json))
            .toList();
      }

      return List<LoanTransactionsModel>.empty();
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Loan Transactions'),
      ),
      body: Builder(builder: (_) {
        return FutureBuilder<List<LoanTransactionsModel>>(
            future: getTnx(),
            builder: (__, snap) {
              if (snap.hasError)
                return Center(
                  child: Text(
                    snap.error.toString(),
                  ),
                );
              if (snap.hasData) {
                return ListView.builder(
                    itemCount: snap.data?.length,
                    itemBuilder: (___, indx) {
                      return customView(snap.data?[indx]);
                    });
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            });
      }),
    );
  }

  Widget customView(LoanTransactionsModel? doc) {
    //DateTime date = DateTime.parse(doc.date);
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Card(
        child: Container(
          color: Colors.grey[300],
          height: 130,
          width: MediaQuery.of(context).size.width - 20,
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  width: MediaQuery.of(context).size.width - 20,
                  height: 30,
                  color: Colors.red,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: Text(
                        'Tnx Id-${doc?.id}',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Expanded(
                child: Row(
                  //mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                                "Collector id : " + doc!.collector.toString(),
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Amount : " + doc.amount.toString(),
                                style: TextStyle(
                                  fontSize: 15,
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
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                //child: Text(name.toString())),
                                child: RichText(
                                  text: TextSpan(
                                    text: "A/c No : " +
                                        doc.loanAccountNumber.toString(),
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                //child: Text(name.toString())),
                                child: RichText(
                                  text: TextSpan(
                                    text: "Date : " +
                                        "${doc.createdAt?.split("T").first}",
                                    style: TextStyle(
                                      fontSize: 15,
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
              //SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
