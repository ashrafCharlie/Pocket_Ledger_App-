import 'package:equatable/equatable.dart';
import 'package:pocket_ledger_app/features/transaction/domain/entities/transaction_entity.dart';
import 'package:pocket_ledger_app/features/transaction/domain/enums/transaction_type.dart';

sealed class TransactionEvent extends Equatable{
   @override
  List<Object?> get props => [];
}


class AddTransactionEvent extends TransactionEvent{
  final TransactionEntity transaction;
  AddTransactionEvent({required this.transaction});
  @override
  List<Object?> get props => [transaction];
}


class GetTransactionsEvent extends TransactionEvent{}

class UpdateTransactionEvent extends TransactionEvent{
  final TransactionEntity transaction;
   UpdateTransactionEvent({required this.transaction});
}


class DeleteTransactionEvent extends TransactionEvent{
  final int id;
  DeleteTransactionEvent({required this.id});
  @override
  List<Object?> get props => [id];
}

class GetTransactionByCategoryEvent extends TransactionEvent{
  final String category;
  GetTransactionByCategoryEvent({required this.category});
   @override
  List<Object?> get props => [category];
}



class GetFilteredTransactionsEvent extends TransactionEvent {
  final DateTime? startDate;
  final DateTime? endDate;
  final TransactionType? type;
  final String? category;
  final double? minAmount;
  final double? maxAmount;

  GetFilteredTransactionsEvent({
    this.startDate,
    this.endDate,
    this.type,
    this.category,
    this.minAmount,
    this.maxAmount,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [startDate,endDate,type,category,minAmount,maxAmount];
}