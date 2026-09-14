import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pocket_ledger_app/core/database/isar_database.dart';
import 'package:pocket_ledger_app/features/authentication/data/datasource/auth_remote_datasource_impl.dart';
import 'package:pocket_ledger_app/features/authentication/data/repositories/auth_repo_impl.dart';
import 'package:pocket_ledger_app/features/authentication/domain/repositories/auth_repo.dart';
import 'package:pocket_ledger_app/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:pocket_ledger_app/features/authentication/presentation/bloc/auth_event.dart';
import 'package:pocket_ledger_app/features/authentication/presentation/bloc/auth_state.dart';
import 'package:pocket_ledger_app/features/authentication/presentation/widgets/switch_page.dart';
import 'package:pocket_ledger_app/features/home/presentation/screens/home_screen.dart';
import 'package:pocket_ledger_app/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final isar = IsarDatabase.open();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepo>(create: (context) => AuthRepoImpl(authRemoteDataSource: AuthRemoteDataSourceimpl()),)
      ],
      child: BlocProvider(
        create: (context) => AuthBloc(authRepo: context.read<AuthRepo>() )..add(CheckAuthStatusEvent()),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Pocket Ledger',
          theme: ThemeData(
            colorScheme: .fromSeed(seedColor: Colors.deepPurple),
          ),
          home: BlocConsumer<AuthBloc,AuthState>( 
              listener: (context, state) {
                if(state  is AuthErrorState){
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.errorMsg)));
                }
              },
              builder:(context, state) {
                if(state  is AuthLoadingState){
                  return Scaffold(body: Center(
                    child: CircularProgressIndicator(),
                  ),);
                }
                if(state is AuthErrorState){
                  Scaffold(body:Center(
                    child: Text(state.errorMsg),
                  ),);
                }
                if(state is AuthenticateState){
                  return HomeScreen();
                }
                if(state is UnAuthenticateState){
                  return SwitchPage();
                }
                return Scaffold(
                  body: Center(
                    child: Text("Some Error Occurred"),
                  ),
                );
              },
          ),
        ),
      ),
    );
  }
}

