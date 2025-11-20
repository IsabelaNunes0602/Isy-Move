import 'package:go_router/go_router.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'aviso_parabens_intermediario_model.dart';
export 'aviso_parabens_intermediario_model.dart';

class AvisoParabensIntermediarioWidget extends StatefulWidget {
  const AvisoParabensIntermediarioWidget({super.key});

  @override
  State<AvisoParabensIntermediarioWidget> createState() => _AvisoParabensIntermediarioWidgetState();
}

class _AvisoParabensIntermediarioWidgetState extends State<AvisoParabensIntermediarioWidget> {
  late AvisoParabensIntermediarioModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AvisoParabensIntermediarioModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();
    super.dispose();
  }

  void _incrementarProgresso() {
    // Incrementa a contagem no FFAppState (ou no estado que você utilizar)
    final progresso = FFAppState().progressoUsuario;
    if (progresso < 15) {
      FFAppState().progressoUsuario = progresso + 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

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
            'Parabéns',
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
            'Você concluiu mais um treino.',
            textAlign: TextAlign.center,
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  font: GoogleFonts.leagueSpartan(),
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.normal,
                  fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                ),
          ),
          const SizedBox(height: 10),
          Text(
            'Seu progresso é ${FFAppState().progressoUsuario}/40',
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  font: GoogleFonts.nunito(),
                  fontSize: 15,
                  fontWeight: FontWeight.normal,
                ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 25),
            child: FFButtonWidget(
              onPressed: () {
                _incrementarProgresso();
                context.pushNamed(PaginaInicialWidget.routeName);
              },
              text: 'Ok',
              options: FFButtonOptions(
                height: 40,
                color: primaryColor,
                textStyle: GoogleFonts.leagueSpartan(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
                elevation: 0,
                borderRadius: BorderRadius.circular(18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}