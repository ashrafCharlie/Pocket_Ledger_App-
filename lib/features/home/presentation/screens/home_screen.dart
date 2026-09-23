import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pocket_ledger_app/features/transaction/domain/enums/transaction_type.dart';
import 'package:pocket_ledger_app/features/transaction/presentation/bloc/transaction_bloc.dart';
import 'package:pocket_ledger_app/features/transaction/presentation/bloc/transaction_event.dart';
import 'package:pocket_ledger_app/features/transaction/presentation/bloc/transaction_state.dart';
import 'package:pocket_ledger_app/features/transaction/presentation/screens/transaction_screen.dart';
import 'package:pocket_ledger_app/features/transaction/presentation/widgets/add_transaction_sheet.dart';

import '../../../transaction/presentation/widgets/transaction_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void _loadTransaction() {
    context.read<TransactionBloc>().add(GetTransactionsEvent());
  }

  @override
  void initState() {
    super.initState();
    _loadTransaction();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (context) {
              return AddTransactionSheet();
            },
          );
        },
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Good Morning',
                style: TextTheme.of(context).displayMedium,
              ),
              const SizedBox(height: 4),
              Text(
                'Here is your financial overview',
                style: TextTheme.of(context).titleLarge,
              ),
              const SizedBox(height: 24),

              BlocBuilder<TransactionBloc, TransactionState>(
                builder: (context, state) {
                  if (state is TransactionLoadingState) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (state is TransactionErrorState) {
                    return Center(
                      child: Text(state.message),
                    );
                  }

                  if (state is TransactionLoadedState) {
                    final transactions = state.transactions;

                    final totalIncome = transactions
                        .where(
                          (transaction) =>
                      transaction.type == TransactionType.income,
                    )
                        .fold<double>(
                      0,
                          (sum, transaction) => sum + transaction.amount,
                    );

                    final totalExpense = transactions
                        .where(
                          (transaction) =>
                      transaction.type == TransactionType.expense,
                    )
                        .fold<double>(
                      0,
                          (sum, transaction) => sum + transaction.amount,
                    );

                    final balance = totalIncome - totalExpense;

                    final recentTransactions =
                    transactions.take(5).toList();

                    return Column(
                      children: [
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Total Balance',
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '৳ ${balance.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        Row(
                          children: [
                            Expanded(
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      const Icon(Icons.arrow_downward),
                                      const SizedBox(height: 8),
                                      const Text('Income'),
                                      const SizedBox(height: 4),
                                      Text(
                                        '৳ ${totalIncome.toStringAsFixed(2)}',
                                        style: const TextStyle(
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
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      const Icon(Icons.arrow_upward),
                                      const SizedBox(height: 8),
                                      const Text('Expense'),
                                      const SizedBox(height: 4),
                                      Text(
                                        '৳ ${totalExpense.toStringAsFixed(2)}',
                                        style: const TextStyle(
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

                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
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
                                Navigator.push(context, MaterialPageRoute(builder: (context) => TransactionScreen(),));
                              },
                              child: const Text('View All'),
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        if (recentTransactions.isEmpty)
                          const Center(
                            child: Text('No Transaction Found.'),
                          )
                        else
                          ListView.builder(
                            shrinkWrap: true,
                            physics:
                            const NeverScrollableScrollPhysics(),
                            itemCount: recentTransactions.length,
                            itemBuilder: (context, index) {
                              final transaction =
                              recentTransactions[index];

                              return TransactionCard(
                                transaction: transaction,
                                showActions: false,
                              );
                            },
                          ),
                      ],
                    );
                  }

                  return const Center(
                    child: Text('Some error occurred'),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}