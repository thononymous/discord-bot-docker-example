FROM python:3.9.7 as base
ENV PIP_DISABLE_PIP_VERSION_CHECK=1
WORKDIR /app

FROM base as poetry
RUN pip install poetry==1.1.12
RUN poetry config virtualenvs.in-project true
COPY pyproject.toml ./
# COPY poetry.lock ./
RUN poetry install --no-dev --no-interaction --no-root
RUN poetry export -o requirements.txt

FROM base as build
COPY --from=poetry /app/requirements.txt /tmp/requirements.txt
RUN python -m venv .venv && \
    .venv/bin/pip install 'wheel==0.36.2' && \
    .venv/bin/pip install -r /tmp/requirements.txt

FROM python:3.9.7-slim as runtime
ENV PIP_DISABLE_PIP_VERSION_CHECK=1
WORKDIR /app
ENV PATH=/app/.venv/bin:$PATH
COPY --from=build /app/.venv /app/.venv
COPY . /app
CMD ["python3", "discord-bot.py"]
