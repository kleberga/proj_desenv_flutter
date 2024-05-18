
class Tarefa {
  final int id;
  final String titulo;
  final String descricao;
  final String created_at;
  final String localizacao;

  const Tarefa({
    required this.id,
    required this.titulo,
    required this.descricao,
    required this.created_at,
    required this.localizacao
  });

  factory Tarefa.fromSqfliteDatabase(Map<String, dynamic> map) => Tarefa(
      id: map['id']?.toInt() ?? 0,
      titulo: map['titulo'] ?? '',
      descricao: map['descricao'] ?? '',
      created_at: map['created_at'],
      localizacao: map['localizacao'] ?? ''
  );

  Map<String, dynamic> toMapForDb(){
    return{
      'id': id,
      'titulo': titulo,
      'descricao': descricao,
      'created_at': created_at,
      'localizacao': localizacao
    };
  }


  @override
  String toString(){
    return 'Tarefa{id: $id, titulo: $titulo, descricao: $descricao, '
        'dia/hora: $created_at, localizacao: $localizacao';
  }
}