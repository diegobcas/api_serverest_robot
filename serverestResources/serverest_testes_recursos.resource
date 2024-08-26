*** Settings ***
Documentation  O objetivo deste arquivo é armazenar todos os recursos para os testes 
*** Settings ***

Library  RequestsLibrary
Library  String
Library  Collections


*** Keywords ***
Criar sessão
  ${headers}  Create Dictionary  accept=application/json  Content-Type=application/json
  Create Session    alias=APIServeRest    url=https://serverest.dev                    headers=${headers}

Criar sessão usuário
  ${headers}  Create Dictionary  accept=application/json  Content-Type=application/json  Authorization=${TOKEN_USUARIO}
  Create Session    alias=APIServeRest    url=https://serverest.dev                    headers=${headers}

Criar um novo usuário
  ${palavra_randomica}  Generate Random String  length=8  chars=[LETTERS]
  ${palavra_randomica}  Convert To Lower Case    ${palavra_randomica} 
  Set Test Variable    ${EMAIL_TEST}             ${palavra_randomica}@qacoders.com.br
  Log                  ${EMAIL_TEST}   
  ${palavra_randomica_nome}  Generate Random String  length=8  chars=[LETTERS]
  ${palavra_randomica_nome}  Convert To Lower Case    ${palavra_randomica_nome} 
  Set Test Variable    ${NOME_TEST}                   P${palavra_randomica_nome}   
  ${palavra_randomica_sobrenome}  Generate Random String  length=8  chars=[LETTERS]
  ${palavra_randomica_sobrenome}  Convert To Lower Case    ${palavra_randomica_nome} 
  Set Test Variable    ${SOBRENOME_TEST}               C${palavra_randomica_sobrenome} 
  ${palavra_randomica_fullname}  Generate Random String  length=8  chars=[LETTERS]
  ${palavra_randomica_fullname}  Convert To Lower Case    ${palavra_randomica_fullname} 
  Set Test Variable    ${FULLNAME_TEST}                 P${palavra_randomica_nome} C${palavra_randomica_sobrenome} 

Cadastrar o novo usuário criado
  ${body}  Create Dictionary   nome=${FULLNAME_TEST}     email=${EMAIL_TEST}   password=teste   administrador=true
  Log  ${body}
  Criar sessão
  ${resposta}  POST On Session  alias=APIServeRest  url=/usuarios  json=${body}  
  Log  ${resposta.json()}
  Set Test Variable    ${ID_USUARIO}  ${resposta.json()["_id"]}
  Set Test Variable    ${RESPOSTA}  ${resposta.json()}

Login com usuário cadastrado
  ${body}  Create Dictionary    email=${EMAIL_TEST}   password=teste  
  Log  ${body}
  ${resposta}  POST On Session  alias=APIServeRest  url=/login  json=${body}  
  Log  ${resposta.json()}
  Set Test Variable    ${TOKEN_USUARIO}  ${resposta.json()["authorization"]}
  Set Test Variable    ${RESPOSTA}                  ${resposta.json()}
  Dictionary Should Contain Item    ${RESPOSTA}    message    Login realizado com sucesso

Consultar os dados do usuário
  ${resposta_consulta}  GET On Session  alias=APIServeRest  url=/usuarios/${ID_USUARIO}  expected_status=200
  Set Test Variable    ${RESPOSTA_CONSULTA}                  ${resposta_consulta.json()}

Conferir os dados retornados do novo usuário
  Log  ${RESPOSTA_CONSULTA}
  Dictionary Should Contain Item    ${RESPOSTA_CONSULTA}    nome             ${FULLNAME_TEST} 
  Dictionary Should Contain Item    ${RESPOSTA_CONSULTA}    email            ${EMAIL_TEST}
  Dictionary Should Contain Item    ${RESPOSTA_CONSULTA}    password         teste
  Dictionary Should Contain Item    ${RESPOSTA_CONSULTA}    administrador    true
  Dictionary Should Contain Item    ${RESPOSTA_CONSULTA}    _id              ${ID_USUARIO}

Conferir se este novo usuário foi cadastrado corretamente
  Log  ${RESPOSTA}
  Dictionary Should Contain Item    ${RESPOSTA}    message    Cadastro realizado com sucesso
  Dictionary Should Contain Key     ${RESPOSTA}    _id  

Alterar perfil de acesso administrador de true para false
  ${alterar_perfil_usuario}  PUT On Session  alias=APIServeRest  url=/usuarios/${ID_USUARIO}  expected_status=200  data={"nome":"Fulano da Silva", "email":"${EMAIL_TEST}","password":"teste","administrador":"false"}

Excluir usuário criado
  ${excluir_usuario}  DELETE On Session  alias=APIServeRest  url=/usuarios/${ID_USUARIO}    expected_status=200  
  Set Test Variable    ${EXCLUIR_USUARIO}    ${excluir_usuario.json}

Conferir se o usuário foi excluído
  Log  ${EXCLUIR_USUARIO}
