import 'package:flutter_test/flutter_test.dart';
import 'package:proj_desenv_flutter/database/TarefaDB.dart';
import 'package:proj_desenv_flutter/model/Tarefa.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() async {
  sqfliteFfiInit();

  var db = await databaseFactoryFfi.openDatabase(inMemoryDatabasePath);
  final tableName = 'tarefas';

  // Criar copia das funções que fazem CRUD no banco de dados para trocar a referência do banco de dados
  // real pelo banco de dados de teste (pacote sqflite_ffi). Esse é o motivo de não usar diretamente, no
  // teste, as funções que estão dentro da classe TarefaDB
  Future<int> create({required String titulo, required String descricao, required String localizacao,
    required String created_at}) async {
    return await db.rawInsert(
        '''INSERT INTO $tableName (titulo,descricao,localizacao,created_at) VALUES (?,?,?,?)''',
        [titulo, descricao,localizacao,created_at]
    );
  }

  Future<List<Tarefa>> fetchAll() async {
    final tarefas = await db.rawQuery(
        '''SELECT * from $tableName ORDER BY id''');
    return tarefas.map((fazer) => Tarefa.fromSqfliteDatabase(fazer)).toList();
  }

  Future<Tarefa> fetchById(int id) async {
    final todo = await db.
    rawQuery('''SELECT * from $tableName WHERE id = ?''', [id]);
    return Tarefa.fromSqfliteDatabase(todo.first);
  }

  Future<int> atualizar({required int id, String? titulo, String? descricao}) async {
    return await db.update(
      tableName,
      {
        if(titulo != null) 'titulo': titulo,
        if(descricao != null) 'descricao': descricao
      },
      where: 'id = ?',
      conflictAlgorithm: ConflictAlgorithm.rollback,
      whereArgs: [id],
    );
  }

  Future<void> deletar(int id) async {
    await db.rawDelete('''DELETE FROM $tableName WHERE id = ?''', [id]);
  }

  group("Testes do banco de dados sqflite", () {

    //__________________________________________________________________________
    test('Teste 1 - Teste de criação de tabela e insercao de valores', () async {

      TarefaDB().createTable(db);
      await create(titulo: 'Tarefa teste', descricao: "Testar o uso do pacote sqflite", localizacao: "Brasilia",
      created_at: "2024-06-20");

      expect([
        {'id': 1, 'titulo': 'Tarefa teste', 'descricao': 'Testar o uso do pacote sqflite',
          'created_at': '2024-06-20', 'localizacao': 'Brasilia'}
      ], await db.query(tableName));
      print("Valor esperado: [{id: 1, titulo: Tarefa teste, descricao: Testar o uso do pacote sqflite,"
      "created_at: 2024-06-20, localizacao: Brasilia}]\nValor obtido: ${await db.query(tableName)}");
    });

    //__________________________________________________________________________
    test('Teste 2 - Teste para obter todos os registros que estão na base de dados', () async {

      TarefaDB().createTable(db);
      await create(titulo: 'Tarefa teste', descricao: "Testar o uso do pacote sqflite", localizacao: "Brasilia",
          created_at: "2024-06-20");
      late List<Tarefa> tabela;

      await fetchAll().then((value) => tabela = value);

      expect(tabela.first.id, 1);
      print("Valor esperado: 1\nValor obtido: ${tabela.first.id}");
    });

    //__________________________________________________________________________
    test('Teste 3 - Teste para obter os registros com base em um id', () async {

      TarefaDB().createTable(db);
      await create(titulo: 'Tarefa teste1', descricao: "Testar o uso do pacote sqflite", localizacao: "Brasilia",
          created_at: "2024-06-20");
      await create(titulo: 'Tarefa teste2', descricao: "Testar o uso do pacote sqflite", localizacao: "Brasilia",
          created_at: "2024-06-20");
      late Tarefa tabela;

      await fetchById(2).then((value) => tabela = value);

      expect(tabela.id, 2);
      print("Valor esperado: 2\nValor obtido: ${tabela.id}");
    });

    //__________________________________________________________________________
    test('Teste 4 - Teste para atualizar registros no banco de dados', () async {

      TarefaDB().createTable(db);
      await create(titulo: 'Tarefa teste1', descricao: "Testar o uso do pacote sqflite", localizacao: "Brasilia",
          created_at: "2024-06-20");
      await create(titulo: 'Tarefa teste2', descricao: "Testar o uso do pacote sqflite", localizacao: "Brasilia",
          created_at: "2024-06-20");
      late Tarefa tabela;

      await atualizar(id: 1, titulo: "Tarefa teste1 - alterado");

      await fetchById(1).then((value) => tabela = value);
      expect(tabela.titulo, "Tarefa teste1 - alterado");
      print("Valor esperado: Tarefa teste1 - alterado\nValor obtido: ${tabela.titulo}");
    });

    //__________________________________________________________________________
    test('Teste 5 - Teste para deletar registros no banco de dados', () async {

      TarefaDB().createTable(db);
      await create(titulo: 'Tarefa teste1', descricao: "Testar o uso do pacote sqflite", localizacao: "Brasilia",
          created_at: "2024-06-20");
      await create(titulo: 'Tarefa teste2', descricao: "Testar o uso do pacote sqflite", localizacao: "Brasilia",
          created_at: "2024-06-20");
      late List<Tarefa> tabela;

      await deletar(1);

      await fetchAll().then((value) => tabela = value);
      expect(tabela.first.id, 2);
      print("Valor esperado: 2\nValor obtido: ${tabela.first.id}");
    });
  });
}