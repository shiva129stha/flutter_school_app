import 'package:flutter/material.dart';

class Club extends StatefulWidget {
  const Club({super.key});

  @override
  State<Club> createState() => _ClubState();
}

class _ClubState extends State<Club> {
  var arrClubName = [
    "Children Club",
    "ECO Club",
    'STEAM Club',
    'Aestronomy Club',
    'D.R.R Club',
    "Litrecher Club",
    'Kishwori Club',
  ];
  // var arrAvt = ["1", "2", "3", "4", "5", "6", "7"];
  var arrFocalTeacher = [
    "Focal Teacher: Samjhana Khatri/Madhabi Sapkota",
    "Focal Teacher: Madhabi Sapkota",
    "Focal Teacher: Rabina Maharjan/Anita Shahi",
    "Focal Teacher: Anita Shahi",
    "Focal Teacher: Machakaji Maharjan/Pooja Dangol",
    "Focal Teacher: Mallika Joshi Shrestha",
    "Focal Teacher: Santa Kumari Tripathi",
  ];
  var arrTotalMember = [
    """Total Member: '20'""",
    """Total Member: '12'""",
    """Total Member: '10'""",
    """Total Member: '9'""",
    """Total Member: '16'""",
    """Total Member: '7'""",
    """Total Member: '15'""",
  ];
  var arrImage = [
     "assets/images/child.jpg",
     "assets/images/eco.jpg",
     "assets/images/steam.jpg",
     "assets/images/aestronomy.JPG",
     "assets/images/drr.jpg",
     "assets/images/leterature.jpg",
     "assets/images/kishwori.jpg",
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        centerTitle: true,
        title: const Text(
          'Clubs',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: Scrollbar(
        thumbVisibility: true,
        thickness: 6,
        child: ListView.separated(
          itemBuilder: (context, index) {
            return ListTile(
              leading: Image.asset(arrImage[index]),
              title: Text(arrClubName[index]),
              subtitle: Text(arrFocalTeacher[index]),
              trailing: Text(
                arrTotalMember[index],
                style: const TextStyle(fontSize: 10),
              ),
            );
          },
          itemCount: arrClubName.length,
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
