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

class _TeacherPhoneScreenState extends State<TeacherPhoneScreen> with SingleTickerProviderStateMixin {
  TextEditingController? _searchController;
  String query = '';
  late List<Employee> employeeData;
  final _searchFocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController(); // Add ScrollController

  late AnimationController _animationController;
  late Animation<double> _searchAnimation;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: '');
    employeeData = FetchDataApi.employeeList;

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _searchAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchController?.dispose();
    _searchFocusNode.dispose();
    _scrollController.dispose(); // Dispose of ScrollController
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.deepPurple,
        title: AnimatedBuilder(
          animation: _searchAnimation,
          builder: (context, child) {
            return SizedBox(
              height: kToolbarHeight,
              child: _searchAnimation.value > 0
                  ? SizeTransition(
                      sizeFactor: _searchAnimation,
                      axis: Axis.horizontal,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: SearchWidget(
                          onChange: searchItems,
                          text: query,
                          isFocus: true,
                          controller: _searchController,
                          focusNode: _searchFocusNode,
                        ),
                      ),
                    )
                  : const Padding(
                    padding: EdgeInsets.only(top: 15.0),
                    child: Text(
                        'Teacher Details',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ),
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              _animationController.isDismissed
                  ? _animationController.forward()
                  : _animationController.reverse();
            },
          ),
        ],
      ),
      body: Container( margin: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white, // Background color of the list container
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3), // Shadow position
                ),
              ],
            ),
        child: SafeArea(
          child: SingleChildScrollView(
            // ignore: avoid_unnecessary_containers
            child: Container(
              child: Column(
                
                children: [
                  const SizedBox(
                    height: 10.0, // Adjust height as needed
                  ),
                  _employeeDashboardBody(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  FutureBuilder<List<Employee>> _employeeDashboardBody() {
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
        // ignore: avoid_unnecessary_containers
        return Container(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: _dashboardBody(context, employeeData),
          ),
        );
      },
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

  Widget _dashboardBody(BuildContext context, List<Employee> employeeData) {
    return Scrollbar(
      thumbVisibility: true,
      thickness: 8,
      radius: const Radius.circular(10),
      controller: _scrollController, // Provide ScrollController
      child: ListView.builder(
        controller: _scrollController, // Provide ScrollController
        shrinkWrap: true, // Ensures that the ListView is as small as its children
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        itemCount: employeeData.length,
        itemBuilder: (context, index) {
          employeeData.sort((a, b) => a.name!.compareTo(b.name!));
          return EmployeeListWidget(
            name: employeeData[index].name,
            phoneNo: employeeData[index].phone,
            email: employeeData[index].email,
            designation: employeeData[index].designation,
          );
        },
      ),
    );
  }
}
