#INCLUDE "totvs.ch"

/*/{Protheus.doc} frpa072
Novo integrador
@type function
@author Leandro Nunes
@since 04/12/2023
/*/
User Function frpa073()

    Local oFnt12  := TFont():New("Tahoma",, 12,, .f.,,,,, .F., .F.) As Object
    Local oFnt16  := TFont():New("Tahoma",, 16,, .f.,,,,, .F., .F.) As Object
    Local oDlInt  := Nil As Object
    Local oTrProc := Nil As Object
    Local oLbStat := Nil As Object
    Local oBmStat := Nil As Object
    Local oMnProc := Nil As Object
	Local oBrwLog := Nil As Object
	Local oGtProc := Nil As Object
	Local oGtSubP := Nil As Object
	Local oGtToke := Nil As Object
	Local oGtJson := Nil As Object
    Local oBtAtu  := Nil As Object
	Local cGtProc := Nil As Character
	Local cGtSubP := Nil As Character
	Local cGtToke := Nil As Character
	Local cGtJson := Nil As Character
	Local aDados  := {} As Array
    Local aSize   := FWGetDialogSize() As Array
	Local cUrl    := GetMv("MV_XURLPAR") As Character // "https://srm-hml2.paradigmabs.com.br/ferroport1-prj/services"
	Local cUri    := GetMv("MV_XURIPAR") As Character // "/api/v1.0/"

    oDlInt := MSDialog():New(aSize[1], aSize[2], aSize[3], aSize[4], "Integrador Ferroport - Proheus x Paradigma",,, .F.,,,,,, .T.,,, .T.)
    If u_HealthCh(cUrl, cUri)
        oBmStat := TBitmap():New(005, 005, 008, 008,, GetSrvProfString("Startpath", "") + "paradigmaon.png",  .T., oDlInt,,, .F., .T.,, "", .F.,, .T.,, .F.)
    Else
        oBmStat := TBitmap():New(005, 005, 008, 008,, GetSrvProfString("Startpath", "") + "paradigmaoff.png", .T., oDlInt,,, .F., .T.,, "", .F.,, .T.,, .F.)
    EndIf
    oLbStat := TSay():New(005, 020, {|| "Status Comunicação Paradigma"}, oDlInt,, oFnt16, .F., .F., .F., .T., CLR_BLACK, CLR_WHITE, 192, 010)
    oTrProc   := DbTree():New(020, 003, 320, 200, oDlInt, {|| },, .T.,, oFnt12, "Lista de Processos")
    MENU oMnProc POPUP
        MENUITEM "Ativar/Desativar"  ACTION Ativar(@oTrProc)
        MENUITEM "Executar Processo" ACTION CallProc(oTrProc:GetCargo(), oBrwLog:Refresh())
    ENDMENU
    oTrProc:bRClicked := {|oObject, nX, nY| oMnProc:Activate(nX - (oDlInt:nLeft + 1275), nY - (oDlInt:nTop + 133), oObject)}
    oTrProc:bLClicked := {|oObject, nX, nY| aDados := {}, aDados := AtuGrid(oTrProc:GetCargo()), oBrwLog:SetArray(aDados), oBrwLog:Refresh()}
    oTrProc:SetScroll(2, .T.)
    AtuTree(@oTrProc)

    oBtAtu := TButton():New(020, 210, "Todos", oDlInt, {|| aDados := AtuGrid(""), oBrwLog:SetArray(aDados), oBrwLog:Refresh()}, 100, 010,, oFnt12,, .T.,,,, {|| .T.},,)
    aDados := AtuGrid("")
	oBrwLog := TCBrowse():New(040, 210, 540, 180,,,, oDlInt,,,,,,, oFnt12,,,,,,, .T.,,,, .T., .T.)
	oBrwLog:SetArray(aDados)
	oBrwLog:AddColumn(TcColumn():New(" ",           {|| IIf(aDados[oBrwLog:nAt, 01] == 1, "VERDE", IIf(aDados[oBrwLog:nAt, 01] == 2, "ROSA", "VERMELHO"))}, "@BMP",,, "CENTER", 010, .T., .F.,,,, .F.,))      
	oBrwLog:AddColumn(TcColumn():New("Filial",      {|| aDados[oBrwLog:nAt, 02]}, "@!",,, "CENTER", 020, .F., .F.,,,, .F.,))      
	oBrwLog:AddColumn(TcColumn():New("Data",        {|| aDados[oBrwLog:nAt, 03]}, "@D",,, "CENTER", 030, .F., .F.,,,, .F.,))      
	oBrwLog:AddColumn(TcColumn():New("Hora",        {|| aDados[oBrwLog:nAt, 04]}, "@!",,, "CENTER", 030, .F., .F.,,,, .F.,))      
	oBrwLog:AddColumn(TcColumn():New("Usuário",     {|| aDados[oBrwLog:nAt, 05]}, "@!",,, "CENTER", 060, .F., .F.,,,, .F.,))
	oBrwLog:AddColumn(TcColumn():New("Função",      {|| aDados[oBrwLog:nAt, 06]}, "@!",,, "CENTER", 035, .F., .F.,,,, .F.,))                                   
	oBrwLog:AddColumn(TcColumn():New("Processo",    {|| aDados[oBrwLog:nAt, 11]}, "@!",,, "CENTER", 050, .F., .F.,,,, .F.,))
	oBrwLog:AddColumn(TcColumn():New("SubProcesso", {|| aDados[oBrwLog:nAt, 12]}, "@!",,, "CENTER", 030, .F., .F.,,,, .F.,))                              
	oBrwLog:AddColumn(TcColumn():New("Mensagem",    {|| aDados[oBrwLog:nAt, 09]}, "@!",,, "LEFT",   030, .F., .F.,,,, .F.,))                                   
	oBrwLog:bLDblClick := {|| cGtProc := aDados[oBrwLog:nAt, 11], ;
        cGtSubP := aDados[oBrwLog:nAt, 12], ;
        cGtToke := aDados[oBrwLog:nAt, 08], ;
        cGtJson := aDados[oBrwLog:nAt, 10], ;
        oGtProc:Refresh(), ;
        oGtSubP:Refresh(), ;
        oGtToke:Refresh(), ;
        oGtJson:Refresh() ;
    }
	oBrwLog:lUseDefaultColors := .T.
    oBrwLog:lAdjustColSize := .T.
	oBrwLog:Refresh()
                                                                                                                                                                      "
    oGtProc := TGet():New(225, 210, bSetGet(cGtProc), oDlInt, 110, 010, "@!", {|| .T.}, CLR_BLACK, CLR_WHITE, oFnt12,,, .T.,,, {|| .T.},,,, .T., .F.,, cGtProc,,,, .F., .F.,, "Nome do Processo",     1, oFnt12, CLR_BLACK, "", .T., .F.)
    oGtSubP := TGet():New(255, 210, bSetGet(cGtSubP), oDlInt, 110, 010, "@!", {|| .T.}, CLR_BLACK, CLR_WHITE, oFnt12,,, .T.,,, {|| .T.},,,, .T., .F.,, cGtSubP,,,, .F., .F.,, "Nome do Sub-Processo", 1, oFnt12, CLR_BLACK, "", .T., .F.)
    oGtToke := TGet():New(285, 210, bSetGet(cGtToke), oDlInt, 110, 010, "@!", {|| .T.}, CLR_BLACK, CLR_WHITE, oFnt12,,, .T.,,, {|| .T.},,,, .T., .F.,, cGtToke,,,, .F., .F.,, "Token da Operação",    1, oFnt12, CLR_BLACK, "", .T., .F.)
    oGtJson := TMultiGet():New(225, 335, bSetGet(cGtJson), oDlInt, 400, 100, oFnt12,,,,, .T.,,, {|| .T.},,, .T., {|| .T.}, ,, .F., .T., "Json da Operação", 1, oFnt12, CLR_BLACK)
    oDlInt:Activate(,,, .T.)

Return()

Static Function AtuTree(oTree As Object)

    Local cSql    := "" As Character
    Local cDescri := "" As Character
    Local cCargo  := "" As Character
    Local cImg    := "" As Character
    Local cPai    := "" As Character

    cSql := "SELECT " + CRLF 
    cSql += "	Z0M_IDPROC, " + CRLF
    cSql += "	Z0M_NOME, " + CRLF
    cSql += "	Z0M_CDSUP, " + CRLF
    cSql += "	Z0M_MSBLQL " + CRLF
    cSql += "FROM " + CRLF
    cSql += "	" + RetSqlName("Z0M") + " " + CRLF
    cSql += "WHERE " + CRLF
    cSql += "	D_E_L_E_T_ = ' ' " + CRLF
    cSql += "ORDER BY 1"
    cTab := MPSysOpenQuery(cSql)
    While !(cTab)->(Eof())
        cDescri := AllTrim((cTab)->Z0M_NOME)
        cCargo  := AllTrim((cTab)->Z0M_IDPROC)
        If (cTab)->Z0M_MSBLQL == "1"
            cImg := "CADEADO" // Processo Inativo
        Else
            cImg := "NORMAS" // Processo Ativo
        EndIf
        cPai := AllTrim((cTab)->Z0M_CDSUP)

        If cPai == ""
            oTree:AddItem(cDescri, cCargo, cImg,,,, 1)
        Else
            If oTree:TreeSeek(cPai) 
                oTree:AddItem(cDescri, cCargo, "DESTINOS",,,, 2)	
            EndIf
        EndIf

        (cTab)->(DbSkip())
	EndDo
    (cTab)->(DbCloseArea())

Return()

Static Function Ativar(oTree As Object)

    Local cProcesso := oTree:GetCargo()

    DbSelectArea("Z0M")
    DbSetOrder(1)
	If DbSeek(xFilial("Z0M") + cProcesso)
		If Z0M->Z0M_MSBLQL == "1"
			If Empty(Z0M->Z0M_CDSUP)
				oTree:ChangeBmp("NORMAS", "NORMAS",,, cProcesso)
			Else
				oTree:ChangeBmp("DESTINOS", "DESTINOS",,, cProcesso)
			EndIf
			RecLock("Z0M", .F.)
			Z0M->Z0M_MSBLQL := "2"
			Z0M->(MsUnlock())
		Else
			If Empty(Z0M->Z0M_CDSUP)
				oTree:ChangeBmp("CADEADO", "CADEADO",,, cProcesso)
			Else
				oTree:ChangeBmp("CADEADO", "CADEADO",,, cProcesso)
			EndIf
			RecLock("Z0M", .F.)
			Z0M->Z0M_MSBLQL := "1"
			Z0M->(MsUnlock())
		EndIf
	EndIf
    oTree:Refresh()

Return()

Static Function CallProc(cRotina As Character, cSbRotina As Character)

    Local bFun := {|| }

    Default cRotina := ""
    Default cSbRotina := ""

    bFun := { || &("u_frpa071('" + cRotina + "','" + cSbRotina + "')")}
    MsgRun("Processando Integração...", "Aguarde", bFun)

Return(Alert(cRotina))

Static Function AtuGrid(cProcesso As Character) As Array

    Local aResult := {} As Array
	Local cSql    := "" As Character
    Local cAlZPL  := "" As Character

	cSql := "SELECT " + CRLF
	cSql += "    ZPL_RETORN, " + CRLF
	cSql += "	 ZPL_FILIAL, " + CRLF
	cSql += "	 ZPL_DATA, " + CRLF
	cSql += "	 ZPL_HORA, " + CRLF
	cSql += "	 ZPL_USUARI, " + CRLF
	cSql += "	 ZPL_FUNCAO, " + CRLF
	cSql += "	 ZPL_ORIGEM, " + CRLF
	cSql += "	 ZPL_TOKEN, " + CRLF
	cSql += "	 ZPL_MSGLOG, " + CRLF
	cSql += "    ISNULL(CAST(CAST(ZPL_JSON AS VARBINARY(8000)) AS VARCHAR(8000)),'') AS ZPL_JSON, " + CRLF 
	cSql += "	 ZPL_PROCES, " + CRLF
	cSql += "	 ZPL_SUBPRO " + CRLF
	cSql += "FROM " + CRLF
	cSql += "    " + RetSqlName("ZPL") + " " + CRLF
	cSql += "WHERE " + CRLF
	cSql += "    ZPL_NEWINT = 'S' AND " + CRLF
    If cProcesso <> "" 
        If SubStr(cProcesso, 4, 3) == "000"
            cSql += "    ZPL_IDPROC = '" + SubStr(cProcesso, 1, 3) + "' AND " + CRLF
        Else
            cSql += "    ZPL_IDPROC = '" + SubStr(cProcesso, 1, 3) + "' AND " + CRLF
            cSql += "    ZPL_IDSBPR = '" + SubStr(cProcesso, 4, 3) + "' AND " + CRLF
        EndIf
    EndIf
	cSql += "	D_E_L_E_T_ = ' '"
    cAlZPL := MPSysOpenQuery(cSql)
    While !(cAlZPL)->(Eof())
        aAdd(aResult, ;
            {(cAlZPL)->ZPL_RETORN, ;  // Indicador de Sucesso (1), Erro (0) ou Correção (2)
            (cAlZPL)->ZPL_FILIAL, ; // Filial
            StoD((cAlZPL)->ZPL_DATA), ;    // Data do Log
            (cAlZPL)->ZPL_HORA, ;    // Hora do Log
            (cAlZPL)->ZPL_USUARI, ;  // Nome do Usuário executor
            (cAlZPL)->ZPL_FUNCAO, ;  // Nome da rotina executada
            (cAlZPL)->ZPL_ORIGEM, ;  // Descreve o Tipo de Erro: E - Estrutura ou 
            (cAlZPL)->ZPL_TOKEN, ;   // Token da operação
            (cAlZPL)->ZPL_MSGLOG, ;  // Mensagem de Retorno do processo
            (cAlZPL)->ZPL_JSON, ;    // Json da Operação
            (cAlZPL)->ZPL_PROCES, ;  // Id do Processo
            (cAlZPL)->ZPL_SUBPRO ;    // Id do SubProcesso
        })

        (cAlZPL)->(DbSkip())
    EndDo
    (cAlZPL)->(DbCloseArea())

Return(aResult)
