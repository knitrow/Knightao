#!/bin/bash

echo -e "\033[1;34m TraceHunter-Forensic Colletor \033[0m"
#Verifica se  o script está rodando como root
if [[ $EUID -ne 0 ]] then
echo -e "\033[1;31m Este script  precisa ser executado como root\033[0m"
exit 1
fi
#Criando diretório para os arquuivos coletados
COLLECTED_DIR="collected_files"
mkdir -p "$COLLECTED_DIR"

#Exibir mensagem de inicio
echo -e "\033[1;35m Coletando arquivos do sistema \033[0m"

#Coleta de Informações do sistema
echo -e "\033[0;95m  Listando informações sobre discos e partições\033[0m"
lsblk >  disk_info.txt

#Coleta de Conexões de Rede
echo -e "\033[0;95m Coleta de Conexões de Rede\033[0m"
ss > active_connections.txt
netstat > open_ports.txt
#Coleta de processos
echo -e "\033[0;95m Coletando Lista  de Processos  \033[0m"
ps > process_list.txt

#Coleta de registros do Sistema 7
echo -e "\033[0;95m Coletando logs do sistema \033[0m"
cp /var/log/syslog $COLLECTED_DIR/syslog.log
cp /var/log/auth.log $COLLECTED_DIR/auth.log
cp /var/log/dmesg $COLLECTED_DIR/desmeg.log

#Coleta de Arquivos de configuração 8
echo -e "\033[0;95m Coletando arquivos de configuração \033[0m"
cp -r /etc $COLLECTED_DIR/etc_config

#Coleta de  Lista de arquivos do diretórrio raiz 9
echo  -e "\033[0;95m Listando o diretório raiz... \033[0m"
ls -la / > root_dir_list.txt

#Compactação e Nomeação do Arquivo de Saída
#criando Variaveis
HOSTNAME=$(hostname)
DATAHORA=$(date +"%Y-%m-%d_%H-%M-%S")
tar -czf "TraceHunter_$(hostname)_$(date +%Y%m%d_%H%M%S).tar.gz" "$COLLECTED_DIR"
