import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'tela_esqueci_senha_widget.dart' show TelaEsqueciSenhaWidget;
import 'package:flutter/material.dart';

class TelaEsqueciSenhaModel extends FlutterFlowModel<TelaEsqueciSenhaWidget> {
  /// Controlador e focus para o campo de e-mail
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;

  /// Validator do e-mail
  String? Function(BuildContext, String?)? textControllerValidator;

  /// Chave do formulário para validação
  final formKey = GlobalKey<FormState>();

  @override
  void initState(BuildContext context) {
    textFieldFocusNode = FocusNode();
    textController ??= TextEditingController();

    // Validator simples para e-mail
    textControllerValidator = (context, value) {
      if (value == null || value.isEmpty) {
        return 'Por favor, digite seu e-mail';
      }
      return null;
    };
  }

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();
  }
}