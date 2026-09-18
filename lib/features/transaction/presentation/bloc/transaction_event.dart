import 'package:equatable/equatable.dart';
import 'package:pocket_ledger_app/features/transaction/domain/entities/transaction_entity.dart';

sealed class TransactionEvent extends Equatable{
   @override
  // TODO: implement props
  List<Object?> get props => [];
}

class AddTransactionEvent extends TransactionEvent{
  final TransactionEntity transaction;
  AddTransactionEvent({required this.transaction});
  @override
  // TODO: implement props
  List<Object?> get props => [transaction];
}

class GetTransactionsEvent extends TransactionEvent{}