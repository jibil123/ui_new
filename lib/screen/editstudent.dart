import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';

class EditStudent extends StatefulWidget {
  final String name;
  final String age;
  final String fatherName;
  final String number;
  final String id;
  final String url;

  const EditStudent(
      {Key? key,
      required this.name,
      required this.age,
      required this.fatherName,
      required this.number,
      required this.id,
      required this.url})
      : super(key: key);

  @override
  State<EditStudent> createState() => _EditStudentState();
}

class _EditStudentState extends State<EditStudent> {
  final _formKey = GlobalKey<FormState>(); //  form key for the validation
  final CollectionReference student =
      FirebaseFirestore.instance.collection('Student Record');
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _guardianController = TextEditingController();
  final _mobileController = TextEditingController();
  String? imagepath;
  Uint8List? selectedImageByInBytes;
  void updatedata(id, String? url) {
    final data = {
      'Name': _nameController.text,
      'Age': _ageController.text,
      'Father Name': _guardianController.text,
      'Phone No': _mobileController.text,
      'image url': url
    };
    student.doc(id).update(data).then((value) => Navigator.pop(context));
  }

  @override
  Widget build(BuildContext context) {
    _nameController.text = widget.name;
    _ageController.text = widget.age;
    _guardianController.text = widget.fatherName;
    _mobileController.text = widget.number;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Student'),
        actions: [
          IconButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                if (selectedImageByInBytes != null && imagepath != null) {
                  uploadImage(selectedImageByInBytes!, imagepath!)
                      .then((imageUrl) {
                    updatedata(widget.id, imageUrl);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        backgroundColor: Colors.green,
                        content: Text("Successfully Added"),
                      ),
                    );
                  });
                } else {
                  updatedata(widget.id, widget.url);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: Colors.green,
                      content: Text("Successfully Added"),
                    ),
                  );
                }
              } else {
                return;
              }
            },
            icon: const Icon(Icons.cloud_upload),
          )
        ],
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      InkWell(
                        onTap: () => selectImage(),
                        child: CircleAvatar(
                          radius: 100,
                          child: selectedImageByInBytes == null
                              ? ClipOval(
                                  child: Image.network(
                                  widget.url,
                                  fit: BoxFit.cover,
                                ))
                              : ClipOval(
                                  child: Image.memory(
                                  selectedImageByInBytes!,
                                  fit: BoxFit.fill,
                                )),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 50),
                  Row(
                    children: [
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextFormField(
                          keyboardType: TextInputType.name,
                          controller: _nameController,
                          decoration: InputDecoration(
                            labelText: "Name",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter a Name';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextFormField(
                          maxLength: 2,
                          keyboardType: TextInputType.text,
                          controller: _ageController,
                          decoration: InputDecoration(
                            labelText: "Class",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter Age';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextFormField(
                          keyboardType: TextInputType.name,
                          controller: _guardianController,
                          decoration: InputDecoration(
                            labelText: "Parent",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Enter Parent Name';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          maxLength: 10,
                          controller: _mobileController,
                          decoration: InputDecoration(
                            labelText: "Mobile",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter a Mobile';
                            } else if (value.length != 10) {
                              return 'Mobile number should be 10 digits';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )),
      ),
    );
  }

  Future<void> selectImage() async {
    var picked = await FilePicker.platform.pickFiles();

    if (picked != null) {
      setState(() {
        imagepath = picked.files.first.name;
        selectedImageByInBytes = picked.files.first.bytes;
      });
    }
  }

  Future<String?> uploadImage(Uint8List imageData, String fileName) async {
    try {
      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref('student image')
          .child(fileName);
      final metadata =
          firebase_storage.SettableMetadata(contentType: 'image/jpeg');
      await ref.putData(imageData, metadata);
      String downloadURL = await ref.getDownloadURL();
      return downloadURL;
    } catch (e) {
      return null;
    }
  }
}
