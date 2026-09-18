import 'package:equatable/equatable.dart';
import 'package:pocket_ledger_app/features/transaction/domain/entities/transaction_entity.dart';

sealed class TransactionState extends Equatable{
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class TransactionInitState extends TransactionState{}

class TransactionLoadingState extends TransactionState{}

class TransactionSuccessState extends TransactionState{
}
class TransactionLoadedState extends TransactionState{
  final List<TransactionEntity> transactions;
  TransactionLoadedState({
    required this.transactions,
});
   @override
  // TODO: implement props
  List<Object?> get props => [transactions];
}

class TransactionErrorState extends TransactionState{
  final String message;
  TransactionErrorState({required this.message});
  @override
  // TODO: implement props
  List<Object?> get props => [message];
}