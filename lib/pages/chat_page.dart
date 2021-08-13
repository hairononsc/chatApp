import 'dart:io';

import 'package:chatapp/widgets/custom_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  final _textController = TextEditingController();
  final _focusNode = FocusNode();

  List<ChatMessage> _messages = [
    //  ChatMessage(
    //   uid: '123',
    //   texto: 'Hola NONITA',
    // ),
    // ChatMessage(
    //   uid: '123',
    //   texto:
    //       'Hola NONITAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA',
    // ),
    // ChatMessage(
    //   uid: '123',
    //   texto: 'Hola NONITA',
    // ),
    // ChatMessage(
    //   uid: '123',
    //   texto: 'Hola NONITA',
    // ),
    // ChatMessage(
    //   uid: '123',
    //   texto: 'Hola NONITA',
    // ),
    // ChatMessage(
    //   uid: '124',
    //   texto: 'Hola Nonito!!',
    // ),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    for (ChatMessage message in _messages) {
      message.animationController.dispose();
    }
    super.dispose();
  }

  bool _estaEscribiendo = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Column(
            children: [
              CircleAvatar(
                child: Text(
                  'Test',
                  style: TextStyle(fontSize: 12),
                ),
                backgroundColor: Colors.blueAccent,
                maxRadius: 14,
              ),
              SizedBox(
                height: 3,
              ),
              Text('Melissa Flores',
                  style: TextStyle(color: Colors.black87, fontSize: 10))
            ],
          ),
          centerTitle: true,
          elevation: 1,
        ),
        body: Container(
          child: Column(
            children: [
              Flexible(
                  child: ListView.builder(
                physics: BouncingScrollPhysics(),
                reverse: true,
                itemCount: _messages.length,
                itemBuilder: (_, i) => _messages[i],
              )),
              Divider(
                height: 1,
              ),
              // TODO: Caja de texto
              Container(
                color: Colors.white,
                // height: 100,
                child: _inputChat(),
              )
            ],
          ),
        ));
  }

  Widget _inputChat() {
    return SafeArea(
        child: Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          Flexible(
              child: TextField(
            controller: _textController,
            onSubmitted: (text) => _handleSubmit(text),
            onChanged: (texto) {
              // TODO: cuando hay un valor, para poder postear
              setState(() {
                if (texto.trim().length > 0) {
                  _estaEscribiendo = true;
                } else {
                  _estaEscribiendo = false;
                }
              });
            },
            focusNode: _focusNode,
            decoration: InputDecoration.collapsed(
              hintText: 'Enviar mensaje',
            ),
          )),
          Container(
              margin: EdgeInsets.symmetric(horizontal: 4),
              child: Platform.isIOS
                  ? CupertinoButton(
                      child: Text('Enviar'),
                      onPressed: _estaEscribiendo
                          ? () => _handleSubmit(_textController.text.trim())
                          : null,
                    )
                  : Container(
                      margin: EdgeInsets.symmetric(horizontal: 4.0),
                      child: IconTheme(
                        data: IconThemeData(
                            color: _estaEscribiendo
                                ? Colors.blue[400]
                                : Colors.grey),
                        child: IconButton(
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          disabledColor: Colors.grey[400],
                          icon: Icon(
                            Icons.send,
                            // color: Colors.blue[400],
                          ),
                          onPressed: _estaEscribiendo
                              ? () => _handleSubmit(_textController.text.trim())
                              : null,
                        ),
                      ),
                    ))
        ],
      ),
    ));
  }

  _handleSubmit(String texto) {
    if (texto.length == 0) return;
    print(texto);
    _textController.clear();
    _focusNode.requestFocus();
    final newMessage = new ChatMessage(
      animationController: AnimationController(
          vsync: this, duration: Duration(milliseconds: 400)),
      uid: '123',
      texto: texto,
    );
    _messages.insert(0, newMessage);
    newMessage.animationController.forward();
    setState(() {
      _estaEscribiendo = false;
    });
  }
}
