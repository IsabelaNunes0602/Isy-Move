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
    // Se o usuário tem menos de 15, ele ainda nem começou o intermediário tecnicamente
    if (treinosConcluidos < 15) return 0.0;
    
    // Calculamos o progresso RELATIVO aos 40 treinos desse nível
    int progressoNivel = treinosConcluidos - 15;
    
    if (progressoNivel >= 40) return 1.0;
    return progressoNivel / 40;
  }

  Future<void> init(BuildContext context) async {
    isLoading = true;
    notifyListeners();

    try {
      final supabase = Supabase.instance.client;
      final userId = supabase.auth.currentUser?.id;

      if (userId != null) {
        // 1. Busca Progresso
        final responseProgresso = await supabase
            .from('progresso')
            .select('treinos_concluidos')
            .eq('id_usuario', userId)
            .maybeSingle();

        if (responseProgresso != null) {
          int valorBanco = responseProgresso['treinos_concluidos'] as int;
          treinosConcluidos = valorBanco > metaNivel ? metaNivel : valorBanco;
        }

        // 2. Busca Treinos (Filtra por 'Intermediario')
        final responseTreinos = await supabase
            .from('treinos_fixos')
            .select('*')
            .eq('nivel', 'Intermediario') // Nota: Sem acento para bater com o SQL
            .order('nome_treino', ascending: true);

        listaTreinos = (responseTreinos as List)
            .map((data) => Treino.fromSupabase(data))
            .toList();
            
        print('Treinos Intermediário carregados: ${listaTreinos.length}');
      }
    } catch (e) {
      print('Erro ao carregar intermediário: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}