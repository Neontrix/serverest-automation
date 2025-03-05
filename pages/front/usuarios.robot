*** Settings ***
Library     SeleniumLibrary
Library     FakerLibrary    locale=pt_BR
Library     ../../utils/YamlLibrary.py
Library     BuiltIn
Library     Collections
Library     OperatingSystem
Library     String 
Library     RequestsLibrary
Resource    ../../resources/usuarios_resources.robot
Resource    ../../components/click_elements.robot
Resource    ../../components/input_texts.robot
Resource    ../../components/validator.robot

*** Variables ***
${CONFIG_FILE}           ./resources/config.yaml
${USERS_FILE}            ./utils/usuarios.yaml
${URL}                   ${EMPTY}
${BROWSER}               ${EMPTY}
${HEADLESS}              ${EMPTY}
${NOME_RANDOM}           ${EMPTY}
${NOME_COMPLETO}         ${EMPTY}
${EMAIL_RANDOM}          ${EMPTY}  
${EMAIL_COMPLETO}        ${EMPTY}  
${IMAGEM_PATH}           ${OUTPUT_DIR}/produto_fake.png      
${NOME_PRODUTO}          ${EMPTY}     
${DESCRICAO_PRODUTO}     ${EMPTY}         
${PRECO_PRODUTO}         ${EMPTY}         
${QUANTIDADE_PRODUTO}    ${EMPTY}  

*** Keywords ***
Carregar Configuração Geral
    ${config}    Read YAML    ${CONFIG_FILE}
    # Tenta obter as variáveis de ambiente, se existirem
    ${env_url}    Get Environment Variable    ENV_FRONTEND_URL    ${EMPTY}
    ${env_browser}    Get Environment Variable    ENV_BROWSER    ${EMPTY}
    ${env_headless}    Get Environment Variable    ENV_HEADLESS    ${EMPTY}

    # Sobrescreve as variáveis com as variáveis de ambiente, se definidas
    Run Keyword If    '${env_url}' != ''    Set Global Variable    ${URL}    ${env_url}
    Run Keyword If    '${env_browser}' != ''    Set Global Variable    ${BROWSER}    ${env_browser}
    Run Keyword If    '${env_headless}' != ''    Set Global Variable    ${HEADLESS}    ${env_headless}

    # Caso não haja variável de ambiente, usa a do arquivo config.yaml
    Run Keyword If    '${URL}' == ""    Set Global Variable    ${URL}    ${config['frontend_url']}
    Run Keyword If    '${BROWSER}' == ""    Set Global Variable    ${BROWSER}    ${config['browser']}
    Run Keyword If    '${HEADLESS}' == ""    Set Global Variable    ${HEADLESS}    ${config['headless']}

Carregar Configuração de Usuário
    ${config_users}    Read YAML    ${USERS_FILE}
    Log    ${config_users}  # Verifica a estrutura do arquivo
    Set Global Variable    ${NOME_USUARIO}    ${config_users['usuario']['nome']}
    Log    ${NOME_USUARIO}  # Verifique o valor de NOME_USUARIO
    Set Global Variable    ${EMAIL_USUARIO}   ${config_users['usuario']['email']}
    Set Global Variable    ${SENHA_USUARIO}   ${config_users['usuario']['password']}
    Set Global Variable    ${ADMIN_USUARIO}   ${config_users['usuario']['administrador']}

Gerar Nome Aleatório
    ${nome_random}    FakerLibrary.Name
    Set Global Variable    ${NOME_RANDOM}    ${nome_random}
    Set Global Variable    ${NOME_COMPLETO}    ${NOME_USUARIO} ${nome_random}    # Concatenar como string

Gerar Email Aleatório
    ${nick_random}    FakerLibrary.Word  # Gera um apelido aleatório
    Set Global Variable    ${EMAIL_COMPLETO}    ${nick_random}${EMAIL_USUARIO}  # Concatena o e-mail com o nick
    Log    ${EMAIL_COMPLETO}  # Exibe o e-mail completo concatenado
    
Gerar Dados do Produto
    ${nome_produto}    FakerLibrary.Word    
    Set Global Variable    ${NOME_PRODUTO}    ${nome_produto}    

    ${descricao}    FakerLibrary.sentence
    ${preco}    Evaluate    random.randint(10, 9999)    random
    ${quantidade}   Evaluate    random.randint(1, 100)    random
    Set Global Variable    ${NOME_PRODUTO}    ${nome_produto}
    Set Global Variable    ${DESCRICAO_PRODUTO}    ${descricao}
    Set Global Variable    ${PRECO_PRODUTO}    ${preco}
    Set Global Variable    ${QUANTIDADE_PRODUTO}    ${quantidade}

Gerar Imagem Fake
    ${response}    GET    https://picsum.photos/200/300
    ${imagem}    Create Binary File    ${IMAGEM_PATH}    ${response.content}
    Set Global Variable    ${IMAGEM_PATH}

# GHERKIN STEPS
# GIVEN
Dado que estou na homepage do serverest
    Go To    url=${URL}
    Wait Until Element Is Visible    locator=${HOME_LOGIN}

Dado que estou na homeadmin do serverest
    E cadastrei usuario com sucesso
    E realizei login com sucesso

# AND
E preencho os campos obrigatórios com informações válidas
    Carregar Configuração de Usuário
    Gerar Nome Aleatório
    Gerar Email Aleatório
    Validar campo    ${NOME_COMPLETO}
    Validar campo    ${EMAIL_COMPLETO}

    Inserir texto    ${CAMPO_NOME}    ${NOME_COMPLETO}
    Inserir texto    ${CAMPO_EMAIL}    ${EMAIL_COMPLETO}
    Inserir texto    ${CAMPO_SENHA}    ${SENHA_USUARIO}

E dou check para o usuário "Administrador"
    Clicar no elemento    ${CHECK_ADMIN}

E clico em "Cadastrar"
    Clicar no elemento    ${BTN_CADASTRAR}

E cadastrei usuario com sucesso   
    Quando clico no botão "Cadastrar"
    E preencho os campos obrigatórios com informações válidas
    E dou check para o usuário "Administrador"
    E clico em "Cadastrar"
    Então o cadastro é efetuado com sucesso

E realizei login com sucesso
    E retorno para a homepage do serverest
    E preencho as credenciais corretas
    Quando clico no botão "Entrar"
    Então usuário realiza login com sucesso

E preencho as credenciais corretas
    Inserir texto    ${CAMPO_EMAIL}    ${EMAIL_COMPLETO}
    Inserir texto    ${CAMPO_SENHA}    ${SENHA_USUARIO}

E retorno para a homepage do serverest
    Dado que estou na homepage do serverest

E cliquei em cadastrar produtos
    Clicar no elemento    ${LINK_CAD_PRODUTO}

E preenchi formulário de cadastro do produto
    Gerar Dados do Produto
    Gerar Imagem Fake
    Inserir texto    ${CAMPO_NOME}        ${NOME_PRODUTO}
    Inserir texto    ${CAMPO_PRECO}       ${PRECO_PRODUTO}
    Inserir texto    ${CAMPO_DESCRICAO}   ${DESCRICAO_PRODUTO}
    Inserir texto    ${CAMPO_QUANTIDADE}  ${QUANTIDADE_PRODUTO}
    Choose File      ${CAMPO_IMAGEM}      ${IMAGEM_PATH}

# WHEN
Quando clico no botão "Cadastrar"
    Clicar no elemento    ${HOME_BTN_CADASTRAR}

Quando clico no botão "Entrar"
    Clicar no elemento    ${BTN_ENTRAR}

Quando clicar em cadastrar produto
    Clicar no elemento    ${BTN_CADASTRAR}

# THEN
Então o cadastro é efetuado com sucesso
    Aguardar elemento visivel    ${POPUP_SUCESSO_CADASTRO}

Então usuário realiza login com sucesso
    Aguardar elemento visivel    ${HEADER_HOME}

Então produto foi cadastrado com sucesso
    Wait Until Element Is Visible    ${LISTA_PRODUTOS}    timeout=10s
    Location Should Be    https://front.serverest.dev/admin/listarprodutos
