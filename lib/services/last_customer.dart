import 'dart:convert';
import 'package:devbynasirulahmed/models/api_response.dart';
import 'package:http/http.dart' as http;
import 'package:devbynasirulahmed/models/customer.dart';

class LastCustomerAddedService {
  Uri url = Uri.parse("https://sanchay-new.herokuapp.com/api/agents/account");
  static const headers = {"Accept": "application/json"};
  Future<ApiResponse<Customer>> getLastCustomer() async {
    var res = await http.get(url, headers: {"Accept": "application/json"});

    try {
      if (200 == res.statusCode) {
        var customerMap = jsonDecode(res.body);
        Customer customer = Customer.fromJson(customerMap[0]);

        return ApiResponse<Customer>(
          data: customer,
        );
      } else {
        return ApiResponse<Customer>(
          err: true,
          errorMsg: 'An Error occured',
        );
      }
    } catch (e) {
      return ApiResponse<Customer>(
        err: true,
        errorMsg: 'An Error occured',
      );
    }
  }
}