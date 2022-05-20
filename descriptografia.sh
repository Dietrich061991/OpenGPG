#!/bin/sh
#__________________________________________________________________________________________________________________________________
#
# Author       : Time BIG DATA --> SEDAMI DIETRICH MONTCHO
# Project      : Cobranca4pII
#
# File Name    : install.20210713.01.sh
# Version      : 1.0
#
# Description  : Script para descriptografar os arquivos de acessoria canal digitais do projeto BIG DATA
#                Cobranca4pII
#
# History
# Who | When       | Comment
#-----+------------+---------------------------------------------------------------------------------------------------------------
# BD  | 16/07/2022 | Creation program file
#__________________________________________________________________________________________________________________________________

#export GPG_TTY=$(tty) #Nao precisa mais para evitar o terminal inter-ativo  

#LOCAL_DIR='/opt/ingestao/automatizador/projetos/hmlg_cobranca4p/data/stage/connect/indicador/import'
LOCAL_DIR="$( cd "$( dirname "${0}" )" && pwd )"
#LOCAL_DIR='/opt/ingestao/automatizador/projetos/hmlg_cobranca4p/scripts/indicador/sftp'

###################################################################################################################################
#parametros iniciais
RC=0
# File Date Log
FILE_DATE_LOG=$(date +%Y%m%d%H%M%S)
#data inicio
INI_DATE=$(date +%d/%m/%Y"  "%H:%M:%S)
#Tipo EPS
EPS=$1
#dir log
#log dir 
LOG_DIR=$LOCAL_DIR/"criptografialogs"
#process point
PROCESSPOINT='PROCESSO.DESCRIPTOGRAFIA.'${EPS}
#log file
FILE_LOG=${LOG_DIR}/${PROCESSPOINT}.${FILE_DATE_LOG}'.log'
###################################################################################################################################
#acess key files
#source criptopasse.pass
#password=$(eval echo ${CRIPTOPASSE} | base64 --decode)
#echo $password
#exit
password="cobranca4pII"

###################################################################################################################################
#funcao para criar a pasta dos log caso nao existir

function mkdircriptografialogs()

{
    if [ $RC -eq 0 ] && [ ! -d $LOG_DIR ]; then
     	mkdir -p $LOG_DIR
    fi

}


#funcao para descompactar os arquivos
function Descompactarfile() 

{
	if [ $RC -eq 0 ]; then 
		echo ""  >> $FILE_LOG                                                                                                                                    
		echo "----------------------------------------------------------------------------------------------" >> $FILE_LOG
		echo "|                             PROCESSO PARA DESCOMPACTAR OS ARQUIVOS                         |" >> $FILE_LOG          	   
		echo "----------------------------------------------------------------------------------------------" >> $FILE_LOG
		nFile=$(ls $LOCAL_DIR | grep *${EPS}*.csv.gz | wc -l) # receber .csv.gz por causa dos arquivod nao encontrados
		if [ $nFile -ne 0 ]; then
			for file in $(ls $LOCAL_DIR | grep *${EPS}*.csv.gz); do #aqui tbm
		        gunzip ${file}
			done
		fi
		retCode=$?
		if [ $retCode -ne 0 ]; then 
			echo "DESCOMPACTACAO DO ARQUIVO $(basename ${file}) FINALIZADO COM ERROR ${retCode}." >> $FILE_LOG
			RC=1                                                              
		else
		    echo "DESCOMPACTACAO DO ARQUIVO $(basename ${file}) FINALIZADO COM SUCCESS" >> $FILE_LOG
		fi
		echo "-----------------------------------------------------------------------------------------------" >> $FILE_LOG		
    	
	fi
}



function alteracaodaextencaoparagpg()

{

	if [ $RC -eq 0 ]; then
		echo ""	>>  $FILE_LOG
		echo ""  >> $FILE_LOG
		echo ""  >> $FILE_LOG
		echo "-----------------------------------------------------------------------------------------------" >> $FILE_LOG
		echo "|       PROCESSO PARA ALTERAR A EXTENSAO (.csv) DOS ARQUIVOS PARA A  EXTENSAO (.gpg)          |" >> $FILE_LOG    		   
		echo "-----------------------------------------------------------------------------------------------" >> $FILE_LOG
		nFile=$(ls $LOCAL_DIR | grep *${EPS}*.csv | wc -l)
		if [ $nFile -ne 0 ]; then
			for file in $(ls $LOCAL_DIR | grep *${EPS}*.csv); do
		    	mv -- "${file}" "${file%.csv}.gpg"
			done
		fi
		retCode=$?
		if [ $retCode -ne 0 ]; then 
		    echo "EXTENSAO DO ARQUIVO: $(basename ${file}) ALTERADO COM ERROR ${retCode}.">> $FILE_LOG
			RC=1 
		else
		    echo "EXTENSAO DO ARQUIVO: $(basename ${file}) ALTERADO COM SUCCESS.">> $FILE_LOG
		fi
		echo "------------------------------------------------------------------------------------------------">> $FILE_LOG
	fi																																		

}

function Descriptografarosarquivos()

{
	if [ $RC -eq 0 ]; then
		echo ""	>>  $FILE_LOG
		echo ""  >> $FILE_LOG
		echo ""  >> $FILE_LOG
		echo "----------------------------------------------------------------------------------------------" >>  $FILE_LOG
		echo "|                    PROCESSO PARA DESCRIPTOGRAFAR OS ARQUIVOS (.gpg)                        |" >>  $FILE_LOG           	        echo "----------------------------------------------------------------------------------------------" >>  $FILE_LOG
		nFile=$(ls $LOCAL_DIR | grep *${EPS}*.gpg | wc -l)
		if [ $nFile -ne 0 ]; then
			for file in $(ls $LOCAL_DIR | grep *${EPS}*.gpg); do
				#gpg --output ${file} --batch --yes --passphrase $password --decrypt ${file}
				#echo $password | gpg  --batch --passphrase-fd 0  --decrypt-file $file >  $file."csv"
				echo $password | gpg  --batch --yes --passphrase-fd 0 -d $file > "${file%.gpg}.csv"
			done
		fi
		retCode=$?
		if [ $retCode -ne 0 ]; then
			echo "DESCRIPTOGRAFIA DO ARQUIVO: $(basename ${file}) FINALIZADO COM ERROR ${retCode}">>  $FILE_LOG
			RC=1
		else
			echo "DESCRIPTOGRAFIA DO ARQUIVO: $(basename ${file}) FINALIZANDO COM SUCCESS">>  $FILE_LOG
		fi
		echo "----------------------------------------------------------------------------------------------" >>  $FILE_LOG

	fi																																	
}


function compactarosarquivoparagz()

{
	if [ $RC -eq 0 ]; then
		echo ""	>>  $FILE_LOG
		echo ""  >> $FILE_LOG
		echo ""  >> $FILE_LOG
		echo "----------------------------------------------------------------------------------------------" >>  $FILE_LOG
		echo "|                            PROCESSO PARA COMPACTAR OS ARQUIVOS                             |" >>  $FILE_LOG                
		echo "----------------------------------------------------------------------------------------------" >>  $FILE_LOG
		nFile=$(ls $LOCAL_DIR | grep *${EPS}*.csv | wc -l)
		if [ $nFile -ne 0 ]; then
			for file in $(ls $LOCAL_DIR | grep *${EPS}*.csv); do
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
		echo "----------------------------------------------------------------------------------------------" >>  $FILE_LOG

	fi
}


function Removerosarquivosgpg()

{
	if [ $RC -eq 0 ]; then
		echo ""  >> $FILE_LOG
		echo ""  >> $FILE_LOG
		echo ""  >> $FILE_LOG
		echo "----------------------------------------------------------------------------------------------" >>  $FILE_LOG
        echo "|                 PROCESSO PARA REMOVER OS ARQUIVOS GPG                                      |" >>  $FILE_LOG     	   
		echo "----------------------------------------------------------------------------------------------" >>  $FILE_LOG
		nFile=$(ls $LOCAL_DIR | grep "${EPS}.*.gpg" | wc -l)
		if [ $nFile -ne 0 ]; then
			for file in $(ls $LOCAL_DIR | grep "${EPS}.*.gpg"); do
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
		echo "-----------------------------------------------------------------------------------------------" >> $FILE_LOG

	fi

}


function Removerloddodiaanterior()

{
	if [ $RC -eq 0 ]; then
		echo ""  >> $FILE_LOG
		echo ""  >> $FILE_LOG
		echo ""  >> $FILE_LOG
		echo "---------------------------------------------------------------------------------------------" >>  $FILE_LOG
		echo "|                 PROCESSO PARA REMOVER OS ARQUIVOS DE LOGS DO DIA ANTERIOR                 |" >>  $FILE_LOG     		   
		echo "---------------------------------------------------------------------------------------------" >>  $FILE_LOG
		DATE_LOG=$(date --date="-1 day" "+%Y%m%d")
		nFile=$(ls $LOG_DIR | grep ${PROCESSPOINT}.${DATE_LOG} | wc -l)
		if [ $nFile -ne 0 ]; then
			for file in $(ls $LOG_DIR | grep ${PROCESSPOINT}.${DATE_LOG});do
				rm -f ${LOG_DIR}/${file}
			done
		fi
		retCode=$?
		if [ $retCode -ne 0 ]; then
			echo " ARQUIVO : $(basename ${file}) REMOVIDO COM ERROR ${retCode} "               >>  $FILE_LOG
			RC=1
		else
			echo "REMOCAO DO ARQUIVO : $(basename ${file}) FINALIZANDO COM SUCCESS "           >>  $FILE_LOG
		fi
		echo "-----------------------------------------------------------------------------------------------" >> $FILE_LOG
	fi	

}


function main() 

{
   mkdircriptografialogs
   echo ""  > $FILE_LOG
   echo ""  >> $FILE_LOG
   echo "============================================================================================================">>$FILE_LOG
   echo "|                   PROCESSO PARA DESCRIPTOGRAFAR OS ARQUIVOS DA EPS CANAIS DIGITAIS                        |">> $FILE_LOG
   echo "=============================================================================================================">> $FILE_LOG
   echo ""  >> $FILE_LOG
   echo ""  >> $FILE_LOG
   echo "                                      Inicio da processo: "$INI_DATE  >> $FILE_LOG
   echo ""  >> $FILE_LOG
   echo ""  >> $FILE_LOG
   echo ""  >> $FILE_LOG
   
   Descompactarfile
   alteracaodaextencaoparagpg
   Descriptografarosarquivos
   compactarosarquivoparagz
   Removerosarquivosgpg
   Removerloddodiaanterior

   echo "============================================= RESUMO DO PROCESSO============================================">> $FILE_LOG
   FIM_DATE=$(date +%d/%m/%Y"  "%H:%M:%S)
   if [ $RC -eq 0 ]; then
	  echo "" >> $FILE_LOG
      echo "                             Processo terminado com SUCCESS.                                         ">> $FILE_LOG
      echo "   			      Termino do processo: "$FIM_DATE                                         >> $FILE_LOG
	  echo "" >> $FILE_LOG
	  echo "=====================================================================================================">> $FILE_LOG
	  echo "" >> $FILE_LOG
   else
   	  echo "" >> $FILE_LOG
	  echo "" >> $FILE_LOG
          echo "                             Processo terminado com ERRO.                                           " >> $FILE_LOG
	  echo "                            Termino do processo: "$FIM_DATE                                           >> $FILE_LOG
	  echo "" >> $FILE_LOG
	  echo "" >> $FILE_LOG
	  echo "======================================================================================================">> $FILE_LOG
   fi
   

   exit 0


}

main
