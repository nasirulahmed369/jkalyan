import 'dart:convert';

import 'package:devbynasirulahmed/constants/api_url.dart';
import 'package:devbynasirulahmed/models/customer.dart';
import 'package:devbynasirulahmed/screen/passbook/passbook_customer.dart';
import 'package:devbynasirulahmed/widgets/search_customer.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class PassBook extends StatefulWidget {
  @override
  _PassBookState createState() => _PassBookState();
}

class _PassBookState extends State<PassBook> {
  TextEditingController _searchAc = TextEditingController();
  String query = '';

  Future<List<Customer>> getCustomerByAc() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final url = Uri.parse('$janaklyan/api/collector/search-ac-by-name');
    //'https://sanchay-new.herokuapp.com/api/collector/searchaccount');

    var body = jsonEncode({
      "name": query,
      "id": _prefs.getInt('collectorId'),
    });

    try {
      var res = await http.post(url,
          headers: {
            "Content-Type": "application/json",
            "Accept": "*/*",
            "Authorization": "Bearer ${_prefs.getString('token')}"
          },
          body: body);
      if (200 == res.statusCode) {
        print(res.body.toString());
        var parsed = jsonDecode(res.body).cast<Map<String, dynamic>>();

        return parsed.map<Customer>((json) => Customer.fromJson(json)).toList();
      }
      return List<Customer>.empty();
    } catch (e) {
      throw e;
    }
  }

  Future<List<Customer>> getCustomer() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final url = Uri.parse('$janaklyan/api/agents/customers');

    try {
      var res = await http.post(url,
          body: jsonEncode({
            "id": _prefs.getInt('collectorId'),
          }),
          headers: {
            "Content-Type": "application/json",
            "Accept": "*/*",
            "Authorization": "Bearer ${_prefs.getString('token')}"
          });
      if (200 == res.statusCode) {
        var parsed = jsonDecode(res.body).cast<Map<String, dynamic>>();

        return parsed.map<Customer>((json) => Customer.fromJson(json)).toList();
      }
      return List<Customer>.empty();
    } catch (e) {
      throw e;
    }
  }

  navigate(Customer? doc) {
    Navigator.push(
        context, MaterialPageRoute(builder: (_) => PassbookCustomer(doc)));
  }

  @override
  void initState() {
    _searchAc.addListener(() {
      //here you have the changes of your textfield
      print("value: ${_searchAc.text}");
      //use setState to rebuild the widget
      setState(() {
        query = _searchAc.text;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Account'),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20),
            child: TextField(
              controller: _searchAc,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                suffixIcon:
                    //query.text.trim().isNotEmpty?
                    IconButton(
                  onPressed: () {
                    _searchAc.clear();
                  },
                  icon: Icon(Icons.clear),
                ),
                //: null,
                hintText: 'Enter a customer name',
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.black,
                    //Color(0xff016b1d),
                  ),
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          SearchCustomer(
              getCustomerByAc, getCustomer, _searchAc.text, navigate),
        ],
      ),
    );
  }
}
