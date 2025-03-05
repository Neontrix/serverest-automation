*** Settings ***
Library     SeleniumLibrary


*** Keywords ***
Comparar strings
    [Arguments]    ${FIELD}    ${STRING}
    Should Be Equal As Strings
    ...    ${FIELD}
    ...    ${STRING}
    ...    error=Esperado: '${STRING}', mas obtido: '${FIELD}'. Teste: ${TEST_NAME}
  
Validar campo
    [Arguments]    ${STRING}
    Should Not Be Empty    ${STRING}    
    ...    msg=Valor da string vazia: '${STRING}'. Teste: ${TEST_NAME}
    
Aguardar elemento visivel
    [Arguments]    ${ELEMENT} 
    Wait Until Element Is Visible    ${ELEMENT}    timeout=10s    
    ...    error=Elemento ${ELEMENT} não foi encontrado durante a execução do caso de teste: ${TEST_NAME}
    