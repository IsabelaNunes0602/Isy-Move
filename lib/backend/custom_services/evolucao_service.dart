import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';

class EvolucaoService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // 1. Atualizar Peso (Trigger no banco cria histórico)
  Future<void> atualizarPeso(double novoPeso) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return;
    
    try {
      await _supabase.from('usuario').update({
        'pesoAtual': novoPeso,
      }).eq('id_usuario', userId);
    } catch (e) {
      print('Erro ao atualizar peso: $e');
      throw Exception('Erro ao salvar peso');
    }
  }

  // 2. Atualizar Meta
  Future<void> atualizarMeta(double novaMeta) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return;

    try {
      await _supabase.from('usuario').update({
        'metaPeso': novaMeta,
      }).eq('id_usuario', userId);
    } catch (e) {
      print('Erro ao atualizar meta: $e');
      throw Exception('Erro ao salvar meta');
    }
  }

  // 3. Buscar Histórico formatado para o Gráfico
  Future<List<Map<String, dynamic>>> buscarDadosGrafico() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return [];

    try {
      final response = await _supabase
          .from('historico_peso')
          .select('peso, data_registro')
          .eq('id_usuario', userId)
          .order('data_registro', ascending: true);

      final List<dynamic> data = response;

      return data.map((item) {
        final dataOriginal = DateTime.parse(item['data_registro']).toLocal();
        return {
          'peso': (item['peso'] as num).toDouble(), // Garante que é double
          'data': DateFormat('dd/MM').format(dataOriginal),
          'data_completa': dataOriginal,
        };
      }).toList();
    } catch (e) {
      print('Erro ao buscar histórico: $e');
      return [];
    }
  }

  // 4. Buscar Meta de Peso (A função que faltava!)
  Future<double?> buscarMetaPeso() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return null;

    try {
      final response = await _supabase
        .from('usuario')
        .select('metaPeso')
        .eq('id_usuario', userId)
        .maybeSingle(); // maybeSingle evita erro se não encontrar
      
      if (response == null) return null;
      return (response['metaPeso'] as num?)?.toDouble();
    } catch (e) {
      print('Erro ao buscar meta: $e');
      return null;
    }
  }
}