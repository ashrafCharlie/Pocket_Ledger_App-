import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pocket_ledger_app/core/validators/app_validator.dart';
import 'package:pocket_ledger_app/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:pocket_ledger_app/features/authentication/presentation/bloc/auth_event.dart';
import 'package:pocket_ledger_app/features/authentication/presentation/bloc/auth_state.dart';
import 'package:pocket_ledger_app/features/home/presentation/screens/home_screen.dart';

class SignupScreen extends StatefulWidget {
  final VoidCallback onPressed;
  const SignupScreen({super.key,required this.onPressed});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmpassController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool isPassObscure = true;
  bool isConfirmPassObscure = true;


  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmpassController.dispose();
  }
  @override
  Widget build(BuildContext context) {
      return Scaffold(
  body: BlocListener<AuthBloc,AuthState>(
    listener: (context, state) {

      if(state is AuthenticateState){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Account Create Successful")));
      }
    },
    child: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 30),
                 Icon(Icons.money_rounded,size: 80,),
                 SizedBox(height: 10.0,),
                 Text(
                  'Pocket Ledger App',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
            
                const SizedBox(height: 8),
            
                 Text(
                  'Manage Your money',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                
                const SizedBox(height: 40),
                
                 // Name field 
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Name",
                    hintText: 'Enter Your Name',
                    prefixIcon: Icon(Icons.person),
                 
                  ),
                  validator: AppValidator.name,
                ),
                
                const SizedBox(height: 20.0,),
            
                // Email field 
                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Email",
                    hintText: 'Enter Your Email',
                    prefixIcon: Icon(Icons.email_outlined),
                  
                  ),
                  validator: AppValidator.email,
                ),
                
                 const  SizedBox(height: 20,),
                
                // Password field 
                TextFormField(
                  controller: passwordController,
                  obscureText: isPassObscure,
                  decoration:  InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Password",
                    hintText: 'Enter Your Password',
                    prefixIcon: Icon(Icons.lock_outlined),
                    suffixIcon: IconButton(
                      onPressed: (){
                        setState(() {
                          isPassObscure = !isPassObscure;
                        });
                    }, 
                    icon: isPassObscure? Icon(Icons.visibility_outlined): Icon(Icons.visibility_off_outlined)),
          
                  ),
                  validator: AppValidator.password,
                ),
                
                const SizedBox(height: 20.0,),
                
                //confirm Password 
                TextFormField(
                  controller: confirmpassController,
                  obscureText: isConfirmPassObscure,
                  decoration:  InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Confirm Password",
                    hintText: 'Enter Confirm Password',
                    prefixIcon: Icon(Icons.lock_outlined),
                    suffixIcon: IconButton(
                      onPressed: (){
                        setState(() {
                          isConfirmPassObscure = !isConfirmPassObscure;
                        });
                    }, 
                    icon: isConfirmPassObscure? Icon(Icons.visibility_outlined): Icon(Icons.visibility_off_outlined)),
                   
                  ),
                  validator: (value){
                    return AppValidator.confirmPassword(value, confirmpassController.text );
                  }
                    ),
                
                const SizedBox(height: 20,),
                
                // Login button
               SizedBox(
                 height: 40,
                 width: double.infinity,
                 child: ElevatedButton(
                   onPressed: () {
                     if(_formKey.currentState!.validate()){
                     final email = emailController.text.trim();
                     final name = nameController.text.trim();
                     final password = passwordController.text;

                     context.read<AuthBloc>().add(SignUpEvent(
                       email: email,
                        name: name,
                         password: password));
                     }

                   },
                   child: const Text('Sign Up'),
                 ),
               ),
                
              const SizedBox(height: 20),
                
              //continue with google 
                  const Row(
                    children: [
                      Expanded(child: Divider()),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text('OR'),
                      ),
                      Expanded(child: Divider()),
                    ],
                  ),
                  const SizedBox(height: 20,),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        context.read<AuthBloc>().add(SignInWithGoolge());
                      },
                      label: const Text('Continue with Google'),
                    ),
                  ),
                
                
              //Don't have account
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account?"),
                  TextButton(
                    onPressed: widget.onPressed,
                    child: const Text('Login'),
                  ),
                ],
              ),
              ],
            ),
          ),
        ),
      ),
    ),
  ),
);
  }
}