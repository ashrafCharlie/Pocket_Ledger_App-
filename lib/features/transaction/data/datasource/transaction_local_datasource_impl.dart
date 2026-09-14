import 'package:isar_community/isar.dart';
import 'package:pocket_ledger_app/features/transaction/data/datasource/transaction_local_datasource.dart';
import 'package:pocket_ledger_app/features/transaction/data/models/transaction_model.dart';

class TransactionLocalDatasourceImpl implements TransactionLocalDatasource{
  final Isar isar;
  TransactionLocalDatasourceImpl({required this.isar});
  @override
  Future<void> addTransaction(TransactionModel transaction) async {
    await isar.writeTxn( () async {
      await isar.transactionModels.put(transaction);
    },);
  }
}