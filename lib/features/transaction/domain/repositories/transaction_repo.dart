import 'package:pocket_ledger_app/features/transaction/domain/entities/transaction_entity.dart';
import 'package:pocket_ledger_app/features/transaction/domain/enums/transaction_type.dart';

abstract class  TransactionRepo {
  Future<void> addTransaction(TransactionEntity transaction);
  Future<List<TransactionEntity>> getTransactions ();
  Future<void> updateTransaction(TransactionEntity transaction);

  Future<void> deleteTransaction (int id);

  Future<List<TransactionEntity>> getFilteredTransactions({
    DateTime? startDate,
    DateTime? endDate,
    TransactionType? type,
    String? category,
    double? minAmount,
    double? maxAmount});
}