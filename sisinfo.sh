#!/bin/bash
################################################################################
#------------------------------------------------------------------------------#
#                                                                              #
#  Nome do script: sisinfo.sh-Lista algumas informações importantes do Sistema #
#  Autor: Igor Portella Pereira Lopes                                          #
#  E-mai: igorlllopesport@gmail.com                                            #
#  Data:09/08/2018                                                             #
#  ----------------------------------------------------------------------------#
#  Esse programa busca por meio de autenticação exibir informações importantes
#  do sistema utilizado.                                                       #
#                                                                              #
#------------------------------------------------------------------------------#
################################################################################

echo "Solicitando autorização para colher e exibir informações sobre o sistema (S/N)?"
read autoriza
test  "$autoriza" = "N" && exit
echo "########## Diretorio atual: ##########"
pwd
echo
echo "########## Arquivos/Pastas no diretorio atual:  ##########"
ls
echo
sleep 2
echo "########## Data e hora atual:  ##########"
date
echo
echo " ########## Informações de rede: ##########"
ifconfig
echo
sleep 2
echo " ########## Uso de espaço do disco: ##########"
df -ah
echo
sleep 2
echo " ########## Memoria utilizada/livre:  ##########"
free -m
echo
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
sleep 2
echo " ########## Espaço do sistema:  ##########"
df -h
echo
sleep 2
echo " ########## Fim do Programa: ######### "
