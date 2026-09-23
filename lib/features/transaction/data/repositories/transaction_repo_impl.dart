import 'package:pocket_ledger_app/features/transaction/data/datasource/transaction_local_datasource.dart';
import 'package:pocket_ledger_app/features/transaction/data/mappers/transaction_mapper.dart';
import 'package:pocket_ledger_app/features/transaction/domain/entities/transaction_entity.dart';
import 'package:pocket_ledger_app/features/transaction/domain/enums/transaction_type.dart';
import 'package:pocket_ledger_app/features/transaction/domain/repositories/transaction_repo.dart';

class TransactionRepoImpl implements TransactionRepo {
  final TransactionLocalDatasource transactionLocalDatasource;
  TransactionRepoImpl({required this.transactionLocalDatasource});
  @override
  Future<void> addTransaction(TransactionEntity transaction) async {
    final transactionModel = TransactionMapper.fromEntity(transaction);
  await transactionLocalDatasource.addTransaction(transactionModel);

  }

  @override
  Future<List<TransactionEntity>> getTransactions() async {
    final models = await  transactionLocalDatasource.getTransactions();
    return models.map((model) => TransactionMapper.toEntity(model),).toList();

  }


  @override
  Future<void> deleteTransaction(int id) async {
   await transactionLocalDatasource.deleteTransaction(id);
  }


  @override
  Future<void> updateTransaction(TransactionEntity transaction) async {
    final transactionModel = TransactionMapper.fromEntity(transaction);
   await transactionLocalDatasource.updateTransaction(transactionModel);
  }


  @override
  Future<List<TransactionEntity>> getFilteredTransactions({
    DateTime? startDate,
    DateTime? endDate,
    TransactionType? type,
    String? category,
    double? minAmount,
    double? maxAmount,
  }) async {
    final models = await transactionLocalDatasource.getFilteredTransactions(
      startDate: startDate,
      endDate: endDate,
      type: type,
      category: category,
      minAmount: minAmount,
      maxAmount: maxAmount,
    );

    return models
        .map((model) => TransactionMapper.toEntity(model))
        .toList();
  }


}