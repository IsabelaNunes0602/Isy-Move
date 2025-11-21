import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // Importante!

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_widgets.dart';

// Import da tela inicial para onde o usuário vai após deletar
import 'package:tcc_1/tela_inicio/tela_inicio/tela_inicio_widget.dart'; 

class AvisoDeletarContaWidget extends StatefulWidget {
  const AvisoDeletarContaWidget({super.key});

  @override
  State<AvisoDeletarContaWidget> createState() => _AvisoDeletarContaWidgetState();
}

class _AvisoDeletarContaWidgetState extends State<AvisoDeletarContaWidget> {
  // Estado para controlar o loading do botão
  bool _isLoading = false;

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
      padding: const EdgeInsets.only(top: 30, left: 20, right: 20, bottom: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Ícone de alerta
          const Icon(Icons.warning_amber_rounded, color: Colors.red, size: 40),
          const SizedBox(height: 10),
          
          Text(
            'Deletar Conta',
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  font: GoogleFonts.leagueSpartan(),
                  fontWeight: FontWeight.w600,
                  color: primaryColor,
                  fontSize: 24,
                ),
          ),
          const SizedBox(height: 15),
          Text(
            'Tem certeza? Essa ação não poderá ser desfeita e seus dados serão perdidos.',
            textAlign: TextAlign.center,
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  font: GoogleFonts.nunito(),
                  color: Colors.black87,
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                ),
          ),
          const Spacer(),
          
          Row(
            children: [
              // --- BOTÃO CANCELAR ---
              Expanded(
                child: FFButtonWidget(
                  onPressed: () {
                    Navigator.pop(context); // Fecha o modal
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
                    borderSide: const BorderSide(color: primaryColor, width: 1),
                    borderRadius: BorderRadius.circular(18),
                    elevation: 0,
                  ),
                ),
              ),
              const SizedBox(width: 15),
              
              // --- BOTÃO DELETAR ---
              Expanded(
                child: FFButtonWidget(

                  onPressed: _isLoading 
                    ? null 
                    : () async {
                      setState(() => _isLoading = true);
    
                      try {
                        // 1. Chama a função SQL (Deleta no banco)
                        await Supabase.instance.client.rpc('delete_user');
                        
                        if (!context.mounted) return;

                        // 2. Feedback visual
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Conta deletada com sucesso.')),
                        );

                        // 3. Fecha o modal
                        Navigator.pop(context);
                        
                        // 4. Vai para a Tela Inicial
                        context.goNamed(TelaInicioWidget.routeName);

                        // 5. Delay de segurança
                        await Future.delayed(const Duration(milliseconds: 200));

                        // 6. Desloga localmente (Limpa sessão)
                        await Supabase.instance.client.auth.signOut();

                      } catch (e) {
                        if (!context.mounted) return;

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Erro ao deletar: $e'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      } finally {
                        // Garante que só dá setState se a tela ainda existir
                        if (context.mounted) {
                          setState(() => _isLoading = false);
                        }
                      }
                    },
                    
                  text: _isLoading ? '...' : 'Sim, apagar',
                  options: FFButtonOptions(
                    height: 45,
                    color: Colors.red,
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
          )
        ],
      ),
    );
  }
}