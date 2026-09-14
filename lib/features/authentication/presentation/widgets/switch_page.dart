import 'package:flutter/material.dart';
import 'package:pocket_ledger_app/features/authentication/presentation/screens/login_screen.dart';
import 'package:pocket_ledger_app/features/authentication/presentation/screens/signup_screen.dart';
class SwitchPage extends StatefulWidget {
  const SwitchPage({super.key});

  @override
  State<SwitchPage> createState() => _SwitchPageState();
}

class _SwitchPageState extends State<SwitchPage> {
  bool isLoginPage = true;
  void togglePage(){
    setState(() {
      isLoginPage = !isLoginPage;
    });
  }
  @override
  Widget build(BuildContext context) {
    if(isLoginPage){
      return LoginScreen(onPressed: togglePage,);
    }
    return SignupScreen(onPressed: togglePage,
    );
  }
}
