import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_widgets.dart';

class AvisoParabensWidget extends StatefulWidget {
  final String nivelConcluido; // Ex: 'Iniciante', 'Intermediário', 'Avançado'
  
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

    const Color primaryColor = Color(0xFF8910F0);

    // Lógica para decidir o texto baseada no nível
    bool isAvancado = widget.nivelConcluido.toLowerCase().contains('avan');
    String mensagemPrincipal = isAvancado 
        ? 'Você concluiu mais um treino avançado!' 
        : 'Você concluiu mais um treino!';

    return Container(
      width: double.infinity, 
      height: 320,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(27),
          topRight: Radius.circular(27),
        ),
      ),
      padding: const EdgeInsets.only(top: 30, left: 20, right: 20, bottom: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          // Ícone de Troféu
          Container(
            margin: const EdgeInsets.only(bottom: 15),
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Color(0xFFF1F4F8),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.emoji_events_rounded, color: primaryColor, size: 32),
          ),

          // Título
          Text(
            'Parabéns!',
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  font: GoogleFonts.leagueSpartan(),
                  color: primaryColor,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 10),
          
          // Mensagem dinâmica
          Text(
            mensagemPrincipal,
            textAlign: TextAlign.center,
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  font: GoogleFonts.leagueSpartan(),
                  color: Colors.black87,
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                ),
          ),
          
          const SizedBox(height: 8),
          
          // Subtítulo com o nível
          Text(
            'Nível: ${widget.nivelConcluido}',
            textAlign: TextAlign.center,
            style: FlutterFlowTheme.of(context).bodySmall.override(
                  font: GoogleFonts.nunito(),
                  color: Colors.grey,
                  fontSize: 14,
                ),
          ),
          
          const SizedBox(height: 15),
          
          // Feedback visual de sucesso
          Text(
            'Progresso salvo com sucesso!',
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  font: GoogleFonts.nunito(),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
          ),
          
          const Spacer(),
          
          // Botão CONTINUAR
          SizedBox(
            width: double.infinity,
            child: FFButtonWidget(
              onPressed: () {
                // 1. Fecha o Modal (BottomSheet) atual
                Navigator.pop(context);
                
                // 2. Redireciona para a Página Inicial (Home)
                context.goNamed('paginaInicial'); 
              },
              text: 'Continuar',
              options: FFButtonOptions(
                height: 50,
                color: primaryColor,
                textStyle: GoogleFonts.leagueSpartan(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
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