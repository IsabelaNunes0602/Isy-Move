import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_widgets.dart';

class AvisoEsqueciSenhaWidget extends StatelessWidget {
  const AvisoEsqueciSenhaWidget({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF8910F0);

    return Container(
      width: double.infinity,
      height: 280,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(27),
          topRight: Radius.circular(27),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Ícone para feedback visual
          const Icon(
            Icons.mark_email_read_rounded,
            color: primaryColor,
            size: 50,
          ),
          const SizedBox(height: 15),
          
          // Título
          Text(
            'E-mail enviado!',
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  font: GoogleFonts.leagueSpartan(),
                  color: primaryColor,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
          ),
          
          const SizedBox(height: 10),
          
          // Texto descritivo
          Expanded(
            child: Text(
              'Um link de recuperação foi enviado para o seu e-mail. Verifique sua caixa de entrada.',
              textAlign: TextAlign.center,
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    font: GoogleFonts.nunito(),
                    color: Colors.black87,
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                  ),
            ),
          ),
          
          // Botão de Ação
          SizedBox(
            width: double.infinity,
            child: FFButtonWidget(
              onPressed: () {
                // 1. Fecha o Modal (BottomSheet)
                Navigator.pop(context);
                
                // 2. Fecha a tela de "Esqueci Senha"
                // Isso faz o usuário cair de volta na tela de Login
                context.pop();
              },
              text: 'Voltar ao Login',
              options: FFButtonOptions(
                height: 50,
                color: primaryColor,
                textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                      font: GoogleFonts.leagueSpartan(),
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                elevation: 0,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}