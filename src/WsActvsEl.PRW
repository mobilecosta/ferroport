#INCLUDE "protheus.ch"

User Function WsActvsEl()
	//Dados da configuração de Proxy no Configurador

	Local lProxy     := ( FWSFPolice("COMUNICATION", "USR_PROXY") == "T" )
	Local cPrxServer := Alltrim( FWSFPolice("COMUNICATION", "USR_PROXYIP") )
	Local nPrxPort   := Val( FWSFPolice("COMUNICATION", "USR_PROXYPORT") )
	Local cPrxUser   := Alltrim( FWSFPolice("COMUNICATION", "USR_PROXYLOGON") )
	Local lAuto 	 := .t.
	Local oWsdl
	Local oRedXml
	Local xRet:=""
	Local cErro 	:= ""
	Local cAviso 	:= ""
	Local aOps 		:= {}
	//Local aComplex 	:= {}
	//Local aSimple 	:= {}
	Local cAccSRV 
	Local cAux		:= ''
	Local cfilempr  := ''
	Local cLenitem  := 0
	Local nX
	Local lret
	//Local cURL 		:= cAccSRV + "/Services/Pedido.svc?wsdl"


	Local cURL 
	Private nPed	:= ''

	if ValType("cFilAnt") == "C" .and. TCIsConnected() // se ja tem ambiente aberto
        ConOut("Ambiente Protheus aberto e pronto para uso")
    else
        RpcSetEnv("11","02") //Abro o ambiente, pois o mesmo não encontrava-se aberto
    endif

	cfilempr	:= cFilant

	cAccSRV 	:= AllTrim(GetMv("MV_ACCSERV "))
	cURL 		:= AllTrim(GetMv("MV_XPARURL"))+'/services/Pedido.svc?wsdl'
	
	// Cria o objeto da classe TWsdlManager
	oWsdl := TWsdlManager():New()
	oWsdl:AddHttpHeader("Authorization", "Bearer " + U_NewToken())

	//Define as propriedades para tratar os prefixos NS das tags do XML e para remover as tags vazias
	oWsdl:lUseNSPrefix := .T.
	oWsdl:lRemEmptyTags := .T.
	//define que irá remover os tipos complexos que foram definidos com 0 no método SetComplexOccurs
	oWsdl:lProcResp 	:= .F.

	If lProxy
		oWsdl:SetProxy(cPrxServer, nPrxPort)
		oWsdl:SetCredentials(cPrxUser, cPrxPass)
	EndIf

	//Verificação SSL
	
	If "https:" $ cUrl
		oWsdl:cSSLCACertFile := "\certs\sslCaCert.cer"
		oWsdl:cSSLCertFile 	 := "\certs\sslCert.crt"
		oWsdl:cSSLKeyFile    := "\certs\sslKeyCert.key"
		oWsdl:lSSLInsecure   := .T.
	EndIf
	
	// Faz o parse de uma URL
	xRet := oWsdl:ParseURL( cURL )
	if xRet == .F.
		Return "Erro: " + oWsdl:cError
	endif

	aOps := oWsdl:ListOperations()

	if Len( aOps ) == 0
		Return "Não existem operações"
	endif

	// Define a operação
	xRet := oWsdl:SetOperation( "RetornarPedidoCancelamento" )
	if xRet == .F.
		Return "Não foi possivel executar a operacao RetornarPedidoCancelamento"
	endif

	if(TYPE('cSOAPmgs') == 'C')
		cSOAPmgs := oWsdl:GetSoapMsg()
	EndIf

	// Envia a mensagem SOAP ao servidor
	xRet := oWsdl:SendSoapMsg()
	if !xRet
		MsgStop( oWsdl:cError , "SendSoapMsg() ERROR")
		Return xRet := {oWsdl::cFaultCode, oWsdl:cError}
	endif

	// Pega a mensagem de resposta
	xRet := oWsdl:GetSoapResponse()
	if(TYPE('cSOAPret') == 'C')
		cSOAPret := xRet
	EndIf

	if(Empty(GetSimples( xRet, '<a:PedidoAtualizarDTO', '</a:PedidoAtualizarDTO>' )))
		xRet := 'Nao existem cancelamentos de Pedidos a processar'
		Return xRet
	elseif(!Empty(oWsdl:cError) .OR. !Empty(GetSimples( xRet, '<faultcode', '</faultcode>' )))
		xRet := {oWsdl:cFaultCode, oWsdl:cError, xRet}

	Else
		oXmlDoc := XmlParser( xRet, "_", @cErro, @cAviso )

		If ValType( OXMLDOC:_S_ENVELOPE:_S_BODY:_RETORNARPEDIDOCANCELAMENTORESPONSE:_RETORNARPEDIDOCANCELAMENTORESULT:_A_PEDIDOATUALIZARDTO) == "A"
            cLenItem := Len(OXMLDOC:_S_ENVELOPE:_S_BODY:_RETORNARPEDIDOCANCELAMENTORESPONSE:_RETORNARPEDIDOCANCELAMENTORESULT:_A_PEDIDOATUALIZARDTO)
        Else
            cLenItem := 1
        EndIf

		For nX := 1 to cLenitem
			If ValType( OXMLDOC:_S_ENVELOPE:_S_BODY:_RETORNARPEDIDOCANCELAMENTORESPONSE:_RETORNARPEDIDOCANCELAMENTORESULT:_A_PEDIDOATUALIZARDTO) == "A"
				oRedXml := OXMLDOC:_S_ENVELOPE:_S_BODY:_RETORNARPEDIDOCANCELAMENTORESPONSE:_RETORNARPEDIDOCANCELAMENTORESULT:_A_PEDIDOATUALIZARDTO[nX]
			Else
				oRedXml := OXMLDOC:_S_ENVELOPE:_S_BODY:_RETORNARPEDIDOCANCELAMENTORESPONSE:_RETORNARPEDIDOCANCELAMENTORESULT:_A_PEDIDOATUALIZARDTO
			EndIf

			cAUX 	:= oRedXml:_A_sCdComprador:TEXT 
			nPed := oRedXml:_A_SCDPEDIDOERP:TEXT

			cFilAnt     := alltrim(GETFIL(cAUX))

			lret:=MATA235(lAuto)

			DbSelectArea('SC7')
            DbSetOrder(1)
            IF DbSeek(xfilial("SC7")+nPed)
				If lret == .T.
					RecLock("ZPL", .T.)
						ZPL->ZPL_DATA   :=date()
						ZPL->ZPL_HORA   := Time()
						ZPL->ZPL_TOKEN  := nPed
						ZPL->ZPL_FILIAL := cFilAnt
						ZPL->ZPL_USUARI := 'Schedule'
						ZPL->ZPL_ROTINA := 'WSACTVSEL'
						ZPL->ZPL_FUNCAO := 'RetornarPedidoCancelamento'
						ZPL->ZPL_ORIGEM := "WSACTVSEL"
						ZPL->ZPL_MSGLOG := "Pedido cancelado via portal.. Pedido: "+nPed
						ZPL->ZPL_MSGWSF := "Pedido cancelado via portal.. Pedido: "+nPed
						ZPL->ZPL_TSTAMP := GetTimeStamp(DATE())
						ZPL->ZPL_RETORN := 1
						ZPL->ZPL_XML    := xRet
					MsUnlock()
				Else
					RecLock("ZPL", .T.)
						ZPL->ZPL_DATA   :=date()
						ZPL->ZPL_HORA   := Time()
						ZPL->ZPL_TOKEN  := nPed
						ZPL->ZPL_FILIAL := cFilAnt
						ZPL->ZPL_USUARI := 'Schedule'
						ZPL->ZPL_ROTINA := 'WSACTVSEL'
						ZPL->ZPL_FUNCAO := 'RetornarPedidoCancelamento'
						ZPL->ZPL_ORIGEM := "WSACTVSEL"
						ZPL->ZPL_MSGLOG := "Pedido não cancelado via portal.. verificar o Pedido: "+nPed
						ZPL->ZPL_MSGWSF := "Pedido não cancelado via portal.. verificar o Pedido: "+nPed
						ZPL->ZPL_TSTAMP := GetTimeStamp(DATE())
						ZPL->ZPL_RETORN := 0
						ZPL->ZPL_XML    := xRet
					MsUnlock()
				EndIf
			Else
				RecLock("ZPL", .T.)
					ZPL->ZPL_DATA   :=date()
					ZPL->ZPL_HORA   := Time()
					ZPL->ZPL_TOKEN  := nPed
					ZPL->ZPL_FILIAL := cFilAnt
					ZPL->ZPL_USUARI := 'Schedule'
					ZPL->ZPL_ROTINA := 'WSACTVSEL'
					ZPL->ZPL_FUNCAO := 'RetornarPedidoCancelamento'
					ZPL->ZPL_ORIGEM := "WSACTVSEL"
					ZPL->ZPL_MSGLOG := "Pedido cancelado via portal.. Pedido: "+nPed
					ZPL->ZPL_MSGWSF := "Pedido cancelado via portal.. Pedido: "+nPed
					ZPL->ZPL_TSTAMP := GetTimeStamp(DATE())
					ZPL->ZPL_RETORN := 0
					ZPL->ZPL_XML    := xRet
				MsUnlock()
			EndIf

		Next nX

		If oXmlDoc <> Nil
			xRet := oXmlDoc
		Else
			//³Retorna falha no parser do XML³
			xRet := "RetornarPedidoCancelamento: Falha ao interpretar xml de retorno"
		EndIf
	EndIf

	cFilAnt := cfilempr

Return xRet



/*================================================================================================================*\
|| ############################################################################################################## ||
|| # Static Function: GETFIL                                                                                    # ||
|| # Desc: Retorna a filial da empresa a partir de seu CNPJ.                                                    # ||
|| ############################################################################################################## ||
\*================================================================================================================*/
Static Function GETFIL(cCNPJ)
    Local cAlias := GetNextAlias()
    Local cQuery := ""
    Local cRet := ""

    cQuery += "SELECT SM0.M0_CODFIL FROM " + RetSqlName("SM0") + " SM0"
    //cQuery += " WHERE SM0.M0_CODIGO = '01'"
    cQuery += " WHERE SM0.M0_CGC = '" + cCNPJ + "'"
    cQuery += " AND SM0.D_E_L_E_T_ <> '*'"
    cQuery := ChangeQuery(cQuery)
    
    DbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),cAlias,.F.,.T.)
	(cAlias)->(DbGotop())

    While (cAlias)->(!EoF())
        cRet := (cAlias)->M0_CODFIL
    	(cAlias)->(DbSkip())
	EndDo
Return cRet
