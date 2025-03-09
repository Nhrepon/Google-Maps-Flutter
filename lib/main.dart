import 'package:flutter/material.dart';

void main(){
  runApp(const GoogleMaps());
}

class GoogleMaps extends StatelessWidget {
  const GoogleMaps({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Google maps and Geolocator", style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: Text("Google maps", style: TextStyle(color: Colors.green),),
    );
  }
}


