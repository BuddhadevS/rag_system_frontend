# Graph Report - rag_system  (2026-09-08)

## Corpus Check
- 56 files · ~22,810 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 555 nodes · 739 edges · 44 communities (36 shown, 8 thin omitted)
- Extraction: 99% EXTRACTED · 1% INFERRED · 0% AMBIGUOUS · INFERRED: 6 edges (avg confidence: 0.8)
- Token cost: 0 input · 0 output

## Community Hubs (Navigation)
- [[_COMMUNITY_Community 0|Community 0]]
- [[_COMMUNITY_Community 1|Community 1]]
- [[_COMMUNITY_Community 2|Community 2]]
- [[_COMMUNITY_Community 3|Community 3]]
- [[_COMMUNITY_Community 4|Community 4]]
- [[_COMMUNITY_Community 5|Community 5]]
- [[_COMMUNITY_Community 6|Community 6]]
- [[_COMMUNITY_Community 7|Community 7]]
- [[_COMMUNITY_Community 8|Community 8]]
- [[_COMMUNITY_Community 9|Community 9]]
- [[_COMMUNITY_Community 10|Community 10]]
- [[_COMMUNITY_Community 11|Community 11]]
- [[_COMMUNITY_Community 12|Community 12]]
- [[_COMMUNITY_Community 13|Community 13]]
- [[_COMMUNITY_Community 14|Community 14]]
- [[_COMMUNITY_Community 15|Community 15]]
- [[_COMMUNITY_Community 19|Community 19]]
- [[_COMMUNITY_Community 20|Community 20]]
- [[_COMMUNITY_Community 21|Community 21]]
- [[_COMMUNITY_Community 22|Community 22]]
- [[_COMMUNITY_Community 23|Community 23]]
- [[_COMMUNITY_Community 24|Community 24]]
- [[_COMMUNITY_Community 25|Community 25]]
- [[_COMMUNITY_Community 26|Community 26]]
- [[_COMMUNITY_Community 27|Community 27]]
- [[_COMMUNITY_Community 28|Community 28]]
- [[_COMMUNITY_Community 29|Community 29]]
- [[_COMMUNITY_Community 30|Community 30]]
- [[_COMMUNITY_Community 31|Community 31]]
- [[_COMMUNITY_Community 32|Community 32]]
- [[_COMMUNITY_Community 34|Community 34]]
- [[_COMMUNITY_Community 35|Community 35]]
- [[_COMMUNITY_Community 36|Community 36]]
- [[_COMMUNITY_Community 37|Community 37]]
- [[_COMMUNITY_Community 38|Community 38]]
- [[_COMMUNITY_Community 39|Community 39]]
- [[_COMMUNITY_Community 41|Community 41]]
- [[_COMMUNITY_Community 42|Community 42]]
- [[_COMMUNITY_Community 43|Community 43]]

## God Nodes (most connected - your core abstractions)
1. `DocumentsController` - 15 edges
2. `Create()` - 10 edges
3. `MessageHandler()` - 10 edges
4. `RagApiClient` - 9 edges
5. `HealthController` - 9 edges
6. `WndProc()` - 9 edges
7. `QaHistoryStore` - 7 edges
8. `DocumentDetailController` - 7 edges
9. `WindowClassRegistrar` - 7 edges
10. `Destroy()` - 7 edges

## Surprising Connections (you probably didn't know these)
- `wWinMain()` --calls--> `CreateAndAttachConsole()`  [INFERRED]
  windows/runner/main.cpp → windows/runner/utils.cpp
- `_ask` --references--> `DocumentDetailController`  [EXTRACTED]
  lib/ui/detail/document_detail_screen.dart → lib/state/document_detail_controller.dart
- `build` --references--> `DocumentDetailController`  [EXTRACTED]
  lib/ui/detail/document_detail_screen.dart → lib/state/document_detail_controller.dart
- `build` --references--> `DocumentsController`  [EXTRACTED]
  lib/ui/home/documents_screen.dart → lib/state/documents_controller.dart
- `_DocumentsScreenState` --references--> `DocumentsController`  [EXTRACTED]
  lib/ui/home/documents_screen.dart → lib/state/documents_controller.dart

## Import Cycles
- None detected.

## Communities (44 total, 8 thin omitted)

### Community 0 - "Community 0"
Cohesion: 0.09
Nodes (34): PluginRegistry, Point, RECT, Size, RegisterPlugins(), OnCreate(), HWND, LPARAM (+26 more)

### Community 1 - "Community 1"
Cohesion: 0.15
Nodes (11): app.dart, main, BannerTone, build, ErrorBanner, message, onDismiss, onRetry (+3 more)

### Community 2 - "Community 2"
Cohesion: 0.10
Nodes (16): Bool, Cocoa, file_picker, FlutterAppDelegate, FlutterMacOS, FlutterPluginRegistry, Foundation, RegisterGeneratedPlugins() (+8 more)

### Community 3 - "Community 3"
Cohesion: 0.23
Nodes (9): _In_, _In_opt_, vector, wWinMain(), string, wchar_t, CreateAndAttachConsole(), GetCommandLineArguments() (+1 more)

### Community 4 - "Community 4"
Cohesion: 0.18
Nodes (10): background_color, description, display, icons, name, orientation, prefer_related_applications, short_name (+2 more)

### Community 5 - "Community 5"
Cohesion: 0.22
Nodes (8): DartProject, HWND, LPARAM, LRESULT, UINT, FlutterWindow(), WPARAM, MessageHandler()

### Community 6 - "Community 6"
Cohesion: 0.04
Nodes (48): int?, answer, AnswerResponse, apiValue, askedAt, canAsk, chunkIndex, content (+40 more)

### Community 7 - "Community 7"
Cohesion: 0.06
Nodes (30): EdgeInsets, amber, AppColors, AppTheme, bg, bgBlue, build, child (+22 more)

### Community 8 - "Community 8"
Cohesion: 0.73
Nodes (5): install_platforms(), require_graphify(), graphify.sh script, status(), usage()

### Community 9 - "Community 9"
Cohesion: 0.06
Nodes (32): api_exception.dart, dio_web_config_stub.dart, Exception, ApiException, cause, error, rawBody, statusCode (+24 more)

### Community 11 - "Community 11"
Cohesion: 0.50
Nodes (3): RAG Studio, Run, What it does

### Community 19 - "Community 19"
Cohesion: 0.16
Nodes (15): ../components/error_banner.dart, HealthController, build, HealthDot, _AppHeader, child, package:go_router/go_router.dart, package:google_fonts/google_fonts.dart (+7 more)

### Community 20 - "Community 20"
Cohesion: 0.05
Nodes (36): bool get, CancelToken?, ../../config/api_config.dart, ../domain/status_poller.dart, allowedExtensions, allowedMimes, error, fail (+28 more)

### Community 21 - "Community 21"
Cohesion: 0.07
Nodes (26): active, asking, controller, createState, dispose, document, documentId, documentName (+18 more)

### Community 22 - "Community 22"
Cohesion: 0.07
Nodes (29): dart:async, ../data/api_exception.dart, ../../data/rag_api_client.dart, DateTime?, DateTime? get, api, _delayFor, documentId (+21 more)

### Community 23 - "Community 23"
Cohesion: 0.11
Nodes (17): ../components/status_chip.dart, DocumentResponse, _clearSelection, createState, document, file, _formatSize, _hover (+9 more)

### Community 24 - "Community 24"
Cohesion: 0.10
Nodes (18): Color get, dart:convert, ../../data/models.dart, ProcessingStatus, append, clear, _key, load (+10 more)

### Community 25 - "Community 25"
Cohesion: 0.17
Nodes (11): ../../data/file_validator.dart, build, _busy, createState, _file, _formatSize, _localError, _pick (+3 more)

### Community 26 - "Community 26"
Cohesion: 0.12
Nodes (15): QaTurn, SourceDocumentResponse, accent, build, child, label, QaHistoryList, QaTurnCard (+7 more)

### Community 27 - "Community 27"
Cohesion: 0.12
Nodes (16): ../../domain/qa_history_store.dart, DocumentPage, _api, banner, clearMessages, currentPage, deleteDocument, error (+8 more)

### Community 28 - "Community 28"
Cohesion: 0.15
Nodes (12): ApiConfig, baseUrl, connectTimeout, defaultReadTimeout, healthPollInterval, maxFileBytes, maxQuestionLength, pageSize (+4 more)

### Community 29 - "Community 29"
Cohesion: 0.12
Nodes (17): _AnswerCard, _ConversationTurn, _DocumentInfoCard, _ProcessingCard, _QuestionSection, _ReadyBanner, _SourceSection, _Step (+9 more)

### Community 30 - "Community 30"
Cohesion: 0.20
Nodes (9): [Flutter Frontend], Implementation Plan - RAG Q-A System Frontend, Manual Verification, [MODIFY] [main.dart](file:///Users/buddhadev/AndroidStudioProjects/rag_system/lib/main.dart), [NEW] [graphify_service.dart](file:///Users/buddhadev/AndroidStudioProjects/rag_system/lib/graphify_service.dart), [NEW] [models.dart](file:///Users/buddhadev/AndroidStudioProjects/rag_system/lib/models.dart), Proposed Changes, User Review Required (+1 more)

### Community 31 - "Community 31"
Cohesion: 0.25
Nodes (8): ChangeNotifier, DocumentDetailController, _ask, _newDocument, _WorkspaceBody, _WorkspaceBodyState, build, Route /

### Community 32 - "Community 32"
Cohesion: 0.32
Nodes (8): RagApp, _RagAppState, DocumentsScreen, _DocumentsScreenState, UploadSheet, _UploadSheetState, State, StatefulWidget

### Community 34 - "Community 34"
Cohesion: 0.40
Nodes (4): Features (API coverage), Plan reference, RAG Studio (Flutter Web), Run

### Community 35 - "Community 35"
Cohesion: 0.33
Nodes (5): Backend APIs (already implemented — from graph), Frontend ↔ Backend implementation notes, Run frontend, Run stack, Why “cannot reach the API” happened

### Community 36 - "Community 36"
Cohesion: 0.40
Nodes (4): package:flutter_test/flutter_test.dart, package:rag_system/data/file_validator.dart, package:rag_system/data/models.dart, main

### Community 41 - "Community 41"
Cohesion: 0.12
Nodes (15): GoRouter, _api, apiBaseUrlLabel, build, createState, dispose, _documents, _health (+7 more)

### Community 42 - "Community 42"
Cohesion: 0.33
Nodes (6): DocumentsController, build, initState, _upload, AppShell, _submit

### Community 43 - "Community 43"
Cohesion: 0.67
Nodes (4): RagApiClient, QaHistoryStore, build, DocumentDetailScreen

## Knowledge Gaps
- **291 isolated node(s):** `$schema`, `plugin`, `@opencode-ai/plugin`, `_api`, `_history` (+286 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **8 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `RagApiClient` connect `Community 43` to `Community 41`, `Community 9`, `Community 20`, `Community 21`, `Community 22`, `Community 27`?**
  _High betweenness centrality (0.042) - this node is a cross-community bridge._
- **Why does `DocumentResponse` connect `Community 23` to `Community 20`, `Community 21`, `Community 6`?**
  _High betweenness centrality (0.033) - this node is a cross-community bridge._
- **Why does `ProcessingStatus` connect `Community 24` to `Community 20`, `Community 21`, `Community 6`?**
  _High betweenness centrality (0.021) - this node is a cross-community bridge._
- **What connects `$schema`, `plugin`, `@opencode-ai/plugin` to the rest of the system?**
  _291 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `Community 0` be split into smaller, more focused modules?**
  _Cohesion score 0.08658536585365853 - nodes in this community are weakly interconnected._
- **Should `Community 2` be split into smaller, more focused modules?**
  _Cohesion score 0.10144927536231885 - nodes in this community are weakly interconnected._
- **Should `Community 6` be split into smaller, more focused modules?**
  _Cohesion score 0.04081632653061224 - nodes in this community are weakly interconnected._