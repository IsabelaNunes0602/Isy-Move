import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tcc_1/main/pagina_inicial/pagina_inicial_model.dart';

class PaginaInicialWidget extends StatefulWidget {
  const PaginaInicialWidget({super.key});

  static const String routeName = 'paginaInicial';
  static const String routePath = '/paginaInicial';

  @override
  State<PaginaInicialWidget> createState() => _PaginaInicialWidgetState();
}

class _PaginaInicialWidgetState extends State<PaginaInicialWidget> {
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PaginaInicialModel>().init(context);
    });
  }

  final List<_NivelTreinoInfo> niveisTreino = [
    _NivelTreinoInfo(
      nome: 'Iniciante',
      imagem: 'assets/images/nivelIniciante.png',
      rota: 'telaIniciante',
      nivelRequerido: 1,
    ),
    _NivelTreinoInfo(
      nome: 'Intermediário',
      imagem: 'assets/images/nivelIntermediario.png',
      rota: 'telaIntermediario',
      nivelRequerido: 2,
    ),
    _NivelTreinoInfo(
      nome: 'Avançado',
      imagem: 'assets/images/nivelAvancado.png',
      rota: 'telaAvancado',
      nivelRequerido: 3,
    ),
  ];


  Future<void> _onCardTap(_NivelTreinoInfo nivel) async { 
    final model = context.read<PaginaInicialModel>();

    if (model.userLevel >= nivel.nivelRequerido) {

      await context.pushNamed(nivel.rota);
      

      if (mounted) {

         await model.init(context); 
      }
    } else {
      // Exibe modal de bloqueio
      _showNivelBloqueadoModal();
    }
  }
  // ----------------------------------------

  void _showNivelBloqueadoModal() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Stack(
          children: [
            // Fundo desfocado
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                color: Colors.black.withValues(alpha: 0.3),
              ),
            ),
            Center(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 30),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Acesso Restrito',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      'Complete mais treinos para acessar esse nível',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8910F0),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        child: Text(
                          'Fechar',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // O card recebe o nível atual do usuário para decidir se está desbloqueado.
  Widget buildNivelTreinoCard(_NivelTreinoInfo nivel, int currentUserLevel) {
    bool desbloqueado = currentUserLevel >= nivel.nivelRequerido;
    return InkWell(
      onTap: () => _onCardTap(nivel),
      borderRadius: BorderRadius.circular(12),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: desbloqueado ? Colors.white : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(12),
          boxShadow: desbloqueado
              ? const [
                  BoxShadow(
                    blurRadius: 4,
                    color: Color(0x22000000),
                    offset: Offset(0, 2),
                  )
                ]
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  nivel.imagem,
                  fit: BoxFit.contain,
                  // Aplica o efeito de cinza/saturação se estiver bloqueado
                  color: desbloqueado ? null : Colors.grey,
                  colorBlendMode: desbloqueado ? null : BlendMode.saturation,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                nivel.nome,
                style: GoogleFonts.leagueSpartan(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: desbloqueado ? Colors.black87 : Colors.black38,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Usa context.watch para escutar mudanças no PaginaInicialModel
    final model = context.watch<PaginaInicialModel>();
    final currentUserLevel = model.userLevel; // Nível reativo

    return Scaffold(
      backgroundColor: const Color(0xFFE5E5E5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF8910F0),
        automaticallyImplyLeading: false,
        title: const Text('Isy Move',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 22,
              color: Colors.white,
            )),
        centerTitle: true,
        elevation: 2,
      ),
      body: SafeArea(
        child: ListView(
          children: [
            const SizedBox(height: 20),
            // ... Textos de cabeçalho ...
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Qual treino você deseja fazer?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Selecione um dos níveis abaixo',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Exibe os cards, passando o nível atual do usuário
            ...niveisTreino
                .map((nivel) => buildNivelTreinoCard(nivel, currentUserLevel)),
            const SizedBox(height: 30),

            Center(
              child: Text(
                'Nível Atual do Usuário: $currentUserLevel',
                style: const TextStyle(fontWeight: FontWeight.bold),
                
              ),
            ),
              const SizedBox(height: 30),

          ],
        ),
      ),
    );
  }
}

class _NivelTreinoInfo {
  final String nome;
  final String imagem;
  final String rota;
  final int nivelRequerido; // 1 = iniciante, 2= intermediário, 3= avançado

  _NivelTreinoInfo({
    required this.nome,
    required this.imagem,
    required this.rota,
    required this.nivelRequerido,
  });
}