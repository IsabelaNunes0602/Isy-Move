import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/flutter_flow_timer.dart';

import '/componentes/aviso_parabens_widget.dart';
import 'package:tcc_1/tela_treino_fixo/treino_model.dart'; 
import 'tela_treino_avancado_model.dart';
export 'tela_treino_avancado_model.dart';

class TelaTreinoAvancadoWidget extends StatefulWidget {
  static const String routeName = 'telaTreinoAvancado';
  static const String routePath = '/telaTreinoAvancado';

  // Recebeu a lista de grupos (Ex: ['Peito', 'Tríceps'])
  final List<String> gruposSelecionados;

  // Construtor ajustado para aceitar o parametro 'extra' do router
  const TelaTreinoAvancadoWidget({
    super.key,
    this.gruposSelecionados = const [], // Default vazio para evitar crash
  });

  @override
  State<TelaTreinoAvancadoWidget> createState() => _TelaTreinoAvancadoWidgetState();
}

class _TelaTreinoAvancadoWidgetState extends State<TelaTreinoAvancadoWidget> {
  late TelaTreinoAvancadoModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  
  // Map dinâmico para controlar os inputs
  final Map<int, TextEditingController> _cargaControllers = {};

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => TelaTreinoAvancadoModel());
    _model.initState(context);

    // --- INICIALIZAÇÃO DO TREINO ---
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // 1. Gera o treino aleatório
      await _model.gerarTreinoAleatorio(widget.gruposSelecionados);
      
      // 2. Busca as cargas antigas
      final cargasSalvas = await _model.carregarCargasSalvas();

      // 3. Configura os controladores para cada exercício gerado
      for (int i = 0; i < _model.exerciciosGerados.length; i++) {
        final exercicio = _model.exerciciosGerados[i];
        
        // Se tiver carga salva, usa ela. Senão vazio.
        String cargaInicial = cargasSalvas[exercicio.nome] ?? '';
        exercicio.carga = cargaInicial;

        final controller = TextEditingController(text: cargaInicial);
        _cargaControllers[i] = controller;

        // Sincroniza controller com objeto
        controller.addListener(() {
           exercicio.carga = controller.text;
        });
      }

      // 4. Inicia timer e atualiza tela
      if (_model.timerController != null) {
        _model.timerController!.onStartTimer();
      }
      setState(() {}); 
    });
  }

  @override
  void dispose() {
    if (_model.timerController != null) {
      _model.timerController!.onStopTimer();
      _model.timerController!.dispose();
    }
    for (var c in _cargaControllers.values) {
      c.dispose();
    }
    _model.dispose();
    super.dispose();
  }

  Future<void> _salvarCarga(int index) async {
    if (index >= _model.exerciciosGerados.length) return;
    
    final exercicio = _model.exerciciosGerados[index];
    final controller = _cargaControllers[index];
    final valor = controller?.text ?? '';
    
    await _model.salvarCargaIndividual(exercicio.nome, valor);
    
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Carga de ${exercicio.nome} salva!'),
        duration: const Duration(seconds: 1),
        backgroundColor: const Color(0xFF8910F0),
      ),
    );
  }

  Widget buildExercicio(Exercicio exercicio, int index) {
    final controller = _cargaControllers[index];
    // Se ainda estiver carregando, retorna vazio
    if (controller == null) return const SizedBox();

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
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
                Text(
                  exercicio.nome,
                  style: GoogleFonts.leagueSpartan(
                    fontSize: 18, fontWeight: FontWeight.w700, color: const Color(0xFF8910F0)
                  ),
                ),
                const SizedBox(height: 4),
                Text('Descanso: ${exercicio.descanso}', style: GoogleFonts.nunito(fontSize: 12)),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text("Série:", style: TextStyle(fontWeight: FontWeight.w600)), Text(exercicio.series)])),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text("Reps:", style: TextStyle(fontWeight: FontWeight.w600)), Text(exercicio.reps)])),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Carga:", style: TextStyle(fontWeight: FontWeight.w600)),
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
                )
              ],
            ),
          ),
          const SizedBox(width: 10),
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
        title: Text(
          'Treino Gerado',
          style: GoogleFonts.leagueSpartan(fontWeight: FontWeight.w700, fontSize: 20, color: Colors.white),
        ),
        centerTitle: true,
        elevation: 0,
        leading: FlutterFlowIconButton(
          borderColor: Colors.transparent,
          borderRadius: 30,
          borderWidth: 1,
          buttonSize: 60,
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 30),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              // --- TIMER ---
              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 15),
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
                  style: GoogleFonts.leagueSpartan(
                    fontSize: 30, fontWeight: FontWeight.w700, color: const Color(0xFF8910F0)
                  ),
                ),
              ),

              // --- LOADING OU LISTA ---
              Expanded(
                child: _model.isLoading
                    ? const Center(child: CircularProgressIndicator(color: Color(0xFF8910F0)))
                    : _model.exerciciosGerados.isEmpty
                        ? const Center(child: Text("Nenhum exercício encontrado para os grupos selecionados."))
                        : ListView.builder(
                            itemCount: _model.exerciciosGerados.length,
                            itemBuilder: (context, index) => buildExercicio(_model.exerciciosGerados[index], index),
                          ),
              ),

              // --- BOTÃO FINALIZAR ---
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: FFButtonWidget(
                  onPressed: () async {
                    // 1. Salva tudo por segurança
                    for(int i=0; i < _model.exerciciosGerados.length; i++) {
                       await _model.salvarCargaIndividual(
                          _model.exerciciosGerados[i].nome, 
                          _cargaControllers[i]?.text ?? ''
                       );
                    }
                    
                    // 2. Incrementa histórico
                    await _model.finalizarTreino();

                    // 3. Abre Modal Parabéns
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
                              child: const AvisoParabensWidget(
                                nivelConcluido: 'Avançado',
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                  text: 'Finalizar treino',
                  options: FFButtonOptions(
                    width: double.infinity,
                    height: 50,
                    color: const Color(0xFF8910F0),
                    textStyle: GoogleFonts.leagueSpartan(
                      fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white
                    ),
                    elevation: 0,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}