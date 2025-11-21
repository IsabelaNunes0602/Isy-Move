import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'deletar_conta_widget.dart' show DeletarContaWidget;
import 'package:flutter/material.dart';

class DeletarContaModel extends FlutterFlowModel<DeletarContaWidget> {
  
  FormFieldController<List<String>>? checkboxGroupValueController;

  List<String>? get checkboxGroupValues => checkboxGroupValueController?.value;
  set checkboxGroupValues(List<String>? values) =>
      checkboxGroupValueController?.value = values;

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