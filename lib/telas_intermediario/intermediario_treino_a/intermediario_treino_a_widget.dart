import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tcc_1/flutter_flow/flutter_flow_icon_button.dart';
import 'package:tcc_1/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/telas_iniciante/aviso_parabens_iniciante/aviso_parabens_iniciante_widget.dart';
import 'intermediario_treino_a_model.dart';
export 'intermediario_treino_a_model.dart';

class IntermediarioTreinoAWidget extends StatefulWidget {
  const IntermediarioTreinoAWidget({super.key});

  static const String routeName = 'intermediarioTreinoA';
  static const String routePath = '/intermediarioTreinoA';

  @override
  State<IntermediarioTreinoAWidget> createState() => _IntermediarioTreinoAWidgetState();
}

class _IntermediarioTreinoAWidgetState extends State<IntermediarioTreinoAWidget> {
  late IntermediarioTreinoAModel _model;
  late Timer _timer;
  Duration _elapsed = Duration.zero;

  final List<Map<String, dynamic>> exercicios = List.generate(6, (index) {
    return {
      'id': index,
      'nome': 'Exercício',
      'serie': 'x',
      'repeticoes': '10',
      'carga': '0',
    };
  });

  final Map<int, TextEditingController> _cargaControllers = {};

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => IntermediarioTreinoAModel());

    for (var e in exercicios) {
      _cargaControllers[e['id']] = TextEditingController(text: e['carga']);
    }

    // Cronômetro começa aqui
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _elapsed = _elapsed + const Duration(seconds: 1);
      });
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _timer.cancel();
    for (var controller in _cargaControllers.values) {
      controller.dispose();
    }
    _model.dispose();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$hours:$minutes:$seconds';
  }

  void _salvarCarga(int id) {
    final valor = _cargaControllers[id]?.text ?? '0';
    print('Carga do exercício $id salva: $valor');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Carga do exercício $id salva: $valor')),
    );
  }

  Widget buildExercicio(Map<String, dynamic> exercicio) {
    final id = exercicio['id'] as int;
    final nome = exercicio['nome'] as String;
    final serie = exercicio['serie'] as String;
    final repeticoes = exercicio['repeticoes'] as String;
    final controller = _cargaControllers[id]!;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFD7DAFF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF8910F0),
            ),
            child: const Icon(Icons.fitness_center, color: Colors.white),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nome,
                  style: GoogleFonts.leagueSpartan(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF8910F0),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Série:', style: TextStyle(fontWeight: FontWeight.w600)),
                          const SizedBox(height: 4),
                          Text(serie),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Repetições:', style: TextStyle(fontWeight: FontWeight.w600)),
                          const SizedBox(height: 4),
                          Text(repeticoes),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Carga:', style: TextStyle(fontWeight: FontWeight.w600)),
                          const SizedBox(height: 4),
                          SizedBox(
                            height: 30,
                            child: TextField(
                              controller: controller,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                              ),
                              onSubmitted: (_) => _salvarCarga(id),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          IconButton(
            icon: const Icon(Icons.save, color: Color(0xFF8910F0)),
            onPressed: () => _salvarCarga(id),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F4F8),
      appBar: AppBar(
        backgroundColor: const Color(0xFF8910F0),
        automaticallyImplyLeading: false,
        leading: FlutterFlowIconButton(
          borderColor: Colors.transparent,
          borderRadius: 30,
          borderWidth: 1,
          buttonSize: 60,
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 30),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Intermediário',
          style: FlutterFlowTheme.of(context).headlineMedium.override(
                font: GoogleFonts.leagueSpartan(),
                color: Colors.white,
                fontSize: 22,
              ),
        ),
        centerTitle: true,
        elevation: 2,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Text(
                _formatDuration(_elapsed),
                style: GoogleFonts.leagueSpartan(
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF8910F0),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: exercicios.length,
                itemBuilder: (context, index) => buildExercicio(exercicios[index]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: FFButtonWidget(
                onPressed: () async {
                  FFAppState().progressoUsuario = (FFAppState().progressoUsuario) + 1;
                  safeSetState(() {});
                  await showModalBottomSheet(
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    enableDrag: false,
                    context: context,
                    builder: (context) {
                      return GestureDetector(
                        onTap: () {
                          FocusScope.of(context).unfocus();
                          FocusManager.instance.primaryFocus?.unfocus();
                        },
                        child: Padding(
                          padding: MediaQuery.viewInsetsOf(context),
                          child: const AvisoParabensInicianteWidget(),
                        ),
                      );
                    },
                  ).then((_) => safeSetState(() {}));
                },
                text: 'Finalizar treino',
                options: FFButtonOptions(
                  width: 220,
                  height: 55,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  color: const Color(0xFF8910F0),
                  textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                        font: GoogleFonts.leagueSpartan(),
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                  elevation: 0,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}