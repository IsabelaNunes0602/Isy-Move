import 'package:tcc_1/flutter_flow/flutter_flow_timer.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'iniciante_treino_a_widget.dart' show InicianteTreinoAWidget;
import 'package:flutter/material.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class InicianteTreinoAModel extends FlutterFlowModel<InicianteTreinoAWidget> {
  /// Controladores para os campos de carga dos 6 exercícios
  late List<TextEditingController> cargaTextControllers;

  /// Quantidade dos exercícios (definido para 6 conforme tela)
  final int exerciciosCount = 6;

  /// Estado para o cronômetro - tempo decorrido em milissegundos
  int timerMilliseconds = 0;

  /// Valor exibido do cronômetro
  String timerValue = '00:00:00';

  /// Inicializador do cronômetro (flutter_flow_timer utiliza FlutterFlowTimerController)
  FlutterFlowTimerController? timerController;

  @override
void initState(BuildContext context) {
  cargaTextControllers = List.generate(exerciciosCount, (_) => TextEditingController(text: '0'));

  timerController = FlutterFlowTimerController(
    StopWatchTimer(mode: StopWatchMode.countUp),
  );
}

  @override
  void dispose() {
    // Limpa os controladores para evitar vazamento de memória
    for (final controller in cargaTextControllers) {
      controller.dispose();
    }

    timerController?.dispose();
  }

  /// Atualiza o valor do cronômetro para exibir
  void updateTimerValue(int milliseconds, String displayTime) {
    timerMilliseconds = milliseconds;
    timerValue = displayTime;
  }
}