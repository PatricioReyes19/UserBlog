import 'package:blog_app/src/utils/routes.dart';
import 'package:dio/dio.dart';
import '../models/post.dart';
import '../models/user.dart';

class ApiConection {
  final Dio dio = Dio();

  //funcion para obtener los usuarios consultados a la consulta api
  Future<List<User>> dataFromUser() async {
    try {
      //consulta a la API de usuarios
      //se maneja con variable global por mas comodidad
      //la API que se apunta tiene la siguiente direccion https://jsonplaceholder.typicode.com/users
      final response = await dio.get(Routes.apiUrl);
      if (response.statusCode == 200) {
        //la respuesta que se obtinen se pasa a una lista de usuarios
        //y se devuele la lista de usuarios que retorna la api
        List<dynamic> userList = response.data;
        List<User> users = userList.map((user) => User.fromJson(user)).toList();
        return users;
      } else {
        throw Exception('Error conect Api');
      }
    } catch (e) {
      throw Exception('$e');
    }
  }

  Future<List<Post>> dataFromUserPost(int userId) async {
    try {
      //consulta a la API de detalles de usuario
      //por temas de error al querer usar variables globales para esta consulta se deja el link de la API
      //se debe tener en consideracion que segun el userId que se sete en la consulta los respuesta de la API varian
      final response = await dio
          .get('https://jsonplaceholder.typicode.com/users/$userId/posts');
      if (response.statusCode == 200) {
        //se convierte a una lista de Post's la respuesta obtenida desde la API
        //se retorna la lista de post's que devuelve la API
        List<dynamic> postList = response.data;
        List<Post> posts =
            postList.map((postJson) => Post.fromJson(postJson)).toList();
        return posts;
      } else {
        throw Exception('Error show post for user $userId');
      }
    } catch (e) {
      throw Exception('$e');
    }
  }
}
