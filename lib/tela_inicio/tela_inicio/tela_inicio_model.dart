import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';

class TelaInicioModel extends ChangeNotifier {
  int? userProgress;
  String? userLevel;

  void updateProgress(int progress) {
    userProgress = progress;
    FFAppState().progressoUsuario = progress;
    notifyListeners();
  }

  void updateUserLevel(String level) {
    userLevel = level;
    // Atualize o FFAppState ou outro estado global se necessário
    notifyListeners();
  }

  void init() {
    userProgress = FFAppState().progressoUsuario;
    userLevel = FFAppState().nivelUsuario;
  }
}