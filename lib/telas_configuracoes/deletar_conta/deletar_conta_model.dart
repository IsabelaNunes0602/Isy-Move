import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'deletar_conta_widget.dart' show DeletarContaWidget;
import 'package:flutter/material.dart';

class DeletarContaModel extends FlutterFlowModel<DeletarContaWidget> {
  /// Controlador e estado para grupo de checkboxes
  FormFieldController<List<String>>? checkboxGroupValueController;

  List<String>? get checkboxGroupValues => checkboxGroupValueController?.value;
  set checkboxGroupValues(List<String>? values) =>
      checkboxGroupValueController?.value = values;

  /// Controlador e foco para o campo de texto onde o usuário explica o motivo
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;

  /// Validador para o campo texto
  String? Function(BuildContext, String?)? textControllerValidator;

  @override
  void initState(BuildContext context) {
    // Defina um validador simples para o campo texto, se desejar
    textControllerValidator = (context, value) {
      if (value == null || value.isEmpty) {
        return 'Por favor, descreva o motivo';
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