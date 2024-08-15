import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_school_app/data/model/employee_model.dart';

class FetchDataApi {
  static final List<Employee> employeeList = [];

  static Future<String> loadAddressAsset() async {
    return await rootBundle.loadString("assets/json/employee.json");
  }

  static Future<List<Employee>> loadAddresss() async {
    employeeList.clear();
    final jsonAddress = await loadAddressAsset();
    final jsonResponse = jsonDecode(jsonAddress);
    for (Map<String, dynamic> i in jsonResponse) {
      employeeList.add(Employee.fromJson(i));
    }
    return employeeList;
  }
}
