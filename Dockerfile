# ── STAGE 1: Builder ──────────────────────
FROM python:3.11-alpine AS builder

WORKDIR /app

COPY requirements.txt ./

RUN pip install --no-cache-dir -r requirements.txt

# ── STAGE 2: Runtime ──────────────────────
FROM python:3.11-alpine AS runtime

# Usuario no root
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

WORKDIR /app

# Copia dependencias instaladas
COPY --from=builder /usr/local/lib/python3.11/site-packages /usr/local/lib/python3.11/site-packages
COPY --from=builder /usr/local/bin /usr/local/bin

# Copia el código fuente
COPY app.py ./
COPY templates/ ./templates/

RUN chown -R appuser:appgroup /app

USER appuser

EXPOSE 5000

CMD ["python", "app.py"]