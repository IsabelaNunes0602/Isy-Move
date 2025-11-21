import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';

import 'package:tcc_1/componentes/aviso_esqueci_senha_widget.dart';

import 'tela_esqueci_senha_model.dart';
export 'tela_esqueci_senha_model.dart';

class TelaEsqueciSenhaWidget extends StatefulWidget {
  const TelaEsqueciSenhaWidget({super.key});

  static const String routeName = 'telaEsqueciSenha';
  static const String routePath = '/telaEsqueciSenha';

  @override
  State<TelaEsqueciSenhaWidget> createState() => _TelaEsqueciSenhaWidgetState();
}

class _TelaEsqueciSenhaWidgetState extends State<TelaEsqueciSenhaWidget> {
  late TelaEsqueciSenhaModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => TelaEsqueciSenhaModel());

    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  // --- Lógica de Recuperação ---
  Future<void> _enviarEmailRecuperacao() async {
    final email = _model.textController?.text.trim();

    if (email == null || email.isEmpty || !email.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Digite um e-mail válido.')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Envia o e-mail via Supabase
      await Supabase.instance.client.auth.resetPasswordForEmail(email);

      if (!mounted) return;

      // Abre o modal de sucesso
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
              child: const AvisoEsqueciSenhaWidget(),
            ),
          );
        },
      );
      
    } on AuthException catch (e) {
      // Tratamento de erro específico do Supabase
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro: ${e.message}'), 
            backgroundColor: Colors.red
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro inesperado ao enviar e-mail.'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF8910F0);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
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
            buttonSize: 50,
            icon: const Icon(
              Icons.arrow_back_rounded,
              color: Colors.white,
              size: 24,
            ),
            onPressed: () => context.pop(),
          ),
          title: Text(
            'Esqueci minha senha',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  font: GoogleFonts.leagueSpartan(),
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
          ),
          centerTitle: true,
          elevation: 2,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Digite seu e-mail cadastrado e enviaremos um link para redefinição.',
                  style: GoogleFonts.nunito(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 30),
                Text(
                  'E-mail cadastrado',
                  style: GoogleFonts.nunito(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _model.textController,
                  focusNode: _model.textFieldFocusNode,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'Digite seu e-mail',
                    hintStyle: GoogleFonts.nunito(color: Colors.grey),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: primaryColor, width: 1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                  style: GoogleFonts.nunito(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 30),
                
                // Botão Enviar
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: FFButtonWidget(
                    onPressed: _isLoading ? null : _enviarEmailRecuperacao,
                    text: _isLoading ? 'Enviando...' : 'Enviar e-mail',
                    options: FFButtonOptions(
                      color: primaryColor,
                      textStyle: GoogleFonts.leagueSpartan(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                      elevation: 0,
                      borderRadius: BorderRadius.circular(12),
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