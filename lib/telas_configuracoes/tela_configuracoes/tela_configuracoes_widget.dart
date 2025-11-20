import 'package:go_router/go_router.dart';

import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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

  Widget _buildConfigOption({
    required String label,
    required String imageAsset,
    required String routeName,
  }) {
    return InkWell(
      onTap: () => context.pushNamed(routeName),
      borderRadius: BorderRadius.circular(12),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage(imageAsset),
                  fit: BoxFit.none,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Text(
              label,
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    font: GoogleFonts.leagueSpartan(
                      fontWeight: FontWeight.normal,
                      fontStyle: FlutterFlowTheme.of(context)
                          .bodyMedium
                          .fontStyle,
                    ),
                    color: Colors.black,
                    fontSize: 20,
                  ),
            ),
            const Spacer(),
            Icon(
              Icons.arrow_forward_ios_sharp,
              size: 24,
              color: FlutterFlowTheme.of(context).secondaryText,
            ),
            const SizedBox(width: 20),
          ],
        ),
      ),
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
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Column(
              children: [
                _buildConfigOption(
                  label: 'Alterar senha',
                  imageAsset: 'assets/images/Vector_(5).png',
                  routeName: AlterarSenhaWidget.routeName,
                ),
                _buildConfigOption(
                  label: 'Deletar Conta',
                  imageAsset: 'assets/images/Vector_(6).png',
                  routeName: DeletarContaWidget.routeName,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}