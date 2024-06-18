import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/Tarefa.dart';
import '../providers/TarefasProvider.dart';

class UpdateTarefa extends StatelessWidget {
  UpdateTarefa({super.key});

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
            //child: Formulario(tarefaAtualiza: tarefaAtualiza),
            child: Formulario(),
          ),
        )
    );
  }
}

class Formulario extends StatefulWidget {
  const Formulario({super.key});

  @override
  State<Formulario> createState() => _UpdateTarefa();
}

class _UpdateTarefa extends State<Formulario> {

  final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    Tarefa tarefaAtualiza = ModalRoute.of(context)!.settings.arguments as Tarefa;

    final tituloController = TextEditingController(text: tarefaAtualiza.titulo);
    final descricaoController = TextEditingController(text: tarefaAtualiza.descricao);

    final tarefaProvider = context.read<TarefasProvider>();
    final atualizarTarefa = tarefaProvider.atualizarTarefa;

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
                  atualizarTarefa(tarefaAtualiza.id, titulo, descricao);
                Navigator.pushNamed(context, 'home');
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