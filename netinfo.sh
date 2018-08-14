#!/bin/bash
############################################################
#----------------------------------------------------------#
#Nome do script: netinfo.sh                                #
#Autor: Igor Portella Pereira Lopes                        #
#E-mail: igorlllopesport@gmail.com                         #
#Data: 13/08/2018                                          #
#----------------------------------------------------------#
#Exibe informações de rede e executa testes de conexão     #
############################################################
echo "#####  Informações sobre a rede  #####: "
ifconfig
sleep 4
echo
echo "#####  Inicio dos testes de conexão  #####: "
ping -c 5 125.25.26.2
sleep 5
echo
echo "#####  Verificando conexões TCP  #####: "
netstat -nt
sleep 5
echo
echo "#####  Resumo das estatísticas de conexão  #####: "
ss -s
sleep 5
echo
echo "#####  Nome do host do IP  #####: "
nslookup www.google.com
sleep 5
echo
echo "#####  Informações sobre o DNS  #####: "
dig www.facebook.com.br
sleep 5
echo
echo "#####  Portas abertas neste computador  #####: "
netstat -t -l -p --numeric-ports
sleep 5
echo
echo "#####  Fim programa  #####: "
sleep 4
