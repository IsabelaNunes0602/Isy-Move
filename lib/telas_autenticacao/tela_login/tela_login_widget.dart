import 'package:go_router/go_router.dart';

import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // Importação essencial
import 'tela_login_model.dart';
export 'tela_login_model.dart';

class TelaLoginWidget extends StatefulWidget {
  const TelaLoginWidget({super.key});

  static String routeName = 'telaLogin';
  static String routePath = '/telaLogin';

  @override
  State<TelaLoginWidget> createState() => _TelaLoginWidgetState();
}

class _TelaLoginWidgetState extends State<TelaLoginWidget> {
  late TelaLoginModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  
  // Adiciona estado de carregamento para o botão
  bool _isLoading = false; 

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => TelaLoginModel());

    _model.textController1 ??= TextEditingController();
    _model.textFieldFocusNode1 ??= FocusNode();

    _model.textController2 ??= TextEditingController();
    _model.textFieldFocusNode2 ??= FocusNode();

    _model.passwordVisibility = false; // Usa o modelo para o estado
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  // --- NOVA FUNÇÃO DE LOGIN ---
  Future<void> _handleLogin() async {
    // 1. Validação simples
    final email = _model.textController1!.text.trim();
    final password = _model.textController2!.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha email e senha para continuar.')),
      );
      return;
    }

    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // 2. Chama a função de login do Supabase
      final response = await Supabase.instance.client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      // Se a resposta for bem-sucedida (não há exceção), o usuário está logado.
      if (response.user != null) {
        if (!mounted) return;
        // 3. Sucesso: Navega para a página inicial
        context.goNamed(PaginaInicialWidget.routeName);
      } else {
        // Isso só deve ser executado se o Supabase não lançar uma exceção,
        // mas retornar um erro de forma incompleta, mas é bom ter.
        throw const AuthException('Ocorreu um erro desconhecido no login.');
      }
      
    } on AuthException catch (e) {
      // 4. Tratamento de Erros (Senha inválida, usuário não existe, etc.)
      if (!mounted) return;
      
      String message;
      if (e.message.contains('Invalid login credentials')) {
        message = 'Email ou senha inválidos. Por favor, verifique.';
      } else {
        message = 'Erro ao entrar: ${e.message}';
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(backgroundColor: Colors.red, content: Text(message)),
      );
      
    } catch (e) {
      // 5. Tratamento de Outros Erros (Sem internet, etc.)
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(backgroundColor: Colors.red, content: Text('Falha na conexão ou erro inesperado.')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
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
            borderRadius: 30.0,
            borderWidth: 1.0,
            buttonSize: 55.0,
            icon: const Icon(
              Icons.arrow_back_rounded,
              color: Colors.white,
              size: 30.0,
            ),
            onPressed: () => context.pop(),
          ),
          title: Text(
            'Entre na sua conta',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  font: GoogleFonts.leagueSpartan(),
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
          ),
          centerTitle: true,
          elevation: 2.0,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 45.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bem-vindo de volta!',
                  style: FlutterFlowTheme.of(context).headlineSmall.override(
                        font: GoogleFonts.leagueSpartan(),
                        color: primaryColor,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 25),
                // Email Field
                Text(
                  'Email',
                  style: FlutterFlowTheme.of(context).headlineSmall.override(
                        font: GoogleFonts.leagueSpartan(),
                        color: primaryColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _model.textController1,
                  focusNode: _model.textFieldFocusNode1,
                  keyboardType: TextInputType.emailAddress,
                  maxLines: 1,
                  decoration: InputDecoration(
                    hintText: 'Email',
                    filled: true,
                    fillColor: const Color(0xFFC6D4FF),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        font: GoogleFonts.nunito(),
                        fontSize: 16,
                      ),
                  validator: _model.textController1Validator.asValidator(context),
                ),
                const SizedBox(height: 20),
                // Password Field
                Text(
                  'Senha',
                  style: FlutterFlowTheme.of(context).headlineSmall.override(
                        font: GoogleFonts.leagueSpartan(),
                        color: primaryColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _model.textController2,
                  focusNode: _model.textFieldFocusNode2,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: !_model.passwordVisibility, // Usa o estado do modelo
                  decoration: InputDecoration(
                    hintText: 'Digite sua senha',
                    filled: true,
                    fillColor: const Color(0xFFC6D4FF),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    suffixIcon: InkWell(
                      onTap: () => setState(() => _model.passwordVisibility = !_model.passwordVisibility),
                      child: Icon(
                        _model.passwordVisibility
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        size: 22,
                      ),
                    ),
                  ),
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        font: GoogleFonts.nunito(),
                        fontSize: 16,
                      ),
                  validator: _model.textController2Validator.asValidator(context),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: GestureDetector(
                      onTap: () => context.pushNamed(TelaEsqueciSenhaWidget.routeName),
                      child: Text(
                        'Esqueci minha senha',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              color: primaryColor,
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.underline,
                              fontSize: 14,
                            ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Center(
                  child: GestureDetector(
                    onTap: () => context.pushNamed(TelaCriarContaWidget.routeName),
                    child: Text(
                      'Não possui uma conta?',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            color: primaryColor,
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.underline,
                            fontSize: 14,
                          ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Center(
                  child: FFButtonWidget(
                    onPressed: _isLoading ? null : _handleLogin, // Chama a nova função
                    text: _isLoading ? 'Entrando...' : 'Entrar',
                    options: FFButtonOptions(
                      width: 290,
                      height: 50,
                      color: primaryColor,
                      textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                            font: GoogleFonts.leagueSpartan(),
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w400,
                          ),
                      elevation: 3,
                      borderRadius: BorderRadius.circular(25),
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