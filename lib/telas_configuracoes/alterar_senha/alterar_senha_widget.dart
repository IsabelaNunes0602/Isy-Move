import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; 

import '/flutter_flow/flutter_flow_widgets.dart';

import 'alterar_senha_model.dart';
export 'alterar_senha_model.dart';

class AlterarSenhaWidget extends StatefulWidget {
  const AlterarSenhaWidget({super.key});

  static const String routeName = 'alterarSenha';
  static const String routePath = '/alterarSenha';

  @override
  State<AlterarSenhaWidget> createState() => _AlterarSenhaWidgetState();
}

class _AlterarSenhaWidgetState extends State<AlterarSenhaWidget> {
  late AlterarSenhaModel _model;
  final _formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  // Controladores
  final _senhaAtualController = TextEditingController();
  final _novaSenhaController = TextEditingController();
  final _confirmaSenhaController = TextEditingController();

  // Visibilidade
  bool _senhaAtualVisivel = false;
  bool _novaSenhaVisivel = false;
  bool _confirmaSenhaVisivel = false;
  
  // Estado de carregamento
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _model = AlterarSenhaModel(); // Inicializa model vazio padrão
  }

  @override
  void dispose() {
    _model.dispose();
    _senhaAtualController.dispose();
    _novaSenhaController.dispose();
    _confirmaSenhaController.dispose();
    super.dispose();
  }

  // --- VALIDAÇÕES ---
  String? _validarSenha(String? value) {
    if (value == null || value.isEmpty) return 'Informe a senha';
    if (value.length < 6) return 'Senha deve ter ao menos 6 caracteres';
    return null;
  }

  String? _validarConfirmaSenha(String? value) {
    if (value != _novaSenhaController.text) return 'As senhas não coincidem';
    return null;
  }

  // --- LÓGICA SUPABASE ---
  Future<void> _alterarSenhaNoSupabase() async {
    if (_isLoading) return;

    final senhaAtual = _senhaAtualController.text.trim();
    final novaSenha = _novaSenhaController.text.trim();
    final emailUser = Supabase.instance.client.auth.currentUser?.email;

    if (emailUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro: Usuário não identificado.')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final supabase = Supabase.instance.client;

      // 1. Verifica se a senha ATUAL está correta
      await supabase.auth.signInWithPassword(
        email: emailUser,
        password: senhaAtual,
      );

      // 2. Se passou, atualiza para a NOVA senha
      await supabase.auth.updateUser(
        UserAttributes(password: novaSenha),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Senha alterada com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );

      // Volta para a tela de configurações
      context.pop();

    } on AuthException catch (e) {
      if (!mounted) return;
      String msg = 'Erro ao alterar senha.';
      
      if (e.message.contains('Invalid login credentials')) {
        msg = 'A senha atual está incorreta.';
      } else {
        msg = e.message;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg), backgroundColor: Colors.red),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro inesperado.'), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // Helper visual
  InputDecoration _buildInputDecoration(
      String hintText, bool isVisible, VoidCallback toggleVisibility) {
    return InputDecoration(
      hintText: hintText,
      filled: true,
      fillColor: Colors.grey.shade100,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF8910F0)),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      suffixIcon: InkWell(
        onTap: toggleVisibility,
        child: Icon(
          isVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
          color: Colors.grey[600],
          size: 20,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const purpleColor = Color(0xFF8910F0);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: purpleColor,
          automaticallyImplyLeading: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => context.pop(),
          ),
          title: Text(
            'Alterar Senha',
            style: GoogleFonts.leagueSpartan(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 22,
            ),
          ),
          centerTitle: true,
          elevation: 0,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Informe sua senha atual e crie uma nova.',
                    style: GoogleFonts.leagueSpartan(
                      fontWeight: FontWeight.bold,
                      fontSize: 24, 
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 30),
                  
                  // SENHA ATUAL
                  Text(
                    'Senha atual',
                    style: GoogleFonts.leagueSpartan(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: purpleColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _senhaAtualController,
                    obscureText: !_senhaAtualVisivel,
                    decoration: _buildInputDecoration(
                        'Digite sua senha atual', _senhaAtualVisivel, () {
                      setState(() => _senhaAtualVisivel = !_senhaAtualVisivel);
                    }),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Informe a senha atual';
                      }
                      return null;
                    },
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // NOVA SENHA
                  Text(
                    'Nova senha',
                    style: GoogleFonts.leagueSpartan(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: purpleColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _novaSenhaController,
                    obscureText: !_novaSenhaVisivel,
                    decoration: _buildInputDecoration(
                        'Escreva sua nova senha', _novaSenhaVisivel, () {
                      setState(() => _novaSenhaVisivel = !_novaSenhaVisivel);
                    }),
                    validator: _validarSenha,
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // CONFIRMAR SENHA
                  Text(
                    'Confirmar senha',
                    style: GoogleFonts.leagueSpartan(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: purpleColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _confirmaSenhaController,
                    obscureText: !_confirmaSenhaVisivel,
                    decoration: _buildInputDecoration(
                        'Confirmar nova senha', _confirmaSenhaVisivel, () {
                      setState(() => _confirmaSenhaVisivel = !_confirmaSenhaVisivel);
                    }),
                    validator: _validarConfirmaSenha,
                    textInputAction: TextInputAction.done,
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // REQUISITOS VISUAIS (Apenas texto)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F4F8),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.info_outline, color: Colors.grey),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Requisitos:\n• Mínimo 6 caracteres',
                            style: GoogleFonts.nunito(
                              color: Colors.grey.shade800,
                              fontSize: 14,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // BOTÃO SALVAR
                  FFButtonWidget(
                    onPressed: _isLoading 
                      ? null 
                      : () async {
                        if (_formKey.currentState?.validate() ?? false) {
                          await _alterarSenhaNoSupabase();
                        }
                      },
                    text: _isLoading ? 'Alterando...' : 'Alterar Senha',
                    options: FFButtonOptions(
                      width: double.infinity,
                      height: 50,
                      color: purpleColor,
                      textStyle: GoogleFonts.leagueSpartan(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                      borderRadius: BorderRadius.circular(30),
                      elevation: 3,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}