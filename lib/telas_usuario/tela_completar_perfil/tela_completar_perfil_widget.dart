import 'package:go_router/go_router.dart';

import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
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
    
    // Inicializa os controllers dos radios
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
      return '${parts[2]}-${parts[1]}-${parts[0]}'; 
    } catch (e) {
      return null;
    }
  }

  // --- WIDGET CUSTOMIZADO PARA RADIO HORIZONTAL ---
  Widget _buildCustomRadioRow({
    required List<String> options,
    required FormFieldController<String> controller,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: options.map((option) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Radio<String>(
              value: option,
              groupValue: controller.value,
              activeColor: const Color(0xFF8910F0),
              onChanged: (value) {
                setState(() {
                  controller.value = value;
                });
              },
            ),
            Text(
              option,
              style: GoogleFonts.nunito(
                fontSize: 14, // Fonte um pouco menor para caber na linha
                color: Colors.black, // Força a cor preta
                fontWeight: controller.value == option ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            const SizedBox(width: 5), // Espaço entre os itens
          ],
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
            borderSide: const BorderSide(color: Color(0xFF8910F0)), // Borda roxa ao focar
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
        ),
      ),
    );
  }

  Future<void> _salvarPerfil() async {
    if (_isLoading) return;

    final user = Supabase.instance.client.auth.currentUser;
    
    // Verificação dupla para debug
    if (user == null) {
      // Tenta buscar a sessão novamente caso tenha havido delay
      final session = Supabase.instance.client.auth.currentSession;
      if (session == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text("Erro: Usuário não autenticado. Verifique se confirmou o email ou desligue a confirmação no Supabase."),
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

      // 2. Inicializar a tabela 'progresso'
      // Importante: Usamos upsert aqui também para evitar erro se o usuário clicar duas vezes
      await supabase.from('progresso').upsert({
        'id_usuario': userId,
        'treinos_concluidos': 0,
        'nivel_atual': nivelSelecionado, // Use o nível que acabou de ser selecionado
        'ultima_atualizacao': DateTime.now().toIso8601String(),
      }, onConflict: 'id_usuario'); // Se já existir, não duplica, apenas atualiza

      if (!mounted) return;

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
    const Color primaryColor = Color(0xFF8910F0); // Cor sólida corrigida

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
                  
                  // --- AQUI ESTÁ A MUDANÇA PARA HORIZONTAL ---
                  // Usando SingleChildScrollView horizontal caso a tela seja pequena
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
                  
                  // --- MUDANÇA PARA HORIZONTAL ---
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