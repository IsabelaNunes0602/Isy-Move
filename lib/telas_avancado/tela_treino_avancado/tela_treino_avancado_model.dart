import '/flutter_flow/flutter_flow_timer.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'tela_treino_avancado_widget.dart' show TelaTreinoAvancadoWidget;
import 'package:flutter/material.dart';

class TelaTreinoAvancadoModel extends FlutterFlowModel<TelaTreinoAvancadoWidget> {
  /// Campos de estado para widgets stateful nesta página.

  // Estado para o cronômetro
  final timerInitialTimeMs = 0;
  int timerMilliseconds = 0;
  String timerValue = StopWatchTimer.getDisplayTime(0, milliSecond: false);
  FlutterFlowTimerController timerController =
      FlutterFlowTimerController(StopWatchTimer(mode: StopWatchMode.countUp));

  // Controladores e focus nodes para o campo "Carga" de 6 exercícios
  // Os dados fixos 'serie' e 'repeticoes' não possuem controlador pois são apenas texto.
  // Só precisa de controladores para os campos editáveis "Carga".

  // Para maior clareza, os índices representam cada exercício na lista da tela.
  final int qntExercicios = 6;

  late List<TextEditingController> cargaTextControllers;
  late List<FocusNode> cargaFocusNodes;
  late List<String? Function(BuildContext, String?)?> cargaValidators;

  @override
  void initState(BuildContext context) {
    cargaTextControllers = List.generate(qntExercicios, (index) => TextEditingController(text: '0'));
    cargaFocusNodes = List.generate(qntExercicios, (index) => FocusNode());
    cargaValidators = List.generate(qntExercicios, (index) => (context, value) {
      if (value == null || value.isEmpty) {
        return 'Informe a carga';
      }
      final num? carga = num.tryParse(value);
      if (carga == null || carga < 0) {
        return 'Carga inválida';
      }
      return null;
    });
  }

  @override
  void dispose() {
    timerController.dispose();

    for (final controller in cargaTextControllers) {
      controller.dispose();
    }
    for (final focusNode in cargaFocusNodes) {
      focusNode.dispose();
    }
  }
}