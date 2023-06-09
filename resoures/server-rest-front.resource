*** Settings ***
Documentation        Cenários de testes 

Library              Browser
# ...                  timeout=00:00:05
# ...                  enable_presenter_mode=${true}
Library              FakerLibrary
Library              DateTime
Library    RequestsLibrary

*** Variables ***
${URL}                https://front.serverest.dev/login
${BROWSER}            chromium
${HEADLESS}           ${False}
&{PAYLOAD}            nome=Fulano da Silva
...                   email=beltrano@qa.com.br
...                   password=teste
...                   administrador=true


*** Keywords ***
Abrir o navegador
    New Browser        browser=${BROWSER}
    ...                headless=${HEADLESS} 
    
    # &{recordVideo}     Create Dictionary     dir=./videos
       
    ${TRACE_NAME}  FakerLibrary.Uuid 4

    # ${NOW}         Get Current Date  result_format=%d-%m-%Y_%H%M%S
    New Context    viewport={'width': 1200, 'height': 800}
    # ...            tracing=${OUTPUT_DIR}/evidencies/traces/${NOW}/${TRACE_NAME}.zip
    # ...            recordVideo=${recordVideo}


Ir para o site Serve Rest Front

    New Page           url=${URL}

    ${title}   Get Title    ==     Front - ServeRest
    Log        ${title}    


Preencher os daddos do novo usuário e cadastrar
    Click        css=a[data-testid='cadastrar']

    ${email}     FakerLibrary.Email 

    Fill Text         css=input[data-testid='nome']         Cristiano Mothe
    Fill Text         css=input[data-testid='email']        ${email}
    Fill Text         css=input[data-testid='password']     Abc@123
    Check Checkbox    css=input[data-testid='checkbox']     
    Click             xpath=//*[@id="root"]//button >> text="Cadastrar"     

Conferir usuário cadastrado com sucesso
    [Arguments]    ${nome}

    Wait For Elements State    h1     visible
    Get Text                   h1   ==    Bem Vindo ${nome}	
    Get Element States         css=button[data-testid='logout']    
    ...                        validate    value & visible

Conferir que o usuário aparece na listagem
    [Arguments]    ${nome}

    ${elemento}      Get Table Cell Element    css=table    "Nome"    "${EMAIL}"
    ${usuario_nome}  Get Text  ${elemento}  ==  ${nome}
    Highlight Elements    ${elemento}
    Take Screenshot       fullPage=${true}

    
Criar usuário via API
    ${email}  FakerLibrary.Email
    Set Suite Variable    ${email}

    ${resposta}  Http    url=https://serverest.dev/usuarios
    ...                  method=POST
    ...                  body={"nome": "Cristiano Mothe","email": "${email}","password": "123456","administrador": "true"}   

    Should Be Equal As Integers    ${resposta["status"]}    201

Logar com o usuário cadastrado via API
    ${resposta}  Http    url=https://serverest.dev/login
    ...                  method=POST
    ...                  body={"email": "${EMAIL}","password": "123456"}
    
    Should Be Equal As Integers    ${resposta["status"]}    200

    LocalStorage Set Item    serverest/userEmail    ${EMAIL}
    LocalStorage Set Item    serverest/userToken    ${resposta["body"]["authorization"]}
    LocalStorage Set Item    serverest/userNome     Cristiano Mothe

    Go To    url=https://front.serverest.dev/admin/home

    Take Screenshot

Cadastrar Usuário e Logar
    New Browser
    New Page    url=${URL}
    Criar usuário via API
    Logar com o usuário cadastrado via API

    ${storage_file}    Save Storage State

    Set Suite Variable    ${storage_file}

Abrir o Site Serve Rest Front Logado
    [Arguments]    ${nome}

    New Browser        browser=${BROWSER}
    ...                headless=${HEADLESS}

    New Context    viewport={'width': 1200, 'height': 800} 
    ...            storageState=${storage_file}  
    
    New Page       url=https://front.serverest.dev/admin/home

    Get Text                   h1   ==    Bem Vindo ${nome}

    Take Screenshot

Acessar a Lista de usuários
    Click    css=a[data-testid='listarUsuarios'] 


