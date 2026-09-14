import 'package:flutter/material.dart';
import 'package:pocket_ledger_app/features/authentication/presentation/screens/login_screen.dart';
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
        title: Text("Home Page"),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(onPressed: (){

            }, child: Text("Login")),
            ElevatedButton(onPressed: (){
              
            }, child: Text("Signup")),
          ],
        ),
      ),
    );
  }
}
