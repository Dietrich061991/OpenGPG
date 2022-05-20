#!/bin/bash
#____________________________________________________________________________________________________________________________________________
#
# Author       : Time BIG DATA --> SEDAMI DIETRICH MONTCHO
# Project      : Cobranca4pII
#
# File Name    : 
# Version      : 1.0
#
# Description  : Script para criptogrfar os arquivos de acessoria
#                Cobranca4pII
#
# History
# Who | When       | Comment
#-----+------------+-----------------------------------------------------------------------------------------------------------------------
# BD  | 17/05/2022 | Creation program file
#__________________________________________________________________________________________________________________________________________
 


# ESSE SCRIPT FOI IMPLEMENTADO PARA CRIPTOGRAFAR OS ARQUIVOS DAS ACESSORIAS
# RECEBE DOIS PARAMETROS:
#    1: CAMINHO DOS ARQUIVOS A SEREM CRIPTOGRAFADOS 
#    2: NOME DA EPS
#

#OBS: VERIFICAR SE O RECIPIENT ESTÁ ARMAZENADA USANDO ESSE COMANDO (o email que foi cadastrado)
#      gpg --list-keys



#Parametro recebe o caminho do arquivo
LOCAL_DIR=$1
#Parametro 2 receber o nome da acessoria
EPS=$2
#codigo de verificacao
RC=0
# File Date Log
FILE_DATE_LOG=$(date +%Y%m%d%H%M%S)
#data inicio
INI_DATE=$(date +%d/%m/%Y"  "%H:%M:%S)
#log dir 
LOG_DIR=${LOCAL_DIR}/'CriptograFialogs'
#process point
PROCESSPOINT='PROCESSO.DESCRIPTOGRAFIA.'${EPS}
#bkp file eps
BKP_FILE_EPS=${LOCAL_DIR}/'BkpFilEps'
#log file
FILE_LOG=${LOG_DIR}/${PROCESSPOINT}.${FILE_DATE_LOG}'.log'
#recipient
RECIPIENT='validacaoEPS@telefonica.com'

#---------------------------------------------------------------------------------------------------------------------------------#
#funcao para criar a pasta dos log caso nao existir
#Se nao existir vai criar caso contrario passa
function Pathcriptografialogs()

{
    if [ $RC -eq 0 ] && [ ! -d $LOG_DIR ]; then
     		mkdir -p $LOG_DIR
    fi

}
#---------------------------------------------------------------------------------------------------------------------------------#




#---------------------------------------------------------------------------------------------------------------------------------#
#funcao para criar a pasta bkp dos arquivos
#Se nao existir vai criar caso contrario passa
function pathbkpfileeps()

{
    if [ $RC -eq 0 ] && [ ! -d $BKP_FILE_EPS ]; then
     		mkdir -p $BKP_FILE_EPS
    fi

}
#---------------------------------------------------------------------------------------------------------------------------------#



#---------------------------------------------------------------------------------------------------------------------------------#
#funcao para fazer o backp dos arquivos da eps em execucao
function bkpfileeps()

{

	if [ $RC -eq 0 ]; then
		echo "######################################################################################################################">>$FILE_LOG
		echo "                                  PROCESSO DE BACKUP DOS ARQUIVOS DA EPS ${EPS}                                       ">>$FILE_LOG            
		echo "######################################################################################################################">>$FILE_LOG
		nFile=$(ls $LOCAL_DIR | grep "${EPS}.*.csv" | wc -l)
		if [ $nFile -ne 0 ]; then
			for file in $(ls $LOCAL_DIR | grep "${EPS}.*.csv"); do
		    	cp ${file} ${BKP_FILE_EPS}
			done
		fi
		retCode=$?
		if [ $retCode -ne 0 ]; then 
		    echo "BACKUP DO ARQUIVO: $(basename ${file}) FINALIZADO COM ERROR ${retCode}.">> $FILE_LOG
			RC=1 
		else
		    echo "BACKUP DO ARQUIVO: $(basename ${file}) FINALIZADO COM SUCCESS.">> $FILE_LOG
		fi
		echo "######################################################################################################################">>$FILE_LOG
        echo ""	>>  $FILE_LOG
        echo ""	>>  $FILE_LOG
        echo ""	>>  $FILE_LOG
	fi																																		

}
#---------------------------------------------------------------------------------------------------------------------------------#


#---------------------------------------------------------------------------------------------------------------------------------#
#funcao para descompactar os arquivos
function criptografiafileeps() 

{
	if [ $RC -eq 0 ]; then 
		echo "######################################################################################################################">$FILE_LOG
		echo "                               PROCESSO PARA CRIPTOGRAFAR OS ARQUIVOS DAS EPS ${EPS}                                  ">>$FILE_LOG          
		echo "######################################################################################################################">>$FILE_LOG
		nFile=$(ls $LOCAL_DIR | grep "${EPS}.*.csv" | wc -l) 
		if [ $nFile -ne 0 ]; then
			for file in $(ls $LOCAL_DIR | grep "${EPS}.*.csv"); do 
		        gpg --output ${file%.csv} --encrypt --recipient ${RECIPIENT} ${file}
			done
		fi
		retCode=$?
		if [ $retCode -ne 0 ]; then 
			echo "CRIPTOGRAFIA DO ARQUIVO $(basename ${file}) FINALIZADO COM ERROR ${retCode}.">>$FILE_LOG
			RC=1                                                              
		else
		    echo "CRIPTOGRAFIA DO ARQUIVO $(basename ${file}) FINALIZADO COM SUCCESS.">>$FILE_LOG
		fi
		echo "######################################################################################################################">>$FILE_LOG		
    	echo ""	>>  $FILE_LOG
        echo ""	>>  $FILE_LOG
        echo ""	>>  $FILE_LOG
	fi
}
#---------------------------------------------------------------------------------------------------------------------------------#


#---------------------------------------------------------------------------------------------------------------------------------#
#funcao para remover os arquivos da eps
function Removerosarquivoseps()

{
	if [ $RC -eq 0 ]; then
		echo "######################################################################################################################">>$FILE_LOG
		echo "                                   PROCESSO PARA REMOVER OS ARQUIVOS DA EPS ${EPS}                                    ">>$FILE_LOG          
		echo "######################################################################################################################">>$FILE_LOG
		nFile=$(ls $LOCAL_DIR | grep "${EPS}.*.csv" | wc -l)
		if [ $nFile -ne 0 ]; then
			for file in $(ls $LOCAL_DIR | grep "${EPS}.*.csv"); do
				rm ${file}
			done
		fi
		retCode=$?
		if [ $retCode -ne 0 ]; then
			echo " ARQUIVO : $(basename $file) REMOVIDO COM ERROR ${retCode}" >>  $FILE_LOG
			RC=1
		else
			echo "REMOCAO DO ARQUIVO : $(basename $file) FINALIZANDO COM SUCCESS" >>  $FILE_LOG
		fi
		echo "######################################################################################################################">>$FILE_LOG
    	echo ""	>>  $FILE_LOG
        echo ""	>>  $FILE_LOG
        echo ""	>>  $FILE_LOG
	fi

}
#---------------------------------------------------------------------------------------------------------------------------------#




#---------------------------------------------------------------------------------------------------------------------------------#
# funcao para colocar a exttension .csv
function addextension()

{
	if [ $RC -eq 0 ]; then
		echo "######################################################################################################################">>$FILE_LOG
		echo "                     PROCESSO PARA COLOCAR A EXTENSION (.csv)  NOS ARQUIVOS CRIPTOGRAFADOS                           " >>$FILE_LOG           
		echo "######################################################################################################################">>$FILE_LOG
		nFile=$(ls $LOCAL_DIR | grep "${EPS}" | wc -l)
		if [ $nFile -ne 0 ]; then
			for file in $(ls $LOCAL_DIR | grep "${EPS}"); do
				mv -- "${file}" "${file}.csv"
			done
		fi
		retCode=$?
		if [ $retCode -ne 0 ]; then
			echo "EXTENSION COLOCADO NO ARQUIVO: $(basename ${file}) FINALIZADO COM ERROR ${retCode}">>$FILE_LOG
			RC=1
		else
			echo "EXTENSION COLOCADO NO ARQUIVO: $(basename ${file}) FINALIZANDO COM SUCCESS">>$FILE_LOG
		fi
		echo "######################################################################################################################">>$FILE_LOG
    	echo ""	>>  $FILE_LOG
        echo ""	>>  $FILE_LOG
        echo ""	>>  $FILE_LOG
	fi																																	
}
#---------------------------------------------------------------------------------------------------------------------------------#




#---------------------------------------------------------------------------------------------------------------------------------#
#Compactar os arquivos criptografados
function compactarosarquivoparagz()

{
	if [ $RC -eq 0 ]; then
		echo "######################################################################################################################">>$FILE_LOG
		echo "                                          PROCESSO PARA COMPACTAR OS ARQUIVOS                                         ">>$FILE_LOG           
		echo "######################################################################################################################">>$FILE_LOG
		nFile=$(ls $LOCAL_DIR | grep "${EPS}.*.csv" | wc -l)
		if [ $nFile -ne 0 ]; then
			for file in $(ls $LOCAL_DIR | grep "${EPS}.*.csv"); do
				gzip ${file}
			done
		fi
		retCode=$?
		if [ $retCode -ne 0 ]; then
			echo " ARQUIVO : $(basename ${file}) COMPACTADO COM ERROR ${retCode}" >>  $FILE_LOG
			RC=1
		else
			echo "COMPACTADCAO DO ARQUIVO : $(basename ${file}) FINALIZANDO COM SUCCESS">>  $FILE_LOG
		fi
		echo "######################################################################################################################">>$FILE_LOG
    	echo ""	>>  $FILE_LOG
        echo ""	>>  $FILE_LOG
        echo ""	>>  $FILE_LOG
	fi
}
#---------------------------------------------------------------------------------------------------------------------------------#




#---------------------------------------------------------------------------------------------------------------------------------#
#funcao para remover os logs
function Removerloddodiaanterior()

{
	if [ $RC -eq 0 ]; then
		echo "######################################################################################################################">>$FILE_LOG
		echo "                     PROCESSO PARA REMOVER OS ARQUIVOS DE LOGS DA EPS ${EPS} DO DIA ANTERIOR                          ">>$FILE_LOG          
		echo "######################################################################################################################">>$FILE_LOG
		DATE_LOG=$(date --date="-1 day" "+%Y%m%d")
		nFile=$(ls $LOG_DIR | grep ${PROCESSPOINT}.${DATE_LOG} | wc -l)
		if [ $nFile -ne 0 ]; then
		    for file in $(ls $LOG_DIR | grep ${PROCESSPOINT}.${DATE_LOG});do
		        rm -f ${LOG_DIR}/${file}
			done
		fi
		retCode=$?
		if [ $retCode -ne 0 ]; then
			echo " ARQUIVO : $(basename ${file}) REMOVIDO COM ERROR ${retCode} ">>$FILE_LOG
			RC=1
		else
			echo "REMOCAO DO ARQUIVO : $(basename ${file}) FINALIZANDO COM SUCCESS ">>$FILE_LOG
		fi
		echo "######################################################################################################################">>$FILE_LOG
    	echo ""	>>  $FILE_LOG
        echo ""	>>  $FILE_LOG
        echo ""	>>  $FILE_LOG	
    
    fi	

}
#---------------------------------------------------------------------------------------------------------------------------------#


function main()

# $LOCAL_DIR -eq '' || 
{
	if [ -z "$EPS" ]; then
	    echo ""
		echo "============================================================================================================"
	    echo "| ERROR: FALTA DE PARAMETRO  PARA EXECUCAO                                                                !|"
		echo "| Por favor consulte o Documento.md item 6                                                                 |"
		echo "============================================================================================================"
		echo ""
		echo "==============================================DOCUMENTACAO=================================================="
		echo "|                                                                                                          |"
		echo "|6-) COMO É UTILIZADO O SCRIPT PARA CRIPTOGRFAR UM ARQUIVO                                                 |"
    	echo "|O ModeloCriptografiaCobranca4pEPS.sh recebe dois Parametros                                               |"
    	echo "|Parametro 1: O diretorio dos arquivos as serem criptografados.                                            |"
    	echo "|Parametro 2: O nome da eps que vem na máscara do arquivo (Exemplo:CREDITCASH_CONTATO_MASSIVO)             |"
		echo "|Execução: bash ModeloCriptografiaCobranca4pEPS.sh <diretorio dos arquivos as serem criptografados>  <EPS> |"
		echo "|                                                                                                          |"
		echo "============================================================================================================"
		echo ""
		exit 0
	else
    	Pathcriptografialogs
    	pathbkpfileeps
    	bkpfileeps
    	criptografiafileeps
    	Removerosarquivoseps
    	addextension
    	compactarosarquivoparagz
    	Removerloddodiaanterior
		exit 0
	fi 
		


}

main
