import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:proj_desenv_flutter/model/Tarefa.dart';
import 'package:proj_desenv_flutter/providers/TarefasProvider.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  Home({super.key});
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  List listaTarefa = [];

  var borderRadius = const BorderRadius.only(topRight: Radius.circular(20), bottomRight: Radius.circular(20),
      topLeft: Radius.circular(20), bottomLeft: Radius.circular(20));
  @override
  Widget build(BuildContext context) {

    final tarefaProvider = context.watch<TarefasProvider>();
    final excluirTarefa = tarefaProvider.excluirTarefa;

    final appBar = AppBar(
      title: Text("Lista de tarefas",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      backgroundColor: Colors.blue[200],
      automaticallyImplyLeading: false,
      actions: [
        IconButton(
          icon: Platform.isAndroid ? Icon(Icons.logout, color: Colors.black,) :
          Icon(Icons.exit_to_app, color: Colors.black,),
          onPressed: () async{
            await FirebaseAuth.instance.signOut();
            Navigator.pushNamed(context, 'login');
          },
        ),
      ]
    );
    return Scaffold(
        appBar: appBar,
        body: Padding(
            padding: EdgeInsets.all(12),
            child: FutureBuilder(
              future: tarefaProvider.listaTarefa,
              builder: (context, snapshot) {
                if(snapshot.hasData){
                  var listaTarefas = snapshot.data as List<Tarefa>;
                  return ListView.separated(
                    itemCount: listaTarefas.length,
                    itemBuilder: (context, index){
                      Tarefa tarefa = listaTarefas[index];
                      return ListTile(
                          shape: RoundedRectangleBorder(borderRadius: borderRadius),
                          minLeadingWidth: 10,
                          contentPadding: EdgeInsets.all(12),
                          title: Text(tarefa.titulo, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),),
                          subtitle: Text('${tarefa.descricao}\nLocal: ${tarefa.localizacao}\nData: ${tarefa.created_at}' ),
                          tileColor: Colors.blue[100],
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red,),
                                onPressed: () async {
                                  excluirTarefa(tarefa.id);
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.edit, color: Colors.blue,),
                                onPressed: () async {
                                  Navigator.pushNamed(context, 'update_taref',
                                      arguments: tarefa
                                  );
                                  },
                              ),
                            ],
                          )
                      );
                    }, separatorBuilder: (BuildContext context, int index) => SizedBox(
                    height: 10,
                  ),
                  );
                }
                return CircularProgressIndicator();
              },
            )
        ),
        floatingActionButton: Platform.isAndroid ?
        FloatingActionButton(
          onPressed: (){
            Navigator.pushNamed(context, 'adicionar_taref');
          },
          child: Icon(Icons.add, color: Colors.white,),
          backgroundColor: Colors.indigo[600],
        ) :
      IconButton(
        onPressed: (){
            Navigator.pushNamed(context, 'adicionar_taref');
          },
        icon: Icon(Icons.add),
        color: Colors.blue,
        iconSize: 50,
      ),
      );

  }
}
