//needed for asynchronus 
import 'dart:async';
import 'dart:math';
//Material Desgin Import
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Random Number Generator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.lightBlueAccent),
        useMaterial3: true,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget{
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{
  int? _generatedNumber;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //App Bar Color and Font Color
        backgroundColor: Colors.blue.shade600,
        title: Text("Random Number Generator",style: TextStyle(color: Colors.white)),
        //Top Right Home Button
        leading: Icon(Icons.home_outlined, color: Colors.white,),
      ),
      backgroundColor: Colors.lightBlue,
      body: Center(
        child: Column(
          mainAxisAlignment: .center,
          children: [
            Expanded(child: Center(
              child: Text(
                _generatedNumber?.toString() ?? "",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ), 
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  buildButton("Generate", (){}),
                  SizedBox(height: 10),
                  buildButton("View Statistics", () {}),
                ],
              ),
            ),
          ),      
        ],
       ),
      ),
    );
  }
}

Widget buildButton (String text, VoidCallback onPressed){
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.blue.shade600,
      foregroundColor : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      minimumSize: Size(double.infinity,60),
    ),
    onPressed: onPressed,
    child: Text(text, style: TextStyle(fontSize: 20)),    
    );
}