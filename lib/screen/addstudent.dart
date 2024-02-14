// ignore_for_file: use_build_context_synchronously

import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class AddStudent extends StatefulWidget {
  const AddStudent({super.key});

  @override
  State<AddStudent> createState() => _AddStudentState();
}

class _AddStudentState extends State<AddStudent> {

  final _formKey = GlobalKey<FormState>(); // Add a form key for the validation
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _guardianController = TextEditingController();
  final _mobileController = TextEditingController();
  String? imagepath;
  Uint8List? selectedImageByInBytes;

  @override
  Widget build(BuildContext context) {
    final CollectionReference student =
        FirebaseFirestore.instance.collection('Student Record');
    void adddata(String url) async {
      final data = {
        'Name': _nameController.text,
        'Age': _ageController.text,
        'Father Name': _guardianController.text,
        'Phone No': _mobileController.text,
        'image url': url
      };
      student.add(data).then((value) => Navigator.pop(context));
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text('Add Student'),
        actions: [
          IconButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                String? url =
                    await uploadImage(selectedImageByInBytes!, imagepath!);
                
                if (url != null) {
                  adddata(url);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: Colors.green,
                      content: Text("Successfully Added"),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: Colors.green,
                      content: Text("Failed to upload image"),
                    ),
                  );
                }
              } else {
                return;
              }
            },
            icon: const Icon(Icons.save_alt_outlined),
          )
        ],
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey, // The form key
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      foregroundColor: Colors.blue,
                      radius: 100,
                      child: selectedImageByInBytes == null
                          ? Image.network(
                              'https://uxwing.com/wp-content/themes/uxwing/download/peoples-avatars/person-profile-icon.png',
                              fit: BoxFit.cover,
                            )
                          : ClipOval(
                              child: Image.memory(selectedImageByInBytes!,
                                  fit: BoxFit.cover)),
                    ),
                    Positioned(
                      bottom: 20,
                      right: 20,
                      child: IconButton(
                        onPressed: () async {
                          selectImage();
                        },
                        icon: const Icon(Icons.camera_alt),
                        color: Colors.white,
                        iconSize: 40,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 50),
                TextFormField(
                  keyboardType: TextInputType.name,
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: "Name",
                    hintText: 'enter name',
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
                const SizedBox(height: 20),
                TextFormField(
                  keyboardType: TextInputType.text,
                  maxLength: 2,
                  controller: _ageController,
                  decoration: InputDecoration(
                    labelText: "Age",
                    hintText: 'enter age',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a Age';
                    } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                      return 'Please enter a valid age (numeric only)';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  keyboardType: TextInputType.name,
                  controller: _guardianController,
                  decoration: InputDecoration(
                    labelText: "Parent",
                    hintText: 'Enter Parent Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a Guardian';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: _mobileController,
                  maxLength: 10,
                  decoration: InputDecoration(
                    labelText: "Mobile",
                    hintText: 'Mobile Number',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a Mobile';
                    } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                      return 'Please enter a valid mobile number (numeric only)';
                    } else if (value.length != 10) {
                      return 'Mobile number should be 10 digits';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
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


