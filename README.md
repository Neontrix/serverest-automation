# serverest-automation

Este projeto tem como objetivo automatizar testes para o **Frontend** e **API** utilizando o **Robot Framework**, juntamente com suas bibliotecas e dependências necessárias para o funcionamento correto do sistema de testes.

### --- Pré-Requisitos Gerais ----

Antes de começar a rodar os testes, verifique se você tem os seguintes pré-requisitos instalados:

### 1. **Instalação do Python**
- Baixe e instale o Python [aqui](https://www.python.org/downloads/).
- Durante a instalação, **marque a opção de instalar o PIP**, que é necessário para gerenciar pacotes no Python.
Verifique a instalação do Python e do PIP com o comando:

```bash
python --version
pip --version
```

### 2. **Instalação Robot Framework**
- Com o Python e o PIP configurados, instale o Robot Framework, que é o principal framework de automação utilizado neste projeto:
```bash
pip install robotframework
```

### 3. **Instalação SeleniumLibrary**
- A biblioteca SeleniumLibrary permite interagir com navegadores para automação de testes de Frontend.
Instale com o comando:
```bash
pip install robotframework-seleniumlibrary
```

### 4. **Instalação Biblioteca Faker**
- Para gerar dados fictícios para testes de API, utilizamos a biblioteca Faker. Instale com o comando:
```bash
pip install Faker
```

### 5. **Ambiente Virtual**
- No diretório do seu projeto, execute:
```bash
python -m venv venv
```

### 6. **Rodar Testes**
- Antes de tudo, verifique no terminal se voce está nesse caminho:
> \serverest-automation\serverest-automation> 
OBS: É extremamente importante pois para localizar as variáveis, configurações e arquivos que rode a partir da pasta raíz.

- Para rodar testes, execute:
```bash
robot testCases/api/usuarios_gherkin.robot
```

- Ou se quiser rodar um cenário com tag específica:
```bash
robot --include criar_usuario testCases/api/usuarios_gherkin.robot   
```

### ---- Pré-Requisitos Testes API ----
### 1. **Instalação RequestsLibrary**
- A RequestsLibrary é necessária para realizar chamadas de API durante os testes automatizados. Instale com o comando:
```bash
pip install robotframework-requests
```

### ---- Pré-Requisitos Testes Frontend ----
### 1. **Instalação Biblioteca de Gravação de Vídeos**
- Se deseja gravar vídeos das execuções dos testes, instale a biblioteca robotframework-screencaplibrary:
```bash
pip install robotframework-screencaplibrary
```

### 2. **Instalação Identador de Códigos**
- Para garantir a formatação adequada dos testes, instale a ferramenta robotframework-tidy:
```bash
pip install robotframework-tidy
```
