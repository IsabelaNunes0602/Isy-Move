import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
// Importa o modelo de dados Treino
import 'package:tcc_1/tela_treino_fixo/treino_model.dart'; 

class TelaInicianteModel extends ChangeNotifier {
  // Variáveis de estado
  int treinosConcluidos = 0;
  bool isLoading = true;
  
  // NOVA PROPRIEDADE: Lista de treinos que será preenchida pelo banco
  List<Treino> listaTreinos = [];
  
  // Meta do nível iniciante
  static const int metaNivel = 15;

  /// Retorna o percentual de progresso entre 0.0 e 1.0
  double get percentualProgresso {
    if (treinosConcluidos >= metaNivel) return 1.0;
    return treinosConcluidos / metaNivel;
  }

  /// Inicializa buscando os dados do banco
  Future<void> init(BuildContext context) async {
    isLoading = true;
    notifyListeners();

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
          treinosConcluidos = valorBanco > metaNivel ? metaNivel : valorBanco;
        }

        // 2. Busca a Lista de Treinos do Nível 'Iniciante'
        final responseTreinos = await supabase
            .from('treinos_fixos')
            .select('*') // Seleciona todas as colunas
            .eq('nivel', 'Iniciante') // Filtra apenas treinos de iniciante
            .order('nome_treino', ascending: true); // Ordena alfabeticamente
        
        // Converte a resposta (List<Map>) para List<Treino> usando o factory do modelo
        listaTreinos = (responseTreinos as List)
            .map((data) => Treino.fromSupabase(data))
            .toList();
            
        print('Treinos carregados: ${listaTreinos.length}');
      }
    } catch (e) {
      print('Erro ao carregar dados da tela iniciante: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}