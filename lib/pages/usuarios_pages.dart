import 'package:animate_do/animate_do.dart';
import 'package:chatapp/models/usuario.dart';
import 'package:chatapp/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class UsuariosPage extends StatefulWidget {
  @override
  _UsuariosPageState createState() => _UsuariosPageState();
}

class _UsuariosPageState extends State<UsuariosPage> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  final usuarios = [
    Usuario(
        uid: '1',
        nombre: 'Maria La loca',
        email: 'test1@test.com',
        online: true),
    Usuario(
        uid: '2',
        nombre: 'Melissa La loca',
        email: 'test2@test.com',
        online: true),
    Usuario(
        uid: '3',
        nombre: 'Jordan La loca',
        email: 'test3@test.com',
        online: false),
  ];
  @override
  Widget build(BuildContext context) {
    final authServices = Provider.of<AuthService>(context);
    final usuario = authServices.usuario;
    return Scaffold(
        appBar: AppBar(
          title: Text(
            '${usuario.nombre}',
            style: TextStyle(color: Colors.black54),
          ),
          elevation: 1,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(
              Icons.exit_to_app,
              color: Colors.black54,
            ),
            onPressed: () {
              // TODO: Desconectarnos del socket server
              Navigator.pushReplacementNamed(context, "login");
              AuthService.deleteToken();
            },
          ),
          actions: [
            Container(
              margin: EdgeInsets.only(right: 10),
              child: Icon(
                Icons.check_circle,
                color: Colors.blue[400],
              ),
              // child: Icon(
            )
          ],
        ),
        body: SmartRefresher(
          controller: _refreshController,
          enablePullDown: true,
          header: WaterDropHeader(
            complete: Icon(
              Icons.check,
              color: Colors.blue[400],
            ),
            waterDropColor: Color(0xff457878),
          ),
          onRefresh: () => _cargarUsuarios(),
          child: _listViewUsuarios(),
        ));
  }

  ListView _listViewUsuarios() {
    return ListView.separated(
      physics: BouncingScrollPhysics(),
      separatorBuilder: (_, i) => Divider(),
      itemCount: usuarios.length,
      itemBuilder: (_, i) => _usuarioListTile(usuarios[i]),
    );
  }

  ListTile _usuarioListTile(Usuario usuario) {
    return ListTile(
        title: Text(usuario.nombre),
        subtitle: Text(usuario.email),
        leading: Stack(
          children: [
            CircleAvatar(
              child: Text(
                usuario.nombre.substring(0, 2),
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.blue[400],
            ),
            Container(
              height: 12,
              width: 12,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: usuario.online ? Colors.green : Colors.red[400],
              ),
            )
          ],
          // child:
        ),
        trailing: Stack(
          children: [
            Icon(
              Icons.chat,
              color: Colors.black54,
              size: 35,
            ),
            Positioned(
              right: 0,
              child: BounceInDown(
                child: Container(
                  alignment: Alignment.center,
                  height: 16,
                  width: 16,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: usuario.online ? Colors.green : Colors.red[400],
                  ),
                  child: Text('1',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: Colors.white)),
                ),
              ),
            )
          ],
        )
        // Container(
        //     width: 15,
        //     height: 15,
        //     decoration: BoxDecoration(
        //         color: usuarios[i].online
        //             ? Colors.green[300]
        //             : Colors.red[400],
        //         borderRadius: BorderRadius.circular(100))),
        );
  }

  _cargarUsuarios() async {
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }
}
