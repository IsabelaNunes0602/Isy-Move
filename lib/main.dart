import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; 
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import 'flutter_flow/flutter_flow_util.dart';
import 'flutter_flow/internationalization.dart';

import 'index.dart';
import 'package:tcc_1/main/pagina_inicial/pagina_inicial_model.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GoRouter.optionURLReflectsImperativeAPIs = true;
  usePathUrlStrategy();

  // Inicializações do Backend e Tema
  await SupaFlow.initialize();
  await FlutterFlowTheme.initialize();

  final appState = FFAppState(); 
  await appState.initializePersistedState();
  
  final appStateNotifier = AppStateNotifier.instance; 
  appStateNotifier.initialize(); 

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<FFAppState>.value(value: appState),
        ChangeNotifierProvider<AppStateNotifier>.value(value: appStateNotifier),
        // Mantém o Model da Home global para persistir o nível do usuário
        ChangeNotifierProvider(create: (context) => PaginaInicialModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => MyAppState();

  static MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<MyAppState>()!;
}

// Acesso via ferramentas do FlutterFlow
class MyAppState extends State<MyApp> {
  Locale? _locale;
  ThemeMode _themeMode = FlutterFlowTheme.themeMode;

  late final AppStateNotifier _appStateNotifier;
  late final GoRouter _router;

  // --- Métodos Utilitários do FlutterFlow ---
  String getRoute([RouteMatch? routeMatch]) {
    final RouteMatch lastMatch = routeMatch ?? _router.routerDelegate.currentConfiguration.last;
    final RouteMatchList matchList = lastMatch is ImperativeRouteMatch
        ? lastMatch.matches
        : _router.routerDelegate.currentConfiguration;
    return matchList.uri.toString();
  }

  List<String> getRouteStack() =>
      _router.routerDelegate.currentConfiguration.matches
          .map((e) => getRoute(e))
          .toList();
  // ------------------------------------------

  @override
  void initState() {
    super.initState();
    _appStateNotifier = AppStateNotifier.instance;
    _router = createRouter(_appStateNotifier); // Chama a função do nav.dart
  }

  void setLocale(String language) {
    safeSetState(() => _locale = createLocale(language));
  }

  void setThemeMode(ThemeMode mode) => safeSetState(() {
        _themeMode = mode;
        FlutterFlowTheme.saveThemeMode(mode);
      });

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Isy Move',
      localizationsDelegates: const [
        FFLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        FallbackMaterialLocalizationDelegate(),
        FallbackCupertinoLocalizationDelegate(),
      ],
      locale: _locale,
      supportedLocales: const [
        Locale('pt'),
      ],
      theme: ThemeData(
        brightness: Brightness.light,
        useMaterial3: false,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: false,
      ),
      themeMode: _themeMode,
      routerConfig: _router, 
    );
  }
}

class NavBarPage extends StatefulWidget {
  const NavBarPage({
    super.key,
    this.initialPage,
    this.page,
    this.disableResizeToAvoidBottomInset = false,
  });

  final String? initialPage;
  final Widget? page;
  final bool disableResizeToAvoidBottomInset;

  @override
  NavBarPageState createState() => NavBarPageState();
}

class NavBarPageState extends State<NavBarPage> {
  String _currentPageName = 'paginaInicial';
  late Widget? _currentPage;

  @override
  void initState() {
    super.initState();
    _currentPageName = widget.initialPage ?? _currentPageName;
    _currentPage = widget.page;
  }

  @override
  Widget build(BuildContext context) {
    final tabs = {
      PaginaInicialWidget.routeName: const PaginaInicialWidget(),
      TelaEvolucaoWidget.routeName: const TelaEvolucaoWidget(),
      TelaPerfilWidget.routeName: const TelaPerfilWidget(),
    };
    
    final currentIndex = tabs.keys.toList().indexOf(_currentPageName);

    return Scaffold(
      resizeToAvoidBottomInset: !widget.disableResizeToAvoidBottomInset,
      body: _currentPage ?? tabs[_currentPageName],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex != -1 ? currentIndex : 0,
        onTap: (i) => safeSetState(() {
          _currentPage = null;
          _currentPageName = tabs.keys.toList()[i];
          // Navega usando o GoRouter para manter a URL e histórico corretos
          context.goNamed(_currentPageName);
        }),
        backgroundColor: Colors.white, 
        selectedItemColor: const Color(0xFF8910F0),
        unselectedItemColor: const Color(0xFF95A1AC), 
        showSelectedLabels: true, 
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined, size: 24.0),
            activeIcon: Icon(Icons.home_rounded, size: 24.0),
            label: 'Home',
            tooltip: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.show_chart_rounded, size: 24.0), 
            activeIcon: Icon(Icons.show_chart, size: 24.0),
            label: 'Evolução',
            tooltip: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline, size: 24.0),
            activeIcon: Icon(Icons.person, size: 24.0),
            label: 'Perfil',
            tooltip: '',
          )
        ],
      ),
    );
  }
}