import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pocket_ledger_app/core/validators/app_validator.dart';
import 'package:pocket_ledger_app/features/transaction/domain/entities/transaction_entity.dart';
import 'package:pocket_ledger_app/features/transaction/domain/enums/transaction_type.dart';
import 'package:pocket_ledger_app/features/transaction/presentation/bloc/transaction_bloc.dart';
import 'package:pocket_ledger_app/features/transaction/presentation/bloc/transaction_event.dart';
import 'package:pocket_ledger_app/features/transaction/presentation/bloc/transaction_state.dart';

import '../../domain/constants/transaction_categories.dart';

class AddTransactionSheet extends StatefulWidget {
  const AddTransactionSheet({super.key});

  @override
  State<AddTransactionSheet> createState() => _AddTransactionSheetState();
}

class _AddTransactionSheetState extends State<AddTransactionSheet> {
  final  amountController = TextEditingController();
  final noteController = TextEditingController();
  TransactionType selectedType = TransactionType.expense;
  String selectedCategory = 'Food';
  DateTime selectedDate = DateTime.now();
  final formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    noteController.dispose();
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TransactionBloc,TransactionState>(
      listener: (context, state) {
        if (state is TransactionSuccessState) {
          context.read<TransactionBloc>().add(
             GetTransactionsEvent(),
          );

          Navigator.pop(context);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Transaction Successfully added"),
            ),
          );
        }
        if(state is TransactionErrorState){
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.viewInsetsOf(context).bottom + 16,
          ),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Add Transaction',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16,),

                TextFormField(
                  validator: AppValidator.amount,
                  controller: amountController,
                  keyboardType: TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: InputDecoration(
                    labelText: "Amount",
                    hintText: 'Enter Amount',
                    border: OutlineInputBorder(),
                  ),
                ),

                SizedBox(height: 8,),

               DropdownButtonFormField(
                 initialValue: selectedType,
                   decoration: InputDecoration(
                     border: OutlineInputBorder(),
                     labelText: 'Transaction Type'
                   ),
                   items: TransactionType.values.map((type) {
                     return DropdownMenuItem(
                       value: type,
                       child: Text(type.name.toUpperCase()),
                     );
                   },).toList() ,
                 onChanged: (value) {
                   if (value == null) return;

                   setState(() {
                     selectedType = value;

                     selectedCategory = value == TransactionType.expense
                         ? TransactionCategories.expenseCategories.first
                         : TransactionCategories.incomeCategories.first;
                   });
                 },
                 ),

                SizedBox(
                  height: 8.0,
                ),

                DropdownButtonFormField(
                  initialValue: selectedCategory,
                  decoration: const InputDecoration(
                    labelText: "Category",
                    border: OutlineInputBorder(),
                  ),
                  items: (selectedType == TransactionType.expense
                      ? TransactionCategories.expenseCategories
                      : TransactionCategories.incomeCategories)
                      .map(
                        (category) => DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    ),
                  )
                      .toList(),
                  onChanged: (value) {
                    if (value == null) return;

                    setState(() {
                      selectedCategory = value;
                    });
                  },
                ),

                SizedBox(height: 8.0,),

                TextFormField(
                  controller: noteController,
                  maxLines: 2,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Note",
                    hintText: "Add a note(optional)"
                  ),
                ),

                SizedBox(height: 10.0,),

                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Date'),
                  subtitle: Text(
                    '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                  ),
                  trailing: const Icon(Icons.calendar_month),
                  onTap: () async {
                    final pickedDate = await showDatePicker(
                      context: context,
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now(),
                      initialDate: selectedDate,
                    );

                    if (pickedDate == null) return;

                    setState(() {
                      selectedDate = pickedDate;
                    });
                  },
                ),

                const SizedBox(height: 16),

                BlocBuilder<TransactionBloc,TransactionState>(

                  builder: (context, state) {
                    final isLoading = state is TransactionLoadingState;

                   return SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isLoading ? null: () {
                          if(!formKey.currentState!.validate()) return;

                          final transaction = TransactionEntity(
                              amount:double.parse( amountController.text.trim()),
                              type: selectedType,
                              category: selectedCategory,
                              note: noteController.text.trim().isEmpty? null : noteController.text.trim(),
                              date: selectedDate);
                          context.read<TransactionBloc>().add(AddTransactionEvent(transaction: transaction));
                        },
                        child: isLoading ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(),
                        ) : const Text('Save Transaction'),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}