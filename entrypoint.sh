#!/bin/sh

if [ -z "$PLUGIN_KUBE_CONFIG" ]; then
    echo "###### ERRO ######"
    echo "O parametro settings.kube_config não foi informado. Esse parâmetro é necessário para que o kubectl consiga executar comandos no cluster kubernetes."
    echo
    echo "Para maiores informações consulte: https://github.com/plugindrone/kubectl"
    echo
    exit 2
else
    mkdir ~/.kube
    printenv PLUGIN_KUBE_CONFIG > ~/.kube/config
    printenv PLUGIN_CMD | sed 's/","/"\n"/g' | sed "s/','/'\n'/g" | sed 's/,/\n/g' > /tmp/cmd
    chmod +x /tmp/cmd
    TOTAL_LINHAS=$(wc -l /tmp/cmd | awk '{print $1}')
    for i in `seq 1 ${TOTAL_LINHAS}`; do
        COMANDO_ATUAL=$(sed -n ${i}p /tmp/cmd)
        if [ "$PLUGIN_DEBUG" == "1" ]; then
            echo "** Executando o comando: ($COMANDO_ATUAL)"
        fi
        ${COMANDO_ATUAL}
    done
    source /tmp/cmd
fi