# Build stage
FROM python:3.11-slim AS build
WORKDIR /app
RUN apt-get update && apt-get install -y --no-install-recommends build-essential gcc libpq-dev && rm -rf /var/lib/apt/lists/*
COPY requirements.txt .
RUN pip install --upgrade pip
RUN pip wheel -r requirements.txt --wheel-dir /wheels

# Final stage
FROM python:3.11-slim
WORKDIR /app
COPY --from=build /wheels /wheels
RUN pip install --no-index --find-links=/wheels -r /app/requirements.txt
COPY . .
EXPOSE 8080
ENV PYTHONUNBUFFERED=1
CMD ["gunicorn", "--bind", "0.0.0.0:8080", "app:app", "--workers", "2", "--threads", "4"]

