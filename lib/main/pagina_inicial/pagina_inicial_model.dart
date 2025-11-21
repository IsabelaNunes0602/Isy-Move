import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PaginaInicialModel extends ChangeNotifier {
  // 1=Iniciante, 2=Intermediário, 3=Avançado
  int userLevel = 1; 
  bool isLoading = true;

  /// Buscando dados reais do banco
  Future<void> init(BuildContext context) async {
    isLoading = true;

    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      
      if (userId != null) {
        
        // Busca na tabela 'progresso' (onde está o contador) ---
        final response = await Supabase.instance.client
            .from('progresso')
            .select('treinos_concluidos') 
            .eq('id_usuario', userId)
            .maybeSingle();

        if (response != null) {
          // Pega o número inteiro
          final treinosConcluidos = response['treinos_concluidos'] as int;

          // --- APLICAÇÃO DA RÉGUA ---
          if (treinosConcluidos >= 55) {
            userLevel = 3; // 15 (iniciante) + 40 (intermediário) = Desbloqueia Avançado
          } else if (treinosConcluidos >= 15) {
            userLevel = 2; // Desbloqueia Intermediário
          } else {
            userLevel = 1; // Iniciante
          }
          
          debugPrint("Treinos: $treinosConcluidos -> Nível Calculado: $userLevel");
        }
      }
    } catch (e) {
      debugPrint('Erro ao buscar nível do usuário: $e');
      userLevel = 1; // Fallback seguro em caso de erro
    } finally {
      isLoading = false;
      notifyListeners(); // Atualiza a tela para remover os cadeados corretos
    }
  }
}