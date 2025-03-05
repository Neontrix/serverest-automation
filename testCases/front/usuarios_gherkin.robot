*** Settings ***
Documentation       Essa suíte testa o site serverest
Resource    ../../pages/front/usuarios.robot

Test Setup    Preparar Para Teste
Test Teardown    Finalizar Teste

*** Variables ***
${SCREENSHOT_DIR}    ./screenshots
#${TEST_NAME}         ${TEST NAME}


*** Test Cases ***
Caso de Teste 01 - Criar usuário com sucesso
    [Documentation]    Este teste cria um usuário com sucesso
    [Tags]    criar_usuario
    Dado que estou na homepage do serverest
    Quando clico no botão "Cadastrar"
    E preencho os campos obrigatórios com informações válidas
    E dou check para o usuário "Administrador"
    E clico em "Cadastrar"
    Então o cadastro é efetuado com sucesso

Caso de Teste 02 - Logar com sucesso
    [Documentation]    Este teste realiza login com sucesso
    [Tags]    login_usuario
    Dado que estou na homepage do serverest
    E cadastrei usuario com sucesso
    E retorno para a homepage do serverest
    E preencho as credenciais corretas
    Quando clico no botão "Entrar"
    Então usuário realiza login com sucesso

Caso de Teste 03 - Cadastrar produto com sucesso
    [Documentation]    Este teste realiza cadastro de produto com sucesso
    [Tags]    cadastrar_produto
    Dado que estou na homeadmin do serverest
    E cliquei em cadastrar produtos
    E preenchi formulário de cadastro do produto
    Quando clicar em cadastrar produto
    Então produto foi cadastrado com sucesso


*** Keywords ***
Preparar Para Teste
    Run Keyword If    '${URL}' == ""    Carregar Configuração Geral
    # Dicionário de opções para o Chrome
    ${options}    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver

    # Verifica a variável HEADLESS
    Log    Valor de HEADLESS: ${HEADLESS}

    # Condição para ativar o headless
    Run Keyword If    '${HEADLESS}' == 'True'    Call Method    ${options}    add_argument    --headless
    Run Keyword If    '${HEADLESS}' == 'True'    Call Method    ${options}    add_argument    --disable-gpu
    Run Keyword If    '${HEADLESS}' == 'True'    Call Method    ${options}    add_argument    --disable-infobars

    Open Browser    ${URL}    ${BROWSER}    options=${options}
    Run Keyword If    '${HEADLESS}' == 'False'    Maximize Browser Window

Finalizar Teste
    Run Keyword If    '${SCREENSHOT_DIR}' != ''    Create Directory    ${SCREENSHOT_DIR}
    ${screenshot_path}    Set Variable    ${SCREENSHOT_DIR}/${TEST_NAME}_${SUITE_NAME}.png

    Capture Page Screenshot    ${screenshot_path}
    Close Browser
