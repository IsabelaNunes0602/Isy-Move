import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'tela_login_widget.dart' show TelaLoginWidget;
import 'package:flutter/material.dart';

class TelaLoginModel extends FlutterFlowModel<TelaLoginWidget> {
  /// State fields for stateful widgets in this page.

  // FocusNode e controlador para campo de Email
  FocusNode? textFieldFocusNode1;
  TextEditingController? textController1;
  String? Function(BuildContext, String?)? textController1Validator;

  // FocusNode e controlador para campo de Senha
  FocusNode? textFieldFocusNode2;
  TextEditingController? textController2;
  String? Function(BuildContext, String?)? textController2Validator;

  // Visibilidade da senha (toggle)
  late bool passwordVisibility;

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