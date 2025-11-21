import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:stop_watch_timer/stop_watch_timer.dart'; 

import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/flutter_flow_timer.dart';

import '/componentes/aviso_parabens_widget.dart';

import 'package:tcc_1/tela_treino_fixo/treino_model.dart'; 

import 'treino_fixo_model.dart';
export 'treino_fixo_model.dart';

class TreinoFixoWidget extends StatefulWidget {
  final Treino treino; 

  const TreinoFixoWidget({
    super.key,
    required this.treino,
  });

  static const String routeName = 'treinoFixo';
  static const String routePath = '/treinoFixo';

  @override
  State<TreinoFixoWidget> createState() => _TreinoFixoWidgetState();
}

class _TreinoFixoWidgetState extends State<TreinoFixoWidget> {
  late TreinoFixoModel _model;
  final Map<int, TextEditingController> _cargaControllers = {};
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => TreinoFixoModel());
    _model.initState(context);

    // Cria os controllers vazios inicialmente
    if (widget.treino.exercicios.isNotEmpty) {
      for (int i = 0; i < widget.treino.exercicios.length; i++) {
        final exercicio = widget.treino.exercicios[i];
        final controller = TextEditingController(text: ''); // Inicia vazio
        _cargaControllers[i] = controller;
        
        // Listener local para atualizar o objeto se precisar
        controller.addListener(() {
          exercicio.carga = controller.text;
        });
      }
    }

    if (_model.timerController != null) {
       _model.timerController!.onStartTimer();
    }
    
    // --- INTEGRAÇÃO SUPABASE: Carregar Cargas ---
    WidgetsBinding.instance.addPostFrameCallback((_) async {
       final cargasSalvas = await _model.carregarCargasSalvas();
       
       // Atualiza os controllers com os valores vindos do banco
       for (int i = 0; i < widget.treino.exercicios.length; i++) {
          final nomeExerc = widget.treino.exercicios[i].nome;
          if (cargasSalvas.containsKey(nomeExerc)) {
             _cargaControllers[i]?.text = cargasSalvas[nomeExerc]!;
          }
       }
       setState(() {}); // Atualiza a tela
    });
  }

  @override
  void dispose() {
    if (_model.timerController != null) {
       _model.timerController!.onStopTimer();
       _model.timerController!.dispose();
    }

    for (var controller in _cargaControllers.values) {
      controller.dispose();
    }

    _model.dispose();
    super.dispose();
  }

  // Função chamada ao clicar no disquete ou dar Enter
  Future<void> _salvarCarga(int index) async {
    if (index >= widget.treino.exercicios.length) return;
    
    final exercicio = widget.treino.exercicios[index];
    final controller = _cargaControllers[index];
    final valor = controller?.text ?? '';
    
    // 1. A espera do banco de dados
    await _model.salvarCargaIndividual(exercicio.nome, valor);
    
    // Se a tela não estiver mais montada (usuário saiu), para a execução aqui.
    if (!mounted) return; 
    
    // 3. Se passou dali, usar o 'context'
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Carga de ${exercicio.nome} atualizada!'),
        duration: const Duration(seconds: 1),
        backgroundColor: const Color(0xFF8910F0),
      ),
    );
  }
  
  Widget buildExercicio(Exercicio exercicio, int index) {
    final controller = _cargaControllers[index];
    if (controller == null) return const SizedBox();

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
            width: 50, height: 50,
            decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFF8910F0)),
            child: const Icon(Icons.fitness_center, color: Colors.white),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(exercicio.nome, style: GoogleFonts.leagueSpartan(color: const Color(0xFF8910F0), fontWeight: FontWeight.w700, fontSize: 18)),
                Text('Descanso: ${exercicio.descanso}', style: GoogleFonts.nunito(color: Colors.black54, fontSize: 12)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    // Colunas Série e Reps iguais...
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('Série:', style: TextStyle(fontWeight: FontWeight.w600)), Text(exercicio.series)])),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('Repetições:', style: TextStyle(fontWeight: FontWeight.w600)), Text(exercicio.reps)])),
                    
                    // Coluna da Carga (Input)
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
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                                fillColor: Colors.white,
                                filled: true,
                              ),
                              onSubmitted: (_) => _salvarCarga(index),
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
          // Botão Disquete
          IconButton(
            icon: const Icon(Icons.save, color: Color(0xFF8910F0)),
            onPressed: () => _salvarCarga(index),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
  
    return Scaffold(
      key: scaffoldKey,
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
          widget.treino.nomeTreino, 
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
            // --- Timer ---
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: FlutterFlowTimer(
                initialTime: _model.timerMilliseconds,
                controller: _model.timerController!, 
                updateStateInterval: const Duration(milliseconds: 1000),
                onChanged: (value, displayTime, shouldUpdate) {
                  _model.timerMilliseconds = value;
                  _model.timerValue = displayTime;
                  if (shouldUpdate) setState(() {});
                },
                getDisplayTime: (value) => StopWatchTimer.getDisplayTime(value, milliSecond: false),
                textAlign: TextAlign.center,
                style: GoogleFonts.leagueSpartan(fontSize: 30, fontWeight: FontWeight.w700, color: const Color(0xFF8910F0)),
              ),
            ),
            
            // --- Lista de Exercícios ---
            Expanded(
              child: ListView.builder(
                itemCount: widget.treino.exercicios.length,
                itemBuilder: (context, index) => buildExercicio(widget.treino.exercicios[index], index),
              ),
            ),
            
            // --- Botão Finalizar ---
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: FFButtonWidget(
                onPressed: () async {
                  // 1. Mostra Loading
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (c) => const Center(child: CircularProgressIndicator()),
                  );

                  // 2. Salva todas as cargas atuais
                  for(int i=0; i<widget.treino.exercicios.length; i++) {
                     await _model.salvarCargaIndividual(
                        widget.treino.exercicios[i].nome, 
                        _cargaControllers[i]?.text ?? ''
                     );
                  }

                  // 3. Executa lógica de finalizar treino no Supabase
                  await _model.finalizarTreino(widget.treino.nivel);

                  // 4. Fecha o loading
                  if (context.mounted) Navigator.pop(context); 

                  // 5. Abre o Modal de Parabéns
                  if (context.mounted) {
                    await showModalBottomSheet(
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      enableDrag: false,
                      context: context,
                      builder: (context) {
                        return GestureDetector(
                          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
                          child: Padding(
                            padding: MediaQuery.viewInsetsOf(context),
                            child: AvisoParabensWidget(
                              nivelConcluido: widget.treino.nivel,
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
                text: 'Finalizar treino',
                options: FFButtonOptions(
                  width: 220,
                  height: 55,
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