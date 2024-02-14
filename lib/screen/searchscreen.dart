import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sqflite_10/screen/editstudent.dart';
import 'package:sqflite_10/screen/studentdetails.dart';

class Searchscreen extends StatefulWidget {
  const Searchscreen({Key? key}) : super(key: key);

  @override
  State<Searchscreen> createState() => _StudentListState();
}

class _StudentListState extends State<Searchscreen> {
  final CollectionReference student =
      FirebaseFirestore.instance.collection('Student Record');
  late TextEditingController searchController;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
  }

  void deleteData(String id) {
    student.doc(id).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              onChanged: (value) {
                setState(() {});
              },
              decoration: const InputDecoration(
                labelText: 'Search',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
              ),
            ),
          ),
          StreamBuilder(
            stream: student.orderBy('Name').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<DocumentSnapshot> students = snapshot.data!.docs;
                List<DocumentSnapshot> filteredStudents =
                    students.where((student) {
                  String name = student['Name'].toString().toLowerCase();
                  return name.contains(searchController.text.toLowerCase());
                }).toList();
                if (filteredStudents.isEmpty) {
                  return const Center(
                      child: Text(
                    'No students available',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ));
                }

                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: filteredStudents.length,
                  itemBuilder: (context, index) {
                    final DocumentSnapshot studentDetails =
                        filteredStudents[index];

                    return Card(
                      color: Colors.lightBlue[50],
                      margin: const EdgeInsets.all(10),
                      child: ListTile(
                        leading: Container(
                            width: 50,
                            height: 50,
                            child: Image.network(studentDetails['image url'],
                                fit: BoxFit.cover)),
                        title: Text(studentDetails['Name']),
                        subtitle: Text(studentDetails['Age']),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.green),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditStudent(
                                      name: studentDetails['Name'],
                                      age: studentDetails['Age'],
                                      fatherName: studentDetails['Father Name'],
                                      number:
                                          studentDetails['Phone No'].toString(),
                                      id: studentDetails.id.toString(),
                                      url: studentDetails['image url'],
                                    ),
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                deleteData(studentDetails.id);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    backgroundColor: Colors.red,
                                    content: Text("Deleted Successfully"),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (ctr) => StudentDetails(
                              name: studentDetails['Name'],
                              age: studentDetails['Age'],
                              fatherName: studentDetails['Father Name'],
                              number: studentDetails['Phone No'].toString(),
                              url: studentDetails['image url'],
                            ),
                          ));
                        },
                      ),
                    );
                  },
                );
              }
              return Container();
            },
          ),
        ],
      ),
    );
  }
}
