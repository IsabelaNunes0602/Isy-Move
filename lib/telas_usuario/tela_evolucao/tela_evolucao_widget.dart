import 'package:go_router/go_router.dart';

import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
// Importante para datas
import '../../backend/custom_services/evolucao_service.dart'; 

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
  
  // Serviço do Supabase
  final EvolucaoService _evolucaoService = EvolucaoService();

  // Estado local para o gráfico
  List<WeightData> _historicoPesos = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => TelaEvolucaoModel());

    // Inicializa os controllers (vazios por enquanto, preencheremos no _carregarDados)
    _model.textController1 ??= TextEditingController();
    _model.textFieldFocusNode1 ??= FocusNode();

    _model.textController2 ??= TextEditingController();
    _model.textFieldFocusNode2 ??= FocusNode();

    _model.textController3 ??= TextEditingController();
    _model.textFieldFocusNode3 ??= FocusNode();

    // Busca os dados reais do banco ao iniciar a tela
    _carregarDados();
  }

  // --- INTEGRAÇÃO SUPABASE: Função para buscar dados ---
  Future<void> _carregarDados() async {
    try {
      // 1. Busca histórico para o gráfico
      final dadosGrafico = await _evolucaoService.buscarDadosGrafico();
      
      // 2. Busca meta atual (opcional, se quiser garantir que está atualizado do banco)
      final metaAtual = await _evolucaoService.buscarMetaPeso();

      if (mounted) {
        setState(() {
          // Converte o Map do service para o objeto WeightData do gráfico
          _historicoPesos = dadosGrafico.map((item) {
            return WeightData(item['data_completa'] as DateTime, (item['peso'] as num).toDouble());
          }).toList();

          // Atualiza os campos de texto com dados reais (se existirem)
          if (metaAtual != null) {
             _model.textController1?.text = metaAtual.toString();
          }
          // O peso atual é o último do histórico
          if (_historicoPesos.isNotEmpty) {
            _model.textController2?.text = _historicoPesos.last.weight.toString();
          }
          
          // Preenche o progresso (Exemplo fixo ou vindo do FFAppState)
          _model.textController3?.text = FFAppState().progressoUsuario.toString();

          _isLoading = false;
        });
      }
    } catch (e) {
      print("Erro ao carregar dados: $e");
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();
    const Color primaryColor = Color(0xFF8910F0);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).info,
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

                  // --- INTEGRAÇÃO SUPABASE: Gráfico Dinâmico ---
                  _isLoading 
                    ? const Center(child: CircularProgressIndicator(color: primaryColor))
                    : AspectRatio(
                      aspectRatio: 1.7,
                      child: _historicoPesos.isEmpty 
                        ? const Center(child: Text("Nenhum dado registrado ainda."))
                        : SfCartesianChart(
                          primaryXAxis: DateTimeAxis(
                            dateFormat: DateFormat('dd/MM'), // Dia/Mês fica melhor visualmente
                            intervalType: DateTimeIntervalType.auto,
                            edgeLabelPlacement: EdgeLabelPlacement.shift,
                            majorGridLines: const MajorGridLines(width: 0),
                            labelRotation: 45,
                            title: const AxisTitle(text: 'Data'),
                          ),
                          primaryYAxis: const NumericAxis(
                            // Removemos minimo/maximo fixo para o gráfico se adaptar aos dados
                            title: AxisTitle(text: 'Peso (kg)'),
                            majorGridLines: MajorGridLines(width: 0.5, dashArray: <double>[5, 5]),
                          ),
                          tooltipBehavior: TooltipBehavior(enable: true), // Adiciona tooltip ao tocar
                          series: <CartesianSeries<WeightData, DateTime>>[
                            LineSeries<WeightData, DateTime>(
                              dataSource: _historicoPesos,
                              xValueMapper: (WeightData wd, _) => wd.date,
                              yValueMapper: (WeightData wd, _) => wd.weight,
                              markerSettings: const MarkerSettings(isVisible: true),
                              dataLabelSettings: const DataLabelSettings(isVisible: false), // Poluição visual se tiver muitos dados
                              color: primaryColor,
                              width: 3,
                              animationDuration: 1500,
                            ),
                          ],
                        ),
                    ),

                  const SizedBox(height: 35),

                  // Campos Meta e Peso Atual
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // --- CAMPO META ---
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
                                if (meta != null) {
                                  // Salva no Supabase
                                  await _evolucaoService.atualizarMeta(meta);
                                  // Atualiza estado global (opcional)
                                  FFAppState().metaPeso = meta;
                                  
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Meta atualizada com sucesso!')),
                                    );
                                  }
                                }
                              },
                              child: const Text('Alterar'),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20),
                      
                      // --- CAMPO PESO ATUAL ---
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
                                if (peso != null) {
                                  // Mostra loading rápido
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Salvando peso...'), duration: Duration(milliseconds: 800)),
                                    );

                                  // 1. Atualiza no Supabase (Trigger cria o histórico)
                                  await _evolucaoService.atualizarPeso(peso);
                                  
                                  // 2. Atualiza estado global
                                  FFAppState().pesoAtual = peso;

                                  // 3. Recarrega o gráfico para mostrar o ponto novo
                                  await _carregarDados();

                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(backgroundColor: Colors.green, content: Text('Histórico atualizado!')),
                                    );
                                  }
                                }
                              },
                              child: const Text('Alterar'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // Contagem de treinos (Mantido igual, apenas visualização)
                  Text('Contagem de treinos concluídos', style: _labelStyle(context)),
                  const SizedBox(height: 8),
                  Container(
                    height: 40,
                    width: 100,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(color: Colors.grey.shade400),
                    ),
                    child: Text(
                      valueOrDefault<String>(FFAppState().progressoUsuario.toString(), '0'),
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            font: GoogleFonts.nunito(),
                            fontSize: 16,
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

  // Helpers para limpar o código principal
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
        color: FlutterFlowTheme.of(context).secondaryBackground,
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
        cursorColor: FlutterFlowTheme.of(context).primaryText,
      ),
    );
  }
}

// Classe de dados para o gráfico
class WeightData {
  final DateTime date;
  final double weight;
  WeightData(this.date, this.weight);
}