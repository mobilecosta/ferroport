#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"

/* ===============================================================================
WSDL Location    https://srm-hml.paradigmawbc.com.br/scala-hml/services/Empresa.svc?wsdl
Gerado em        12/06/18 17:32:50
Observações      Código-Fonte gerado por ADVPL WSDL Client 1.120703
                 Alterações neste arquivo podem causar funcionamento incorreto
                 e serão perdidas caso o código-fonte seja gerado novamente.
=============================================================================== */

User Function _AXHLQUJ ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSEmpresa
------------------------------------------------------------------------------- */

WSCLIENT WSEmpresa

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD ProcessarEmpresa
	WSMETHOD ProcessarEmpresaAvaliacao
	WSMETHOD ProcessarEmpresaBloqueio
	WSMETHOD RetornarEmpresaPorCnpj
	WSMETHOD RetornarEmpresaPorCodigoWBC
	WSMETHOD RetornarEmpresaVencedoraSemDePara
	WSMETHOD RetornarEmpresaCotacao
	WSMETHOD RetornarEmpresaLeilao
	WSMETHOD RetornarEmpresaSemDePara
	WSMETHOD RetornarEmpresaIntegracao
	WSMETHOD RetornarEmpresaParticipante
	WSMETHOD RetornarEmpresa
	WSMETHOD RetornarEmpresaCompradoraPorNome
	WSMETHOD RetornarEmpresaVerificacaoDepara
	WSMETHOD RetornarEmpresaAtivadaInativada

	WSDATA   _URL                      AS String
	WSDATA   _CERT                     AS String
	WSDATA   _PRIVKEY                  AS String
	WSDATA   _PASSPHRASE               AS String
	WSDATA   _HEADOUT                  AS Array of String
	WSDATA   _COOKIES                  AS Array of String
	WSDATA   oWSlstEmpresa             AS Empresa_ArrayOfEmpresaDTO
	WSDATA   oWSProcessarEmpresaResult AS Empresa_RetornoDTO
	WSDATA   oWSProcessarEmpresaAvaliacaoResult AS Empresa_RetornoDTO
	WSDATA   oWSlstEmpresaBloqueio     AS Empresa_ArrayOfEmpresaBloqueioDTO
	WSDATA   oWSProcessarEmpresaBloqueioResult AS Empresa_RetornoDTO
	WSDATA   cCnpj                     AS string
	WSDATA   oWSRetornarEmpresaPorCnpjResult AS Empresa_EmpresaDTO
	WSDATA   nnCdEmpresa               AS long
	WSDATA   oWSRetornarEmpresaPorCodigoWBCResult AS Empresa_EmpresaDTO
	WSDATA   oWSRetornarEmpresaVencedoraSemDeParaResult AS Empresa_ArrayOfEmpresaDTO
	WSDATA   oWSlstProcessoCotacaoDTO  AS Empresa_ArrayOfProcessoCotacaoDTO
	WSDATA   nnFlParticipa             AS int
	WSDATA   oWSRetornarEmpresaCotacaoResult AS Empresa_ArrayOfEmpresaDTO
	WSDATA   oWSlstProcessoLeilaoDTO   AS Empresa_ArrayOfProcessoLeilaoDTO
	WSDATA   oWSRetornarEmpresaLeilaoResult AS Empresa_ArrayOfEmpresaDTO
	WSDATA   oWSRetornarEmpresaSemDeParaResult AS Empresa_ArrayOfEmpresaDTO
	WSDATA   csCdEmpresaErp            AS string
	WSDATA   csNrCnpj                  AS string
	WSDATA   oWSlstUsuarioHomologador  AS Empresa_ArrayOfstring
	WSDATA   oWSRetornarEmpresaIntegracaoResult AS Empresa_ArrayOfEmpresaDTO
	WSDATA   oWSRetornarEmpresaParticipanteResult AS Empresa_ArrayOfEmpresaDTO
	WSDATA   oWSRetornarEmpresaResult  AS Empresa_EmpresaDTO
	WSDATA   csNmEmpresa               AS string
	WSDATA   nnCdSituacao              AS int
	WSDATA   nnNrPagina                AS int
	WSDATA   oWSRetornarEmpresaCompradoraPorNomeResult AS Empresa_RetornoLista_x003C_EmpresaDTO
	WSDATA   oWSRetornarEmpresaVerificacaoDeparaResult AS Empresa_EmpresaDTO
	WSDATA   oWSRetornarEmpresaAtivadaInativadaResult AS Empresa_RetornoLista_x003C_EmpresaDTO
	
	Data SoapResponse
	Data SoapResponseXml
	Data SoapSend

	Data XmlErro
	Data XmlAviso

	Data UrlService
	Data UrlBase
	Data Wsdl
ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSEmpresa
	::Init()
	::UrlBase := Lower(AllTrim(GetMv("MV_XPARURL")))
	::Wsdl := TWsdlManager():New()
	::Wsdl:AddHttpHeader("Authorization", "Bearer " + U_NewToken())

	::Wsdl:lAlwaysSendSA    := .F. //se for SOAP 1.1, é necessário forçar o envio do Header
	::Wsdl:bNoCheckPeerCert := .T. //elimina falha de certificado (anonymous peer cert)
	::Wsdl:nTimeOut         := 300
	
	cMetodo  := 'ProcessarEmpresa'
	cServico := 'Empresa'
	cUrl   := ::UrlBase
	
	::UrlService := "services/" + cServico + ".svc?singleWsdl"

	If Right(cUrl, 1) != "/"
		cUrl += "/"
	EndIf

	cUrl += ::UrlService

	conout(' PARADIGMA::: ' + cUrl)
	If ! ::Wsdl:ParseURL(cUrl)
		Conout(' ERRO ::Wsdl:ParseURL(cUrl): ' + ::Wsdl:cError)
		//Return .F.
	EndIf
	
If !FindFunction("XMLCHILDEX")
	UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.131227A-20180727 NG] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSEmpresa
	::oWSlstEmpresa      := Empresa_ARRAYOFEMPRESADTO():New()
	::oWSProcessarEmpresaResult := Empresa_RETORNODTO():New()
	::oWSProcessarEmpresaAvaliacaoResult := Empresa_RETORNODTO():New()
	::oWSlstEmpresaBloqueio := Empresa_ARRAYOFEMPRESABLOQUEIODTO():New()
	::oWSProcessarEmpresaBloqueioResult := Empresa_RETORNODTO():New()
	::oWSRetornarEmpresaPorCnpjResult := Empresa_EMPRESADTO():New()
	::oWSRetornarEmpresaPorCodigoWBCResult := Empresa_EMPRESADTO():New()
	::oWSRetornarEmpresaVencedoraSemDeParaResult := Empresa_ARRAYOFEMPRESADTO():New()
	::oWSlstProcessoCotacaoDTO := Empresa_ARRAYOFPROCESSOCOTACAODTO():New()
	::oWSRetornarEmpresaCotacaoResult := Empresa_ARRAYOFEMPRESADTO():New()
	::oWSlstProcessoLeilaoDTO := Empresa_ARRAYOFPROCESSOLEILAODTO():New()
	::oWSRetornarEmpresaLeilaoResult := Empresa_ARRAYOFEMPRESADTO():New()
	::oWSRetornarEmpresaSemDeParaResult := Empresa_ARRAYOFEMPRESADTO():New()
	::oWSlstUsuarioHomologador := Empresa_ARRAYOFSTRING():New()
	::oWSRetornarEmpresaIntegracaoResult := Empresa_ARRAYOFEMPRESADTO():New()
	::oWSRetornarEmpresaParticipanteResult := Empresa_ARRAYOFEMPRESADTO():New()
	::oWSRetornarEmpresaResult := Empresa_EMPRESADTO():New()
	::oWSRetornarEmpresaCompradoraPorNomeResult := Empresa_RetornoLista_x003C_EmpresaDTO():New()
	::oWSRetornarEmpresaVerificacaoDeparaResult := Empresa_EMPRESADTO():New()
	::oWSRetornarEmpresaAtivadaInativadaResult := Empresa_RetornoLista_x003C_EmpresaDTO():New()
Return

WSMETHOD RESET WSCLIENT WSEmpresa
	::oWSlstEmpresa      := NIL 
	::oWSProcessarEmpresaResult := NIL 
	::oWSProcessarEmpresaAvaliacaoResult := NIL 
	::oWSlstEmpresaBloqueio := NIL 
	::oWSProcessarEmpresaBloqueioResult := NIL 
	::cCnpj              := NIL 
	::oWSRetornarEmpresaPorCnpjResult := NIL 
	::nnCdEmpresa        := NIL 
	::oWSRetornarEmpresaPorCodigoWBCResult := NIL 
	::oWSRetornarEmpresaVencedoraSemDeParaResult := NIL 
	::oWSlstProcessoCotacaoDTO := NIL 
	::nnFlParticipa      := NIL 
	::oWSRetornarEmpresaCotacaoResult := NIL 
	::oWSlstProcessoLeilaoDTO := NIL 
	::oWSRetornarEmpresaLeilaoResult := NIL 
	::oWSRetornarEmpresaSemDeParaResult := NIL 
	::csCdEmpresaErp     := NIL 
	::csNrCnpj           := NIL 
	::oWSlstUsuarioHomologador := NIL 
	::oWSRetornarEmpresaIntegracaoResult := NIL 
	::oWSRetornarEmpresaParticipanteResult := NIL 
	::oWSRetornarEmpresaResult := NIL 
	::csNmEmpresa        := NIL 
	::nnCdSituacao       := NIL 
	::nnNrPagina         := NIL 
	::oWSRetornarEmpresaCompradoraPorNomeResult := NIL 
	::oWSRetornarEmpresaVerificacaoDeparaResult := NIL 
	::oWSRetornarEmpresaAtivadaInativadaResult := NIL 
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSEmpresa
Local oClone := WSEmpresa():New()
	oClone:_URL          := ::_URL 
	oClone:_CERT         := ::_CERT 
	oClone:_PRIVKEY      := ::_PRIVKEY 
	oClone:_PASSPHRASE   := ::_PASSPHRASE 
	oClone:oWSlstEmpresa :=  IIF(::oWSlstEmpresa = NIL , NIL ,::oWSlstEmpresa:Clone() )
	oClone:oWSProcessarEmpresaResult :=  IIF(::oWSProcessarEmpresaResult = NIL , NIL ,::oWSProcessarEmpresaResult:Clone() )
	oClone:oWSProcessarEmpresaAvaliacaoResult :=  IIF(::oWSProcessarEmpresaAvaliacaoResult = NIL , NIL ,::oWSProcessarEmpresaAvaliacaoResult:Clone() )
	oClone:oWSlstEmpresaBloqueio :=  IIF(::oWSlstEmpresaBloqueio = NIL , NIL ,::oWSlstEmpresaBloqueio:Clone() )
	oClone:oWSProcessarEmpresaBloqueioResult :=  IIF(::oWSProcessarEmpresaBloqueioResult = NIL , NIL ,::oWSProcessarEmpresaBloqueioResult:Clone() )
	oClone:cCnpj         := ::cCnpj
	oClone:oWSRetornarEmpresaPorCnpjResult :=  IIF(::oWSRetornarEmpresaPorCnpjResult = NIL , NIL ,::oWSRetornarEmpresaPorCnpjResult:Clone() )
	oClone:nnCdEmpresa   := ::nnCdEmpresa
	oClone:oWSRetornarEmpresaPorCodigoWBCResult :=  IIF(::oWSRetornarEmpresaPorCodigoWBCResult = NIL , NIL ,::oWSRetornarEmpresaPorCodigoWBCResult:Clone() )
	oClone:oWSRetornarEmpresaVencedoraSemDeParaResult :=  IIF(::oWSRetornarEmpresaVencedoraSemDeParaResult = NIL , NIL ,::oWSRetornarEmpresaVencedoraSemDeParaResult:Clone() )
	oClone:oWSlstProcessoCotacaoDTO :=  IIF(::oWSlstProcessoCotacaoDTO = NIL , NIL ,::oWSlstProcessoCotacaoDTO:Clone() )
	oClone:nnFlParticipa := ::nnFlParticipa
	oClone:oWSRetornarEmpresaCotacaoResult :=  IIF(::oWSRetornarEmpresaCotacaoResult = NIL , NIL ,::oWSRetornarEmpresaCotacaoResult:Clone() )
	oClone:oWSlstProcessoLeilaoDTO :=  IIF(::oWSlstProcessoLeilaoDTO = NIL , NIL ,::oWSlstProcessoLeilaoDTO:Clone() )
	oClone:oWSRetornarEmpresaLeilaoResult :=  IIF(::oWSRetornarEmpresaLeilaoResult = NIL , NIL ,::oWSRetornarEmpresaLeilaoResult:Clone() )
	oClone:oWSRetornarEmpresaSemDeParaResult :=  IIF(::oWSRetornarEmpresaSemDeParaResult = NIL , NIL ,::oWSRetornarEmpresaSemDeParaResult:Clone() )
	oClone:csCdEmpresaErp := ::csCdEmpresaErp
	oClone:csNrCnpj      := ::csNrCnpj
	oClone:oWSlstUsuarioHomologador :=  IIF(::oWSlstUsuarioHomologador = NIL , NIL ,::oWSlstUsuarioHomologador:Clone() )
	oClone:oWSRetornarEmpresaIntegracaoResult :=  IIF(::oWSRetornarEmpresaIntegracaoResult = NIL , NIL ,::oWSRetornarEmpresaIntegracaoResult:Clone() )
	oClone:oWSRetornarEmpresaParticipanteResult :=  IIF(::oWSRetornarEmpresaParticipanteResult = NIL , NIL ,::oWSRetornarEmpresaParticipanteResult:Clone() )
	oClone:oWSRetornarEmpresaResult :=  IIF(::oWSRetornarEmpresaResult = NIL , NIL ,::oWSRetornarEmpresaResult:Clone() )
	oClone:csNmEmpresa   := ::csNmEmpresa
	oClone:nnCdSituacao  := ::nnCdSituacao
	oClone:nnNrPagina    := ::nnNrPagina
	oClone:oWSRetornarEmpresaCompradoraPorNomeResult :=  IIF(::oWSRetornarEmpresaCompradoraPorNomeResult = NIL , NIL ,::oWSRetornarEmpresaCompradoraPorNomeResult:Clone() )
	oClone:oWSRetornarEmpresaVerificacaoDeparaResult :=  IIF(::oWSRetornarEmpresaVerificacaoDeparaResult = NIL , NIL ,::oWSRetornarEmpresaVerificacaoDeparaResult:Clone() )
	oClone:oWSRetornarEmpresaAtivadaInativadaResult :=  IIF(::oWSRetornarEmpresaAtivadaInativadaResult = NIL , NIL ,::oWSRetornarEmpresaAtivadaInativadaResult:Clone() )
Return oClone

// WSDL Method ProcessarEmpresa of Service WSEmpresa

WSMETHOD ProcessarEmpresa WSSEND oWSlstEmpresa WSRECEIVE oWSProcessarEmpresaResult WSCLIENT WSEmpresa
	Local cSoap := "" , oXmlRet, nHandle
	
	BEGIN WSMETHOD
	If ! ::Wsdl:SetOperation( 'ProcessarEmpresa' )
		Conout(' ERROR ::Wsdl:SetOperation( ProcessarEmpresa): ' + ::Wsdl:cError)
	EndIf
	
	cSoap += AllTrim('<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/" xmlns:par="http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO">')
	cSoap += AllTrim('   <soapenv:Header/>')
	cSoap += AllTrim('   <soapenv:Body>')
	cSoap += '<ProcessarEmpresa xmlns="http://tempuri.org/">'
	cSoap += WSSoapValue("lstEmpresa", ::oWSlstEmpresa, oWSlstEmpresa , "ArrayOfEmpresaDTO", .F. , .F., 0 , "http://tempuri.org/", .F.,.F.) 
	cSoap += "</ProcessarEmpresa>"
	cSoap += AllTrim('   </soapenv:Body>')
	cSoap += AllTrim('</soapenv:Envelope>')
	
	Conout(' :XML: ' + cSoap)
	If Left(::Wsdl:cLocation,5) == "http:"
		::Wsdl:cLocation = "https:" + SubStr(::Wsdl:cLocation,6)
	EndIf
	Conout(' ::Wsdl:cLocation - ' + ::Wsdl:cLocation)
	If ! (::Wsdl:SendSoapMsg( cSoap ))
		Conout(' ERROR ::Wsdl:SendSoapMsg: ' + ::Wsdl:cError + ' .cFaultCode: ' + ::Wsdl:cFaultCode + ' .cFaultSubCode: ' + ::Wsdl:cFaultSubCode + ' .cFaultString: ' + ::Wsdl:cFaultString + ' .cFaultActor: ' + ::Wsdl:cFaultActor )
	EndIf
	::XmlErro  := ''
	::XmlAviso := ''
	
	oXmlRet := ::Wsdl:GetSoapResponse()
	Conout(' ::Wsdl:GetSoapResponse: ' + oXmlRet)
	oXmlRet := XmlParser(oXmlRet , "_", @::XmlErro, @::XmlAviso) 
	If oXmlRet == Nil
		Conout(' ERRO no XmlParser.  ::XmlErro: ' + ::XmlErro + '  ::XmlAviso: ' + ::XmlAviso)
	EndIf
	oXmlRet := oXmlRet:_S_ENVELOPE:_S_BODY 
		
	::Init()
	::oWSProcessarEmpresaResult:SoapRecv( WSAdvValue( oXmlRet,"_PROCESSAREMPRESARESPONSE:_PROCESSAREMPRESARESULT","RetornoDTO",NIL,NIL,NIL,NIL,NIL,NIL) )
	
	END WSMETHOD
	
	oXmlRet := NIL
Return .T.

// WSDL Method ProcessarEmpresaAvaliacao of Service WSEmpresa

WSMETHOD ProcessarEmpresaAvaliacao WSSEND oWSlstEmpresa WSRECEIVE oWSProcessarEmpresaAvaliacaoResult WSCLIENT WSEmpresa
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ProcessarEmpresaAvaliacao xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("lstEmpresa", ::oWSlstEmpresa, oWSlstEmpresa , "ArrayOfEmpresaAvaliacaoDTO", .F. , .F., 0 , "http://tempuri.org/", .F.,.F.) 
cSoap += "</ProcessarEmpresaAvaliacao>"

Self:_HEADOUT := { "Authorization: Bearer " + U_NewToken() }
oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/IEmpresa/ProcessarEmpresaAvaliacao",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	Lower(AllTrim(GetMv("MV_XPARURL"))) + "/services/Empresa.svc?wsdl")
	//Lower(AllTrim(GetMv("MV_XPARURL"))) + "/services/Empresa.svc?wsdl")

::Init()
::oWSProcessarEmpresaAvaliacaoResult:SoapRecv( WSAdvValue( oXmlRet,"_PROCESSAREMPRESAAVALIACAORESPONSE:_PROCESSAREMPRESAAVALIACAORESULT","RetornoDTO",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method ProcessarEmpresaBloqueio of Service WSEmpresa

WSMETHOD ProcessarEmpresaBloqueio WSSEND oWSlstEmpresaBloqueio WSRECEIVE oWSProcessarEmpresaBloqueioResult WSCLIENT WSEmpresa
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ProcessarEmpresaBloqueio xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("lstEmpresaBloqueio", ::oWSlstEmpresaBloqueio, oWSlstEmpresaBloqueio , "ArrayOfEmpresaBloqueioDTO", .F. , .F., 0 , "http://tempuri.org/", .F.,.F.) 
cSoap += "</ProcessarEmpresaBloqueio>"

Self:_HEADOUT := { "Authorization: Bearer " + U_NewToken() }
oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/IEmpresa/ProcessarEmpresaBloqueio",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	Lower(AllTrim(GetMv("MV_XPARURL"))) + "/services/Empresa.svc?wsdl")
	//Lower(AllTrim(GetMv("MV_XPARURL"))) + "/services/Empresa.svc?wsdl")

::Init()
::oWSProcessarEmpresaBloqueioResult:SoapRecv( WSAdvValue( oXmlRet,"_PROCESSAREMPRESABLOQUEIORESPONSE:_PROCESSAREMPRESABLOQUEIORESULT","RetornoDTO",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method RetornarEmpresaPorCnpj of Service WSEmpresa
WSMETHOD RetornarEmpresaPorCnpj WSSEND cCnpj WSRECEIVE oWSRetornarEmpresaPorCnpjResult WSCLIENT WSEmpresa
	Local cSoap := "" , oXmlRet
	
	BEGIN WSMETHOD
	If ! ::Wsdl:SetOperation( 'RetornarEmpresaPorCnpj' )
		Conout(' ERROR ::Wsdl:SetOperation( RetornarEmpresaPorCnpj): ' + ::Wsdl:cError)
	EndIf
	
	cSoap += AllTrim('<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/" xmlns:par="http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO">')
	cSoap += AllTrim('   <soapenv:Header/>')
	cSoap += AllTrim('   <soapenv:Body>')
	cSoap += '<RetornarEmpresaPorCnpj xmlns="http://tempuri.org/">'
	cSoap += WSSoapValue("Cnpj", ::cCnpj, cCnpj , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += "</RetornarEmpresaPorCnpj>"
	cSoap += AllTrim('   </soapenv:Body>')
	cSoap += AllTrim('</soapenv:Envelope>')
	
	CONOUT(cSoap)
	If Left(::Wsdl:cLocation,5) == "http:"
		::Wsdl:cLocation = "https:" + SubStr(::Wsdl:cLocation,6)
	EndIf
	Conout(' ::Wsdl:cLocation - ' + ::Wsdl:cLocation)
	If ! (::Wsdl:SendSoapMsg( cSoap ))
		Conout(' ERROR ::Wsdl:SendSoapMsg: ' + ::Wsdl:cError + ' .cFaultCode: ' + ::Wsdl:cFaultCode + ' .cFaultSubCode: ' + ::Wsdl:cFaultSubCode + ' .cFaultString: ' + ::Wsdl:cFaultString + ' .cFaultActor: ' + ::Wsdl:cFaultActor )
	EndIf
	::XmlErro  := ''
	::XmlAviso := ''
	
	oXmlRet := ::Wsdl:GetSoapResponse()
	Conout(' ::Wsdl:GetSoapResponse: ' + oXmlRet)
	oXmlRet := XmlParser(oXmlRet , "_", @::XmlErro, @::XmlAviso)
	If oXmlRet == Nil
		Conout(' ERRO no XmlParser.  ::XmlErro: ' + ::XmlErro + '  ::XmlAviso: ' + ::XmlAviso)
	EndIf 
	oXmlRet := oXmlRet:_S_ENVELOPE:_S_BODY 
	
	::Init()
	::oWSRetornarEmpresaPorCnpjResult:SoapRecv( WSAdvValue( oXmlRet,"_RETORNAREMPRESAPORCNPJRESPONSE:_RETORNAREMPRESAPORCNPJRESULT","EmpresaDTO",NIL,NIL,NIL,NIL,NIL,NIL) )
	
	END WSMETHOD
	
	oXmlRet := NIL
Return .T.


/*
WSMETHOD RetornarEmpresaPorCnpj WSSEND cCnpj WSRECEIVE oWSRetornarEmpresaPorCnpjResult WSCLIENT WSEmpresa
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<RetornarEmpresaPorCnpj xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("Cnpj", ::cCnpj, cCnpj , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</RetornarEmpresaPorCnpj>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/IEmpresa/RetornarEmpresaPorCnpj",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	Lower(AllTrim(GetMv("MV_XPARURL"))) + "/services/Empresa.svc")

::Init()
::oWSRetornarEmpresaPorCnpjResult:SoapRecv( WSAdvValue( oXmlRet,"_RETORNAREMPRESAPORCNPJRESPONSE:_RETORNAREMPRESAPORCNPJRESULT","EmpresaDTO",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.
*/
// WSDL Method RetornarEmpresaPorCodigoWBC of Service WSEmpresa

WSMETHOD RetornarEmpresaPorCodigoWBC WSSEND nnCdEmpresa WSRECEIVE oWSRetornarEmpresaPorCodigoWBCResult WSCLIENT WSEmpresa
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<RetornarEmpresaPorCodigoWBC xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("nCdEmpresa", ::nnCdEmpresa, nnCdEmpresa , "long", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</RetornarEmpresaPorCodigoWBC>"

Self:_HEADOUT := { "Authorization: Bearer " + U_NewToken() }
oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/IEmpresa/RetornarEmpresaPorCodigoWBC",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	Lower(AllTrim(GetMv("MV_XPARURL"))) + "/services/Empresa.svc?wsdl")
	//Lower(AllTrim(GetMv("MV_XPARURL"))) + "/services/Empresa.svc?wsdl")

::Init()
::oWSRetornarEmpresaPorCodigoWBCResult:SoapRecv( WSAdvValue( oXmlRet,"_RETORNAREMPRESAPORCODIGOWBCRESPONSE:_RETORNAREMPRESAPORCODIGOWBCRESULT","EmpresaDTO",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method RetornarEmpresaVencedoraSemDePara of Service WSEmpresa

WSMETHOD RetornarEmpresaVencedoraSemDePara WSSEND NULLPARAM WSRECEIVE oWSRetornarEmpresaVencedoraSemDeParaResult WSCLIENT WSEmpresa
	Local cSoap := "" , oXmlRet
	
	BEGIN WSMETHOD
	If ! ::Wsdl:SetOperation( 'RetornarEmpresaVencedoraSemDePara' )
		Conout(' ERROR ::Wsdl:SetOperation( RetornarEmpresaVencedoraSemDePara): ' + ::Wsdl:cError)
	EndIf
	
	cSoap += AllTrim('<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/" xmlns:par="http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO">')
	cSoap += AllTrim('   <soapenv:Header/>')
	cSoap += AllTrim('   <soapenv:Body>')
	cSoap += '<RetornarEmpresaVencedoraSemDePara xmlns="http://tempuri.org/">'
	cSoap += "</RetornarEmpresaVencedoraSemDePara>"
	cSoap += AllTrim('   </soapenv:Body>')
	cSoap += AllTrim('</soapenv:Envelope>')
	
	CONOUT(cSoap)
	If Left(::Wsdl:cLocation,5) == "http:"
		::Wsdl:cLocation = "https:" + SubStr(::Wsdl:cLocation,6)
	EndIf
	Conout(' ::Wsdl:cLocation - ' + ::Wsdl:cLocation)
	If ! (::Wsdl:SendSoapMsg( cSoap ))
		Conout(' ERROR ::Wsdl:SendSoapMsg: ' + ::Wsdl:cError + ' .cFaultCode: ' + ::Wsdl:cFaultCode + ' .cFaultSubCode: ' + ::Wsdl:cFaultSubCode + ' .cFaultString: ' + ::Wsdl:cFaultString + ' .cFaultActor: ' + ::Wsdl:cFaultActor )
	EndIf
	::XmlErro  := ''
	::XmlAviso := ''
	
	oXmlRet := ::Wsdl:GetSoapResponse()
	Conout(' ::Wsdl:GetSoapResponse: ' + oXmlRet)
	oXmlRet := XmlParser(oXmlRet , "_", @::XmlErro, @::XmlAviso)
	oXmlRet := oXmlRet:_S_ENVELOPE:_S_BODY
	
	::Init()
	::oWSRetornarEmpresaVencedoraSemDeParaResult:SoapRecv( WSAdvValue( oXmlRet,"_RETORNAREMPRESAVENCEDORASEMDEPARARESPONSE:_RETORNAREMPRESAVENCEDORASEMDEPARARESULT","ArrayOfEmpresaDTO",NIL,NIL,NIL,NIL,NIL,NIL) )
	
	END WSMETHOD
	
	oXmlRet := NIL
Return {.T., cSoap}

// WSDL Method RetornarEmpresaCotacao of Service WSEmpresa

WSMETHOD RetornarEmpresaCotacao WSSEND oWSlstProcessoCotacaoDTO,nnFlParticipa WSRECEIVE oWSRetornarEmpresaCotacaoResult WSCLIENT WSEmpresa
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<RetornarEmpresaCotacao xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("lstProcessoCotacaoDTO", ::oWSlstProcessoCotacaoDTO, oWSlstProcessoCotacaoDTO , "ArrayOfProcessoCotacaoDTO", .F. , .F., 0 , "http://tempuri.org/", .F.,.F.) 
cSoap += WSSoapValue("nFlParticipa", ::nnFlParticipa, nnFlParticipa , "int", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</RetornarEmpresaCotacao>"

Self:_HEADOUT := { "Authorization: Bearer " + U_NewToken() }
oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/IEmpresa/RetornarEmpresaCotacao",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	Lower(AllTrim(GetMv("MV_XPARURL"))) + "/services/Empresa.svc?wsdl")
	//Lower(AllTrim(GetMv("MV_XPARURL"))) + "/services/Empresa.svc?wsdl")

::Init()
::oWSRetornarEmpresaCotacaoResult:SoapRecv( WSAdvValue( oXmlRet,"_RETORNAREMPRESACOTACAORESPONSE:_RETORNAREMPRESACOTACAORESULT","ArrayOfEmpresaDTO",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method RetornarEmpresaLeilao of Service WSEmpresa

WSMETHOD RetornarEmpresaLeilao WSSEND oWSlstProcessoLeilaoDTO,nnFlParticipa WSRECEIVE oWSRetornarEmpresaLeilaoResult WSCLIENT WSEmpresa
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<RetornarEmpresaLeilao xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("lstProcessoLeilaoDTO", ::oWSlstProcessoLeilaoDTO, oWSlstProcessoLeilaoDTO , "ArrayOfProcessoLeilaoDTO", .F. , .F., 0 , "http://tempuri.org/", .F.,.F.) 
cSoap += WSSoapValue("nFlParticipa", ::nnFlParticipa, nnFlParticipa , "int", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</RetornarEmpresaLeilao>"

Self:_HEADOUT := { "Authorization: Bearer " + U_NewToken() }
oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/IEmpresa/RetornarEmpresaLeilao",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	Lower(AllTrim(GetMv("MV_XPARURL"))) + "/services/Empresa.svc?wsdl")
	//Lower(AllTrim(GetMv("MV_XPARURL"))) + "/services/Empresa.svc?wsdl")

::Init()
::oWSRetornarEmpresaLeilaoResult:SoapRecv( WSAdvValue( oXmlRet,"_RETORNAREMPRESALEILAORESPONSE:_RETORNAREMPRESALEILAORESULT","ArrayOfEmpresaDTO",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method RetornarEmpresaSemDePara of Service WSEmpresa

WSMETHOD RetornarEmpresaSemDePara WSSEND NULLPARAM WSRECEIVE oWSRetornarEmpresaSemDeParaResult WSCLIENT WSEmpresa
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<RetornarEmpresaSemDePara xmlns="http://tempuri.org/">'
cSoap += "</RetornarEmpresaSemDePara>"

Self:_HEADOUT := { "Authorization: Bearer " + U_NewToken() }
oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/IEmpresa/RetornarEmpresaSemDePara",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	Lower(AllTrim(GetMv("MV_XPARURL"))) + "/services/Empresa.svc?wsdl")
	//Lower(AllTrim(GetMv("MV_XPARURL"))) + "/services/Empresa.svc?wsdl")

::Init()
::oWSRetornarEmpresaSemDeParaResult:SoapRecv( WSAdvValue( oXmlRet,"_RETORNAREMPRESASEMDEPARARESPONSE:_RETORNAREMPRESASEMDEPARARESULT","ArrayOfEmpresaDTO",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return {.T.,cSoap}

// WSDL Method RetornarEmpresaIntegracao of Service WSEmpresa

WSMETHOD RetornarEmpresaIntegracao WSSEND csCdEmpresaErp,csNrCnpj,oWSlstUsuarioHomologador WSRECEIVE oWSRetornarEmpresaIntegracaoResult WSCLIENT WSEmpresa
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<RetornarEmpresaIntegracao xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("sCdEmpresaErp", ::csCdEmpresaErp, csCdEmpresaErp , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("sNrCnpj", ::csNrCnpj, csNrCnpj , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("lstUsuarioHomologador", ::oWSlstUsuarioHomologador, oWSlstUsuarioHomologador , "ArrayOfstring", .F. , .F., 0 , "http://tempuri.org/", .F.,.F.) 
cSoap += "</RetornarEmpresaIntegracao>"

Self:_HEADOUT := { "Authorization: Bearer " + U_NewToken() }
oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/IEmpresa/RetornarEmpresaIntegracao",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	Lower(AllTrim(GetMv("MV_XPARURL"))) + "/services/Empresa.svc?wsdl")
	//Lower(AllTrim(GetMv("MV_XPARURL"))) + "/services/Empresa.svc?wsdl")

::Init()
::oWSRetornarEmpresaIntegracaoResult:SoapRecv( WSAdvValue( oXmlRet,"_RETORNAREMPRESAINTEGRACAORESPONSE:_RETORNAREMPRESAINTEGRACAORESULT","ArrayOfEmpresaDTO",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method RetornarEmpresaParticipante of Service WSEmpresa

WSMETHOD RetornarEmpresaParticipante WSSEND NULLPARAM WSRECEIVE oWSRetornarEmpresaParticipanteResult WSCLIENT WSEmpresa
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<RetornarEmpresaParticipante xmlns="http://tempuri.org/">'
cSoap += "</RetornarEmpresaParticipante>"

Self:_HEADOUT := { "Authorization: Bearer " + U_NewToken() }
oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/IEmpresa/RetornarEmpresaParticipante",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	Lower(AllTrim(GetMv("MV_XPARURL"))) + "/services/Empresa.svc?wsdl")
	//Lower(AllTrim(GetMv("MV_XPARURL"))) + "/services/Empresa.svc?wsdl")

::Init()
::oWSRetornarEmpresaParticipanteResult:SoapRecv( WSAdvValue( oXmlRet,"_RETORNAREMPRESAPARTICIPANTERESPONSE:_RETORNAREMPRESAPARTICIPANTERESULT","ArrayOfEmpresaDTO",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method RetornarEmpresa of Service WSEmpresa

WSMETHOD RetornarEmpresa WSSEND csCdEmpresaErp WSRECEIVE oWSRetornarEmpresaResult WSCLIENT WSEmpresa
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<RetornarEmpresa xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("sCdEmpresaErp", ::csCdEmpresaErp, csCdEmpresaErp , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</RetornarEmpresa>"

Self:_HEADOUT := { "Authorization: Bearer " + U_NewToken() }
oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/IEmpresa/RetornarEmpresa",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	Lower(AllTrim(GetMv("MV_XPARURL"))) + "/services/Empresa.svc?wsdl")
	//Lower(AllTrim(GetMv("MV_XPARURL"))) + "/services/Empresa.svc?wsdl")

::Init()
::oWSRetornarEmpresaResult:SoapRecv( WSAdvValue( oXmlRet,"_RETORNAREMPRESARESPONSE:_RETORNAREMPRESARESULT","EmpresaDTO",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method RetornarEmpresaCompradoraPorNome of Service WSEmpresa

WSMETHOD RetornarEmpresaCompradoraPorNome WSSEND csNmEmpresa,nnCdSituacao,nnNrPagina WSRECEIVE oWSRetornarEmpresaCompradoraPorNomeResult WSCLIENT WSEmpresa
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<RetornarEmpresaCompradoraPorNome xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("sNmEmpresa", ::csNmEmpresa, csNmEmpresa , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("nCdSituacao", ::nnCdSituacao, nnCdSituacao , "int", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("nNrPagina", ::nnNrPagina, nnNrPagina , "int", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</RetornarEmpresaCompradoraPorNome>"

Self:_HEADOUT := { "Authorization: Bearer " + U_NewToken() }
oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/IEmpresa/RetornarEmpresaCompradoraPorNome",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	Lower(AllTrim(GetMv("MV_XPARURL"))) + "/services/Empresa.svc?wsdl")
	//Lower(AllTrim(GetMv("MV_XPARURL"))) + "/services/Empresa.svc?wsdl")

::Init()
::oWSRetornarEmpresaCompradoraPorNomeResult:SoapRecv( WSAdvValue( oXmlRet,"_RETORNAREMPRESACOMPRADORAPORNOMERESPONSE:_RETORNAREMPRESACOMPRADORAPORNOMERESULT","RetornoLista_x003C_EmpresaDTO_x003E_",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method RetornarEmpresaVerificacaoDepara of Service WSEmpresa

WSMETHOD RetornarEmpresaVerificacaoDepara WSSEND csCdEmpresaErp,csNrCnpj WSRECEIVE oWSRetornarEmpresaVerificacaoDeparaResult WSCLIENT WSEmpresa
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<RetornarEmpresaVerificacaoDepara xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("sCdEmpresaErp", ::csCdEmpresaErp, csCdEmpresaErp , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("sNrCnpj", ::csNrCnpj, csNrCnpj , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</RetornarEmpresaVerificacaoDepara>"

Self:_HEADOUT := { "Authorization: Bearer " + U_NewToken() }
oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/IEmpresa/RetornarEmpresaVerificacaoDepara",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	Lower(AllTrim(GetMv("MV_XPARURL"))) + "/services/Empresa.svc?wsdl")
	//Lower(AllTrim(GetMv("MV_XPARURL"))) + "/services/Empresa.svc?wsdl")

::Init()
::oWSRetornarEmpresaVerificacaoDeparaResult:SoapRecv( WSAdvValue( oXmlRet,"_RETORNAREMPRESAVERIFICACAODEPARARESPONSE:_RETORNAREMPRESAVERIFICACAODEPARARESULT","EmpresaDTO",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method RetornarEmpresaAtivadaInativada of Service WSEmpresa

WSMETHOD RetornarEmpresaAtivadaInativada WSSEND NULLPARAM WSRECEIVE oWSRetornarEmpresaAtivadaInativadaResult WSCLIENT WSEmpresa
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<RetornarEmpresaAtivadaInativada xmlns="http://tempuri.org/">'
cSoap += "</RetornarEmpresaAtivadaInativada>"

Self:_HEADOUT := { "Authorization: Bearer " + U_NewToken() }
oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/IEmpresa/RetornarEmpresaAtivadaInativada",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	Lower(AllTrim(GetMv("MV_XPARURL"))) + "/services/Empresa.svc?wsdl")

::Init()
::oWSRetornarEmpresaAtivadaInativadaResult:SoapRecv( WSAdvValue( oXmlRet,"_RETORNAREMPRESAATIVADAINATIVADARESPONSE:_RETORNAREMPRESAATIVADAINATIVADARESULT","RetornoLista_x003C_EmpresaDTO_x003E_",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.


// WSDL Data Structure ArrayOfEmpresaDTO

WSSTRUCT Empresa_ArrayOfEmpresaDTO
	WSDATA   oWSEmpresaDTO             AS Empresa_EmpresaDTO OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Empresa_ArrayOfEmpresaDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Empresa_ArrayOfEmpresaDTO
	::oWSEmpresaDTO        := {} // Array Of  Empresa_EMPRESADTO():New()
Return

WSMETHOD CLONE WSCLIENT Empresa_ArrayOfEmpresaDTO
	Local oClone := Empresa_ArrayOfEmpresaDTO():NEW()
	oClone:oWSEmpresaDTO := NIL
	If ::oWSEmpresaDTO <> NIL 
		oClone:oWSEmpresaDTO := {}
		aEval( ::oWSEmpresaDTO , { |x| aadd( oClone:oWSEmpresaDTO , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT Empresa_ArrayOfEmpresaDTO
	Local cSoap := ""
	aEval( ::oWSEmpresaDTO , {|x| cSoap := cSoap  +  WSSoapValue("EmpresaDTO", x , x , "EmpresaDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.)  } ) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Empresa_ArrayOfEmpresaDTO
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_EMPRESADTO","EmpresaDTO",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSEmpresaDTO , Empresa_EmpresaDTO():New() )
			::oWSEmpresaDTO[len(::oWSEmpresaDTO)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure RetornoDTO

WSSTRUCT Empresa_RetornoDTO
	WSDATA   oWSlstWbtLogDTO           AS Empresa_ArrayOfWbtLogDTO OPTIONAL
	WSDATA   nnIdRetorno               AS long OPTIONAL
	WSDATA   csNrToken                 AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Empresa_RetornoDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Empresa_RetornoDTO
Return

WSMETHOD CLONE WSCLIENT Empresa_RetornoDTO
	Local oClone := Empresa_RetornoDTO():NEW()
	oClone:oWSlstWbtLogDTO      := IIF(::oWSlstWbtLogDTO = NIL , NIL , ::oWSlstWbtLogDTO:Clone() )
	oClone:nnIdRetorno          := ::nnIdRetorno
	oClone:csNrToken            := ::csNrToken
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Empresa_RetornoDTO
	Local oNode1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_LSTWBTLOGDTO","ArrayOfWbtLogDTO",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode1 != NIL
		::oWSlstWbtLogDTO := Empresa_ArrayOfWbtLogDTO():New()
		::oWSlstWbtLogDTO:SoapRecv(oNode1)
	EndIf
	If (::nnIdRetorno        :=  WSAdvValue( oResponse,"_A_NIDRETORNO:TEXT","long",NIL,NIL,NIL,"N",NIL,NIL) ) == Nil
		::nnIdRetorno        :=  WSAdvValue( oResponse,"_A_NIDRETORNO","long",NIL,NIL,NIL,"N",NIL,NIL) 
	EndIf
	If (::csNrToken          :=  WSAdvValue( oResponse,"_A_SNRTOKEN:TEXT","string",NIL,NIL,NIL,"S",NIL,NIL) ) == Nil
		::csNrToken          :=  WSAdvValue( oResponse,"_A_SNRTOKEN","string",NIL,NIL,NIL,"S",NIL,NIL)
	EndIf
Return

// WSDL Data Structure ArrayOfEmpresaBloqueioDTO

WSSTRUCT Empresa_ArrayOfEmpresaBloqueioDTO
	WSDATA   oWSEmpresaBloqueioDTO     AS Empresa_EmpresaBloqueioDTO OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Empresa_ArrayOfEmpresaBloqueioDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Empresa_ArrayOfEmpresaBloqueioDTO
	::oWSEmpresaBloqueioDTO := {} // Array Of  Empresa_EMPRESABLOQUEIODTO():New()
Return

WSMETHOD CLONE WSCLIENT Empresa_ArrayOfEmpresaBloqueioDTO
	Local oClone := Empresa_ArrayOfEmpresaBloqueioDTO():NEW()
	oClone:oWSEmpresaBloqueioDTO := NIL
	If ::oWSEmpresaBloqueioDTO <> NIL 
		oClone:oWSEmpresaBloqueioDTO := {}
		aEval( ::oWSEmpresaBloqueioDTO , { |x| aadd( oClone:oWSEmpresaBloqueioDTO , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT Empresa_ArrayOfEmpresaBloqueioDTO
	Local cSoap := ""
	aEval( ::oWSEmpresaBloqueioDTO , {|x| cSoap := cSoap  +  WSSoapValue("EmpresaBloqueioDTO", x , x , "EmpresaBloqueioDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.)  } ) 
Return cSoap

// WSDL Data Structure EmpresaDTO

WSSTRUCT Empresa_EmpresaDTO
	WSDATA   nbFlAreaInfluencia        AS int OPTIONAL
	WSDATA   nbFlAtividadeComercial    AS int OPTIONAL
	WSDATA   nbFlAtividadeIndustrial   AS int OPTIONAL
	WSDATA   nbFlAtividadeServico      AS int OPTIONAL
	WSDATA   ndVlCapitalIntegralizado  AS decimal OPTIONAL
	WSDATA   ndVlCapitalSocial         AS decimal OPTIONAL
	WSDATA   ndVlPatrimonioLiquido     AS decimal OPTIONAL
	WSDATA   oWSlstDocumento           AS Empresa_ArrayOfCrcHistoricoDTO OPTIONAL
	WSDATA   oWSlstEmpresaBanco        AS Empresa_ArrayOfEmpresaBancoDTO OPTIONAL
	WSDATA   oWSlstEmpresaClasse       AS Empresa_ArrayOfEmpresaClasseDTO OPTIONAL
	WSDATA   oWSlstEmpresaContato      AS Empresa_ArrayOfEmpresaContatoDTO OPTIONAL
	WSDATA   oWSlstEmpresaEnderecoCobranca AS Empresa_ArrayOfEmpresaEnderecoDTO OPTIONAL
	WSDATA   oWSlstEmpresaEnderecoEntrega AS Empresa_ArrayOfEmpresaEnderecoDTO OPTIONAL
	WSDATA   oWSlstEmpresaEnderecoFaturamento AS Empresa_ArrayOfEmpresaEnderecoDTO OPTIONAL
	WSDATA   oWSlstEmpresaEnderecoInstitucional AS Empresa_ArrayOfEmpresaEnderecoDTO OPTIONAL
	WSDATA   nnCdEmpresaWbc            AS long OPTIONAL
	WSDATA   nnCdIdioma                AS long OPTIONAL
	WSDATA   nnCdPorte                 AS int OPTIONAL
	WSDATA   nnCdSituacao              AS long OPTIONAL
	WSDATA   nnCdTipo                  AS long OPTIONAL
	WSDATA   nnCdTipoCadastroMap       AS int OPTIONAL
	WSDATA   nnIdPerfilTributario      AS int OPTIONAL
	WSDATA   nnIdSuperSimples          AS int OPTIONAL
	WSDATA   nnIdTipoPessoa            AS int OPTIONAL
	WSDATA   nnNrAutoAvaliacao         AS int OPTIONAL
	WSDATA   nnNrNotaAvaliacao         AS decimal OPTIONAL
	WSDATA   csCdAtividadeMap          AS string OPTIONAL
	WSDATA   csCdCnae                  AS string OPTIONAL
	WSDATA   csCdEmpresa               AS string OPTIONAL
	WSDATA   csCdEmpresaCliente        AS string OPTIONAL
	WSDATA   csCdEmpresaEnvio          AS string OPTIONAL
	WSDATA   csCdMoeda                 AS string OPTIONAL
	WSDATA   csCdNaturezaJuridica      AS string OPTIONAL
	WSDATA   csCdUsarioHomologador     AS string OPTIONAL
	WSDATA   csDsCep                   AS string OPTIONAL
	WSDATA   csDsEmailContato          AS string OPTIONAL
	WSDATA   csDsEndereco              AS string OPTIONAL
	WSDATA   csDsEnderecoComplemento   AS string OPTIONAL
	WSDATA   csDsUrl                   AS string OPTIONAL
	WSDATA   csNmApelido               AS string OPTIONAL
	WSDATA   csNmBairro                AS string OPTIONAL
	WSDATA   csNmCidade                AS string OPTIONAL
	WSDATA   csNmContato               AS string OPTIONAL
	WSDATA   csNmEmpresa               AS string OPTIONAL
	WSDATA   csNmFantasia              AS string OPTIONAL
	WSDATA   csNrCelular               AS string OPTIONAL
	WSDATA   csNrCnpj                  AS string OPTIONAL
	WSDATA   csNrCnpjMatriz            AS string OPTIONAL
	WSDATA   csNrEndereco              AS string OPTIONAL
	WSDATA   csNrFax                   AS string OPTIONAL
	WSDATA   csNrInscricaoEstadual     AS string OPTIONAL
	WSDATA   csNrInscricaoMunicial     AS string OPTIONAL
	WSDATA   csNrInscricaoMunicipal    AS string OPTIONAL
	WSDATA   csNrTelefone              AS string OPTIONAL
	WSDATA   csSgEstado                AS string OPTIONAL
	WSDATA   csSgGrupoConta            AS string OPTIONAL
	WSDATA   csSgPais                  AS string OPTIONAL
	WSDATA   ctDtCadastro              AS dateTime OPTIONAL
	WSDATA   ctDtInicioAtividade       AS dateTime OPTIONAL
	WSDATA   ctDtIntegralizacao        AS dateTime OPTIONAL
	WSDATA   ctDtValidadeCadastro      AS dateTime OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Empresa_EmpresaDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Empresa_EmpresaDTO
Return

WSMETHOD CLONE WSCLIENT Empresa_EmpresaDTO
	Local oClone := Empresa_EmpresaDTO():NEW()
	oClone:nbFlAreaInfluencia   := ::nbFlAreaInfluencia
	oClone:nbFlAtividadeComercial := ::nbFlAtividadeComercial
	oClone:nbFlAtividadeIndustrial := ::nbFlAtividadeIndustrial
	oClone:nbFlAtividadeServico := ::nbFlAtividadeServico
	oClone:ndVlCapitalIntegralizado := ::ndVlCapitalIntegralizado
	oClone:ndVlCapitalSocial    := ::ndVlCapitalSocial
	oClone:ndVlPatrimonioLiquido := ::ndVlPatrimonioLiquido
	oClone:oWSlstDocumento      := IIF(::oWSlstDocumento = NIL , NIL , ::oWSlstDocumento:Clone() )
	oClone:oWSlstEmpresaBanco   := IIF(::oWSlstEmpresaBanco = NIL , NIL , ::oWSlstEmpresaBanco:Clone() )
	oClone:oWSlstEmpresaClasse  := IIF(::oWSlstEmpresaClasse = NIL , NIL , ::oWSlstEmpresaClasse:Clone() )
	oClone:oWSlstEmpresaContato := IIF(::oWSlstEmpresaContato = NIL , NIL , ::oWSlstEmpresaContato:Clone() )
	oClone:oWSlstEmpresaEnderecoCobranca := IIF(::oWSlstEmpresaEnderecoCobranca = NIL , NIL , ::oWSlstEmpresaEnderecoCobranca:Clone() )
	oClone:oWSlstEmpresaEnderecoEntrega := IIF(::oWSlstEmpresaEnderecoEntrega = NIL , NIL , ::oWSlstEmpresaEnderecoEntrega:Clone() )
	oClone:oWSlstEmpresaEnderecoFaturamento := IIF(::oWSlstEmpresaEnderecoFaturamento = NIL , NIL , ::oWSlstEmpresaEnderecoFaturamento:Clone() )
	oClone:oWSlstEmpresaEnderecoInstitucional := IIF(::oWSlstEmpresaEnderecoInstitucional = NIL , NIL , ::oWSlstEmpresaEnderecoInstitucional:Clone() )
	oClone:nnCdEmpresaWbc       := ::nnCdEmpresaWbc
	oClone:nnCdIdioma           := ::nnCdIdioma
	oClone:nnCdPorte            := ::nnCdPorte
	oClone:nnCdSituacao         := ::nnCdSituacao
	oClone:nnCdTipo             := ::nnCdTipo
	oClone:nnCdTipoCadastroMap  := ::nnCdTipoCadastroMap
	oClone:nnIdPerfilTributario := ::nnIdPerfilTributario
	oClone:nnIdSuperSimples     := ::nnIdSuperSimples
	oClone:nnIdTipoPessoa       := ::nnIdTipoPessoa
	oClone:nnNrAutoAvaliacao    := ::nnNrAutoAvaliacao
	oClone:nnNrNotaAvaliacao    := ::nnNrNotaAvaliacao
	oClone:csCdAtividadeMap     := ::csCdAtividadeMap
	oClone:csCdCnae             := ::csCdCnae
	oClone:csCdEmpresa          := ::csCdEmpresa
	oClone:csCdEmpresaCliente   := ::csCdEmpresaCliente
	oClone:csCdEmpresaEnvio     := ::csCdEmpresaEnvio
	oClone:csCdMoeda            := ::csCdMoeda
	oClone:csCdNaturezaJuridica := ::csCdNaturezaJuridica
	oClone:csCdUsarioHomologador := ::csCdUsarioHomologador
	oClone:csDsCep              := ::csDsCep
	oClone:csDsEmailContato     := ::csDsEmailContato
	oClone:csDsEndereco         := ::csDsEndereco
	oClone:csDsEnderecoComplemento := ::csDsEnderecoComplemento
	oClone:csDsUrl              := ::csDsUrl
	oClone:csNmApelido          := ::csNmApelido
	oClone:csNmBairro           := ::csNmBairro
	oClone:csNmCidade           := ::csNmCidade
	oClone:csNmContato          := ::csNmContato
	oClone:csNmEmpresa          := ::csNmEmpresa
	oClone:csNmFantasia         := ::csNmFantasia
	oClone:csNrCelular          := ::csNrCelular
	oClone:csNrCnpj             := ::csNrCnpj
	oClone:csNrCnpjMatriz       := ::csNrCnpjMatriz
	oClone:csNrEndereco         := ::csNrEndereco
	oClone:csNrFax              := ::csNrFax
	oClone:csNrInscricaoEstadual := ::csNrInscricaoEstadual
	oClone:csNrInscricaoMunicial := ::csNrInscricaoMunicial
	oClone:csNrInscricaoMunicipal := ::csNrInscricaoMunicipal
	oClone:csNrTelefone         := ::csNrTelefone
	oClone:csSgEstado           := ::csSgEstado
	oClone:csSgGrupoConta       := ::csSgGrupoConta
	oClone:csSgPais             := ::csSgPais
	oClone:ctDtCadastro         := ::ctDtCadastro
	oClone:ctDtInicioAtividade  := ::ctDtInicioAtividade
	oClone:ctDtIntegralizacao   := ::ctDtIntegralizacao
	oClone:ctDtValidadeCadastro := ::ctDtValidadeCadastro
Return oClone

WSMETHOD SOAPSEND WSCLIENT Empresa_EmpresaDTO
	Local cSoap := ""
	cSoap += WSSoapValue("bFlAreaInfluencia", ::nbFlAreaInfluencia, ::nbFlAreaInfluencia , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("bFlAtividadeComercial", ::nbFlAtividadeComercial, ::nbFlAtividadeComercial , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("bFlAtividadeIndustrial", ::nbFlAtividadeIndustrial, ::nbFlAtividadeIndustrial , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("bFlAtividadeServico", ::nbFlAtividadeServico, ::nbFlAtividadeServico , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("dVlCapitalIntegralizado", ::ndVlCapitalIntegralizado, ::ndVlCapitalIntegralizado , "decimal", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("dVlCapitalSocial", ::ndVlCapitalSocial, ::ndVlCapitalSocial , "decimal", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("dVlPatrimonioLiquido", ::ndVlPatrimonioLiquido, ::ndVlPatrimonioLiquido , "decimal", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("lstDocumento", ::oWSlstDocumento, ::oWSlstDocumento , "ArrayOfCrcHistoricoDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("lstEmpresaBanco", ::oWSlstEmpresaBanco, ::oWSlstEmpresaBanco , "ArrayOfEmpresaBancoDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("lstEmpresaClasse", ::oWSlstEmpresaClasse, ::oWSlstEmpresaClasse , "ArrayOfEmpresaClasseDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("lstEmpresaContato", ::oWSlstEmpresaContato, ::oWSlstEmpresaContato , "ArrayOfEmpresaContatoDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("lstEmpresaEnderecoCobranca", ::oWSlstEmpresaEnderecoCobranca, ::oWSlstEmpresaEnderecoCobranca , "ArrayOfEmpresaEnderecoDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("lstEmpresaEnderecoEntrega", ::oWSlstEmpresaEnderecoEntrega, ::oWSlstEmpresaEnderecoEntrega , "ArrayOfEmpresaEnderecoDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("lstEmpresaEnderecoFaturamento", ::oWSlstEmpresaEnderecoFaturamento, ::oWSlstEmpresaEnderecoFaturamento , "ArrayOfEmpresaEnderecoDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("lstEmpresaEnderecoInstitucional", ::oWSlstEmpresaEnderecoInstitucional, ::oWSlstEmpresaEnderecoInstitucional , "ArrayOfEmpresaEnderecoDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("nCdEmpresaWbc", ::nnCdEmpresaWbc, ::nnCdEmpresaWbc , "long", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("nCdIdioma", ::nnCdIdioma, ::nnCdIdioma , "long", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("nCdPorte", ::nnCdPorte, ::nnCdPorte , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("nCdSituacao", ::nnCdSituacao, ::nnCdSituacao , "long", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("nCdTipo", ::nnCdTipo, ::nnCdTipo , "long", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("nCdTipoCadastroMap", ::nnCdTipoCadastroMap, ::nnCdTipoCadastroMap , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("nIdPerfilTributario", ::nnIdPerfilTributario, ::nnIdPerfilTributario , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("nIdSuperSimples", ::nnIdSuperSimples, ::nnIdSuperSimples , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("nIdTipoPessoa", ::nnIdTipoPessoa, ::nnIdTipoPessoa , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("nNrAutoAvaliacao", ::nnNrAutoAvaliacao, ::nnNrAutoAvaliacao , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("nNrNotaAvaliacao", ::nnNrNotaAvaliacao, ::nnNrNotaAvaliacao , "decimal", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdAtividadeMap", ::csCdAtividadeMap, ::csCdAtividadeMap , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdCnae", ::csCdCnae, ::csCdCnae , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdEmpresa", ::csCdEmpresa, ::csCdEmpresa , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdEmpresaCliente", ::csCdEmpresaCliente, ::csCdEmpresaCliente , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdEmpresaEnvio", ::csCdEmpresaEnvio, ::csCdEmpresaEnvio , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdMoeda", ::csCdMoeda, ::csCdMoeda , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdNaturezaJuridica", ::csCdNaturezaJuridica, ::csCdNaturezaJuridica , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdUsarioHomologador", ::csCdUsarioHomologador, ::csCdUsarioHomologador , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sDsCep", ::csDsCep, ::csDsCep , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sDsEmailContato", ::csDsEmailContato, ::csDsEmailContato , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sDsEndereco", ::csDsEndereco, ::csDsEndereco , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sDsEnderecoComplemento", ::csDsEnderecoComplemento, ::csDsEnderecoComplemento , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sDsUrl", ::csDsUrl, ::csDsUrl , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sNmApelido", ::csNmApelido, ::csNmApelido , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sNmBairro", ::csNmBairro, ::csNmBairro , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sNmCidade", ::csNmCidade, ::csNmCidade , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sNmContato", ::csNmContato, ::csNmContato , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sNmEmpresa", ::csNmEmpresa, ::csNmEmpresa , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sNmFantasia", ::csNmFantasia, ::csNmFantasia , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sNrCelular", ::csNrCelular, ::csNrCelular , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sNrCnpj", ::csNrCnpj, ::csNrCnpj , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sNrCnpjMatriz", ::csNrCnpjMatriz, ::csNrCnpjMatriz , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sNrEndereco", ::csNrEndereco, ::csNrEndereco , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sNrFax", ::csNrFax, ::csNrFax , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sNrInscricaoEstadual", ::csNrInscricaoEstadual, ::csNrInscricaoEstadual , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sNrInscricaoMunicial", ::csNrInscricaoMunicial, ::csNrInscricaoMunicial , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sNrInscricaoMunicipal", ::csNrInscricaoMunicipal, ::csNrInscricaoMunicipal , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sNrTelefone", ::csNrTelefone, ::csNrTelefone , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sSgEstado", ::csSgEstado, ::csSgEstado , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sSgGrupoConta", ::csSgGrupoConta, ::csSgGrupoConta , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sSgPais", ::csSgPais, ::csSgPais , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("tDtCadastro", ::ctDtCadastro, ::ctDtCadastro , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("tDtInicioAtividade", ::ctDtInicioAtividade, ::ctDtInicioAtividade , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("tDtIntegralizacao", ::ctDtIntegralizacao, ::ctDtIntegralizacao , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("tDtValidadeCadastro", ::ctDtValidadeCadastro, ::ctDtValidadeCadastro , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Empresa_EmpresaDTO
	Local oNode8
	Local oNode9
	Local oNode10
	Local oNode11
	Local oNode12
	Local oNode13
	Local oNode14
	Local oNode15
	::Init()
	If oResponse = NIL ; Return ; Endif 
	If (::nbFlAreaInfluencia :=  WSAdvValue( oResponse,"_A_BFLAREAINFLUENCIA:TEXT","int",NIL,NIL,NIL,"N",NIL,NIL) ) == Nil
		::nbFlAreaInfluencia :=  WSAdvValue( oResponse,"_A_BFLAREAINFLUENCIA","int",NIL,NIL,NIL,"N",NIL,NIL) 
	EndIf
	If (::nbFlAtividadeComercial :=  WSAdvValue( oResponse,"_A_BFLATIVIDADECOMERCIAL:TEXT","int",NIL,NIL,NIL,"N",NIL,NIL) ) == Nil
		::nbFlAtividadeComercial :=  WSAdvValue( oResponse,"_A_BFLATIVIDADECOMERCIAL","int",NIL,NIL,NIL,"N",NIL,NIL)
	EndIf 
	If (::nbFlAtividadeIndustrial :=  WSAdvValue( oResponse,"_A_BFLATIVIDADEINDUSTRIAL:TEXT","int",NIL,NIL,NIL,"N",NIL,NIL) ) == Nil
		::nbFlAtividadeIndustrial :=  WSAdvValue( oResponse,"_A_BFLATIVIDADEINDUSTRIAL","int",NIL,NIL,NIL,"N",NIL,NIL)
	EndIf 
	If (::nbFlAtividadeServico :=  WSAdvValue( oResponse,"_A_BFLATIVIDADESERVICO:TEXT","int",NIL,NIL,NIL,"N",NIL,NIL) ) == Nil
		::nbFlAtividadeServico :=  WSAdvValue( oResponse,"_A_BFLATIVIDADESERVICO","int",NIL,NIL,NIL,"N",NIL,NIL)
	EndIf 
	If (::ndVlCapitalIntegralizado :=  WSAdvValue( oResponse,"_A_DVLCAPITALINTEGRALIZADO:TEXT","decimal",NIL,NIL,NIL,"N",NIL,NIL) ) == Nil
		::ndVlCapitalIntegralizado :=  WSAdvValue( oResponse,"_A_DVLCAPITALINTEGRALIZADO","decimal",NIL,NIL,NIL,"N",NIL,NIL)
	EndIf 
	If (::ndVlCapitalSocial  :=  WSAdvValue( oResponse,"_A_DVLCAPITALSOCIAL:TEXT","decimal",NIL,NIL,NIL,"N",NIL,NIL) ) == Nil
		::ndVlCapitalSocial  :=  WSAdvValue( oResponse,"_A_DVLCAPITALSOCIAL","decimal",NIL,NIL,NIL,"N",NIL,NIL)
	EndIf 
	If (::ndVlPatrimonioLiquido :=  WSAdvValue( oResponse,"_A_DVLPATRIMONIOLIQUIDO:TEXT","decimal",NIL,NIL,NIL,"N",NIL,NIL) ) == Nil
		::ndVlPatrimonioLiquido :=  WSAdvValue( oResponse,"_A_DVLPATRIMONIOLIQUIDO","decimal",NIL,NIL,NIL,"N",NIL,NIL)
	EndIf
	 
	oNode8 :=  WSAdvValue( oResponse,"_LSTDOCUMENTO","ArrayOfCrcHistoricoDTO",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode8 != NIL
		::oWSlstDocumento := Empresa_ArrayOfCrcHistoricoDTO():New()
		::oWSlstDocumento:SoapRecv(oNode8)
	EndIf
	oNode9 :=  WSAdvValue( oResponse,"_LSTEMPRESABANCO","ArrayOfEmpresaBancoDTO",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode9 != NIL
		::oWSlstEmpresaBanco := Empresa_ArrayOfEmpresaBancoDTO():New()
		::oWSlstEmpresaBanco:SoapRecv(oNode9)
	EndIf
	oNode10 :=  WSAdvValue( oResponse,"_LSTEMPRESACLASSE","ArrayOfEmpresaClasseDTO",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode10 != NIL
		::oWSlstEmpresaClasse := Empresa_ArrayOfEmpresaClasseDTO():New()
		::oWSlstEmpresaClasse:SoapRecv(oNode10)
	EndIf
	oNode11 :=  WSAdvValue( oResponse,"_LSTEMPRESACONTATO","ArrayOfEmpresaContatoDTO",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode11 != NIL
		::oWSlstEmpresaContato := Empresa_ArrayOfEmpresaContatoDTO():New()
		::oWSlstEmpresaContato:SoapRecv(oNode11)
	EndIf
	oNode12 :=  WSAdvValue( oResponse,"_LSTEMPRESAENDERECOCOBRANCA","ArrayOfEmpresaEnderecoDTO",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode12 != NIL
		::oWSlstEmpresaEnderecoCobranca := Empresa_ArrayOfEmpresaEnderecoDTO():New()
		::oWSlstEmpresaEnderecoCobranca:SoapRecv(oNode12)
	EndIf
	oNode13 :=  WSAdvValue( oResponse,"_LSTEMPRESAENDERECOENTREGA","ArrayOfEmpresaEnderecoDTO",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode13 != NIL
		::oWSlstEmpresaEnderecoEntrega := Empresa_ArrayOfEmpresaEnderecoDTO():New()
		::oWSlstEmpresaEnderecoEntrega:SoapRecv(oNode13)
	EndIf
	oNode14 :=  WSAdvValue( oResponse,"_LSTEMPRESAENDERECOFATURAMENTO","ArrayOfEmpresaEnderecoDTO",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode14 != NIL
		::oWSlstEmpresaEnderecoFaturamento := Empresa_ArrayOfEmpresaEnderecoDTO():New()
		::oWSlstEmpresaEnderecoFaturamento:SoapRecv(oNode14)
	EndIf
	oNode15 :=  WSAdvValue( oResponse,"_LSTEMPRESAENDERECOINSTITUCIONAL","ArrayOfEmpresaEnderecoDTO",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode15 != NIL
		::oWSlstEmpresaEnderecoInstitucional := Empresa_ArrayOfEmpresaEnderecoDTO():New()
		::oWSlstEmpresaEnderecoInstitucional:SoapRecv(oNode15)
	EndIf
	If (::nnCdEmpresaWbc     :=  WSAdvValue( oResponse,"_A_NCDEMPRESAWBC:TEXT","long",NIL,NIL,NIL,"N",NIL,NIL)  ) == Nil
		::nnCdEmpresaWbc     :=  WSAdvValue( oResponse,"_A_NCDEMPRESAWBC","long",NIL,NIL,NIL,"N",NIL,NIL)
	EndIf
	If (::nnCdIdioma         :=  WSAdvValue( oResponse,"_A_NCDIDIOMA:TEXT","long",NIL,NIL,NIL,"N",NIL,NIL) ) == Nil
		::nnCdIdioma         :=  WSAdvValue( oResponse,"_A_NCDIDIOMA","long",NIL,NIL,NIL,"N",NIL,NIL)
	EndIf 
	If (::nnCdPorte          :=  WSAdvValue( oResponse,"_A_NCDPORTE:TEXT","int",NIL,NIL,NIL,"N",NIL,NIL) ) == Nil
		::nnCdPorte          :=  WSAdvValue( oResponse,"_A_NCDPORTE","int",NIL,NIL,NIL,"N",NIL,NIL)
	EndIf 
	If (::nnCdSituacao       :=  WSAdvValue( oResponse,"_A_NCDSITUACAO:TEXT","long",NIL,NIL,NIL,"N",NIL,NIL) ) == Nil
		::nnCdSituacao       :=  WSAdvValue( oResponse,"_A_NCDSITUACAO","long",NIL,NIL,NIL,"N",NIL,NIL)
	EndIf 
	If (::nnCdTipo           :=  WSAdvValue( oResponse,"_A_NCDTIPO:TEXT","long",NIL,NIL,NIL,"N",NIL,NIL) ) == Nil
		::nnCdTipo           :=  WSAdvValue( oResponse,"_A_NCDTIPO","long",NIL,NIL,NIL,"N",NIL,NIL)
	EndIf 
	If (::nnCdTipoCadastroMap :=  WSAdvValue( oResponse,"_A_NCDTIPOCADASTROMAP:TEXT","int",NIL,NIL,NIL,"N",NIL,NIL) ) == Nil
		::nnCdTipoCadastroMap :=  WSAdvValue( oResponse,"_A_NCDTIPOCADASTROMAP","int",NIL,NIL,NIL,"N",NIL,NIL)
	EndIf 
	If (::nnIdPerfilTributario :=  WSAdvValue( oResponse,"_A_NIDPERFILTRIBUTARIO:TEXT","int",NIL,NIL,NIL,"N",NIL,NIL) ) == Nil
		::nnIdPerfilTributario :=  WSAdvValue( oResponse,"_A_NIDPERFILTRIBUTARIO","int",NIL,NIL,NIL,"N",NIL,NIL)
	EndIf 
	If (::nnIdSuperSimples   :=  WSAdvValue( oResponse,"_A_NIDSUPERSIMPLES:TEXT","int",NIL,NIL,NIL,"N",NIL,NIL) ) == Nil
		::nnIdSuperSimples   :=  WSAdvValue( oResponse,"_A_NIDSUPERSIMPLES","int",NIL,NIL,NIL,"N",NIL,NIL)
	EndIf 
	If (::nnIdTipoPessoa     :=  WSAdvValue( oResponse,"_A_NIDTIPOPESSOA:TEXT","int",NIL,NIL,NIL,"N",NIL,NIL) ) == Nil
		::nnIdTipoPessoa     :=  WSAdvValue( oResponse,"_A_NIDTIPOPESSOA","int",NIL,NIL,NIL,"N",NIL,NIL)
	EndIf 
	If (::nnNrAutoAvaliacao  :=  WSAdvValue( oResponse,"_A_NNRAUTOAVALIACAO:TEXT","int",NIL,NIL,NIL,"N",NIL,NIL) ) == Nil
		::nnNrAutoAvaliacao  :=  WSAdvValue( oResponse,"_A_NNRAUTOAVALIACAO","int",NIL,NIL,NIL,"N",NIL,NIL)
	EndIf 
	If (::nnNrNotaAvaliacao  :=  WSAdvValue( oResponse,"_A_NNRNOTAAVALIACAO:TEXT","decimal",NIL,NIL,NIL,"N",NIL,NIL) ) == Nil
		::nnNrNotaAvaliacao  :=  WSAdvValue( oResponse,"_A_NNRNOTAAVALIACAO","decimal",NIL,NIL,NIL,"N",NIL,NIL)
	EndIf 
	If (::csCdAtividadeMap   :=  WSAdvValue( oResponse,"_A_SCDATIVIDADEMAP:TEXT","string",NIL,NIL,NIL,"S",NIL,NIL) ) == Nil
		::csCdAtividadeMap   :=  WSAdvValue( oResponse,"_A_SCDATIVIDADEMAP","string",NIL,NIL,NIL,"S",NIL,NIL)
	EndIf 
	If (::csCdCnae           :=  WSAdvValue( oResponse,"_A_SCDCNAE:TEXT","string",NIL,NIL,NIL,"S",NIL,NIL) ) == Nil
		::csCdCnae           :=  WSAdvValue( oResponse,"_A_SCDCNAE","string",NIL,NIL,NIL,"S",NIL,NIL)
	EndIf 
	If (::csCdEmpresa        :=  WSAdvValue( oResponse,"_A_SCDEMPRESA:TEXT","string",NIL,NIL,NIL,"S",NIL,NIL) ) == Nil
		::csCdEmpresa        :=  WSAdvValue( oResponse,"_A_SCDEMPRESA","string",NIL,NIL,NIL,"S",NIL,NIL)
	EndIf 
	If (::csCdEmpresaCliente :=  WSAdvValue( oResponse,"_A_SCDEMPRESACLIENTE:TEXT","string",NIL,NIL,NIL,"S",NIL,NIL) ) == Nil
		::csCdEmpresaCliente :=  WSAdvValue( oResponse,"_A_SCDEMPRESACLIENTE","string",NIL,NIL,NIL,"S",NIL,NIL)
	EndIf 
	If (::csCdEmpresaEnvio   :=  WSAdvValue( oResponse,"_A_SCDEMPRESAENVIO:TEXT","string",NIL,NIL,NIL,"S",NIL,NIL) ) == Nil
		::csCdEmpresaEnvio   :=  WSAdvValue( oResponse,"_A_SCDEMPRESAENVIO","string",NIL,NIL,NIL,"S",NIL,NIL)
	EndIf 
	If (::csCdMoeda          :=  WSAdvValue( oResponse,"_A_SCDMOEDA:TEXT","string",NIL,NIL,NIL,"S",NIL,NIL) ) == Nil
		::csCdMoeda          :=  WSAdvValue( oResponse,"_A_SCDMOEDA","string",NIL,NIL,NIL,"S",NIL,NIL)
	EndIf 
	If (::csCdNaturezaJuridica :=  WSAdvValue( oResponse,"_A_SCDNATUREZAJURIDICA:TEXT","string",NIL,NIL,NIL,"S",NIL,NIL) ) == Nil
		::csCdNaturezaJuridica :=  WSAdvValue( oResponse,"_A_SCDNATUREZAJURIDICA","string",NIL,NIL,NIL,"S",NIL,NIL)
	EndIf 
	If (::csCdUsarioHomologador :=  WSAdvValue( oResponse,"_A_SCDUSARIOHOMOLOGADOR:TEXT","string",NIL,NIL,NIL,"S",NIL,NIL) ) == Nil
		::csCdUsarioHomologador :=  WSAdvValue( oResponse,"_A_SCDUSARIOHOMOLOGADOR","string",NIL,NIL,NIL,"S",NIL,NIL)
	EndIf 
	If (::csDsCep            :=  WSAdvValue( oResponse,"_A_SDSCEP:TEXT","string",NIL,NIL,NIL,"S",NIL,NIL) ) == Nil
		::csDsCep            :=  WSAdvValue( oResponse,"_A_SDSCEP","string",NIL,NIL,NIL,"S",NIL,NIL)
	EndIf 
	If (::csDsEmailContato   :=  WSAdvValue( oResponse,"_A_SDSEMAILCONTATO:TEXT","string",NIL,NIL,NIL,"S",NIL,NIL) ) == Nil
		::csDsEmailContato   :=  WSAdvValue( oResponse,"_A_SDSEMAILCONTATO","string",NIL,NIL,NIL,"S",NIL,NIL)
	EndIf 
	If (::csDsEndereco       :=  WSAdvValue( oResponse,"_A_SDSENDERECO:TEXT","string",NIL,NIL,NIL,"S",NIL,NIL) ) == Nil
		::csDsEndereco       :=  WSAdvValue( oResponse,"_A_SDSENDERECO","string",NIL,NIL,NIL,"S",NIL,NIL)
	EndIf 
	If (::csDsEnderecoComplemento :=  WSAdvValue( oResponse,"_A_SDSENDERECOCOMPLEMENTO:TEXT","string",NIL,NIL,NIL,"S",NIL,NIL) ) == Nil
		::csDsEnderecoComplemento :=  WSAdvValue( oResponse,"_A_SDSENDERECOCOMPLEMENTO","string",NIL,NIL,NIL,"S",NIL,NIL)
	EndIf 
	If (::csDsUrl            :=  WSAdvValue( oResponse,"_A_SDSURL:TEXT","string",NIL,NIL,NIL,"S",NIL,NIL) ) == Nil
		::csDsUrl            :=  WSAdvValue( oResponse,"_A_SDSURL","string",NIL,NIL,NIL,"S",NIL,NIL)
	EndIf 
	If (::csNmApelido        :=  WSAdvValue( oResponse,"_A_SNMAPELIDO:TEXT","string",NIL,NIL,NIL,"S",NIL,NIL) ) == Nil
		::csNmApelido        :=  WSAdvValue( oResponse,"_A_SNMAPELIDO","string",NIL,NIL,NIL,"S",NIL,NIL)
	EndIf 
	If (::csNmBairro         :=  WSAdvValue( oResponse,"_A_SNMBAIRRO:TEXT","string",NIL,NIL,NIL,"S",NIL,NIL) ) == Nil
		::csNmBairro         :=  WSAdvValue( oResponse,"_A_SNMBAIRRO","string",NIL,NIL,NIL,"S",NIL,NIL)
	EndIf 
	If (::csNmCidade         :=  WSAdvValue( oResponse,"_A_SNMCIDADE:TEXT","string",NIL,NIL,NIL,"S",NIL,NIL) ) == Nil
		::csNmCidade         :=  WSAdvValue( oResponse,"_A_SNMCIDADE","string",NIL,NIL,NIL,"S",NIL,NIL)
	EndIf 
	If (::csNmContato        :=  WSAdvValue( oResponse,"_A_SNMCONTATO:TEXT","string",NIL,NIL,NIL,"S",NIL,NIL) ) == Nil
		::csNmContato        :=  WSAdvValue( oResponse,"_A_SNMCONTATO","string",NIL,NIL,NIL,"S",NIL,NIL)
	EndIf 
	If (::csNmEmpresa        :=  WSAdvValue( oResponse,"_A_SNMEMPRESA:TEXT","string",NIL,NIL,NIL,"S",NIL,NIL) ) == Nil
		::csNmEmpresa        :=  WSAdvValue( oResponse,"_A_SNMEMPRESA","string",NIL,NIL,NIL,"S",NIL,NIL)
	EndIf 
	If (::csNmFantasia       :=  WSAdvValue( oResponse,"_A_SNMFANTASIA:TEXT","string",NIL,NIL,NIL,"S",NIL,NIL) ) == Nil
		::csNmFantasia       :=  WSAdvValue( oResponse,"_A_SNMFANTASIA","string",NIL,NIL,NIL,"S",NIL,NIL)
	EndIf 
	If (::csNrCelular        :=  WSAdvValue( oResponse,"_A_SNRCELULAR:TEXT","string",NIL,NIL,NIL,"S",NIL,NIL) ) == Nil
		::csNrCelular        :=  WSAdvValue( oResponse,"_A_SNRCELULAR","string",NIL,NIL,NIL,"S",NIL,NIL)
	EndIf 
	If (::csNrCnpj           :=  WSAdvValue( oResponse,"_A_SNRCNPJ:TEXT","string",NIL,NIL,NIL,"S",NIL,NIL) ) == Nil
		::csNrCnpj           :=  WSAdvValue( oResponse,"_A_SNRCNPJ","string",NIL,NIL,NIL,"S",NIL,NIL)
	EndIf 
	If (::csNrCnpjMatriz     :=  WSAdvValue( oResponse,"_A_SNRCNPJMATRIZ:TEXT","string",NIL,NIL,NIL,"S",NIL,NIL) ) == Nil
		::csNrCnpjMatriz     :=  WSAdvValue( oResponse,"_A_SNRCNPJMATRIZ","string",NIL,NIL,NIL,"S",NIL,NIL)
	EndIf 
	If (::csNrEndereco       :=  WSAdvValue( oResponse,"_A_SNRENDERECO:TEXT","string",NIL,NIL,NIL,"S",NIL,NIL) ) == Nil
		::csNrEndereco       :=  WSAdvValue( oResponse,"_A_SNRENDERECO","string",NIL,NIL,NIL,"S",NIL,NIL)
	EndIf 
	If (::csNrFax            :=  WSAdvValue( oResponse,"_A_SNRFAX:TEXT","string",NIL,NIL,NIL,"S",NIL,NIL) ) == Nil
		::csNrFax            :=  WSAdvValue( oResponse,"_A_SNRFAX","string",NIL,NIL,NIL,"S",NIL,NIL)
	EndIf 
	If (::csNrInscricaoEstadual :=  WSAdvValue( oResponse,"_A_SNRINSCRICAOESTADUAL:TEXT","string",NIL,NIL,NIL,"S",NIL,NIL) ) == Nil
		::csNrInscricaoEstadual :=  WSAdvValue( oResponse,"_A_SNRINSCRICAOESTADUAL","string",NIL,NIL,NIL,"S",NIL,NIL)
	EndIf 
	If (::csNrInscricaoMunicial :=  WSAdvValue( oResponse,"_A_SNRINSCRICAOMUNICIAL:TEXT","string",NIL,NIL,NIL,"S",NIL,NIL) ) == Nil
		::csNrInscricaoMunicial :=  WSAdvValue( oResponse,"_A_SNRINSCRICAOMUNICIAL","string",NIL,NIL,NIL,"S",NIL,NIL)
	EndIf 
	If (::csNrInscricaoMunicipal :=  WSAdvValue( oResponse,"_A_SNRINSCRICAOMUNICIPAL:TEXT","string",NIL,NIL,NIL,"S",NIL,NIL) ) == Nil
		::csNrInscricaoMunicipal :=  WSAdvValue( oResponse,"_A_SNRINSCRICAOMUNICIPAL","string",NIL,NIL,NIL,"S",NIL,NIL)
	EndIf 
	If (::csNrTelefone       :=  WSAdvValue( oResponse,"_A_SNRTELEFONE:TEXT","string",NIL,NIL,NIL,"S",NIL,NIL) ) == Nil
		::csNrTelefone       :=  WSAdvValue( oResponse,"_A_SNRTELEFONE","string",NIL,NIL,NIL,"S",NIL,NIL)
	EndIf 
	If (::csSgEstado         :=  WSAdvValue( oResponse,"_A_SSGESTADO:TEXT","string",NIL,NIL,NIL,"S",NIL,NIL) ) == Nil
		::csSgEstado         :=  WSAdvValue( oResponse,"_A_SSGESTADO","string",NIL,NIL,NIL,"S",NIL,NIL)
	EndIf 
	If (::csSgGrupoConta     :=  WSAdvValue( oResponse,"_A_SSGGRUPOCONTA:TEXT","string",NIL,NIL,NIL,"S",NIL,NIL) ) == Nil
		::csSgGrupoConta     :=  WSAdvValue( oResponse,"_A_SSGGRUPOCONTA","string",NIL,NIL,NIL,"S",NIL,NIL)
	EndIf 
	If (::csSgPais           :=  WSAdvValue( oResponse,"_A_SSGPAIS:TEXT","string",NIL,NIL,NIL,"S",NIL,NIL) ) == Nil
		::csSgPais           :=  WSAdvValue( oResponse,"_A_SSGPAIS","string",NIL,NIL,NIL,"S",NIL,NIL)
	EndIf 
	If (::ctDtCadastro       :=  WSAdvValue( oResponse,"_A_TDTCADASTRO:TEXT","dateTime",NIL,NIL,NIL,"S",NIL,NIL) ) == Nil
		::ctDtCadastro       :=  WSAdvValue( oResponse,"_A_TDTCADASTRO","dateTime",NIL,NIL,NIL,"S",NIL,NIL)
	EndIf 
	If (::ctDtInicioAtividade :=  WSAdvValue( oResponse,"_A_TDTINICIOATIVIDADE:TEXT","dateTime",NIL,NIL,NIL,"S",NIL,NIL) ) == Nil
		::ctDtInicioAtividade :=  WSAdvValue( oResponse,"_A_TDTINICIOATIVIDADE","dateTime",NIL,NIL,NIL,"S",NIL,NIL)
	EndIf 
	If (::ctDtIntegralizacao :=  WSAdvValue( oResponse,"_A_TDTINTEGRALIZACAO:TEXT","dateTime",NIL,NIL,NIL,"S",NIL,NIL) ) == Nil
		::ctDtIntegralizacao :=  WSAdvValue( oResponse,"_A_TDTINTEGRALIZACAO","dateTime",NIL,NIL,NIL,"S",NIL,NIL)
	EndIf 
	If (::ctDtValidadeCadastro :=  WSAdvValue( oResponse,"_A_TDTVALIDADECADASTRO:TEXT","dateTime",NIL,NIL,NIL,"S",NIL,NIL) ) == Nil
		::ctDtValidadeCadastro :=  WSAdvValue( oResponse,"_A_TDTVALIDADECADASTRO","dateTime",NIL,NIL,NIL,"S",NIL,NIL)
	EndIf 
Return

// WSDL Data Structure ArrayOfProcessoCotacaoDTO

WSSTRUCT Empresa_ArrayOfProcessoCotacaoDTO
	WSDATA   oWSProcessoCotacaoDTO     AS Empresa_ProcessoCotacaoDTO OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Empresa_ArrayOfProcessoCotacaoDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Empresa_ArrayOfProcessoCotacaoDTO
	::oWSProcessoCotacaoDTO := {} // Array Of  Empresa_PROCESSOCOTACAODTO():New()
Return

WSMETHOD CLONE WSCLIENT Empresa_ArrayOfProcessoCotacaoDTO
	Local oClone := Empresa_ArrayOfProcessoCotacaoDTO():NEW()
	oClone:oWSProcessoCotacaoDTO := NIL
	If ::oWSProcessoCotacaoDTO <> NIL 
		oClone:oWSProcessoCotacaoDTO := {}
		aEval( ::oWSProcessoCotacaoDTO , { |x| aadd( oClone:oWSProcessoCotacaoDTO , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT Empresa_ArrayOfProcessoCotacaoDTO
	Local cSoap := ""
	aEval( ::oWSProcessoCotacaoDTO , {|x| cSoap := cSoap  +  WSSoapValue("ProcessoCotacaoDTO", x , x , "ProcessoCotacaoDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.)  } ) 
Return cSoap

// WSDL Data Structure ArrayOfProcessoLeilaoDTO

WSSTRUCT Empresa_ArrayOfProcessoLeilaoDTO
	WSDATA   oWSProcessoLeilaoDTO      AS Empresa_ProcessoLeilaoDTO OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Empresa_ArrayOfProcessoLeilaoDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Empresa_ArrayOfProcessoLeilaoDTO
	::oWSProcessoLeilaoDTO := {} // Array Of  Empresa_PROCESSOLEILAODTO():New()
Return

WSMETHOD CLONE WSCLIENT Empresa_ArrayOfProcessoLeilaoDTO
	Local oClone := Empresa_ArrayOfProcessoLeilaoDTO():NEW()
	oClone:oWSProcessoLeilaoDTO := NIL
	If ::oWSProcessoLeilaoDTO <> NIL 
		oClone:oWSProcessoLeilaoDTO := {}
		aEval( ::oWSProcessoLeilaoDTO , { |x| aadd( oClone:oWSProcessoLeilaoDTO , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT Empresa_ArrayOfProcessoLeilaoDTO
	Local cSoap := ""
	aEval( ::oWSProcessoLeilaoDTO , {|x| cSoap := cSoap  +  WSSoapValue("ProcessoLeilaoDTO", x , x , "ProcessoLeilaoDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.)  } ) 
Return cSoap

// WSDL Data Structure ArrayOfstring

WSSTRUCT Empresa_ArrayOfstring
	WSDATA   cstring                   AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Empresa_ArrayOfstring
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Empresa_ArrayOfstring
	::cstring              := {} // Array Of  ""
Return

WSMETHOD CLONE WSCLIENT Empresa_ArrayOfstring
	Local oClone := Empresa_ArrayOfstring():NEW()
	oClone:cstring              := IIf(::cstring <> NIL , aClone(::cstring) , NIL )
Return oClone

WSMETHOD SOAPSEND WSCLIENT Empresa_ArrayOfstring
	Local cSoap := ""
	aEval( ::cstring , {|x| cSoap := cSoap  +  WSSoapValue("string", x , x , "string", .F. , .F., 0 , "http://schemas.microsoft.com/2003/10/Serialization/Arrays", .F.,.F.)  } ) 
Return cSoap

// WSDL Data Structure RetornoLista_x003C_EmpresaDTO_x003E_

WSSTRUCT Empresa_RetornoLista_x003C_EmpresaDTO
	WSDATA   oWSlstObjetoRetorno       AS Empresa_ArrayOfEmpresaDTO OPTIONAL
	WSDATA   nnQtRegistrosRetorno      AS int OPTIONAL
	WSDATA   nnQtRegistrosTotal        AS int OPTIONAL
	WSDATA   oWSoRetornoDTO            AS Empresa_RetornoDTO OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Empresa_RetornoLista_x003C_EmpresaDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Empresa_RetornoLista_x003C_EmpresaDTO
Return

WSMETHOD CLONE WSCLIENT Empresa_RetornoLista_x003C_EmpresaDTO
	Local oClone := Empresa_RetornoLista_x003C_EmpresaDTO():NEW()
	oClone:oWSlstObjetoRetorno  := IIF(::oWSlstObjetoRetorno = NIL , NIL , ::oWSlstObjetoRetorno:Clone() )
	oClone:nnQtRegistrosRetorno := ::nnQtRegistrosRetorno
	oClone:nnQtRegistrosTotal   := ::nnQtRegistrosTotal
	oClone:oWSoRetornoDTO       := IIF(::oWSoRetornoDTO = NIL , NIL , ::oWSoRetornoDTO:Clone() )
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Empresa_RetornoLista_x003C_EmpresaDTO
	Local oNode1
	Local oNode4
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_LSTOBJETORETORNO","ArrayOfEmpresaDTO",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode1 != NIL
		::oWSlstObjetoRetorno := Empresa_ArrayOfEmpresaDTO():New()
		::oWSlstObjetoRetorno:SoapRecv(oNode1)
	EndIf
	If (::nnQtRegistrosRetorno :=  WSAdvValue( oResponse,"_A_NQTREGISTROSRETORNO:TEXT","int",NIL,NIL,NIL,"N",NIL,NIL) ) == Nil
		::nnQtRegistrosRetorno :=  WSAdvValue( oResponse,"_A_NQTREGISTROSRETORNO","int",NIL,NIL,NIL,"N",NIL,NIL)
	EndIf
	If (::nnQtRegistrosTotal :=  WSAdvValue( oResponse,"_A_NQTREGISTROSTOTAL:TEXT","int",NIL,NIL,NIL,"N",NIL,NIL) ) == Nil
		::nnQtRegistrosTotal :=  WSAdvValue( oResponse,"_A_NQTREGISTROSTOTAL","int",NIL,NIL,NIL,"N",NIL,NIL)
	EndIf
	 
	oNode4 :=  WSAdvValue( oResponse,"_ORETORNODTO","RetornoDTO",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode4 != NIL
		::oWSoRetornoDTO := Empresa_RetornoDTO():New()
		::oWSoRetornoDTO:SoapRecv(oNode4)
	EndIf
Return

// WSDL Data Structure ArrayOfWbtLogDTO

WSSTRUCT Empresa_ArrayOfWbtLogDTO
	WSDATA   oWSWbtLogDTO              AS Empresa_WbtLogDTO OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Empresa_ArrayOfWbtLogDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Empresa_ArrayOfWbtLogDTO
	::oWSWbtLogDTO         := {} // Array Of  Empresa_WBTLOGDTO():New()
Return

WSMETHOD CLONE WSCLIENT Empresa_ArrayOfWbtLogDTO
	Local oClone := Empresa_ArrayOfWbtLogDTO():NEW()
	oClone:oWSWbtLogDTO := NIL
	If ::oWSWbtLogDTO <> NIL 
		oClone:oWSWbtLogDTO := {}
		aEval( ::oWSWbtLogDTO , { |x| aadd( oClone:oWSWbtLogDTO , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Empresa_ArrayOfWbtLogDTO
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_WBTLOGDTO","WbtLogDTO",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSWbtLogDTO , Empresa_WbtLogDTO():New() )
			::oWSWbtLogDTO[len(::oWSWbtLogDTO)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure EmpresaBloqueioDTO

WSSTRUCT Empresa_EmpresaBloqueioDTO
	WSDATA   nnCdSituacao              AS int OPTIONAL
	WSDATA   csCdEmpresa               AS string OPTIONAL
	WSDATA   csCdEmpresaFornecedor     AS string OPTIONAL
	WSDATA   csDsJustificativa         AS string OPTIONAL
	WSDATA   ctDtFinalInativo          AS dateTime OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Empresa_EmpresaBloqueioDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Empresa_EmpresaBloqueioDTO
Return

WSMETHOD CLONE WSCLIENT Empresa_EmpresaBloqueioDTO
	Local oClone := Empresa_EmpresaBloqueioDTO():NEW()
	oClone:nnCdSituacao         := ::nnCdSituacao
	oClone:csCdEmpresa          := ::csCdEmpresa
	oClone:csCdEmpresaFornecedor := ::csCdEmpresaFornecedor
	oClone:csDsJustificativa    := ::csDsJustificativa
	oClone:ctDtFinalInativo     := ::ctDtFinalInativo
Return oClone

WSMETHOD SOAPSEND WSCLIENT Empresa_EmpresaBloqueioDTO
	Local cSoap := ""
	cSoap += WSSoapValue("nCdSituacao", ::nnCdSituacao, ::nnCdSituacao , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdEmpresa", ::csCdEmpresa, ::csCdEmpresa , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdEmpresaFornecedor", ::csCdEmpresaFornecedor, ::csCdEmpresaFornecedor , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sDsJustificativa", ::csDsJustificativa, ::csDsJustificativa , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("tDtFinalInativo", ::ctDtFinalInativo, ::ctDtFinalInativo , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
Return cSoap

// WSDL Data Structure ArrayOfCrcHistoricoDTO

WSSTRUCT Empresa_ArrayOfCrcHistoricoDTO
	WSDATA   oWSCrcHistoricoDTO        AS Empresa_CrcHistoricoDTO OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Empresa_ArrayOfCrcHistoricoDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Empresa_ArrayOfCrcHistoricoDTO
	::oWSCrcHistoricoDTO   := {} // Array Of  Empresa_CRCHISTORICODTO():New()
Return

WSMETHOD CLONE WSCLIENT Empresa_ArrayOfCrcHistoricoDTO
	Local oClone := Empresa_ArrayOfCrcHistoricoDTO():NEW()
	oClone:oWSCrcHistoricoDTO := NIL
	If ::oWSCrcHistoricoDTO <> NIL 
		oClone:oWSCrcHistoricoDTO := {}
		aEval( ::oWSCrcHistoricoDTO , { |x| aadd( oClone:oWSCrcHistoricoDTO , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT Empresa_ArrayOfCrcHistoricoDTO
	Local cSoap := ""
	aEval( ::oWSCrcHistoricoDTO , {|x| cSoap := cSoap  +  WSSoapValue("CrcHistoricoDTO", x , x , "CrcHistoricoDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.)  } ) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Empresa_ArrayOfCrcHistoricoDTO
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_CRCHISTORICODTO","CrcHistoricoDTO",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSCrcHistoricoDTO , Empresa_CrcHistoricoDTO():New() )
			::oWSCrcHistoricoDTO[len(::oWSCrcHistoricoDTO)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure ArrayOfEmpresaBancoDTO

WSSTRUCT Empresa_ArrayOfEmpresaBancoDTO
	WSDATA   oWSEmpresaBancoDTO        AS Empresa_EmpresaBancoDTO OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Empresa_ArrayOfEmpresaBancoDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Empresa_ArrayOfEmpresaBancoDTO
	::oWSEmpresaBancoDTO   := {} // Array Of  Empresa_EMPRESABANCODTO():New()
Return

WSMETHOD CLONE WSCLIENT Empresa_ArrayOfEmpresaBancoDTO
	Local oClone := Empresa_ArrayOfEmpresaBancoDTO():NEW()
	oClone:oWSEmpresaBancoDTO := NIL
	If ::oWSEmpresaBancoDTO <> NIL 
		oClone:oWSEmpresaBancoDTO := {}
		aEval( ::oWSEmpresaBancoDTO , { |x| aadd( oClone:oWSEmpresaBancoDTO , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT Empresa_ArrayOfEmpresaBancoDTO
	Local cSoap := ""
	aEval( ::oWSEmpresaBancoDTO , {|x| cSoap := cSoap  +  WSSoapValue("EmpresaBancoDTO", x , x , "EmpresaBancoDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.)  } ) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Empresa_ArrayOfEmpresaBancoDTO
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_EMPRESABANCODTO","EmpresaBancoDTO",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSEmpresaBancoDTO , Empresa_EmpresaBancoDTO():New() )
			::oWSEmpresaBancoDTO[len(::oWSEmpresaBancoDTO)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure ArrayOfEmpresaClasseDTO

WSSTRUCT Empresa_ArrayOfEmpresaClasseDTO
	WSDATA   oWSEmpresaClasseDTO       AS Empresa_EmpresaClasseDTO OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Empresa_ArrayOfEmpresaClasseDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Empresa_ArrayOfEmpresaClasseDTO
	::oWSEmpresaClasseDTO  := {} // Array Of  Empresa_EMPRESACLASSEDTO():New()
Return

WSMETHOD CLONE WSCLIENT Empresa_ArrayOfEmpresaClasseDTO
	Local oClone := Empresa_ArrayOfEmpresaClasseDTO():NEW()
	oClone:oWSEmpresaClasseDTO := NIL
	If ::oWSEmpresaClasseDTO <> NIL 
		oClone:oWSEmpresaClasseDTO := {}
		aEval( ::oWSEmpresaClasseDTO , { |x| aadd( oClone:oWSEmpresaClasseDTO , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT Empresa_ArrayOfEmpresaClasseDTO
	Local cSoap := ""
	aEval( ::oWSEmpresaClasseDTO , {|x| cSoap := cSoap  +  WSSoapValue("EmpresaClasseDTO", x , x , "EmpresaClasseDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.)  } ) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Empresa_ArrayOfEmpresaClasseDTO
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_EMPRESACLASSEDTO","EmpresaClasseDTO",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSEmpresaClasseDTO , Empresa_EmpresaClasseDTO():New() )
			::oWSEmpresaClasseDTO[len(::oWSEmpresaClasseDTO)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure ArrayOfEmpresaContatoDTO

WSSTRUCT Empresa_ArrayOfEmpresaContatoDTO
	WSDATA   oWSEmpresaContatoDTO      AS Empresa_EmpresaContatoDTO OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Empresa_ArrayOfEmpresaContatoDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Empresa_ArrayOfEmpresaContatoDTO
	::oWSEmpresaContatoDTO := {} // Array Of  Empresa_EMPRESACONTATODTO():New()
Return

WSMETHOD CLONE WSCLIENT Empresa_ArrayOfEmpresaContatoDTO
	Local oClone := Empresa_ArrayOfEmpresaContatoDTO():NEW()
	oClone:oWSEmpresaContatoDTO := NIL
	If ::oWSEmpresaContatoDTO <> NIL 
		oClone:oWSEmpresaContatoDTO := {}
		aEval( ::oWSEmpresaContatoDTO , { |x| aadd( oClone:oWSEmpresaContatoDTO , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT Empresa_ArrayOfEmpresaContatoDTO
	Local cSoap := ""
	aEval( ::oWSEmpresaContatoDTO , {|x| cSoap := cSoap  +  WSSoapValue("EmpresaContatoDTO", x , x , "EmpresaContatoDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.)  } ) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Empresa_ArrayOfEmpresaContatoDTO
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_EMPRESACONTATODTO","EmpresaContatoDTO",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSEmpresaContatoDTO , Empresa_EmpresaContatoDTO():New() )
			::oWSEmpresaContatoDTO[len(::oWSEmpresaContatoDTO)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure ArrayOfEmpresaEnderecoDTO

WSSTRUCT Empresa_ArrayOfEmpresaEnderecoDTO
	WSDATA   oWSEmpresaEnderecoDTO     AS Empresa_EmpresaEnderecoDTO OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Empresa_ArrayOfEmpresaEnderecoDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Empresa_ArrayOfEmpresaEnderecoDTO
	::oWSEmpresaEnderecoDTO := {} // Array Of  Empresa_EMPRESAENDERECODTO():New()
Return

WSMETHOD CLONE WSCLIENT Empresa_ArrayOfEmpresaEnderecoDTO
	Local oClone := Empresa_ArrayOfEmpresaEnderecoDTO():NEW()
	oClone:oWSEmpresaEnderecoDTO := NIL
	If ::oWSEmpresaEnderecoDTO <> NIL 
		oClone:oWSEmpresaEnderecoDTO := {}
		aEval( ::oWSEmpresaEnderecoDTO , { |x| aadd( oClone:oWSEmpresaEnderecoDTO , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT Empresa_ArrayOfEmpresaEnderecoDTO
	Local cSoap := ""
	aEval( ::oWSEmpresaEnderecoDTO , {|x| cSoap := cSoap  +  WSSoapValue("EmpresaEnderecoDTO", x , x , "EmpresaEnderecoDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.)  } ) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Empresa_ArrayOfEmpresaEnderecoDTO
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_EMPRESAENDERECODTO","EmpresaEnderecoDTO",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSEmpresaEnderecoDTO , Empresa_EmpresaEnderecoDTO():New() )
			::oWSEmpresaEnderecoDTO[len(::oWSEmpresaEnderecoDTO)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure ProcessoCotacaoDTO

WSSTRUCT Empresa_ProcessoCotacaoDTO
	WSDATA   csCdCotacaoWBC            AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Empresa_ProcessoCotacaoDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Empresa_ProcessoCotacaoDTO
Return

WSMETHOD CLONE WSCLIENT Empresa_ProcessoCotacaoDTO
	Local oClone := Empresa_ProcessoCotacaoDTO():NEW()
	oClone:csCdCotacaoWBC       := ::csCdCotacaoWBC
Return oClone

WSMETHOD SOAPSEND WSCLIENT Empresa_ProcessoCotacaoDTO
	Local cSoap := ""
	cSoap += WSSoapValue("sCdCotacaoWBC", ::csCdCotacaoWBC, ::csCdCotacaoWBC , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
Return cSoap

// WSDL Data Structure ProcessoLeilaoDTO

WSSTRUCT Empresa_ProcessoLeilaoDTO
	WSDATA   csCdLeilaoWBC             AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Empresa_ProcessoLeilaoDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Empresa_ProcessoLeilaoDTO
Return

WSMETHOD CLONE WSCLIENT Empresa_ProcessoLeilaoDTO
	Local oClone := Empresa_ProcessoLeilaoDTO():NEW()
	oClone:csCdLeilaoWBC        := ::csCdLeilaoWBC
Return oClone

WSMETHOD SOAPSEND WSCLIENT Empresa_ProcessoLeilaoDTO
	Local cSoap := ""
	cSoap += WSSoapValue("sCdLeilaoWBC", ::csCdLeilaoWBC, ::csCdLeilaoWBC , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
Return cSoap

// WSDL Data Structure WbtLogDTO

WSSTRUCT Empresa_WbtLogDTO
	WSDATA   nnCdLog                   AS long OPTIONAL
	WSDATA   nnIdRetorno               AS long OPTIONAL
	WSDATA   csCdOrigem                AS string OPTIONAL
	WSDATA   csDsLog                   AS string OPTIONAL
	WSDATA   csDsTipoDocumento         AS string OPTIONAL
	WSDATA   csNrToken                 AS string OPTIONAL
	WSDATA   ctDtLog                   AS dateTime OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Empresa_WbtLogDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Empresa_WbtLogDTO
Return

WSMETHOD CLONE WSCLIENT Empresa_WbtLogDTO
	Local oClone := Empresa_WbtLogDTO():NEW()
	oClone:nnCdLog              := ::nnCdLog
	oClone:nnIdRetorno          := ::nnIdRetorno
	oClone:csCdOrigem           := ::csCdOrigem
	oClone:csDsLog              := ::csDsLog
	oClone:csDsTipoDocumento    := ::csDsTipoDocumento
	oClone:csNrToken            := ::csNrToken
	oClone:ctDtLog              := ::ctDtLog
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Empresa_WbtLogDTO
	::Init()
	If oResponse = NIL ; Return ; Endif 
	If (::nnCdLog            :=  WSAdvValue( oResponse,"_A_NCDLOG:TEXT","long",NIL,NIL,NIL,"N",NIL,NIL) ) == Nil 
		::nnCdLog            :=  WSAdvValue( oResponse,"_A_NCDLOG","long",NIL,NIL,NIL,"N",NIL,NIL) 
	EndIf
	If (::nnIdRetorno        :=  WSAdvValue( oResponse,"_A_NIDRETORNO:TEXT","long",NIL,NIL,NIL,"N",NIL,NIL) ) == Nil 
		::nnIdRetorno        :=  WSAdvValue( oResponse,"_A_NIDRETORNO","long",NIL,NIL,NIL,"N",NIL,NIL) 
	EndIf
	If (::csCdOrigem         :=  WSAdvValue( oResponse,"_A_SCDORIGEM:TEXT","string",NIL,NIL,NIL,"S",NIL,NIL) ) == Nil 
		::csCdOrigem         :=  WSAdvValue( oResponse,"_A_SCDORIGEM","string",NIL,NIL,NIL,"S",NIL,NIL) 
	EndIf
	If (::csDsLog            :=  WSAdvValue( oResponse,"_A_SDSLOG:TEXT","string",NIL,NIL,NIL,"S",NIL,NIL) ) == Nil
		::csDsLog            :=  WSAdvValue( oResponse,"_A_SDSLOG","string",NIL,NIL,NIL,"S",NIL,NIL) 
	EndIf
	If (::csDsTipoDocumento  :=  WSAdvValue( oResponse,"_A_SDSTIPODOCUMENTO:TEXT","string",NIL,NIL,NIL,"S",NIL,NIL) ) == Nil
		::csDsTipoDocumento  :=  WSAdvValue( oResponse,"_A_SDSTIPODOCUMENTO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	EndIf
	If (::csNrToken          :=  WSAdvValue( oResponse,"_A_SNRTOKEN:TEXT","string",NIL,NIL,NIL,"S",NIL,NIL) ) == Nil
		::csNrToken          :=  WSAdvValue( oResponse,"_A_SNRTOKEN","string",NIL,NIL,NIL,"S",NIL,NIL) 
	EndIf
	If (::ctDtLog            :=  WSAdvValue( oResponse,"_A_TDTLOG:TEXT","dateTime",NIL,NIL,NIL,"S",NIL,NIL) ) == Nil
		::ctDtLog            :=  WSAdvValue( oResponse,"_A_TDTLOG","dateTime",NIL,NIL,NIL,"S",NIL,NIL) 
	EndIf
Return

// WSDL Data Structure CrcHistoricoDTO

WSSTRUCT Empresa_CrcHistoricoDTO
	WSDATA   nnCdCrcHistorico          AS long OPTIONAL
	WSDATA   nnCdVersao                AS long OPTIONAL
	WSDATA   nnNrOrdem                 AS int OPTIONAL
	WSDATA   csDsLink                  AS string OPTIONAL
	WSDATA   csNmDocumento             AS string OPTIONAL
	WSDATA   csSgDocumento             AS string OPTIONAL
	WSDATA   ctDtHistorico             AS dateTime OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Empresa_CrcHistoricoDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Empresa_CrcHistoricoDTO
Return

WSMETHOD CLONE WSCLIENT Empresa_CrcHistoricoDTO
	Local oClone := Empresa_CrcHistoricoDTO():NEW()
	oClone:nnCdCrcHistorico     := ::nnCdCrcHistorico
	oClone:nnCdVersao           := ::nnCdVersao
	oClone:nnNrOrdem            := ::nnNrOrdem
	oClone:csDsLink             := ::csDsLink
	oClone:csNmDocumento        := ::csNmDocumento
	oClone:csSgDocumento        := ::csSgDocumento
	oClone:ctDtHistorico        := ::ctDtHistorico
Return oClone

WSMETHOD SOAPSEND WSCLIENT Empresa_CrcHistoricoDTO
	Local cSoap := ""
	cSoap += WSSoapValue("nCdCrcHistorico", ::nnCdCrcHistorico, ::nnCdCrcHistorico , "long", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("nCdVersao", ::nnCdVersao, ::nnCdVersao , "long", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("nNrOrdem", ::nnNrOrdem, ::nnNrOrdem , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sDsLink", ::csDsLink, ::csDsLink , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sNmDocumento", ::csNmDocumento, ::csNmDocumento , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sSgDocumento", ::csSgDocumento, ::csSgDocumento , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("tDtHistorico", ::ctDtHistorico, ::ctDtHistorico , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Empresa_CrcHistoricoDTO
	::Init()
	If oResponse = NIL ; Return ; Endif 
	If (::nnCdCrcHistorico   :=  WSAdvValue( oResponse,"_A_NCDCRCHISTORICO:TEXT","long",NIL,NIL,NIL,"N",NIL,NIL) ) == Nil
		::nnCdCrcHistorico   :=  WSAdvValue( oResponse,"_A_NCDCRCHISTORICO","long",NIL,NIL,NIL,"N",NIL,NIL)
	EndIf
	If (::nnCdVersao         :=  WSAdvValue( oResponse,"_A_NCDVERSAO:TEXT","long",NIL,NIL,NIL,"N",NIL,NIL) ) == Nil
		::nnCdVersao         :=  WSAdvValue( oResponse,"_A_NCDVERSAO","long",NIL,NIL,NIL,"N",NIL,NIL)
	EndIf
	If (::nnNrOrdem          :=  WSAdvValue( oResponse,"_A_NNRORDEM:TEXT","int",NIL,NIL,NIL,"N",NIL,NIL) ) == Nil
		::nnNrOrdem          :=  WSAdvValue( oResponse,"_A_NNRORDEM","int",NIL,NIL,NIL,"N",NIL,NIL)
	EndIf
	If (::csDsLink           :=  WSAdvValue( oResponse,"_A_SDSLINK:TEXT","string",NIL,NIL,NIL,"S",NIL,NIL) ) == Nil
		::csDsLink           :=  WSAdvValue( oResponse,"_A_SDSLINK","string",NIL,NIL,NIL,"S",NIL,NIL)
	EndIf
	If (::csNmDocumento      :=  WSAdvValue( oResponse,"_A_SNMDOCUMENTO:TEXT","string",NIL,NIL,NIL,"S",NIL,NIL) ) == Nil
		::csNmDocumento      :=  WSAdvValue( oResponse,"_A_SNMDOCUMENTO","string",NIL,NIL,NIL,"S",NIL,NIL)
	EndIf
	If (::csSgDocumento      :=  WSAdvValue( oResponse,"_A_SSGDOCUMENTO:TEXT","string",NIL,NIL,NIL,"S",NIL,NIL) ) == Nil
		::csSgDocumento      :=  WSAdvValue( oResponse,"_A_SSGDOCUMENTO","string",NIL,NIL,NIL,"S",NIL,NIL)
	EndIf
	If (::ctDtHistorico      :=  WSAdvValue( oResponse,"_A_TDTHISTORICO:TEXT","dateTime",NIL,NIL,NIL,"S",NIL,NIL) ) == Nil
		::ctDtHistorico      :=  WSAdvValue( oResponse,"_A_TDTHISTORICO","dateTime",NIL,NIL,NIL,"S",NIL,NIL)
	EndIf
Return

// WSDL Data Structure EmpresaBancoDTO

WSSTRUCT Empresa_EmpresaBancoDTO
	WSDATA   nbFlPrincipal             AS int OPTIONAL
	WSDATA   nnCdTipoConta             AS int OPTIONAL
	WSDATA   csCdAgencia               AS string OPTIONAL
	WSDATA   csCdAgenciaDigito         AS string OPTIONAL
	WSDATA   csCdBanco                 AS string OPTIONAL
	WSDATA   csCdContaCorrente         AS string OPTIONAL
	WSDATA   csCdContaDigito           AS string OPTIONAL
	WSDATA   csCdEmpresa               AS string OPTIONAL
	WSDATA   csCdPais                  AS string OPTIONAL
	WSDATA   csNmTitular               AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Empresa_EmpresaBancoDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Empresa_EmpresaBancoDTO
Return

WSMETHOD CLONE WSCLIENT Empresa_EmpresaBancoDTO
	Local oClone := Empresa_EmpresaBancoDTO():NEW()
	oClone:nbFlPrincipal        := ::nbFlPrincipal
	oClone:nnCdTipoConta        := ::nnCdTipoConta
	oClone:csCdAgencia          := ::csCdAgencia
	oClone:csCdAgenciaDigito    := ::csCdAgenciaDigito
	oClone:csCdBanco            := ::csCdBanco
	oClone:csCdContaCorrente    := ::csCdContaCorrente
	oClone:csCdContaDigito      := ::csCdContaDigito
	oClone:csCdEmpresa          := ::csCdEmpresa
	oClone:csCdPais             := ::csCdPais
	oClone:csNmTitular          := ::csNmTitular
Return oClone

WSMETHOD SOAPSEND WSCLIENT Empresa_EmpresaBancoDTO
	Local cSoap := ""
	cSoap += WSSoapValue("bFlPrincipal", ::nbFlPrincipal, ::nbFlPrincipal , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("nCdTipoConta", ::nnCdTipoConta, ::nnCdTipoConta , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdAgencia", ::csCdAgencia, ::csCdAgencia , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdAgenciaDigito", ::csCdAgenciaDigito, ::csCdAgenciaDigito , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdBanco", ::csCdBanco, ::csCdBanco , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdContaCorrente", ::csCdContaCorrente, ::csCdContaCorrente , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdContaDigito", ::csCdContaDigito, ::csCdContaDigito , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdEmpresa", ::csCdEmpresa, ::csCdEmpresa , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdPais", ::csCdPais, ::csCdPais , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sNmTitular", ::csNmTitular, ::csNmTitular , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Empresa_EmpresaBancoDTO
	::Init()
	If oResponse = NIL ; Return ; Endif 
	If (::nbFlPrincipal      :=  WSAdvValue( oResponse,"_A_BFLPRINCIPAL:TEXT","int",NIL,NIL,NIL,"N",NIL,NIL) ) == Nil
		::nbFlPrincipal      :=  WSAdvValue( oResponse,"_A_BFLPRINCIPAL","int",NIL,NIL,NIL,"N",NIL,NIL)
	EndIf
	If (::nnCdTipoConta      :=  WSAdvValue( oResponse,"_A_NCDTIPOCONTA:TEXT","int",NIL,NIL,NIL,"N",NIL,NIL)  ) == Nil
		::nnCdTipoConta      :=  WSAdvValue( oResponse,"_A_NCDTIPOCONTA","int",NIL,NIL,NIL,"N",NIL,NIL)
	EndIf
	If (::csCdAgencia        :=  WSAdvValue( oResponse,"_A_SCDAGENCIA:TEXT","string",NIL,NIL,NIL,"S",NIL,NIL) ) == Nil
		::csCdAgencia        :=  WSAdvValue( oResponse,"_A_SCDAGENCIA","string",NIL,NIL,NIL,"S",NIL,NIL)
	EndIf 
	If (::csCdAgenciaDigito  :=  WSAdvValue( oResponse,"_A_SCDAGENCIADIGITO:TEXT","string",NIL,NIL,NIL,"S",NIL,NIL) ) == Nil
		::csCdAgenciaDigito  :=  WSAdvValue( oResponse,"_A_SCDAGENCIADIGITO","string",NIL,NIL,NIL,"S",NIL,NIL)
	EndIf 
	If (::csCdBanco          :=  WSAdvValue( oResponse,"_A_SCDBANCO:TEXT","string",NIL,NIL,NIL,"S",NIL,NIL) ) == Nil
		::csCdBanco          :=  WSAdvValue( oResponse,"_A_SCDBANCO","string",NIL,NIL,NIL,"S",NIL,NIL)
	EndIf 
	If (::csCdContaCorrente  :=  WSAdvValue( oResponse,"_A_SCDCONTACORRENTE:TEXT","string",NIL,NIL,NIL,"S",NIL,NIL) ) == Nil
		::csCdContaCorrente  :=  WSAdvValue( oResponse,"_A_SCDCONTACORRENTE","string",NIL,NIL,NIL,"S",NIL,NIL)
	EndIf 
	If (::csCdContaDigito    :=  WSAdvValue( oResponse,"_A_SCDCONTADIGITO:TEXT","string",NIL,NIL,NIL,"S",NIL,NIL) ) == Nil
		::csCdContaDigito    :=  WSAdvValue( oResponse,"_A_SCDCONTADIGITO","string",NIL,NIL,NIL,"S",NIL,NIL)
	EndIf 
	If (::csCdEmpresa        :=  WSAdvValue( oResponse,"_A_SCDEMPRESA:TEXT","string",NIL,NIL,NIL,"S",NIL,NIL) ) == Nil
		::csCdEmpresa        :=  WSAdvValue( oResponse,"_A_SCDEMPRESA","string",NIL,NIL,NIL,"S",NIL,NIL)
	EndIf 
	If (::csCdPais           :=  WSAdvValue( oResponse,"_A_SCDPAIS:TEXT","string",NIL,NIL,NIL,"S",NIL,NIL) ) == Nil
		::csCdPais           :=  WSAdvValue( oResponse,"_A_SCDPAIS","string",NIL,NIL,NIL,"S",NIL,NIL)
	EndIf 
	If (::csNmTitular        :=  WSAdvValue( oResponse,"_A_SNMTITULAR:TEXT","string",NIL,NIL,NIL,"S",NIL,NIL) ) == Nil
		::csNmTitular        :=  WSAdvValue( oResponse,"_A_SNMTITULAR","string",NIL,NIL,NIL,"S",NIL,NIL)
	EndIf 
Return

// WSDL Data Structure EmpresaClasseDTO

WSSTRUCT Empresa_EmpresaClasseDTO
	WSDATA   csCdClasse                AS string OPTIONAL
	WSDATA   csCdEmpresa               AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Empresa_EmpresaClasseDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Empresa_EmpresaClasseDTO
Return

WSMETHOD CLONE WSCLIENT Empresa_EmpresaClasseDTO
	Local oClone := Empresa_EmpresaClasseDTO():NEW()
	oClone:csCdClasse           := ::csCdClasse
	oClone:csCdEmpresa          := ::csCdEmpresa
Return oClone

WSMETHOD SOAPSEND WSCLIENT Empresa_EmpresaClasseDTO
	Local cSoap := ""
	cSoap += WSSoapValue("sCdClasse", ::csCdClasse, ::csCdClasse , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdEmpresa", ::csCdEmpresa, ::csCdEmpresa , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Empresa_EmpresaClasseDTO
	::Init()
	If oResponse = NIL ; Return ; Endif 
	If (::csCdClasse         :=  WSAdvValue( oResponse,"_A_SCDCLASSE:TEXT","string",NIL,NIL,NIL,"S",NIL,NIL) ) == Nil
		::csCdClasse         :=  WSAdvValue( oResponse,"_A_SCDCLASSE","string",NIL,NIL,NIL,"S",NIL,NIL)
	EndIf
	If (::csCdEmpresa        :=  WSAdvValue( oResponse,"_A_SCDEMPRESA:TEXT","string",NIL,NIL,NIL,"S",NIL,NIL)  ) == Nil
		::csCdEmpresa        :=  WSAdvValue( oResponse,"_A_SCDEMPRESA","string",NIL,NIL,NIL,"S",NIL,NIL)
	EndIf
Return

// WSDL Data Structure EmpresaContatoDTO

WSSTRUCT Empresa_EmpresaContatoDTO
	WSDATA   oWSlstDocumentoContato    AS Empresa_ArrayOfDocumentoDTO OPTIONAL
	WSDATA   oWSlstTipoContato         AS Empresa_ArrayOfTipoContatoDTO OPTIONAL
	WSDATA   nnCdContato               AS long OPTIONAL
	WSDATA   csDsCargo                 AS string OPTIONAL
	WSDATA   csDsEmail                 AS string OPTIONAL
	WSDATA   csNmContato               AS string OPTIONAL
	WSDATA   csNrCelular               AS string OPTIONAL
	WSDATA   csNrRamal                 AS string OPTIONAL
	WSDATA   csNrTelefone              AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Empresa_EmpresaContatoDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Empresa_EmpresaContatoDTO
Return

WSMETHOD CLONE WSCLIENT Empresa_EmpresaContatoDTO
	Local oClone := Empresa_EmpresaContatoDTO():NEW()
	oClone:oWSlstDocumentoContato := IIF(::oWSlstDocumentoContato = NIL , NIL , ::oWSlstDocumentoContato:Clone() )
	oClone:oWSlstTipoContato    := IIF(::oWSlstTipoContato = NIL , NIL , ::oWSlstTipoContato:Clone() )
	oClone:nnCdContato          := ::nnCdContato
	oClone:csDsCargo            := ::csDsCargo
	oClone:csDsEmail            := ::csDsEmail
	oClone:csNmContato          := ::csNmContato
	oClone:csNrCelular          := ::csNrCelular
	oClone:csNrRamal            := ::csNrRamal
	oClone:csNrTelefone         := ::csNrTelefone
Return oClone

WSMETHOD SOAPSEND WSCLIENT Empresa_EmpresaContatoDTO
	Local cSoap := ""
	cSoap += WSSoapValue("lstDocumentoContato", ::oWSlstDocumentoContato, ::oWSlstDocumentoContato , "ArrayOfDocumentoDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("lstTipoContato", ::oWSlstTipoContato, ::oWSlstTipoContato , "ArrayOfTipoContatoDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("nCdContato", ::nnCdContato, ::nnCdContato , "long", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sDsCargo", ::csDsCargo, ::csDsCargo , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sDsEmail", ::csDsEmail, ::csDsEmail , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sNmContato", ::csNmContato, ::csNmContato , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sNrCelular", ::csNrCelular, ::csNrCelular , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sNrRamal", ::csNrRamal, ::csNrRamal , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sNrTelefone", ::csNrTelefone, ::csNrTelefone , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Empresa_EmpresaContatoDTO
	Local oNode1
	Local oNode2
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_LSTDOCUMENTOCONTATO","ArrayOfDocumentoDTO",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode1 != NIL
		::oWSlstDocumentoContato := Empresa_ArrayOfDocumentoDTO():New()
		::oWSlstDocumentoContato:SoapRecv(oNode1)
	EndIf
	oNode2 :=  WSAdvValue( oResponse,"_LSTTIPOCONTATO","ArrayOfTipoContatoDTO",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode2 != NIL
		::oWSlstTipoContato := Empresa_ArrayOfTipoContatoDTO():New()
		::oWSlstTipoContato:SoapRecv(oNode2)
	EndIf
	If (::nnCdContato        :=  WSAdvValue( oResponse,"_A_NCDCONTATO:TEXT","long",NIL,NIL,NIL,"N",NIL,NIL) ) == Nil
		::nnCdContato        :=  WSAdvValue( oResponse,"_A_NCDCONTATO","long",NIL,NIL,NIL,"N",NIL,NIL)
	EndIf
	If (::csDsCargo          :=  WSAdvValue( oResponse,"_A_SDSCARGO:TEXT","string",NIL,NIL,NIL,"S",NIL,NIL)  ) == Nil
		::csDsCargo          :=  WSAdvValue( oResponse,"_A_SDSCARGO","string",NIL,NIL,NIL,"S",NIL,NIL)
	EndIf
	If (::csDsEmail          :=  WSAdvValue( oResponse,"_A_SDSEMAIL:TEXT","string",NIL,NIL,NIL,"S",NIL,NIL) ) == Nil
		::csDsEmail          :=  WSAdvValue( oResponse,"_A_SDSEMAIL","string",NIL,NIL,NIL,"S",NIL,NIL)
	EndIf 
	If (::csNmContato        :=  WSAdvValue( oResponse,"_A_SNMCONTATO:TEXT","string",NIL,NIL,NIL,"S",NIL,NIL) ) == Nil
		::csNmContato        :=  WSAdvValue( oResponse,"_A_SNMCONTATO","string",NIL,NIL,NIL,"S",NIL,NIL)
	EndIf 
	If (::csNrCelular        :=  WSAdvValue( oResponse,"_A_SNRCELULAR:TEXT","string",NIL,NIL,NIL,"S",NIL,NIL) ) == Nil
		::csNrCelular        :=  WSAdvValue( oResponse,"_A_SNRCELULAR","string",NIL,NIL,NIL,"S",NIL,NIL)
	EndIf 
	If (::csNrRamal          :=  WSAdvValue( oResponse,"_A_SNRRAMAL:TEXT","string",NIL,NIL,NIL,"S",NIL,NIL) ) == Nil
		::csNrRamal          :=  WSAdvValue( oResponse,"_A_SNRRAMAL","string",NIL,NIL,NIL,"S",NIL,NIL)
	EndIf 
	If (::csNrTelefone       :=  WSAdvValue( oResponse,"_A_SNRTELEFONE:TEXT","string",NIL,NIL,NIL,"S",NIL,NIL) ) == Nil
		::csNrTelefone       :=  WSAdvValue( oResponse,"_A_SNRTELEFONE","string",NIL,NIL,NIL,"S",NIL,NIL)
	EndIf 
Return

// WSDL Data Structure EmpresaEnderecoDTO

WSSTRUCT Empresa_EmpresaEnderecoDTO
	WSDATA   nbFlPrincipal             AS int OPTIONAL
	WSDATA   nnCdEmpresaEndereco       AS long OPTIONAL
	WSDATA   nnCdEndereco              AS long OPTIONAL
	WSDATA   csCdEstado                AS string OPTIONAL
	WSDATA   csCdPais                  AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Empresa_EmpresaEnderecoDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Empresa_EmpresaEnderecoDTO
Return

WSMETHOD CLONE WSCLIENT Empresa_EmpresaEnderecoDTO
	Local oClone := Empresa_EmpresaEnderecoDTO():NEW()
	oClone:nbFlPrincipal        := ::nbFlPrincipal
	oClone:nnCdEmpresaEndereco  := ::nnCdEmpresaEndereco
	oClone:nnCdEndereco         := ::nnCdEndereco
	oClone:csCdEstado           := ::csCdEstado
	oClone:csCdPais             := ::csCdPais
Return oClone

WSMETHOD SOAPSEND WSCLIENT Empresa_EmpresaEnderecoDTO
	Local cSoap := ""
	cSoap += WSSoapValue("bFlPrincipal", ::nbFlPrincipal, ::nbFlPrincipal , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("nCdEmpresaEndereco", ::nnCdEmpresaEndereco, ::nnCdEmpresaEndereco , "long", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("nCdEndereco", ::nnCdEndereco, ::nnCdEndereco , "long", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdEstado", ::csCdEstado, ::csCdEstado , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdPais", ::csCdPais, ::csCdPais , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Empresa_EmpresaEnderecoDTO
	::Init()
	If oResponse = NIL ; Return ; Endif 
	If (::nbFlPrincipal      :=  WSAdvValue( oResponse,"_A_BFLPRINCIPAL:TEXT","int",NIL,NIL,NIL,"N",NIL,NIL) ) == Nil
		::nbFlPrincipal      :=  WSAdvValue( oResponse,"_A_BFLPRINCIPAL","int",NIL,NIL,NIL,"N",NIL,NIL)
	EndIf
	If (::nnCdEmpresaEndereco :=  WSAdvValue( oResponse,"_A_NCDEMPRESAENDERECO:TEXT","long",NIL,NIL,NIL,"N",NIL,NIL) ) == Nil
		::nnCdEmpresaEndereco :=  WSAdvValue( oResponse,"_A_NCDEMPRESAENDERECO","long",NIL,NIL,NIL,"N",NIL,NIL)
	EndIf 
	If (::nnCdEndereco       :=  WSAdvValue( oResponse,"_A_NCDENDERECO:TEXT","long",NIL,NIL,NIL,"N",NIL,NIL) ) == Nil
		::nnCdEndereco       :=  WSAdvValue( oResponse,"_A_NCDENDERECO","long",NIL,NIL,NIL,"N",NIL,NIL)
	EndIf 
	If (::csCdEstado         :=  WSAdvValue( oResponse,"_A_SCDESTADO:TEXT","string",NIL,NIL,NIL,"S",NIL,NIL) ) == Nil
		::csCdEstado         :=  WSAdvValue( oResponse,"_A_SCDESTADO","string",NIL,NIL,NIL,"S",NIL,NIL)
	EndIf 
	If (::csCdPais           :=  WSAdvValue( oResponse,"_A_SCDPAIS:TEXT","string",NIL,NIL,NIL,"S",NIL,NIL) ) == Nil
		::csCdPais           :=  WSAdvValue( oResponse,"_A_SCDPAIS","string",NIL,NIL,NIL,"S",NIL,NIL)
	EndIf 
Return

// WSDL Data Structure ArrayOfDocumentoDTO

WSSTRUCT Empresa_ArrayOfDocumentoDTO
	WSDATA   oWSDocumentoDTO           AS Empresa_DocumentoDTO OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Empresa_ArrayOfDocumentoDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Empresa_ArrayOfDocumentoDTO
	::oWSDocumentoDTO      := {} // Array Of  Empresa_DOCUMENTODTO():New()
Return

WSMETHOD CLONE WSCLIENT Empresa_ArrayOfDocumentoDTO
	Local oClone := Empresa_ArrayOfDocumentoDTO():NEW()
	oClone:oWSDocumentoDTO := NIL
	If ::oWSDocumentoDTO <> NIL 
		oClone:oWSDocumentoDTO := {}
		aEval( ::oWSDocumentoDTO , { |x| aadd( oClone:oWSDocumentoDTO , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT Empresa_ArrayOfDocumentoDTO
	Local cSoap := ""
	aEval( ::oWSDocumentoDTO , {|x| cSoap := cSoap  +  WSSoapValue("DocumentoDTO", x , x , "DocumentoDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.)  } ) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Empresa_ArrayOfDocumentoDTO
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_DOCUMENTODTO","DocumentoDTO",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSDocumentoDTO , Empresa_DocumentoDTO():New() )
			::oWSDocumentoDTO[len(::oWSDocumentoDTO)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure ArrayOfTipoContatoDTO

WSSTRUCT Empresa_ArrayOfTipoContatoDTO
	WSDATA   oWSTipoContatoDTO         AS Empresa_TipoContatoDTO OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Empresa_ArrayOfTipoContatoDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Empresa_ArrayOfTipoContatoDTO
	::oWSTipoContatoDTO    := {} // Array Of  Empresa_TIPOCONTATODTO():New()
Return

WSMETHOD CLONE WSCLIENT Empresa_ArrayOfTipoContatoDTO
	Local oClone := Empresa_ArrayOfTipoContatoDTO():NEW()
	oClone:oWSTipoContatoDTO := NIL
	If ::oWSTipoContatoDTO <> NIL 
		oClone:oWSTipoContatoDTO := {}
		aEval( ::oWSTipoContatoDTO , { |x| aadd( oClone:oWSTipoContatoDTO , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT Empresa_ArrayOfTipoContatoDTO
	Local cSoap := ""
	aEval( ::oWSTipoContatoDTO , {|x| cSoap := cSoap  +  WSSoapValue("TipoContatoDTO", x , x , "TipoContatoDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.)  } ) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Empresa_ArrayOfTipoContatoDTO
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_TIPOCONTATODTO","TipoContatoDTO",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSTipoContatoDTO , Empresa_TipoContatoDTO():New() )
			::oWSTipoContatoDTO[len(::oWSTipoContatoDTO)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure DocumentoDTO

WSSTRUCT Empresa_DocumentoDTO
	WSDATA   nbFlAtivo                 AS int OPTIONAL
	WSDATA   nbFlIsento                AS int OPTIONAL
	WSDATA   csCdDocumentoWBC          AS string OPTIONAL
	WSDATA   ctDtVencimento            AS dateTime OPTIONAL
	WSDATA   ctDtVencimentoFatorExterno AS dateTime OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Empresa_DocumentoDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Empresa_DocumentoDTO
Return

WSMETHOD CLONE WSCLIENT Empresa_DocumentoDTO
	Local oClone := Empresa_DocumentoDTO():NEW()
	oClone:nbFlAtivo            := ::nbFlAtivo
	oClone:nbFlIsento           := ::nbFlIsento
	oClone:csCdDocumentoWBC     := ::csCdDocumentoWBC
	oClone:ctDtVencimento       := ::ctDtVencimento
	oClone:ctDtVencimentoFatorExterno := ::ctDtVencimentoFatorExterno
Return oClone

WSMETHOD SOAPSEND WSCLIENT Empresa_DocumentoDTO
	Local cSoap := ""
	cSoap += WSSoapValue("bFlAtivo", ::nbFlAtivo, ::nbFlAtivo , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("bFlIsento", ::nbFlIsento, ::nbFlIsento , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdDocumentoWBC", ::csCdDocumentoWBC, ::csCdDocumentoWBC , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("tDtVencimento", ::ctDtVencimento, ::ctDtVencimento , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("tDtVencimentoFatorExterno", ::ctDtVencimentoFatorExterno, ::ctDtVencimentoFatorExterno , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Empresa_DocumentoDTO
	::Init()
	If oResponse = NIL ; Return ; Endif 
	If (::nbFlAtivo          :=  WSAdvValue( oResponse,"_A_BFLATIVO:TEXT","int",NIL,NIL,NIL,"N",NIL,NIL) ) == Nil
		::nbFlAtivo          :=  WSAdvValue( oResponse,"_A_BFLATIVO","int",NIL,NIL,NIL,"N",NIL,NIL)
	EndIf
	If (::nbFlIsento         :=  WSAdvValue( oResponse,"_A_BFLISENTO:TEXT","int",NIL,NIL,NIL,"N",NIL,NIL) ) == Nil
		::nbFlIsento         :=  WSAdvValue( oResponse,"_A_BFLISENTO","int",NIL,NIL,NIL,"N",NIL,NIL)
	EndIf 
	If (::csCdDocumentoWBC   :=  WSAdvValue( oResponse,"_A_SCDDOCUMENTOWBC:TEXT","string",NIL,NIL,NIL,"S",NIL,NIL) ) == Nil
		::csCdDocumentoWBC   :=  WSAdvValue( oResponse,"_A_SCDDOCUMENTOWBC","string",NIL,NIL,NIL,"S",NIL,NIL)
	EndIf 
	If (::ctDtVencimento     :=  WSAdvValue( oResponse,"_A_TDTVENCIMENTO:TEXT","dateTime",NIL,NIL,NIL,"S",NIL,NIL) ) == Nil
		::ctDtVencimento     :=  WSAdvValue( oResponse,"_A_TDTVENCIMENTO","dateTime",NIL,NIL,NIL,"S",NIL,NIL)
	EndIf 
	If (::ctDtVencimentoFatorExterno :=  WSAdvValue( oResponse,"_A_TDTVENCIMENTOFATOREXTERNO:TEXT","dateTime",NIL,NIL,NIL,"S",NIL,NIL) ) == Nil
		::ctDtVencimentoFatorExterno :=  WSAdvValue( oResponse,"_A_TDTVENCIMENTOFATOREXTERNO","dateTime",NIL,NIL,NIL,"S",NIL,NIL)
	EndIf	 
Return

// WSDL Data Structure TipoContatoDTO

WSSTRUCT Empresa_TipoContatoDTO
	WSDATA   csCdTipoContato           AS string OPTIONAL
	WSDATA   csDsTipoContato           AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Empresa_TipoContatoDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Empresa_TipoContatoDTO
Return

WSMETHOD CLONE WSCLIENT Empresa_TipoContatoDTO
	Local oClone := Empresa_TipoContatoDTO():NEW()
	oClone:csCdTipoContato      := ::csCdTipoContato
	oClone:csDsTipoContato      := ::csDsTipoContato
Return oClone

WSMETHOD SOAPSEND WSCLIENT Empresa_TipoContatoDTO
	Local cSoap := ""
	cSoap += WSSoapValue("sCdTipoContato", ::csCdTipoContato, ::csCdTipoContato , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sDsTipoContato", ::csDsTipoContato, ::csDsTipoContato , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Empresa_TipoContatoDTO
	::Init()
	If oResponse = NIL ; Return ; Endif 
	If (::csCdTipoContato    :=  WSAdvValue( oResponse,"_A_SCDTIPOCONTATO:TEXT","string",NIL,NIL,NIL,"S",NIL,NIL) ) == Nil
		::csCdTipoContato    :=  WSAdvValue( oResponse,"_A_SCDTIPOCONTATO","string",NIL,NIL,NIL,"S",NIL,NIL)
	EndIf
	If (::csDsTipoContato    :=  WSAdvValue( oResponse,"_A_SDSTIPOCONTATO:TEXT","string",NIL,NIL,NIL,"S",NIL,NIL) ) == Nil
		::csDsTipoContato    :=  WSAdvValue( oResponse,"_A_SDSTIPOCONTATO","string",NIL,NIL,NIL,"S",NIL,NIL)
	EndIf  
Return


