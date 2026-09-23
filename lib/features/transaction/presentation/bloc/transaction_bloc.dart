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

    on<DeleteTransactionEvent>((event, emit) async {
      emit(TransactionLoadingState());
      try{
      await  transactionRepo.deleteTransaction(event.id);
      final transactions = await transactionRepo.getTransactions();
      emit(TransactionLoadedState(transactions: transactions));
      }catch(e){
        emit(TransactionErrorState(message: e.toString()));
      }
    },);

    on<UpdateTransactionEvent>((event, emit) async {
      emit(TransactionLoadingState());
      try{
        await transactionRepo.updateTransaction(event.transaction);
        final transactions = await transactionRepo.getTransactions();
        emit(TransactionSuccessState());
        emit(TransactionLoadedState(transactions: transactions));
      }catch(e){
        emit(TransactionErrorState(message: e.toString()));
      }
    },);




    on<GetFilteredTransactionsEvent>((event, emit) async {
      emit(TransactionLoadingState());

      try {
        final transactions = await transactionRepo.getFilteredTransactions(
          startDate: event.startDate,
          endDate: event.endDate,
          type: event.type,
          category: event.category,
          minAmount: event.minAmount,
          maxAmount: event.maxAmount,
        );

        emit(TransactionLoadedState(transactions: transactions));
      } catch (e) {
        emit(TransactionErrorState(message: e.toString()));
      }
    });


  }
}