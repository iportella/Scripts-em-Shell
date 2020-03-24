#!/bin/bash
################################################################################
#------------------------------------------------------------------------------#
#                                                                              #
#  Nome do script: sisinfo.sh                                                  #
#  Autor: Igor Portella Pereira Lopes                                          #
#  E-mai: igorlllopesport@gmail.com                                            #
#  Data:09/08/2018                                                             #
#  ----------------------------------------------------------------------------#
#  Esse programa busca por meio de autenticação exibir informações importantes #
#  do sistema utilizado.                                                       #
#                                                                              #
#------------------------------------------------------------------------------#
################################################################################

echo "Solicitando autorização para colher e exibir informações sobre o sistema (s/n)?"
read autoriza
test  "$autoriza" != "s" && exit
echo "########## Diretorio atual: ##########"
pwd
echo
sleep 2
echo "########## Arquivos/Pastas no diretorio atual:  ##########"
ls
echo
sleep 2
echo "########## Data e hora atual:  ##########"
date
echo
sleep 2
echo " ########## Informações de rede: ##########"
ifconfig
echo
sleep 3
echo " ########## Uso de espaço do disco: ##########"
df -ah
echo
sleep 3
echo " ########## Memoria utilizada/livre:  ##########"
free -m
echo
sleep 2
echo " ########## Usuários logados no sistema:  ##########"
w
echo
sleep 2
echo " ########## Informações do tipo do sistema:  ##########"
uname -a
echo
sleep 2
echo " ########## Processos em execução no momento:  ##########"
pstree
echo
sleep 4
echo " ########## Espaço do sistema:  ##########"
df -h
echo
sleep 3
echo " ########## Fim do Programa: ######### "
