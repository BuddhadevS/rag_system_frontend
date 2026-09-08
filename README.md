# DocuMind — RAG Document Q&A

A Flutter web application that lets users upload documents and ask natural-language questions about their content, powered by a Retrieval-Augmented Generation (RAG) backend.

## What it is

DocuMind is a browser-based frontend for a Spring Boot RAG API. It bridges the user and an AI pipeline that ingests documents, chunks and embeds them, then retrieves the most relevant passages to ground an LLM answer.

## Purpose

Enable users to query the contents of their own documents without reading them manually — upload once, ask anything, get cited answers.

## What it handles

| Capability | Detail |
|---|---|
| Document upload | PDF, PNG, JPEG up to 50 MB via multipart POST |
| Ingestion tracking | Polls `GET /documents/{id}/status` until `Ready` or `Failed` |
| Document library | Paginated list (20/page), metadata view, delete |
| Grounded Q&A | Sends question + document ID, receives answer + ranked source excerpts with relevance scores |
| Q&A history | Per-document conversation history stored client-side (`shared_preferences`) |
| API health | Live indicator polling `GET /health` every 30 s |
| Error handling | Typed `ApiException` with parsed backend error responses |

## Architecture

```
lib/
├── config/        # ApiConfig (base URL, timeouts, limits)
├── data/          # RagApiClient (Dio), models, file validator
├── domain/        # QaHistoryStore, StatusPoller
├── state/         # ChangeNotifier controllers (documents, health, detail)
└── ui/            # Screens, shell, components, theme
```

State is managed with `provider`. Routing uses `go_router` (`/` → document list, `/documents/:id` → detail + Q&A).

## Run

```bash
flutter pub get
flutter run -d chrome
```

API base URL defaults to `http://172.16.16.111:8080/api`. Override with:

```bash
flutter run -d chrome --dart-define=API_BASE_URL=http://<host>:8080/api
```

Backend (Spring Boot) must be running separately on port `8080`.
