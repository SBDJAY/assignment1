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
  final Map<int, int> _statistics = {};
  int? _lastGeneratedNumber;



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
      _lastGeneratedNumber = _generatedNumber;

      setState(() {
        _statistics[_lastGeneratedNumber!] = (_statistics[_lastGeneratedNumber!] ?? 0) + 1;
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
        backgroundColor: Color(0xFF147CD3),
        title: Text("Random Number Generator", style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: Icon(Icons.home_outlined, color: Colors.white),
          onPressed: () {
            print("Home button clicked");
          },
        ),
      ),
 
      backgroundColor: Colors.lightBlue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(child: Center(
              child: RotationTransition(
                turns: _rotationAnimation,
              child: Text(
                _generatedNumber?.toString() ?? "",
                //Element Space to show generated number 
                style: TextStyle(fontSize: 64, color: Colors.white, fontWeight: FontWeight.bold),
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
                  buildButton("Generate", _generateNumber),
                  SizedBox(height: 10),
                  buildButton("View Statistics", () => Navigator.push(
                    context, MaterialPageRoute(
                      builder: (context) => StatisticsPage(
                        statistics: _statistics, 
                        onReset: (){
                          setState(() {
                            _statistics.clear();
                            _generatedNumber = null;
                          });
                        },
                      ),
                    ),
                  )),
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



//UI Page for the Stats Page that saves the spinned nuber data 
class StatisticsPage extends StatelessWidget {
  final Map<int, int> statistics;
  final VoidCallback onReset;
  StatisticsPage({required this.statistics, required this.onReset});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade600,
        title: Text("Statistics", style: TextStyle(color : Colors.white)),
        leading : IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
          ),
        ),
        backgroundColor: Colors.lightBlue,
        body: SafeArea(child: Padding
          (padding: const EdgeInsets.symmetric(
            horizontal: 10.0, vertical: 20.0
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(child: ListView.builder(
                  itemCount: 9,
                  itemBuilder: (context, index){
                    int number = index + 1;
                    return ListTile(
                      title: Text("$number: ${statistics[number] ?? 0}",
                        style: TextStyle(color: Colors.white, fontSize: 20)),
                      );
                    }, 
                  ),
                ),

                buildButton("Reset", () {
                  statistics.clear();
                  onReset();
                }),
                SizedBox(height: 10),
                buildButton("Back to Home", () => Navigator.pop(context)),
              ],
            ),
          ),
        ),
    );
  }
}


//Provides Widget for the the Generate Button, and the Change page to stats button
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