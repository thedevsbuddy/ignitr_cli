const String stub = """
import '../../../shared/shared.dart';
import '{SNAKE_MODULE}_service.dart';
 
class Local{MODULE}Service extends BaseService implements {MODULE}Service {
  @override
  String? database = '{PLURAL_MODULE}';

  @override
  Future<ApiResponse> index({required String client}) async {
    List<Map<String, dynamic>> data = await db.get();
    return ApiResponse.success(data: data);
  }

  @override
  Future<ApiResponse> show({required String client, required int id}) async {
    Map<String, dynamic>? data = await db.where({'id': id}).first();
    return ApiResponse.success(data: data);
  }

  @override
  Future<ApiResponse> store({required String client, required Map<String, dynamic> data}) async {
    List<Map<String, dynamic>> _data = await db.store(data);
    return ApiResponse.success(data: _data);
  }

  @override
  Future<ApiResponse> patch({required String client, required int id, required Map<String, dynamic> data}) async {
    await db.where({'id': id}).update(data);
    Map<String, dynamic>? _data = await db.where({'id': id}).first();
    return ApiResponse.success(data: _data);
  }

  @override
  Future<ApiResponse> destroy({required String client, required int id}) async {
    await db.where({'id': id}).delete();
    return ApiResponse.success();
  }
}
""";
