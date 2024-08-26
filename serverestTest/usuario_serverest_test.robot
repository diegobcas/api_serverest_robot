*** Settings ***
Resource  ../serverestResources/serverest_testes_recursos.resource

*** Variables ***

*** Test Cases ***
Cenário com Post: Cadastrar um novo usuário com sucesso
  Criar um novo usuário
  Cadastrar o novo usuário criado
  Conferir se este novo usuário foi cadastrado corretamente

Cenário com GET: Consultar os dados de um usuário
   Criar um novo usuário
   Cadastrar o novo usuário criado
   Consultar os dados do usuário
   Conferir os dados retornados do novo usuário

Cenário com PUT: Atualizar os dados de um usuário
   Criar um novo usuário
   Cadastrar o novo usuário criado
   Consultar os dados do usuário
   Alterar perfil de acesso administrador de true para false
   Consultar os dados do usuário

Cenário com DELETE: Excluir usuário já existente
    Criar um novo usuário
    Cadastrar o novo usuário criado
    Excluir usuário criado
    Conferir se o usuário foi excluído