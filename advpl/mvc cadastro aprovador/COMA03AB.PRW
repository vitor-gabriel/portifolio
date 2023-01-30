#INCLUDE 'TOTVS.CH'
#INCLUDE 'FWMVCDEF.CH'
#INCLUDE 'TOPCONN.CH'

/*/{Protheus.doc} COMA03AB
COMA03AB
@type function
@version 12.1.27
@author vitor.gabriel
@since 20/10/2021
/*/

User Function COMA03AB()

	Local aArea    := GetArea()
	Local oBrowse  := Nil
	Local aRotina  := {}
	Local cUserLib := GetNewPar("MV_XAPROV","000000")

	//-> Verifica acesso a rotina
	If (__cUserId $ cUserLib)
		aRotina := MenuDef()
		//-> Instanciamento da Classe de Browse
		oBrowse := FWMBrowse():New()

		//-> DefiniÃ§Ã£o da tabela do Browse
		oBrowse:SetAlias("ZZD")
		oBrowse:SetMenuDef("COMA03AB")

		// Titulo da Browse
		oBrowse:SetDescription("Cadastro de Aprovador")

		// AtivaÃ§Ã£o da Classe
		oBrowse:Activate()
		RestArea(aArea)
	Else
		Help(,,"Sem Permissao de Acesso",,;
			"Usuario sem permissão para acesso ao cadastro de aprovador.",1,0,,,,,,;
			{"Contate o time de TI."})
		RestArea(aArea)
	EndIf

Return

/*/{Protheus.doc} MenuDef
MenuDef
@type function
@version 1.0.0 
@author vitor.gabriel
@since 20/10/2021
/*/
Static Function MenuDef()

	Local aRotina := {}

	aAdd( aRotina, { 'Pesquisar' , 'PesqBrw'         , 0, 1, 0, NIL } )
	aAdd( aRotina, { 'Visualizar', 'VIEWDEF.COMA03AB', 0, 2, 0, NIL } )
	aAdd( aRotina, { 'Incluir'   , 'VIEWDEF.COMA03AB', 0, 3, 0, NIL } )
	aAdd( aRotina, { 'Alterar'   , 'VIEWDEF.COMA03AB', 0, 4, 0, NIL } )
	aAdd( aRotina, { 'Excluir'   , 'VIEWDEF.COMA03AB', 0, 5, 0, NIL } )
	aAdd( aRotina, { 'Imprimir'  , 'VIEWDEF.COMA03AB', 0, 8, 0, NIL } )
	aAdd( aRotina, { 'Copiar'    , 'VIEWDEF.COMA03AB', 0, 9, 0, NIL } )

Return(aRotina)

Static Function ModelDef()

	Local oModel  := MPFormModel():New("OMA03AB",,{ |oMdl| fChkPos( oMdl ) })
	Local oStrZZD := FWFormStruct(1,"ZZD")

	//->Cabeçalho
	oStrZZD:RemoveField("ZZD_FILIAL")

	oStrZZD:SetProperty("ZZD_CODIGO" , MODEL_FIELD_INIT , {|x| x := GetSxeNum("ZZD","ZZD_CODIGO")})
	oStrZZD:SetProperty("ZZD_CODIGO" , MODEL_FIELD_WHEN , {||.F.                                 })

	oStrZZD:AddTrigger("ZZD_USCOD"   ,"ZZD_NOME"        , {||.T.},{|x| x := RetNome(x)           })
	oStrZZD:SetProperty("ZZD_NOME"   , MODEL_FIELD_WHEN , {||.F.                                 })

	oModel:SetDescription("Tabela de Aprovadores")

	oModel:AddFields("ZZDMASTER",,oStrZZD)

	oModel:SetPrimaryKey({"ZZD_FILIAL","ZZD_CODIGO"})

Return(oModel)

Static Function ViewDef()

	Local oStrZZD  := FWFormStruct(2,"ZZD")
	Local oModel   := ModelDef()
	Local oView    := FWFormView():New()

	//->Cabeçalho
	oStrZZD:RemoveField("ZZD_FILIAL")

	oView:SetModel(oModel)

	//Adicionando os campos do cabeÃ§alho e o grid dos filhos
	oView:AddField("VIEW_ZZD",oStrZZD,"ZZDMASTER")

	//Setando o dimensionamento de tamanho
	oView:CreateHorizontalBox("TELA" ,100)
	//Amarrando a view com as box
	oView:SetOwnerView("VIEW_ZZD","TELA")

	oView:EnableControlBar(.T.)
	oView:SetCloseOnOk({||.T.})

	oView:SetViewAction( "BUTTONCANCEL" ,{ || RollbackSx8() } )
	oView:SetViewAction( "BUTTONOK"     ,{ || ConfirmSx8()  } )
	oView:SetFieldAction("ZZD_NIVEL",{|oView| fChkCad(oView)} )

Return(oView)

Static Function RetNome(oField)

	Local cCodUsr := oField:GetValue("ZZD_USCOD")

	If PSWSeek(cCodUsr)
		aUser  := PswRet(1)
		cRet   := aUser[1][2]
	EndIf

Return cRet

Static Function fChkCad(oView)

	Local oModel  := FWModelActive()
	Local oModelM := oModel:GetModel("ZZDMASTER")
	Local cCodUsr := oModelM:GetValue("ZZD_USCOD")
	Local cNivel  := oModelM:GetValue("ZZD_NIVEL")
	Local cAlZZD  := GetNextAlias()
	Local cSQLUsr := "%"+cCodUsr+"%"

	If Select(cAlZZD) != 0
		(cAlZZD)->(DbCloseArea())
	EndIf

	If !Empty(oModelM:GetValue("ZZD_NIVEL")) .And. oModel:isActive()

		BeginSql Alias cAlZZD
            SELECT
                ZZD_USCOD
            FROM
                %Table:ZZD%
            WHERE
                %NotDel%
                AND ZZD_USCOD = %Exp:cSQLUsr%
                AND ZZD_NIVEL = %Exp:cNivel%
		EndSql

		If !Empty((cAlZZD)->ZZD_USCOD)
			Help(,,"Aprovador já cadastrado!",,"O aprovador ja foi cadastrado anteriormente no mesmo nivel.",1,0,,,,,,{"Consulte o codigo do aprovador via Browse e atualize o registro ja cadastrado."})
			(cAlZZD)->(DbCloseArea())
			oModelM:LoadValue("ZZD_USCOD","")
			oModelM:LoadValue("ZZD_NOME" ,"")
			oModelM:LoadValue("ZZD_NIVEL","")
			oView:Refresh()
		EndIf
	EndIf
Return

/*/{Protheus.doc} fChkPos
checa os campos do model
@type function
@version 1.0.0
@author Vitor
@since 20/10/2021
@param oModel, object, objeto do model
@return variant, .T. continua, .F. nao deixa continuar
/*/
Static Function fChkPos(oModel)

	Local nOperation := oModel:GetOperation()
	Local lRet := .T.

	If nOperation == MODEL_OPERATION_UPDATE .Or. nOperation == MODEL_OPERATION_INSERT
		If Empty(oModel:GetValue("ZZDMASTER","ZZD_CO"))
			Help(,,"HELP",,"Informe a conta orçamentaria com um valor válido ou com 'XXXXXX' para indicar que ele aprova todas as contas do grupo", 1, 0)
			lRet := .F.
		EndIf
		If Empty(oModel:GetValue("ZZDMASTER","ZZD_FILAPV"))
			Help(,,"HELP",,"Informe a filial com um valor valido ou com 'XXXXXX' para indicar que ele aprova todas as filiais do grupo", 1, 0)
			lRet := .F.
		EndIf
	EndIf

Return lRet
