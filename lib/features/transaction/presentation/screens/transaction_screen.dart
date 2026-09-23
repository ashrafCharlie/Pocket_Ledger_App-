import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pocket_ledger_app/features/transaction/presentation/bloc/transaction_bloc.dart';
import 'package:pocket_ledger_app/features/transaction/presentation/bloc/transaction_event.dart';
import 'package:pocket_ledger_app/features/transaction/presentation/bloc/transaction_state.dart';
import 'package:pocket_ledger_app/features/transaction/presentation/widgets/update_transaction_sheet.dart';

import '../../domain/constants/transaction_categories.dart';
import '../../domain/enums/transaction_type.dart';
import '../../utils/date_range_helper.dart';
import '../widgets/transaction_card.dart';
class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  TransactionType? selectedType;
  String? selectedCategory;
  String selectedAmountFilter = 'All';
  String selectedDateFilter = 'All';
  double? selectedAmount;
  DateTime? selectedStartDate;
  DateTime? selectedEndDate;

  void _selectDateRange(DateTime startDate, DateTime endDate) {
    setState(() {
      selectedStartDate = startDate;
      selectedEndDate = endDate;
    });
  }


  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Filter Transactions',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    'Transaction Type',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Wrap(
                    spacing: 8,
                    children: [
                      ChoiceChip(
                        label: const Text('All'),
                        selected: selectedType == null,
                        onSelected: (_) {
                          setSheetState(() {
                            selectedType = null;
                          });
                        },
                      ),
                      ChoiceChip(
                        label: const Text('Income'),
                        selected: selectedType == TransactionType.income,
                        onSelected: (_) {
                          setSheetState(() {
                            selectedType = TransactionType.income;
                          });
                        },
                      ),
                      ChoiceChip(
                        label: const Text('Expense'),
                        selected: selectedType == TransactionType.expense,
                        onSelected: (_) {
                          setSheetState(() {
                            selectedType = TransactionType.expense;
                          });
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    'Category',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Wrap(
                    spacing: 8,
                    children: [
                      ChoiceChip(
                        label: const Text('All'),
                        selected: selectedCategory == null,
                        onSelected: (_) {
                          setSheetState(() {
                            selectedCategory = null;
                          });
                        },
                      ),
                      ...TransactionCategories.expenseCategories
                          .map(
                            (category) => ChoiceChip(
                          label: Text(category),
                          selected: selectedCategory == category,
                          onSelected: (_) {
                            setSheetState(() {
                              selectedCategory = category;
                            });
                          },
                        ),
                      ),
                      ...TransactionCategories.incomeCategories
                          .where(
                            (category) =>
                        !TransactionCategories.expenseCategories.contains(category),
                      )
                          .map(
                            (category) => ChoiceChip(
                          label: Text(category),
                          selected: selectedCategory == category,
                          onSelected: (_) {
                            setSheetState(() {
                              selectedCategory = category;
                            });
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    'Date',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Wrap(
                    spacing: 8,
                    children: [
                      ChoiceChip(
                        label: const Text('All'),
                        selected: selectedDateFilter == 'All',
                        onSelected: (_) {
                          setSheetState(() {
                            selectedDateFilter = 'All';
                            selectedStartDate = null;
                            selectedEndDate = null;
                          });
                        },
                      ),

                      ChoiceChip(
                        label: const Text('Today'),
                        selected: selectedDateFilter == 'Today',
                        onSelected: (_) {
                          final range = DateRangeHelper.getTodayRange();

                          setSheetState(() {
                            selectedDateFilter = 'Today';
                            selectedStartDate = range.start;
                            selectedEndDate = range.end;
                          });
                        },
                      ),

                      ChoiceChip(
                        label: const Text('This Week'),
                        selected: selectedDateFilter == 'This Week',
                        onSelected: (_) {
                          final range = DateRangeHelper.getThisWeekRange();

                          setSheetState(() {
                            selectedDateFilter = 'This Week';
                            selectedStartDate = range.start;
                            selectedEndDate = range.end;
                          });
                        },
                      ),

                      ChoiceChip(
                        label: const Text('This Month'),
                        selected: selectedDateFilter == 'This Month',
                        onSelected: (_) {
                          final range = DateRangeHelper.getThisMonthRange();

                          setSheetState(() {
                            selectedDateFilter = 'This Month';
                            selectedStartDate = range.start;
                            selectedEndDate = range.end;
                          });
                        },
                      ),

                      ChoiceChip(
                        label: const Text('Custom'),
                        selected: selectedDateFilter == 'Custom',
                        onSelected: (_) async {
                          final startDate = await showDatePicker(
                            context: context,
                            firstDate: DateTime(2020),
                            lastDate: DateTime.now(),
                            initialDate: DateTime.now(),
                          );

                          if (startDate == null) return;

                          final endDate = await showDatePicker(
                            context: context,
                            firstDate: startDate,
                            lastDate: DateTime.now(),
                            initialDate: startDate,
                          );

                          if (endDate == null) return;

                          setSheetState(() {
                            selectedDateFilter = 'Custom';
                            selectedStartDate = startDate;
                            selectedEndDate = DateTime(
                              endDate.year,
                              endDate.month,
                              endDate.day + 1,
                            );
                          });
                        },
                      ),

                    ],
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    'Amount',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Wrap(
                    spacing: 8,
                    children: [
                      ChoiceChip(
                        label: const Text('All'),
                        selected: selectedAmountFilter == 'All',
                        onSelected: (_) {
                          setSheetState(() {
                            selectedAmountFilter = 'All';
                            selectedAmount = null;
                          });
                        },
                      ),
                      ChoiceChip(
                        label: const Text('Greater than'),
                        selected: selectedAmountFilter == 'Greater than',
                        onSelected: (_) {
                          setSheetState(() {
                            selectedAmountFilter = 'Greater than';
                          });
                        },
                      ),
                      ChoiceChip(
                        label: const Text('Less than'),
                        selected: selectedAmountFilter == 'Less than',
                        onSelected: (_) {
                          setSheetState(() {
                            selectedAmountFilter = 'Less than';
                          });
                        },
                      ),
                    ],
                  ),

                  if (selectedAmountFilter != 'All') ...[
                    const SizedBox(height: 15),
                    TextField(
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: const InputDecoration(
                        labelText: 'Enter amount',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        selectedAmount = double.tryParse(value);
                      },
                    ),
                  ],

                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {

                          final minAmount =
                          selectedAmountFilter == 'Greater than'
                              ? selectedAmount
                              : null;

                          final maxAmount =
                          selectedAmountFilter == 'Less than'
                              ? selectedAmount
                              : null;

                          context.read<TransactionBloc>().add(
                            GetFilteredTransactionsEvent(
                              startDate: selectedStartDate,
                              endDate: selectedEndDate,
                              type: selectedType,
                              category: selectedCategory,
                              minAmount: minAmount,
                              maxAmount: maxAmount,
                            ),
                          );

                          Navigator.pop(context);

                      },
                      child: const Text('Apply Filter'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Transactions"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              _showFilterSheet(context);
            },
            icon: const Icon(Icons.filter_list),
          ),
        ],
      ),
      body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.0,vertical: 16.0),
          child: BlocBuilder<TransactionBloc,TransactionState>(
              builder:(context, state) {
                if(state is TransactionErrorState){
                  return Center(child: Text(state.message),);
                }
                if(state is TransactionLoadingState){
                  return Center(child: CircularProgressIndicator(),);
                }
                if(state is TransactionLoadedState){
                  final transactions = state.transactions;
                  if(transactions.isEmpty){
                    return Center(child: Text("No transaction Found"),);
                  }
                  return ListView.builder(
                    itemCount: transactions.length,
                      itemBuilder: (context, index) {
                        final transaction = transactions[index];
                        return TransactionCard(
                          transaction: transaction,
                          showActions: true,

                          onDelete: () {
                            context.read<TransactionBloc>().add(
                              DeleteTransactionEvent(
                                id: transaction.id!,
                              ),
                            );
                          },

                          onEdit: () {
                            showModalBottomSheet(
                              isScrollControlled: true,
                              context: context,
                              builder: (context) {
                                return UpdateTransactionSheet(
                                  transaction: transaction,
                                );
                              },
                            );
                          },
                        );
                      },
                  );
                }
                return Center(child: Text("Some error Occurred"),);
              }, ),
      ),
    );
  }
}
