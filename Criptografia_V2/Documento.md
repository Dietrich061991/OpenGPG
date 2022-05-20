

                                  CRIPTOGRAFIA DOS ARQUIVOS DAS ACESSORIAS

1 - NOME DO SCRIPT
2 - PARA QUE SERVE
3 - AMBIANTE DE TESTE
4 - TECNOLOGIA USADA
5 - SOFTWARE UTILIZADO PARA CRIPTOGRAFIA
6 - COMO ELE É UTILIZADO 
7 - TIPO DA CRIPTOGRAFIA
8 - O QUE DEVO FAZER ANTES DE QUALQUER EXECUÇÃO
9 - CHAVE PÚBLICA  

                             
1-) NOME DO SCRIPT

    ModeloCriptografiaCobranca4pEPS.sh



2-) PARA QUE SERVE

    Esse script foi implementado para criptografar os arquivos enviados pelos parceiros de cobrança (Ex: Atento; Cash; Fulltime)


3-) AMBIANTE DE TESTE

    Ambiante Unix
    Todos os testes foram realizados no ambiante de homologação no servidor 'svc_preloadbd@brtlvlts1707co'.



4-) TECNOLOGIA USADA

    - Shell Script
    Um script Script é um algoritmo projetado para realizar uma determinada tarefa, utilizando os comandos específicos do bash e os executáveis do sistema operacional.


5-) SOFTWARE UTILIZADO PARA CRIPTOGRAFIA

    *Ambiente de Homologação* 

    - GPG
    - version do software
    gpg (GnuPG) 2.0.22
    libgcrypt 1.5.3
    Copyright (C) 2013 Free Software Foundation, Inc.
    License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
    This is free software: you are free to change and redistribute it.
    There is NO WARRANTY, to the extent permitted by law.

    Home: ~/.gnupg
    Supported algorithms:
    Pubkey: RSA, ?, ?, ELG, DSA
    Cipher: IDEA, 3DES, CAST5, BLOWFISH, AES, AES192, AES256, TWOFISH,
            CAMELLIA128, CAMELLIA192, CAMELLIA256
    Hash: MD5, SHA1, RIPEMD160, SHA256, SHA384, SHA512, SHA224
    Compression: Uncompressed, ZIP, ZLIB, BZIP2


    *Ambiente de Produção*
    - GPG
    - version do software
    gpg (GnuPG) 2.0.22
    libgcrypt 1.5.3
    Copyright (C) 2013 Free Software Foundation, Inc.
    License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
    This is free software: you are free to change and redistribute it.
    There is NO WARRANTY, to the extent permitted by law.

    Home: ~/.gnupg
    Supported algorithms:
    Pubkey: RSA, ?, ?, ELG, DSA
    Cipher: IDEA, 3DES, CAST5, BLOWFISH, AES, AES192, AES256, TWOFISH,
            CAMELLIA128, CAMELLIA192, CAMELLIA256
    Hash: MD5, SHA1, RIPEMD160, SHA256, SHA384, SHA512, SHA224
    Compression: Uncompressed, ZIP, ZLIB, BZIP2


6-) COMO É UTILIZADO O SCRIPT PARA CRIPTOGRFAR UM ARQUIVO

    O ModeloCriptografiaCobranca4pEPS.sh recebe dois Parametros

    Parametro 1: O diretorio dos arquivos as serem criptografados.
    Parametro 2: O nome da eps que vem na máscara do arquivo (Exemplo: CREDITCASH_CONTATO_MASSIVO)

    Execução: bash ModeloCriptografiaCobranca4pEPS.sh <diretorio dos arquivos as serem criptografados>  <EPS>


7-) TIPO DA CRIPTOGRAFIA


    RSA 4096 


8-) O QUE DEVO FAZER ANTES DE QUALQUER EXECUÇÃO

    Verificar se a chave publica foi importada para a base gpg usando esse comando
    
    gpg --list-keys
    
    OBS: verificar se 'validacaoEPS@telefonica.com' se encontra na lista das chaves retornadas.
    se for encontrada executar o processo, caso contrário solicitar a chave pública para fazer o import usando esse comando 

    gpg --import PublickeyAcessoriasVivoCobranca4pII.key

    gpg --edit-key validacaoEPS@telefonica.com 

    gpg> trust

    Your decision? 5

    Do you really want to set this key to ultimate trust? (y/N) y

    gpg> quit


9-) CHAVE PÚBLICA

    A chave pública gerada será PublickeyAcessoriasVivoCobranca4pII.key





    


