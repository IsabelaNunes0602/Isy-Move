import 'package:tcc_1/backend/supabase/supabase.dart';

class DatabaseService {
  static final client = SupaFlow.client;

  /// Criar ou atualizar usuário no banco
  static Future<void> upsertUsuario(Map<String, dynamic> data) async {
    final response = await client
        .from('usuario')
        .upsert(data, onConflict: 'id_usuario')
        .select()
        .maybeSingle();

    if (response == null) {
      throw Exception('Erro ao inserir/atualizar usuário');
    }
  }

  /// Buscar usuário pelo ID
  static Future<Map<String, dynamic>?> getUsuario(String userId) async {
    final response = await client
        .from('usuario')
        .select()
        .eq('id_usuario', userId)
        .maybeSingle();

    return response != null ? Map<String, dynamic>.from(response) : null;
  }

  /// Obter lista de exercícios
  static Future<List<Map<String, dynamic>>> getExercicios() async {
    final response = await client.from('exercicio').select();

    if (response.isEmpty) return [];
    return List<Map<String, dynamic>>.from(response);
  }

  /// Atualizar progresso
  static Future<void> atualizarProgresso(
      String userId, int treinosConcluidos, String nivelAtual) async {
    final response = await client
        .from('progresso')
        .upsert({
          'id_usuario': userId,
          'treinos_concluidos': treinosConcluidos,
          'nivel_atual': nivelAtual,
        }, onConflict: 'id_usuario')
        .select()
        .maybeSingle();

    if (response == null) {
      throw Exception('Erro ao atualizar progresso');
    }
  }

  /// Obter treino fixo por nível
  static Future<List<Map<String, dynamic>>> getTreinosFixosPorNivel(
      String nivel) async {
    final response =
        await client.from('treinos_fixos').select().eq('nivel', nivel);

    if (response.isEmpty) return [];
    return List<Map<String, dynamic>>.from(response);
  }
}