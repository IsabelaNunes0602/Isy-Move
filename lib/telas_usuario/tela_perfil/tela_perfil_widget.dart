import 'package:go_router/go_router.dart';
import 'package:tcc_1/telas_configuracoes/aviso_sair/aviso_sair_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'tela_perfil_model.dart';
export 'tela_perfil_model.dart';

class TelaPerfilWidget extends StatefulWidget {
  const TelaPerfilWidget({super.key});

  static const String routeName = 'telaPerfil';
  static const String routePath = '/telaPerfil';

  @override
  State<TelaPerfilWidget> createState() => _TelaPerfilWidgetState();
}

class _TelaPerfilWidgetState extends State<TelaPerfilWidget> {
  late TelaPerfilModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => TelaPerfilModel());
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();
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
          centerTitle: true,
          elevation: 2,
          title: Text(
            'Meu Perfil',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  font: GoogleFonts.leagueSpartan(),
                  color: Colors.white,
                  fontSize: 24.0,
                ),
            textAlign: TextAlign.center,
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Center(
                child: Stack(
                  children: [
                    ClipOval(
                      child: Image.asset(
                        'assets/images/Mask_group_(6).png',
                        width: 106,
                        height: 106,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).secondaryBackground,
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: Image.asset('assets/images/Group_13.png').image,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              Text(
                'Usuário',
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      font: GoogleFonts.leagueSpartan(
                        fontWeight: FontWeight.w600,
                      ),
                      color: const Color(0xFF14181B),
                      fontSize: 24.0,
                    ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Seu nível é ',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          font: GoogleFonts.nunito(),
                          fontWeight: FontWeight.w500,
                          fontSize: 16.0,
                          color: Colors.black,
                        ),
                  ),
                  Text(
                    FFAppState().nivelUsuario,
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          font: GoogleFonts.nunito(),
                          fontWeight: FontWeight.w600,
                          fontSize: 20.0,
                          color: Colors.black,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              InkWell(
                onTap: () => context.pushNamed(TelaConfiguracoesWidget.routeName),
                child: ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                      image: DecorationImage(
                        image: Image.asset('assets/images/Group_34.png').image,
                        fit: BoxFit.none,
                      ),
                      shape: BoxShape.circle,
                    ),
                  ),
                  title: Text(
                    'Configurações',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          font: GoogleFonts.leagueSpartan(
                            fontWeight: FontWeight.w600,
                          ),
                          color: const Color(0xFF14181B),
                          fontSize: 20.0,
                        ),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: FlutterFlowTheme.of(context).secondaryText,
                    size: 24,
                  ),
                ),
              ),
              InkWell(
                onTap: () async {
                  await showModalBottomSheet(
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    enableDrag: false,
                    context: context,
                    builder: (context) {
                      return GestureDetector(
                        onTap: () {
                          FocusScope.of(context).unfocus();
                          FocusManager.instance.primaryFocus?.unfocus();
                        },
                        child: Padding(
                          padding: MediaQuery.viewInsetsOf(context),
                          child: const AvisoSairWidget(),
                        ),
                      );
                    },
                  );
                },
                child: ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                      image: DecorationImage(
                        image: Image.asset('assets/images/Group_36.png').image,
                        fit: BoxFit.none,
                      ),
                      shape: BoxShape.circle,
                    ),
                  ),
                  title: Text(
                    'Logout',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          font: GoogleFonts.leagueSpartan(
                            fontWeight: FontWeight.w600,
                          ),
                          color: const Color(0xFF14181B),
                          fontSize: 20.0,
                        ),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: FlutterFlowTheme.of(context).secondaryText,
                    size: 24,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      
    );
    
  }
}