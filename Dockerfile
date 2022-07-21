# Base Image
FROM python:3.9 AS base-image

ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_NO_CACHE_DIR=off \
    PIP_DISABLE_PIP_VERSION_CHECK=on \
    PIP_DEFAULT_TIMEOUT=100 \
    POETRY_VERSION=1.1.3 \
    POETRY_HOME="/opt/poetry" \
    POETRY_VIRTUALENVS_IN_PROJECT=false \
    POETRY_NO_INTERACTION=1 \
    PYSETUP_PATH="/app" \
    VENV_PATH="$PYSETUP_PATH/.venv"

ENV PATH="$POETRY_HOME/bin:$VENV_PATH/bin:$PATH"

# Builder Image
FROM base-image AS builder-image

RUN apt-get update && \
    apt-get install --no-install-recommends -y \
    curl \
    build-essential

RUN curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python -

WORKDIR $PYSETUP_PATH
COPY poetry.lock pyproject.toml ./

RUN poetry install --no-dev

# Prod Image
FROM base-image AS prod-image
COPY --from=builder-image $PYSETUP_PATH $PYSETUP_PATH
COPY . .
CMD gunicorn --bind=0.0.0.0:5000 --log-level=DEBUG -w=4 --timeout=1080 'base_app:app'