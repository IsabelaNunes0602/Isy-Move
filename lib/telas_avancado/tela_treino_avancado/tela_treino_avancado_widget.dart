import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class TelaTreinoAvancadoWidget extends StatefulWidget {
  static const String routeName = 'telaTreinoAvancado';
  static const String routePath = '/telaTreinoAvancado';

  const TelaTreinoAvancadoWidget({super.key});

  @override
  State<TelaTreinoAvancadoWidget> createState() => _TelaTreinoAvancadoWidgetState();
}

class _TelaTreinoAvancadoWidgetState extends State<TelaTreinoAvancadoWidget> {
  late Timer _timer;
  Duration _elapsed = Duration.zero;

  // Simulação dados fixos vindos do banco para série e repetições
  final List<Map<String, dynamic>> exercicios = List.generate(6, (index) {
    return {
      'id': index,
      'nome': 'Exercício',
      'serie': 'x',
      'repeticoes': '10', // exemplo fixo
      'carga': '0',
    };
  });

  // Controladores para o campo carga de cada exercício
  final Map<int, TextEditingController> _cargaControllers = {};

  @override
  void initState() {
    super.initState();
    // Inicializar controladores para carga
    for (var e in exercicios) {
      final controller = TextEditingController(text: e['carga']);
      _cargaControllers[e['id']] = controller;
    }
    // Iniciar cronômetro
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _elapsed = _elapsed + const Duration(seconds: 1);
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    for (var controller in _cargaControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(d.inHours);
    final minutes = twoDigits(d.inMinutes.remainder(60));
    final seconds = twoDigits(d.inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
  }

  void _salvarCarga(int id) {
    final valor = _cargaControllers[id]?.text ?? '0';
    // Aqui você pode salvar a carga no banco de dados, estado global, etc.
    // Por enquanto, só print para teste
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
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFD7DAFF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Imagem/ícone - substitua pelo seu asset ou animation
          Container(
            width: 50,
            height: 50,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF8E6EFF), // roxo escuro para contraste
            ),
            child: const Icon(Icons.fitness_center, color: Colors.white),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(nome,
                    style: GoogleFonts.leagueSpartan(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF8E6EFF),
                    )),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Série:", style: TextStyle(fontWeight: FontWeight.w600)),
                          const SizedBox(height: 4),
                          Text(serie),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Repetições:", style: TextStyle(fontWeight: FontWeight.w600)),
                          const SizedBox(height: 4),
                          Text(repeticoes),
                        ],
                      ),
                    ),
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
                )
              ],
            ),
          ),
          const SizedBox(width: 10),
          IconButton(
            icon: const Icon(Icons.save, color: Color(0xFF8E6EFF)),
            onPressed: () => _salvarCarga(id),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF8910F0),
        title: Text(
          'Treino',
          style: GoogleFonts.leagueSpartan(fontWeight: FontWeight.w700, fontSize: 20),
        ),
        centerTitle: true,
        elevation: 0,
        leading: const BackButton(color: Colors.white),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              // Cronômetro no topo
              Text(
                _formatDuration(_elapsed),
                style: GoogleFonts.leagueSpartan(
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF8E6EFF),
                ),
              ),
              const SizedBox(height: 15),

              // Lista dos 6 exercícios
              Expanded(
                child: ListView.builder(
                  itemCount: exercicios.length,
                  itemBuilder: (context, index) => buildExercicio(exercicios[index]),
                ),
              ),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8910F0), // cor roxa uniforme
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () {
                    _timer.cancel(); // pare o timer antes de navegar

                    showDialog(
                      context: context,
                      barrierDismissible: false, // força o usuário usar o botão fechar
                      builder: (context) => AlertDialog(
                        title: const Text("Treino finalizado!"),
                        content: const Text("Parabéns pelo seu treino."),
                        actions: [
                          TextButton(
                            child: const Text("Fechar"),
                            onPressed: () {
                              Navigator.of(context).pop(); // fecha o diálogo
                
                              // Navega para a página inicial após fechar o diálogo
                              context.go('/paginaInicial'); // verifique o routePath correto
                            },
                          ),
                        ],
                      ),
                    );
                  },
                  child: Text(
                    "Finalizar treino",
                    style: GoogleFonts.leagueSpartan(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
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