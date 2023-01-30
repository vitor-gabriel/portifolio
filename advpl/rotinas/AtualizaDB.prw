#INCLUDE "TOTVS.CH"                                                                     

Static oMemo
Static cMemo := "" 

User Function AtualizaDB()

	PRIVATE oDlg
	PRIVATE aCritica  := {}
	PRIVATE lCritico  := .F.
	PRIVATE cDataBase := AllTrim(TCGetDB())

	cMemo    := ""
	cMascara := "   "

	DEFINE MSDIALOG oDlg TITLE "Atualizador de Estrutura - Versao 2.1" FROM 0,0 TO 330,600 PIXEL

	@ 3,3 GET oMemo  VAR cMemo MEMO SIZE 297,130 OF oDlg PIXEL
	oMemo:lReadOnly := .T.
	@ 138, 003 SAY "Mascara :" OF oDlg PIXEL SIZE 050,006
	@ 137, 030 GET cMascara Picture "@!" OF oDlg VALID /*ValidaAlias(cMascara)*/SIZE 050,006 PIXEL
	@ 138, 085 SAY "-->>  INSIRA A TABELA QUE DESEJA ATUALIZAR OU DEIXE EM BRANCO" OF oDlg PIXEL SIZE 300,006
	@ 150, 085 SAY "      PARA TODAS AS TABELAS DO SX2" OF oDlg PIXEL SIZE 300,006
	DEFINE SBUTTON FROM 152,03 TYPE 1 ACTION(Processa({||fOK(cMascara)})) OF oDlg ENABLE PIXEL

	ACTIVATE DIALOG oDlg CENTERED

Return

Static function fOK(cMascara)

	Local aStruSX3 	:= {}
	Local _aAreaSX2	:= {}
	
	__SetX31Mode(.F.)
	If Empty(cMascara)
		DbSelectArea("SX2")
		SX2->(DbSetOrder(1))
		ProcRegua(SX2->(RecCount()))
		SX2->(DbGotop())
		While !SX2->(Eof())
			_aAreaSX2 := SX2->(GetArea())
			IncProc("Tabela: "+ SX2->X2_CHAVE)
			X31UpdTable(SX2->X2_CHAVE)
			DbSelectArea(SX2->X2_CHAVE)
			RestArea(_aAreaSX2)
			SX2->(Dbskip())
		EndDo	
	Else
		X31UpdTable(cMascara)
		DbSelectArea(SX2->X2_CHAVE)
		If __GetX31Error()
			Alert(__GetX31Trace())
			MsgAlert("Ocorreu um erro desconhecido durante a atualizacao!","Atencao!")
		EndIf
	EndIf

Return

