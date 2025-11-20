import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '/flutter_flow/flutter_flow_widgets.dart';

class TelaCriarContaWidget extends StatefulWidget {
  const TelaCriarContaWidget({super.key});

  static String routeName = 'telaCriarConta';
  static String routePath = '/telaCriarConta';

  @override
  _TelaCriarContaWidgetState createState() => _TelaCriarContaWidgetState();
}

class _TelaCriarContaWidgetState extends State<TelaCriarContaWidget> {
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _confirmaSenhaController = TextEditingController();

  bool _senhaVisivel = false;
  bool _confirmaSenhaVisivel = false;

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    _confirmaSenhaController.dispose();
    super.dispose();
  }

  // --- Validação de email CORRETA ---
  String? _validarEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "Informe um email";
    }

    // Regex real para email
    final emailRegex = RegExp(r"^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$");

    if (!emailRegex.hasMatch(value.trim())) {
      return "Email inválido";
    }

    return null;
  }

  String? _validarSenha(String? value) {
    if (value == null || value.isEmpty) return 'Informe a senha';
    if (value.length < 8) return 'A senha deve ter pelo menos 8 caracteres';
    if (!RegExp(r'[A-Z]').hasMatch(value)) return 'Inclua pelo menos 1 letra maiúscula';
    if (!RegExp(r'[a-z]').hasMatch(value)) return 'Inclua pelo menos 1 letra minúscula';
    if (!RegExp(r'[0-9]').hasMatch(value)) return 'Inclua pelo menos 1 número';
    if (!RegExp(r'[!@#\$&*~%^\-_+=]').hasMatch(value)) {
      return 'Inclua pelo menos 1 caractere especial (!@#\$&*~%^-_+=)';
    }
    return null;
  }

  String? _validarConfirmaSenha(String? value) {
    if (value != _senhaController.text) {
      return 'As senhas não coincidem';
    }
    return null;
  }

  Future<void> _criarConta() async {
    final email = _emailController.text.trim();
    final senha = _senhaController.text.trim();

    try {
      final supabase = Supabase.instance.client;

      final response = await supabase.auth.signUp(
        email: email,
        password: senha,
      );

      if (!mounted) return;

      if (response.user != null) {
        context.go('/telaCompletarPerfil');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao criar conta.')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      String mensagem = 'Erro ao criar conta';
      if (e.toString().contains('already registered')) {
        mensagem = 'Este e-mail já está cadastrado.';
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mensagem)));
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF8910F0);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
          color: Colors.white,
        ),
        title: Text(
          'Criar conta',
          style: GoogleFonts.leagueSpartan(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
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
                  'Bem-vindo ao Isy Move!',
                  style: GoogleFonts.leagueSpartan(
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                    color: primaryColor,
                  ),
                ),
                const SizedBox(height: 12),

                // EMAIL
                Text(
                  'Email',
                  style: GoogleFonts.leagueSpartan(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    color: primaryColor,
                  ),
                ),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: _validarEmail,
                  decoration: InputDecoration(
                    hintText: 'Email',
                    filled: true,
                    fillColor: const Color(0xFFDCD9FE),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                  style: GoogleFonts.nunito(fontSize: 16, color: Colors.black87),
                ),

                const SizedBox(height: 20),

                // SENHA
                Text(
                  'Senha',
                  style: GoogleFonts.leagueSpartan(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    color: primaryColor,
                  ),
                ),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _senhaController,
                  obscureText: !_senhaVisivel,
                  validator: _validarSenha,
                  decoration: InputDecoration(
                    hintText: 'Crie sua senha',
                    filled: true,
                    fillColor: const Color(0xFFDCD9FE),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: InkWell(
                      onTap: () => setState(() => _senhaVisivel = !_senhaVisivel),
                      child: Icon(
                        _senhaVisivel
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // CONFIRMA SENHA
                Text(
                  'Confirme sua senha',
                  style: GoogleFonts.leagueSpartan(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    color: primaryColor,
                  ),
                ),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _confirmaSenhaController,
                  obscureText: !_confirmaSenhaVisivel,
                  validator: _validarConfirmaSenha,
                  decoration: InputDecoration(
                    hintText: 'Confirme sua senha',
                    filled: true,
                    fillColor: const Color(0xFFDCD9FE),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: InkWell(
                      onTap: () => setState(
                          () => _confirmaSenhaVisivel = !_confirmaSenhaVisivel),
                      child: Icon(
                        _confirmaSenhaVisivel
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                Center(
                  child: FFButtonWidget(
                    onPressed: () async {
                      if (_formKey.currentState?.validate() ?? false) {
                        await _criarConta();
                      }
                    },
                    text: 'Criar conta',
                    options: FFButtonOptions(
                      width: 290,
                      height: 50,
                      color: primaryColor,
                      textStyle: GoogleFonts.leagueSpartan(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
