*** Settings ***
Library    RequestsLibrary
Library    FakerLibrary    locale=pt_BR
Library    ../../utils/YamlLibrary.py    # Biblioteca personalizada para carregar YAML
Library    Collections    

Resource    ../../components/validator.robot

*** Variables ***
${CONFIG_FILE}    ./resources/config.yaml
${USERS_FILE}     ./utils/usuarios.yaml

*** Keywords ***
# GHERKIN STEPS

# GIVEN
Dado que tenho um usuário gerado
    ${CONFIG}        Read YAML    ${CONFIG_FILE}
    ${BASE_URL}      Get From Dictionary    ${CONFIG}    base_url
    ${USER_DATA}     Read YAML    ${USERS_FILE}
    
    ${random_name}=  FakerLibrary.User Name
    ${prefix_name}=   Get From Dictionary    ${USER_DATA['usuario']}    nome
    ${unique_name}=   Set Variable    ${prefix_name} ${random_name}
    ${prefix_email}=  Get From Dictionary    ${USER_DATA['usuario']}    email
    ${unique_email}=  Set Variable    ${random_name}${prefix_email}
    
    ${password}=      Get From Dictionary    ${USER_DATA['usuario']}    password
    ${administrador}=     Get From Dictionary    ${USER_DATA['usuario']}    administrador

    RETURN    ${BASE_URL}    ${unique_name}    ${unique_email}    ${password}    ${administrador}

Dado que desejo realizar login informando credenciais corretas
    ${BASE_URL}    ${unique_name}    ${unique_email}    ${password}    ${administrador}    
    ...    Dado que tenho um usuário gerado
    
    ${body}=    Quando crio corpo de requisição para criação de usuário    ${unique_name}    ${unique_email}    ${password}    ${administrador}
    
    ${response}=    E envio requisição de cadastro    ${BASE_URL}    ${body}
    
    Então usuário é criado com sucesso    ${response}

    # Retorna as credenciais para serem usadas no login
    RETURN    ${BASE_URL}    ${unique_email}    ${password}

Dado que desejo verificar usuários com prefixo "Teste QA"
    ${CONFIG}    Read YAML    ${CONFIG_FILE}
    ${BASE_URL}    Get From Dictionary    ${CONFIG}    base_url

    ${response}    GET    url=${BASE_URL}/usuarios    params=nome=Teste%20QA
    ${usuarios}    Get From Dictionary    ${response.json()}    usuarios
    Run Keyword If    ${usuarios}    Log    Usuários encontrados: ${usuarios}
    ...    ELSE    Log    Nenhum usuário encontrado com o prefixo "Teste QA"
    RETURN    ${usuarios}    ${BASE_URL}


# WHEN
Quando crio corpo de requisição para criação de usuário
    [Arguments]    ${unique_name}    ${unique_email}    ${password}    ${administrador}
    ${body}=    Create Dictionary    nome=${unique_name}    email=${unique_email}    password=${password}    administrador=${administrador}
    RETURN    ${body}

Quando crio corpo de requisição para login do usuário
    [Arguments]    ${email}    ${password}
    ${body}=    Create Dictionary    email=${email}    password=${password}
    RETURN    ${body}

Quando deleto todos os usuários encontrados
    [Arguments]    ${usuarios}    ${BASE_URL}
    FOR    ${usuario}    IN    @{usuarios}
        ${user_id}=    Get From Dictionary    ${usuario}    _id
        ${delete_response}=    DELETE    ${BASE_URL}/usuarios/${user_id}
        Log    Usuário ${user_id} deletado - Status: ${delete_response.status_code}
    END

# AND
E envio requisição de cadastro
    [Arguments]    ${BASE_URL}    ${body}
    ${response}=    POST    ${BASE_URL}/usuarios    json=${body}
    RETURN    ${response}

E envio requisição de login
    [Arguments]    ${BASE_URL}    ${body}
    ${response}=    POST    ${BASE_URL}/login    json=${body}
    RETURN    ${response}
    
# THEN
Então usuário é criado com sucesso
    [Arguments]    ${response}

    Comparar strings    ${response.status_code}    201

    ${response_message}=    Get From Dictionary    ${response.json()}    message
    Comparar strings    ${response_message}    Cadastro realizado com sucesso

    Log    ${response.json()}

Então login é realizado com sucesso
    [Arguments]    ${response}
    Comparar strings    ${response.status_code}    200

    ${response_message}=    Get From Dictionary    ${response.json()}    message
    Comparar strings    ${response_message}    Login realizado com sucesso

    Log    ${response.json()}

Então não existem mais usuários com prefixo "Teste QA"
    [Arguments]    ${BASE_URL} 
    ${response}=    GET    url=${BASE_URL}/usuarios    params=nome=Teste%20QA
    ${usuarios}=    Get From Dictionary    ${response.json()}    usuarios
    Should Be Empty    ${usuarios}    Ainda existem usuários com "Teste QA"
