import '/flutter_flow/flutter_flow_util.dart';
import 'tela_esqueci_senha_widget.dart' show TelaEsqueciSenhaWidget;
import 'package:flutter/material.dart';

class TelaEsqueciSenhaModel extends FlutterFlowModel<TelaEsqueciSenhaWidget> {
  
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();
  }
}