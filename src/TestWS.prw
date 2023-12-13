#INCLUDE "protheus.ch"

User Function TestWS()

	Local cXmlRet	:= ''
	Local cErros 	:= ''
	Local cAvisos	:= ''
	Local cReplace  := ''
	Local cRet      := ''
	// User Function checkCategoria(cTipo, cGrupo, cXSubGrp, cFilPrd)
	
    If .f.
		aReturn := U_checkCategoria("PX", "0001", "0001", "0001")
		Alert(VarInfo("aReturn", aReturn))
		Return
	EndIf

    If .f.
         // Teste de chamada do WS de Centro de Custo
        oWsCdC := WSCentroCusto():New()

        oCdC := CentroCusto_CentroCustoDTO():New()

        oCdC:nbFlAtivo          := "T"
        oCdC:csCdEmpresa        := "EmpresaX"
        oCdC:csCdCentroCusto    := "CC001"
        oCdC:csDsCentroCusto    := "CC001"

        aRetorno := oWsCdC:ProcessarCentroCust()
    EndIf

    // Teste de chamada do WS de Unidade de Medida
    If .f.
        oWsUm := WSUnidadeMedida():New()

        oUM := UnidadeMedida_UnidadeMedidaDTO():New()

        oUM:csCdUnidadeMedida := "MM"
        oUM:csSgUnidadeMedida := "M2"
        oUM:csDsUnidadeMedida := "DescriÁ„o unidade de medida"
        aAdd(oWsUm:oWSlstUnidadeMedida:oWSUnidadeMedidaDTO, oUM:Clone())

        aRetorno := oWsUm:ProcessarUnidadeMedida()
    EndIF

	cUrl := Lower(AllTrim(GetMv("MV_XPARURL")))+"/services/Projeto.svc?wsdl" 

	cXml:= ''
	cXml+=' <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/" xmlns:par="http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO">'
	cXml+="   <soapenv:Header/>"
	cXml+="   <soapenv:Body>"
	cXml+="     <tem:ProcessarProjeto>"
	cXml+="       <tem:lstProjeto>"
	cXml+="         <par:ProjetoDTO>"
	cXml+="          	<par:bFlStatus>1</par:bFlStatus>"
	cXml+="   			<par:sCdProjeto>SIB0436</par:sCdProjeto>"
	cXml+="   			<par:sDsProjeto>TESTE</par:sDsProjeto>"
	cXml+="         </par:ProjetoDTO>"
	cXml+="       </tem:lstProjeto>"
	cXml+="     </tem:ProcessarProjeto>"
	cXml+="   </soapenv:Body>"
	cXml+=" </soapenv:Envelope>"

	cRet := U_SendSOAP(cUrl, "ProcessarProjeto", cXML, @cRet)

	oXML := XMLParser(cRet, cReplace,  @cErros,  @cAvisos)

	Alert(cRet)

	Return

	oWsdl := TWsdlManager():New()
	oWsdl:lSSLInsecure := .T.
	oWsdl:nTimeout     := 120
	oWsdl:nSSLVersion  := 0
	If ! oWsdl:AddHttpHeader("Authorization", "Bearer " + U_NewToken())
		ConOut("oWsdl - Erro AddHttpHeader: " + oWsdl:cError)
		Return
	EndIF
	xRet := oWsdl:ParseURL(Lower(AllTrim(GetMv("MV_XPARURL")))+"/services/Projeto.svc?wsdl" )

	If xRet == .F.
		ConOut("WsActvs - Erro ParseURL: " + oWsdl:cError)
		Return
	EndIf

	// Definiùùo da operaùùo \\
	lRet := oWsdl:SetOperation("ProcessarProjeto")
	If lRet == .F.
		ConOut("WsActvs - Erro SetOperation: " + oWsdl:cError)
		Return
	EndIf

	cXml:= ''
	cXml+=' <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/" xmlns:par="http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO">'
	cXml+="   <soapenv:Header/>"
	cXml+="   <soapenv:Body>"
	cXml+="     <tem:ProcessarProjeto>"
	cXml+="       <tem:lstProjeto>"
	cXml+="         <par:ProjetoDTO>"
	cXml+="          	<par:bFlStatus>1</par:bFlStatus>"
	cXml+="   			<par:sCdProjeto>SIB0436</par:sCdProjeto>"
	cXml+="   			<par:sDsProjeto>TESTE</par:sDsProjeto>"
	cXml+="         </par:ProjetoDTO>"
	cXml+="       </tem:lstProjeto>"
	cXml+="     </tem:ProcessarProjeto>"
	cXml+="   </soapenv:Body>"
	cXml+=" </soapenv:Envelope>"

	// lRet := oWsdl:SendSoapMsg(cXml)
	// cXMLRet := oWsdl:GetSoapResponse()
	
	cXMLRet := XMLFORMAT(Httppost(cUrl,"",cBody,nTimeOut,aHeader,@cRet))

	oXML := XMLParser(cXMLRet, cReplace,  @cErros,  @cAvisos)

	RETURN .T.
