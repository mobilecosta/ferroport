#Include "PROTHEUS.CH"
#Include "PARMTYPE.CH"
#Include "FWMVCDEF.CH"
#Include "TOPCONN.CH"

/*================================================================================================================*\
|| ############################################################################################################## ||
||																	 											  ||
|| # Programa: WsActvs 																							# ||
|| # Exclui os titulos provisórios                                                                     # ||
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
User Function WsActvsRe()
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
    xRet := oWsdl:ParseURL(GetMv("MV_ZPARURL"))
    
    If xRet == .F.
        ConOut("WsActvs - Erro ParseURL: " + oWsdl:cError)
        Return
    EndIf

    // Definição da operação \\
    lRet := oWsdl:SetOperation("RetornarContratoRescindido")
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
    If XmlChildCount(OXML:_S_ENVELOPE:_S_BODY:_RetornarContratoRescindidoResponse:_RetornarContratoRescindidoResult) > 2
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
    // Arrays \\
    Local cCont   := ''
    Local cLenCntr:= ''
    Local nY
    lMsErroAuto := .F.

    // Contratos \\
    If ValType(OXML:_S_ENVELOPE:_S_BODY:_RetornarContratoRescindidoResponse:_RetornarContratoRescindidoResult:_A_CONTRATODTO) == "A"
        cLenCntr := Len(OXML:_S_ENVELOPE:_S_BODY:_RetornarContratoRescindidoResponse:_RetornarContratoRescindidoResult:_A_CONTRATODTO)
    Else
        cLenCntr := 1
    EndIf

    For nY := 1 To cLenCntr
       
        If cLenCntr == 1
            cCont := OXML:_S_ENVELOPE:_S_BODY:_RetornarContratoRescindidoResponse:_RetornarContratoRescindidoResult:_A_CONTRATODTO:_A_sCdContratoWbc:TEXT
        Else
            cCont := OXML:_S_ENVELOPE:_S_BODY:_RetornarContratoRescindidoResponse:_RetornarContratoRescindidoResult:_A_CONTRATODTO[NY]:_A_sCdContratoWbc:TEXT
        EndIf

        ExcTit(cCont)
   
   Next nY
    
    /*
        // Conta Contábil \\
        DbSelectArea("SED")
        SED->(DbSetOrder(1))
        SED->(DbSeek(xFilial("SED") + GetMv("MV_CNNAT")))
        cConta := SED->ED_CONTA
        SED->(DbCloseArea())

        // Itens do contrato \\
        If ValType(OAUXCNT:_A_LSTCONTRATOITEMDTO:_A_CONTRATOITEMDTO) == "A"
            cLenItem := Len(OAUXCNT:_A_LSTCONTRATOITEMDTO:_A_CONTRATOITEMDTO)
        Else
            cLenItem := 1
        EndIf


        // Item do Contrato \\
        For nZ := 1 To cLenItem            
            If cLenItem == 1
                OAUXITM := OAUXCNT:_A_LSTCONTRATOITEMDTO:_A_CONTRATOITEMDTO
            Else
                OAUXITM := OAUXCNT:_A_LSTCONTRATOITEMDTO:_A_CONTRATOITEMDTO[nZ]
            EndIf
            
            nIdTipo := Val(OAUXITM:_A_NIDTIPO:TEXT)

            // Itens de Tipo 1 - O valor do título se repete integralmente para todas as parcelas previstas \\
            If nIdTipo == 1
                If ValType(OAUXITM:_A_LSTCONTRATOITEMENDERECODTO:_A_CONTRATOITEMENDERECODTO) == "A"
                    cLenItEnd := Len(OAUXITM:_A_LSTCONTRATOITEMENDERECODTO:_A_CONTRATOITEMENDERECODTO)
                Else
                    cLenItEnd := 1
                EndIf

                // Especificidades dos itens do contrato \\
                // Itens de Tipo 1 - O valor do título é integral e vigente enquanto tiver uma data prevista de entrega \\
                For nW := 1 To cLenItEnd // Meses previstos para entrega
                    If cLenItEnd == 1
                        OAUXITME := OAUXITM:_A_LSTCONTRATOITEMENDERECODTO:_A_CONTRATOITEMENDERECODTO
                    Else
                        OAUXITME := OAUXITM:_A_LSTCONTRATOITEMENDERECODTO:_A_CONTRATOITEMENDERECODTO[nW]
                    EndIf

                    cDtItem := OAUXITME:_A_TDTENTREGAPREVISTA:TEXT
                    dDtItem := CToD(SubStr(cDtItem,9,2) + "/" + SubStr(cDtItem,6,2) + "/" + SubStr(cDtItem,1,4))
                    If cLenItEnd == 1
                        cValor := Val(OAUXITM:_A_DVLITEM:TEXT) * Val(OAUXITM:_A_LSTCONTRATOITEMENDERECODTO:_A_CONTRATOITEMENDERECODTO:_A_DQTITEMPREVISTA:TEXT)
                    Else
                        cValor := Val(OAUXITM:_A_DVLITEM:TEXT) * Val(OAUXITM:_A_LSTCONTRATOITEMENDERECODTO:_A_CONTRATOITEMENDERECODTO[nW]:_A_DQTITEMPREVISTA:TEXT)
                    EndIf
                    
                    // Parcela atual \\
                    DbSelectArea("SE2")
                    SE2->(DbSetOrder(1))
                    SE2->(DbSeek(xFilial("SE2") + "PRV" + OAUXCNT:_A_SCDCONTRATOWBC:TEXT))
                    cParc := StrZero(Val(SE2->E2_PARCELA) + nW, TamSX3("E2_PARCELA")[1])
                    SE2->(DbCloseArea())

                    aAdd(aProd, {dDtItem, cValor, cParc})
                Next nW
                
                cUltParc := IIf(Val(cUltParc) < Val(cParc), cParc, cUltParc) // Gravação da última parcela gerada

            // Itens de Tipo 0 e 2 - O valor do título é dividido pela vigência do contrato \\
            Else
                For nW := 1 To DateDiffMonth(dIniCnt, dFimCnt) // Diferença entre meses de início e fim do contrato
                    dDtItem := IIf(Day(MonthSum(dIniCnt, nW)) < Day(dIniCnt), MonthSum(dIniCnt, nW) + 1, MonthSum(dIniCnt, nW))
                    cParc := StrZero(nW + Val(cUltParc), TamSX3("E2_PARCELA")[1])
                    cValor := Val(OAUXITM:_A_DVLITEM:TEXT) * Val(OAUXITM:_A_DQTITEMPREVISTO:TEXT)

                    aAdd(aProd, {dDtItem, cValor/DateDiffMonth(dIniCnt, dFimCnt), cParc})
                Next
                
                cUltParc := IIf(Val(cUltParc) < Val(cParc), cParc, cUltParc) // Gravação da última parcela gerada
            EndIf
        Next nZ
        //Logica para buscar a natureza 
        cFornec := SubStr(OAUXCNT:_A_SCDEMPRESACONTRATADA:TEXT, 1, 8)
        cLoja   := SubStr(OAUXCNT:_A_SCDEMPRESACONTRATADA:TEXT, 9, 4)
        cNat    :=POSICIONE('SA2',1, xFilial('SA2')+cFornec+cLoja, 'A2_NATUREZ')
        cCnpj   := OAUXCNT:_A_SCDEMPRESACONTRATADA:TEXT
   

        IF Empty(cNat)

            cType :=POSICIONE('SB1',1, xFilial('SB1')+OAUXITM:_A_SCDPRODUTO:TEXT,'B1_TIPO')

            IF cType == 'SV'

                cNat := GetMv("MV_CNNATS")

            Else

                cNat := GetMv("MV_CNNATP")
            
            ENDIF
   
        Endif 

        dbselectArea("SA2")
	    DbSetOrder(3) //A2_FILIAL+A2_CGC
		If DbSeek(xFilial('SA2')+cCnpj) 
            cFornec := SA2->A2_COD
            cLoja   := SA2->A2_LOJA
        Else
            CadFornec(cCnpj)
            cFornec := SA2->A2_COD
            cLoja   := SA2->A2_LOJA
        EndIf

        cContPai :=OAUXCNT:_A_SCDCONTRATOERPPAI:TEXT

        IF !Empty(cContPai)
        
            ExcTit(cContPai,dIniCnt)

        Endif

        // Mantida a ordem dos campos da SE2 \\
        For nX := 1 To Len(aProd)
            // Array de registros \\
            aReg := {}
            aAdd(aReg,{"E2_FILIAL",  GETFIL(OAUXCNT:_A_SCDEMPRESACONTRATANTE:TEXT),     Nil}) // Filial
            aAdd(aReg,{"E2_PREFIXO", "PRV",                                             Nil}) // Prefixo
            aAdd(aReg,{"E2_NUM",     OAUXCNT:_A_SCDCONTRATOWBC:TEXT,                    Nil}) // Título a pagar
            aAdd(aReg,{"E2_PARCELA", aProd[nX][3],                                      Nil}) // Parcela
            aAdd(aReg,{"E2_TIPO",    "PR",                                              Nil}) // Tipo
            aAdd(aReg,{"E2_NATUREZ", GetMv("MV_CNNAT"),                                 Nil}) // Natureza
            aAdd(aReg,{"E2_FORNECE", cFornec,                                           Nil}) // Fornecedor - Código
            aAdd(aReg,{"E2_LOJA",    cLoja                                              ,Nil}) // Fornecedor - Filial
            aAdd(aReg,{"E2_EMISSAO", dIniCnt,                                           Nil}) // Data Inicial
            aAdd(aReg,{"E2_VENCTO",  aProd[nX][1],                                      Nil}) // Vencimento
            aAdd(aReg,{"E2_VALOR",   aProd[nX][2],                                      Nil}) // Valor
            aAdd(aReg,{"E2_HIST",    OAUXCNT:_A_SDSOBJETO:TEXT,                         Nil}) // Histórico
            aAdd(aReg,{"E2_MOEDA",   Val(OAUXCNT:_A_SCDMOEDA:TEXT),                     Nil}) // Moeda
            aAdd(aReg,{"E2_CONTAD",  cConta,                                            Nil}) // Conta Contábil
            aAdd(aReg,{"E2_MDCONTR", OAUXCNT:_A_SCDCONTRATOWBC:TEXT,                    Nil}) // Contrato

            MSExecAuto({|x,y,z| FINA050(x,y,z)}, aReg,, 3) // 3-Inclusao
        Next nX

        // Último registro de Log \\
        DbSelectArea("ZUQ")
        ZUQ->(DbSetOrder(1))
        ZUQ->(DbGoBottom())
        cCod := StrZero(Val(ZUQ->ZUQ_CODIGO) + 1, TamSX3("ZUQ_CODIGO")[1])
        ZUQ->(DbCloseArea())
            
        // Validação de erros \\
        If lMsErroAuto
            Begin Transaction
                RecLock("ZUQ", .T.)
                    ZUQ->ZUQ_FILIAL := xFilial('ZUQ')
                    ZUQ->ZUQ_CODIGO := cCod
                    ZUQ->ZUQ_XML    := cXML
                    //ZUQ->ZUQ_PROC   := 0
                    ZUQ->ZUQ_CONTR  := OAUXCNT:_A_SCDCONTRATOWBC:TEXT
                MsUnLock()
            End Transaction
            ConOut("Gravação de Log - Cod: " + cCod)

            DisarmTransaction()
            RollbackSx8()
        Else
            Begin Transaction
                RecLock("ZUQ", .T.)
                    ZUQ->ZUQ_FILIAL := xFilial('ZUQ')
                    ZUQ->ZUQ_CODIGO := cCod
                    ZUQ->ZUQ_XML    := cXML
                    //ZUQ->ZUQ_PROC   := "1"
                    ZUQ->ZUQ_CONTR  := OAUXCNT:_A_SCDCONTRATOWBC:TEXT
                MsUnLock()
            End Transaction
            ConOut("Gravação de Log - Cod: " + cCod)

            ConfirmSX8()
        Endif

    */
 
Return

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
    cXML += '      <tem:RetornarContratoRescindido/>' + CRLF
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
        oModel:SetValue('SA2MASTER','A2_CEP' ,oWsEmpresa:oWsRetornarEmpresaPorCnpjResult:CSDSCEP)

        If oModel:VldData()
            oModel:CommitData()
        Else
            VarInfo("Erro",oModel:GetErrorMessage()[6])
        Endif

        oModel:DeActivate()

        oModel:Destroy()

  
Return 


/*================================================================================================================*\
|| ############################################################################################################## ||
|| # tatic Function: ExcTit                                                                                   # ||
|| # Desc: excluir titulos provisorios ExcTit.   S                                                            # ||
|| ############################################################################################################## ||
\*================================================================================================================*/
Static Function ExcTit(cContPai,dIniCnt)


    LOCAL aArray := {}
    Local cNum   := strzero(val(cContPai),tamsx3("E2_NUM")[1]) 
    Local cAlias := GetNextAlias()
    Local cQuery :=''
    PRIVATE lMsErroAuto := .F.
    

    cQuery += "SELECT * FROM " + RetSqlName("SE2") + " SE2"
    cQuery += " WHERE E2_NUM = '" + cNum + "'"
    cQuery += " AND E2_PREFIXO = 'PRV' " 
    //cQuery += " AND E2_VENCTO >= '" + DTOS(dIniCnt) + "'" 
    cQuery += " AND SE2.D_E_L_E_T_ <> '*'"
    cQuery := ChangeQuery(cQuery)
    
    DbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),cAlias,.F.,.T.)
	(cAlias)->(DbGotop())

    While (cAlias)->(!EoF())

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
        (cAlias)->(DbSkip())
    EndDo

Return 
