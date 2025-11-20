import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '/flutter_flow/flutter_flow_widgets.dart';

class AlterarSenhaWidget extends StatefulWidget {
  const AlterarSenhaWidget({super.key});

  static const String routeName = 'alterarSenha';
  static const String routePath = '/alterarSenha';

  @override
  State<AlterarSenhaWidget> createState() => _AlterarSenhaWidgetState();
}

class _AlterarSenhaWidgetState extends State<AlterarSenhaWidget> {
  final _formKey = GlobalKey<FormState>();

  final _senhaAtualController = TextEditingController();
  final _novaSenhaController = TextEditingController();
  final _confirmaSenhaController = TextEditingController();

  bool _senhaAtualVisivel = false;
  bool _novaSenhaVisivel = false;
  bool _confirmaSenhaVisivel = false;

  String? _validarSenha(String? value) {
    if (value == null || value.isEmpty) return 'Informe a senha';
    if (value.length < 8) return 'Senha deve ter ao menos 8 caracteres';
    if (!RegExp(r'[A-Z]').hasMatch(value)) return 'Deve conter letra maiúscula';
    if (!RegExp(r'[a-z]').hasMatch(value)) return 'Deve conter letra minúscula';
    if (!RegExp(r'[0-9]').hasMatch(value)) return 'Deve conter número';
    if (!RegExp(r'[!@#\$&*~%^\-_+=]').hasMatch(value)) {
      return 'Deve conter caractere especial (!@#\$&*~%^-_+=)';
    }
    return null;
  }

  String? _validarConfirmaSenha(String? value) {
    if (value != _novaSenhaController.text) return 'As senhas não coincidem';
    return null;
  }

  @override
  void dispose() {
    _senhaAtualController.dispose();
    _novaSenhaController.dispose();
    _confirmaSenhaController.dispose();
    super.dispose();
  }

  InputDecoration _buildInputDecoration(
      String hintText, bool isVisible, VoidCallback toggleVisibility) {
    return InputDecoration(
      hintText: hintText,
      filled: true,
      fillColor: Colors.grey.shade200,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: purpleColor,
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
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
                    fontSize: 25,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Senha atual',
                  style: GoogleFonts.leagueSpartan(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Colors.black87,
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
                Text(
                  'Nova senha',
                  style: GoogleFonts.leagueSpartan(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Colors.black87,
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
                Text(
                  'Confirmar senha',
                  style: GoogleFonts.leagueSpartan(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Colors.black87,
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
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.info_outline, color: Colors.grey),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Requisitos para nova senha:\n'
                          '• Até 8 caracteres\n'
                          '• Incluir letras maiúsculas e minúsculas\n'
                          '• Incluir número e caracteres especiais (ex: @, %, \$, #)',
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
                FFButtonWidget(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Senha alterada com sucesso!')),
                      );
                      context.go('/telaLogin');
                    }
                  },
                  text: 'Alterar Senha',
                  options: FFButtonOptions(
                    width: double.infinity,
                    height: 50,
                    color: purpleColor,
                    textStyle: GoogleFonts.leagueSpartan(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
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
    );
  }
}