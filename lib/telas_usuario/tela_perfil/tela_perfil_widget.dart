import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';

import 'package:tcc_1/componentes/aviso_sair_widget.dart';

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

  // Variáveis de estado para exibir na tela
  String _nomeUsuario = 'Usuário';
  String _nivelUsuario = 'Iniciante';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => TelaPerfilModel());
    
    // Busca dados assim que a tela abre
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _carregarDadosPerfil();
    });
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  // --- BUSCAR DADOS REAIS ---
  Future<void> _carregarDadosPerfil() async {
    try {
      final supabase = Supabase.instance.client;
      final userId = supabase.auth.currentUser?.id;

      if (userId != null) {
        final response = await supabase
            .from('usuario')
            .select('nome_usuario, nivel_usuario')
            .eq('id_usuario', userId)
            .maybeSingle();

        if (response != null) {
          if (mounted) {
            setState(() {
              _nomeUsuario = response['nome_usuario'] ?? 'Usuário';
              // Capitaliza a primeira letra do nível (ex: iniciante -> Iniciante)
              String nivelRaw = response['nivel_usuario'] ?? 'Iniciante';
              _nivelUsuario = nivelRaw[0].toUpperCase() + nivelRaw.substring(1);
              
              _isLoading = false;
            });
          }
        }
      }
    } catch (e) {
      debugPrint('Erro ao carregar perfil: $e');
      if (mounted) setState(() => _isLoading = false);
    }
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
          child: _isLoading 
            ? const Center(child: CircularProgressIndicator(color: primaryColor))
            : SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 30),
              
                    // --- FOTO DE PERFIL ---
              Center(
                child: Stack(
                  children: [
                    // Imagem principal
                    ClipOval(
                      child: Image.asset(
                        'assets/images/Mask_group_(6).png',
                        width: 106,
                        height: 106,
                        fit: BoxFit.cover,
                        // Se der erro, mostra ícone
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: 106, height: 106,
                          color: Colors.grey.shade200,
                          child: const Icon(Icons.person, size: 60, color: Colors.grey),
                        ),
                      ),
                    ),
                    // Ícone de edição (lápis)
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey.shade300),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 4,
                            )
                          ]
                        ),
                        child: const Icon(Icons.edit, size: 18, color: primaryColor),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 15),
              
              // --- NOME DO USUÁRIO ---
              Text(
                _nomeUsuario,
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      font: GoogleFonts.leagueSpartan(),
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF14181B),
                      fontSize: 24.0,
                    ),
              ),
              
              const SizedBox(height: 8),
              
              // --- NÍVEL ---
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Seu nível é ',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          font: GoogleFonts.nunito(),
                          fontWeight: FontWeight.w500,
                          fontSize: 16.0,
                          color: Colors.black54,
                        ),
                  ),
                  Text(
                    _nivelUsuario,
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          font: GoogleFonts.nunito(),
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                          color: primaryColor, 
                        ),
                  ),
                ],
              ),
              
              const SizedBox(height: 40),
              
              // --- BOTÃO CONFIGURAÇÕES ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: InkWell(
                  onTap: () => context.pushNamed('telaConfiguracoes'), 
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 40, height: 40,
                          decoration: const BoxDecoration(
                            color: Color(0xFFF1F4F8),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.settings, color: primaryColor),
                        ),
                        const SizedBox(width: 15),
                        Text(
                          'Configurações',
                          style: GoogleFonts.leagueSpartan(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            color: const Color(0xFF14181B),
                          ),
                        ),
                        const Spacer(),
                        const Icon(Icons.arrow_forward_ios_rounded, size: 18, color: Colors.grey),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              // --- BOTÃO LOGOUT ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: InkWell(
                  onTap: () async {
                    await showModalBottomSheet(
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      enableDrag: false,
                      context: context,
                      builder: (context) {
                        return GestureDetector(
                          onTap: () => FocusScope.of(context).unfocus(),
                          child: Padding(
                            padding: MediaQuery.viewInsetsOf(context),
                            child: const AvisoSairWidget(), 
                          ),
                        );
                      },
                    );
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 40, height: 40,
                          decoration: const BoxDecoration(
                            color: Color(0xFFFEECEC),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.logout, color: Colors.red),
                        ),
                        const SizedBox(width: 15),
                        Text(
                          'Sair',
                          style: GoogleFonts.leagueSpartan(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            color: Colors.red,
                          ),
                        ),
                        const Spacer(),
                        const Icon(Icons.arrow_forward_ios_rounded, size: 18, color: Colors.grey),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),        
        ),
      ),
    );
  }
}