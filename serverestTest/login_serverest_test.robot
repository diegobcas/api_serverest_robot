*** Settings ***
Resource  ../serverestResources/serverest_testes_recursos.resource

*** Variables ***

*** Test Cases ***

Cenário com Post: Realizar login com sucesso
  Criar um novo usuário 
  Cadastrar o novo usuário criado
  Login com usuário cadastrado
