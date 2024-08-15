import 'package:flutter/material.dart';

class NumberOfStudents extends StatefulWidget {
  const NumberOfStudents({super.key});

  @override
  State<NumberOfStudents> createState() => _NumberOfStudentsState();
}

class _NumberOfStudentsState extends State<NumberOfStudents> {
  var arrClass = [
    'Nursery',
    'Nursery',
    'L.K.G',
    'L.K.G',
    'U.K.G',
    "Class 1",
    "Class 1",
    "Class 2",
    "Class 2",
    "Class 3",
    "Class 3",
    "Class 4",
    "Class 5",
    "Class 6",
    "Class 7",
    "Class 8",
    "Class 9",
    "Class 9",
    "Class 10",
    "Class 10",
  ];
  var arrAvt = [
    ''' N 'A' ''',
    ''' N 'B' ''',
    ''' L 'A' ''',
    ''' L 'B' ''',
    '''U''',
    ''' 1 'A' ''',
    ''' 1 'B' ''',
    ''' 2 'A' ''',
    ''' 2 'B' ''',
    ''' 3 'A' ''',
    ''' 3 'B' ''',
    "4",
    "5",
    "6",
    "7",
    "8",
 ''' 9 'G' ''',
 ''' 9 'CE' ''',
 ''' 10 'G' ''',
 ''' 10 'CE' ''',
  ];
  var arrNoStu = [
    '''No of Student: '28' ''',
    '''No of Student: '27' ''',
    '''No of Student: '19' ''',
    '''No of Student: '21' ''',
    '''No of Student: '30' ''',
    '''No of Student: '24' ''',
    '''No of Student: '23' ''',
    '''No of Student: '30' ''',
    '''No of Student: '29' ''',
    '''No of Student: '26' ''',
    '''No of Student: '27' ''',
    '''No of Student: '44' ''',
    '''No of Student: '51' ''',
    '''No of Student: '46' ''',
    '''No of Student: '48' ''',
    '''No of Student: '43' ''',
    '''No of Student: '24' ''',
    '''No of Student: '35' ''',
    '''No of Student: '21' ''',
    '''No of Student: '32' ''',
  ];
  var arrClassTeacher = [
    "Class Teacher: Rita Lama",
    "Class Teacher: Sujita Singh",
    "Class Teacher: Uma Thapa",
    "Class Teacher: Kalpana Koirala",
    "Class Teacher: Bimala Pandey",
    "Class Teacher: Rema Manandhar",
    "Class Teacher: Roshana Shakya",
    "Class Teacher: Hira Sina Maharjan",
    "Class Teacher: Kabitri Singh",
    "Class Teacher: Mani Raj Manandhar",
    "Class Teacher: Rashmi Maharjan",
    "Class Teacher: Pooja Dangol",
    "Class Teacher: Samjhana Khatri",
    "Class Teacher: Saraswati Shrestha",
    "Class Teacher: Meenu Gurung",
    "Class Teacher: Sushila Maharjan",
    "Class Teacher: Santoshi Thokar",
    "Class Teacher: Anita Shahi",
    "Class Teacher: Madhabi Sapkota",
    "Class Teacher: Mallika Joshi Shrestha",
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppBar(
        backgroundColor: Colors.red,
        centerTitle: true,
        title: const Text(
          'Classes',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: Scrollbar(
        thumbVisibility: true,
        thickness: 6,
        child: ListView.separated(
          itemBuilder: (context, index) {
            return ListTile(
              leading: CircleAvatar(
                radius: 24,
                backgroundColor: Colors.green,
                child: Text(
                  arrAvt[index].toUpperCase(),
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
              title: Text(arrClass[index]),
              subtitle: Text(arrClassTeacher[index]),
              trailing: Text(
                arrNoStu[index],
                style: const TextStyle(fontSize: 12, color: Colors.blueAccent),
              ),
              // subtitle: Text("${arrNumbers[index]}"),
            );
          },
          itemCount: arrClass.length,
          separatorBuilder: (context, index) {
            return const Divider(
              height: 20,
            );
          },
        ),
      ),
    );
  }
}
