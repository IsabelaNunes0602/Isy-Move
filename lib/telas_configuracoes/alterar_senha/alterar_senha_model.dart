import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'alterar_senha_widget.dart' show AlterarSenhaWidget;
import 'package:flutter/material.dart';

class AlterarSenhaModel extends FlutterFlowModel<AlterarSenhaWidget> {
  /// Chave do formulário para validação
  final formKey = GlobalKey<FormState>();

  /// Controladores, focos e variáveis de visibilidade para os campos
  FocusNode? textFieldFocusNode1;
  TextEditingController? textController1;
  bool passwordVisibility1 = false;
  String? Function(BuildContext, String?)? textController1Validator;

  FocusNode? textFieldFocusNode2;
  TextEditingController? textController2;
  bool passwordVisibility2 = false;
  String? Function(BuildContext, String?)? textController2Validator;

  FocusNode? textFieldFocusNode3;
  TextEditingController? textController3;
  bool passwordVisibility3 = false;
  String? Function(BuildContext, String?)? textController3Validator;

  @override
  void initState(BuildContext context) {
    // Inicializa as variáveis de visibilidade da senha
    passwordVisibility1 = false;
    passwordVisibility2 = false;
    passwordVisibility3 = false;

    // Validador para a senha atual
    textController1Validator = (context, value) {
      if (value == null || value.isEmpty) {
        return 'Informe sua senha atual';
      }
      return null;
    };

    // Validador para a nova senha com regras de complexidade
    textController2Validator = (context, value) {
      if (value == null || value.isEmpty) {
        return 'Informe a nova senha';
      }
      if (value.length < 8) {
        return 'Senha deve ter ao menos 8 caracteres';
      }
      final uppercase = RegExp(r'[A-Z]');
      final lowercase = RegExp(r'[a-z]');
      final number = RegExp(r'[0-9]');
      final specialChar = RegExp(r'[!@#\$&*~%^\-_+=]');

      if (!uppercase.hasMatch(value)) {
        return 'Inclua ao menos uma letra maiúscula';
      }
      if (!lowercase.hasMatch(value)) {
        return 'Inclua ao menos uma letra minúscula';
      }
      if (!number.hasMatch(value)) {
        return 'Inclua ao menos um número';
      }
      if (!specialChar.hasMatch(value)) {
        return 'Inclua ao menos um caractere especial (!@#\$&*~%^-_+=)';
      }
      return null;
    };

    // Validador para confirmação de senha confirmando igualdade com a nova senha
    textController3Validator = (context, value) {
      if (value == null || value.isEmpty) {
        return 'Confirme a nova senha';
      }
      if (value != textController2?.text) {
        return 'As senhas não coincidem';
      }
      return null;
    };
  }

  @override
  void dispose() {
    // Limpeza dos controladores e focos para evitar vazamentos de memória
    textFieldFocusNode1?.dispose();
    textController1?.dispose();

    textFieldFocusNode2?.dispose();
    textController2?.dispose();

    textFieldFocusNode3?.dispose();
    textController3?.dispose();
  }
}