import 'dart:async';
import 'package:blog_app/src/models/post.dart';
import 'package:blog_app/src/services/apiConection.dart';
import '../models/user.dart';

class UsersBloc {
  final ApiConection apiConnection = ApiConection();

  List<User> usersList = [];
  List<Post> postsList = [];
  int usersCount = 0;

  //los controlladores y stream se encargan de generar y actualizar los datos que van dirigidos a la reenderizacion de los widgets que los consultan
  //la informacion obtenida de las consultas y de la funcion delete actualizan los controladores
  //los stream's se encargan de actualizar los widgets que los consultan
  final userListController = StreamController<List<User>>.broadcast();
  Stream<List<User>> get userListStream => userListController.stream;

  final userSelectedController = StreamController<User>.broadcast();
  Stream<User> get userSelectedStream => userSelectedController.stream;

  final userPostsController = StreamController<List<Post>>.broadcast();
  Stream<List<Post>> get userPostsStream => userPostsController.stream;

  final userCountController = StreamController<int>.broadcast();
  Stream<int> get userCountStream => userCountController.stream;

  //getters de acesso
  List<User> get userList => usersList;
  List<Post> get postList => postsList;
  int get userCount => usersCount;

  //funcion para obetner la lista de usuarios desde la api
  //actualiza el controllador para que la lista de usuarios se muestre y/o actualize en la vista de lista de usuarios
  void getUsers() async {
    try {
      final users = await apiConnection.dataFromUser();
      usersList = users;
      userListController.sink.add(usersList);
      usersCount = usersList.length;
      userCountController.sink.add(usersCount);
    } catch (e) {
      print('Error con los datos de usuario: $e');
    }
  }

  //funcion para determinar que usuario se selecciono segun su id
  //ademas obtiene y setea el valor userId para asignarlo a la funcion getUserPost
  void selectedUser(int userId) {
    apiConnection.dataFromUserPost(userId);
    getUserPost(userId);
  }

  //funcion que permite eliminar por id al usuario correspondiente
  //se actualiza el controllador para que reenderise los widgets correspondientes en este caso la vista de lista de usuarios
  void deleteUser(int userId) {
    usersList.removeWhere((user) => user.id == userId);
    userListController.sink.add(userList);

    usersCount = usersList.length;
    userCountController.sink.add(usersCount);
  }

  //funcion para obtener los post segun un userId asignado
  //actualiza el controllador para que la lista de post en la vista de detalles se reenderize segun el userId seteado
  void getUserPost(int userId) async {
    try {
      final posts = await apiConnection.dataFromUserPost(userId);
      postsList = posts;
      userPostsController.sink.add(postList);
    } catch (e) {
      print('Error al obtener los post del usuario $userId');
    }
  }

  //finalizacion de los controlladores
  void dispose() {
    userListController.close();
    userSelectedController.close();
    userPostsController.close();
  }
}

final usersBloc = UsersBloc();
