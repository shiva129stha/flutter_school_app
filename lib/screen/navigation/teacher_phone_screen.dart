import 'package:flutter/material.dart';
import 'package:flutter_school_app/data/dataproviders/fetch_employee_data.dart';
import 'package:flutter_school_app/data/model/employee_model.dart';
import 'package:flutter_school_app/widgets/employee_list_widget.dart';
import 'package:flutter_school_app/widgets/search_widget.dart';

class TeacherPhoneScreen extends StatefulWidget {
  const TeacherPhoneScreen({super.key});

  @override
  State<TeacherPhoneScreen> createState() => _TeacherPhoneScreenState();
}

class _TeacherPhoneScreenState extends State<TeacherPhoneScreen> {
  TextEditingController? _searchController;
  String query = '';
  late List<Employee> employee;
  final _searchFocusNode = FocusNode();

  late List<Employee> employeeData;

  @override
  void initState() {
    employeeData = FetchDataApi.employeeList;
    _searchController = TextEditingController(text: '');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            employeeDashboardBody(),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: employeeBar(context),
            ),
            Positioned(
              top: 80,
              left: 16,
              right: 16,
              child: searchWidget(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget employeeBar(BuildContext context) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        color: Colors.blueAccent,
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(16),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.person, color: Colors.white, size: 28),
          const SizedBox(width: 10),
          Text(
            "Teacher Details",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  FutureBuilder<List<Employee>> employeeDashboardBody() {
    return FutureBuilder(
      future: FetchDataApi.loadAddresss(),
      builder: (context, AsyncSnapshot<List<Employee>> snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text(
              "Error fetching data",
              style: TextStyle(color: Colors.red),
            ),
          );
        }
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        return Padding(
          padding: const EdgeInsets.only(top: 140.0),
          child: dashboardBody(context, employeeData),
        );
      },
    );
  }

  Widget searchWidget(BuildContext context) {
    return Material(
      elevation: 3,
      borderRadius: BorderRadius.circular(16),
      child: SearchWidget(
        onChange: searchItems,
        text: query,
        isFocus: false,
        controller: _searchController,
        focusNode: _searchFocusNode,
        onChanged: null,
      ),
    );
  }

  void searchItems(String query) {
    final items = FetchDataApi.employeeList.where((item) {
      final titleLower = item.name!.toLowerCase();
      final searchLower = query.toLowerCase();
      return titleLower.contains(searchLower);
    }).toList();
    setState(() {
      this.query = query;
      employeeData = items;
    });
  }

  Widget dashboardBody(BuildContext context, List<Employee> employeeData) {
    return Scrollbar(
      thumbVisibility: true,
      thickness: 6,
      radius: const Radius.circular(10),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: employeeData.length,
        itemBuilder: (c, i) {
          employeeData.sort((a, b) => a.name!.compareTo(b.name!));
          return EmployeeListWidget(
            name: employeeData[i].name,
            phoneNo: employeeData[i].phone,
            email: employeeData[i].email,
            designation: employeeData[i].designation,
          );
        },
      ),
    );
  }
}
