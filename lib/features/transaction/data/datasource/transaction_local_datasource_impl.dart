import 'package:isar_community/isar.dart';
import 'package:pocket_ledger_app/features/transaction/data/datasource/transaction_local_datasource.dart';
import 'package:pocket_ledger_app/features/transaction/data/models/transaction_model.dart';

class TransactionLocalDatasourceImpl implements TransactionLocalDatasource{
  final Isar isar;
  TransactionLocalDatasourceImpl({required this.isar});
  // @override
  // Future<void> addTransaction(TransactionModel transaction) async {
  //   await isar.writeTxn( () async {
  //     await isar.transactionModels.put(transaction);
  //   },);
  //
  //   final count = await isar.transactionModels.count();
  //   print('Total transactions: $count');
  // }
  @override
  Future<void> addTransaction(TransactionModel transaction) async {
    print('Before save - ID: ${transaction.id}');

    await isar.writeTxn(() async {
      await isar.transactionModels.put(transaction);
    });

    print('After save - ID: ${transaction.id}');

    final count = await isar.transactionModels.count();
    print('Total transactions: $count');
  }

  @override
  Future<List<TransactionModel>> getTransactions() async {
   return await isar.transactionModels.where().findAll();
  }
}