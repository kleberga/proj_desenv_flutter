import 'package:flutter/material.dart';

import '../database/TarefaDB.dart';
import '../model/Tarefa.dart';

class TarefasProvider extends ChangeNotifier{

  var listaTarefa;

  Future<List<Tarefa>> carregarLista() async {
    return await TarefaDB().fetchAll();
  }

  TarefasProvider(){
    listaTarefa = carregarLista();
  }

  void addTarefa({titulo, descricao, created_at, localizacao}) async {
    await TarefaDB().create(titulo: titulo, descricao: descricao, created_at: created_at, localizacao: localizacao);
    listaTarefa = carregarLista();
    notifyListeners();
  }

  void excluirTarefa(id) async {
    await TarefaDB().delete(id);
    listaTarefa = carregarLista();
    notifyListeners();
  }

  void atualizarTarefa(id, titulo, descricao) async {
    await TarefaDB().update(id: id, titulo: titulo, descricao: descricao);
    listaTarefa = carregarLista();
    notifyListeners();
  }
}