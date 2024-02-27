#INCLUDE "totvs.ch"
#INCLUDE "fwmvcdef.ch"

#DEFINE NOME_RESUMIDO_ROTINA "Cadastro de Processos"
#DEFINE NOME_COMPLETO_ROTINA "Cadastro de Processos da Integração Protheus x Paradigma"

/* @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ *
Data   : 02/01/2024
Autor  : Leandro Nunes
Tipo   : Específico
Param. : Nenhum 
Retorno: Nenhum
Descr. : Rotina MVC para tratamento do cadastro de Processos da integração Protheus x Paradigma
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ */

User Function frpa074()

    Local aArea    := GetArea() As Array
    Local oBrowZ0M := Nil As Object

    oBrowZ0M := FwmBrowse():New()
    oBrowZ0M:SetAlias("Z0M")
    oBrowZ0M:SetDescription(NOME_COMPLETO_ROTINA)
    oBrowZ0M:DisableDetails()
    oBrowZ0M:AddLegend("Z0M->Z0M_MSBLQL  <> '1'", "GREEN", "Ativo")
    oBrowZ0M:AddLegend("Z0M->Z0M_MSBLQL  == '1'", "RED",   "Inativo")
    oBrowZ0M:Activate()

    Restarea(aArea)

Return() 

/* @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ *
Data   : 02/01/2024
Autor  : Leandro Nunes
Tipo   : Específico
Param. : Nenhum 
Retorno: aRotina, Array, Array com: titulo + acao + operacao + nivel de acesso da operaçao/rotina/programa
Descr. : Tela Modelo 1 em MVC (Tabela Z0M) - MenuDef
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ */

Static Function MenuDef() As Array

    Local aRotina := {} As Array

    aRotina := { ;
        {"Visualizar", "FwExecView('Visualizar', 'ViewDef.frpa074', " + Str(MODEL_OPERATION_VIEW)   + ")", 0, 2, 0, Nil}, ;
		{"Incluir",    "FwExecView('Incluir',    'ViewDef.frpa074', " + Str(MODEL_OPERATION_INSERT) + ")", 0, 3, 0, Nil}, ;
		{"Alterar",    "FwExecView('Alterar',    'ViewDef.frpa074', " + Str(MODEL_OPERATION_UPDATE) + ")", 0, 4, 0, Nil}, ;
		{"Excluir",    "FwExecView('Excluir',    'ViewDef.frpa074', " + Str(MODEL_OPERATION_DELETE) + ")", 0, 5, 0, Nil}, ;
        {"Legenda",    "u_LegZ0M", 0, 7, 0, Nil}}

Return(aRotina)

/* @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ *
Data   : 02/01/2024
Autor  : Leandro Nunes
Tipo   : Específico
Param. : Nenhum 
Retorno: oModel, Objeto, Objeto da funcao MVC - Modelo de Dados
Descr. : Tela Modelo 1 em MVC (Tabela Z0M) - ModelDef
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ */

Static Function ModelDef() As Object

    Local oModelZ0M  := Nil As Object
    Local oStructZ0M := FwFormStruct(1, "Z0M") As Object   

    oModelZ0M := MPFormModel():New("MVCZ0M")
    oModelZ0M:AddFields("FORMZ0M",, oStructZ0M)
    oModelZ0M:SetPrimaryKey({"Z0M_FILIAL", "Z0M_IDPROC"})
    oModelZ0M:SetDescription("Modelo do " + NOME_RESUMIDO_ROTINA)
    oModelZ0M:GetModel("FORMZ0M"):SetDescription("Formulário do " + NOME_RESUMIDO_ROTINA)

Return(oModelZ0M)

/* @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ *
Data   : 02/01/2024
Autor  : Leandro Nunes
Tipo   : Específico
Param. : Nenhum 
Retorno: oView, Objeto, Objeto da funcao MVC - Modelo de Visualizacao
Descr. : Tela Modelo 1 em MVC (Tabela Z0M) - ViewDef
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ */

Static Function ViewDef() As Object

    Local oView      := Nil As Object
    Local oModel     := FwLoadModel("frpa074") As Object  
    Local oStructZ0M := FWFormStruct(2, "Z0M") As Object 

    oView := FwFormView():New()
    oView:SetModel(oModel)
    oView:Addfield("VIEWZ0M", oStructZ0M, "FORMZ0M")
    oView:CreateHorizontalBox("TELAZ0M", 100)
    oView:EnableTitleView("VIEWZ0M", NOME_RESUMIDO_ROTINA)
    oView:SetCloseOn({|| .T.})
    oView:SetOwnerView("VIEWZ0M", "TELAZ0M")

Return(oView)

/* @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ *
Data   : 02/01/2024
Autor  : Leandro Nunes
Tipo   : Específico
Param. : Nenhum 
Retorno: aRotina, Array, Array com: cor + status/descricao da legenda
Descr. : Tela Modelo 1 em MVC (Tabela Z0M) - Legenda MVC
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ */

User Function LegZ0M() As Array

    Local aLegZ0M   := {}

    aAdd(aLegZ0M,{"BR_VERDE",   "Ativo"})
    aAdd(aLegZ0M,{"BR_VERMELHO", "Inativo"})

    BrwLegenda(CRLF + CRLF + "Situação dos Processos de Integração", "Status dos Processos (Ativo/Inativo)", aLegZ0M)

Return(aLegZ0M)

/*/{Protheus.doc} f0740001_VerificarProcessoAtivo
Verificar se processo está ativo ou bloqueado
@type function
@author Fernando Nicolau
@since 26/01/2024
@param cIdProc, character, Id do Processo
@return logical, Retorna se o processo está ativo ou bloqueado
/*/
User Function f0740001_VerificarProcessoAtivo(cIdProc As Character) As Logical

    Local aArea  := GetArea() As Array
    Local lRet   := .F. As Logical
    Local cQuery := "" As Character
    Local cTab   := "" As Character

    cQuery := " SELECT Z0M_MSBLQL "
	cQuery += "   FROM " + RetSqlName("Z0M")
	cQuery += " WHERE D_E_L_E_T_ = ' ' "
	cQuery += "   AND Z0M_IDPROC = '" + cIdProc +"' "
	cQuery += "   AND Z0M_FILIAL = '" + xFilial("Z0M") +"' "

    cTab := MPSysOpenQuery(ChangeQuery(cQuery))

    If !(cTab)->(EoF())

        lRet := (cTab)->Z0M_MSBLQL != "1"

    EndIf

    If Select(cTab) <> 0
        (cTab)->(dbCloseArea())
    EndIf

    Restarea(aArea)

Return(lRet)

