import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';


class AvisoParabensWidget extends StatefulWidget {
  final String nivelConcluido; // Ex: "Iniciante"
  
  const AvisoParabensWidget({
    super.key,
    required this.nivelConcluido,
  });

  @override
  State<AvisoParabensWidget> createState() => _AvisoParabensWidgetState();
}

class _AvisoParabensWidgetState extends State<AvisoParabensWidget> {
  
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<FFAppState>(context);
    const Color primaryColor = Color(0xFF8910F0);

    return Container(
      width: 360,
      height: 280, 
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(27),
      ),
      padding: const EdgeInsets.only(top: 30, left: 20, right: 20, bottom: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Parabéns!',
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  font: GoogleFonts.leagueSpartan(),
                  color: primaryColor,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 15),
          Text(
            'Você concluiu mais um treino!',
            textAlign: TextAlign.center,
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  font: GoogleFonts.leagueSpartan(),
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                ),
          ),
          const SizedBox(height: 10),
          Text(
            'Treino: ${widget.nivelConcluido}',
            textAlign: TextAlign.center,
            style: FlutterFlowTheme.of(context).bodySmall.override(
                  font: GoogleFonts.nunito(),
                  color: Colors.grey,
                  fontSize: 14,
                ),
          ),
          const SizedBox(height: 20),
          Text(
            'Progresso Total: ${appState.progressoUsuario}',
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  font: GoogleFonts.nunito(),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: FFButtonWidget(
              onPressed: () {
                // Volta para a tela inicial (Home)
                context.goNamed(routePaginaInicial);
              },
              text: 'Continuar',
              options: FFButtonOptions(
                height: 45,
                color: primaryColor,
                textStyle: GoogleFonts.leagueSpartan(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
                elevation: 0,
                borderRadius: BorderRadius.circular(25),
              ),
            ),
          ),
        ],
      ),
    );
  }
}