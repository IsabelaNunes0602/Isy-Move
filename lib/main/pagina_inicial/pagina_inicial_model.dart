import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PaginaInicialModel extends ChangeNotifier {
  // 1=Iniciante, 2=Intermediário, 3=Avançado
  int userLevel = 1; 
  bool isLoading = true;

  /// Inicializa o modelo buscando dados reais do banco
  Future<void> init(BuildContext context) async {
    isLoading = true;
    // Notifica para a tela mostrar o carregando...
    notifyListeners(); 

    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      
      if (userId != null) {
        // Busca quantos treinos o usuário já concluiu na tabela 'progresso'
        final response = await Supabase.instance.client
            .from('progresso')
            .select('treinos_concluidos')
            .eq('id_usuario', userId)
            .maybeSingle();

        if (response != null) {
          final treinosConcluidos = response['treinos_concluidos'] as int;
          
          // --- REGRA DE NEGÓCIO ---
          // Verifica quantos treinos foram feitos para definir o nível
          if (treinosConcluidos >= 55) {
            userLevel = 3; // Avançado (15 + 40)
          } else if (treinosConcluidos >= 15) {
            userLevel = 2; // Intermediário
          } else {
            userLevel = 1; // Iniciante
          }
          
          print("Nível calculado: $userLevel (Treinos: $treinosConcluidos)");
        }
      }
    } catch (e) {
      print('Erro ao buscar nível do usuário: $e');
      // Em caso de erro, mantém nível 1 por segurança
    } finally {
      isLoading = false;
      notifyListeners(); // Avisa a tela para atualizar os cadeados
    }
  }

  // Método auxiliar para testes manuais (se precisar)
  void updateUserLevel(int newLevel) {
    if (newLevel >= 1 && newLevel <= 3) {
      userLevel = newLevel;
      notifyListeners();
    }
  }
}