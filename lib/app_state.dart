import 'package:flutter/material.dart';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  Future initializePersistedState() async {}

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  List<String> musculosSelecionados = [];

  double metaPeso = 0.0;

  String nivelUsuario = '';

  double pesoAtual = 0.0;

  double percentualProgresso = 0.0;

  int progressoUsuario = 0;

  // --- Métodos Auxiliares ---

  void addToMusculosSelecionados(String value) {
    musculosSelecionados.add(value);
    notifyListeners(); 
  }

  void removeFromMusculosSelecionados(String value) {
    musculosSelecionados.remove(value);
    notifyListeners();
  }

  void removeAtIndexFromMusculosSelecionados(int index) {
    musculosSelecionados.removeAt(index);
    notifyListeners();
  }

  void updateMusculosSelecionadosAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    musculosSelecionados[index] = updateFn(musculosSelecionados[index]);
    notifyListeners();
  }

  void insertAtIndexInMusculosSelecionados(int index, String value) {
    musculosSelecionados.insert(index, value);
    notifyListeners();
  }
}