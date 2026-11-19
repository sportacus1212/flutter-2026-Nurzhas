import 'package:flutter/foundation.dart';

import '../../core/api/api_exception.dart';
import 'user.dart';
import 'user_repository.dart';

class UsersModel extends ChangeNotifier {
  UsersModel(this._repo);

  final UserRepository _repo;

  List<User> items = const [];
  ApiException? error;
  bool loading = false;
  bool isSaving = false;

  Future<void> load() async {
    loading = true;
    error = null;
    notifyListeners();

    try {
      items = await _repo.getAll();
    } on ApiException catch (e) {
      error = e;
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<bool> addUser(User draft) async {
    if (isSaving) return false;
    isSaving = true;
    notifyListeners();

    try {
      final createdUser = await _repo.create(draft);
      items = [createdUser, ...items];
      isSaving = false;
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      error = e;
      isSaving = false;
      notifyListeners();
      return false;
    }
  }
}
