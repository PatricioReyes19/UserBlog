import 'package:blog_app/src/blocs/usersBloc.dart';
import 'package:flutter/material.dart';

import '../models/user.dart';

class UsersList extends StatefulWidget {
  const UsersList({Key? key}) : super(key: key);

  @override
  _UsersListState createState() => _UsersListState();
}

class _UsersListState extends State<UsersList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    usersBloc.getUsers();
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de usuarios'),
        backgroundColor: Colors.blue,
        actions: [
          Container(
            margin: EdgeInsets.all(20),
            child: StreamBuilder<int>(
              stream: usersBloc.userCountStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  int userCount = snapshot.data!;
                  return Text('$userCount');
                } else {
                  return Text('ups');
                }
              },
            ),
          )
        ],
      ),
      body: StreamBuilder<List<User>>(
        stream: usersBloc.userListStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<User> users = snapshot.data!;
            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('${(users[index].name)}'),
                  subtitle: Text(users[index].email),
                  onTap: () {
                    usersBloc.selectedUser(users[index].id);
                    Navigator.pushNamed(context, '/userDesatils');
                  },
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      usersBloc.deleteUser(users[index].id);
                    },
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Lo siento, hubo un error de conexión'),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
