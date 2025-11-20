import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tcc_1/tela_treino_fixo/treino_fixo_widget.dart';
import 'package:tcc_1/tela_treino_fixo/treino_model.dart';
import '/index.dart'; // Importa os widgets
import '/main.dart';  // Importa a NavBarPage

// ***************************************************************
// 1. App State Notifier
// ***************************************************************

class AppStateNotifier extends ChangeNotifier {
  static final AppStateNotifier _instance = AppStateNotifier._internal();
  factory AppStateNotifier() => _instance;
  AppStateNotifier._internal();
  
  static AppStateNotifier get instance => _instance;

  bool _loggedIn = false;
  bool get loggedIn => _loggedIn;

  bool _isAuthStatusChecked = false;
  bool get isAuthStatusChecked => _isAuthStatusChecked;
  
  void initialize() {
    Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      final Session? session = data.session;
      final bool newLoggedInState = session != null;
      
      if (_loggedIn != newLoggedInState) {
        _loggedIn = newLoggedInState;
        notifyListeners(); 
      }

      if (!_isAuthStatusChecked) {
        _isAuthStatusChecked = true;
        notifyListeners(); 
      }
    });
  }

  void update(bool loggedIn) {
    _loggedIn = loggedIn;
    notifyListeners();
  }
}

// ***************************************************************
// 2. Definição das Rotas
// ***************************************************************

const String routeTelaCarregamento = 'telaCarregamento';
const String routeTelaInicio = 'telaInicio';
const String routeTelaLogin = 'telaLogin';
const String routeTelaCriarConta = 'telaCriarConta';
const String routeTelaEsqueciSenha = 'telaEsqueciSenha';
const String routePaginaInicial = 'paginaInicial';
const String routeTelaCompletarPerfil = 'telaCompletarPerfil';
const String routeTreinoFixo = 'treinoFixo'; // Rota genérica para execução

const List<String> publicRoutes = [
  routeTelaCarregamento, 
  routeTelaInicio,
  routeTelaLogin,
  routeTelaCriarConta,
  routeTelaEsqueciSenha,
];

GoRouter createRouter(AppStateNotifier appStateNotifier) => GoRouter(
      initialLocation: '/telaCarregamento', 
      debugLogDiagnostics: true,
      refreshListenable: appStateNotifier,
      
      routes: [
        // --- ROTAS PÚBLICAS ---
        GoRoute(
          path: '/telaCarregamento',
          name: routeTelaCarregamento,
          builder: (context, state) => const TelaCarregamentoWidget(),
        ),
        GoRoute(
          path: '/telaInicio',
          name: routeTelaInicio,
          builder: (context, state) => const TelaInicioWidget(),
        ),
        GoRoute(
          path: '/telaLogin',
          name: routeTelaLogin,
          builder: (context, state) => const TelaLoginWidget(),
        ),
        GoRoute(
          path: '/telaCriarConta',
          name: routeTelaCriarConta,
          builder: (context, state) => const TelaCriarContaWidget(),
        ),
        GoRoute(
          path: '/telaEsqueciSenha',
          name: routeTelaEsqueciSenha,
          builder: (context, state) => const TelaEsqueciSenhaWidget(),
        ),

        // --- ROTA DE COMPLETAR PERFIL ---
        GoRoute(
          path: '/telaCompletarPerfil',
          name: routeTelaCompletarPerfil,
          builder: (context, state) => const TelaCompletarPerfilWidget(),
        ),
        
        // --- ROTA DE EXECUÇÃO DE TREINO (GENÉRICA) ---
        GoRoute(
          path: '/execucao',
          name: routeTreinoFixo,
          builder: (context, state) {
            // Recupera o objeto Treino passado como argumento extra
            final treino = state.extra as Treino?;
            // Fallback: Se não vier treino, volta para o início (evita tela vermelha)
            if (treino == null) {
               return const PaginaInicialWidget(); 
            }
            return TreinoFixoWidget(treino: treino);
          },
        ),

        // --- ROTA PRINCIPAL COM BARRA DE NAVEGAÇÃO (NAVBAR) ---
        GoRoute(
          path: '/paginaInicial', 
          name: 'NavBarPage', 
          builder: (context, state) => const NavBarPage(initialPage: routePaginaInicial), 
          routes: [
            // Abas
            GoRoute(
              path: 'paginaInicial', 
              name: routePaginaInicial,
              builder: (context, state) => const NavBarPage(initialPage: routePaginaInicial),
            ),
            GoRoute(
              path: 'telaEvolucao',
              name: 'telaEvolucao',
              builder: (context, state) => const NavBarPage(initialPage: 'telaEvolucao'),
            ),
            GoRoute(
              path: 'telaPerfil',
              name: 'telaPerfil',
              builder: (context, state) => const NavBarPage(initialPage: 'telaPerfil'),
            ),
            
            // Rotas filhas (mantêm a NavBar)
            GoRoute(
              path: 'telaConfiguracoes',
              name: 'telaConfiguracoes',
              builder: (context, state) => const TelaConfiguracoesWidget(),
            ),
            GoRoute(
              path: 'deletarConta',
              name: 'deletarConta',
              builder: (context, state) => const DeletarContaWidget(),
            ),
            GoRoute(
              path: 'alterarSenha',
              name: 'alterarSenha',
              builder: (context, state) => const AlterarSenhaWidget(),
            ),

            // Telas de Listagem de Níveis
            GoRoute(
              path: 'telaTreinoAvancado',
              name: 'telaTreinoAvancado',
              builder: (context, state) => const TelaTreinoAvancadoWidget(),
            ),
            GoRoute(
              path: 'telaAvancado',
              name: 'telaAvancado',
              builder: (context, state) => const TelaAvancadoWidget(),
            ),
            GoRoute(
              path: 'telaIniciante',
              name: 'telaIniciante',
              builder: (context, state) => const TelaInicianteWidget(),
            ),
            GoRoute(
              path: 'telaIntermediario',
              name: 'telaIntermediario',
              builder: (context, state) => const TelaIntermediarioWidget(),
            ),
          ],
        ),
      ],
      
      redirect: (context, state) {
        if (!appStateNotifier.isAuthStatusChecked) {
          return null;
        }

        final loggedIn = appStateNotifier.loggedIn;
        final location = state.matchedLocation.replaceAll('/', '');
        
        final isPublic = publicRoutes.contains(location);
        
        if (location == routeTelaCarregamento) {
             if (loggedIn) {
                return '/paginaInicial';
            } else {
                return '/telaInicio'; 
            }
        }

        if (!loggedIn && !isPublic) {
          return '/telaLogin'; 
        }
        
        if (loggedIn && (location == routeTelaLogin ||
                         location == routeTelaCriarConta ||
                         location == routeTelaEsqueciSenha || 
                         location == routeTelaInicio)) {
          return '/paginaInicial'; 
        }
        
        return null;
      },
    );