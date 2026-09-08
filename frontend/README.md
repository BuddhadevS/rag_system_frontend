# RAG Studio (Flutter Web)

Browser UI for the RAG Document Q&A API (`http://localhost:8080/api`).

## Run

```bash
# Backend must be up on your LAN IP
flutter pub get
flutter run -d chrome --dart-define=API_BASE_URL=http://172.16.16.111:8080/api
```

Default `ApiConfig.baseUrl` is already `http://172.16.16.111:8080/api`.

Custom API URL:

```bash
flutter run -d chrome --dart-define=API_BASE_URL=http://172.16.16.111:8080/api
```

## Features (API coverage)

| Action | Endpoint |
|--------|----------|
| Health indicator | `GET /health` |
| Upload PDF/PNG/JPEG | `POST /documents/upload` |
| Status polling | `GET /documents/{id}/status` |
| List / paginate | `GET /documents` |
| Detail metadata | `GET /documents/{id}` |
| Delete | `DELETE /documents/{id}` |
| Ask + sources | `POST /query` |

Q&A history is client-side (`shared_preferences`, key `rag.qa.{id}`).

## Plan reference

See `frontend/backend_implementation.md` (frontend plan v001).
