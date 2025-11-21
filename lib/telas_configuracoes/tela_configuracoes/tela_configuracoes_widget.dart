import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';


import 'tela_configuracoes_model.dart';
export 'tela_configuracoes_model.dart';

class TelaConfiguracoesWidget extends StatefulWidget {
  const TelaConfiguracoesWidget({super.key});

  static const String routeName = 'telaConfiguracoes';
  static const String routePath = '/telaConfiguracoes';

  @override
  State<TelaConfiguracoesWidget> createState() =>
      _TelaConfiguracoesWidgetState();
}

class _TelaConfiguracoesWidgetState extends State<TelaConfiguracoesWidget> {
  late TelaConfiguracoesModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => TelaConfiguracoesModel());
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  // --- Widget Auxiliar para Opções de Menu ---
  Widget _buildConfigOption({
    required String label,
    required String imageAsset,
    required String routeName,
    IconData fallbackIcon = Icons.settings, // Ícone padrão caso a imagem falhe
  }) {
    return InkWell(
      onTap: () {
        // Usa pushNamed para permitir voltar para esta tela
        context.pushNamed(routeName);
      },
      borderRadius: BorderRadius.circular(12),
      splashColor: Colors.grey.withValues(alpha: 0.1),
      highlightColor: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              // Tratamento de erro da imagem
              child: Image.asset(
                imageAsset,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => Icon(
                  fallbackIcon,
                  color: const Color(0xC58910F0), 
                  size: 24,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Text(
              label,
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    font: GoogleFonts.leagueSpartan(),
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                  ),
            ),
            const Spacer(),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 20,
              color: FlutterFlowTheme.of(context).secondaryText,
            ),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xC58910F0);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: primaryColor,
          automaticallyImplyLeading: false,
          leading: FlutterFlowIconButton(
            borderColor: Colors.transparent,
            borderRadius: 30,
            borderWidth: 1,
            buttonSize: 60,
            icon: const Icon(
              Icons.arrow_back_rounded,
              size: 30,
              color: Colors.white,
            ),
            onPressed: () => context.pop(),
          ),
          title: Text(
            'Configurações',
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
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
            child: Column(
              children: [
                // Opção 1: Alterar Senha
                _buildConfigOption(
                  label: 'Alterar senha',
                  imageAsset: 'assets/images/Vector_(5).png',
                  routeName: AlterarSenhaWidget.routeName,
                  fallbackIcon: Icons.lock_reset,
                ),
                
                // Linha divisória
                Divider(color: Colors.grey.shade200, thickness: 1),

                // Opção 2: Deletar Conta
                _buildConfigOption(
                  label: 'Deletar Conta',
                  imageAsset: 'assets/images/Vector_(6).png',
                  routeName: DeletarContaWidget.routeName,
                  fallbackIcon: Icons.delete_forever,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}