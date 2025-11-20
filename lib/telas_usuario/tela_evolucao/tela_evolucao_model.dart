import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'tela_evolucao_widget.dart' show TelaEvolucaoWidget;
import 'package:flutter/material.dart';

class TelaEvolucaoModel extends FlutterFlowModel<TelaEvolucaoWidget> {
  /// Campos de estado para widgets controlados na página.

  // Campo Meta
  FocusNode? textFieldFocusNode1;
  TextEditingController? textController1;
  String? Function(BuildContext, String?)? textController1Validator;

  // Campo Peso Atual
  FocusNode? textFieldFocusNode2;
  TextEditingController? textController2;
  String? Function(BuildContext, String?)? textController2Validator;

  // Campo Contagem de treinos
  FocusNode? textFieldFocusNode3;
  TextEditingController? textController3;
  String? Function(BuildContext, String?)? textController3Validator;

  @override
  void initState(BuildContext context) {
    // Meta
    textFieldFocusNode1 = FocusNode();
    textController1 ??= TextEditingController();
    textController1Validator = (context, value) {
      if (value == null || value.isEmpty) {
        return 'Digite a meta de peso';
      }
      double? peso = double.tryParse(value);
      if (peso == null || peso <= 0) {
        return 'Informe uma meta válida maior que zero';
      }
      return null;
    };

    // Peso Atual
    textFieldFocusNode2 = FocusNode();
    textController2 ??= TextEditingController();
    textController2Validator = (context, value) {
      if (value == null || value.isEmpty) {
        return 'Digite o peso atual';
      }
      double? pesoAtual = double.tryParse(value);
      if (pesoAtual == null || pesoAtual <= 0) {
        return 'Informe um peso válido maior que zero';
      }
      return null;
    };

    // Contagem de treinos (não editável, mas mantida aqui)
    textFieldFocusNode3 = FocusNode();
    textController3 ??= TextEditingController();
    textController3Validator = (context, value) {
      if (value == null || value.isEmpty) {
        return 'Informe a contagem de treinos';
      }
      int? treinCount = int.tryParse(value);
      if (treinCount == null || treinCount < 0) {
        return 'Informe um número válido de treinos';
      }
      return null;
    };
  }

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