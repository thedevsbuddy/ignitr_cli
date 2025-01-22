const String stub = """
import '../../../shared/shared.dart';
import '{SNAKE_MODULE}_service.dart';

class Remote{MODULE}Service extends BaseService implements {MODULE}Service {  
  @override
  Future<ApiResponse> index({required String client}) {
    // TODO: implement index
    throw UnimplementedError();
  }

  @override
  Future<ApiResponse> show({required String client, required int id}) {
    // TODO: implement show
    throw UnimplementedError();
  }

  @override
  Future<ApiResponse> store({required String client, required Map<String, dynamic> data}) {
    // TODO: implement store
    throw UnimplementedError();
  }

  @override
  Future<ApiResponse> patch({required String client, required int id, required Map<String, dynamic> data}) {
    // TODO: implement update
    throw UnimplementedError();
  }

  @override
  Future<ApiResponse> destroy({required String client, required int id}) {
    // TODO: implement destroy
    throw UnimplementedError();
  }
}
""";
