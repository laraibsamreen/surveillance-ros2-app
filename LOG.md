# Engineering Work Ledger & Daily Standup Log

## 1. Frozen Port Registry (Strict — Never change without M5 approval)
| Port | Service | Owner | Protocol |
|---|---|---|---|
| `9090` | rosbridge_server | M3 | WebSocket (JSON) |
| `8000` | FastAPI Analytics Backend | M4 | HTTP REST |
| `5050` | AI Commander Microservice | M4 | HTTP REST |
| `5432` | PostgreSQL Database Engine | M4 | TCP/IP |

---

## 2. Daily Standup Log Entries

### 2026-10-19 — M5
- **Done:** Monorepo initialized, directory structure established, CI/CD pipeline committed, PR template deployed.
- **Doing:** Auditing local developer environments (Flutter SDK for M1, WSL2 ROS 2 Humble for M2/M3, PostgreSQL for M4).
- **Blocked:** None.