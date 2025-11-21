import '/flutter_flow/flutter_flow_util.dart';
import 'tela_evolucao_widget.dart' show TelaEvolucaoWidget;
import 'package:flutter/material.dart';

class TelaEvolucaoModel extends FlutterFlowModel<TelaEvolucaoWidget> {
  
  FocusNode? textFieldFocusNode1;
  TextEditingController? textController1; // Meta

  FocusNode? textFieldFocusNode2;
  TextEditingController? textController2; // Peso Atual

  FocusNode? textFieldFocusNode3;
  TextEditingController? textController3; // Treinos

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    textFieldFocusNode1?.dispose();
    textController1?.dispose();

    textFieldFocusNode2?.dispose();
    textController2?.dispose();

    textFieldFocusNode3?.dispose();
    textController3?.dispose();
  }
}