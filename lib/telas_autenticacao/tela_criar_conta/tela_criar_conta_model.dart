import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'tela_criar_conta_widget.dart' show TelaCriarContaWidget;
import 'package:flutter/material.dart';


class TelaCriarContaModel extends FlutterFlowModel<TelaCriarContaWidget> {
  
  // Controladores e focus nodes para campo Email
  FocusNode? emailFocusNode;
  TextEditingController? emailController;
  String? Function(BuildContext, String?)? emailValidator;

  // Controladores e focus nodes para campo Senha
  FocusNode? senhaFocusNode;
  TextEditingController? senhaController;
  bool passwordVisibility = false;
  String? Function(BuildContext, String?)? senhaValidator;

  // Controladores e focus nodes para campo Confirmar Senha
  FocusNode? confirmarSenhaFocusNode;
  TextEditingController? confirmarSenhaController;
  bool confirmarPasswordVisibility = false;
  String? Function(BuildContext, String?)? confirmarSenhaValidator;

  @override
  void initState(BuildContext context) {
    emailFocusNode = FocusNode();
    senhaFocusNode = FocusNode();
    confirmarSenhaFocusNode = FocusNode();

    emailController ??= TextEditingController();
    senhaController ??= TextEditingController();
    confirmarSenhaController ??= TextEditingController();

    passwordVisibility = false;
    confirmarPasswordVisibility = false;

    // Validadores customizados
    emailValidator = (context, value) {
      if (value == null || value.isEmpty) {
        return 'Por favor, digite o email';
      }
      if (!value.contains('@')) {
        return 'Digite um email válido';
      }
      return null;
    };

    senhaValidator = (context, value) {
      if (value == null || value.isEmpty) {
        return 'Por favor, digite a senha';
      }
      if (value.length < 8) {
        return 'A senha deve ter ao menos 8 caracteres';
      }
      if (!RegExp(r'[A-Z]').hasMatch(value)) {
        return 'A senha deve conter letra maiúscula';
      }
      if (!RegExp(r'[a-z]').hasMatch(value)) {
        return 'A senha deve conter letra minúscula';
      }
      if (!RegExp(r'[0-9]').hasMatch(value)) {
        return 'A senha deve conter número';
      }
      if (!RegExp(r'[!@#\$&*~%^\-_+=]').hasMatch(value)) {
        return 'A senha deve conter caractere especial (!@#\$&*~%^-_+=)';
      }
      return null;
    };

    confirmarSenhaValidator = (context, value) {
      if (value == null || value.isEmpty) {
        return 'Confirme sua senha';
      }
      if (value != senhaController?.text) {
        return 'As senhas não coincidem';
      }
      return null;
    };
  }

  @override
  void dispose() {
    emailFocusNode?.dispose();
    emailController?.dispose();

    senhaFocusNode?.dispose();
    senhaController?.dispose();

    confirmarSenhaFocusNode?.dispose();
    confirmarSenhaController?.dispose();
  }
}