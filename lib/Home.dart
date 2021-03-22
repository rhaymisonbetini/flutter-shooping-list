import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _Home createState() => _Home();
}

class _Home extends State<Home> {
  List _listaTarefas = ['Arroz', 'Feijao', 'Macarrão'];

  void modalAdicionar() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Adicionar produto'),
          content: TextField(
            decoration: InputDecoration(labelText: "Inserir nome do produto"),
            onChanged: (text) {},
          ),
          actions: [
            // ignore: deprecated_member_use
            FlatButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancelar"),
              color: Colors.redAccent,
            ),
            // ignore: deprecated_member_use
            FlatButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Adicionar"),
              color: Colors.purple,
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text('Cadastre sua lista de compras'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _listaTarefas.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_listaTarefas[index]),
                );
              },
            ),
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        icon: Icon(Icons.add_shopping_cart),
        label: Text('Adicionar'),
        elevation: 2,
        onPressed: modalAdicionar,
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: [
            IconButton(
              icon: Icon(
                Icons.exit_to_app,
                color: Colors.purple,
              ),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
