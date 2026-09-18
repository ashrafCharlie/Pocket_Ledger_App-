
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pocket_ledger_app/features/transaction/presentation/bloc/transaction_bloc.dart';
import 'package:pocket_ledger_app/features/transaction/presentation/bloc/transaction_event.dart';
import 'package:pocket_ledger_app/features/transaction/presentation/bloc/transaction_state.dart';
import 'package:pocket_ledger_app/features/transaction/presentation/widgets/add_transaction_sheet.dart';

class HomeScreen extends StatefulWidget {
const HomeScreen({super.key});

@override
State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void _loadTransaction(){
    context.read<TransactionBloc>().add(GetTransactionsEvent());
  }
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadTransaction();
  }
@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(
title: const Text('PocketLedger'),
),

floatingActionButton: FloatingActionButton(
onPressed: () {
showModalBottomSheet(
context: context,
isScrollControlled: true,
builder: (context) {
return const AddTransactionSheet();
},
);
},
child: const Icon(Icons.add),
),

body: SingleChildScrollView(
padding: const EdgeInsets.all(16),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [

// Greeting
const Text(
'Good Morning 👋',
style: TextStyle(
fontSize: 16,
),
),

const SizedBox(height: 4),

const Text(
'Here is your financial overview',
style: TextStyle(
fontSize: 14,
),
),

const SizedBox(height: 24),

// Total Balance
Card(
child: Padding(
padding: const EdgeInsets.all(20),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: const [
Text(
'Total Balance',
style: TextStyle(
fontSize: 15,
),
),

SizedBox(height: 8),

Text(
'৳ 0.00',
style: TextStyle(
fontSize: 30,
fontWeight: FontWeight.bold,
),
),
],
),
),
),

const SizedBox(height: 16),

// Income & Expense
Row(
children: [

Expanded(
child: Card(
child: Padding(
padding: const EdgeInsets.all(16),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: const [
Icon(Icons.arrow_downward),

SizedBox(height: 8),

Text('Income'),

SizedBox(height: 4),

Text(
'৳ 0.00',
style: TextStyle(
fontSize: 18,
fontWeight: FontWeight.bold,
),
),
],
),
),
),
),

const SizedBox(width: 12),

Expanded(
child: Card(
child: Padding(
padding: const EdgeInsets.all(16),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: const [
Icon(Icons.arrow_upward),

SizedBox(height: 8),

Text('Expense'),

SizedBox(height: 4),

Text(
'৳ 0.00',
style: TextStyle(
fontSize: 18,
fontWeight: FontWeight.bold,
),
),
],
),
),
),
),
],
),

const SizedBox(height: 24),

// Recent Transactions Header
Row(
mainAxisAlignment: MainAxisAlignment.spaceBetween,
children: [
const Text(
'Recent Transactions',
style: TextStyle(
fontSize: 18,
fontWeight: FontWeight.bold,
),
),

TextButton(
onPressed: () {
// Later:
// Navigate to Transactions Screen
},
child: const Text('View All'),
),
],
),

const SizedBox(height: 8),

// Temporary transaction UI

BlocBuilder<TransactionBloc,TransactionState>(builder:  (context, state) {
 if(state is TransactionLoadingState){
   return Center(child: CircularProgressIndicator(),);
 }
 if(state is TransactionErrorState){
   return Center(child: Text(state.message),);
 }
 if(state is TransactionLoadedState){
   final transactions = state.transactions;
   if(transactions.isEmpty){
     return Center(child: Text("No Transaction Found."),);
   }
  return ListView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemCount: transactions.length,
     itemBuilder: (context, index) {
      final transaction = transactions[index];
     return Padding(
       padding: EdgeInsets.symmetric(vertical: 10.0,horizontal: 8.0),
       child: ListTile(
         title: Text(transaction.category),

       ),
     );
   },);
 }
 return Center(child: Text("Some error occurred"),);
},),
],
),
),
);
}
}

