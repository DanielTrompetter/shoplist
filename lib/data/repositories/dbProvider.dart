import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoplist/data/repositories/dbinterface.dart';

final dbProvider = FutureProvider<DbInterface>((ref) async {
  return await DbInterface.create();
});
