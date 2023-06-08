*** Settings ***
Documentation        Cenários de testes 

Library              Browser
Library              FakerLibrary
Library              DateTime

*** Variables ***
${URL}                https://front.serverest.dev/login
${BROWSER}            chromium
${HEADLESS}           ${True}


*** Keywords ***
Abrir o navegador
    New Browser        browser=${BROWSER}
    ...                headless=${HEADLESS} 
    
    &{recordVideo}     Create Dictionary     dir=./videos
       
    ${TRACE_NAME}  FakerLibrary.Uuid 4

    ${NOW}         Get Current Date  result_format=%d-%m-%Y_%H%M%S
    New Context    viewport={'width': 1200, 'height': 800}
    ...            tracing=${OUTPUT_DIR}/evidencies/traces/${NOW}/${TRACE_NAME}.zip
    ...            recordVideo=${recordVideo}


Ir para o site Serve Rest Front
    New Page           url=${URL} 

    ${title}   Get Title    ==     Front - ServeRest
    Log        ${title}    


Preencher os daddos do novo usuário e cadastrar
    Click        css=a[data-testid='cadastrar']

    ${email}     FakerLibrary.Email 

    Fill Text         css=input[data-testid='nome']         Cristiano Ferreira Mothe
    Fill Text         css=input[data-testid='email']        ${email}
    Fill Text         css=input[data-testid='password']     Abc@123
    Check Checkbox    css=input[data-testid='checkbox']     
    Click             xpath=//*[@id="root"]//button >> text="Cadastrar"
    Sleep    3s

Conferir usuário cadastrado com sucesso
    [Arguments]    ${nome}
    Wait For Elements State    h1     visible
    Get Text                   h1   ==    Bem Vindo ${nome}	
    Get Element States         css=button[data-testid='logout']    
    ...                        validate    value & visible