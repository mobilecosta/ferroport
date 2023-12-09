#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"

/*=================================================================================================================*\
|| ############################################################################################################### ||
||																	                                               ||
|| # WSDL Service WSEmpresaCondicaoPagamento																	 # ||
|| # WSDL Location: https://srm-hml.paradigmabs.com.br/cassi-hml/services/EmpresaCondicaoPagamento.svc?wsdl		 # ||
||																	                                               ||
|| # Data - 10/05/2019 																							 # ||
||																	                                               ||
|| # Desc: WebService de cadastro de Condição de Pagamento de Empresas.											 # ||
||																	                                               ||
|| # Obs: Alterações neste arquivo podem causar funcionamento incorreto.										 # ||
||																	                                               ||
|| ############################################################################################################### ||
\*=================================================================================================================*/
User Function _JLXASRF ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSEmpresaCondicaoPagamento
------------------------------------------------------------------------------- */

WSCLIENT WSEmpresaCondicaoPagamento

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD ProcessarEmpresaCondicaoPagamento

	WSDATA   _URL                      AS String
	WSDATA   _CERT                     AS String
	WSDATA   _PRIVKEY                  AS String
	WSDATA   _PASSPHRASE               AS String
	WSDATA   _HEADOUT                  AS Array of String
	WSDATA   _COOKIES                  AS Array of String
	WSDATA   oWSlstEmpresaCondicaoPagamento AS EmpresaCondicaoPagamento_ArrayOfEmpresaCondicaoPagamentoDTO
	WSDATA   oWSProcessarEmpresaCondicaoPagamentoResult AS EmpresaCondicaoPagamento_RetornoDTO

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSEmpresaCondicaoPagamento
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.131227A-20190114 NG] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSEmpresaCondicaoPagamento
	::oWSlstEmpresaCondicaoPagamento := EmpresaCondicaoPagamento_ARRAYOFEMPRESACONDICAOPAGAMENTODTO():New()
	::oWSProcessarEmpresaCondicaoPagamentoResult := EmpresaCondicaoPagamento_RETORNODTO():New()
Return

WSMETHOD RESET WSCLIENT WSEmpresaCondicaoPagamento
	::oWSlstEmpresaCondicaoPagamento := NIL 
	::oWSProcessarEmpresaCondicaoPagamentoResult := NIL 
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSEmpresaCondicaoPagamento
Local oClone := WSEmpresaCondicaoPagamento():New()
	oClone:_URL          := ::_URL 
	oClone:_CERT         := ::_CERT 
	oClone:_PRIVKEY      := ::_PRIVKEY 
	oClone:_PASSPHRASE   := ::_PASSPHRASE 
	oClone:oWSlstEmpresaCondicaoPagamento :=  IIF(::oWSlstEmpresaCondicaoPagamento = NIL , NIL ,::oWSlstEmpresaCondicaoPagamento:Clone() )
	oClone:oWSProcessarEmpresaCondicaoPagamentoResult :=  IIF(::oWSProcessarEmpresaCondicaoPagamentoResult = NIL , NIL ,::oWSProcessarEmpresaCondicaoPagamentoResult:Clone() )
Return oClone

// WSDL Method ProcessarEmpresaCondicaoPagamento of Service WSEmpresaCondicaoPagamento

WSMETHOD ProcessarEmpresaCondicaoPagamento WSSEND oWSlstEmpresaCondicaoPagamento WSRECEIVE oWSProcessarEmpresaCondicaoPagamentoResult WSCLIENT WSEmpresaCondicaoPagamento
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ProcessarEmpresaCondicaoPagamento xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("lstEmpresaCondicaoPagamento", ::oWSlstEmpresaCondicaoPagamento, oWSlstEmpresaCondicaoPagamento , "ArrayOfEmpresaCondicaoPagamentoDTO", .F. , .F., 0 , "http://tempuri.org/", .F.,.F.) 
cSoap += "</ProcessarEmpresaCondicaoPagamento>"

Self:_HEADOUT := { "Authorization: Bearer " + U_NewToken() }
oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tempuri.org/IEmpresaCondicaoPagamento/ProcessarEmpresaCondicaoPagamento",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	Lower(AllTrim(GetMv("MV_XPARURL"))) + "/services/EmpresaCondicaoPagamento.svc")

::Init()
::oWSProcessarEmpresaCondicaoPagamentoResult:SoapRecv( WSAdvValue( oXmlRet,"_PROCESSAREMPRESACONDICAOPAGAMENTORESPONSE:_PROCESSAREMPRESACONDICAOPAGAMENTORESULT","RetornoDTO",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.


// WSDL Data Structure ArrayOfEmpresaCondicaoPagamentoDTO

WSSTRUCT EmpresaCondicaoPagamento_ArrayOfEmpresaCondicaoPagamentoDTO
	WSDATA   oWSEmpresaCondicaoPagamentoDTO AS EmpresaCondicaoPagamento_EmpresaCondicaoPagamentoDTO OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT EmpresaCondicaoPagamento_ArrayOfEmpresaCondicaoPagamentoDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT EmpresaCondicaoPagamento_ArrayOfEmpresaCondicaoPagamentoDTO
	::oWSEmpresaCondicaoPagamentoDTO := {} // Array Of  EmpresaCondicaoPagamento_EMPRESACONDICAOPAGAMENTODTO():New()
Return

WSMETHOD CLONE WSCLIENT EmpresaCondicaoPagamento_ArrayOfEmpresaCondicaoPagamentoDTO
	Local oClone := EmpresaCondicaoPagamento_ArrayOfEmpresaCondicaoPagamentoDTO():NEW()
	oClone:oWSEmpresaCondicaoPagamentoDTO := NIL
	If ::oWSEmpresaCondicaoPagamentoDTO <> NIL 
		oClone:oWSEmpresaCondicaoPagamentoDTO := {}
		aEval( ::oWSEmpresaCondicaoPagamentoDTO , { |x| aadd( oClone:oWSEmpresaCondicaoPagamentoDTO , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT EmpresaCondicaoPagamento_ArrayOfEmpresaCondicaoPagamentoDTO
	Local cSoap := ""
	aEval( ::oWSEmpresaCondicaoPagamentoDTO , {|x| cSoap := cSoap  +  WSSoapValue("EmpresaCondicaoPagamentoDTO", x , x , "EmpresaCondicaoPagamentoDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.)  } ) 
Return cSoap

// WSDL Data Structure RetornoDTO

WSSTRUCT EmpresaCondicaoPagamento_RetornoDTO
	WSDATA   oWSlstWbtLogDTO           AS EmpresaCondicaoPagamento_ArrayOfWbtLogDTO OPTIONAL
	WSDATA   nnIdRetorno               AS long OPTIONAL
	WSDATA   csNrToken                 AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT EmpresaCondicaoPagamento_RetornoDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT EmpresaCondicaoPagamento_RetornoDTO
Return

WSMETHOD CLONE WSCLIENT EmpresaCondicaoPagamento_RetornoDTO
	Local oClone := EmpresaCondicaoPagamento_RetornoDTO():NEW()
	oClone:oWSlstWbtLogDTO      := IIF(::oWSlstWbtLogDTO = NIL , NIL , ::oWSlstWbtLogDTO:Clone() )
	oClone:nnIdRetorno          := ::nnIdRetorno
	oClone:csNrToken            := ::csNrToken
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT EmpresaCondicaoPagamento_RetornoDTO
	Local oNode1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_LSTWBTLOGDTO","ArrayOfWbtLogDTO",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode1 != NIL
		::oWSlstWbtLogDTO := EmpresaCondicaoPagamento_ArrayOfWbtLogDTO():New()
		::oWSlstWbtLogDTO:SoapRecv(oNode1)
	EndIf
	::nnIdRetorno        :=  WSAdvValue( oResponse,"_NIDRETORNO","long",NIL,NIL,NIL,"N",NIL,NIL) 
	::csNrToken          :=  WSAdvValue( oResponse,"_SNRTOKEN","string",NIL,NIL,NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure EmpresaCondicaoPagamentoDTO

WSSTRUCT EmpresaCondicaoPagamento_EmpresaCondicaoPagamentoDTO
	WSDATA   csCdCondicaoPagamento     AS string OPTIONAL
	WSDATA   csCdEmpresa               AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT EmpresaCondicaoPagamento_EmpresaCondicaoPagamentoDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT EmpresaCondicaoPagamento_EmpresaCondicaoPagamentoDTO
Return

WSMETHOD CLONE WSCLIENT EmpresaCondicaoPagamento_EmpresaCondicaoPagamentoDTO
	Local oClone := EmpresaCondicaoPagamento_EmpresaCondicaoPagamentoDTO():NEW()
	oClone:csCdCondicaoPagamento := ::csCdCondicaoPagamento
	oClone:csCdEmpresa          := ::csCdEmpresa
Return oClone

WSMETHOD SOAPSEND WSCLIENT EmpresaCondicaoPagamento_EmpresaCondicaoPagamentoDTO
	Local cSoap := ""
	cSoap += WSSoapValue("sCdCondicaoPagamento", ::csCdCondicaoPagamento, ::csCdCondicaoPagamento , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdEmpresa", ::csCdEmpresa, ::csCdEmpresa , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
Return cSoap

// WSDL Data Structure ArrayOfWbtLogDTO

WSSTRUCT EmpresaCondicaoPagamento_ArrayOfWbtLogDTO
	WSDATA   oWSWbtLogDTO              AS EmpresaCondicaoPagamento_WbtLogDTO OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT EmpresaCondicaoPagamento_ArrayOfWbtLogDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT EmpresaCondicaoPagamento_ArrayOfWbtLogDTO
	::oWSWbtLogDTO         := {} // Array Of  EmpresaCondicaoPagamento_WBTLOGDTO():New()
Return

WSMETHOD CLONE WSCLIENT EmpresaCondicaoPagamento_ArrayOfWbtLogDTO
	Local oClone := EmpresaCondicaoPagamento_ArrayOfWbtLogDTO():NEW()
	oClone:oWSWbtLogDTO := NIL
	If ::oWSWbtLogDTO <> NIL 
		oClone:oWSWbtLogDTO := {}
		aEval( ::oWSWbtLogDTO , { |x| aadd( oClone:oWSWbtLogDTO , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT EmpresaCondicaoPagamento_ArrayOfWbtLogDTO
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_WBTLOGDTO","WbtLogDTO",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSWbtLogDTO , EmpresaCondicaoPagamento_WbtLogDTO():New() )
			::oWSWbtLogDTO[len(::oWSWbtLogDTO)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure WbtLogDTO

WSSTRUCT EmpresaCondicaoPagamento_WbtLogDTO
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

WSMETHOD NEW WSCLIENT EmpresaCondicaoPagamento_WbtLogDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT EmpresaCondicaoPagamento_WbtLogDTO
Return

WSMETHOD CLONE WSCLIENT EmpresaCondicaoPagamento_WbtLogDTO
	Local oClone := EmpresaCondicaoPagamento_WbtLogDTO():NEW()
	oClone:nnCdLog              := ::nnCdLog
	oClone:nnIdRetorno          := ::nnIdRetorno
	oClone:csCdOrigem           := ::csCdOrigem
	oClone:csDsLog              := ::csDsLog
	oClone:csDsTipoDocumento    := ::csDsTipoDocumento
	oClone:csNrToken            := ::csNrToken
	oClone:ctDtLog              := ::ctDtLog
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT EmpresaCondicaoPagamento_WbtLogDTO
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


