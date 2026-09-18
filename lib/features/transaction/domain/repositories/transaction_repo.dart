import 'package:pocket_ledger_app/features/transaction/domain/entities/transaction_entity.dart';

abstract class  TransactionRepo {
  Future<void> addTransaction(TransactionEntity transaction);
  Future<List<TransactionEntity>> getTransactions ();
}