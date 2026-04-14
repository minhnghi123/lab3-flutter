import 'package:dio/dio.dart' ;

class ApiService {
  final Dio dio = Dio() ; 
  final String baseUrl = "https://69ddf309410caa3d47ba4e77.mockapi.io/nguyenminhnghi" ; 

  Future<void> send(String endpoint, Map<String,dynamic> data) async {
    try {
      final Response = await dio.post("$baseUrl/$endpoint", data: data) ;
    } catch (e) {
      throw Exception("Error happens : $e" ) ;
      print("Dio error : $e") ; 
    }
  }
}
