import 'package:flutter/material.dart';

class AboutSchool extends StatelessWidget {
  const AboutSchool({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("About School"),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Row(
                  children: [
                    SizedBox(
                        height: 120,
                        width: 120,
                        child: Image.asset('assets/images/image1.png')),
                    Expanded(
                      child: SizedBox(
                        height: 100,
                        width: double.maxFinite,
                        child: Column(
                          children: [
                            RichText(
                              softWrap: true,
                              text: const TextSpan(
                                text:
                                    "Shree Saraswati Niketan Secondary School",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const Text("Bramha tole-12, Kathmandu, Nepal"),
                            const Text(
                              "Tel: 01-5355489",
                              style: TextStyle(fontSize: 13),
                            ),
                            const Text(
                              "Email: snmvschool@gmail.com",
                              style: TextStyle(fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                const SizedBox(height: 20),
                Container(
                  height: 500,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.blue.shade100,
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          height: 300,
                          width: double.infinity,
                          child: Center(
                              child: Image.asset("assets/images/school.jpg")),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Text(
                            "OUR SCHOOL,",
                            style: TextStyle(
                                fontSize: 19,
                                color: Colors.brown,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(right: 8, left: 8),
                        child: Text(
                          """  stands with 75 years of glorious history with experienced teachers and excellent outcomes through various methodes likestudent based teaching pedology and child friendly enviroment.""",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.brown,
                            fontStyle: FontStyle.normal,
                          ),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  height: 355,
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                      color: Colors.blue.shade100,
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Container(
                                height: 100,
                                width: 100,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.blue,
                                    width: 4.0,
                                  ),
                                ),
                                child: const Center(
                                  child: CircleAvatar(
                                    radius: 40,
                                    backgroundImage: AssetImage(
                                        "assets/images/principal.jpg"),
                                  ),
                                ),
                              ),
                            ),
                            const Expanded(
                              flex: 3,
                              child: Padding(
                                padding: EdgeInsets.only(left: 28.0),
                                child: SizedBox(
                                  height: 100,
                                  width: double.maxFinite,
                                  child: Center(
                                      child: Text(
                                    "What Principal/Ms. Maharjan says..",
                                    style: TextStyle(
                                        fontSize: 19,
                                        fontWeight: FontWeight.bold),
                                  )),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 234,
                            width: double.maxFinite,
                            decoration: const BoxDecoration(),
                            child: const Text(
                              """produced quite a big number of graduates who are serving the nation in one and other ways. In the changing scenario Saraswati Niketan Secondary School is trying to inculcate the 21 century skills in students in order to enable them to compete globally. Today, we are offering Computer Engineering courses of school level technical stream program from grade 9 to 12 funded by Kathmandu Metropolitan City. With qualified teaching faculties and well equipped laboratories, it is providing ample opportunities to make them competent and technically skilled to flourish in the future job market.""",
                              style: TextStyle(fontSize: 18),
                              textAlign: TextAlign.justify,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
