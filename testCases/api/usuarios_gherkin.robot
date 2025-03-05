*** Settings ***
Documentation       Essa suíte testa os cenários de usuário

Resource            ../../pages/api/usuarios.robot

*** Test Cases ***
Caso de Teste 01 - Criar usuário com sucesso
    [Documentation]    Esse teste realiza a criação de usuário
    [Tags]    criar_usuario_api
    ${BASE_URL}    ${unique_name}    ${unique_email}    ${password}    ${administrador}    
    ...    Dado que tenho um usuário gerado
    ${body}    Quando crio corpo de requisição para criação de usuário    ${unique_name}    ${unique_email}    ${password}    ${administrador}
    ${response}    E envio requisição de cadastro    ${BASE_URL}    ${body}
    Então usuário é criado com sucesso    ${response}

Caso de teste 02 - Realizar login com sucesso
    [Documentation]    Esse teste realiza login de usuário
    [Tags]    login_usuario_api
    ${BASE_URL}    ${unique_email}    ${password}    
    ...    Dado que desejo realizar login informando credenciais corretas
    ${body}    Quando crio corpo de requisição para login do usuário    ${unique_email}    ${password}
    ${response}    E envio requisição de login    ${BASE_URL}    ${body}
    Então login é realizado com sucesso    ${response}

Caso de Teste 03 - Remover usuários com prefixo "Teste QA"
    [Documentation]    Este teste verifica se existem usuários com prefixo "Teste QA" e os remove se encontrados.
    [Tags]    remover_usuarios_api
    ${usuarios}    ${BASE_URL}    Dado que desejo verificar usuários com prefixo "Teste QA"
    Quando deleto todos os usuários encontrados    ${usuarios}    ${BASE_URL}
    Então não existem mais usuários com prefixo "Teste QA"    ${BASE_URL}
