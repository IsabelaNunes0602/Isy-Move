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

  List<String> _musculosSelecionados = [];
  List<String> get musculosSelecionados => _musculosSelecionados;
  set musculosSelecionados(List<String> value) {
    _musculosSelecionados = value;
  }

  void addToMusculosSelecionados(String value) {
    musculosSelecionados.add(value);
  }

  void removeFromMusculosSelecionados(String value) {
    musculosSelecionados.remove(value);
  }

  void removeAtIndexFromMusculosSelecionados(int index) {
    musculosSelecionados.removeAt(index);
  }

  void updateMusculosSelecionadosAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    musculosSelecionados[index] = updateFn(_musculosSelecionados[index]);
  }

  void insertAtIndexInMusculosSelecionados(int index, String value) {
    musculosSelecionados.insert(index, value);
  }

  double _metaPeso = 0.0;
  double get metaPeso => _metaPeso;
  set metaPeso(double value) {
    _metaPeso = value;
  }

  String _nivelUsuario = '';
  String get nivelUsuario => _nivelUsuario;
  set nivelUsuario(String value) {
    _nivelUsuario = value;
  }

  double _pesoAtual = 0.0;
  double get pesoAtual => _pesoAtual;
  set pesoAtual(double value) {
    _pesoAtual = value;
  }

  double _percentualProgresso = 0.0;
  double get percentualProgresso => _percentualProgresso;
  set percentualProgresso(double value) {
    _percentualProgresso = value;
  }

  int _progressoUsuario = 0;
  int get progressoUsuario => _progressoUsuario;
  set progressoUsuario(int value) {
    _progressoUsuario = value;
  }
}
