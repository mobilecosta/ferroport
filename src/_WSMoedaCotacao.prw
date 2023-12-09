#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"

/* ===============================================================================
WSDL Location    http://compras-hml.mafrahospitalar.com.br/mafra-hml/services/MoedaCotacao.svc?wsdl
Gerado em        03/18/20 14:06:45
Observações      Código-Fonte gerado por ADVPL WSDL Client 1.120703
                 Alterações neste arquivo podem causar funcionamento incorreto
                 e serão perdidas caso o código-fonte seja gerado novamente.
=============================================================================== */

User Function _PZWRJPR ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSMoedaCotacao
------------------------------------------------------------------------------- */

WSCLIENT WSMoedaCotacao

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD ProcessarMoedaCotacao

	WSDATA   _URL                      AS String
	WSDATA   _CERT                     AS String
	WSDATA   _PRIVKEY                  AS String
	WSDATA   _PASSPHRASE               AS String
	WSDATA   _HEADOUT                  AS Array of String
	WSDATA   _COOKIES                  AS Array of String
	WSDATA   oWSlstMoedaCotacao        AS MoedaCotacao_ArrayOfMoedaCotacaoDTO
	WSDATA   oWSProcessarMoedaCotacaoResult AS MoedaCotacao_RetornoDTO

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSMoedaCotacao
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.170117A-20200102] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSMoedaCotacao
	::oWSlstMoedaCotacao := MoedaCotacao_ARRAYOFMOEDACOTACAODTO():New()
	::oWSProcessarMoedaCotacaoResult := MoedaCotacao_RETORNODTO():New()
Return

WSMETHOD RESET WSCLIENT WSMoedaCotacao
	::oWSlstMoedaCotacao := NIL 
	::oWSProcessarMoedaCotacaoResult := NIL 
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSMoedaCotacao
Local oClone := WSMoedaCotacao():New()
	oClone:_URL          := ::_URL 
	oClone:_CERT         := ::_CERT 
	oClone:_PRIVKEY      := ::_PRIVKEY 
	oClone:_PASSPHRASE   := ::_PASSPHRASE 
	oClone:oWSlstMoedaCotacao :=  IIF(::oWSlstMoedaCotacao = NIL , NIL ,::oWSlstMoedaCotacao:Clone() )
	oClone:oWSProcessarMoedaCotacaoResult :=  IIF(::oWSProcessarMoedaCotacaoResult = NIL , NIL ,::oWSProcessarMoedaCotacaoResult:Clone() )
Return oClone

// WSDL Method ProcessarMoedaCotacao of Service WSMoedaCotacao

WSMETHOD ProcessarMoedaCotacao WSSEND oWSlstMoedaCotacao WSRECEIVE oWSProcessarMoedaCotacaoResult WSCLIENT WSMoedaCotacao
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ProcessarMoedaCotacao xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("lstMoedaCotacao", ::oWSlstMoedaCotacao, oWSlstMoedaCotacao , "ArrayOfMoedaCotacaoDTO", .F. , .F., 0 , "http://tempuri.org/", .F.,.F.) 
cSoap += "</ProcessarMoedaCotacao>"

Self:_HEADOUT := { "Authorization: Bearer " + U_NewToken() }
oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/IMoedaCotacao/ProcessarMoedaCotacao",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	Lower(AllTrim(GetMv("MV_XPARURL"))) + "/Services/MoedaCotacao.svc")

::Init()
::oWSProcessarMoedaCotacaoResult:SoapRecv( WSAdvValue( oXmlRet,"_PROCESSARMOEDACOTACAORESPONSE:_PROCESSARMOEDACOTACAORESULT","RetornoDTO",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return {.T.,cSoap}


// WSDL Data Structure ArrayOfMoedaCotacaoDTO

WSSTRUCT MoedaCotacao_ArrayOfMoedaCotacaoDTO
	WSDATA   oWSMoedaCotacaoDTO        AS MoedaCotacao_MoedaCotacaoDTO OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT MoedaCotacao_ArrayOfMoedaCotacaoDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT MoedaCotacao_ArrayOfMoedaCotacaoDTO
	::oWSMoedaCotacaoDTO   := {} // Array Of  MoedaCotacao_MOEDACOTACAODTO():New()
Return

WSMETHOD CLONE WSCLIENT MoedaCotacao_ArrayOfMoedaCotacaoDTO
	Local oClone := MoedaCotacao_ArrayOfMoedaCotacaoDTO():NEW()
	oClone:oWSMoedaCotacaoDTO := NIL
	If ::oWSMoedaCotacaoDTO <> NIL 
		oClone:oWSMoedaCotacaoDTO := {}
		aEval( ::oWSMoedaCotacaoDTO , { |x| aadd( oClone:oWSMoedaCotacaoDTO , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT MoedaCotacao_ArrayOfMoedaCotacaoDTO
	Local cSoap := ""
	aEval( ::oWSMoedaCotacaoDTO , {|x| cSoap := cSoap  +  WSSoapValue("MoedaCotacaoDTO", x , x , "MoedaCotacaoDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.)  } ) 
Return cSoap

// WSDL Data Structure RetornoDTO

WSSTRUCT MoedaCotacao_RetornoDTO
	WSDATA   oWSlstWbtLogDTO           AS MoedaCotacao_ArrayOfWbtLogDTO OPTIONAL
	WSDATA   nnIdRetorno               AS long OPTIONAL
	WSDATA   csNrToken                 AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT MoedaCotacao_RetornoDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT MoedaCotacao_RetornoDTO
Return

WSMETHOD CLONE WSCLIENT MoedaCotacao_RetornoDTO
	Local oClone := MoedaCotacao_RetornoDTO():NEW()
	oClone:oWSlstWbtLogDTO      := IIF(::oWSlstWbtLogDTO = NIL , NIL , ::oWSlstWbtLogDTO:Clone() )
	oClone:nnIdRetorno          := ::nnIdRetorno
	oClone:csNrToken            := ::csNrToken
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT MoedaCotacao_RetornoDTO
	Local oNode1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_LSTWBTLOGDTO","ArrayOfWbtLogDTO",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode1 != NIL
		::oWSlstWbtLogDTO := MoedaCotacao_ArrayOfWbtLogDTO():New()
		::oWSlstWbtLogDTO:SoapRecv(oNode1)
	EndIf
	::nnIdRetorno        :=  WSAdvValue( oResponse,"_NIDRETORNO","long",NIL,NIL,NIL,"N",NIL,NIL) 
	::csNrToken          :=  WSAdvValue( oResponse,"_SNRTOKEN","string",NIL,NIL,NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure MoedaCotacaoDTO

WSSTRUCT MoedaCotacao_MoedaCotacaoDTO
	WSDATA   ndVlMoedaCotacao          AS decimal OPTIONAL
	WSDATA   csCdMoedaDestino          AS string OPTIONAL
	WSDATA   csCdMoedaOrigem           AS string OPTIONAL
	WSDATA   ctDtMoedaCotacao          AS dateTime OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT MoedaCotacao_MoedaCotacaoDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT MoedaCotacao_MoedaCotacaoDTO
Return

WSMETHOD CLONE WSCLIENT MoedaCotacao_MoedaCotacaoDTO
	Local oClone := MoedaCotacao_MoedaCotacaoDTO():NEW()
	oClone:ndVlMoedaCotacao     := ::ndVlMoedaCotacao
	oClone:csCdMoedaDestino     := ::csCdMoedaDestino
	oClone:csCdMoedaOrigem      := ::csCdMoedaOrigem
	oClone:ctDtMoedaCotacao     := ::ctDtMoedaCotacao
Return oClone

WSMETHOD SOAPSEND WSCLIENT MoedaCotacao_MoedaCotacaoDTO
	Local cSoap := ""
	cSoap += WSSoapValue("dVlMoedaCotacao", ::ndVlMoedaCotacao, ::ndVlMoedaCotacao , "decimal", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdMoedaDestino", ::csCdMoedaDestino, ::csCdMoedaDestino , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdMoedaOrigem", ::csCdMoedaOrigem, ::csCdMoedaOrigem , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("tDtMoedaCotacao", ::ctDtMoedaCotacao, ::ctDtMoedaCotacao , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
Return cSoap

// WSDL Data Structure ArrayOfWbtLogDTO

WSSTRUCT MoedaCotacao_ArrayOfWbtLogDTO
	WSDATA   oWSWbtLogDTO              AS MoedaCotacao_WbtLogDTO OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT MoedaCotacao_ArrayOfWbtLogDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT MoedaCotacao_ArrayOfWbtLogDTO
	::oWSWbtLogDTO         := {} // Array Of  MoedaCotacao_WBTLOGDTO():New()
Return

WSMETHOD CLONE WSCLIENT MoedaCotacao_ArrayOfWbtLogDTO
	Local oClone := MoedaCotacao_ArrayOfWbtLogDTO():NEW()
	oClone:oWSWbtLogDTO := NIL
	If ::oWSWbtLogDTO <> NIL 
		oClone:oWSWbtLogDTO := {}
		aEval( ::oWSWbtLogDTO , { |x| aadd( oClone:oWSWbtLogDTO , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT MoedaCotacao_ArrayOfWbtLogDTO
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_WBTLOGDTO","WbtLogDTO",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSWbtLogDTO , MoedaCotacao_WbtLogDTO():New() )
			::oWSWbtLogDTO[len(::oWSWbtLogDTO)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure WbtLogDTO

WSSTRUCT MoedaCotacao_WbtLogDTO
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

WSMETHOD NEW WSCLIENT MoedaCotacao_WbtLogDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT MoedaCotacao_WbtLogDTO
Return

WSMETHOD CLONE WSCLIENT MoedaCotacao_WbtLogDTO
	Local oClone := MoedaCotacao_WbtLogDTO():NEW()
	oClone:nnCdLog              := ::nnCdLog
	oClone:nnIdRetorno          := ::nnIdRetorno
	oClone:csCdOrigem           := ::csCdOrigem
	oClone:csDsLog              := ::csDsLog
	oClone:csDsTipoDocumento    := ::csDsTipoDocumento
	oClone:csNrToken            := ::csNrToken
	oClone:ctDtLog              := ::ctDtLog
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT MoedaCotacao_WbtLogDTO
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::nnCdLog            :=  WSAdvValue( oResponse,"_NCDLOG","long",NIL,NIL,NIL,"N",NIL,NIL) 
	::nnIdRetorno        :=  WSAdvValue( oResponse,"_NIDRETORNO","long",NIL,NIL,NIL,"N",NIL,NIL) 
	::csCdOrigem         :=  WSAdvValue( oResponse,"_SCDORIGEM","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csDsLog            :=  WSAdvValue( oResponse,"_SDSLOG","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csDsTipoDocumento  :=  WSAdvValue( oResponse,"_SDSTIPODOCUMENTO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csNrToken          :=  WSAdvValue( oResponse,"_SNRTOKEN","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::ctDtLog            :=  WSAdvValue( oResponse,"_TDTLOG","dateTime",NIL,NIL,NIL,"S",NIL,NIL) 
Return


