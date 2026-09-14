import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pocket_ledger_app/features/transaction/data/models/transaction_model.dart';

class IsarDatabase {
  IsarDatabase._();
  static Future<Isar> open() async {
    final dir = await getApplicationDocumentsDirectory();
    return Isar.open([TransactionModelSchema], directory: dir.path );
  }
}