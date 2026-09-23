import 'package:isar_community/isar.dart';
import 'package:pocket_ledger_app/features/transaction/data/datasource/transaction_local_datasource.dart';
import 'package:pocket_ledger_app/features/transaction/data/models/transaction_model.dart';
import 'package:pocket_ledger_app/features/transaction/domain/enums/transaction_type.dart';

class TransactionLocalDatasourceImpl implements TransactionLocalDatasource{
  final Isar isar;
  TransactionLocalDatasourceImpl({required this.isar});

  @override
  Future<void> addTransaction(TransactionModel transaction) async {
    await isar.writeTxn(() async {
      await isar.transactionModels.put(transaction);
    });
  }

  @override
  Future<List<TransactionModel>> getTransactions() async {
   return await isar.transactionModels
       .where().sortByDateDesc().findAll();
  }


  @override
  Future<void> deleteTransaction(int id) async {
    await isar.writeTxn(() async {
      await isar.transactionModels.delete(id);
    },);
  }

  @override
  Future<void> updateTransaction(TransactionModel transaction) async {
    await isar.writeTxn(() async {
      await isar.transactionModels.put(transaction);
    },);
  }

  @override
  Future<List<TransactionModel>> getFilteredTransactions({
    DateTime? startDate,
    DateTime? endDate,
    TransactionType? type,
    String? category,
    double? minAmount,
    double? maxAmount,
  }) async {
    return await isar.transactionModels
        .filter()
        .optional(
      startDate != null && endDate != null,
          (q) => q.dateBetween(startDate!, endDate!),
    )
        .optional(
      type != null,
          (q) => q.typeEqualTo(type!),
    )
        .optional(
      category != null,
          (q) => q.categoryEqualTo(category!),
    )
        .optional(
      minAmount != null,
          (q) => q.amountGreaterThan(minAmount!),
    )
        .optional(
      maxAmount != null,
          (q) => q.amountLessThan(maxAmount!),
    )
        .findAll();
  }
}