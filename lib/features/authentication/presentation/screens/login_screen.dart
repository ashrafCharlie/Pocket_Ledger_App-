import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pocket_ledger_app/core/validators/app_validator.dart';
import 'package:pocket_ledger_app/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:pocket_ledger_app/features/authentication/presentation/bloc/auth_event.dart';
import 'package:pocket_ledger_app/features/authentication/presentation/bloc/auth_state.dart';
import 'package:pocket_ledger_app/features/authentication/presentation/screens/signup_screen.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback onPressed;
  const LoginScreen({super.key,required this.onPressed});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final forgetPasswrdEmail = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isPassObscure = true;
   
  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    forgetPasswrdEmail.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
  body: BlocListener<AuthBloc,AuthState>(
    listener: (context, state) {
      if(state is AuthenticateState){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Login Successful")));
      }

    },
    child: SingleChildScrollView(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                const SizedBox(height: 30),
                 Icon(Icons.money_outlined,
                   size: 80,
                 ),
                 SizedBox(height: 10.0,),
                 Text(
                  'Pocket Ledger',
                  style: Theme.of(context).textTheme.headlineLarge,
                  
                ),
            
                const SizedBox(height: 8),
            
                 Text(
                  'Manage Your Money',
                  style:Theme.of(context).textTheme.bodyLarge,
                ),
            
                const SizedBox(height: 40),
            
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
      
                //forget password
                  Align(
                      alignment: Alignment.centerRight,
                        child: TextButton(
                        
                            onPressed: () {
                              final forgetFormKey = GlobalKey<FormState>();
      
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text("Forget Your Password"),
      
                                  content: Form(
                                    key: forgetFormKey,
                                    child: TextFormField(
                                      controller: forgetPasswrdEmail,
                                      keyboardType: TextInputType.emailAddress,
                                      decoration: const InputDecoration(
                                        labelText: "Email",
                                        hintText: "Enter your email",
                                        prefixIcon: Icon(Icons.email_outlined),
                               
                                      ),
                                      validator: AppValidator.email,
                                    ),
                                  ),
      
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        if (forgetFormKey.currentState!.validate()) {
                                          final email = forgetPasswrdEmail.text.trim();
      
                                          context.read<AuthBloc>().add(
                                            ResetAccountEvent(email: email),
                                          );
      
                                          Navigator.pop(context);
                                        }
                                      },
                                      child: const Text("Send Reset Link"),
                                    ),
      
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text("Cancel"),
                                    ),
                                  ],
                                ),
                              );
                            },
      
                          child: const Text('Forgot Password?'),
                  ),
                ),
      
                const SizedBox(height: 20,),
                // Login button
               SizedBox(
                 height: 40,
                 width: double.infinity,
                 child: ElevatedButton(
                   onPressed: () {
                    if( formKey.currentState!.validate()){
                     final email = emailController.text.trim();
                     final password = passwordController.text;
                     context.read<AuthBloc>().add(SignInEvent(email: email, password: password));
                    }
                   },
                   child: BlocBuilder<AuthBloc,AuthState>(
                      builder:(context, state) {
                        if(state is AuthLoadingState){
                         return CircularProgressIndicator();
                        }
                       return Text("Login");
                      } ,


                     ),
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
                  const Text("Don't have an account?"),
                  TextButton(
                    onPressed: widget.onPressed,
                    child: const Text('Sign Up'),
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