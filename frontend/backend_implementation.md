# Frontend ↔ Backend implementation notes

This Flutter web app talks to the Spring RAG API from
`/Users/buddhadev/Downloads/RAG_Q-A_system`.

**Configured API base URL:** `http://172.16.16.111:8080/api`

## Why “cannot reach the API” happened

1. `rag-app` was **not running** (Flyway checksum mismatch crashed startup).
2. Postgres + Ollama were up; only the Spring app was down.
3. Frontend defaulted to `localhost` — now defaults to your LAN IP `172.16.16.111`.

## Backend APIs (already implemented — from graph)

| Method | Path | Controller |
|--------|------|------------|
| GET | `/health` | `HealthController` |
| POST | `/documents/upload` | `DocumentController.upload` |
| GET | `/documents/{id}/status` | `DocumentController.status` |
| GET | `/documents/{id}` | `DocumentController.get` |
| GET | `/documents` | `DocumentController.list` |
| DELETE | `/documents/{id}` | `DocumentController.delete` |
| POST | `/query` | `QueryController.ask` |

CORS allowlist includes `http://172.16.16.111:*`.

## Run stack

```bash
cd /Users/buddhadev/Downloads/RAG_Q-A_system
docker compose up -d
curl http://172.16.16.111:8080/api/health
```

## Run frontend

```bash
cd /Users/buddhadev/AndroidStudioProjects/rag_system
flutter run -d chrome --dart-define=API_BASE_URL=http://172.16.16.111:8080/api
```
