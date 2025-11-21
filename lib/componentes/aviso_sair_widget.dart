import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_widgets.dart';

class AvisoSairWidget extends StatefulWidget {
  const AvisoSairWidget({super.key});

  @override
  State<AvisoSairWidget> createState() => _AvisoSairWidgetState();
}

class _AvisoSairWidgetState extends State<AvisoSairWidget> {
  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF8910F0);

    return Container(
      width: double.infinity,
      height: 260,
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
          Text(
            'Sair',
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  font: GoogleFonts.leagueSpartan(),
                  color: primaryColor,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 15),
          Text(
            'Tem certeza que deseja sair da sua conta?',
            textAlign: TextAlign.center,
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  font: GoogleFonts.leagueSpartan(),
                  color: Colors.black87,
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                ),
          ),
          const Spacer(),
          
          Row(
            children: [
              // --- BOTÃO 1: CANCELAR ---
              Expanded(
                child: FFButtonWidget(
                  onPressed: () {
                    // Apenas fecha o modal e não faz nada
                    Navigator.pop(context);
                  },
                  text: 'Cancelar',
                  options: FFButtonOptions(
                    height: 45,
                    color: Colors.white,
                    textStyle: GoogleFonts.leagueSpartan(
                      color: primaryColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                    elevation: 0,
                    borderSide: const BorderSide(color: primaryColor, width: 1),
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
              ),
              
              const SizedBox(width: 15),
              
              // --- BOTÃO 2: SIM, SAIR ---
              Expanded(
                child: FFButtonWidget(
                  onPressed: () async {
                    // PASSO 1: Fecha o modal IMEDIATAMENTE.
                    // Isso limpa a tela e volta para o contexto da TelaPerfil
                    Navigator.pop(context);

                    // PASSO 2: Pequeno delay visual.
                    // Isso garante que o modal fechou completamente antes de destruir a sessão.
                    await Future.delayed(const Duration(milliseconds: 200));

                    // PASSO 3: Faz o Logout.
                    await Supabase.instance.client.auth.signOut();
                  },
                  text: 'Sim, sair',
                  options: FFButtonOptions(
                    height: 45,
                    color: primaryColor,
                    textStyle: GoogleFonts.leagueSpartan(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                    elevation: 0,
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}