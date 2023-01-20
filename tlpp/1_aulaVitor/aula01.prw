#INCLUDE "TOTVS.CH"

/*
Classe da Lanchonete
    Propriedade:
        Mesa
        Talheres
        Cardapio -> Filho da classe cardapio

    Method:
        Arrumar a mesa
        Agendar a mesa
        Colocar talher na mesa
        Tirar a mesa
        Cardapio do dia

*/

USER FUNCTION minhaLanchonete()
    Local oLanchonete := Nil as object
    Local cMesaEscolhida := "01" as Character 
    Local nOpc  := 1 as Numeric // 1 verifica / 2 agenda

    oLanchonete := lanchonete():new() 
    oLanchonete:arrumarMesa(cMesaEscolhida, nOpc)
RETURN 

CLASS LANCHONETE FROM LONGCLASSNAME

    DATA MESA       AS ARRAY 
    DATA TALHERES   AS CHARACTER  
    DATA CARDAPIO   AS ARRAY 

    METHOD new() CONSTRUCTOR

    METHOD arrumarMesa() 
    METHOD agendarMesa()
    METHOD talherNaMesa()
    METHOD tirarMesa()
    METHOD cardapioDia()

ENDCLASS

METHOD new() CLASS lanchonete
    SELF:mesa     := { {"01", .T.},{"02", .T.},{"03", .T. },{"04", .T.} }
    SELF:talheres := ""
    SELF:cardapio := {"Hamburguer Tradicional","Hamburguer Gourmet","Fritas"}
RETURN 

METHOD arrumarMesa(cMesaEscolhida, nOpc) CLASS lanchonete 
    Local lRet := .F. as Logical

    IF SELF:agendaMesa(cMesaEscolhida, nOpc)
        lRet := .T.
    ENDIF 

RETURN lRet 

METHOD agendarMesa(cMesaEscolhida, nOpc) CLASS lanchonete
    Local lRet := .F. as Logical 

    IF AScan(SELF:mesa,{|x| lRet := IIF(x[1] == cMesaEscolhida, x[2],.F.) }) .AND. nOpc == 1
        conOut("Mesa disponivel: " + cMesaEscolhida)
    ELSEIF AScan(SELF:mesa,{|x| lRet := IIF(x[1] == cMesaEscolhida, x[2],.F.) }) .AND. nOpc == 2
        conOut("Mesa disponivel: " + cMesaEscolhida)
        SELF:mesa[AScan(SELF:mesa,{|x| x[1] == cMesaEscolhida})][2] := .F.
    ENDIF
RETURN lRet 

/*
Classe do Cardapio
    Propriedade:
        Ingredientes
        Acompanhamento

    Method:
        Ingredientes do Prato  
        Acompanhamento do Prato

*/

