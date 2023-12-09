#Include "PROTHEUS.CH"
#Include "PARMTYPE.CH"
#Include "FWMVCDEF.CH"
#Include "TOPCONN.CH"

/*/{Protheus.doc} nCancel2
//VerIfica cancelamentos de SC via o portal paradigma
@author Administrator
@since 02/05/2018
@version 1.0
@param oProcess, object, objeto tNewProccess
@type function
/*/

/**********************************************************************************\
|PE001 - ponto de entrada na eliminação de resíduo.
\**********************************************************************************/
user Function WsCancel2()

    //Local oLog  := FwParLog():New("PAR001", "RetornarPedidoAtualizadoNoPortal")

		//Dados da configuração de Proxy no Configurador
	Local lProxy     := ( FWSFPolice("COMUNICATION", "USR_PROXY") == "T" )
	Local cPrxServer := Alltrim( FWSFPolice("COMUNICATION", "USR_PROXYIP") )
	Local nPrxPort   := Val( FWSFPolice("COMUNICATION", "USR_PROXYPORT") )
	Local cPrxUser   := Alltrim( FWSFPolice("COMUNICATION", "USR_PROXYLOGON") )
	Local lAuto 	 := .t.
	Local oWsdl
	Local xRet
    Local lRet
	Local cErro 	:= ""
	Local cAviso 	:= ""
	Local aOps 		:= {}
	Local Oobj       
    Local cFilImPa  := ''
    Local cFilAux   := cFilAnt
    Local nY:=1
    Local nTamVet:=1
    Local oRet
    Local cLenCntr := 0
    Local nX := 0
	Local cURL 		:= ''
    Local cAtua     :=''
	Private Cped	:= ''
    Private cItem    := ''

    conout("INICIO cancelamento itens pedido")

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
		//Return "Erro: " + oWsdl:cError
	endif

	aOps := oWsdl:ListOperations()

	// Define a operação
	xRet := oWsdl:SetOperation( "RetornarPedidoAtualizadoNoPortal" )
	if xRet == .F.
		//Return "Não foi possivel executar a operacao RetornarRequisicaoAlteracaoComprador"
	endif

    If ExistBlock("WBCZ20")//Ponto de entrada do token.
        xRet := ExecBlock("WBCZ20",.F.,.F.,{oWsdl,"1"})
        if xRet == .F.
            Return
        endif
    EndIf

	if(TYPE('cSOAPmgs') == 'C')
		cSOAPmgs := oWsdl:GetSoapMsg()
	EndIf

	// Envia a mensagem SOAP ao servidor
	xRet := oWsdl:SendSoapMsg()
	if !xRet
		MsgStop( oWsdl:cError , "SendSoapMsg() ERROR")
		//Return xRet := {oWsdl::cFaultCode, oWsdl:cError}
	endif

	// Pega a mensagem de resposta
	xRet := oWsdl:GetSoapResponse()
	if(TYPE('cSOAPret') == 'C')
		cSOAPret := xRet
	EndIf

	if(Empty(GetSimples( xRet, '<a:PedidoDTO', '</a:PedidoDTO>' )))

	elseif(!Empty(oWsdl:cError) .OR. !Empty(GetSimples( xRet, '<faultcode', '</faultcode>' )))
        //xRet := {oWsdl:cFaultCode, oWsdl:cError, xRet}
        xRet:=GetSimples( xRet, '<faultcode', '</faultcode>' )
        RecLock("ZPL", .T.)
			ZPL->ZPL_DATA   :=date()
			ZPL->ZPL_HORA   := Time()
			ZPL->ZPL_TOKEN  := ''
			ZPL->ZPL_FILIAL := xFilial('ZPL') //xFilial(cTabela)
			ZPL->ZPL_USUARI := 'Schedule'
			ZPL->ZPL_ROTINA := 'Par001'
			ZPL->ZPL_FUNCAO := 'RetornarPedidoAtualizadoNoPortal'
			ZPL->ZPL_ORIGEM := ""
			ZPL->ZPL_MSGLOG := If(ValType(xRet)=='C',xRet,"Erro no xml montado.")
			ZPL->ZPL_MSGWSF := If(ValType(xRet)=='C',xRet,"Erro no xml montado.")
			ZPL->ZPL_TSTAMP := GetTimeStamp(DATE())
			ZPL->ZPL_RETORN := 0
            ZPL->ZPL_XML    := xRet
        MsUnlock() 
	Else
        conout('retorno xml cancelamento item: '+xRet)
        oXmlDoc := XmlParser( xRet, "_", @cErro, @cAviso )

        Oobj :=  oXmlDoc:_S_ENVELOPE:_S_BODY:_RetornarPedidoAtualizadoNoPortalResponse:_RetornarPedidoAtualizadoNoPortalResult:_A_PEDIDODTO
        
        If ValType(Oobj) == "A"
            cLenCntr := Len(Oobj)
        Else
            cLenCntr := 1
        EndIf

        For nx := 1  to cLenCntr
            
            If cLenCntr > 1
                Oobj :=  oXmlDoc:_S_ENVELOPE:_S_BODY:_RetornarPedidoAtualizadoNoPortalResponse:_RetornarPedidoAtualizadoNoPortalResult:_A_PEDIDODTO[nX]
            Else
                Oobj :=  oXmlDoc:_S_ENVELOPE:_S_BODY:_RetornarPedidoAtualizadoNoPortalResponse:_RetornarPedidoAtualizadoNoPortalResult:_A_PEDIDODTO
            EndIf

            If ValType(Oobj:_A_LSTPEDIDOITEM:_A_PEDIDOITEMDTO)=="A"
                nTamVet    := Len(Oobj:_A_LSTPEDIDOITEM:_A_PEDIDOITEMDTO)
            Else
                nTamVet    := 1
            EndIf
                
            For nY:=1 to nTamVet

                If nTamVet > 1
                    oRet :=  Oobj:_A_LSTPEDIDOITEM:_A_PEDIDOITEMDTO[nY]
                Else
                    oRet :=  Oobj:_A_LSTPEDIDOITEM:_A_PEDIDOITEMDTO
                EndIf

                cItem    := oRet:_A_SCDITEMEMPRESA:TEXT

                Cped     := Oobj:_A_SCDPEDIDOERP:TEXT 
                cFilImPa := cFilGet(Oobj:_A_SCDCOMPRADOR:TEXT)

                If ExistBlock("WBCZ101")==.T.
                    ExecBlock("WBCZ101",.F.,.F.,{Oobj:_A_SCDCOMPRADOR:TEXT,Oobj,99})
                EndIf

                cFilAnt  := cFilImPa

                IF oRet:_A_NCDSITUACAO:TEXT == '4'
                    lRet:=MATA235(lAuto)
                    conout("cancelamento itens pedido: "+Cped+' Item :'+cItem)

                    DbSelectArea('SC7')
                        DbSetOrder(1)
                        If ValType(lRet)<>"L"
                            lRet:=.F.
                        EndIf
                        IF DbSeek(cFilImPa+Cped+cItem) .And. lRet==.T.
                            
                            RecLock("ZPL", .T.)
                                        ZPL->ZPL_DATA   :=date()
                                        ZPL->ZPL_HORA   := Time()
                                        ZPL->ZPL_TOKEN  := Cped
                                        ZPL->ZPL_FILIAL := xFilial('ZPL') //xFilial(cTabela)
                                        ZPL->ZPL_USUARI := 'Schedule'
                                        ZPL->ZPL_ROTINA := 'Par001'
                                        ZPL->ZPL_FUNCAO := 'RetornarPedidoAtualizadoNoPortal'
                                        ZPL->ZPL_ORIGEM := ""
                                        ZPL->ZPL_MSGLOG := 'Item eliminado por residuo '+ Cped + ' Item ' + cItem + ' Filial ' + cFilImPa
                                        ZPL->ZPL_MSGWSF := 'Item eliminado por residuo '+ Cped + ' Item ' + cItem + ' Filial ' + cFilImPa
                                        ZPL->ZPL_TSTAMP := GetTimeStamp(DATE())
                                        ZPL->ZPL_RETORN := 1
                                        ZPL->ZPL_XML    := xRet
                            MsUnlock()

                            If ExistBlock("ElResPE1")//PE001 - ponto de entrada na eliminação de resíduo.
                                U_ElResPE1(Cped,cItem)
                            EndIf
                        Else

                            RecLock("ZPL", .T.)
                                        ZPL->ZPL_DATA   :=date()
                                        ZPL->ZPL_HORA   := Time()
                                        ZPL->ZPL_TOKEN  := Cped
                                        ZPL->ZPL_FILIAL := xFilial('ZPL') //xFilial(cTabela)
                                        ZPL->ZPL_USUARI := 'Schedule'
                                        ZPL->ZPL_ROTINA := 'Par001'
                                        ZPL->ZPL_FUNCAO := 'RetornarPedidoAtualizadoNoPortal'
                                        ZPL->ZPL_ORIGEM := ""
                                        ZPL->ZPL_MSGLOG := 'Pedido não encontrado ou não pode ser eliminado, '+ Cped + ' Item ' + cItem + ' Filial ' + cFilImPa
                                        ZPL->ZPL_MSGWSF := 'Pedido não encontrado ou não pode ser eliminado, '+ Cped + ' Item ' + cItem + ' Filial ' + cFilImPa+ '. Verificar a requisição'
                                        ZPL->ZPL_TSTAMP := GetTimeStamp(DATE())
                                        ZPL->ZPL_RETORN := 0
                                        ZPL->ZPL_XML    := xRet
                            MsUnlock()

                        EndIF

                Else

                    Cped     := Oobj:_A_SCDPEDIDOERP:TEXT 
                    cItem    := oRet:_A_SCDITEMEMPRESA:TEXT

                    If ValType(oRet:_A_LSTPEDIDOITEMENTREGA:_A_PEDIDOITEMENTREGADTO) == 'A'
                        dDtEntrga:= oRet:_A_LSTPEDIDOITEMENTREGA:_A_PEDIDOITEMENTREGADTO[1]:_A_tDtEntregaConfirmada:TEXT
                        cAtua:= oRet:_A_LSTPEDIDOITEMENTREGA:_A_PEDIDOITEMENTREGADTO[1]:_A_bFlAtualizado:TEXT
                    else
                        dDtEntrga:= oRet:_A_LSTPEDIDOITEMENTREGA:_A_PEDIDOITEMENTREGADTO:_A_tDtEntregaConfirmada:TEXT
                        cAtua:= oRet:_A_LSTPEDIDOITEMENTREGA:_A_PEDIDOITEMENTREGADTO:_A_bFlAtualizado:TEXT
                    EndIf
                    dDtEntrga:=  CToD(SubStr(dDtEntrga,9,2) + "/" + SubStr(dDtEntrga,6,2) + "/" + SubStr(dDtEntrga,1,4))

                    DbSelectArea('SC7')
                    DbSetOrder(1)
                    IF DbSeek(cFilImPa+Cped+cItem) .AND. AllTrim(cAtua)=="1"
                        RecLock("SC7", .f.)
                            SC7->C7_DATPRF  := dDtEntrga
                        MsUnlock() 

                        RecLock("ZPL", .T.)
                                ZPL->ZPL_DATA   :=date()
                                ZPL->ZPL_HORA   := Time()
                                ZPL->ZPL_TOKEN  := Cped
                                ZPL->ZPL_FILIAL := xFilial('ZPL') //xFilial(cTabela)
                                ZPL->ZPL_USUARI := 'Schedule'
                                ZPL->ZPL_ROTINA := 'Par001'
                                ZPL->ZPL_FUNCAO := 'DataEntregaAlterada'
                                ZPL->ZPL_ORIGEM := ""
                                ZPL->ZPL_MSGLOG := 'Data de entrega alterada no pedido '+ Cped + ' Item ' + cItem + ' Filial ' + cFilImPa
                                ZPL->ZPL_MSGWSF := 'Data de entrega alterada no pedido '+ Cped + ' Item ' + cItem + ' Filial ' + cFilImPa
                                ZPL->ZPL_TSTAMP := GetTimeStamp(DATE())
                                ZPL->ZPL_RETORN := 1
                                ZPL->ZPL_XML    := xRet
                        MsUnlock()  
                        
                    Else

                        RecLock("ZPL", .T.)
                                ZPL->ZPL_DATA   :=date()
                                ZPL->ZPL_HORA   := Time()
                                ZPL->ZPL_TOKEN  := Cped
                                ZPL->ZPL_FILIAL := xFilial('ZPL') //xFilial(cTabela)
                                ZPL->ZPL_USUARI := 'Schedule'
                                ZPL->ZPL_ROTINA := 'Par001'
                                ZPL->ZPL_FUNCAO := 'DataEntregaAlterada'
                                ZPL->ZPL_ORIGEM := ""
                                ZPL->ZPL_MSGLOG := 'Pedido não encontrado '+ Cped + ' Item ' + cItem + ' Filial ' + cFilImPa + ' ou data igual a 01/01/2001, data alteracao: '+dtoc(dDtEntrga)
                                ZPL->ZPL_MSGWSF := 'Pedido não encontrado '+ Cped + ' Item ' + cItem + ' Filial ' + cFilImPa + ' ou data igual a 01/01/2001, data alteracao: '+dtoc(dDtEntrga)
                                ZPL->ZPL_TSTAMP := GetTimeStamp(DATE())
                                ZPL->ZPL_RETORN := 0
                                ZPL->ZPL_XML    := xRet
                        MsUnlock()

                    EndIF
                Endif 
            Next nY
		next nx
	EndIf
    cFilAnt := cFilAux

    conout("FIM cancelamento itens pedido")

Return 

//Pega a filial do usuário apartir do cnpj

static function cFilGet(xcnpj)

	Local aList := FWLoadSM0()
	Local xFil := ''
	Local x

	For  x:=1 to len(aList)

		IF aList[x][18] == xcnpj

			xFil:= aList[x][2]
			Return xFil

		Endif

	next x

Return xFil
