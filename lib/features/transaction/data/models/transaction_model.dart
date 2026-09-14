import 'package:isar_community/isar.dart';
import 'package:pocket_ledger_app/features/transaction/data/enums/transaction_type.dart';

part 'transaction_model.g.dart';
@collection
class TransactionModel {
  Id id = Isar.autoIncrement;
  double amount = 0;

  @enumerated
  TransactionType type = TransactionType.expense;

  String category = '';
  String? note;
  DateTime date = DateTime.now();

}