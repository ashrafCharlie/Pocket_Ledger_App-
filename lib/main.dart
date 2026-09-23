import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isar_community/isar.dart';
import 'package:pocket_ledger_app/core/database/isar_database.dart';
import 'package:pocket_ledger_app/features/authentication/data/datasource/auth_remote_datasource_impl.dart';
import 'package:pocket_ledger_app/features/authentication/data/repositories/auth_repo_impl.dart';
import 'package:pocket_ledger_app/features/authentication/domain/repositories/auth_repo.dart';
import 'package:pocket_ledger_app/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:pocket_ledger_app/features/authentication/presentation/bloc/auth_event.dart';
import 'package:pocket_ledger_app/features/authentication/presentation/bloc/auth_state.dart';
import 'package:pocket_ledger_app/features/authentication/presentation/widgets/switch_page.dart';
import 'package:pocket_ledger_app/features/bottom_navigation/presentation/screens/main_screen.dart';
import 'package:pocket_ledger_app/features/home/presentation/screens/home_screen.dart';
import 'package:pocket_ledger_app/features/transaction/data/datasource/transaction_local_datasource_impl.dart';
import 'package:pocket_ledger_app/features/transaction/data/models/transaction_model.dart';
import 'package:pocket_ledger_app/features/transaction/data/repositories/transaction_repo_impl.dart';
import 'package:pocket_ledger_app/features/transaction/domain/repositories/transaction_repo.dart';
import 'package:pocket_ledger_app/features/transaction/presentation/bloc/transaction_bloc.dart';
import 'package:pocket_ledger_app/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final isar = await IsarDatabase.open(
    schemas: [TransactionModelSchema]
  );
  runApp( MyApp(isar: isar,));
}

class MyApp extends StatelessWidget {
  final  Isar isar;
  const MyApp({super.key, required this.isar});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepo>(create: (context) => AuthRepoImpl(authRemoteDataSource: AuthRemoteDataSourceimpl()),),
        RepositoryProvider<TransactionRepo>(create: (context) => TransactionRepoImpl(transactionLocalDatasource: TransactionLocalDatasourceImpl(isar: isar)),),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
          create: (context) => AuthBloc(authRepo: context.read<AuthRepo>() )..add(CheckAuthStatusEvent()),),
          BlocProvider(create: (context) => TransactionBloc(transactionRepo: context.read<TransactionRepo>()),),
        ],
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
                  if(state is AuthenticateState){
                    return MainScreen(currentUser: state.user,);
                  }
                  return SwitchPage();
                },
            ),
          ),
        
      ),
    );
  }
}

