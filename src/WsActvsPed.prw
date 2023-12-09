#Include "PROTHEUS.CH"
#Include "PARMTYPE.CH"
#Include "FWMVCDEF.CH"
#Include "TOPCONN.CH"

//PRIVATE lMsErroAuto := .F.

/*================================================================================================================*\
|| ############################################################################################################## ||
||																	 											  ||
|| # Programa: WsActvs 																							# ||
|| # Desc: Rotina que faz a integração de pedidos do portal paradigma                                                                  # ||
||																												  ||
|| # Tabelas Usadas: SE2, SED, SM0                                                                              # ||
||																												  ||
|| # Data - 29/09/2020 																							# ||
||																												  ||
|| ############################################################################################################## ||
||																												  ||
|| # Alterações 								 																# ||
|| 																												  ||
|| ############################################################################################################## ||
\*================================================================================================================*/
User Function WsActvsPed()
    Local lRet    := Nil
    Local oWsdl   := Nil

    Local cLockName := "WsActvs - Pedidos"
    Local nProc    := 1
    
    if ValType("cFilAnt") == "C" .and. TCIsConnected() // se ja tem ambiente aberto
        ConOut("Ambiente Protheus aberto e pronto para uso")
    else
        RpcSetEnv("11","02",,,"COM") //Abro o ambiente, pois o mesmo não encontrava-se aberto
    endif

    // Início - Semáforo de controle de execução simultânea
    If !LockByName(cLockName,.T.,.T.)
        MsgInfo("Rotina já está sendo executada por outro usuário","Atenção"+Procname())
        Return nProc
    EndIf

    conout("INICIO ")
   
    Private cXMLRet := ""
    // Conexão com o WebService \\
    oWsdl := TWsdlManager():New()
	oWsdl:AddHttpHeader("Authorization", "Bearer " + U_NewToken())
    oWsdl:lSSLInsecure := .T.
    oWsdl:nTimeout     := 120
    oWsdl:nSSLVersion  := 0
    xRet := oWsdl:ParseURL(AllTrim(GetMv("MV_XPARURL"))+'/services/Pedido.svc?wsdl')	
    
    If xRet == .F.
        ConOut("WsActvs - Erro ParseURL: " + oWsdl:cError)
        Return nProc
    EndIf

    // Definição da operação \\
    lRet := oWsdl:SetOperation("RetornarTodosPedidosEmProcessoDeIntegracao")
    If lRet == .F.
        ConOut("WsActvs - Erro SetOperation: " + oWsdl:cError)
        Return nProc
    EndIf

    // Envia uma mensagem SOAP XML ao servidor. Retorna o erro, caso ocorra. \\
    ConOut("WsActvs - " + SendXML())
    lRet := oWsdl:SendSoapMsg(SendXML())

    If lRet == .F.
        ConOut("WsActvs - Erro SendSoapMsg: " + oWsdl:cError)
        ConOut("WsActvs - Erro SendSoapMsg FaultCode: " + oWsdl:cFaultCode)
        Return nProc
    EndIf

    cXMLRet := oWsdl:GetSoapResponse()
    ConOut("WsActvs - " + cXMLRet)

    ProcXML(cXMLRet)
    //ProcXML(XMLRet())

    // Fim - Semáforo de controle de execução simultânea
    UnLockByName(cLockName,.T.,.T.)

    /*
    IF IsBlind()
         RpcClearEnv()
    endif */

    conout("FIM ")

Return nProc

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
    If XmlChildCount(OXML:_S_ENVELOPE:_S_BODY:_RetornarTodosPedidosEmProcessoDeIntegracaoResponse:_RetornarTodosPedidosEmProcessoDeIntegracaoResult) > 2
        XMLSE2(oXML, cXML)
    Else
        ConOut("Sem pedidos para integrar!")
            RecLock("ZPL", .T.)
                ZPL->ZPL_DATA   :=date()
                ZPL->ZPL_HORA   := Time()
                ZPL->ZPL_TOKEN  := ""
                ZPL->ZPL_FILIAL := xFilial('ZPL') //xFilial(cTabela)
                ZPL->ZPL_USUARI := 'Schedule'
                ZPL->ZPL_ROTINA := 'wsActvsPed'
                ZPL->ZPL_FUNCAO := 'RetornarTodosPedidosEmProcessoDeIntegracao'
                ZPL->ZPL_ORIGEM := "ProcXML"
                ZPL->ZPL_MSGLOG := "Sem pedidos para integrar!"
                ZPL->ZPL_MSGWSF := "Sem pedidos para integrar!"
                ZPL->ZPL_TSTAMP := GetTimeStamp(DATE())
                ZPL->ZPL_RETORN := 1
                ZPL->ZPL_XML := cXML
            MsUnlock()  
    EndIf
Return

/*================================================================================================================*\
|| ############################################################################################################## ||
|| # Static Function: XMLSE2                                                                                    # ||
|| # Desc: Conversão do contrato em título provisório.                                                          # ||
|| ############################################################################################################## ||
\*================================================================================================================*/
Static Function XMLSE2(OXML, cXML)
    // Arrays \\
    Local aProd := {} // Array contendo todos os valores, vencimentos e parcelas a serem gravadas

    // Tamanhos de array \\
    Local cLenCntr  // Contrato
    Local cLenItem  // Item

    // Objetos \\
    Local OAUXCNT // Objeto auxiliar, para diminuir o tamanho do objeto original para manipulação do contrato

    // Contadores \\
    Local nX // Contador de contratos
    Local nY // Contador de itens do contrato
    Local nZ // Contador de itens do contrato

    // Auxiliares \
    Local cDoc    := ''
    Local nNrItem := ''
    Local cFornec := ''
    Local cLoja   := ''
    Local cCond   := ''
    Local cEmpEnt := ''
    Local cObs    := ''
    Local cUsu    := ''
    Local cMoeda  := ''
    Local cCodtr  := ''
    Local cLojtr  := ''
    Local cCdFre  := ''
    Local dDateem := ''
    Local cCC     := ''
    Local cCnpj   := ''
    Local cPcompr := ''
    Local cOrigem := ''
    Local cMoedaPar := ''
    Local cTipoPar := ''
    Local cFilImPa := ''
    Local cCdPedIt := ''
    Local cdGrpoCom := ''
    Local cIdComFor := nil
    Local oRet
    Local nYy      := 0
    lOCAL aPedWS  := {}
    Local cFilAux := ''
    Local xOper    := ''
    Local xPacote  := ''
    Local cAlias   := GetNextAlias()
    Local cQuery   := ''
    Local cIcms    := ''
    Local cIpi     := ''
    Local cIcmsST  := 0
    Local cIss     := ''
    Local cAuximp  := ''
    Local cGeracont:= ''
    Local cErro    := ''
    Local cCdReqEmp:= ""
    Local cItemEnt:=""
    Local cValFre := 0
    Local _x := 0
    Private aRatElb:= {}
    Private lAutoErrNoFile := .T.
    Private lMsHelpAuto	:= .T.
    Private cErroEspParad := ''
   
   
    lMsErroAuto := .F.
    
    oRet := OXML:_S_ENVELOPE:_S_BODY:_RetornarTodosPedidosEmProcessoDeIntegracaoResponse:_RetornarTodosPedidosEmProcessoDeIntegracaoResult:_A_PedidoDTO
    // pedido, identifica se é 1 ou mais que 1 \\
    If ValType(oRet) == "A"
        cLenCntr := Len(oRet)
    Else
        cLenCntr := 1
    EndIf

   //Faz a leitura pedido a pedido 
    For nY := 1 To cLenCntr
       
     
        If cLenCntr == 1 //se for apenas 1 pedido ele é um objeto 
           
            OAUXCNT :=OXML:_S_ENVELOPE:_S_BODY:_RetornarTodosPedidosEmProcessoDeIntegracaoResponse:_RetornarTodosPedidosEmProcessoDeIntegracaoResult:_A_PedidoDTO
            

            cFilImPa :=cFilGet(OAUXCNT:_A_SCDCOMPRADOR:TEXT)   //'02' //GETFIL(OAUXCNT:_A_SCDCOMPRADOR:TEXT)
            cCond   := OAUXCNT:_A_sCdCondicaoPagamento:TEXT
            cEmpEnt := cFilGet(OAUXCNT:_A_SCDCOMPRADOR:TEXT)   //'02' //GETFIL(OAUXCNT:_A_SCDENDERECOENTREGA:TEXT)
            cCond   := OAUXCNT:_A_sCdCondicaoPagamento:TEXT
            cObs    := OAUXCNT:_A_SDSOBSERVACOES:TEXT
            cUsu    := Getuser(OAUXCNT:_A_sCdUsuario:TEXT)
            cMoeda  := OAUXCNT:_A_sCdMoeda:TEXT
            cTransp := OAUXCNT:_A_sCdTransportadora:TEXT
            cCnpj   := OAUXCNT:_A_sCdFornecedor:TEXT
            cPedwbc := OAUXCNT:_A_sCdPedidoWBC:TEXT  
            cPedido := OAUXCNT:_A_NCDPEDIDO:TEXT  
            cOrigem := OAUXCNT:_A_NIDTIPOORIGEM:TEXT
            cPcompr := OAUXCNT:_A_sCdComprador:TEXT
            cMoedaPar := OAUXCNT:_A_sCdMoeda:TEXT
            cTipoPar := OAUXCNT:_A_nCdTipo:TEXT
            cIdComFor:= OAUXCNT:_A_nIdComunicaFornecedor:TEXT
            cdGrpoCom := OAUXCNT:_A_sCdGrupoCompra:TEXT  // criar campo para gravação.

             dbselectArea("SA2")
	         DbSetOrder(3) //A2_FILIAL+A2_CGC
		
            If DbSeek(xFilial('SA2')+cTransp) 
                cCodtr := SA2->A2_COD
                cLojtr   := SA2->A2_LOJA
            Else
                cCodtr  :=  ''
                cLojtr  :=  ''
            EndIf
          
            cCdFre  := OAUXCNT:_A_sCdFrete:TEXT
            cValFre := Val(OAUXCNT:_A_dvlFrete:TEXT)
            dDateem := OAUXCNT:_A_tDtEmissao:TEXT
            dDateem2:=  CToD(SubStr(dDateem,9,2) + "/" + SubStr(dDateem,6,2) + "/" + SubStr(dDateem,1,4))
            cCC     := OAUXCNT:_A_sCdCentroCusto:TEXT
      
       Else
            //se for mais que um pedido ele é uma array então temos que passar o NY no pedido dto 
           
            OAUXCNT := OXML:_S_ENVELOPE:_S_BODY:_RetornarTodosPedidosEmProcessoDeIntegracaoResponse:_RetornarTodosPedidosEmProcessoDeIntegracaoResult:_A_PedidoDTO[nY]
            
            cFilImPa :=cFilGet(OAUXCNT:_A_SCDCOMPRADOR:TEXT)
            cCond   := OAUXCNT:_A_sCdCondicaoPagamento:TEXT
            cEmpEnt := cFilGet(OAUXCNT:_A_SCDCOMPRADOR:TEXT)
            cCond   := OAUXCNT:_A_sCdCondicaoPagamento:TEXT
            cObs    := OAUXCNT:_A_SDSOBSERVACOES:TEXT
            cUsu    := Getuser(OAUXCNT:_A_sCdUsuario:TEXT)
            cMoeda  := OAUXCNT:_A_sCdMoeda:TEXT
            cTransp := OAUXCNT:_A_sCdTransportadora:TEXT
            cCnpj   := OAUXCNT:_A_sCdFornecedor:TEXT
            cPedwbc := OAUXCNT:_A_sCdPedidoWBC:TEXT  
            cPedido := OAUXCNT:_A_NCDPEDIDO:TEXT  
            cOrigem := OAUXCNT:_A_NIDTIPOORIGEM:TEXT
            cPcompr := OAUXCNT:_A_sCdComprador:TEXT
            cMoedaPar := OAUXCNT:_A_sCdMoeda:TEXT
            cTipoPar := OAUXCNT:_A_nCdTipo:TEXT
            cIdComFor:= OAUXCNT:_A_nIdComunicaFornecedor:TEXT
            cdGrpoCom := OAUXCNT:_A_sCdGrupoCompra:TEXT  // criar campo para gravação.

             dbselectArea("SA2")
	         DbSetOrder(3) //A2_FILIAL+A2_CGC
		
            If DbSeek(xFilial('SA2')+cTransp) 
                cCodtr := SA2->A2_COD
                cLojtr   := SA2->A2_LOJA
            Else
                cCodtr  :=  ''
                cLojtr  :=  ''
            EndIf
          
            cCdFre  := OAUXCNT:_A_sCdFrete:TEXT
            cValFre := Val(OAUXCNT:_A_dvlFrete:TEXT)
            dDateem := OAUXCNT:_A_tDtEmissao:TEXT
            dDateem2:=  CToD(SubStr(dDateem,9,2) + "/" + SubStr(dDateem,6,2) + "/" + SubStr(dDateem,1,4))
            cCC     := OAUXCNT:_A_sCdCentroCusto:TEXT
    
      
       EndIf
        
        //verifica a quantidade de itens no pedido 
        If ValType( OAUXCNT:_A_LSTPEDIDOITEM:_A_PEDIDOITEMDTO) == "A"
            cLenItem := Len(OAUXCNT:_A_LSTPEDIDOITEM:_A_PEDIDOITEMDTO)
        Else
            cLenItem := 1
        EndIf
        
		aProd := {}
		 aRatElb:= {}
        //Se for apenas 1 item no pedido aqui ele monta o array de produtos que será passado na rotina automatica
        IF cLenItem == 1
            
            cProduto := OAUXCNT:_A_LSTPEDIDOITEM:_A_PEDIDOITEMDTO:_A_sCdProduto:TEXT
            cDesProd := OAUXCNT:_A_LSTPEDIDOITEM:_A_PEDIDOITEMDTO:_A_sDsItem:TEXT
            nQuantIT := OAUXCNT:_A_LSTPEDIDOITEM:_A_PEDIDOITEMDTO:_A_dQtItem:TEXT
            nValorIt := OAUXCNT:_A_LSTPEDIDOITEM:_A_PEDIDOITEMDTO:_A_dVlItem:TEXT
            cObsIT   := OAUXCNT:_A_LSTPEDIDOITEM:_A_PEDIDOITEMDTO:_A_sDsObservacao:TEXT
            cNumsc   := OAUXCNT:_A_LSTPEDIDOITEM:_A_PEDIDOITEMDTO:_A_sCdOrigemEmpresa:TEXT
            cItemsc  := OAUXCNT:_A_LSTPEDIDOITEM:_A_PEDIDOITEMDTO:_A_sCdItemOrigemEmpresa:TEXT
            If val(nQuantIT) > 1 .and. ValType(OAUXCNT:_A_LSTPEDIDOITEM:_A_PEDIDOITEMDTO:_A_LSTPEDIDOITEMENTREGA:_A_PEDIDOITEMENTREGADTO) == 'A'
                dDtEntrga:= OAUXCNT:_A_LSTPEDIDOITEM:_A_PEDIDOITEMDTO:_A_LSTPEDIDOITEMENTREGA:_A_PEDIDOITEMENTREGADTO[ny]:_A_TDTENTREGA:TEXT
                cCdEmCob := OAUXCNT:_A_LSTPEDIDOITEM:_A_PEDIDOITEMDTO:_A_LSTPEDIDOITEMENTREGA:_A_PEDIDOITEMENTREGADTO[ny]:_A_sCdEmpresaCobrancaEndereco:TEXT
                cCdEmEnt := OAUXCNT:_A_LSTPEDIDOITEM:_A_PEDIDOITEMDTO:_A_LSTPEDIDOITEMENTREGA:_A_PEDIDOITEMENTREGADTO[ny]:_A_sCdEmpresaEntregaEndereco:TEXT
                cCdEmFat := OAUXCNT:_A_LSTPEDIDOITEM:_A_PEDIDOITEMDTO:_A_LSTPEDIDOITEMENTREGA:_A_PEDIDOITEMENTREGADTO[ny]:_A_sCdEmpresaFaturamentoEndereco:TEXT
                cCdReqEmp:= OAUXCNT:_A_LSTPEDIDOITEM:_A_PEDIDOITEMDTO:_A_LSTPEDIDOITEMENTREGA:_A_PEDIDOITEMENTREGADTO[ny]:_A_SCDREQUISICAOEMPRESA:TEXT
                cItemEnt := OAUXCNT:_A_LSTPEDIDOITEM:_A_PEDIDOITEMDTO:_A_LSTPEDIDOITEMENTREGA:_A_PEDIDOITEMENTREGADTO[ny]:_A_sCdItemRequisicaoEmpresa:TEXT
            Else
                dDtEntrga:= OAUXCNT:_A_LSTPEDIDOITEM:_A_PEDIDOITEMDTO:_A_LSTPEDIDOITEMENTREGA:_A_PEDIDOITEMENTREGADTO:_A_TDTENTREGA:TEXT
                cCdEmCob := OAUXCNT:_A_LSTPEDIDOITEM:_A_PEDIDOITEMDTO:_A_LSTPEDIDOITEMENTREGA:_A_PEDIDOITEMENTREGADTO:_A_sCdEmpresaCobrancaEndereco:TEXT
                cCdEmEnt := OAUXCNT:_A_LSTPEDIDOITEM:_A_PEDIDOITEMDTO:_A_LSTPEDIDOITEMENTREGA:_A_PEDIDOITEMENTREGADTO:_A_sCdEmpresaEntregaEndereco:TEXT
                cCdEmFat := OAUXCNT:_A_LSTPEDIDOITEM:_A_PEDIDOITEMDTO:_A_LSTPEDIDOITEMENTREGA:_A_PEDIDOITEMENTREGADTO:_A_sCdEmpresaFaturamentoEndereco:TEXT
                cCdReqEmp:= OAUXCNT:_A_LSTPEDIDOITEM:_A_PEDIDOITEMDTO:_A_LSTPEDIDOITEMENTREGA:_A_PEDIDOITEMENTREGADTO:_A_SCDREQUISICAOEMPRESA:TEXT
                cItemEnt := OAUXCNT:_A_LSTPEDIDOITEM:_A_PEDIDOITEMDTO:_A_LSTPEDIDOITEMENTREGA:_A_PEDIDOITEMENTREGADTO:_A_sCdItemRequisicaoEmpresa:TEXT

            EndIf
            cItemwbc := OAUXCNT:_A_LSTPEDIDOITEM:_A_PEDIDOITEMDTO:_A_SCDITEMWBC:TEXT
            cCdPedIt := OAUXCNT:_A_LSTPEDIDOITEM:_A_PEDIDOITEMDTO:_A_nCdPedidoItem:TEXT
            cCdmarca := OAUXCNT:_A_LSTPEDIDOITEM:_A_PEDIDOITEMDTO:_A_SCDMARCA:TEXT
            
            //cdGrpoCom := OAUXCNT:_A_sCdGrupoCompra:TEXT  // criar campo para gravação.
                        
            dDateem2:=  CToD(SubStr(dDateem,9,2) + "/" + SubStr(dDateem,6,2) + "/" + SubStr(dDateem,1,4))
            
            IF cOrigem == '12'

                ExcTit(cPedwbc,dDateem2,cItemwbc) //Verifica a origem do pedido se for = 12 excluímos os titulos provisórios 

            Endif

            //Aqui verificamos se para esse produto existe rateio de centro de custo  
            
            IF  OAUXCNT:_A_LSTPEDIDOITEM:_A_PEDIDOITEMDTO:_A_LSTPEDIDOITEMRATEIO:TEXT <> ''
                If ValType( OAUXCNT:_A_LSTPEDIDOITEM:_A_PEDIDOITEMDTO:_A_LSTPEDIDOITEMRATEIO:_A_PEDIDOITEMRATEIODTO) == "A"  
                    cLenRat := Len(OAUXCNT:_A_LSTPEDIDOITEM:_A_PEDIDOITEMDTO:_A_LSTPEDIDOITEMRATEIO:_A_PEDIDOITEMRATEIODTO)
                Else
                    cLenRat := 1
                EndIf

                //aqui montamos o array de rateio de centro de custo 
                if cLenRat == 1 

                    aRatElb:= {}
                    cValRat := OAUXCNT:_A_LSTPEDIDOITEM:_A_PEDIDOITEMDTO:_A_LSTPEDIDOITEMRATEIO:_A_PEDIDOITEMRATEIODTO:_A_DPCRATEIO:TEXT
                    cCeCust := SUBSTR(OAUXCNT:_A_LSTPEDIDOITEM:_A_PEDIDOITEMDTO:_A_LSTPEDIDOITEMRATEIO:_A_PEDIDOITEMRATEIODTO:_A_SCDCENTROCUSTO:TEXT,1,4)
                    cClval  := SUBSTR(OAUXCNT:_A_LSTPEDIDOITEM:_A_PEDIDOITEMDTO:_A_LSTPEDIDOITEMRATEIO:_A_PEDIDOITEMRATEIODTO:_A_SCDCENTROCUSTO:TEXT,6,8) 

                    aadd(aRatElb,{cValRat,cCeCust,cClval,cProduto,cCdPedIt })

                Else

                    aRatElb:={}
                    for nYy := 1 to cLenRat

                        cValRat := OAUXCNT:_A_LSTPEDIDOITEM:_A_PEDIDOITEMDTO:_A_LSTPEDIDOITEMRATEIO:_A_PEDIDOITEMRATEIODTO[nYy]:_A_DPCRATEIO:TEXT
                        cCeCust := SUBSTR(OAUXCNT:_A_LSTPEDIDOITEM:_A_PEDIDOITEMDTO:_A_LSTPEDIDOITEMRATEIO:_A_PEDIDOITEMRATEIODTO[nYy]:_A_SCDCENTROCUSTO:TEXT,1,4)
                        cClval  := SUBSTR(OAUXCNT:_A_LSTPEDIDOITEM:_A_PEDIDOITEMDTO:_A_LSTPEDIDOITEMRATEIO:_A_PEDIDOITEMRATEIODTO[nYy]:_A_SCDCENTROCUSTO:TEXT,6,8)


                        aadd(aRatElb,{cValRat,cCeCust,cClval,cProduto,cCdPedIt })
                    Next nYy  
                    
                Endif
            Endif
            //arrray de produtos que será passado na rotina automatica
            
            //impostos
            FOR _x:=1 to len(OAUXCNT:_A_LSTPEDIDOITEM:_A_PEDIDOITEMDTO:_A_LSTPEDIDOITEMTAXA:_A_PEDIDOITEMTAXADTO)


                IF oAUXCNT:_A_LSTPEDIDOITEM:_A_PEDIDOITEMDTO:_A_LSTPEDIDOITEMTAXA:_A_PEDIDOITEMTAXADTO[_x]:_A_NCDTAXA:TEXT == '1'
                  cIcms    :=  OAUXCNT:_A_LSTPEDIDOITEM:_A_PEDIDOITEMDTO:_A_LSTPEDIDOITEMTAXA:_A_PEDIDOITEMTAXADTO[_x]:_A_DPCTAXA:TEXT
                ENDIF
           
                 IF oAUXCNT:_A_LSTPEDIDOITEM:_A_PEDIDOITEMDTO:_A_LSTPEDIDOITEMTAXA:_A_PEDIDOITEMTAXADTO[_x]:_A_NCDTAXA:TEXT == '2'
                  cIpi    :=  OAUXCNT:_A_LSTPEDIDOITEM:_A_PEDIDOITEMDTO:_A_LSTPEDIDOITEMTAXA:_A_PEDIDOITEMTAXADTO[_x]:_A_DPCTAXA:TEXT
                ENDIF

               
                IF oAUXCNT:_A_LSTPEDIDOITEM:_A_PEDIDOITEMDTO:_A_LSTPEDIDOITEMTAXA:_A_PEDIDOITEMTAXADTO[_x]:_A_NCDTAXA:TEXT == '4'
                  cIss    :=  OAUXCNT:_A_LSTPEDIDOITEM:_A_PEDIDOITEMDTO:_A_LSTPEDIDOITEMTAXA:_A_PEDIDOITEMTAXADTO[_x]:_A_DPCTAXA:TEXT
                ENDIF
               
                IF oAUXCNT:_A_LSTPEDIDOITEM:_A_PEDIDOITEMDTO:_A_LSTPEDIDOITEMTAXA:_A_PEDIDOITEMTAXADTO[_x]:_A_NCDTAXA:TEXT == '3'
                  cAuximp    :=  OAUXCNT:_A_LSTPEDIDOITEM:_A_PEDIDOITEMDTO:_A_LSTPEDIDOITEMTAXA:_A_PEDIDOITEMTAXADTO[_x]:_A_DPCTAXA:TEXT
                
                  IF  cIss = '0' 
                    cIcmsST   := (VAL(nValorIt) * VAL(nQuantIT)) * VAL(cAuximp)/100
                  else
                     cIcmsST   := (VAL(nValorIt) * VAL(nQuantIT))  
                     cIcmsST   := ((VAL(cAuximp) + VAL(cIss)) /100)  * cIcmsST
                  endif

                ENDIF


           Next _x
            
            
            aadd(aProd,{cProduto,cDesProd,nValorIt,nQuantIT,cObsIT,cNumsc,cItemsc,cItemwbc,cCdPedIt,cdGrpoCom,cCdReqEmp,cItemEnt,cIcms,cIpi,cIcmsST,cIss})
            aAdd(aPedWS, cItemwbc)


        Else //se possuir mais de um item precisamos montar o array de produtos passando o NZ 
      
            For nZ := 1 To cLenItem            

                cProduto := OAUXCNT:_A_LSTPEDIDOITEM:_A_PEDIDOITEMDTO[nZ]:_A_sCdProduto:TEXT
                cDesProd := OAUXCNT:_A_LSTPEDIDOITEM:_A_PEDIDOITEMDTO[nZ]:_A_sDsItem:TEXT
                nQuantIT := OAUXCNT:_A_LSTPEDIDOITEM:_A_PEDIDOITEMDTO[nZ]:_A_dQtItem:TEXT
                nValorIt := OAUXCNT:_A_LSTPEDIDOITEM:_A_PEDIDOITEMDTO[nZ]:_A_dVlItem:TEXT
                cObsIT   := OAUXCNT:_A_LSTPEDIDOITEM:_A_PEDIDOITEMDTO[nZ]:_A_sDsObservacao:TEXT
                cNumsc   := OAUXCNT:_A_LSTPEDIDOITEM:_A_PEDIDOITEMDTO[nZ]:_A_sCdOrigemEmpresa:TEXT
                cItemsc  := OAUXCNT:_A_LSTPEDIDOITEM:_A_PEDIDOITEMDTO[nZ]:_A_sCdItemOrigemEmpresa:TEXT
                If val(nQuantIT) > 1 .and. ValType(OAUXCNT:_A_LSTPEDIDOITEM:_A_PEDIDOITEMDTO[nZ]:_A_LSTPEDIDOITEMENTREGA:_A_PEDIDOITEMENTREGADTO:_A_TDTENTREGA) == 'A'
                    dDtEntrga:= OAUXCNT:_A_LSTPEDIDOITEM:_A_PEDIDOITEMDTO[nZ]:_A_LSTPEDIDOITEMENTREGA:_A_PEDIDOITEMENTREGADTO[nz]:_A_TDTENTREGA:TEXT
                    cCdEmCob := OAUXCNT:_A_LSTPEDIDOITEM:_A_PEDIDOITEMDTO[nZ]:_A_LSTPEDIDOITEMENTREGA:_A_PEDIDOITEMENTREGADTO[nz]:_A_sCdEmpresaCobrancaEndereco:TEXT
                    cCdEmEnt := OAUXCNT:_A_LSTPEDIDOITEM:_A_PEDIDOITEMDTO[nZ]:_A_LSTPEDIDOITEMENTREGA:_A_PEDIDOITEMENTREGADTO[nz]:_A_sCdEmpresaEntregaEndereco:TEXT
                    cCdEmFat := OAUXCNT:_A_LSTPEDIDOITEM:_A_PEDIDOITEMDTO[nZ]:_A_LSTPEDIDOITEMENTREGA:_A_PEDIDOITEMENTREGADTO[nz]:_A_sCdEmpresaFaturamentoEndereco:TEXT
                    cCdReqEmp:= OAUXCNT:_A_LSTPEDIDOITEM:_A_PEDIDOITEMDTO[nZ]:_A_LSTPEDIDOITEMENTREGA:_A_PEDIDOITEMENTREGADTO[nz]:_A_SCDREQUISICAOEMPRESA:TEXT
                    cItemEnt := OAUXCNT:_A_LSTPEDIDOITEM:_A_PEDIDOITEMDTO[nZ]:_A_LSTPEDIDOITEMENTREGA:_A_PEDIDOITEMENTREGADTO[nz]:_A_sCdItemRequisicaoEmpresa:TEXT
                else
                    dDtEntrga:= OAUXCNT:_A_LSTPEDIDOITEM:_A_PEDIDOITEMDTO[nZ]:_A_LSTPEDIDOITEMENTREGA:_A_PEDIDOITEMENTREGADTO:_A_TDTENTREGA:TEXT
                    cCdEmCob := OAUXCNT:_A_LSTPEDIDOITEM:_A_PEDIDOITEMDTO[nZ]:_A_LSTPEDIDOITEMENTREGA:_A_PEDIDOITEMENTREGADTO:_A_sCdEmpresaCobrancaEndereco:TEXT
                    cCdEmEnt := OAUXCNT:_A_LSTPEDIDOITEM:_A_PEDIDOITEMDTO[nZ]:_A_LSTPEDIDOITEMENTREGA:_A_PEDIDOITEMENTREGADTO:_A_sCdEmpresaEntregaEndereco:TEXT
                    cCdEmFat := OAUXCNT:_A_LSTPEDIDOITEM:_A_PEDIDOITEMDTO[nZ]:_A_LSTPEDIDOITEMENTREGA:_A_PEDIDOITEMENTREGADTO:_A_sCdEmpresaFaturamentoEndereco:TEXT
                    cCdReqEmp:= OAUXCNT:_A_LSTPEDIDOITEM:_A_PEDIDOITEMDTO[nZ]:_A_LSTPEDIDOITEMENTREGA:_A_PEDIDOITEMENTREGADTO:_A_SCDREQUISICAOEMPRESA:TEXT
                    cItemEnt := OAUXCNT:_A_LSTPEDIDOITEM:_A_PEDIDOITEMDTO[nZ]:_A_LSTPEDIDOITEMENTREGA:_A_PEDIDOITEMENTREGADTO:_A_sCdItemRequisicaoEmpresa:TEXT
               
                EndIf
                cItemwbc := OAUXCNT:_A_LSTPEDIDOITEM:_A_PEDIDOITEMDTO[nZ]:_A_SCDITEMWBC:TEXT
                cCdPedIt := OAUXCNT:_A_LSTPEDIDOITEM:_A_PEDIDOITEMDTO[nZ]:_A_nCdPedidoItem:TEXT
                cCdmarca := OAUXCNT:_A_LSTPEDIDOITEM:_A_PEDIDOITEMDTO[nZ]:_A_SCDMARCA:TEXT
                
                IF  OAUXCNT:_A_LSTPEDIDOITEM:_A_PEDIDOITEMDTO[nz]:_A_LSTPEDIDOITEMRATEIO:TEXT <> ''
                    If ValType( OAUXCNT:_A_LSTPEDIDOITEM:_A_PEDIDOITEMDTO[nZ]:_A_LSTPEDIDOITEMRATEIO:_A_PEDIDOITEMRATEIODTO) == "A"  
                        cLenRat := Len(OAUXCNT:_A_LSTPEDIDOITEM:_A_PEDIDOITEMDTO[nZ]:_A_LSTPEDIDOITEMRATEIO:_A_PEDIDOITEMRATEIODTO)
                    Else
                        cLenRat := 1
                    EndIf

                    //aqui montamos o array de rateio de centro de custo 
                    if cLenRat == 1 

                    // aRatElb:= {}
                        cValRat := OAUXCNT:_A_LSTPEDIDOITEM:_A_PEDIDOITEMDTO[nZ]:_A_LSTPEDIDOITEMRATEIO:_A_PEDIDOITEMRATEIODTO:_A_DPCRATEIO:TEXT
                        cCeCust := SUBSTR(OAUXCNT:_A_LSTPEDIDOITEM:_A_PEDIDOITEMDTO[nZ]:_A_LSTPEDIDOITEMRATEIO:_A_PEDIDOITEMRATEIODTO:_A_SCDCENTROCUSTO:TEXT,1,4)
                        cClval  := SUBSTR(OAUXCNT:_A_LSTPEDIDOITEM:_A_PEDIDOITEMDTO[nZ]:_A_LSTPEDIDOITEMRATEIO:_A_PEDIDOITEMRATEIODTO:_A_SCDCENTROCUSTO:TEXT,6,8) 

                        aadd(aRatElb,{cValRat,cCeCust,cClval,cProduto,cCdPedIt })

                    Else

                    //  aRatElb:={}
                    
                        for nYy := 1 to cLenRat

                            cValRat := OAUXCNT:_A_LSTPEDIDOITEM:_A_PEDIDOITEMDTO[nZ]:_A_LSTPEDIDOITEMRATEIO:_A_PEDIDOITEMRATEIODTO[nYy]:_A_DPCRATEIO:TEXT
                            cCeCust := SUBSTR(OAUXCNT:_A_LSTPEDIDOITEM:_A_PEDIDOITEMDTO[nZ]:_A_LSTPEDIDOITEMRATEIO:_A_PEDIDOITEMRATEIODTO[nYy]:_A_SCDCENTROCUSTO:TEXT,1,4)
                            cClval  := SUBSTR(OAUXCNT:_A_LSTPEDIDOITEM:_A_PEDIDOITEMDTO[nZ]:_A_LSTPEDIDOITEMRATEIO:_A_PEDIDOITEMRATEIODTO[nYy]:_A_SCDCENTROCUSTO:TEXT,6,8)


                            aadd(aRatElb,{cValRat,cCeCust,cClval,cProduto,cCdPedIt })
                        Next nYy  
                    
                    Endif
                Endif
                
               

                
                FOR _x:=1 to len(OAUXCNT:_A_LSTPEDIDOITEM:_A_PEDIDOITEMDTO[nZ]:_A_LSTPEDIDOITEMTAXA:_A_PEDIDOITEMTAXADTO)

                    IF oAUXCNT:_A_LSTPEDIDOITEM:_A_PEDIDOITEMDTO[nZ]:_A_LSTPEDIDOITEMTAXA:_A_PEDIDOITEMTAXADTO[_x]:_A_NCDTAXA:TEXT == '1'
                        cIcms    :=  OAUXCNT:_A_LSTPEDIDOITEM:_A_PEDIDOITEMDTO[nZ]:_A_LSTPEDIDOITEMTAXA:_A_PEDIDOITEMTAXADTO[_x]:_A_DPCTAXA:TEXT
                    ENDIF
            
                    IF oAUXCNT:_A_LSTPEDIDOITEM:_A_PEDIDOITEMDTO[nZ]:_A_LSTPEDIDOITEMTAXA:_A_PEDIDOITEMTAXADTO[_x]:_A_NCDTAXA:TEXT == '2'
                        cIpi    :=  OAUXCNT:_A_LSTPEDIDOITEM:_A_PEDIDOITEMDTO[nZ]:_A_LSTPEDIDOITEMTAXA:_A_PEDIDOITEMTAXADTO[_x]:_A_DPCTAXA:TEXT
                    ENDIF


                    IF oAUXCNT:_A_LSTPEDIDOITEM:_A_PEDIDOITEMDTO[nZ]:_A_LSTPEDIDOITEMTAXA:_A_PEDIDOITEMTAXADTO[_x]:_A_NCDTAXA:TEXT == '4'
                          cIss    :=  OAUXCNT:_A_LSTPEDIDOITEM:_A_PEDIDOITEMDTO[nZ]:_A_LSTPEDIDOITEMTAXA:_A_PEDIDOITEMTAXADTO[_x]:_A_DPCTAXA:TEXT
                    ENDIF

                    
                    IF oAUXCNT:_A_LSTPEDIDOITEM:_A_PEDIDOITEMDTO[nZ]:_A_LSTPEDIDOITEMTAXA:_A_PEDIDOITEMTAXADTO[_x]:_A_NCDTAXA:TEXT == '3'
                    
                    
                       cAuximp    :=  OAUXCNT:_A_LSTPEDIDOITEM:_A_PEDIDOITEMDTO[nZ]:_A_LSTPEDIDOITEMTAXA:_A_PEDIDOITEMTAXADTO[_x]:_A_DPCTAXA:TEXT
                
                         IF  cIss = '0' 
                            cIcmsST   := (VAL(nValorIt) * VAL(nQuantIT)) * VAL(cAuximp)/100
                        else
                            cIcmsST   := (VAL(nValorIt) * VAL(nQuantIT))  
                            cIcmsST   := ((VAL(cAuximp) + VAL(cIss)) /100)  * cIcmsST
                        endif


                    
                    ENDIF
              Next _x
                
                
                
                aadd(aProd,{cProduto,cDesProd,nValorIt,nQuantIT,cObsIT,cNumsc,cItemsc,cItemwbc,cCdPedIt,cdGrpoCom,cCdReqEmp,cItemEnt,cIcms,cIpi,cIcmsST,cIss})
                aAdd(aPedWS, cItemwbc)
             
                IF cOrigem == '12'

                    ExcTit(cPedwbc,dDateem2,cItemwbc)

                Endif

            next nZ
            
        Endif
      
         //VALIDAÇÃO CONTRATO 
        
        // Inclusão
        IF cMoedaPar  == '1'  

            dbselectArea("SA2")   //se  não for ex 
            DbSetOrder(3) //A2_FILIAL+A2_CGC
            
            If DbSeek(xFilial('SA2')+cCnpj) 
                cFornec := SA2->A2_COD
                cLoja   := SA2->A2_LOJA
            Else
                dbselectArea("SA2")  //fornecedor estrangeiro muda o indice 
                DbSetOrder(1) //A2_FILIAL+A2_CGC
                If DbSeek(xFilial('SA2')+cCnpj) 
                    cFornec := SA2->A2_COD
                    cLoja   := SA2->A2_LOJA
                else    
                    //CadFornec(cCnpj)
                    cFornec :=''
                    cLoja   := ''
                Endif
            EndIf
    
        Else 
            dbselectArea("SA2")  //se não for ex mas o pedido foi em dolar 
            DbSetOrder(3) //A2_FILIAL+A2_CGC
            If DbSeek(xFilial('SA2')+cCnpj) 
                cFornec := SA2->A2_COD
                cLoja   := SA2->A2_LOJA
            Else
                     
                dbselectArea("SA2")  //fornecedor estrangeiro muda o indice 
                DbSetOrder(1) //A2_FILIAL+A2_CGC
                If DbSeek(xFilial('SA2')+cCnpj) 
                    cFornec := SA2->A2_COD
                    cLoja   := SA2->A2_LOJA
                    
                Endif
            EndIf

        Endif 
        
        If !Empty(cCdReqEmp) .AND. !Empty(cItemEnt) //E0001 - específico para não aceitar sem SC (específico Ferroport)
        
            cFilAux := cFilAnt
            cFilAnt := cFilImPa
            
            cDoc := GetSXENum("SC7","C7_NUM")
            SC7->(dbSetOrder(1))
            While SC7->(dbSeek(xFilial("SC7")+cDoc))
            ConfirmSX8()
            cDoc := GetSXENum("SC7","C7_NUM")
            EndDo
            
            //cDoc := GetSXENum("SC7","C7_NUM")
            dDtEntrga:=CToD(SubStr(dDtEntrga,9,2) + "/" + SubStr(dDtEntrga,6,2) + "/" + SubStr(dDtEntrga,1,4))

            /*cQuery := ''
            cQuery += "SELECT * FROM " + RetSqlName("CN1") + " CN1"
            cQuery += " WHERE CN1_XWBCTP = '" + cTipoPar + "'
            cQuery += " AND CN1.D_E_L_E_T_ <> '*'"
                
            cQuery := ChangeQuery(cQuery)

                
            If Select(cAlias) <> 0
                (cAlias)->(dbCloseArea())
            Endif
                

            DbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),cAlias,.F.,.T.)

            
            cGeracont := ''
        
            IF !Empty((cAlias)->CN1_XWBCTP)

                cGeracont := 'SIM'
                //U_WBC030(aCabec, aItens, cTipoPar, '001',xConta,xPacote)	

            endif*/

            //cUsu :=
            aCabec:= {}
            aadd(aCabec,{"C7_FILIAL" ,cFilImPa})
            aadd(aCabec,{"C7_TIPO" ,'1'})
            aadd(aCabec,{"C7_NUM" ,cDoc})
            aadd(aCabec,{"C7_EMISSAO" ,dDateem2})
            aadd(aCabec,{"C7_DATPRF " ,dDtEntrga,Nil})  
            aadd(aCabec,{"C7_FORNECE" ,cFornec})
            aadd(aCabec,{"C7_LOJA" ,cLoja})
            aadd(aCabec,{"C7_COND" ,cCond})
            aadd(aCabec,{"C7_CONTATO" ,"AUTO"})
            aadd(aCabec,{"C7_FILENT" ,cFilImPa})
            aadd(aCabec,{"C7_OBS" ,cObs})
            aadd(aCabec,{"C7_USER" ,cUsu})
            // aadd(aCabec,{"C7_TRANSP" ,cCodtr})
            // aadd(aCabec,{"C7_TRANSLJ" ,cLojtr})
            aadd(aCabec,{"C7_TPFRETE" ,cCdFre})
            aadd(aCabec,{"C7_FRETE" ,cValFre})
            aadd(aCabec,{"C7_MOEDA" ,VAL(cMoedaPar)})
            aadd(aCabec,{"C7_XPROPOS" ,''})
            //aadd(aCabec,{"C7_XGERACT" ,cGeracont})
            aRatCC:={}  
            aItens:={}
            For nX := 1 To Len(aProd)
                aLinha := {}
                
                dbselectArea("SC1")
                DbSetOrder(2)
                DbSeek(xFilial('SB2')+Padr(aProd[nX][1], tamsx3('C7_PRODUTO')[1])+aProd[nX][11]) 

                If FieldPos("C1_XOPER")>0
                    xOper := SC1->C1_XOPER
                EndIf
                If FieldPos("C1_CONTA")>0
                    xConta:= SC1->C1_CONTA
                EndIf
                If FieldPos("C1_XPACOTE")>0
                    xPacote:=SC1->C1_XPACOTE
                EndIf
                aadd(aLinha,{"C7_PRODUTO", Padr(aProd[nX][1], tamsx3('C7_PRODUTO')[1]),Nil})
                aadd(aLinha,{"C7_QUANT" ,VAL(aProd[nX][4]) ,Nil})
                aadd(aLinha,{"C7_PRECO" ,VAL(aProd[nX][3]) ,Nil})
                aadd(aLinha,{"C7_TOTAL" ,VAL(aProd[nX][4]) * VAL(aProd[nX][3])  ,Nil})
                aadd(aLinha,{"C7_DESCRI" ,aProd[nX][2],Nil})
                aadd(aLinha,{"C7_XPEDWBC" ,alltrim(cPedido),Nil})
                //aadd(aLinha,{"C7_CONTA" ,xConta,Nil})   
                IF Len(aRatElb) == 0
                    aadd(aLinha,{"C7_CC" ,cCC,Nil})
                    // aadd(aLinha,{"C7_CLVL" ,cClval,Nil})
                Endif
                
                aadd(aLinha,{"C7_OBSM" ,aProd[nX][5] ,Nil})
                aadd(aLinha,{"C7_NUMSC" ,aProd[nX][11],Nil})
                aadd(aLinha,{"C7_ITEMSC" ,aProd[nx][12] ,Nil})
                aadd(aLinha,{"C7_XITWBC" ,aProd[nx][8] ,Nil})
                aadd(aLinha,{"C7_QTDSOL" ,VAL(aProd[nX][4]) ,Nil})
                aadd(aLinha,{"C7_XITPEWB" ,aProd[nx][9] ,Nil})
                //aadd(aLinha,{"C7_XTPORIG" ,INT(VAL(cTipoPar)),Nil}) //nCdTipo - Paradigma
                aadd(aLinha,{"C7_XCOTACA" ,cTipoPar,Nil}) //nCdTipo - Paradigma - AJUSTAR CAMPO DICIONARIO criar um campo string
                aadd(aLinha,{"C7_XNCDTIP" ,cTipoPar,Nil})
                aadd(aLinha,{"C7_ORIGEM" ,'WBS',Nil})
                //aadd(aLinha,{"C7_XFLUXO" ,cPedwbc,Nil}) //- CRIAR CAMPO NA BASE PARA ESTA INFRMAÇÃO cPedwbc Marcar o campo ped wbc Conferir
                aadd(aLinha,{"C7_XNPEDWB" ,cPedwbc,Nil}) 
                aadd(aLinha,{"C7_XORIGEM" ,cOrigem,Nil})    
                aadd(aLinha,{"C7_XOPER" ,xOper,Nil})     
                aadd(aLinha,{"C7_DATPRF " ,dDtEntrga,Nil})  
                aadd(aLinha,{"C7_XDTAENT" ,dDtEntrga,Nil})     
                //aadd(aLinha,{"C7_PICM" ,VAL(aProd[nx][13]),Nil}) 
                //aadd(aLinha,{"C7_IPI" ,VAL(aProd[nx][14]),Nil}) 
                //aadd(aLinha,{"C7_ICMSRET" ,aProd[nx][15],Nil}) 
                //aadd(aLinha,{"C7_ALIQISS" ,VAL(aProd[nx][16]),Nil}) 
                aadd(aLinha,{"C7_XGERACT" ,alltrim(cGeracont),Nil})
                aadd(aLinha,{"C7_XPACOTE" ,alltrim(xPacote),Nil})
                If !empty(cdGrpoCom)
                    aadd(aLinha,{"C7_XCOTACA" ,cdGrpoCom,Nil})
                Endif   
                aadd(aLinha,{"C7_XWBSXML" ,cXMLRet,Nil})
                aadd(aItens,aLinha)
        
            Next nX   
        
            aRatPrj:={}
            lMsErroAuto := .F.
            cErroEspParad := ''

            //  MSExecAuto({|v,x,y,z| MATA120(v,x,y,z)},1,aCabec,aItens,3,aRatCC)
            MSExecAuto({|a,b,c,d,e,f,g| MATA120(a,b,c,d,e,f,g)},1,aCabec,aItens,3,.F.)//aRatCC //aRatPrj
            
        
            If !lMsErroAuto
            ConOut("Incluido PC: "+cDoc)
                nNrItem := 1
                DbSelectArea("SC7")
                DbSetOrder(1)
                DbSeek(ALLTRIM(cFilImPa)+cDoc) 
                While !(SC7->(EOF())) .AND. SC7->C7_NUM = cDoc .AND. SC7->C7_FILIAL = ALLTRIM(cFilImPa)
                    RecLock("SC7", .f.)
                        SC7->C7_XWBSXML := cXMLRet
                        nNrItem++
                    MsUnlock() 
                    SC7->(DbSkip())
                END 

                ConfirmSX8()
                RecLock("ZPL", .T.)
                    ZPL->ZPL_DATA   :=date()
                    ZPL->ZPL_HORA   := Time()
                    ZPL->ZPL_TOKEN  := alltrim(cPedido)
                    ZPL->ZPL_FILIAL := xFilial('ZPL') //xFilial(cTabela)
                    ZPL->ZPL_USUARI := 'Schedule'
                    ZPL->ZPL_ROTINA := 'wsActvsPed'
                    ZPL->ZPL_FUNCAO := 'RetornarTodosPedidosEmProcessoDeIntegracao'
                    ZPL->ZPL_ORIGEM := cDoc
                    ZPL->ZPL_MSGLOG := "Pedido incluido com sucesso Pedido Paradigma: "+alltrim(cPedido)+" Pedido Protheus: "+AllTrim(cDoc)
                    ZPL->ZPL_MSGWSF := "Pedido incluido com sucesso Pedido Paradigma: "+alltrim(cPedido)+" Pedido Protheus: "+AllTrim(cDoc)
                    ZPL->ZPL_TSTAMP := GetTimeStamp(DATE())
                    ZPL->ZPL_RETORN := 1
                    ZPL->ZPL_XML := cXMLRet
                MsUnlock()  

            Else
                ConOut("Erro na inclusao!")
                RollBackSX8()
                aerro:= GetAutoGRLog()	
            
                For Nx := 1 To len(aErro)
                    cErro+=aerro[nx]+ Chr(13)+Chr(10)
                Next nX  

                If alltrim(cErroEspParad)<>''
                    cErro := cErroEspParad
                EndIf

                RecLock("ZPL", .T.)
                    ZPL->ZPL_DATA   :=date()
                    ZPL->ZPL_HORA   := Time()
                    ZPL->ZPL_TOKEN  := alltrim(cPedido)
                    ZPL->ZPL_FILIAL := xFilial('ZPL') //xFilial(cTabela)
                    ZPL->ZPL_USUARI := 'Schedule'
                    ZPL->ZPL_ROTINA := 'wsActvsPed'
                    ZPL->ZPL_FUNCAO := 'RetornarTodosPedidosEmProcessoDeIntegracao'
                    ZPL->ZPL_ORIGEM := cDoc
                    ZPL->ZPL_MSGLOG := cErro+" Pedido Paradigma: "+alltrim(cPedido)+" Pedido Protheus: "+AllTrim(cDoc)
                    ZPL->ZPL_MSGWSF := cErro+" Pedido Paradigma: "+alltrim(cPedido)+" Pedido Protheus: "+AllTrim(cDoc)
                    ZPL->ZPL_TSTAMP := GetTimeStamp(DATE())
                    ZPL->ZPL_RETORN := 0
                    ZPL->ZPL_XML := cXMLRet
                MsUnlock() 

                //Chamar o Habilita Pedido da Paradigma 
                pHabiPed(cPcompr, cPedido)
                
            EndIf
        Else
            ConOut("Erro na inclusao, falta de numero Solicitacao ou item da solicitacao!")

            RecLock("ZPL", .T.)
                ZPL->ZPL_DATA   :=date()
                ZPL->ZPL_HORA   := Time()
                ZPL->ZPL_TOKEN  := alltrim(cPedido)
                ZPL->ZPL_FILIAL := xFilial('ZPL')
                ZPL->ZPL_USUARI := 'Schedule'
                ZPL->ZPL_ROTINA := 'wsActvsPed'
                ZPL->ZPL_FUNCAO := 'RetornarTodosPedidosEmProcessoDeIntegracao'
                ZPL->ZPL_ORIGEM := alltrim(cPedido)
                ZPL->ZPL_MSGLOG := "Pedido Paradigma: "+alltrim(cPedido)+" NumSC: "+AllTrim(cCdReqEmp)+" ItemSC: "+AllTrim(cItemEnt)
                ZPL->ZPL_MSGWSF := "Pedido Paradigma: "+alltrim(cPedido)+" NumSC: "+AllTrim(cCdReqEmp)+" ItemSC: "+AllTrim(cItemEnt)
                ZPL->ZPL_TSTAMP := GetTimeStamp(DATE())
                ZPL->ZPL_RETORN := 0
                ZPL->ZPL_XML := cXMLRet
            MsUnlock() 

            //Chamar o Habilita Pedido da Paradigma 
            pHabiPed(cPcompr, cPedido)
        EndIf
        //E0001 - Fim
        cFilAnt :=cFilAux 

    Next nY
    
    
     
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
    cQuery += " WHERE SM0.M0_CODIGO = '01'"
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
    cXML += '      <tem:RetornarTodosPedidosEmProcessoDeIntegracao/>' + CRLF
    cXML += '   </soapenv:Body>' + CRLF
    cXML += '</soapenv:Envelope>'
Return cXML

/*================================================================================================================*\
|| ############################################################################################################## ||
|| # Static Function: CadFornec                                                                                   # ||
|| # Desc: Cadastro do fornecedor.                                                               # ||
|| ############################################################################################################## ||
\*================================================================================================================*/
Static Function CadFornec(cCnpj)

     
    
        Local oLog 		 := Nil
        Local oWsEmpresa := Nil
        Local cCod       := ''
        Local cLoja      := ''
        Local cTipo      := ''

        oLog := FwParLog():New("PAR001", "RetornarEmpresaPorCnpj")
		oWsEmpresa := WSEmpresa():New()

		oWsEmpresa:RetornarEmpresaPorCnpj(AllTrim(cCnpj))

        cCodWBC := oWsEmpresa:oWsRetornarEmpresaPorCnpjResult:NCDEMPRESAWBC

        cCodMun := POSICIONE('CC2', 4, xFilial('CC2')+ oWsEmpresa:oWsRetornarEmpresaPorCnpjResult:csSgEstado+PADR( oWsEmpresa:oWsRetornarEmpresaPorCnpjResult:csNmCidade,tamsx3("CC2_MUN")[1]), 'CC2_CODMUN')
            
            IF oWsEmpresa:oWsRetornarEmpresaPorCnpjResult:NNIDTIPOPESSOA == 0
                
                cCod    := SubStr(cCnpj, 1, 8)
                cLoja   := SubStr(cCnpj, 9, 4)
                cTipo   := 'J'
            Else
                
                cCod    := SubStr(cCnpj, 1, 8)
                cLoja   := '0001'
                cTipo   := 'F'

            Endif

        oModel := FWLoadModel('MATA020')

        oModel:SetOperation(3)
        oModel:Activate()

        //Cabeçalho
        oModel:SetValue('SA2MASTER','A2_COD' ,cCod)
        oModel:SetValue('SA2MASTER','A2_LOJA' ,cLoja)
        oModel:SetValue('SA2MASTER','A2_NOME' ,  oWsEmpresa:oWsRetornarEmpresaPorCnpjResult:CSNMEMPRESA)
        oModel:SetValue('SA2MASTER','A2_NREDUZ' ,oWsEmpresa:oWsRetornarEmpresaPorCnpjResult:CSNMEMPRESA)
        oModel:SetValue('SA2MASTER','A2_END' ,oWsEmpresa:oWsRetornarEmpresaPorCnpjResult:CSDSENDERECO)
        oModel:SetValue('SA2MASTER','A2_BAIRRO' ,oWsEmpresa:oWsRetornarEmpresaPorCnpjResult:CSNMBAIRRO)
        oModel:SetValue('SA2MASTER','A2_EST' ,oWsEmpresa:oWsRetornarEmpresaPorCnpjResult:csSgEstado)
        oModel:SetValue('SA2MASTER','A2_COD_MUN',cCodMun)
        oModel:SetValue('SA2MASTER','A2_MUN' ,oWsEmpresa:oWsRetornarEmpresaPorCnpjResult:csNmCidade)
        oModel:SetValue('SA2MASTER','A2_TIPO' ,cTipo)
        oModel:SetValue('SA2MASTER','A2_CGC' ,cCnpj)
        oModel:SetValue('SA2MASTER','A2_XTPPRST' ,'2')
        oModel:SetValue('SA2MASTER','A2_CEP' ,oWsEmpresa:oWsRetornarEmpresaPorCnpjResult:CSDSCEP)

        If oModel:VldData()
            oModel:CommitData()
        Else
            VarInfo("Erro",oModel:GetErrorMessage()[6])
        Endif

        oModel:DeActivate()

        oModel:Destroy()

        //PeFoDePA(cCod, cLoja, cCodWBC)

  
Return 


/*================================================================================================================*\
|| ############################################################################################################## ||
|| # tatic Function: ExcTit                                                                                   # ||
|| # Desc: excluir titulos provisorios ExcTit.   S                                                            # ||
|| ############################################################################################################## ||
\*================================================================================================================*/
Static Function ExcTit(cContPai,dIniCnt,cItemwbc)


    LOCAL aArray := {}
    Local cNum   := strzero(val(cContPai),tamsx3("E2_NUM")[1]) 
    Local cAlias := GetNextAlias()
    Local cQuery :=''
    Local lmes   :=.t.
    PRIVATE lMsErroAuto := .F.
    

    cQuery += "SELECT * FROM " + RetSqlName("SE2") + " SE2"
    cQuery += " WHERE E2_NUM = '" + cNum + "'"
    cQuery += " AND E2_PREFIXO = 'PRV' " 
    cQuery += " AND E2_VENCTO >= '" + DTOS(dIniCnt) + "'" 
    cQuery += " AND E2_XITWBC = '" + cItemwbc + "'"
    cQuery += "AND SE2.D_E_L_E_T_ <> '*'"
    cQuery += "ORDER BY E2_VENCTO"
    cQuery := ChangeQuery(cQuery)
    
    DbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),cAlias,.F.,.T.)
	(cAlias)->(DbGotop())

    While (cAlias)->(!EoF())

        IF  DTOS(dIniCnt) == (cAlias)->E2_VENCTO  //precisamos validar a data de inicio do contrato se é igual o vencimento 
            
            DbSelectArea("SE2") 
            SE2->(DbSetOrder(1)) ///lusão deve ter o registro SE2 posicionado
            SE2->(DbSeek(xFilial("SE2")+(cAlias)->E2_PREFIXO+(cAlias)->E2_NUM+(cAlias)->E2_PARCELA+(cAlias)->E2_TIPO+(cAlias)->E2_FORNECE+(cAlias)->E2_LOJA))          
                                
            aArray := { { "E2_PREFIXO" , SE2->E2_PREFIXO , NIL },;
                        { "E2_NUM"     , SE2->E2_NUM     , NIL } }
                
            MsExecAuto( { |x,y,z| FINA050(x,y,z)}, aArray,, 5)  // 3 - Inclusao, 4 - Alteração, 5 - Exclusão
                
            If lMsErroAuto
                MostraErro()
            Else
                Alert("Exclusão do Título com sucesso!")
            Endif

             lmes:= .f.
            Exit
        
        EndIF

    (cAlias)->(DbSkip())

    EndDo

    IF lmes //Caso a data de vencimento não seja igual a de inicio do contrato precisamos excluir o titulo do mesmo mês da data de inicio 

        (cAlias)->(DbGotop())
        While (cAlias)->(!EoF())

            IF SUBSTR(DTOS(dIniCnt),1,6) == SUBSTR((cAlias)->E2_VENCTO,1,6)
                
                DbSelectArea("SE2") 
                SE2->(DbSetOrder(1)) ///lusão deve ter o registro SE2 posicionado
                SE2->(DbSeek(xFilial("SE2")+(cAlias)->E2_PREFIXO+(cAlias)->E2_NUM+(cAlias)->E2_PARCELA+(cAlias)->E2_TIPO+(cAlias)->E2_FORNECE+(cAlias)->E2_LOJA))          
                                    
                aArray := { { "E2_PREFIXO" , SE2->E2_PREFIXO , NIL },;
                            { "E2_NUM"     , SE2->E2_NUM     , NIL } }
                    
                MsExecAuto( { |x,y,z| FINA050(x,y,z)}, aArray,, 5)  // 3 - Inclusao, 4 - Alteração, 5 - Exclusão
                    
                If lMsErroAuto
                    MostraErro()
                Else
                    Alert("Exclusão do Título com sucesso!")
                Endif

            EndIF

        (cAlias)->(DbSkip())

        EndDo

    EndIF

Return 



/*================================================================================================================*\
|| ############################################################################################################## ||
|| # Static Function: CadFornec                                                                                   # ||
|| # Desc: Retorno pedido portal paradigma.                                                               # ||
|| ############################################################################################################## ||
\*================================================================================================================*/
user Function RetPed()
   
    Local xRet    := Nil
    Local cLockName := "WsActvs"
    Local cAlias  := GetNextAlias()
    Local cQuery  := ''
    Local lRet   := .F.
    Local cMensagem:= '', cToken := '', cLogMens:=""
    Local cPedAnt := ''
    Local cErro 	:= ""
	Local cAviso 	:= ""
    Local cRetXml:=""
 
    if ValType("cFilAnt") == "C" .and. TCIsConnected() // se ja tem ambiente aberto
        ConOut("Ambiente Protheus aberto e pronto para uso")
    else
        RpcSetEnv("11","02") //Abro o ambiente, pois o mesmo não encontrava-se aberto
    endif

    conout('Eliminando Resíduos ou alterando de data de entrega')
    u_WsCancel2()
    conout('Eliminando Resíduos ou alterando de data de entrega - fim')
 
    conout("INICIO ")

    cQuery += "SELECT  C7_FILIAL,C7_NUM,C7_ITEM,C7_XPEDWBC,C7_XINTPA,C7_QUJE,C7_QUANT  FROM" + RetSqlName("SC7") + " SC7"
    //cQuery += " WHERE C7_CONAPRO <> 'B' " 
    cQuery += " WHERE " 
    cQuery += " (SC7.C7_XPEDWBC  <> '' OR (SC7.C7_ORIGEM = 'EICPO400' AND SC7.C7_CONAPRO <> 'B'))"
    cQuery += " AND SC7.D_E_L_E_T_ <> '*'"
    cQuery += " AND C7_XINTPA = '2'"
    //cQuery += " AND C7_XINTPA = '2' OR (C7_XINTPA = '3' AND C7_QUJE > 0 AND SC7.C7_ORIGEM <> 'EICPO400') OR (C7_XINTPA = '5' AND C7_QUJE >= C7_QUANT AND SC7.C7_ORIGEM <> 'EICPO400') "
    cQuery += " ORDER BY C7_FILIAL,C7_NUM,C7_ITEM,C7_XPEDWBC "

    cQuery := ChangeQuery(cQuery)
    
    DbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),cAlias,.F.,.T.)
	(cAlias)->(DbGotop())

    While (cAlias)->(!EoF())
        If cPedAnt <> (cAlias)->C7_NUM
            cRetXml:=""
            cToken:=""
            xRet:=""
            //Atualiza STATUS pedido Portal Paradigma para integrado
            If (cAlias)->C7_XINTPA == '2'
                xRet := U_AtuPedPa((cAlias)->C7_NUM,(cAlias)->C7_ITEM, (cAlias)->C7_FILIAL,'1')
                cRetXml:=xRet
                oXmlDoc := XmlParser( xRet, "_", @cErro, @cAviso )
                If oXmlDoc <> Nil
                    xRet := oXmlDoc
                Else
                    //Retorna falha no parser do XML
                    xRet := "ProcessarPedido: Falha ao interpretar xml de retorno"
                EndIf
            endif    
            cPedAnt := (cAlias)->C7_NUM
        Endif
		
        If !(valtype(xRet) == 'O')
            lRet := .F.
            
            If valtype(xRet)='L'
                cMensagem := ' Pedidos com problemas no xml - Provavelmente existem caracteres especiais'
            else
                cMensagem := 'Verificar Dados no Banco.'    
            endif
        Else
            lRet := .T.
            cMensagem := Iif(ValType(cRetXml)=="C",cRetXml,"Erro no formato do xml.")
            cToken := xRet:_S_ENVELOPE:_S_BODY:_PROCESSARPEDIDOALTERACAORESPONSE:_PROCESSARPEDIDOALTERACAORESULT:_A_SNRTOKEN:TEXT
        EndIf
        
        IF lRet
            IF xRet:_S_ENVELOPE:_S_BODY:_PROCESSARPEDIDOALTERACAORESPONSE:_PROCESSARPEDIDOALTERACAORESULT:_A_NIDRETORNO:TEXT == '0'
                //Mensagem que pega o log de erro do xml
                cLogMens := xRet:_S_ENVELOPE:_S_BODY:_PROCESSARPEDIDOALTERACAORESPONSE:_PROCESSARPEDIDOALTERACAORESULT:_A_LSTWBTLOGDTO:_A_WBTLOGDTO:_A_sdsLog:TEXT
                cToken := xRet:_S_ENVELOPE:_S_BODY:_PROCESSARPEDIDOALTERACAORESPONSE:_PROCESSARPEDIDOALTERACAORESULT:_A_SNRTOKEN:TEXT
                RecLock("ZPL", .T.)
                    ZPL->ZPL_DATA   :=date()
                    ZPL->ZPL_HORA   := Time()
                    ZPL->ZPL_TOKEN  := cToken
                    ZPL->ZPL_FILIAL := (cAlias)->C7_FILIAL
                    ZPL->ZPL_USUARI := 'Schedule'
                    ZPL->ZPL_ROTINA := 'wsActvsPed'
                    ZPL->ZPL_FUNCAO := 'ProcessarPedidoAlteracao'
                    ZPL->ZPL_ORIGEM := ''
                    ZPL->ZPL_MSGLOG := 'Erro na integração não integrado ' + 'Pedido Wbc:'+(cAlias)->C7_XPEDWBC + 'Pedido ERP:'+(cAlias)->C7_NUM + " Item " + (cAlias)->C7_ITEM
                    ZPL->ZPL_MSGWSF := 'Erro na integração não integrado ' + 'Pedido Wbc:'+(cAlias)->C7_XPEDWBC + 'Pedido ERP:'+(cAlias)->C7_NUM + " - " + cLogMens
                    ZPL->ZPL_TSTAMP := GetTimeStamp(DATE())
                    ZPL->ZPL_RETORN := 0
                    ZPL->ZPL_XML := cMensagem
                MsUnlock()
            Else
                //If (cAlias)->C7_XINTPA == '2'
                dbselectArea("SC7")
                DbSetOrder(1) 
                if DbSeek((cAlias)->C7_FILIAL+(cAlias)->C7_NUM+(cAlias)->C7_ITEM) 
                    IF SC7->C7_CONAPRO <> 'B' 
                        RecLock("SC7", .F.)
                        SC7->C7_XINTPA := '3'
                        MsUnlock()
                    ENDIF
                Endif
                /*Else
                    lTotal := verifItens(Alltrim((cAlias)->C7_FILIAL), (cAlias)->C7_NUM,(cAlias)->C7_ITEM)
                    dbselectArea("SC7")
                    DbSetOrder(1) //A2_FILIAL+A2_CGC
                    if DbSeek((cAlias)->C7_FILIAL+(cAlias)->C7_NUM+(cAlias)->C7_ITEM) 
                        RecLock("SC7", .F.)
                            SC7->C7_XINTPA := iif(lTotal,'4','5')
                        MsUnlock()
                    Endif
                EndIf*/    

                RecLock("ZPL", .T.)
                ZPL->ZPL_DATA   :=date()
                ZPL->ZPL_HORA   := Time()
                ZPL->ZPL_TOKEN  := cToken
                ZPL->ZPL_FILIAL := (cAlias)->C7_FILIAL
                ZPL->ZPL_USUARI := 'Schedule'
                ZPL->ZPL_ROTINA := 'wsActvsPed'
                ZPL->ZPL_FUNCAO := 'ProcessarPedidoAlteracao'
                ZPL->ZPL_ORIGEM := ''
                ZPL->ZPL_MSGLOG := 'Integrado ' + 'Pedido Wbc:'+(cAlias)->C7_XPEDWBC + 'Pedido ERP:'+(cAlias)->C7_NUM + " Item " + (cAlias)->C7_ITEM
                ZPL->ZPL_MSGWSF := 'Integrado ' + 'Pedido Wbc:'+(cAlias)->C7_XPEDWBC + 'Pedido ERP:'+(cAlias)->C7_NUM + " Item " + (cAlias)->C7_ITEM + " - Token : " + cToken
                ZPL->ZPL_TSTAMP := GetTimeStamp(DATE())
                ZPL->ZPL_RETORN := 1
                ZPL->ZPL_XML := cMensagem
                MsUnlock()
            Endif
        ELSE
            RecLock("ZPL", .T.)
                    ZPL->ZPL_DATA   :=date()
                    ZPL->ZPL_HORA   := Time()
                    ZPL->ZPL_TOKEN  := ''
                    ZPL->ZPL_FILIAL := (cAlias)->C7_FILIAL
                    ZPL->ZPL_USUARI := 'Schedule'
                    ZPL->ZPL_ROTINA := 'wsActvsPed'
                    ZPL->ZPL_FUNCAO := 'ProcessarPedidoAlteracao'
                    ZPL->ZPL_ORIGEM := ''
                    ZPL->ZPL_MSGLOG := 'Erro na integração não integrado ' + 'Pedido Wbc:'+(cAlias)->C7_XPEDWBC + 'Pedido ERP:'+(cAlias)->C7_NUM + " Item " + (cAlias)->C7_ITEM
                    ZPL->ZPL_MSGWSF := 'Erro na integração não integrado ' + 'Pedido Wbc:'+(cAlias)->C7_XPEDWBC + 'Pedido ERP:'+(cAlias)->C7_NUM + " - " + 'Erro de xml' + cMensagem
                    ZPL->ZPL_TSTAMP := GetTimeStamp(DATE())
                    ZPL->ZPL_RETORN := 0
                    ZPL->ZPL_XML := cMensagem
                MsUnlock()
        ENDIF
      
        // Início - Semáforo de controle de execução simultânea
        If !LockByName(cLockName,.T.,.T.)
            MsgInfo("Rotina já está sendo executada por outro usuário","Atenção"+Procname())
            Return .F.
        EndIf

        // Fim - Semáforo de controle de execução simultânea
        UnLockByName(cLockName,.T.,.T.)
   
      (cAlias)->(DbSkip())
    EndDo

    /*    
    IF IsBlind()
        RpcClearEnv()
    Endif
   */ 
    conout("FIM ")

Return 

//Verifica status nota
Static Function verifItens(cFilSC7, cNumSC7 , cItemPed)
	Local aArea 	:= GetArea()
	Local lRet		:= .T.

	dbselectArea("SC7")
	DbSetOrder(1) //A2_FILIAL+A2_CGC
	if DbSeek(cFilSC7+cNumSC7+cItemPed)

		If(SC7->C7_QUJE < SC7->C7_QUANT .AND. SC7->C7_RESIDUO <> 'S' .AND. SC7->C7_ENCER <> 'E')
			lRet := .F.
		EndIf

	Endif
	RestArea(aArea)
Return lRet

/*================================================================================================================*\
|| ############################################################################################################## ||
|| # Static Function: pHabiPed                                                                                 # ||
|| # Desc: Habilita pedido Paradigma            .                                                               # ||
|| ############################################################################################################## ||
\*================================================================================================================*/
static Function pHabiPed(cUsu, cPedWS)
   


    Local lRet    := Nil
    Local oWsdl   := Nil
    Local cXMLRet := ""
    Local cLockName := "WsActvs"
    
    /*
    IF IsBlind()
        RpcSetEnv("11","02")
    Endif
    */
    // Conexão com o WebService \\
    oWsdl := TWsdlManager():New()
	oWsdl:AddHttpHeader("Authorization", "Bearer " + U_NewToken())
    oWsdl:lSSLInsecure := .T.  
    oWsdl:nTimeout     := 120
    oWsdl:nSSLVersion  := 0
    xRet := oWsdl:ParseURL(AllTrim(GetMv("MV_XPARURL"))+'/services/Pedido.svc?wsdl')
    
    If xRet == .F.
        ConOut("WsActvs - Erro ParseURL: " + oWsdl:cError)
        Return
    EndIf
    
    // Definição da operação \\
    lRet := oWsdl:SetOperation("HabilitarRetornarPedidoEmProcessoDeIntegracao")
    If lRet == .F.
        ConOut("WsActvs - Erro SetOperation: " + oWsdl:cError)
        Return
    EndIf
    
    cXml:= ''
    cXml+=' <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/" xmlns:par="http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO">'
    cXml+="   <soapenv:Header/>"
    cXml+="   <soapenv:Body>"
    cXml+="     <tem:HabilitarRetornarPedidoEmProcessoDeIntegracao>"
    //cXml+="       <tem:lstPedidoHabilitarDTO xmlns:i='http://www.w3.org/2001/XMLSchema-instance'>"
    cXml+="       <tem:lstPedidoHabilitarDTO>"
    cXml+="         <par:PedidoHabilitarDTO>"
    cXml+="           <par:nCdPedido>" + cPedWS + "</par:nCdPedido>"
    cXml+="           <par:sCdComprador>"+cUsu+"</par:sCdComprador>"
    cXml+="         </par:PedidoHabilitarDTO>"
    cXml+="       </tem:lstPedidoHabilitarDTO>"
    cXml+="     </tem:HabilitarRetornarPedidoEmProcessoDeIntegracao>"
    cXml+="   </soapenv:Body>"
    cXml+=" </soapenv:Envelope>"
    
    lRet := oWsdl:SendSoapMsg(cXml)
    cXMLRet := oWsdl:GetSoapResponse()"
        
    If lRet == .F.
        
        RecLock("ZPL", .T.)
            ZPL->ZPL_DATA   :=date()
            ZPL->ZPL_HORA   := Time()
            ZPL->ZPL_TOKEN  := cPedWS
            ZPL->ZPL_FILIAL := xFilial('ZPL') 
            ZPL->ZPL_USUARI := 'Schedule'
            ZPL->ZPL_ROTINA := 'wsActvsPed'
            ZPL->ZPL_FUNCAO := 'HabilitaPedidoPortal'
            ZPL->ZPL_ORIGEM := ""
            ZPL->ZPL_MSGLOG := 'NAO FOI POSSIVEL VOLTAR PEDIDO PARA STATUS DE A IMPORTAR PORTAL PARADIGMA'
            ZPL->ZPL_MSGWSF := 'NAO FOI POSSIVEL VOLTAR PEDIDO PARA STATUS DE A IMPORTAR PORTAL PARADIGMA'
            ZPL->ZPL_TSTAMP := GetTimeStamp(DATE())
            ZPL->ZPL_RETORN := 0
            ZPL->ZPL_XML := cXMLRet
        MsUnlock() 
    else
        RecLock("ZPL", .T.)
            ZPL->ZPL_DATA   :=date()
            ZPL->ZPL_HORA   := Time()
            ZPL->ZPL_TOKEN  := cPedWS
            ZPL->ZPL_FILIAL := xFilial('ZPL') 
            ZPL->ZPL_USUARI := 'Schedule'
            ZPL->ZPL_ROTINA := 'wsActvsPed'
            ZPL->ZPL_FUNCAO := 'HabilitaPedidoPortal'
            ZPL->ZPL_ORIGEM := ""
            ZPL->ZPL_MSGLOG := 'PEDIDO RETORNA PARA STATUS DE A IMPORTAR NO PORTAL PARADIGMA'
            ZPL->ZPL_MSGWSF := 'PEDIDO RETORNA PARA STATUS DE A IMPORTAR NO PORTAL PARADIGMA'
            ZPL->ZPL_TSTAMP := GetTimeStamp(DATE())
            ZPL->ZPL_RETORN := 1
            ZPL->ZPL_XML := cXMLRet
        MsUnlock() 
    EndIf
        
    // Início - Semáforo de controle de execução simultânea
    If !LockByName(cLockName,.T.,.T.)
        MsgInfo("Rotina já está sendo executada por outro usuário","Atenção"+Procname())
        Return .F.
    EndIf

    // Fim - Semáforo de controle de execução simultânea
    UnLockByName(cLockName,.T.,.T.)

    /*
    IF isblind()
        RpcClearEnv()
    Endif
    */
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



Static function ReTiGraf(_sOrig)
   local _sRet := _sOrig
   _sRet := strtran (_sRet, "á", "a")
   _sRet := strtran (_sRet, "é", "e")
   _sRet := strtran (_sRet, "í", "i")
   _sRet := strtran (_sRet, "ó", "o")
   _sRet := strtran (_sRet, "ú", "u")
   _SRET := STRTRAN (_SRET, "Ý", "A")
   _SRET := STRTRAN (_SRET, "É", "E")
   _SRET := STRTRAN (_SRET, "Ý", "I")
   _SRET := STRTRAN (_SRET, "Ó", "O")
   _SRET := STRTRAN (_SRET, "Ú", "U")
   _sRet := strtran (_sRet, "ã", "a")
   _sRet := strtran (_sRet, "õ", "o")
   _SRET := STRTRAN (_SRET, "Ã", "A")
   _SRET := STRTRAN (_SRET, "Õ", "O")
   _sRet := strtran (_sRet, "â", "a")
   _sRet := strtran (_sRet, "ê", "e")
   _sRet := strtran (_sRet, "î", "i")
   _sRet := strtran (_sRet, "ô", "o")
   _sRet := strtran (_sRet, "û", "u")
   _SRET := STRTRAN (_SRET, "Â", "A")
   _SRET := STRTRAN (_SRET, "Ê", "E")
   _SRET := STRTRAN (_SRET, "Î", "I")
   _SRET := STRTRAN (_SRET, "Ô", "O")
   _SRET := STRTRAN (_SRET, "Û", "U")
   _sRet := strtran (_sRet, "ç", "c")
   _sRet := strtran (_sRet, "Ç", "C")
   _sRet := strtran (_sRet, "à", "a")
   _sRet := strtran (_sRet, "À", "A")
   _sRet := strtran (_sRet, "º", ".")
   _sRet := strtran (_sRet, "ª", ".")
   _sRet := strtran (_sRet, "&", "e")
   _sRet := strtran (_sRet, "°", ".")
   _sRet := strtran (_sRet, "´", ".")
   _sRet := strtran (_sRet, chr (9), " ") // TAB
   _sRet := FwNoAccent( _sRet )
return _sRet



/*/{Protheus.doc} WsAtuDatEn
//Atualiza data do pedido
@author Administrator
@since 02/05/2018
@version 1.0
@param oProcess, object, objeto tNewProccess
@type function
/*/
user Function WsAtuDatEn()

    conout('Eliminando Resíduos ou alterando de data de entrega')
    u_WsCancel2()
    conout('Eliminando Resíduos ou alterando de data de entrega - fim')

	//Dados da configuração de Proxy no Configurador
	/*Local lProxy     := ( FWSFPolice("COMUNICATION", "USR_PROXY") == "T" )
	Local cPrxServer := Alltrim( FWSFPolice("COMUNICATION", "USR_PROXYIP") )
	Local nPrxPort   := Val( FWSFPolice("COMUNICATION", "USR_PROXYPORT") )
	Local cPrxUser   := Alltrim( FWSFPolice("COMUNICATION", "USR_PROXYLOGON") )

	Local oWsdl
	Local xRet
	Local cErro 	:= ""
	Local cAviso 	:= ""
	Local aOps 		:= {}
	Local Oobj       
    Local oRet 
    Local Cped     := ''
    Local cItem    := ''
    Local dDtEntrga := ''
    Local nItem    := ''
    Local nx := 0
    Local ny := 0
    Local cMensagem := ""
   
	Local cURL 		:= ''
	Private nPed	:= ''

    RpcSetEnv("11","02")

    conout("INICIO ")

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

	if Len( aOps ) == 0
		//Return "Não existem operações"
	endif

	//varinfo( "", aOps )

	// Define a operação
	xRet := oWsdl:SetOperation( "RetornarPedidoAtualizadoNoPortal" )
	if xRet == .F.
		//Return "Não foi possivel executar a operacao RetornarRequisicaoAlteracaoComprador"
	endif

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

		RecLock("ZPL", .T.)
			ZPL->ZPL_DATA   :=date()
			ZPL->ZPL_HORA   := Time()
			ZPL->ZPL_TOKEN  := ''
			ZPL->ZPL_FILIAL := xFilial('ZPL') //xFilial(cTabela)
			ZPL->ZPL_USUARI := 'Schedule'
			ZPL->ZPL_ROTINA := 'Par001'
			ZPL->ZPL_FUNCAO := 'RetornarPedidoAtualizadoNoPortal'
			ZPL->ZPL_ORIGEM := ""
			ZPL->ZPL_MSGLOG := 'Nennhum pedido alterado ' 
			ZPL->ZPL_MSGWSF := 'Nennhum pedido alterado ' 
			ZPL->ZPL_TSTAMP := GetTimeStamp(DATE())
			ZPL->ZPL_RETORN := 1
            ZPL->ZPL_XML	:= Iif(ValType(xRet)=="C",xRet,cMensagem)
        MsUnlock()  
		
        
	elseif(!Empty(oWsdl:cError) .OR. !Empty(GetSimples( xRet, '<faultcode', '</faultcode>' )))
		//xRet := {oWsdl:cFaultCode, oWsdl:cError, xRet}
        ZPL->ZPL_DATA   :=date()
			ZPL->ZPL_HORA   := Time()
			ZPL->ZPL_TOKEN  := ''
			ZPL->ZPL_FILIAL := xFilial('ZPL') //xFilial(cTabela)
			ZPL->ZPL_USUARI := 'Schedule'
			ZPL->ZPL_ROTINA := 'Par001'
			ZPL->ZPL_FUNCAO := 'RetornarPedidoAtualizadoNoPortal'
			ZPL->ZPL_ORIGEM := ""
			ZPL->ZPL_MSGLOG := 'Erro no xml ' 
			ZPL->ZPL_MSGWSF := 'erro no xml ' 
			ZPL->ZPL_TSTAMP := GetTimeStamp(DATE())
			ZPL->ZPL_RETORN := 0
            ZPL->ZPL_XML	:= Iif(ValType(xRet)=="C",xRet,cMensagem)
	Else
	
    	oXmlDoc := XmlParser( xRet, "_", @cErro, @cAviso )

		oRet := oXmlDoc:_S_ENVELOPE:_S_BODY:_RetornarPedidoAtualizadoNoPortalResponse:_RetornarPedidoAtualizadoNoPortalResult:_A_PedidoDTO
    // pedido, identifica se é 1 ou mais que 1 \\
        /*
        If ValType(oRet) == "A"
            cLenped := Len(oRet)
        Else
            cLenped := 1
        EndIf    
        
        */
        /*
        Oobj :=  oXmlDoc:_S_ENVELOPE:_S_BODY:_RetornarPedidoAtualizadoNoPortalResponse:_RetornarPedidoAtualizadoNoPortalResult:_A_PEDIDODTO
        
        If ValType(Oobj) == "A"
            cLenCntr := Len(Oobj)
        Else
            cLenCntr := 1
        EndIf

    
        For nx := 1  to cLenCntr
            /*
            If val(nQuantIT) > 1 .and. ValType(OAUXCNT:_A_LSTPEDIDOITEM:_A_PEDIDOITEMDTO[nx]:_A_LSTPEDIDOITEMENTREGA:_A_PEDIDOITEMENTREGADTO:_A_TDTENTREGA) == 'A'
                dDtEntrga:= Oobj:_A_LSTPEDIDOITEM:_A_PEDIDOITEMDTO[nx]:_A_LSTPEDIDOITEMENTREGA:_A_PEDIDOITEMENTREGADTO[nx]:_A_TDTENTREGA:TEXT
            else
                dDtEntrga:= OAUXCNT:_A_LSTPEDIDOITEM:_A_PEDIDOITEMDTO[nx]:_A_LSTPEDIDOITEMENTREGA:_A_PEDIDOITEMENTREGADTO:_A_TDTENTREGA:TEXT
            EndIf
              */  
            /*
            IF cLenCntr <> 1 
               // dDtEntrga:= Oobj:_A_PEDIDODTO[nx]:_A_LSTPEDIDOITEM:_A_PEDIDOITEMDTO:_A_LSTPEDIDOITEMENTREGA:_A_PEDIDOITEMENTREGADTO:_A_TDTENTREGA:TEXT
                dDtEntrga:= Oobj[nx]:_A_LSTPEDIDOITEM:_A_PEDIDOITEMDTO:_A_LSTPEDIDOITEMENTREGA:_A_PEDIDOITEMENTREGADTO:_A_tDtEntregaConfirmada:TEXT
                dDtEntrga:=  CToD(SubStr(dDtEntrga,9,2) + "/" + SubStr(dDtEntrga,6,2) + "/" + SubStr(dDtEntrga,1,4))
    
                Cped     := Oobj[nx]:_A_SCDPEDIDOERP:TEXT 
                cItem    := Oobj[nx]:_A_LSTPEDIDOITEM:_A_PEDIDOITEMDTO:_A_SCDITEMEMPRESA:TEXT
            
                DbSelectArea('SC7')
                DbSetOrder(1)
                IF DbSeek('02'+Cped+cItem)
                    RecLock("SC7", .f.)
                    // SC7->C7_QUANT   := VAL(nQuantIT)
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
                                ZPL->ZPL_MSGLOG := 'Data de entrega alterada no pedido '+ Cped + ' Item ' + cItem
                                ZPL->ZPL_MSGWSF := 'Data de entrega alterada no pedido '+ Cped + ' Item ' + cItem
                                ZPL->ZPL_TSTAMP := GetTimeStamp(DATE())
                                ZPL->ZPL_RETORN := 1
                                ZPL->ZPL_XML	:= Iif(ValType(xRet)=="C",xRet,cMensagem)
                     MsUnlock()  
                        
                
                EndIF
            Else
                
                if ValType(Oobj:_A_LSTPEDIDOITEM:_A_PEDIDOITEMDTO) == "A"
                    nItem := len(Oobj:_A_LSTPEDIDOITEM:_A_PEDIDOITEMDTO)
                Else
                    nItem := 1
                Endif

                IF nitem > 1 

                    for ny := 1 to  nItem

                        dDtEntrga:= Oobj:_A_LSTPEDIDOITEM:_A_PEDIDOITEMDTO[ny]:_A_LSTPEDIDOITEMENTREGA:_A_PEDIDOITEMENTREGADTO:_A_tDtEntregaConfirmada:TEXT

                        dDtEntrga:=  CToD(SubStr(dDtEntrga,9,2) + "/" + SubStr(dDtEntrga,6,2) + "/" + SubStr(dDtEntrga,1,4))
            
                        Cped     := Oobj:_A_SCDPEDIDOERP:TEXT 
                        cItem    := Oobj:_A_LSTPEDIDOITEM:_A_PEDIDOITEMDTO[ny]:_A_SCDITEMEMPRESA:TEXT
                    
                        DbSelectArea('SC7')
                        DbSetOrder(1)
                        IF DbSeek('02'+Cped+cItem)
                            RecLock("SC7", .f.)
                            // SC7->C7_QUANT   := VAL(nQuantIT)
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
                                ZPL->ZPL_MSGLOG := 'Data de entrega alterada no pedido '+ Cped + ' Item ' + cItem
                                ZPL->ZPL_MSGWSF := 'Data de entrega alterada no pedido '+ Cped + ' Item ' + cItem
                                ZPL->ZPL_TSTAMP := GetTimeStamp(DATE())
                                ZPL->ZPL_RETORN := 1
                                ZPL->ZPL_XML	:= Iif(ValType(xRet)=="C",xRet,cMensagem)
                            MsUnlock()  
                        
                        EndIF
                    next ny
                ELSE 

                        
                        dDtEntrga:= Oobj:_A_LSTPEDIDOITEM:_A_PEDIDOITEMDTO:_A_LSTPEDIDOITEMENTREGA:_A_PEDIDOITEMENTREGADTO:_A_tDtEntregaConfirmada:TEXT

                        dDtEntrga:=  CToD(SubStr(dDtEntrga,9,2) + "/" + SubStr(dDtEntrga,6,2) + "/" + SubStr(dDtEntrga,1,4))
            
                        Cped     := Oobj:_A_SCDPEDIDOERP:TEXT 
                        cItem    := Oobj:_A_LSTPEDIDOITEM:_A_PEDIDOITEMDTO:_A_SCDITEMEMPRESA:TEXT
                    
                        DbSelectArea('SC7')
                        DbSetOrder(1)
                        IF DbSeek('02'+Cped+cItem)
                            RecLock("SC7", .f.)
                            // SC7->C7_QUANT   := VAL(nQuantIT)
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
                                ZPL->ZPL_MSGLOG := 'Data de entrega alterada no pedido '+ Cped + ' Item ' + cItem
                                ZPL->ZPL_MSGWSF := 'Data de entrega alterada no pedido '+ Cped + ' Item ' + cItem
                                ZPL->ZPL_TSTAMP := GetTimeStamp(DATE())
                                ZPL->ZPL_RETORN := 1
                                ZPL->ZPL_XML	:= Iif(ValType(xRet)=="C",xRet,cMensagem)
                            MsUnlock()  
                        
                        Endif
                ENDIF

            endif
		next nx 

	EndIf

    /*
    IF isblind()
        RpcClearEnv()
    Endif
*/
     conout("FIM ")

Return 



/*================================================================================================================*\
|| ############################################################################################################## ||
|| # Static Function: pHabiPed                                                                                 # ||
|| # Desc: Habilita pedido Paradigma            .                                                               # ||
|| ############################################################################################################## ||
\*================================================================================================================*/
user Function envcan()
   
    Local lRet    := Nil
    Local oWsdl   := Nil
    Local cXMLRet := ""
    Local cLockName := "WsActvs - envcan"
    Local cAlias    := GetNextAlias()
    Local oXmldoc   
    Local cErro     := ''
    Local cAviso    := ''
    
 
    if ValType("cFilAnt") == "C" .and. TCIsConnected() // se ja tem ambiente aberto
        ConOut("Ambiente Protheus aberto e pronto para uso")
    else
        RpcSetEnv("11","02") //Abro o ambiente, pois o mesmo não encontrava-se aberto
    endif
   

    // Conexão com o WebService \\
    oWsdl := TWsdlManager():New()
    oWsdl:lSSLInsecure := .T.
    oWsdl:nTimeout     := 120
    oWsdl:nSSLVersion  := 0
	oWsdl:AddHttpHeader("Authorization", "Bearer " + U_NewToken())
    xRet := oWsdl:ParseURL(AllTrim(GetMv("MV_XPARURL"))+'/services/Pedido.svc?wsdl')
    
    If xRet == .F.
        ConOut("WsActvs - Erro ParseURL: " + oWsdl:cError)
        Return
    EndIf
    
    // Definição da operação \\
    lRet := oWsdl:SetOperation("ProcessarPedidoCancelamento")
    If lRet == .F.
        ConOut("WsActvs - Erro SetOperation: " + oWsdl:cError)
        Return
    EndIf
    

    cQuery := ''
    cQuery += "SELECT * FROM " + RetSqlName("SC7") + " SC7"
    cQuery += " WHERE C7_RESIDUO = 'S'"
    cQuery += " AND SC7.D_E_L_E_T_ <> '*'"
    cQuery += " AND SC7.C7_XINTPA  <> '1' "
    cQuery += " AND SC7.C7_EMISSAO >= '20210628'"
    cQuery += " AND SC7.C7_XCONTRA  = '' "
    cQuery := ChangeQuery(cQuery)
    
    DbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),cAlias,.F.,.T.)
	(cAlias)->(DbGotop())

    While (cAlias)->(!EoF())

        cFilAnt := (cAlias)->C7_FILIAL

        cXml :=''
        cXml+=' <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/" xmlns:par="http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO">'
        cXml+="   <soapenv:Header />                                                                                                                                                                     "
        cXml+="   <soapenv:Body>                                                                                                                                                                         "
        cXml+="      <tem:ProcessarPedidoCancelamento>                                                                                                                                                   "
        cXml+="         <!--Optional:-->                                                                                                                                                                 "
        cXml+="         <tem:lstPedidoAtualizarDTO>                                                                                                                                                      "
        cXml+="            <!--Zero or more repetitions:-->                                                                                                                                              "
        cXml+="            <par:PedidoAtualizarDTO>                                                                                                                                                      "
        cXml+="               <!--Optional:-->                                                                                                                                                           "
        cXml+="               <par:nCdSituacao>4</par:nCdSituacao>                                                                                                                                       "
        cXml+="               <!--Optional:-->                                                                                                                                                           "
        cXml+="               <par:sCdComprador>" + AllTrim(GetMv('MV_XMATCNP'))  + "</par:sCdComprador>                                                                                                                        "
        cXml+="               <par:sCdPedidoErp>" +  (cAlias)->C7_NUM + "</par:sCdPedidoErp>                                                                                                                                "
        cXml+="            </par:PedidoAtualizarDTO>                                                                                                                                                     "
        cXml+="         </tem:lstPedidoAtualizarDTO>                                                                                                                                                     "
        cXml+="      </tem:ProcessarPedidoCancelamento>                                                                                                                                                  "
        cXml+="   </soapenv:Body>                                                                                                                                                                        "
        cXml+="</soapenv:Envelope>                                                                                                                                                                     "


        lRet := oWsdl:SendSoapMsg(cXml)
        cXMLRet := oWsdl:GetSoapResponse()

        oXmldoc := XmlParser( cXMLRet, "_", @cErro, @cAviso )    
        If oxmldoc:_s_envelope:_s_body:_ProcessarPedidoCancelamentoResponse:_ProcessarPedidoCancelamentoResult:_A_NIDRETORNO:TEXT == '0'
            
            RecLock("ZPL", .T.)
                ZPL->ZPL_DATA   :=date()
                ZPL->ZPL_HORA   := Time()
                ZPL->ZPL_TOKEN  := (cAlias)->C7_NUM
                ZPL->ZPL_FILIAL := xFilial('ZPL') 
                ZPL->ZPL_USUARI := 'Schedule'
                ZPL->ZPL_ROTINA := 'wsActvsPed'
                ZPL->ZPL_FUNCAO := 'ProcessarPedidoCancelamento'
                ZPL->ZPL_ORIGEM := ""
                ZPL->ZPL_MSGLOG := cXMLRet
                ZPL->ZPL_MSGWSF := cXMLRet
                ZPL->ZPL_TSTAMP := GetTimeStamp(DATE())
                ZPL->ZPL_RETORN := 0
                ZPL->ZPL_XML := cXMLRet
            MsUnlock() 
        else
            RecLock("ZPL", .T.)
                ZPL->ZPL_DATA   :=date()
                ZPL->ZPL_HORA   := Time()
                ZPL->ZPL_TOKEN  := (cAlias)->C7_NUM
                ZPL->ZPL_FILIAL := xFilial('ZPL') 
                ZPL->ZPL_USUARI := 'Schedule'
                ZPL->ZPL_ROTINA := 'wsActvsPed'
                ZPL->ZPL_FUNCAO := 'ProcessarPedidoCancelamento'
                ZPL->ZPL_ORIGEM := ""
                ZPL->ZPL_MSGLOG := cXMLRet
                ZPL->ZPL_MSGWSF := cXMLRet
                ZPL->ZPL_TSTAMP := GetTimeStamp(DATE())
                ZPL->ZPL_RETORN := 1
                ZPL->ZPL_XML := cXMLRet
            MsUnlock() 
        
            
                DbSelectArea('SC7')
                DbSetOrder(1)
                IF DbSeek((cAlias)->C7_FILIAL+(cAlias)->C7_NUM +(cAlias)->C7_ITEM )
                RecLock("SC7", .f.)
                        // SC7->C7_QUANT   := VAL(nQuantIT)
                    SC7->C7_XINTPA  := '1'
                MsUnlock() 
            Endif
        
        EndIf


        (cAlias)->(DbSkip())
	EndDo


    // Início - Semáforo de controle de execução simultânea
    If !LockByName(cLockName,.T.,.T.)
        MsgInfo("Rotina já está sendo executada por outro usuário","Atenção"+Procname())
        Return .F.
    EndIf

    // Fim - Semáforo de controle de execução simultânea
    UnLockByName(cLockName,.T.,.T.)

    /*
    if isblind()
       RpcClearEnv()
    endif
   */
    conout("FIM ")
Return 


static function cFilGet(xcnpj)

    Local aList := FWLoadSM0()
    Local xFil := ''
    Local x := 0

    For  x:=1 to len(aList)

        IF aList[x][18] == xcnpj      

            xFil:= aList[x][5]
            Return xFil
        
        Endif 

    next x


Return xFil

User Function xhabped()

Local nOpca     := 0
Local cPedPar   := Space(6)
Local cCnpjCo   := Space(14)
Local cQry      := ''
Local cAlias    := GetNextAlias()
Local nTotal    := 0

		DEFINE MSDIALOG oMkwdlg FROM 050,116 TO 250,500 TITLE "Habilitar Pedido" PIXEL
		@ 010,010 SAY "Pedido Paradigma:"   Size 75,07  OF oMkwdlg PIXEL
        @ 017,010 MSGET cPedPar             Size 100,10 OF oMkwdlg PIXEL PICTURE "@R 999999" VALID !Vazio(cPedPar)
		//@ 017,010 MSGET cPedPar F3 "SC7"  Size 100,10 OF oMkwdlg PIXEL 
		@ 040,010 SAY "CNPJ Comprador:"     Size 75,07  OF oMkwdlg PIXEL
	    @ 047,010 MSGET cCnpjCo        Size 100,10 OF oMkwdlg PIXEL PICTURE "@R 99.999.999/9999-99" VALID !Vazio(cCnpjCo)

		DEFINE SBUTTON FROM 75, 060 TYPE 1 ACTION (nOpca:=1,oMkwdlg:End()) ENABLE OF oMkwdlg PIXEL
		DEFINE SBUTTON FROM 75, 110 TYPE 2 ACTION (nOpca:=2,oMkwdlg:End()) ENABLE OF oMkwdlg PIXEL
		ACTIVATE MSDIALOG oMkwdlg CENTERED
		
		If Empty(cPedPar) .or. Empty(cCnpjCo)
                MsgAlert("Favor preencher todos os campos", "Campo Obrigatório")
                Return
        EndIf

        if nOpca == 1

            cQry+= "SELECT C7_FILIAL, C7_XPEDWBC, C7_XINTPA, D_E_L_E_T_  FROM " + RetSqlName("SC7") + " SC7"
            cQry+= "WHERE SC7.C7_XPEDWBC = '" + Alltrim(cPedPar) + "'"
            cQry+= "AND SC7.C7_FILIAL = '"+ xFilial("SC7") + "'"
            cQry+= "AND SC7.D_E_L_E_T_ <> '*'"
            
            cQry:= ChangeQuery(cQry)
            
            If Select(cAlias) <> 0
                (cAlias)->(dbCloseArea())
            Endif

            DbUseArea(.T.,"TOPCONN",TCGenQry(,,cQry),cAlias,.F.,.T.)
            
            Count To nTotal

            If nTotal == 0
                pHabiPed(cCnpjCo, cPedPar)    
            else
                MsgAlert("Pedido já integrado no Portal Paradigma ", "Pedido Integrado")
            EndIf
        EndIf
Return 
