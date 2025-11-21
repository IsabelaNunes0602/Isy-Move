import 'package:tcc_1/index.dart';

import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'tela_avancado_widget.dart'; 

class TelaAvancadoModel extends FlutterFlowModel<TelaAvancadoWidget> {
  
  /// Lista para armazenar grupos musculares selecionados
  List<String> gruposSelecionados = [];

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}

  /// Métodos para adicionar/remover grupos selecionados
  void addToGruposSelecionados(String grupo) {
    if (!gruposSelecionados.contains(grupo)) {
      gruposSelecionados.add(grupo);
    }
  }

  void removeFromGruposSelecionados(String grupo) {
    gruposSelecionados.remove(grupo);
  }
}