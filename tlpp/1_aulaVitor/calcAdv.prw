#INCLUDE "TOTVS.CH"
 
/*/{Protheus.doc} zLogin
Função para montar a tela de login simplificada
@type function
@author Atilio
@since 17/09/2015
@version 1.0
    @param cUsrLog, Caracter, Usuário para o login (ex.: "admin")
    @param cPswLog, Caracter, Senha para o login (ex.: "123")
    @return lRet, Retorno lógico se conseguiu encontrar o usuário digitado
    @example
    //Verificando se o login deu certo
    If u_zLogin(@cUsrAux, @cPswAux)
        //....
    EndIf
/*/
 
User Function calcadv(cUsrLog, cPswLog)
    Local aArea := GetArea()
    Local oGrpLog
    Local oBtnConf
    Private lRetorno := .F.
    Private oDlgPvt
    //Says e Gets
    Private oSayUsr
    Private oGetUsr, cGetUsr := Space(25)
    Private oSayPsw
    Private oGetPsw, cGetPsw := Space(20)
    Private oGetErr, cGetErr := ""
    //Dimensões da janela
    Private nJanLarg := 200
    Private nJanAltu := 200
     
    //Criando a janela
    DEFINE MSDIALOG oDlgPvt TITLE "Calculadora" FROM 000, 000  TO nJanAltu, nJanLarg COLORS 0, 16777215 PIXEL
         
            @ 020, 002 MSGET oGetErr VAR cGetErr SIZE (nJanLarg/2)-12, 007 OF oDlgPvt COLORS 0, 16777215 NO BORDER PIXEL
            oGetErr:lActive := .F.
         
            //Botões
            @ 40,  000 BUTTON oBtnConf PROMPT "AC" SIZE 20, 015 OF oDlgPvt ACTION (cGetErr := "",  oGetErr:Refresh()) PIXEL
            @ 50,  000 BUTTON oBtnConf PROMPT "<-" SIZE 20, 015 OF oDlgPvt ACTION (cGetErr := "",  oGetErr:Refresh()) PIXEL
            @ 60,  000 BUTTON oBtnConf PROMPT "%"  SIZE 20, 015 OF oDlgPvt ACTION (cGetErr := "%", oGetErr:Refresh()) PIXEL
            @ 70,  000 BUTTON oBtnConf PROMPT "/"  SIZE 20, 015 OF oDlgPvt ACTION (cGetErr := "/", oGetErr:Refresh()) PIXEL
            @ 80,  000 BUTTON oBtnConf PROMPT "7"  SIZE 20, 015 OF oDlgPvt ACTION (cGetErr := "7", oGetErr:Refresh()) PIXEL
            @ 90,  000 BUTTON oBtnConf PROMPT "8"  SIZE 20, 015 OF oDlgPvt ACTION (cGetErr := "8", oGetErr:Refresh()) PIXEL
            @ 100, 000 BUTTON oBtnConf PROMPT "9"  SIZE 20, 015 OF oDlgPvt ACTION (cGetErr := "9", oGetErr:Refresh()) PIXEL
            @ 110, 000 BUTTON oBtnConf PROMPT "x"  SIZE 20, 015 OF oDlgPvt ACTION (cGetErr := "x", oGetErr:Refresh()) PIXEL
            @ 120, 000 BUTTON oBtnConf PROMPT "4"  SIZE 20, 015 OF oDlgPvt ACTION (cGetErr := "4", oGetErr:Refresh()) PIXEL
            @ 130, 000 BUTTON oBtnConf PROMPT "5"  SIZE 20, 015 OF oDlgPvt ACTION (cGetErr := "5", oGetErr:Refresh()) PIXEL
            @ 140, 000 BUTTON oBtnConf PROMPT "6"  SIZE 20, 015 OF oDlgPvt ACTION (cGetErr := "6", oGetErr:Refresh()) PIXEL
            @ 150, 000 BUTTON oBtnConf PROMPT "-"  SIZE 20, 015 OF oDlgPvt ACTION (cGetErr := "-", oGetErr:Refresh()) PIXEL
            @ 160, 000 BUTTON oBtnConf PROMPT "1"  SIZE 20, 015 OF oDlgPvt ACTION (cGetErr := "1", oGetErr:Refresh()) PIXEL
            @ 170, 000 BUTTON oBtnConf PROMPT "2"  SIZE 20, 015 OF oDlgPvt ACTION (cGetErr := "2", oGetErr:Refresh()) PIXEL
            @ 180, 000 BUTTON oBtnConf PROMPT "3"  SIZE 20, 015 OF oDlgPvt ACTION (cGetErr := "3", oGetErr:Refresh()) PIXEL
            @ 190, 000 BUTTON oBtnConf PROMPT "+"  SIZE 20, 015 OF oDlgPvt ACTION (cGetErr := "+", oGetErr:Refresh()) PIXEL
            @ 200, 000 BUTTON oBtnConf PROMPT "0"  SIZE 40, 015 OF oDlgPvt ACTION (cGetErr := "0", oGetErr:Refresh()) PIXEL
            @ 210, 000 BUTTON oBtnConf PROMPT ","  SIZE 20, 015 OF oDlgPvt ACTION (cGetErr := ",", oGetErr:Refresh()) PIXEL
            @ 220, 000 BUTTON oBtnConf PROMPT "="  SIZE 20, 015 OF oDlgPvt ACTION (cGetErr := "=", oGetErr:Refresh()) PIXEL

    ACTIVATE MSDIALOG oDlgPvt CENTERED
     
    //Se a rotina foi confirmada e deu certo, atualiza o usuário e a senha
    If lRetorno
        cUsrLog := Alltrim(cGetUsr)
        cPswLog := Alltrim(cGetPsw)
    EndIf
     
    RestArea(aArea)
Return lRetorno
 
/*---------------------------------------------------------------------*
 | Func:  fVldUsr                                                      |
 | Autor: Daniel Atilio                                                |
 | Data:  17/09/2015                                                   |
 | Desc:  Função para validar se o usuário existe                      |
 *---------------------------------------------------------------------*/
 
Static Function fVldUsr()
    Local cUsrAux := Alltrim(cGetUsr)
    Local cPswAux := Alltrim(cGetPsw)
    Local cCodAux := ""
     
    //Pega o código do usuário
    RPCClearEnv()
    If RpcSetEnv("01", "", cGetUsr, cGetPsw)
        cCodAux := RetCodUsr()
      
     //Senão atualiza o erro e retorna para a rotina
     Else
         cGetErr := "Usuário e/ou senha inválidos!"
         oGetErr:Refresh()
         Return
    EndIf
     
    //Se o retorno for válido, fecha a janela
    If lRetorno
        oDlgPvt:End()
    EndIf
Return


/* 
USER FUNCTION calcAdv()
 
    DEFINE MSDIALOG oDlg TITLE "Calculadora" PIXEL FROM 0,0 TO 220,210
 
        // Cria Botoes com metodos básicos
        TButton():New(25 , 002, "AC", oDlg, {|| }, 25, 25, , , .F., .T., .F., , .F., , , .F.)
        TButton():New(25 , 027, "<-", oDlg, {|| }, 25, 25, , , .F., .T., .F., , .F., , , .F.)
        TButton():New(25 , 052, "%" , oDlg, {|| }, 25, 25, , , .F., .T., .F., , .F., , , .F.)
        TButton():New(25 , 077, "/" , oDlg, {|| }, 25, 25, , , .F., .T., .F., , .F., , , .F.)
        TButton():New(50 , 002, "7" , oDlg, {|| }, 25, 25, , , .F., .T., .F., , .F., , , .F.)
        TButton():New(50 , 027, "8" , oDlg, {|| }, 25, 25, , , .F., .T., .F., , .F., , , .F.)
        TButton():New(50 , 052, "9" , oDlg, {|| }, 25, 25, , , .F., .T., .F., , .F., , , .F.)
        TButton():New(50 , 077, "x" , oDlg, {|| }, 25, 25, , , .F., .T., .F., , .F., , , .F.)
        TButton():New(75 , 002, "4" , oDlg, {|| }, 25, 25, , , .F., .T., .F., , .F., , , .F.)
        TButton():New(75 , 027, "5" , oDlg, {|| }, 25, 25, , , .F., .T., .F., , .F., , , .F.)
        TButton():New(75 , 052, "6" , oDlg, {|| }, 25, 25, , , .F., .T., .F., , .F., , , .F.)
        TButton():New(75 , 077, "-" , oDlg, {|| }, 25, 25, , , .F., .T., .F., , .F., , , .F.)
        TButton():New(100, 002, "1" , oDlg, {|| }, 25, 25, , , .F., .T., .F., , .F., , , .F.)
        TButton():New(100, 027, "2" , oDlg, {|| }, 25, 25, , , .F., .T., .F., , .F., , , .F.)
        TButton():New(100, 052, "3" , oDlg, {|| }, 25, 25, , , .F., .T., .F., , .F., , , .F.)
        TButton():New(100, 077, "+" , oDlg, {|| }, 25, 25, , , .F., .T., .F., , .F., , , .F.)
        TButton():New(125, 002, "0" , oDlg, {|| }, 50, 25, , , .F., .T., .F., , .F., , , .F.)
        TButton():New(125, 052, "," , oDlg, {|| }, 25, 25, , , .F., .T., .F., , .F., , , .F.)
        TButton():New(125, 077, "=" , oDlg, {|| }, 25, 25, , , .F., .T., .F., , .F., , , .F.)
 
    ACTIVATE DIALOG oDlg CENTERED

RETURN
*/
