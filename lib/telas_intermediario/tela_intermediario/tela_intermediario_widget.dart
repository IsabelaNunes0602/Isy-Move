import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';

// Imports dos modelos e da tela genérica
import 'tela_intermediario_model.dart';
import 'package:tcc_1/tela_treino_fixo/treino_model.dart';
import 'package:tcc_1/flutter_flow/nav/nav.dart';

class TelaIntermediarioWidget extends StatefulWidget {
  const TelaIntermediarioWidget({super.key});

  static const String routeName = 'telaIntermediario';
  static const String routePath = '/telaIntermediario';

  @override
  State<TelaIntermediarioWidget> createState() => _TelaIntermediarioWidgetState();
}

class _TelaIntermediarioWidgetState extends State<TelaIntermediarioWidget> {
  late TelaIntermediarioModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = TelaIntermediarioModel();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _model.init(context);
    });
  }

  Widget buildTreinoCard(Treino treinoData) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    final title = treinoData.nomeTreino;
    final subtitle = treinoData.descricao;
    // Fallback para imagem caso venha vazia
    final imageAsset = treinoData.imagemCaminho.isNotEmpty 
        ? treinoData.imagemCaminho 
        : 'assets/images/nivelIntermediario.png'; 

    return InkWell(
      onTap: () {
        // Navega para a tela genérica com os dados do treino clicado
        context.pushNamed(
          routeTreinoFixo, 
          extra: treinoData,
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: (screenWidth / 2) - 30,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Color(0x22000000),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              child: Image.asset(
                imageAsset,
                width: double.infinity,
                height: 120,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 120,
                  color: Colors.grey.shade200,
                  child: const Icon(Icons.fitness_center, color: Colors.grey, size: 40),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.leagueSpartan(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: const Color(0xFF8910F0),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: GoogleFonts.nunito(
                      fontSize: 12,
                      color: Colors.grey[700],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF8910F0);
    
    return ChangeNotifierProvider<TelaIntermediarioModel>.value(
      value: _model,
      child: Consumer<TelaIntermediarioModel>(
        builder: (context, model, child) {
          // Cálculo visual: Treinos feitos neste nível (Total - 15 anteriores)
          int treinosNesseNivel = (model.treinosConcluidos - 15).clamp(0, 40);

          return Scaffold(
            key: scaffoldKey,
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: primaryColor,
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
              child: model.isLoading
                  ? const Center(child: CircularProgressIndicator(color: primaryColor))
                  : SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Contador
                          Text(
                            'Seu progresso é $treinosNesseNivel/40',
                            style: GoogleFonts.nunito(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                              color: Colors.black87,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 15),
                          
                          // Barra de Progresso
                          Container(
                            width: double.infinity,
                            height: 24,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: LinearProgressIndicator(
                                value: model.percentualProgresso,
                                backgroundColor: Colors.grey.shade300,
                                valueColor: const AlwaysStoppedAnimation<Color>(primaryColor),
                                minHeight: 24,
                              ),
                            ),
                          ),
                          
                          const SizedBox(height: 15),
                          Text(
                            model.treinosConcluidos >= 55
                                ? 'Parabéns! Você desbloqueou o nível Avançado!'
                                : 'Complete os treinos para avançar para o nível avançado',
                            style: GoogleFonts.nunito(
                              fontSize: 14,
                              color: Colors.black54,
                              fontWeight: model.treinosConcluidos >= 55 ? FontWeight.bold : FontWeight.normal,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          
                          const SizedBox(height: 40),
                          
                          if (model.listaTreinos.isEmpty)
                             const Center(
                               child: Padding(
                                 padding: EdgeInsets.all(20.0),
                                 child: Text("Nenhum treino intermediário encontrado."),
                               ),
                             ),

                          // Lista Dinâmica
                          Wrap(
                            alignment: WrapAlignment.center,
                            spacing: 20,
                            runSpacing: 20,
                            children: model.listaTreinos.map((treino) {
                              return buildTreinoCard(treino);
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
            ),
          );
        },
      ),
    );
  }
}