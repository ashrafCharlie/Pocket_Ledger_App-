import 'package:flutter/material.dart';
import '../../domain/entities/transaction_entity.dart';
import '../../domain/enums/transaction_type.dart';

class TransactionCard extends StatelessWidget {
  final TransactionEntity transaction;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final bool showActions;

  const TransactionCard({
    super.key,
    required this.transaction,
    this.onEdit,
    this.onDelete,
    this.showActions = false,
  });

  @override
  Widget build(BuildContext context) {
    final isIncome = transaction.type == TransactionType.income;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),

        // Category icon
        leading: CircleAvatar(
          child: Icon(
            transaction.type == TransactionType.expense?
                Icons.remove: Icons.add
          ),
        ),

        // Category
        title: Text(
          transaction.category,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),

        // Date + note
        subtitle: Text(
          '${transaction.date.day}/${transaction.date.month}/${transaction.date.year}'
              '${transaction.note != null ? ' • ${transaction.note}' : ''}',
        ),

        // Amount
        trailing: showActions
            ? Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${isIncome ? '+' : '-'}৳${transaction.amount.toStringAsFixed(2)}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              onPressed: onEdit,
              icon: const Icon(Icons.edit_outlined),
            ),
            IconButton(
              onPressed: onDelete,
              icon: const Icon(Icons.delete_outline),
            ),
          ],
        )
            : Text(
          '${isIncome ? '+' : '-'}৳${transaction.amount.toStringAsFixed(2)}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}