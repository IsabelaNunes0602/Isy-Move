import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';

// Importações dos modelos e widgets necessários
import 'tela_iniciante_model.dart';
import 'package:tcc_1/tela_treino_fixo/treino_model.dart'; 
import 'package:tcc_1/flutter_flow/nav/nav.dart'; 

class TelaInicianteWidget extends StatefulWidget {
  const TelaInicianteWidget({super.key});

  static const String routeName = 'telaIniciante';
  static const String routePath = '/telaIniciante';

  @override
  State<TelaInicianteWidget> createState() => _TelaInicianteWidgetState();
}

class _TelaInicianteWidgetState extends State<TelaInicianteWidget> {
  late TelaInicianteModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = TelaInicianteModel();
    // Inicializa o modelo buscando dados do banco
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _model.init(context);
    });
  }

  // Método auxiliar para construir os cards de treino
  Widget buildTreinoCard(Treino treinoData) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    final title = treinoData.nomeTreino;
    final subtitle = treinoData.descricao;
    // Se não tiver imagem, usa um placeholder ou string vazia para tratar no errorBuilder
    final imageAsset = treinoData.imagemCaminho.isNotEmpty 
        ? treinoData.imagemCaminho 
        : 'assets/images/placeholder.png'; 
    
    return InkWell(
      onTap: () {
        // Navegação correta passando o objeto 'treinoData' via 'extra'
        context.pushNamed(
          routeTreinoFixo, // Constante definida em nav.dart
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

    return ChangeNotifierProvider<TelaInicianteModel>.value(
      value: _model,
      child: Consumer<TelaInicianteModel>(
        builder: (context, model, child) {
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
                'Iniciante',
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
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                  child: Column(
                    children: [
                      // Contador de progresso
                      Text(
                        'Seu progresso é ${model.treinosConcluidos}/15',
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
                        model.treinosConcluidos >= 15 
                          ? 'Parabéns! Você desbloqueou o nível Intermediário!'
                          : 'Complete os treinos para avançar para o nível intermediário',
                        style: GoogleFonts.nunito(
                          fontSize: 14,
                          color: Colors.black54,
                          fontWeight: model.treinosConcluidos >= 15 ? FontWeight.bold : FontWeight.normal,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      
                      const SizedBox(height: 40),
                      
                      // Mensagem se não houver treinos
                      if (model.listaTreinos.isEmpty)
                         const Center(
                           child: Padding(
                             padding: EdgeInsets.all(20.0),
                             child: Text("Nenhum treino encontrado no banco de dados."),
                           ),
                         ),

                      // Lista Dinâmica de Cards
                      Wrap(
                        spacing: 20,
                        runSpacing: 20,
                        alignment: WrapAlignment.center,
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