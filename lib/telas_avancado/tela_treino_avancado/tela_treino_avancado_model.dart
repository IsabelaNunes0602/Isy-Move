import '/flutter_flow/flutter_flow_timer.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'tela_treino_avancado_widget.dart' show TelaTreinoAvancadoWidget;
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tcc_1/tela_treino_fixo/treino_model.dart';

class TelaTreinoAvancadoModel extends FlutterFlowModel<TelaTreinoAvancadoWidget> {
  // --- Timer ---
  int timerMilliseconds = 0;
  String timerValue = '00:00:00';
  FlutterFlowTimerController? timerController;

  // --- Estado ---
  bool isLoading = true;
  List<Exercicio> exerciciosGerados = [];

  @override
  void initState(BuildContext context) {
    timerController = FlutterFlowTimerController(
      StopWatchTimer(mode: StopWatchMode.countUp),
    );
  }

  @override
  void dispose() {
    timerController?.dispose();
  }

  // --- LÓGICA DO GERADOR EQUILIBRADO ---

  Future<void> gerarTreinoAleatorio(List<String> gruposSelecionados) async {
    if (gruposSelecionados.isEmpty) return;
    
    isLoading = true;
    exerciciosGerados = []; // Limpa lista anterior

    try {
      // 1. Busca TODOS os exercícios disponíveis para os grupos escolhidos
      final response = await Supabase.instance.client
          .from('exercicio')
          .select('*')
          .inFilter('grupo_muscular', gruposSelecionados);

      List<dynamic> todosExercicios = response as List<dynamic>;
      
      // 2. Organiza os exercícios em "baldes" por grupo muscular
      Map<String, List<dynamic>> mapPorGrupo = {};
      
      // Inicializa as listas
      for (var grupo in gruposSelecionados) {
        mapPorGrupo[grupo] = [];
      }
      
      // Preenche as listas
      for (var item in todosExercicios) {
        String grupoDoItem = item['grupo_muscular'];
        // Verifica se o item pertence a um dos grupos selecionados (segurança)
        if (mapPorGrupo.containsKey(grupoDoItem)) {
           mapPorGrupo[grupoDoItem]!.add(item);
        }
      }

      // 3. Embaralha cada "balde" individualmente
      mapPorGrupo.forEach((key, lista) {
        lista.shuffle();
      });

      // 4. Seleção até dar 8
      List<dynamic> listaFinal = [];
      int maxExercicios = 8;
      int index = 0;
      bool aindaTemExercicio = true;

      while (listaFinal.length < maxExercicios && aindaTemExercicio) {
        aindaTemExercicio = false;

        for (var grupo in gruposSelecionados) {
          if (listaFinal.length >= maxExercicios) break;

          List<dynamic> listaDoGrupo = mapPorGrupo[grupo] ?? [];
          
          if (index < listaDoGrupo.length) {
            listaFinal.add(listaDoGrupo[index]);
            aindaTemExercicio = true;
          }
        }
        index++; // Vai para o próximo da fila de cada grupo
      }

      // 5. Mapear para classe Exercicio
      exerciciosGerados = listaFinal.map((json) {
        return Exercicio(
          nome: json['nome_exercicio'] ?? 'Exercício',
          series: (json['quant_series'] ?? 4).toString(), 
          reps: (json['quant_reps'] ?? 12).toString(),
          descanso: '60s',
          carga: '', 
        );
      }).toList();

      debugPrint('Treino gerado EQUILIBRADO com ${exerciciosGerados.length} exercícios.');

    } catch (e) {
      debugPrint('Erro ao gerar treino aleatório: $e');
    } finally {
      isLoading = false;
    }
  }
  
  Future<Map<String, String>> carregarCargasSalvas() async {
    final Map<String, String> cargasMap = {};
    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) return {};

      final response = await Supabase.instance.client
          .from('historico_cargas')
          .select('nome_exercicio, ultima_carga')
          .eq('id_usuario', userId);

      for (var item in response) {
        cargasMap[item['nome_exercicio']] = item['ultima_carga'].toString();
      }
    } catch (e) {
      debugPrint('Erro ao carregar cargas: $e');
    }
    return cargasMap;
  }

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
    } catch (e) {
      debugPrint('Erro salvar carga: $e');
    }
  }

  Future<void> finalizarTreino() async {
    try {
      final supabase = Supabase.instance.client;
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) return;

      final dadosProgresso = await supabase
          .from('progresso')
          .select('treinos_concluidos')
          .eq('id_usuario', userId)
          .maybeSingle();

      int atual = 0;
      if (dadosProgresso != null) {
        atual = dadosProgresso['treinos_concluidos'] as int;
      }

      await supabase.from('progresso').update({
        'treinos_concluidos': atual + 1,
        'ultimo_treino_data': DateTime.now().toIso8601String(),
      }).eq('id_usuario', userId);
      
    } catch (e) {
      debugPrint('Erro finalizar: $e');
    }
  }
}