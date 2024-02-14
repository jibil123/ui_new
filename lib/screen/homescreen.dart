import 'package:flutter/material.dart';
import 'package:sqflite_10/screen/addstudent.dart';
import 'package:sqflite_10/screen/listscreeen.dart';
import 'package:sqflite_10/screen/searchscreen.dart';


class HomeScreeen extends StatefulWidget {
  const HomeScreeen({super.key});

  @override
  State<HomeScreeen> createState() => _HomeScreeenState();
}

class _HomeScreeenState extends State<HomeScreeen> {
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        centerTitle: true,
        title: const Text(
          'Students Record',
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (ctxs) =>const Searchscreen()));
              },
              icon: const Icon(Icons.search_rounded,color: Colors.white,))
        ],
      ),
      body:const Column(
        children: [
          Expanded(
               child:StudentList()),
        ],
      ),
      floatingActionButton: Visibility(
        visible: true, // Show the add button
        child: FloatingActionButton(
          backgroundColor: Colors.green,
          shape:const CircleBorder(),
          onPressed: () {
            addstudent(context);
          },
          child:const Icon(Icons.add,),
        ),
      ),
      
    );
  }

  void addstudent(ctx) {
    Navigator.of(ctx)
        .push(MaterialPageRoute(builder: (ctx) => const AddStudent()));
  }
}
