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

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin{
  int? _generatedNumber;
  final Random _random = Random();
  Timer? _timer;
  late AnimationController _animationController;
  late Animation<double> _rotationAnimation;
  bool _isSpinning = false;
  int _currentSpinId = 0;

  @override
void initState() {
  super.initState();
  _animationController = AnimationController(
    vsync: this,
    duration: Duration(seconds: 1),
  );
  _rotationAnimation = Tween<double>(begin: 0, end: 1)
      .animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOut));
}


  void _generateNumber() {
    _currentSpinId++;
    int spinId = _currentSpinId;
    _isSpinning = true;
    _animationController.reset();
    _animationController.forward();

    _timer?.cancel();
    _timer = Timer.periodic(Duration(microseconds: 100), (timer){
      setState(() => _generatedNumber = _random.nextInt(9)+1);
    });

    Future.delayed(Duration(seconds: 1), () {
      if (spinId != _currentSpinId) return;
      _timer?.cancel();
      _animationController.stop();
      _animationController.value = 1.0;


      setState(() {
        _isSpinning = false;
      });
    });
  }

  @override
  void dispose (){
    _animationController.dispose();
    _timer?.cancel();
    super.dispose();
  }



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
              child: RotationTransition(
                turns: _rotationAnimation,
              child: Text(
                _generatedNumber?.toString() ??"",
                //Element Space to show generated number 
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
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
                  //This Element here generates the randomly generated Number on the Generate Page (Has a limit of 1 - 9)
                  _buildButton("Generate", _generateNumber),
                  SizedBox(height: 10),
                  _buildButton("View Statistics", () {}),
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

//Provides Widget for the the Generate Button, and the Change page to stats button
Widget _buildButton (String text, VoidCallback onPressed){
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