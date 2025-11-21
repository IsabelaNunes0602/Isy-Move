import '/flutter_flow/flutter_flow_util.dart';
import 'tela_login_widget.dart' show TelaLoginWidget;
import 'package:flutter/material.dart';

class TelaLoginModel extends FlutterFlowModel<TelaLoginWidget> {
  
  // FocusNode e controlador para campo de Email
  FocusNode? textFieldFocusNode1;
  TextEditingController? textController1;

  // FocusNode e controlador para campo de Senha
  FocusNode? textFieldFocusNode2;
  TextEditingController? textController2;

  // Visibilidade da senha
  bool passwordVisibility = false;

  @override
  void initState(BuildContext context) {
    passwordVisibility = false;
  }

  @override
  void dispose() {
    textFieldFocusNode1?.dispose();
    textController1?.dispose();

    textFieldFocusNode2?.dispose();
    textController2?.dispose();
  }
}