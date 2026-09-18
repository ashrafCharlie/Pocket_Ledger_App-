import 'package:pocket_ledger_app/features/transaction/domain/enums/transaction_type.dart';

class TransactionEntity {
  final int? id;
  final double amount;
  final TransactionType type;
  final String category;
  final String? note;
  final DateTime date;
  TransactionEntity({
     this.id,
    required this.amount,
    required this.type,
    required this.category,
    this.note,
    required this.date,
});
}