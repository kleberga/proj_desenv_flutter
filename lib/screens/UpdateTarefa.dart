import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../database/tarefa_db.dart';
import '../model/Tarefa.dart';
import 'Home.dart';

class UpdateTarefa extends StatelessWidget {
  UpdateTarefa({super.key, required this.tarefaAtualiza, required this.adicionarTaref});

  final Tarefa tarefaAtualiza;
  final Function adicionarTaref;

  @override
  Widget build(BuildContext context) {

    final appBar = AppBar(
      title: Text("Atualizar tarefa",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      backgroundColor: Colors.blue[200],
    );

    return Scaffold(
        appBar: appBar,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(12, 20, 12, 20),
            child: Formulario(tarefaAtualiza: tarefaAtualiza, adicionarTaref: adicionarTaref),
          ),
        )
    );
  }
}

class Formulario extends StatefulWidget {
  const Formulario({super.key, required this.tarefaAtualiza, required this.adicionarTaref});

  final Tarefa tarefaAtualiza;
  final Function adicionarTaref;

  @override
  State<Formulario> createState() => _UpdateTarefa(tarefaAtualiza: tarefaAtualiza, adicionarTaref: adicionarTaref);
}

class _UpdateTarefa extends State<Formulario> {

  _UpdateTarefa({required this.tarefaAtualiza, required this.adicionarTaref});

  final Tarefa tarefaAtualiza;
  final Function adicionarTaref;

  final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    final tituloController = TextEditingController(text: tarefaAtualiza.titulo);
    final descricaoController = TextEditingController(text: tarefaAtualiza.descricao);

    return Form(
      key: _formKey2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            controller: tituloController,
            decoration: const InputDecoration(
                label: Text('Título', style: TextStyle(fontSize: 20),),
                border: OutlineInputBorder()
            ),
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Informe o título da tarefa';
              }
              return null;
            },
          ),
          Padding(padding: EdgeInsets.fromLTRB(0, 20, 0, 0)),
          TextFormField(
            controller: descricaoController,
            decoration: const InputDecoration(
                label: Text('Descrição', style: TextStyle(fontSize: 20),),
                border: OutlineInputBorder()
            ),
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Informe a descrição da tarefa';
              }
              return null;
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: () async {
                String titulo;
                String descricao;
                if (_formKey2.currentState!.validate()) {
                  titulo = tituloController.text;
                  descricao = descricaoController.text;

                  DateTime agora = DateTime.now();
                  var formatter = DateFormat('dd/MM/yyyy');
                  String formattedDate = formatter.format(agora).toString();

                  await TarefaDB().update(id: tarefaAtualiza.id, titulo: titulo, descricao: descricao);

                  List listaAux = await TarefaDB().fetchAll();

                  adicionarTaref(listaAux);
                  print(formattedDate);
                  Navigator.pop(
                      context,
                      MaterialPageRoute(builder: (context) => Home())
                  );
                };
              },
              child: const Text('Enviar'),
            ),
          ),
        ],
      ),
    );
  }
}