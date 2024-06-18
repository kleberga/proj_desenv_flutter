import 'package:sqflite/sqflite.dart';
import '../model/Tarefa.dart';
import 'DatabaseService.dart';

class TarefaDB{
  final tableName = 'tarefas';
  Future<void> createTable(Database database) async {
    await database.execute("""CREATE TABLE IF NOT EXISTS $tableName(
    "id" INTEGER NOT NULL,
    "titulo" TEXT NOT NULL,
    "descricao" TEXT NOT NULL,
    "created_at" TEXT NOT NULL,
    "localizacao" TEXT,
    PRIMARY KEY ("id" AUTOINCREMENT)
    )""");
  }

  Future<int> create({required String titulo, required String descricao, required String localizacao,
  required String created_at}) async {
    final database = await DatabaseService().database;
    return await database!.rawInsert(
      '''INSERT INTO $tableName (titulo,descricao,localizacao,created_at) VALUES (?,?,?,?)''',
      [titulo, descricao,localizacao,created_at]
    );
  }

  Future<List<Tarefa>> fetchAll() async {
    final database = await DatabaseService().database;
    final tarefas = await database!.rawQuery(
      '''SELECT * from $tableName ORDER BY id''');
      return tarefas.map((fazer) => Tarefa.fromSqfliteDatabase(fazer)).toList();
  }

  Future<Tarefa> fetchById(int id) async {
    final database = await DatabaseService().database;
    final todo = await database!.
    rawQuery('''SELECT * from $tableName WHERE id = ?''', [id]);
    return Tarefa.fromSqfliteDatabase(todo.first);
  }

  Future<int> update({required int id, String? titulo, String? descricao}) async {
    final database = await DatabaseService().database;
    return await database!.update(
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

  Future<void> delete(int id) async {
    final database = await DatabaseService().database;
    await database!.rawDelete('''DELETE FROM $tableName WHERE id = ?''', [id]);
  }
}
