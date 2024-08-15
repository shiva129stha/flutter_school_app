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
      body: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: Stack(
            children: [
              employeeDashboardBody(),
              employeeBar(context),
              searchWidget(context)
            ],
          ),
        ),
    );
  }

  Container employeeBar(BuildContext context) {
    return Container(
      height: 129,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.blue,
      ),
      child: const Padding(
        padding: EdgeInsets.only(
          top: 10,
          left: 16,
          right: 16,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Teacher Details",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            )
          ],
        ),
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
              ),
            );
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          return Padding(
            padding: const EdgeInsets.only(top: 128.0),
            child: dashboardBody(context, employeeData),
          );
        });
  }

  SizedBox searchWidget(BuildContext context) {
    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
        ),
        child: Column(
          children: [
            const SizedBox(
              height: 101,
            ),
            SizedBox(
              height: 49,
              child: Material(
                elevation: 2,
                color: Colors.white,
                borderRadius: const BorderRadius.all(
                  Radius.circular(16),
                ),
                child: SearchWidget(
                  onChange: searchItems,
                  text: query,
                  isFocus: false,
                  controller: _searchController,
                  focusNode: _searchFocusNode,
                  onChanged: null,
                ),
              ),
            )
          ],
        ),
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
      child: ListView.builder(
          itemCount: employeeData.length,
          itemBuilder: (c, i) {
            employeeData.sort((a, b) => a.name!.compareTo(b.name!));
            return EmployeeListWidget(
              name: employeeData[i].name,
              phoneNo: employeeData[i].phone,
              email: employeeData[i].email,
              designation: employeeData[i].designation,
            );
          }),
    );
  }
}





// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';
// // import 'package:flutter_school_app/widgets/employee_list_widget.dart';
// import 'package:flutter_school_app/widgets/employee_model.dart';

// class Screen2 extends StatefulWidget {
//   const Screen2({super.key});

//   @override
//   State<Screen2> createState() => _Screen2State();
// }

// class _Screen2State extends State<Screen2> {
//   Future<List<Employee>> getEmployee() async {
//     String data = await DefaultAssetBundle.of(context)
//         .loadString("assets/json/employee.json");
//     List mapData = jsonDecode(data);

//     List<Employee> employee =
//         mapData.map((employee) => Employee.fromJson(employee)).toList();

//     return employee;
//   }

//   @override
//   void initState() {
//     getEmployee();
//     super.initState();
//   }

//   Widget build(BuildContext context) {
//     return    FutureBuilder<List<Employee>>(
//       future: getEmployee(),
//       builder: (context, data) {
//         if (data.hasData) {
//           List<Employee> employees = data.data!;
//           return Container(
//             height: double.infinity,
//             width: double.infinity,
//             child: Stack(
//               children: [
//                 Scrollbar(
//                   thumbVisibility: true,
//                   thickness: 5,
//                   child: ListView.builder(
//                     itemCount: employees.length,
//                     itemBuilder: (context, index) {
//                       return Container(
//                         height: 80,
//                         decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(10),
//                             color: Colors.grey.shade300),
//                         margin: const EdgeInsets.symmetric(
//                             horizontal: 10, vertical: 5),
//                         padding: EdgeInsets.all(10),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             CircleAvatar(
//                               radius: 24,
//                               backgroundColor: Colors.green,
//                               child: Text(
//                                 employees[index]
//                                     .name!
//                                     .substring(0, 1)
//                                     .toUpperCase(),
//                                 style: TextStyle(
//                                     fontSize: 18, fontWeight: FontWeight.bold),
//                               ),
//                             ),
//                             SizedBox(
//                               width: 15,
//                             ),
//                             Expanded(
//                               child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     employees[index].name!,
//                                     style: TextStyle(
//                                         fontSize: 18, color: Colors.black),
//                                   ),
//                                   Text(
//                                     employees[index].designation!,
//                                     style: TextStyle(
//                                         fontSize: 18, color: Colors.grey),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             IconButton(
//                                 onPressed: () async {
//                                   await launch("tel:${employees[index].phone}");
//                                 },
//                                 icon: Icon(Icons.phone)),
//                             IconButton(
//                                 onPressed: () async {
//                                   await launch("tel:${employees[index].phone}");
//                                 },
//                                 icon: Icon(Icons.email)),
//                           ],
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           );
//         } else {
//           return Center(
//             child: CircularProgressIndicator(),
//           );
//         }
//       },
//     );

//   }
// }

// // import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
// //import 'package:url_launcher/url_launcher.dart';

// // class Screen2 extends StatefulWidget {
// //   const Screen2({super.key});

// //   @override
// //   State<Screen2> createState() => _Screen2State();
// // }

// // class _Screen2State extends State<Screen2> {
// //   var arrNames = [
// //     "Anish Maharjan",
// //     'Anita Shahi',
// //     'Bishnu Maya Mishra',
// //     'Devi Kumari Shrestha',
// //     'Dipak Shrestha',
// //     'Gyani Shrestha',
// //     'Hira Sina Maharjan',
// //     'HiraKaji Maharhan',
// //     'Kabitri Singh',
// //     'Kalpana Koirala',
// //     'Kirshna Laxmi Sukuvatu',
// //     'Machakaji Maharjan',
// //     'Madhabi Sapkota',
// //     'Mallika Jhosi Shrestha',
// //     'Manish Raj Manandhar',
// //     'Meenu Gurung',
// //     'Pooja Dangol',
// //     'Rabina Maharjan',
// //     'Rajat Upreti',
// //     'Rashmi Maharjan',
// //     'Rema Manandhar',
// //     'Rita Lama',
// //     'Roshana Shakya',
// //     'Samjhana Baskota',
// //     'Santa Kumari Tripathi',
// //     'Santoshi Thokar',
// //     'Saraswati Shrestha',
// //     'Shaily Shakya',
// //     'Shyam Prashad Chapagain',
// //     'Sujita Singh',
// //     'Sumitra Baskota',
// //     'Sunila Maharjan',
// //     'Suraj Dangol',
// //     'Sushila Maharjan',
// //     'Uma Thapa'
// //   ];
// //   var arrNumbers = [
// //     9851300541,
// //     9841022225,
// //     9841384022,
// //     9818892009,
// //     9860364529,
// //     9811755179,
// //     9841427681,
// //     9860300600,
// //     9818448675,
// //     9842100617,
// //     9823589328,
// //     9841340445,
// //     9845205974,
// //     9803840388,
// //     9841889928,
// //     9861490136,
// //     9841760903,
// //     9841455244,
// //     9860688864,
// //     9841079972,
// //     9841145537,
// //     9849934314,
// //     9849516595,
// //     9841680280,
// //     9841910818,
// //     9841721988,
// //     9849570974,
// //     9851133533,
// //     9841402829,
// //     9813475933,
// //     9841743329,
// //     9849136471,
// //     9851159122,
// //     9841237146,
// //     9841686221
// //   ];
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('Phone'),
// //         centerTitle: true,
// //       ),
// //       body: ListView.separated(
// //         itemBuilder: (context, index) {
// //           return ListTile(
// //             leading: Text("${index + 1}"),
// //             title: Text("${arrNames[index]}"),
// //             subtitle: Text("${arrNumbers[index]}"),
// //             trailing: TextButton(
// //               style: TextButton.styleFrom(
// //                 padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
// //                 shape: RoundedRectangleBorder(
// //                   side: BorderSide(color: Colors.blue),
// //                 ),
// //               ),
// //               child: Text("Call"),
// //               onPressed: () async {
// //                 await launch("tel:${arrNumbers[index]}");
// //               },
// //             ),
// //           );
// //         },
// //         itemCount: arrNames.length,
// //         separatorBuilder: (context, index) {
// //           return Divider(
// //             height: 20,
// //           );
// //         },
// //       ),
// //     );
// //   }
// // }// 
// : () async {
// //                 await launch("tel:${arrNumbers[index]}");
// //               },
// //             ),
// //           );
// //         },
// //         itemCount: arrNames.length,
// //         separatorBuilder: (context, index) {
// //           return Divider(
// //             height: 20,
// //           );
// //         },
// //       ),
// //     );
// //   }
// // }// 
// : () async {
// //                 await launch("tel:${arrNumbers[index]}");
// //               },
// //             ),
// //           );
// //         },
// //         itemCount: arrNames.length,
// //         separatorBuilder: (context, index) {
// //           return Divider(
// //             height: 20,
// //           );
// //         },
// //       ),
// //     );
// //   }
// // }// 
