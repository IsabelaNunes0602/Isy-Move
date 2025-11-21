import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tcc_1/tela_treino_fixo/treino_model.dart';

class TelaInicianteModel extends ChangeNotifier {
  // Variáveis de estado
  int treinosConcluidos = 0;
  bool isLoading = true;
  
  // Lista de treinos que vem do banco
  List<Treino> listaTreinos = [];
  
  // Meta do nível iniciante
  static const int metaNivel = 15;

  /// Retorna o percentual de progresso entre 0.0 e 1.0 para a barra
  double get percentualProgresso {
    if (treinosConcluidos >= metaNivel) return 1.0;
    return treinosConcluidos / metaNivel;
  }

  /// Inicializa tudo (chama ao abrir a tela pela primeira vez)
  Future<void> init() async {
    isLoading = true;
    notifyListeners();

    try {
      // Carrega as duas coisas em paralelo para ser mais rápido
      await Future.wait([
        carregarListaTreinos(),
        atualizarProgresso(),
      ]);
    } catch (e) {
      debugPrint('Erro ao inicializar tela iniciante: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Busca o número do contador 
  Future<void> atualizarProgresso() async {
    try {
      final supabase = Supabase.instance.client;
      final userId = supabase.auth.currentUser?.id;
      
      if (userId != null) {
        // 1. Busca o Progresso do Usuário
        final responseProgresso = await supabase
            .from('progresso')
            .select('treinos_concluidos')
            .eq('id_usuario', userId)
            .maybeSingle();

        if (responseProgresso != null) {
          int valorBanco = responseProgresso['treinos_concluidos'] as int;
          // Garante que visualmente não ultrapasse a meta (ex: 16/15)
          treinosConcluidos = valorBanco > metaNivel ? metaNivel : valorBanco;
          notifyListeners(); // Atualiza a tela
        }
      }
    } catch (e) {
      debugPrint('Erro ao atualizar progresso: $e');
    }
  }

  /// Busca a lista de treinos completa (com imagens, descrições)
  Future<void> carregarListaTreinos() async {
    try {
      final supabase = Supabase.instance.client;
      
      // O Supabase v2 já retorna os dados tipados como List<Map<String, dynamic>>
      final responseTreinos = await supabase
          .from('treinos_fixos')
          .select('*')
          .eq('nivel', 'Iniciante')
          .order('nome_treino', ascending: true);
      
      listaTreinos = responseTreinos
          .map((data) => Treino.fromSupabase(data))
          .toList();
            
      debugPrint('Treinos carregados: ${listaTreinos.length}');
      
    } catch (e) {
      debugPrint('Erro ao carregar lista de treinos: $e');
    }
  }
}