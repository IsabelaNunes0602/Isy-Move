import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tcc_1/tela_treino_fixo/treino_model.dart';

class TelaIntermediarioModel extends ChangeNotifier {
  int treinosConcluidos = 0;
  bool isLoading = true;
  
  // Meta cumulativa: 15 (iniciante) + 40 (intermediário) = 55
  static const int metaNivel = 55; 

  List<Treino> listaTreinos = [];

  double get percentualProgresso {
    // Se tem menos de 15, progresso é 0%
    if (treinosConcluidos < 15) return 0.0;
    
    // Calcula o progresso RELATIVO aos 40 treinos desse nível
    int progressoNivel = treinosConcluidos - 15;
    
    if (progressoNivel >= 40) return 1.0;
    return progressoNivel / 40;
  }

  Future<void> init(BuildContext context) async {
    isLoading = true;
    notifyListeners();
    try {
      // Carrega lista e progresso em paralelo
      await Future.wait([
        carregarListaTreinos(),
        atualizarProgresso(),
      ]);
    } catch (e) {
      debugPrint('Erro ao inicializar tela intermediário: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> atualizarProgresso() async {
    try {
      final supabase = Supabase.instance.client;
      final userId = supabase.auth.currentUser?.id;

      if (userId != null) {
        final responseProgresso = await supabase
            .from('progresso')
            .select('treinos_concluidos')
            .eq('id_usuario', userId)
            .maybeSingle();

        if (responseProgresso != null) {
          int valorBanco = responseProgresso['treinos_concluidos'] as int;
          treinosConcluidos = valorBanco > metaNivel ? metaNivel : valorBanco;
          notifyListeners();
        }
      }
    } catch (e) {
      debugPrint('Erro ao atualizar progresso intermediário: $e');
    }
  }

  Future<void> carregarListaTreinos() async {
    try {
      final responseTreinos = await Supabase.instance.client
          .from('treinos_fixos')
          .select('*')
          .eq('nivel', 'Intermediario') 
          .order('nome_treino', ascending: true);

      listaTreinos = responseTreinos
          .map((data) => Treino.fromSupabase(data))
          .toList();
          
      debugPrint('Treinos Intermediário carregados: ${listaTreinos.length}');
    } catch (e) {
      debugPrint('Erro ao carregar lista intermediário: $e');
    }
  }
}