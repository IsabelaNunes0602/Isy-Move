import 'package:go_router/go_router.dart';

import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'tela_carregamento_model.dart';
export 'tela_carregamento_model.dart';

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

    // Ação para navegação automática ao carregar a tela
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      context.pushNamed(TelaInicioWidget.routeName);
    });
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const purpleBackground = Color(0xF4713680); 

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: purpleBackground,
        body: Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.asset(
              'assets/images/logo.png',
              width: 180, 
              height: 180, 
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}