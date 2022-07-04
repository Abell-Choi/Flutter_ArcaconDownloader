import 'package:flutter/material.dart';
import 'pages/root_page.dart';
import 'pages/download_page.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/' : (context) => Splash(),
      '/root' : (context) => root_page(),
      '/download' : (context) => download_page()
    },
  ));
}

class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('click next'),
              ElevatedButton(
                onPressed: (){
                  Navigator.pushNamed(context, '/root');
              }, 
              child: Text('move next'))
            ],
          ),
        ),
      ),
    );
  }
}
