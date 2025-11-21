import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tcc_1/tela_inicio/tela_inicio/tela_inicio_widget.dart';

import '/flutter_flow/flutter_flow_util.dart';
import 'tela_carregamento_model.dart';
export 'tela_carregamento_model.dart';


import '../../main/pagina_inicial/pagina_inicial_widget.dart'; 

class TelaCarregamentoWidget extends StatefulWidget {
  const TelaCarregamentoWidget({super.key});

  static const String routeName = 'tela_carregamento';
  static const String routePath = '/telaCarregamento';

  @override
  State<TelaCarregamentoWidget> createState() => _TelaCarregamentoWidgetState();
}

class _TelaCarregamentoWidgetState extends State<TelaCarregamentoWidget> {
  late TelaCarregamentoModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => TelaCarregamentoModel());

    // Ação executada logo após o widget ser construído
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      
      // 1. Espera 3 segundos para exibir marca (Branding)
      await Future.delayed(const Duration(seconds: 3));

      // 2. Verifica se o widget ainda existe antes de rodar lógica
      if (!mounted) return;

      // 3. Verifica se já tem usuário logado no Supabase
      final session = Supabase.instance.client.auth.currentSession;

      if (session != null) {
        // CASO A: Já está logado -> Vai direto para o App (Pagina Inicial)
        // Usa context.goNamed para não deixar voltar para o carregamento
        context.goNamed(PaginaInicialWidget.routeName);
      } else {
        // CASO B: Não está logado -> Vai para a Landing Page (Tela Inicio)
        context.goNamed(TelaInicioWidget.routeName);
      }
    });
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    const purpleBackground = Color(0xFF8910F0); 

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: purpleBackground,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
  
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.asset(
                'assets/images/logo.png',
                width: 180, 
                height: 180, 
                fit: BoxFit.contain,
                // Fallback caso a imagem não carregue
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.fitness_center, 
                  size: 100, 
                  color: Colors.white
                ),
              ),
            ),
            const SizedBox(height: 40),
            // Indicador de carregamento para dar feedback visual
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}