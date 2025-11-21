import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/flutter_flow_checkbox_group.dart';
import '/flutter_flow/form_field_controller.dart';

import 'package:tcc_1/componentes/aviso_deletar_conta_widget.dart';

import 'deletar_conta_model.dart';
export 'deletar_conta_model.dart';

class DeletarContaWidget extends StatefulWidget {
  const DeletarContaWidget({super.key});

  static const String routeName = 'DeletarConta';
  static const String routePath = '/deletarConta';

  @override
  State<DeletarContaWidget> createState() => _DeletarContaWidgetState();
}

class _DeletarContaWidgetState extends State<DeletarContaWidget> {
  late DeletarContaModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => DeletarContaModel());

    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Widget _buildCheckboxes() {
    return FlutterFlowCheckboxGroup(
      options: const [
        'Não é o que eu imaginava',
        'Não consegui mexer',
        'Outros',
      ],
      onChanged: (val) => setState(() => _model.checkboxGroupValues = val),
      controller: _model.checkboxGroupValueController ??= FormFieldController<List<String>>([]),
      activeColor: const Color(0xC58910F0),
      checkColor: Colors.white,
      checkboxBorderColor: Colors.grey,
      textStyle: GoogleFonts.nunito(
            color: Colors.black,
            fontSize: 16,
          ),
      checkboxBorderRadius: BorderRadius.circular(4),
      initialized: _model.checkboxGroupValues != null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: const Color(0xC58910F0),
          automaticallyImplyLeading: false,
          leading: FlutterFlowIconButton(
            borderColor: Colors.transparent,
            borderRadius: 30,
            borderWidth: 1,
            buttonSize: 60,
            icon: const Icon(Icons.arrow_back_rounded, size: 30, color: Colors.white),
            onPressed: () => context.pop(),
          ),
          title: Text(
            'Deletar Conta',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  font: GoogleFonts.leagueSpartan(),
                  color: Colors.white,
                  fontSize: 22,
                ),
          ),
          centerTitle: true,
          elevation: 2,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Por que deseja apagar sua conta?',
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        font: GoogleFonts.leagueSpartan(),
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                        fontSize: 22,
                      ),
                ),
                const SizedBox(height: 15),
                _buildCheckboxes(),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFECF1FF),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: TextFormField(
                    controller: _model.textController,
                    focusNode: _model.textFieldFocusNode,
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText: 'Nos conte o que aconteceu (Opcional)',
                      hintStyle: GoogleFonts.nunito(color: const Color(0xFFA9A6A6)),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    style: GoogleFonts.nunito(color: Colors.black87),
                  ),
                ),
                const Spacer(),
                FFButtonWidget(
                  onPressed: () async {
                    // Abre o modal de confirmação
                    await showModalBottomSheet(
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      enableDrag: false,
                      context: context,
                      builder: (context) {
                        return Padding(
                          padding: MediaQuery.viewInsetsOf(context),
                          child: const AvisoDeletarContaWidget(),
                        );
                      },
                    );
                  },
                  text: 'Deletar conta',
                  options: FFButtonOptions(
                    height: 45,
                    width: double.infinity,
                    color: const Color(0xC58910F0),
                    textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                          font: GoogleFonts.leagueSpartan(),
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                    elevation: 0,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}