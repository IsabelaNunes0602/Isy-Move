import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import '../../main/pagina_inicial/pagina_inicial_widget.dart'; 

import 'tela_completar_perfil_model.dart';
export 'tela_completar_perfil_model.dart';

class TelaCompletarPerfilWidget extends StatefulWidget {
  const TelaCompletarPerfilWidget({super.key});

  static const String routeName = 'telaCompletarPerfil';
  static const String routePath = '/telaCompletarPerfil';

  @override
  State<TelaCompletarPerfilWidget> createState() =>
      _TelaCompletarPerfilWidgetState();
}

class _TelaCompletarPerfilWidgetState extends State<TelaCompletarPerfilWidget> {
  late TelaCompletarPerfilModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => TelaCompletarPerfilModel());

    _model.nomeController = TextEditingController();
    _model.telefoneController = TextEditingController();
    _model.dataController = TextEditingController();
    _model.pesoController = TextEditingController();

    _model.nomeFocus = FocusNode();
    _model.telefoneFocus = FocusNode();
    _model.dataFocus = FocusNode();
    _model.pesoFocus = FocusNode();
    
    _model.generoController ??= FormFieldController<String>(null);
    _model.nivelController ??= FormFieldController<String>(null);
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  // --- Função auxiliar Data ---
  String? _converterDataParaSQL(String dataBrasileira) {
    try {
      final parts = dataBrasileira.split('/');
      if (parts.length != 3) return null;
      // Garante que tenha 2 digitos (ex: 1 -> 01
      final dia = parts[0].padLeft(2, '0');
      final mes = parts[1].padLeft(2, '0');
      final ano = parts[2];
      return '$ano-$mes-$dia'; 
    } catch (e) {
      return null;
    }
  }

  // --- WIDGET CUSTOMIZADO ---
  Widget _buildCustomRadioRow({
    required List<String> options,
    required FormFieldController<String> controller,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: options.map((option) {
        final isSelected = controller.value == option;
        
        return Padding(
          padding: const EdgeInsets.only(right: 15.0), // Espaço entre opções
          child: InkWell(
            onTap: () {
              setState(() {
                controller.value = option;
              });
            },
            borderRadius: BorderRadius.circular(20),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Simula o Radio com Ícones
                Icon(
                  isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                  color: isSelected ? const Color(0xFF8910F0) : Colors.grey,
                  size: 24,
                ),
                const SizedBox(width: 6), // Espaço entre bolinha e texto
                Text(
                  option,
                  style: GoogleFonts.nunito(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTF({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String hintText,
    required String labelText,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        keyboardType: keyboardType,
        validator: validator,
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          filled: true,
          fillColor: Colors.white,
          labelStyle: GoogleFonts.nunito(color: const Color(0xFF262A2F)),
          hintStyle: GoogleFonts.nunito(color: const Color(0xFF989A9C)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFFA3A5AD)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFF8910F0)), 
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
        ),
      ),
    );
  }

  Future<void> _salvarPerfil() async {
    if (_isLoading) return;

    final user = Supabase.instance.client.auth.currentUser;
    
    if (user == null) {
      final session = Supabase.instance.client.auth.currentSession;
      if (session == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text("Erro: Usuário não autenticado."),
          ),
        );
        return;
      }
    }

    final userId = user?.id ?? Supabase.instance.client.auth.currentUser!.id;
    final email = user?.email ?? Supabase.instance.client.auth.currentUser!.email;

    final nome = _model.nomeController!.text.trim();
    final telefone = _model.telefoneController!.text.trim();
    final nascimentoStr = _model.dataController!.text.trim();
    final peso = double.tryParse(_model.pesoController!.text.replaceAll(',', '.'));
    final genero = _model.generoController?.value;
    final nivelSelecionado = _model.nivelController?.value;

    if (nome.isEmpty || telefone.isEmpty || nascimentoStr.isEmpty || genero == null || nivelSelecionado == null || peso == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(backgroundColor: Colors.orange, content: Text("Por favor, preencha todos os campos.")),
      );
      return;
    }

    final dataSQL = _converterDataParaSQL(nascimentoStr);
    if (dataSQL == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Data inválida. Use DD/MM/AAAA")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final supabase = Supabase.instance.client;

      // 1. Salvar na tabela 'usuario'
      await supabase.from('usuario').upsert({
        'id_usuario': userId,
        'email_usuario': email,
        'nome_usuario': nome,
        'telefone_usuario': telefone,
        'genero_usuario': genero,
        'datanasc_usuario': dataSQL,
        'pesoAtual': peso,
        'metaPeso': peso,
        'nivel_usuario': nivelSelecionado,
      }, onConflict: 'id_usuario');


      // --- Lógica da Régua Cumulativa ---
      
      int treinosIniciais = 0; // Padrão para Iniciante

      if (nivelSelecionado == 'Intermediário') {
        // Se escolheu Intermediário, já "fez" os 15 do iniciante
        treinosIniciais = 15;
      } 
      else if (nivelSelecionado == 'Avançado') {
        // Se escolheu Avançado, já "fez" 15 (iniciante) + 40 (intermediário)
        treinosIniciais = 55;
      }
      
      // --------------------------------------------------------

      // 2. Inicializar a tabela 'progresso' com o valor calculado
      await supabase.from('progresso').upsert({
        'id_usuario': userId,
        'treinos_concluidos': treinosIniciais,
        'desconto_inicial': treinosIniciais,
        'ultimo_treino_data': DateTime.now().toIso8601String(),
      }, onConflict: 'id_usuario');

      if (!mounted) return;

      // Navega para a Home
      context.goNamed(PaginaInicialWidget.routeName);

    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(backgroundColor: Colors.red, content: Text("Erro ao salvar: $e")),
      );
      setState(() => _isLoading = false);
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
          title: Text(
            'Complete seu perfil',
            style: GoogleFonts.leagueSpartan(
              color: Colors.white,
              fontSize: 30,
            ),
          ),
          centerTitle: true,
          elevation: 2,
        ),
        body: SafeArea(
          top: true,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Foto de Perfil (Placeholder)
                  Center(
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/Mask_group_(6).png', 
                        width: 106, height: 106, fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => 
                          const Icon(Icons.account_circle, size: 106, color: Colors.grey),
                      ),
                    ),
                  ),
                  const SizedBox(height: 36),

                  _buildTF(
                    controller: _model.nomeController!,
                    focusNode: _model.nomeFocus!,
                    labelText: 'Nome completo',
                    hintText: 'Digite seu nome completo',
                  ),

                  _buildTF(
                    controller: _model.telefoneController!,
                    focusNode: _model.telefoneFocus!,
                    labelText: 'Telefone',
                    hintText: '(00) 00000-0000',
                    keyboardType: TextInputType.phone,
                  ),

                  const SizedBox(height: 22),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Gênero', style: GoogleFonts.leagueSpartan(fontWeight: FontWeight.w500, fontSize: 22)),
                  ),
                  
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: _buildCustomRadioRow(
                      options: ['Masculino', 'Feminino', 'Outro'],
                      controller: _model.generoController!,
                    ),
                  ),

                  const SizedBox(height: 22),
                  _buildTF(
                    controller: _model.dataController!,
                    focusNode: _model.dataFocus!,
                    labelText: 'Data de nascimento',
                    hintText: 'DD/MM/AAAA',
                    keyboardType: TextInputType.datetime,
                  ),

                  _buildTF(
                    controller: _model.pesoController!,
                    focusNode: _model.pesoFocus!,
                    labelText: 'Peso',
                    hintText: 'Kg (ex: 70.5)',
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  ),

                  const SizedBox(height: 22),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Nível de atividade física', style: GoogleFonts.leagueSpartan(fontWeight: FontWeight.w500, fontSize: 22)),
                  ),
                  
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: _buildCustomRadioRow(
                      options: ['Iniciante', 'Intermediário', 'Avançado'],
                      controller: _model.nivelController!,
                    ),
                  ),

                  const SizedBox(height: 40),
                  
                  FFButtonWidget(
                    onPressed: _isLoading ? null : _salvarPerfil,
                    text: _isLoading ? 'Salvando...' : 'Completar perfil',
                    options: FFButtonOptions(
                      height: 50,
                      color: primaryColor,
                      textStyle: GoogleFonts.leagueSpartan(
                        color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600,
                      ),
                      borderRadius: BorderRadius.circular(8),
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
}