import '/flutter_flow/flutter_flow_timer.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'treino_fixo_widget.dart' show TreinoFixoWidget;
import 'package:flutter/material.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TreinoFixoModel extends FlutterFlowModel<TreinoFixoWidget> {
  // Variáveis para controlar o Cronômetro

  int timerMilliseconds = 0;
  String timerValue = '00:00:00';
  // Controlador do pacote stop_watch_timer
  FlutterFlowTimerController? timerController;

  // --- Variáveis de Estado ---
  bool isLoading = false;

  @override
  void initState(BuildContext context) {
    // Inicializa o controlador do timer para contagem progressiva
    timerController = FlutterFlowTimerController(
      StopWatchTimer(mode: StopWatchMode.countUp),
    );
  }

  @override
  void dispose() {
    timerController?.dispose();
  }

  // ---------------------------------------------------------
  // LÓGICA DO SUPABASE
  // ---------------------------------------------------------

  /// 1. Carrega as cargas que o usuário usou na última vez
  Future<Map<String, String>> carregarCargasSalvas() async {
    final Map<String, String> cargasMap = {};
    
    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) return {};

      final response = await Supabase.instance.client
          .from('historico_cargas')
          .select('nome_exercicio, ultima_carga')
          .eq('id_usuario', userId);

      // Transforma a lista do banco num Map {'Supino': '20', 'Leg Press': '100'}
      for (var item in response) {
        cargasMap[item['nome_exercicio']] = item['ultima_carga'].toString();
      }
    } catch (e) {
      debugPrint('Erro ao carregar cargas: $e');
    }
    return cargasMap;
  }

  /// 2. Salva a carga de um único exercício (Upsert)
  Future<void> salvarCargaIndividual(String nomeExercicio, String cargaValor) async {
    if (cargaValor.isEmpty) return;
    
    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) return;

      await Supabase.instance.client.from('historico_cargas').upsert(
        {
          'id_usuario': userId,
          'nome_exercicio': nomeExercicio,
          'ultima_carga': double.tryParse(cargaValor.replaceAll(',', '.')) ?? 0,
          'updated_at': DateTime.now().toIso8601String(),
        },
        onConflict: 'id_usuario, nome_exercicio',
      );
      debugPrint('Carga salva: $nomeExercicio -> $cargaValor');
    } catch (e) {
      debugPrint('Erro ao salvar carga: $e');
    }
  }

  /// 3. Finaliza o treino: Atualiza contador e verifica Level Up
  /// Retorna TRUE se o usuário subiu de nível
  Future<bool> finalizarTreino(String nivelAtualDoTreino) async {
    bool subiuDeNivel = false;
    
    try {
      final supabase = Supabase.instance.client;
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) return false;

      // A. Incrementa o contador na tabela 'progresso'
      // Primeiro buscamos o valor atual
      final dadosProgresso = await supabase
          .from('progresso')
          .select('treinos_concluidos')
          .eq('id_usuario', userId)
          .maybeSingle();

      int contagemAtual = 0;
      if (dadosProgresso != null) {
        contagemAtual = dadosProgresso['treinos_concluidos'] as int;
      }

      // Incrementa +1
      final novaContagem = contagemAtual + 1;

      await supabase.from('progresso').update({
        'treinos_concluidos': novaContagem,
        'ultimo_treino_data': DateTime.now().toIso8601String(),
      }).eq('id_usuario', userId);

      // B. Verifica se deve subir de nível (Regra de Negócio)
      // Se é Iniciante e bateu 15 -> Vira Intermediário
      if (nivelAtualDoTreino == 'Iniciante' && novaContagem >= 15) {
         // Atualiza na tabela de USUARIO
         await supabase.from('usuario').update({
           'nivel_usuario': 'intermediario'
         }).eq('id_usuario', userId);
         subiuDeNivel = true;
      }
      // Se é Intermediário e bateu 15+40=55 
      else if (nivelAtualDoTreino == 'Intermediário' && novaContagem >= 55) {
         await supabase.from('usuario').update({
           'nivel_usuario': 'avancado'
         }).eq('id_usuario', userId);
         subiuDeNivel = true;
      }

    } catch (e) {
      debugPrint('Erro ao finalizar treino: $e');
    }
    
    return subiuDeNivel;
  }
}