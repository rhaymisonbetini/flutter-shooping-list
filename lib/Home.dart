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
  Map<String, dynamic> _ultimoJogoAtualizado = Map();
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

  void _verifyDirectionAndExecute(DismissDirection diretion, index) {
    _ultimoJogoAtualizado = _listaTarefas[index];
    if (diretion == DismissDirection.endToStart) {
      setState(() {
        _listaTarefas.removeAt(index);
      });
      _salvarArquivo();
      this.callSnackBar(index);
    }
  }

  callSnackBar(index) {
    final SnackBar snackBar = SnackBar(
      content: Text('Você desistiu deste jogo'),
      backgroundColor: Colors.blueGrey,
      action: SnackBarAction(
        label: "Desfazer",
        textColor: Colors.white,
        onPressed: () {
          setState(() {
            _listaTarefas.insert(index, _ultimoJogoAtualizado);
          });
          _salvarArquivo();
        },
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
        backgroundColor: Colors.blueGrey,
        title: Text('Playstation Story'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _listaTarefas.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  background: Container(
                    color: Colors.greenAccent,
                    padding: EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(
                          Icons.check,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                  secondaryBackground: Container(
                    color: Colors.red,
                    padding: EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                  direction: DismissDirection.horizontal,
                  key: Key(DateTime.now().microsecondsSinceEpoch.toString()),
                  child: CheckboxListTile(
                    activeColor: Colors.purple,
                    title: Text(_listaTarefas[index]['titulo']),
                    value: _listaTarefas[index]['realizada'],
                    onChanged: (valor) {
                      setState(() {
                        _listaTarefas[index]['realizada'] = valor;
                      });
                      _salvarArquivo();
                    },
                  ),
                  onDismissed: (direction) {
                    this._verifyDirectionAndExecute(direction, index);
                  },
                );
              },
            ),
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueGrey,
        foregroundColor: Colors.white,
        child: Icon(Icons.add),
        elevation: 2,
        onPressed: modalAdicionar,
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: Row(
          children: [
            IconButton(
              icon: Icon(
                Icons.gamepad,
                color: Colors.blueGrey,
              ),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
