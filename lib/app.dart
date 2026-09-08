import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'config/api_config.dart';
import 'data/rag_api_client.dart';
import 'domain/qa_history_store.dart';
import 'state/documents_controller.dart';
import 'state/health_controller.dart';
import 'ui/detail/document_detail_screen.dart';
import 'ui/home/documents_screen.dart';
import 'ui/shell/app_shell.dart';
import 'ui/theme/app_theme.dart';

class RagApp extends StatefulWidget {
  const RagApp({super.key});

  @override
  State<RagApp> createState() => _RagAppState();
}

class _RagAppState extends State<RagApp> {
  late final RagApiClient _api;
  late final QaHistoryStore _history;
  late final HealthController _health;
  late final DocumentsController _documents;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _api = RagApiClient();
    _history = QaHistoryStore();
    _health = HealthController(_api)..start();
    _documents = DocumentsController(_api, _history);
    _router = GoRouter(
      initialLocation: '/',
      routes: [
        ShellRoute(
          builder: (context, state, child) => AppShell(child: child),
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => const DocumentsScreen(),
            ),
            GoRoute(
              path: '/documents/:id',
              builder: (context, state) {
                final id = int.tryParse(state.pathParameters['id'] ?? '') ?? -1;
                return DocumentDetailScreen(documentId: id);
              },
            ),
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    _health.dispose();
    _documents.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider.value(value: _api),
        Provider.value(value: _history),
        ChangeNotifierProvider.value(value: _health),
        ChangeNotifierProvider.value(value: _documents),
      ],
      child: MaterialApp.router(
        title: 'DocuMind',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        routerConfig: _router,
        builder: (context, child) {
          return child ?? const SizedBox.shrink();
        },
      ),
    );
  }
}

/// Visible in debug overlays / tooltips.
String get apiBaseUrlLabel => ApiConfig.baseUrl;
