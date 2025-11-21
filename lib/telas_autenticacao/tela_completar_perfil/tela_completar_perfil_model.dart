import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'package:flutter/material.dart';

import 'tela_completar_perfil_widget.dart'
    show TelaCompletarPerfilWidget;

class TelaCompletarPerfilModel
    extends FlutterFlowModel<TelaCompletarPerfilWidget> {
  TextEditingController? nomeController;
  TextEditingController? telefoneController;
  TextEditingController? dataController;
  TextEditingController? pesoController;

  FocusNode? nomeFocus;
  FocusNode? telefoneFocus;
  FocusNode? dataFocus;
  FocusNode? pesoFocus;

  // --- RADIO BUTTONS ---
  FormFieldController<String>? generoController;
  FormFieldController<String>? nivelController;

  String? get generoSelecionado => generoController?.value;
  String? get nivelSelecionado => nivelController?.value;

  @override
  void dispose() {
    nomeController?.dispose();
    telefoneController?.dispose();
    dataController?.dispose();
    pesoController?.dispose();

    nomeFocus?.dispose();
    telefoneFocus?.dispose();
    dataFocus?.dispose();
    pesoFocus?.dispose();
  }
  
  @override
  void initState(BuildContext context) {}
}
