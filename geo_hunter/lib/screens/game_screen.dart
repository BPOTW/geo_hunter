import 'package:flutter/material.dart';

class GameScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Geo Puzzle'),
        backgroundColor: Colors.indigo,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Solve the Puzzle!', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            Icon(Icons.public, color: Colors.indigo, size: 80),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {},
              child: Text('Submit Answer'),
            )
          ],
        ),
      ),
    );
  }
}
