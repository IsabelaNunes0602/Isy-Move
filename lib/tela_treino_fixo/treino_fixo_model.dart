import '/flutter_flow/flutter_flow_timer.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'treino_fixo_widget.dart' show TreinoFixoWidget;
import 'package:flutter/material.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class TreinoFixoModel extends FlutterFlowModel<TreinoFixoWidget> {
  // Variáveis para controlar o Cronômetro
  int timerMilliseconds = 0;
  String timerValue = '00:00:00';
  
  // Controlador do pacote stop_watch_timer
  FlutterFlowTimerController? timerController;

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
}