# Usar a imagem oficial do Python
FROM python:3.12.1-slim

# Instalar dependências do sistema para compilar pacotes como pandas
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    gcc \
    libpq-dev \
    python3-dev \
    && rm -rf /var/lib/apt/lists/*

# Instalar o Poetry
RUN pip install poetry

# Definir o diretório de trabalho
WORKDIR /src

# Copiar apenas os arquivos necessários para instalar as dependências
COPY pyproject.toml poetry.lock ./

# Configurar o Poetry para não criar virtualenvs e instalar apenas dependências de produção
RUN poetry config virtualenvs.create false \
    && poetry install --only main --no-root --no-interaction --no-ansi

# Copiar o restante do código para o contêiner
COPY . .

# Expor a porta padrão do Streamlit
EXPOSE 8501

# Comando de entrada para rodar o Streamlit
ENTRYPOINT ["poetry", "run", "streamlit", "run", "app.py", "--server.port=8501", "--server.address=0.0.0.0"]
