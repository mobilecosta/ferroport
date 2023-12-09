#Include "PROTHEUS.CH"
#Include "PARMTYPE.CH"
#Include "FWMVCDEF.CH"
#Include "TOPCONN.CH"

//PRIVATE lMsErroAuto := .F.

/*================================================================================================================*\
|| ############################################################################################################## ||
||																	 											  ||
|| # Programa: WsActvs 																							# ||
|| # Desc: Rotina que faz a integração de pedidos do portal paradigma                                           # ||
||					******* SOLICITAÇÂO DE COMPRAS *********     												  ||
|| # Tabelas Usadas: SE2, SED, SM0                                                                              # ||
||																												  ||
|| # Data - 24/05/2020 																							# ||
||																												  ||
|| ############################################################################################################## ||
||																												  ||
|| # Alterações 								 																# ||
|| 																												  ||
|| ############################################################################################################## ||
\*================================================================================================================*/
User Function WSActvsSol()
    Local lRet    := Nil
    Local oWsdl   := Nil
    Local cXMLRet := ""
    Local cLockName := "WsActvs"


    cEmp := "99"
    cFil := "01"
   // RPCSetType(3)  //Nao consome licensas
    //RpcSetEnv(cEmp,cFil,,,,GetEnvServer(),{ }) //Abertura do ambiente em rotinas automáticas


    // Conexão com o WebService \\
    oWsdl := TWsdlManager():New()
	oWsdl:AddHttpHeader("Authorization", "Bearer " + U_NewToken())
    oWsdl:lSSLInsecure := .T.
    oWsdl:nTimeout     := 120
    oWsdl:nSSLVersion  := 0
    xRet := oWsdl:ParseURL(GetMv("MV_XPARURL") + "/services/Requisicao.svc?wsdl")
    
    If xRet == .F.
        ConOut("WsActvs - Erro ParseURL: " + oWsdl:cError)
        Return
    EndIf

    // Definição da operação \\
    lRet := oWsdl:SetOperation("RetornarRequisicaoAlteracaoComprador")
    
    If lRet == .F.
        ConOut("WsActvs - Erro SetOperation: " + oWsdl:cError)
        Return
    EndIf

    // Envia uma mensagem SOAP XML ao servidor. Retorna o erro, caso ocorra. \\
    ConOut("WsActvs - " + SendXML())
    lRet := oWsdl:SendSoapMsg(SendXML())

    If lRet == .F.
        ConOut("WsActvs - Erro SendSoapMsg: " + oWsdl:cError)
        ConOut("WsActvs - Erro SendSoapMsg FaultCode: " + oWsdl:cFaultCode)
        Return
    EndIf

    cXMLRet := oWsdl:GetSoapResponse()
    ConOut("WsActvs - " + cXMLRet)

	// Início - Semáforo de controle de execução simultânea
	If !LockByName(cLockName,.T.,.T.)
		MsgInfo("Rotina já está sendo executada por outro usuário","Atenção"+Procname())
		Return .F.
	EndIf

    ProcXML(cXMLRet)
    //ProcXML(XMLRet())

    // Fim - Semáforo de controle de execução simultânea
	UnLockByName(cLockName,.T.,.T.)

    //RpcClearEnv()   //Libera o Ambiente

Return

/*================================================================================================================*\
|| ############################################################################################################## ||
|| # Static Function: ProcXML                                                                                   # ||
|| # Desc: Processamento do XML do contrato.                                                                    # ||
|| ############################################################################################################## ||
\*================================================================================================================*/
Static Function ProcXML(cXML)
    Local oXML
    Local cReplace := "_"
    Local cErros   := ""
	Local cAvisos  := ""

    oXML := XMLParser(cXML, cReplace, @cErros, @cAvisos)

    // Execução apenas quando há contrato a ser processado \\
    //Alterado por não haver tag no XML _A_LSTOBJETORETORNO
    //If XmlChildCount(OXML:_S_ENVELOPE:_S_BODY:_RetornarRequisicaoAlteracaoCompradorResponse:_RetornarRequisicaoAlteracaoCompradorResult:_A_LSTOBJETORETORNO) > 0
    If XmlChildCount(OXML:_S_ENVELOPE:_S_BODY:_RetornarRequisicaoAlteracaoCompradorResponse:_RetornarRequisicaoAlteracaoCompradorResult) > 2
        XMLSE2(oXML, cXML)
    EndIf
Return

/*================================================================================================================*\
|| ############################################################################################################## ||
|| # Static Function: XMLSE2                                                                                    # ||
|| # Desc: Conversão do contrato em título provisório.                                                          # ||
|| ############################################################################################################## ||
\*================================================================================================================*/
Static Function XMLSE2(OXML, cXML)

    // Objetos \\
    Local OAUXCNT // Objeto auxiliar, para diminuir o tamanho do objeto original para manipulação do contrato

    // Auxiliares \
    Local cDoc    := ''
    Local cFilImPa := ''
    Local oRet
    Local cUser := ''
    Private aRatElb:= {}
    

    lMsErroAuto := .F.
    aRetItens := {}

    //oRet := OXML:_S_ENVELOPE:_S_BODY:_RetornarRequisicaoAlteracaoCompradorResponse:_RetornarRequisicaoAlteracaoCompradorResult:_A_LSTOBJETORETORNO:_A_RequisicaoCompradorAlteradoDTO
    // removi o _A_LSTOBJETORETORNO da tag por não haver no xml de retorno da paradigma
    oRet := OXML:_S_ENVELOPE:_S_BODY:_RetornarRequisicaoAlteracaoCompradorResponse:_RetornarRequisicaoAlteracaoCompradorResult:_A_RequisicaoCompradorAlteradoDTO
   
    // Verifica se tem mais de um item de solicitação ou somente uma solicitacao
    If ValType(oRet) == "A"
        aRetItens := oRet
    Else
        aAdd( aRetItens , oRet )
    EndIf
      
    OAUXCNT := aRetItens[1]
    cFilImPa  := GETFIL(getmv('MV_XMATCNP'))
    cCdSolici := OAUXCNT:_A_sCdRequisicaoEmpresa:TEXT
    cItemSol  := OAUXCNT:_A_sCdItemRequisicaoEmpresa:TEXT

    cUser := AllTrim(POSICIONE('ZUP', 2, alltrim(OAUXCNT:_A_sCdUsuarioComprador:TEXT), 'ZUP_CODUSU'))

    cFilAnt := cFilImPa

    U_FRPA062(cCdSolici,cUser)

    RecLock("ZPL", .T.)
        ZPL->ZPL_DATA   :=date()
        ZPL->ZPL_HORA   := Time()
        ZPL->ZPL_TOKEN  := cDoc
        ZPL->ZPL_FILIAL := xFilial('ZPL') //xFilial(cTabela)
        ZPL->ZPL_USUARI := 'Schedule'
        ZPL->ZPL_ROTINA := 'wsSolDte'
        ZPL->ZPL_FUNCAO := 'RetornarRequisicaoAlteracaoComprador'
        ZPL->ZPL_ORIGEM := ""
        ZPL->ZPL_MSGLOG := 'Solicitação Alterada (comprador) com sucesso, Solicitação : ' + cCdSolici + " Usuário : " + cUser
        ZPL->ZPL_MSGWSF := 'Solicitação Alterada (comprador) com sucesso, Solicitação : ' + cCdSolici + " Usuário : " + cUser
        ZPL->ZPL_TSTAMP := GetTimeStamp(DATE())
        ZPL->ZPL_RETORN := 1
        ZPL->ZPL_XML	:= cXML
    MsUnlock() 


Return

/*================================================================================================================*\
|| ############################################################################################################## ||
|| # Static Function: GETFIL                                                                                    # ||
|| # Desc: Retorna a filial da empresa a partir de seu CNPJ.                                                    # ||
|| ############################################################################################################## ||
\*================================================================TOTVS-EVERTON LUIZ    ================================================*/
Static Function GETFIL(cCNPJ)
    Local cAlias := GetNextAlias()
    Local cQuery := ""
    Local cRet := ""

    cQuery += "SELECT SM0.M0_CODFIL FROM " + RetSqlName("SM0") + " SM0"
    cQuery += " WHERE SM0.M0_CODIGO = '" + FWCodEmp() + "'"
    cQuery += " AND SM0.M0_CGC = '" + cCNPJ + "'"
    cQuery += " AND SM0.D_E_L_E_T_ <> '*'"
    cQuery := ChangeQuery(cQuery)
    
    DbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),cAlias,.F.,.T.)
	(cAlias)->(DbGotop())

    While (cAlias)->(!EoF())
        cRet := (cAlias)->M0_CODFIL
    	(cAlias)->(DbSkip())
	EndDo
Return cRet

/*================================================================================================================*\
|| ############################################################################################################## ||
|| # Static Function: SendXML                                                                                   # ||
|| # Desc: XML de requisição de Contratos Ativos.                                                               # ||
|| ############################################################################################################## ||
\*================================================================================================================*/
Static Function SendXML()
    Local cXML := ""

    cXML += '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/">' + CRLF
    cXML += '   <soapenv:Header/>' + CRLF
    cXML += '   <soapenv:Body>' + CRLF
    cXML += '      <tem:RetornarRequisicaoAlteracaoComprador/>' + CRLF
    cXML += '   </soapenv:Body>' + CRLF
    cXML += '</soapenv:Envelope>'
Return cXML



/*================================================================================================================*\
|| ############################################################################################################## ||
|| # Static Function: CadFornec                                                                                   # ||
|| # Desc: Retorno pedido portal paradigma.                                                               # ||
|| ############################################################################################################## ||
\*================================================================================================================*/
user Function RetSol()
   
    Local xRet    := Nil
    Local cLockName := "WsActvs"
    Local cAlias  := GetNextAlias()
    Local cQuery  := ''
    Local lRet   := .F.
    Local cMensagem, cToken := ''
    Local cPedAnt := ''

    cQuery += "SELECT  C7_FILIAL,C7_NUM,C7_ITEM,C7_XPEDWBC FROM" + RetSqlName("SC7") + " SC7"
    cQuery += " WHERE C7_CONAPRO <> 'B' " 
    cQuery += " AND SC7.C7_XPEDWBC  <> ''"
    cQuery += " AND SC7.D_E_L_E_T_ <> '*'"
    cQuery += " AND C7_XINTPA = '2'"
    cQuery += " GROUP BY C7_FILIAL,C7_NUM,C7_ITEM,C7_XPEDWBC"

    cQuery := ChangeQuery(cQuery)
    
    DbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),cAlias,.F.,.T.)
	(cAlias)->(DbGotop())

    While (cAlias)->(!EoF())

        If cPedAnt <> (cAlias)->C7_NUM
            //Atualiza STATUS pedido Portal Paradigma para integrado
            xRet := U_AtuPedPa((cAlias)->C7_NUM,(cAlias)->C7_ITEM, (cAlias)->C7_FILIAL,'1')
            cPedAnt := (cAlias)->C7_NUM
        Endif    
        
        If !(valtype(xRet) == 'O')
            lRet := .F.
            cMensagem := xRet
        Else
            lRet := .T.
            cToken := xRet:_S_ENVELOPE:_S_BODY:_PROCESSARPEDIDOALTERACAORESPONSE:_PROCESSARPEDIDOALTERACAORESULT:_A_SNRTOKEN:TEXT
        EndIf
        If lRet == .F.
            
            RecLock("ZPL", .T.)
                ZPL->ZPL_DATA   :=date()
                ZPL->ZPL_HORA   := Time()
                ZPL->ZPL_TOKEN  := ''
                ZPL->ZPL_FILIAL := (cAlias)->C7_FILIAL
                ZPL->ZPL_USUARI := 'Schedule'
                ZPL->ZPL_ROTINA := 'wsActvsPed'
                ZPL->ZPL_FUNCAO := 'ProcessarPedidoAlteracao'
                ZPL->ZPL_ORIGEM := ''
                ZPL->ZPL_MSGLOG := 'Erro na integração não integrado ' + 'Pedido Wbc:'+(cAlias)->C7_XPEDWBC + 'Pedido ERP:'+(cAlias)->C7_NUM + " - " + cMensagem
                ZPL->ZPL_MSGWSF := 'Erro na integração não integrado ' + 'Pedido Wbc:'+(cAlias)->C7_XPEDWBC + 'Pedido ERP:'+(cAlias)->C7_NUM + " - " + cMensagem
                ZPL->ZPL_TSTAMP := GetTimeStamp(DATE())
                ZPL->ZPL_RETORN := 0
            MsUnlock()

        Else

            dbselectArea("SC7")
            DbSetOrder(1) 
            if DbSeek((cAlias)->C7_FILIAL+(cAlias)->C7_NUM+(cAlias)->C7_ITEM) 
           
                RecLock("SC7", .F.)
                 SC7->C7_XINTPA := '3'
                MsUnlock()
            
            Endif

            RecLock("ZPL", .T.)
            ZPL->ZPL_DATA   :=date()
            ZPL->ZPL_HORA   := Time()
            ZPL->ZPL_TOKEN  := cToken
            ZPL->ZPL_FILIAL := (cAlias)->C7_FILIAL
            ZPL->ZPL_USUARI := 'Schedule'
            ZPL->ZPL_ROTINA := 'wsActvsPed'
            ZPL->ZPL_FUNCAO := 'AtualizarNumeroPedidoPortal'
            ZPL->ZPL_ORIGEM := ''
            ZPL->ZPL_MSGLOG := 'Integrado ' + 'Pedido Wbc:'+(cAlias)->C7_XPEDWBC + 'Pedido ERP:'+(cAlias)->C7_NUM + " - Token : " + cToken
            ZPL->ZPL_MSGWSF := 'Integrado ' + 'Pedido Wbc:'+(cAlias)->C7_XPEDWBC + 'Pedido ERP:'+(cAlias)->C7_NUM + " - Token : " + cToken
            ZPL->ZPL_TSTAMP := GetTimeStamp(DATE())
            ZPL->ZPL_RETORN := 1
            MsUnlock()
        
        Endif

        // Início - Semáforo de controle de execução simultânea
        If !LockByName(cLockName,.T.,.T.)
            MsgInfo("Rotina já está sendo executada por outro usuário","Atenção"+Procname())
            Return .F.
        EndIf

        // Fim - Semáforo de controle de execução simultânea
        UnLockByName(cLockName,.T.,.T.)
   
      (cAlias)->(DbSkip())
    EndDo


Return 

/*================================================================================================================*\
|| ############################################################################################################## ||
|| # Static Function: pHabiSol                                                                                 # ||
|| # Desc: Habilita ordem de compra Paradigma            .                                                               # ||
|| ############################################################################################################## ||
\*================================================================================================================*/
static Function pHabiSol( cCdOrdemCompra )
   
    Local lRet    := Nil
    Local oWsdl   := Nil
    Local cXMLRet := ""
    Local cLockName := "WsActvs"
    
    //RpcSetEnv("01","5303")

    // Conexão com o WebService \\
    oWsdl := TWsdlManager():New()
	oWsdl:AddHttpHeader("Authorization", "Bearer " + U_NewToken())
    oWsdl:lSSLInsecure := .T.
    oWsdl:nTimeout     := 120
    oWsdl:nSSLVersion  := 0
    xRet := oWsdl:ParseURL(GetMv("MV_XPARURL") + "/services/OrdemCompra.svc?wsdl") 
    
    If xRet == .F.
        ConOut("WsActvs - Erro ParseURL: " + oWsdl:cError)
        Return
    EndIf
    
    // Definição da operação \\
    lRet := oWsdl:SetOperation("HabilitarRetornarOrdemCompraEmProcessoDeIntegracao")
    If lRet == .F.
        ConOut("WsActvs - Erro SetOperation: " + oWsdl:cError)
        Return
    EndIf
    
    cXml:= ''
    cXml+=' <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/" xmlns:par="http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO">'
    cXml+="    <soapenv:Header/>                                                      "
    cXml+="    <soapenv:Body>                                                         "
    cXml+="       <tem:HabilitarRetornarOrdemCompraEmProcessoDeIntegracao>            "
    cXml+="          <!--Optional:-->                                                 "
    cXml+="          <tem:lstOrdemCompraHabilitarDTO>                                 "
    cXml+="             <!--Zero or more repetitions:-->                              "
    cXml+="             <par:OrdemCompraHabilitarDTO>                                 "
    cXml+="             	<par:sCdOrdemCompraEmpresa>"+cCdOrdemCompra+"</par:sCdOrdemCompraEmpresa>  "
    cXml+="             </par:OrdemCompraHabilitarDTO>                                "
    cXml+="          </tem:lstOrdemCompraHabilitarDTO>                                "
    cXml+="       </tem:HabilitarRetornarOrdemCompraEmProcessoDeIntegracao>           "
    cXml+="    </soapenv:Body>                                                        "
    cXml+=" </soapenv:Envelope>                                                       "
    
    lRet := oWsdl:SendSoapMsg(cXml)
    cXMLRet := oWsdl:GetSoapResponse()"
        
    If lRet == .F.
        
        RecLock("ZPL", .T.)
            ZPL->ZPL_DATA   :=date()
            ZPL->ZPL_HORA   := Time()
            ZPL->ZPL_TOKEN  := cCdOrdemCompra
            ZPL->ZPL_FILIAL := xFilial('ZPL') 
            ZPL->ZPL_USUARI := 'Schedule'
            ZPL->ZPL_ROTINA := 'wsActvsSol'
            ZPL->ZPL_FUNCAO := 'HabilitaSolicitacaoCompraPortal'
            ZPL->ZPL_ORIGEM := ""
            ZPL->ZPL_MSGLOG := 'NAO FOI POSSIVEL VOLTAR ORDEM DE COMPRA PARA STATUS DE A IMPORTAR PORTAL PARADIGMA'
            ZPL->ZPL_MSGWSF := 'NAO FOI POSSIVEL VOLTAR ORDEM DE COMPRA P PARA STATUS DE A IMPORTAR PORTAL PARADIGMA'
            ZPL->ZPL_TSTAMP := GetTimeStamp(DATE())
            ZPL->ZPL_RETORN := 0
        MsUnlock() 
    else
        RecLock("ZPL", .T.)
            ZPL->ZPL_DATA   :=date()
            ZPL->ZPL_HORA   := Time()
            ZPL->ZPL_TOKEN  := cCdOrdemCompra
            ZPL->ZPL_FILIAL := xFilial('ZPL') 
            ZPL->ZPL_USUARI := 'Schedule'
            ZPL->ZPL_ROTINA := 'wsActvsSol'
            ZPL->ZPL_FUNCAO := 'HabilitaSolicitacaoCompraPortal'
            ZPL->ZPL_ORIGEM := ""
            ZPL->ZPL_MSGLOG := 'ORDEM DE COMPRA RETORNA PARA STATUS DE A IMPORTAR NO PORTAL PARADIGMA'
            ZPL->ZPL_MSGWSF := 'ORDEM DE COMPRA RETORNA PARA STATUS DE A IMPORTAR NO PORTAL PARADIGMA'
            ZPL->ZPL_TSTAMP := GetTimeStamp(DATE())
            ZPL->ZPL_RETORN := 1
        MsUnlock() 
    EndIf
        
    // Início - Semáforo de controle de execução simultânea
    If !LockByName(cLockName,.T.,.T.)
        MsgInfo("Rotina já está sendo executada por outro usuário","Atenção"+Procname())
        Return .F.
    EndIf

    // Fim - Semáforo de controle de execução simultânea
    UnLockByName(cLockName,.T.,.T.)

Return 



Static Function Getuser(cUser)


    Local cAlias := GetNextAlias()
    Local cQuery := ""
    Local cRet := ""

    cQuery += "SELECT ZUP_CODUSU FROM " + RetSqlName("ZUP") + " ZUP"
    cQuery += " WHERE ZUP_NOMRED ='" + cUser + "'"
    cQuery += " AND ZUP.D_E_L_E_T_ <> '*'"
    cQuery := ChangeQuery(cQuery)
    
    DbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),cAlias,.F.,.T.)
	(cAlias)->(DbGotop())

    While (cAlias)->(!EoF())
        cRet := (cAlias)->ZUP_CODUSU
        (cAlias)->(DbSkip())
	EndDo

Return cRet



Static Function GetComprador(cUser)


    Local cAlias := GetNextAlias()
    Local cQuery := ""
    Local cRet := ""

    cQuery += "SELECT SY1.Y1_COD FROM " + RetSqlName("ZUP") + " ZUP"
    cQuery += " INNER JOIN " + RetSqlName("SY1") + " SY1 ON (  SY1.Y1_USER = ZUP.ZUP_CODUSU AND ZUP.D_E_L_E_T_ <> '*'   ) " 
    cQuery += " WHERE ZUP_NOMRED ='" + cUser + "'"
    cQuery += " AND ZUP.D_E_L_E_T_ <> '*'"
    cQuery := ChangeQuery(cQuery)
    
    DbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),cAlias,.F.,.T.)
	(cAlias)->(DbGotop())

    While (cAlias)->(!EoF())
        cRet := (cAlias)->Y1_COD
        (cAlias)->(DbSkip())
	EndDo

Return cRet
