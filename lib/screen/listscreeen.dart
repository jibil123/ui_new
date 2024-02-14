import 'dart:html';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sqflite_10/screen/editstudent.dart';
import 'package:sqflite_10/screen/studentdetails.dart';

class StudentList extends StatefulWidget {
  const StudentList({Key? key}) : super(key: key);

  @override
  State<StudentList> createState() => _StudentListState();
}

class _StudentListState extends State<StudentList> {
  final CollectionReference student =
      FirebaseFirestore.instance.collection('Student Record');

  void deletedata(id) {
    showDialog(
        context: context,
        builder: (i) {
          return AlertDialog(
              title: const Text('Delete Data'),
              content: const Text('Are you sure to delete this student data'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                    onPressed: () {
                      student.doc(id).delete();
                      setState(() {});
                      Navigator.pop(context);
                    },
                    child: const Text('delete'))
              ]);
        });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: student.orderBy('Name').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text(
                  'No students available',
                  style: TextStyle(fontSize: 18),
                ),
              );
            }
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot studentdetails =
                    snapshot.data!.docs[index];
                return Card(
                  color: Colors.lightBlue[50],
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    leading: Container(
                        width: 50,
                        height: 50,
                        child: Image.network(studentdetails['image url'],
                            fit: BoxFit.cover)),
                    title: Text(studentdetails['Name']),
                    subtitle: Text(
                      studentdetails['Age'],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.green,
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EditStudent(
                                          name: studentdetails['Name'],
                                          age: studentdetails['Age'],
                                          fatherName:
                                              studentdetails['Father Name'],
                                          number: studentdetails['Phone No']
                                              .toString(),
                                          id: studentdetails.id.toString(),
                                          url: studentdetails['image url'],
                                        )));
                          },
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            deletedata(studentdetails.id);
                            
                          },
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (ctr) => StudentDetails(
                          name: studentdetails['Name'],
                          age: studentdetails['Age'],
                          fatherName: studentdetails['Father Name'],
                          number: studentdetails['Phone No'].toString(),
                          url: studentdetails['image url'],
                        ),
                      ));
                    },
                  ),
                );
              },
            );
          }
          return Container();
        });
  }
}

