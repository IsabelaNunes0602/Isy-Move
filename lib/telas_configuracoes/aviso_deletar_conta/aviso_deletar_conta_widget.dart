import 'package:go_router/go_router.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'aviso_deletar_conta_model.dart';
export 'aviso_deletar_conta_model.dart';

class AvisoDeletarContaWidget extends StatefulWidget {
  const AvisoDeletarContaWidget({super.key});

  @override
  State<AvisoDeletarContaWidget> createState() => _AvisoDeletarContaWidgetState();
}

class _AvisoDeletarContaWidgetState extends State<AvisoDeletarContaWidget> {
  late AvisoDeletarContaModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AvisoDeletarContaModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF8910F0);

    return Container(
      width: 360,
      height: 242,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(27),
      ),
      padding: const EdgeInsets.only(top: 40, left: 20, right: 20),
      child: Column(
        children: [
          Text(
            'Deletar Conta',
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  font: GoogleFonts.leagueSpartan(
                    fontWeight: FontWeight.w500,
                    fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                  ),
                  color: primaryColor,
                  fontSize: 24,
                ),
          ),
          const SizedBox(height: 20),
          Text(
            'Tem certeza que deseja deletar sua conta? \nEssa ação não poderá ser desfeita',
            textAlign: TextAlign.center,
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  font: GoogleFonts.leagueSpartan(),
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.normal,
                  fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                ),
          ),
          const SizedBox(height: 25),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: FFButtonWidget(
                    onPressed: () {
                      context.safePop();
                    },
                    text: 'Cancelar',
                    options: FFButtonOptions(
                      height: 40,
                      color: primaryColor,
                      textStyle: GoogleFonts.leagueSpartan(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                      elevation: 0,
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 6),
                  child: FFButtonWidget(
                    onPressed: () {
                      context.pushNamed(TelaInicioWidget.routeName);
                    },
                    text: 'Deletar conta',
                    options: FFButtonOptions(
                      height: 40,
                      color: primaryColor,
                      textStyle: GoogleFonts.leagueSpartan(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                      elevation: 0,
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}