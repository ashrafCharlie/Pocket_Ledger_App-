import 'package:pocket_ledger_app/features/transaction/data/models/transaction_model.dart';
import 'package:pocket_ledger_app/features/transaction/domain/entities/transaction_entity.dart';

class TransactionMapper {
  static TransactionEntity toEntity(TransactionModel model){
    return TransactionEntity(
        amount: model.amount,
        type: model.type,
        category: model.category,
        note: model.note,
        date: model.date);
  }
  static TransactionModel fromEntity(TransactionEntity entity){
    final model =  TransactionModel();
    if (entity.id != null) {
      model.id = entity.id!;
    }
    model.amount = entity.amount;
    model.type = entity.type;
    model.category = entity.category;
    model.note = entity.note;
    model.date = entity.date;
    return model;
  }
}