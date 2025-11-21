import 'package:go_router/go_router.dart';

import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';

import 'tela_avancado_model.dart';

export 'tela_avancado_model.dart';

class TelaAvancadoWidget extends StatefulWidget {
  static const String routeName = 'telaAvancado';
  static const String routePath = '/telaAvancado';

  const TelaAvancadoWidget({super.key});

  @override
  State<TelaAvancadoWidget> createState() => _TelaAvancadoWidgetState();
}

class _TelaAvancadoWidgetState extends State<TelaAvancadoWidget> {
  late TelaAvancadoModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Map<String, dynamic>> gruposMusculares = [
    {'nome': 'Peito', 'icone': Icons.sports_gymnastics},
    {'nome': 'Costas', 'icone': Icons.back_hand},
    {'nome': 'Bíceps', 'icone': Icons.fitness_center},
    {'nome': 'Tríceps', 'icone': Icons.sports_kabaddi},
    {'nome': 'Ombros', 'icone': Icons.accessibility_new},
    {'nome': 'Abdômen', 'icone': Icons.sports_martial_arts},
    {'nome': 'Quadríceps', 'icone': Icons.run_circle},
    {'nome': 'Posterior', 'icone': Icons.directions_run},
    {'nome': 'Glúteo', 'icone': Icons.checkroom},
    {'nome': 'Panturrilha', 'icone': Icons.directions_walk},
  ];

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => TelaAvancadoModel());
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Widget buildGrupoMuscular(Map<String, dynamic> grupo) {
    final nome = grupo['nome'] as String;
    final icone = grupo['icone'] as IconData;
    final selecionado = _model.gruposSelecionados.contains(nome);

    return InkWell(
      onTap: () {
        setState(() {
          if (selecionado) {
            _model.removeFromGruposSelecionados(nome);
          } else {
            _model.addToGruposSelecionados(nome);
          }
        });
      },
      borderRadius: BorderRadius.circular(12.0),
      child: Container(
        decoration: BoxDecoration(
          color: selecionado ? const Color(0xFF8910F0) : Colors.white, 
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              blurRadius: 6,
              color: Colors.black.withValues(alpha: 0.1),
              offset: const Offset(0, 4),
            )
          ],
        ),
        padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 12.0),
        child: Row(
          children: [
            Icon(
              icone,
              color: selecionado ? Colors.white : Colors.black87,
              size: 28,
            ),
            const SizedBox(width: 10),
            Flexible( 
              child: Text(
                nome,
                style: TextStyle(
                  color: selecionado ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: const Color(0xFFE5E5E5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF8910F0), 
        centerTitle: true,
        elevation: 0,
        title: const Text(
          'Avançado',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 15),
        child: Column(
          children: [
            const Text(
              'Qual treino vamos fazer hoje?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 20,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Selecione pelo menos um',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 15,
                crossAxisSpacing: 15,
                childAspectRatio: 3.0,
                children: gruposMusculares.map(buildGrupoMuscular).toList(),
              ),
            ),
            FFButtonWidget(
              onPressed: () {
                if (_model.gruposSelecionados.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Selecione pelo menos um grupo!'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }
                
                debugPrint('Gerando treino para: ${_model.gruposSelecionados}');
                context.pushNamed(
                  'telaTreinoAvancado', 
                  extra: _model.gruposSelecionados,
                );
              },
              text: 'Gerar treino',
              options: FFButtonOptions(
                width: double.infinity,
                height: 45,
                color: const Color(0xFF8910F0),
                textStyle: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Colors.white,
                ),
                elevation: 3,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}