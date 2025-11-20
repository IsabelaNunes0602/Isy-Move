class Exercicio {
  String nome;
  String series;
  String reps;
  String descanso;
  String carga; // Campo onde o usuário digita o peso

  Exercicio({
    required this.nome,
    required this.series,
    required this.reps,
    required this.descanso,
    this.carga = '',
  });

  // Converte o JSON do banco para o objeto Exercicio
  factory Exercicio.fromJson(Map<String, dynamic> json) {
    return Exercicio(
      nome: json['nome'] ?? 'Exercício',
      series: (json['series'] ?? 0).toString(),
      reps: (json['reps'] ?? 0).toString(),
      descanso: json['descanso'] ?? '0s',
      carga: json['carga'] ?? '',
    );
  }
}

class Treino {
  String nomeTreino;
  String nivel;
  String descricao;
  String imagemCaminho;
  List<Exercicio> exercicios;

  Treino({
    required this.nomeTreino,
    required this.nivel,
    this.descricao = '',
    this.imagemCaminho = '',
    required this.exercicios,
  });

  // Converte o dado do Supabase para o objeto Treino
  factory Treino.fromSupabase(Map<String, dynamic> data) {
    var list = data['exercicios'] as List? ?? [];
    
    // Converte a lista de JSON em lista de objetos Exercicio
    List<Exercicio> exerciciosList = list.map((i) => Exercicio.fromJson(i)).toList();

    return Treino(
      nomeTreino: data['nome_treino'] ?? 'Treino',
      nivel: data['nivel'] ?? 'Iniciante',
      descricao: data['descricao'] ?? '',
      imagemCaminho: data['imagem_caminho'] ?? '',
      exercicios: exerciciosList,
    );
  }
}