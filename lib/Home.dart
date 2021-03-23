import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';

class Home extends StatefulWidget {
  @override
  _Home createState() => _Home();
}

class _Home extends State<Home> {
  @override
  void initState() {
    super.initState();
    _lerArquivo().then((dados) {
      setState(() {
        _listaTarefas = json.decode(dados);
      });
    });
  }

  List _listaTarefas = [];
  TextEditingController _controllerTarefa = TextEditingController();

  Future<File> _getFile() async {
    final diretorio = await getApplicationDocumentsDirectory();
    var arquivo = File("${diretorio.path}/dados.json");
    return arquivo;
  }

  _salvarTarefa() {
    String novoProduto = _controllerTarefa.text;
    Map<String, dynamic> tarefa = Map();
    tarefa['titulo'] = novoProduto;
    tarefa['realizada'] = false;
    setState(() {
      _listaTarefas.add(tarefa);
    });
    _salvarArquivo();
    _controllerTarefa.text = "";
  }

  _salvarArquivo() async {
    var arquivo = await this._getFile();
    String dados = json.encode(_listaTarefas);
    arquivo.writeAsStringSync(dados);
  }

  _lerArquivo() async {
    try {
      var arquivo = await this._getFile();
      return arquivo.readAsString();
    } catch (e) {
      return null;
    }
  }

  void modalAdicionar() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Adicionar produto'),
          content: TextField(
            controller: _controllerTarefa,
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
                _salvarTarefa();
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
                return CheckboxListTile(
                  activeColor: Colors.purple,
                  title: Text(_listaTarefas[index]['titulo']),
                  value: _listaTarefas[index]['realizada'],
                  onChanged: (valor) {
                    setState(() {
                      _listaTarefas[index]['realizada'] = valor;
                    });
                    _salvarArquivo();
                  },
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
