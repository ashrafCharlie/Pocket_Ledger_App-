import 'package:isar_community/isar.dart';
import 'package:isar_community/isar.dart';
import '../../domain/enums/transaction_type.dart';

part 'transaction_model.g.dart';

@collection
class TransactionModel {
  Id id = Isar.autoIncrement;

  @Index()
  double amount = 0;

  @enumerated
  @Index()
  TransactionType type = TransactionType.expense;

  @Index()
  String category = '';

  String? note;

  @Index()
  DateTime date = DateTime.now();
}