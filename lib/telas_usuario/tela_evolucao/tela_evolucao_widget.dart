import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';

import 'tela_evolucao_model.dart';
export 'tela_evolucao_model.dart';

class TelaEvolucaoWidget extends StatefulWidget {
  const TelaEvolucaoWidget({super.key});

  static String routeName = 'telaEvolucao';
  static String routePath = '/telaEvolucao';

  @override
  State<TelaEvolucaoWidget> createState() => _TelaEvolucaoWidgetState();
}

class _TelaEvolucaoWidgetState extends State<TelaEvolucaoWidget> {
  late TelaEvolucaoModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  
  // Estado local para o gráfico
  List<WeightData> _historicoPesos = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => TelaEvolucaoModel());

    _model.textController1 ??= TextEditingController();
    _model.textFieldFocusNode1 ??= FocusNode();

    _model.textController2 ??= TextEditingController();
    _model.textFieldFocusNode2 ??= FocusNode();

    _model.textController3 ??= TextEditingController();
    _model.textFieldFocusNode3 ??= FocusNode();

    // Busca dados reais assim que a tela abre
    WidgetsBinding.instance.addPostFrameCallback((_) {
       _carregarDadosCompletos();
    });
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  // --- INTEGRAÇÃO SUPABASE DIRETA ---
  Future<void> _carregarDadosCompletos() async {
    setState(() => _isLoading = true);
    try {
      final supabase = Supabase.instance.client;
      final userId = supabase.auth.currentUser?.id;
      
      if (userId == null) return;

      // 1. Busca Histórico de Peso
      final responseHistorico = await supabase
          .from('historico_peso')
          .select('peso, data_registro')
          .eq('id_usuario', userId)
          .order('data_registro', ascending: true);

      List<WeightData> listaTemporaria = [];
      for (var item in responseHistorico) {
         listaTemporaria.add(WeightData(
           DateTime.parse(item['data_registro']), 
           (item['peso'] as num).toDouble()
         ));
      }

      // 2. Busca Dados do Usuário
      final responseUser = await supabase
          .from('usuario')
          .select('metaPeso') 
          .eq('id_usuario', userId)
          .maybeSingle();
          
      // 3. Busca Progresso e o Desconto Inicial
      final responseProgresso = await supabase
          .from('progresso')
          .select('treinos_concluidos, desconto_inicial')
          .eq('id_usuario', userId)
          .maybeSingle();

      if (mounted) {
        setState(() {
          _historicoPesos = listaTemporaria;

          if (responseUser != null && responseUser['metaPeso'] != null) {
             _model.textController1?.text = responseUser['metaPeso'].toString();
          }

          if (_historicoPesos.isNotEmpty) {
             _model.textController2?.text = _historicoPesos.last.weight.toString();
          }

          // --- LÓGICA DEFINITIVA DE CONTAGEM REAL ---
          if (responseProgresso != null) {
             int totalBanco = responseProgresso['treinos_concluidos'] as int;
             // Se o campo for nulo (usuários antigos), assume 0
             int desconto = (responseProgresso['desconto_inicial'] as int?) ?? 0; 
             
             // A Mágica: Total acumulado - O que ele ganhou de brinde no cadastro
             int treinosReaisFeitos = totalBanco - desconto;
             
             // Proteção para não mostrar negativo (caso edite banco manualmente)
             if (treinosReaisFeitos < 0) treinosReaisFeitos = 0;

             _model.textController3?.text = treinosReaisFeitos.toString();
          }
          // -------------------------------------------
          
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Erro ao carregar dados: $e");
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // Função para salvar novo peso e criar ponto no gráfico
  Future<void> _atualizarPeso(double novoPeso) async {
     try {
       final supabase = Supabase.instance.client;
       final userId = supabase.auth.currentUser?.id;
       if (userId == null) return;

       // 1. Atualiza o peso atual no perfil do usuário (para aparecer no topo da tela)
       await supabase.from('usuario').update({
         'pesoAtual': novoPeso
       }).eq('id_usuario', userId);

       // 2. INSERE um novo registro no histórico (Sempre cria um novo ponto)
       await supabase.from('historico_peso').insert({
         'id_usuario': userId,
         'peso': novoPeso,
         'data_registro': DateTime.now().toIso8601String() 
       });

       debugPrint('Novo peso adicionado ao histórico.');

       // 3. Recarrega o gráfico
       await _carregarDadosCompletos();

       if (mounted) {
         ScaffoldMessenger.of(context).showSnackBar(
           const SnackBar(backgroundColor: Colors.green, content: Text('Peso registrado!')),
         );
       }
     } catch (e) {
       debugPrint('Erro ao atualizar peso: $e');
       if (mounted) {
         ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(backgroundColor: Colors.red, content: Text('Erro: $e')),
         );
       }
     }
  }

  // Função para salvar apenas a Meta
  Future<void> _atualizarMeta(double novaMeta) async {
     try {
       final supabase = Supabase.instance.client;
       final userId = supabase.auth.currentUser?.id;
       if (userId == null) return;

       await supabase.from('usuario').update({
         'metaPeso': novaMeta
       }).eq('id_usuario', userId);

       if (mounted) {
         ScaffoldMessenger.of(context).showSnackBar(
           const SnackBar(content: Text('Meta atualizada!')),
         );
       }
     } catch (e) {
       debugPrint('Erro ao atualizar meta: $e');
     }
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF8910F0);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: primaryColor,
          automaticallyImplyLeading: false,
          leading: FlutterFlowIconButton(
            borderColor: Colors.transparent,
            borderRadius: 30.0,
            borderWidth: 1.0,
            buttonSize: 60.0,
            icon: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 30.0),
            onPressed: () async {
              context.pop();
            },
          ),
          title: Text(
            'Evolução',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  font: GoogleFonts.leagueSpartan(),
                  color: Colors.white,
                  fontSize: 30.0,
                ),
          ),
          centerTitle: true,
          elevation: 2.0,
        ),
        body: SafeArea(
          top: true,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Evolução de Peso Corporal',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          font: GoogleFonts.leagueSpartan(),
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                          fontSize: 24.0,
                        ),
                  ),
                  const SizedBox(height: 15),

                  // --- GRÁFICO ---
                  _isLoading 
                    ? const Center(child: CircularProgressIndicator(color: primaryColor))
                    : AspectRatio(
                      aspectRatio: 1.7,
                      child: _historicoPesos.isEmpty 
                        ? Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Center(child: Text("Registre seu peso para ver o gráfico.")),
                          )
                        : SfCartesianChart(
                          primaryXAxis: DateTimeAxis(
                            dateFormat: DateFormat('dd/MM'),
                            intervalType: DateTimeIntervalType.auto,
                            majorGridLines: const MajorGridLines(width: 0),
                          ),
                          primaryYAxis: const NumericAxis(
                            title: AxisTitle(text: 'Peso (kg)'),
                            majorGridLines: MajorGridLines(width: 0.5, dashArray: <double>[5, 5]),
                          ),
                          tooltipBehavior: TooltipBehavior(enable: true),
                          series: <CartesianSeries<WeightData, DateTime>>[
                            LineSeries<WeightData, DateTime>(
                              dataSource: _historicoPesos,
                              xValueMapper: (WeightData wd, _) => wd.date,
                              yValueMapper: (WeightData wd, _) => wd.weight,
                              markerSettings: const MarkerSettings(isVisible: true),
                              color: primaryColor,
                              width: 3,
                              animationDuration: 1500,
                            ),
                          ],
                        ),
                    ),

                  const SizedBox(height: 35),

                  // --- CAMPOS DE EDIÇÃO ---
                  Row(
                    children: [
                      // META
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Meta', style: _labelStyle(context)),
                            const SizedBox(height: 8),
                            _buildInputContainer(context, _model.textController1, _model.textFieldFocusNode1),
                            TextButton(
                              onPressed: () async {
                                double? meta = double.tryParse(_model.textController1?.text.replaceAll(',', '.') ?? '');
                                if (meta != null) await _atualizarMeta(meta);
                              },
                              child: const Text('Alterar'),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20),
                      
                      // PESO ATUAL
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Peso Atual', style: _labelStyle(context)),
                            const SizedBox(height: 8),
                            _buildInputContainer(context, _model.textController2, _model.textFieldFocusNode2),
                            TextButton(
                              onPressed: () async {
                                double? peso = double.tryParse(_model.textController2?.text.replaceAll(',', '.') ?? '');
                                if (peso != null) await _atualizarPeso(peso);
                              },
                              child: const Text('Alterar'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // CONTAGEM (Apenas Leitura)
                  Text('Contagem de treinos concluídos', style: _labelStyle(context)),
                  const SizedBox(height: 8),
                  Container(
                    height: 40,
                    width: 100,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F4F8),
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(color: Colors.grey.shade400),
                    ),
                    child: Text(
                      _model.textController3?.text ?? '0',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            font: GoogleFonts.nunito(),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
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

  TextStyle _labelStyle(BuildContext context) {
    return FlutterFlowTheme.of(context).bodyMedium.override(
          font: GoogleFonts.leagueSpartan(),
          fontWeight: FontWeight.w600,
          fontSize: 20,
          color: Colors.black,
        );
  }

  Widget _buildInputContainer(BuildContext context, TextEditingController? controller, FocusNode? focusNode) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: const Color(0xFFF1F4F8),
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.grey.shade400),
      ),
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: const InputDecoration(
          hintText: '0',
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        ),
        style: FlutterFlowTheme.of(context).bodyMedium.override(
              font: GoogleFonts.nunito(),
              fontSize: 16,
            ),
      ),
    );
  }
}

class WeightData {
  final DateTime date;
  final double weight;
  WeightData(this.date, this.weight);
}