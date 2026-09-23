import 'package:pocket_ledger_app/features/transaction/data/models/transaction_model.dart';
import 'package:pocket_ledger_app/features/transaction/domain/enums/transaction_type.dart';

abstract class TransactionLocalDatasource {
  Future<void> addTransaction(TransactionModel transaction);
  Future<List<TransactionModel>> getTransactions();
  Future<void> updateTransaction(TransactionModel transaction);

  Future<void> deleteTransaction(int id);
  Future<List<TransactionModel>> getFilteredTransactions({
    DateTime? startDate,
    DateTime? endDate,
    TransactionType? type,
    String? category,
    double? minAmount,
    double? maxAmount,
  });
}