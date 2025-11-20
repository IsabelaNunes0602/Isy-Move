import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '../../telas_autenticacao/tela_login/tela_login_widget.dart';
import '../../telas_autenticacao/tela_criar_conta/tela_criar_conta_widget.dart';

class TelaInicioWidget extends StatefulWidget {
  const TelaInicioWidget({super.key});

  static const String routeName = 'telaInicio';
  static const String routePath = '/telaInicio';

  @override
  State<TelaInicioWidget> createState() => _TelaInicioWidgetState();
}

class _TelaInicioWidgetState extends State<TelaInicioWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    // Cor Roxa do seu tema
    const primaryPurple = Color(0xFF8910F0); 

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: primaryPurple,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Se a imagem não carregar, mostra um ícone como fallback
                  Image.asset(
                    'assets/images/logo.png',
                    width: 350,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.fitness_center, 
                      size: 100, 
                      color: Colors.white
                    ),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    'Mexa-se. Evolua. Sinta a diferença',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.nunito(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 40),
                  
                  // Botão Entrar
                  SizedBox(
                    width: double.infinity,
                    child: FFButtonWidget(
                      onPressed: () {
                        context.pushNamed(TelaLoginWidget.routeName);
                      },
                      text: 'Entrar',
                      options: FFButtonOptions(
                        height: 50,
                        color: Colors.white,
                        textStyle: GoogleFonts.leagueSpartan(
                          color: primaryPurple,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                        elevation: 3,
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Botão Criar Conta
                  SizedBox(
                    width: double.infinity,
                    child: FFButtonWidget(
                      onPressed: () {
                        context.pushNamed(TelaCriarContaWidget.routeName);
                      },
                      text: 'Criar uma conta',
                      options: FFButtonOptions(
                        height: 50,
                        color: Colors.white.withOpacity(0.2),
                        textStyle: GoogleFonts.leagueSpartan(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                        ),
                        elevation: 0,
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(
                          color: Colors.white,
                          width: 1,
                        ),
                      ),
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