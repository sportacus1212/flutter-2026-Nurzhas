import '../../core/api/api_client.dart';
import '../../core/api/api_exception.dart';
import 'user.dart';

class UserRepository {
  UserRepository(this._api);

  final ApiClient _api;

  Future<List<User>> getAll() async {
    try {
      final rawList = await _api.get('/users') as List<dynamic>;
      return rawList
          .map((item) => User.fromJson(item as Map<String, dynamic>))
          .toList();
    } on TypeError catch (e) {
      throw BadResponseException('users: $e');
    }
  }

  Future<User> getById(int id) async {
    try {
      final rawMap = await _api.get('/users/$id') as Map<String, dynamic>;
      return User.fromJson(rawMap);
    } on TypeError catch (e) {
      throw BadResponseException('users/$id: $e');
    }
  }

  Future<User> create(User draft) async {
    try {
      final responseMap = await _api.post(
        '/users',
        body: draft.toJson(),
      ) as Map<String, dynamic>;
      return User.fromJson(responseMap);
    } on TypeError catch (e) {
      throw BadResponseException('users post: $e');
    }
  }
}
