import 'package:tcc_1/index.dart';

import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';

class TelaAvancadoModel extends FlutterFlowModel<TelaAvancadoWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for mouseRegionPeito widget.
  bool mouseRegionPeitoHovered = false;
  // State field(s) for mouseRegionCostas widget.
  bool mouseRegionCostasHovered = false;
  // State field(s) for mouseRegionBiceps widget.
  bool mouseRegionBicepsHovered = false;
  // State field(s) for mouseRegionTriceps widget.
  bool mouseRegionTricepsHovered = false;
  // State field(s) for mouseRegionOmbros widget.
  bool mouseRegionOmbrosHovered = false;
  // State field(s) for mouseRegionPernas widget.
  bool mouseRegionPernasHovered = false;
  // State field(s) for mouseRegionGluteos widget.
  bool mouseRegionGluteosHovered = false;
  // State field(s) for mouseRegionAbdomen widget.
  bool mouseRegionAbdomenHovered = false;

  /// Lista para armazenar grupos musculares selecionados
  List<String> gruposSelecionados = [];

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}

  /// Métodos para adicionar/remover grupos selecionados
  void addToGruposSelecionados(String grupo) {
    gruposSelecionados.add(grupo);
  }

  void removeFromGruposSelecionados(String grupo) {
    gruposSelecionados.remove(grupo);
  }
}