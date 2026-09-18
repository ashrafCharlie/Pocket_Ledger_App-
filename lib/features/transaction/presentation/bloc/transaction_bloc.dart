import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pocket_ledger_app/features/transaction/domain/repositories/transaction_repo.dart';
import 'package:pocket_ledger_app/features/transaction/presentation/bloc/transaction_event.dart';
import 'package:pocket_ledger_app/features/transaction/presentation/bloc/transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent,TransactionState>{
  final TransactionRepo transactionRepo;
  TransactionBloc({required this.transactionRepo}): super(TransactionInitState()){
    on<AddTransactionEvent>((event, emit) async {
      emit(TransactionLoadingState());
      try{
      await  transactionRepo.addTransaction(event.transaction);
      emit(TransactionSuccessState());
      }catch(e){
        emit(TransactionErrorState(message: e.toString()));
      }
    },);

    on<GetTransactionsEvent>((event, emit) async {
      emit(TransactionLoadingState());
      try{
       final transactions = await transactionRepo.getTransactions();
       emit(TransactionLoadedState(transactions: transactions));
      }catch(e){
        emit(TransactionErrorState(message: e.toString()));
      }
    },);
  }
}