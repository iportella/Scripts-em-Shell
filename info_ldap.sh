#!/usr/bin/env bash

########################################################################
# Nome do script: info_ldap.sh                                         #
# Autor: Igor Portella                                                 #
# Data: 07/07/2025                                                     #
# Versao: 1.0                                                          #
# Resumo: A funcao deste script eh exibir as seguintes informacoes do  #
# servidor:                                                            #
#              1. Informacoes do Sistema Operacional                   #
#              1.1 Versao detalhada do S.O                             #
#              2. Arquitetura da maquina                               #
#              3. Memoria RAM                                          #
#              4. Quantidade de CPU                                    #
#              5. Diretorio do LDAP                                    #
#              5.1 Espaco em disco do(s) diretorio(s) LDAP             #
#              5.2 Espaco usado desse disco                            #
#              5.3 Espaco total desse disco                            #
#              6. Identificacao do LDAP                                #
#              6.1 Caminho do dsconfig/dsconf                          #
#              6.2 Versao e Patch do dsconfig/dsconf                   #
#              6.3 Servico do LDAP - Online                            #
#              7. FQDN(s)                                              #
#              8. Verificar a porta recebendo conexao LDAP             #
#              9. Verificar a(s) instancia(s) do LDAP                  #
#              9.1 Quantidade de instancias                            #
########################################################################

set -euo pipefail

print_header() {
    echo "##############################################################################"
    echo "#                COLETA DE INFORMACOES - LDAP                                #"
    echo "##############################################################################"
}

print_footer() {
    echo "##############################################################################"
    echo "#              FIM DA COLETA DE INFORMACOES - LDAP                           #"
    echo "##############################################################################"
}

get_os_info() {
    echo "[1] Informacoes do Sistema Operacional: "
    uname -a
    [ -f /etc/release ] && cat /etc/release || echo "[!] /etc/release nao encontrado"
    echo "[2] Arquitetura da Maquina: "
    isainfo -kv 2>/dev/null || uname -m
    echo "[3] Memoria RAM: "
    if command -v kstat &>/dev/null; then
        phys_pages=$(kstat -p unix:0:system_pages:physmem | awk '{print $2}')
        page_size=$(pagesize)
        total_gb=$(( phys_pages * page_size / 1024 / 1024 / 1024 ))
        echo "$total_gb GB"
    else
        free -h
    fi
    echo "[4] Quantidade de CPU: "
    command -v psrinfo &>/dev/null && psrinfo | wc -l || nproc
}

get_disk_info() {
    echo "[5] Espaco em disco do(s) diretorio(s) LDAP: "
    diretorios=("/opt/sjsds" "/opt/oracle" "/opt/sjs" "/orahmp01" "/orahmp02" "/export/home/oud" "/opt/SUNWds" "/opt/oud")
    for dir in "${diretorios[@]}"; do
        [ -d "$dir" ] && {
            echo "[5.1] Diretorio: $dir"
            du -sh "$dir" | awk '{print "[5.2] Espaco usado: "$1}'
            df -h "$dir" | awk 'NR==2 {print "[5.3] Espaco total do sistema de arquivos LDAP: "$2}'
        }
    done
}

get_ldap_info() {
    echo "[*] Identificacao do LDAP em uso: "
    ldap_type=""
    if dsconfig_path=$(find /opt -maxdepth 6 -type f -name dsconfig 2>/dev/null | head -n 1); then
        echo "[6] LDAP Identificado: OUD"
        echo "[6.1] Caminho para o dsconfig: $dsconfig_path"
        "$dsconfig_path" --version || echo "[!] Falha ao executar dsconfig --version"
        ldap_type="OUD"
    elif dsconf_path=$(find /opt -maxdepth 6 -type f -name dsconf 2>/dev/null | head -n 1); then
        echo "[6] LDAP Identificado: ODSEE"
        echo "[6.1] Caminho para o dsconf: $dsconf_path"
        "$dsconf_path" --version || echo "[!] Falha ao executar dsconf --version"
        ldap_type="ODSEE"
    else
        echo "[!] LDAP nao identificado"
    fi
}

get_instance_info() {
    echo "[9] Verificando instancias LDAP no servidor:"
    if [ "$ldap_type" == "OUD" ]; then
        instances=$(ps -ef | grep -i oud | grep -v grep | awk '{for(i=1;i<=NF;i++){if($i~/(instances|slapd|oud|prdctc|prdsp)/) print $i}}' | sort | uniq)
        echo "$instances"
        echo "[9.1] Quantidade de instancias: $(echo "$instances" | wc -l)"
    elif [ "$ldap_type" == "ODSEE" ]; then
        instances=$(ps -ef | grep -i dsee | grep -v grep | awk '{for(i=1;i<=NF;i++){if($i~/(slapd|dsee|prdctc|prdsp)/) print $i}}' | sort | uniq)
        echo "$instances"
        echo "[9.1] Quantidade de instancias: $(echo "$instances" | wc -l)"
    else
        echo "[!] LDAP nao identificado, nao foi possivel identificar instancias."
    fi
}

get_fqdn_info() {
    echo "[7] FQDN(s) configurados no /etc/hosts:"
    grep ldap /etc/hosts || echo "[!] Nenhuma entrada LDAP encontrada no /etc/hosts"
}

get_ports_info() {
    echo "[*] Verificando portas LDAP em uso: "
    if command -v ss &>/dev/null; then
        ss -ltn | grep ':389' && echo "[8] Porta 389 em uso"
        ss -ltn | grep ':489' && echo "[8] Porta 489 em uso"
    else
        netstat -an | grep 389 | grep LISTEN && echo "[8] Porta 389 em uso"
        netstat -an | grep 489 | grep LISTEN && echo "[8] Porta 489 em uso"
    fi
}

print_header
get_os_info
get_disk_info
get_ldap_info
get_instance_info
get_fqdn_info
get_ports_info
print_footer
