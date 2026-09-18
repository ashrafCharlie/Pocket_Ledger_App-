import 'package:pocket_ledger_app/features/transaction/data/models/transaction_model.dart';

abstract class TransactionLocalDatasource {
  Future<void> addTransaction(TransactionModel transaction);
  Future<List<TransactionModel>> getTransactions();
}