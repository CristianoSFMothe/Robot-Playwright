*** Settings ***
Documentation        Arquivo de testes para consumir as resources

Resource            ../resoures/server-rest-front.resource

Suite Setup        Cadastrar Usuário e Logar


*** Test Cases ***
Login com sucesso Serve Rest Front
    Abrir o navegador
    Ir para o site Serve Rest Front    
    Preencher os daddos do novo usuário e cadastrar
    Conferir usuário cadastrado com sucesso    Cristiano Ferreira Mothe


Login HTTP com requisição via API
    [Tags]        api

    Abrir o navegador
    Ir para o site Serve Rest Front    
    Criar usuário via API  
    Logar com o usuário cadastrado via API


Utilizando o Storage Armazenado no Contexto
    [Tags]    storage

    Abrir o Site Serve Rest Front Logado    Cristiano Mothe
    Acessar a Lista de usuários








    

