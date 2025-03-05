*** Settings ***
Library     SeleniumLibrary


*** Keywords ***
Comparar strings
    [Arguments]    ${FIELD}    ${STRING}
    Should Be Equal As Strings
    ...    ${FIELD}
    ...    ${STRING}
    ...    error=O elemento ${FIELD} da string ${STRING} não foi encontrado durante a execução do caso de teste: ${TEST_NAME}
    ...    
    