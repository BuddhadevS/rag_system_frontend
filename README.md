# RAG Studio

Flutter web frontend for the RAG Document Q&A API.

## Run

```bash
# Start the Spring backend (separate repo / Docker) on :8080
flutter pub get
flutter run -d chrome
```

API base URL defaults to `http://localhost:8080/api`. Override with:

```bash
flutter run -d chrome --dart-define=API_BASE_URL=http://host:8080/api
```

## What it does

- Upload PDF / PNG / JPEG (≤ 50 MB)
- Poll ingestion status until Ready or Failed
- Ask grounded questions with Question → Answer → Sources
- List, paginate, and delete documents
- Live API health indicator

See `frontend/README.md` and `frontend/backend_implementation.md`.

**API URL:** `http://172.16.16.111:8080/api` (your LAN IP).
