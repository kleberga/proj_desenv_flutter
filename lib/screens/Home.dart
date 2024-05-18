import 'package:flutter/material.dart';
import 'package:proj_desenv_flutter/model/Tarefa.dart';
import 'package:proj_desenv_flutter/screens/AddTarefa.dart';
import 'package:proj_desenv_flutter/screens/UpdateTarefa.dart';
import '../database/tarefa_db.dart';

class Home extends StatefulWidget {
  Home({super.key});
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
 List listaTarefa = [];
 Future<List<Tarefa>> carregarLista() async {
     return await TarefaDB().fetchAll();
 }
  void adicionarTarefa(List<Tarefa> taref){
    setState(() {
      listaTarefa = taref;
    });
  }

  var borderRadius = const BorderRadius.only(topRight: Radius.circular(20), bottomRight: Radius.circular(20),
  topLeft: Radius.circular(20), bottomLeft: Radius.circular(20));
  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: Text("Lista de tarefas",
      style: TextStyle(fontWeight: FontWeight.bold),
      ),
      backgroundColor: Colors.blue[200],
    );
    return Scaffold(
      appBar: appBar,
      body: Padding(
          padding: EdgeInsets.all(12),
          child: FutureBuilder(
            future: carregarLista(),
            builder: (context, snapshot) {
                if(snapshot.hasData){
                  var listaTarefas = snapshot.data as List<Tarefa>;
                  void atualizarDados() async {
                    await TarefaDB().fetchAll().then((value) => {
                      setState((){
                        listaTarefas = value;
                      })
                    });
                  }
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
                                await TarefaDB().delete(tarefa.id);
                                atualizarDados();
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.blue,),
                              onPressed: () async {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => UpdateTarefa(tarefaAtualiza: tarefa, adicionarTaref: adicionarTarefa,))
                                );
                                atualizarDados();
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
                // while waiting for data to arrive, show a spinning indicator
                return CircularProgressIndicator();
            },
          )
        ),
      floatingActionButton: FloatingActionButton(
          onPressed: (){
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddTarefa(adicionarTaref: adicionarTarefa,))
            );
          },
          child: Icon(Icons.add, color: Colors.white,),
        backgroundColor: Colors.indigo[600],
      ),
    );
  }
}
