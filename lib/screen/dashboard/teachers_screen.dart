import 'package:flutter/material.dart';

class Teachers extends StatefulWidget {
  const Teachers({super.key});

  @override
  State<Teachers> createState() => _TeachersState();
}

class _TeachersState extends State<Teachers> {
  var arrNames = [
    "Aakash Koirala",
    "Anish Maharjan",
    'Anita Shahi',
    'Bishnu Maya Mishra',
    'Hira Sina Maharjan',
    "Ishara Dhakal",
    'Kabitri Singh',
    'Kalpana Koirala',
    'Machakaji Maharjan',
    'Madhabi Sapkota',
    'Mallika Jhosi Shrestha',
    'Mani Raj Manandhar',
    'Meenu Gurung',
    'Pooja Dangol',
    'Rabina Maharjan',
    'Rajat Upreti',
    'Rashmi Maharjan',
    "Reja Thapa",
    'Rema Manandhar',
    'Rita Lama',
    'Roshana Shakya',
    'Samjhana Baskota',
    'Santa Kumari Tripathi',
    'Santoshi Thokar',
    'Saraswati Shrestha',
    'Shaily Shakya',
    'Shyam Prashad Chapagain',
    'Sujita Singh',
    'Sumitra Baskota',
    'Suraj Dangol',
    "Susan Adhikari",
    'Sushila Maharjan',
    "Sushmita Shrestha",
    'Uma Thapa'
  ];
  var arrImage = [
    "assets/images/teachers.anish1.png",
    "assets/images/teachers.anish1.png",
    "assets/images/teachers.anish1.png",
    "assets/images/teachers.anish1.png",
    "assets/images/teachers.anish1.png",
    "assets/images/teachers.anish1.png",
    "assets/images/teachers.anish1.png",
    "assets/images/teachers.anish1.png",
    "assets/images/teachers.anish1.png",
    "assets/images/teachers.anish1.png",
    "assets/images/teachers.anish1.png",
    "assets/images/teachers.anish1.png",
    "assets/images/teachers.anish1.png",
    "assets/images/teachers.anish1.png",
    "assets/images/teachers.anish1.png",
    "assets/images/teachers.anish1.png",
    "assets/images/teachers.anish1.png",
    "assets/images/teachers.anish1.png",
    "assets/images/teachers.anish1.png",
    "assets/images/teachers.anish1.png",
    "assets/images/teachers.anish1.png",
    "assets/images/teachers.anish1.png",
    "assets/images/teachers.anish1.png",
    "assets/images/teachers.anish1.png",
    "assets/images/teachers.anish1.png",
    "assets/images/teachers.anish1.png",
    "assets/images/teachers.anish1.png",
    "assets/images/teachers.anish1.png",
    "assets/images/teachers.anish1.png",
    "assets/images/teachers.anish1.png",
    "assets/images/teachers.anish1.png",
    "assets/images/teachers.anish1.png",
    "assets/images/teachers.anish1.png",
    "assets/images/teachers.anish1.png",
    // "assets/images/teachers/aakash.png",
    // "assets/images/teachers/anish.png",
    // "assets/images/teachers/anita.png",
    // "assets/images/teachers/bimala.png",
    // "assets/images/teachers/hirasina.png",
    // "assets/images/teachers/ishara.png",
    // "assets/images/teachers/kabitri.png",
    // "assets/images/teachers/kalpana.png",
    // "assets/images/teachers/machakaji.png",
    // "assets/images/teachers/madhavi.png",
    // "assets/images/teachers/mallika.png",
    // "assets/images/teachers/manish.png",
    // "assets/images/teachers/meenu.png",
    // "assets/images/teachers/puja.png",
    // "assets/images/teachers/rabina.png",
    // "assets/images/teachers/rajat.png",
    // "assets/images/teachers/rashmi.png",
    // "assets/images/teachers/rawol.png",
    // "assets/images/teachers/rema.png",
    // "assets/images/teachers/rita.png",
    // "assets/images/teachers/roshana.png",
    // "assets/images/teachers/samjhana.png",
    // "assets/images/teachers/santa.png",
    // "assets/images/teachers/santoshi.png",
    // "assets/images/teachers/saraswati.png",
    // "assets/images/teachers/shaily.png",
    // "assets/images/teachers/shyam.png",
    // "assets/images/teachers/sujita.png",
    // "assets/images/teachers/sumitra.png",
    // "assets/images/teachers/suraj.png",
    // "assets/images/teachers/susan.jpg",
    // "assets/images/teachers/sushila.jpeg",
    // "assets/images/teachers/sushila.jpeg",
    // "assets/images/teachers/uma.png",
  ];
  var arrDesignation = [
    'Lab Technician',
    'Ast.Instructor',
    'Teacher',
    'Teacher',
    'Teacher',
    'Instructor',
    'Teacher',
    'Teacher',
    'Second Co-ordinator',
    'Teacher',
    'Teacher',
    'Teacher',
    'Lower-Secondary Co-ordinator',
    'Primary Co-ordinator',
    'Principal',
    'Instructor',
    'Teacher',
    'Teacher',
    'Teacher',
    'Per-Primary Co-ordinator',
    'Teacher',
    'Teacher',
    'Teacher',
    'Teacher',
    'Teacher',
    'Teacher',
    'Teacher',
    'Teacher',
    'Teacher',
    'Teacher',
    'Instructor',
    'Teacher',
    'Teacher',
    'Teacher',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        centerTitle: true,
        title: const Text(
          'Teachers',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: Scrollbar(
        thumbVisibility: true,
        thickness: 6,
        child: ListView.separated(
          itemBuilder: (context, index) {
            return Container(
              height: 80,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey.shade300),
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                   CircleAvatar(
              radius: 24,
              backgroundColor: Colors.green,
              child: Text(
                arrNames[index].substring(0, 1).toUpperCase(),
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          arrNames[index],
                          style: const TextStyle(fontSize: 18, color: Colors.black),
                        ),
                        Text(
                          arrDesignation[index],
                          style: const TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
          itemCount: arrNames.length,
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
