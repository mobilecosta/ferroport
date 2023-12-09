#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"

/*=================================================================================================================*\
|| ############################################################################################################### ||
||																	                                               ||
|| # WSDL Service WSContaContabil																				 # ||
|| # WSDL Location: https://srm-hml.paradigmabs.com.br/cassi-hml/services/ContaContabil.svc?wsdl				 # ||
||																	                                               ||
|| # Data - 26/09/2019 																							 # ||
||																	                                               ||
|| # Desc: WebService de cadastro de Condição de Pagamento.														 # ||
||																	                                               ||
|| # Obs: Alterações neste arquivo podem causar funcionamento incorreto.										 # ||
||																	                                               ||
|| ############################################################################################################### ||
\*=================================================================================================================*/
User Function _ZJXJLLA ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSContaContabil
------------------------------------------------------------------------------- */

WSCLIENT WSContaContabil

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD ProcessarContaContabil

	WSDATA   _URL                      AS String
	WSDATA   _CERT                     AS String
	WSDATA   _PRIVKEY                  AS String
	WSDATA   _PASSPHRASE               AS String
	WSDATA   _HEADOUT                  AS Array of String
	WSDATA   _COOKIES                  AS Array of String
	WSDATA   oWSlstContaContabil       AS ContaContabil_ArrayOfContaContabilDTO
	WSDATA   oWSProcessarContaContabilResult AS ContaContabil_RetornoDTO

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSContaContabil
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.131227A-20190114 NG] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSContaContabil
	::oWSlstContaContabil := ContaContabil_ARRAYOFCONTACONTABILDTO():New()
	::oWSProcessarContaContabilResult := ContaContabil_RETORNODTO():New()
Return

WSMETHOD RESET WSCLIENT WSContaContabil
	::oWSlstContaContabil := NIL 
	::oWSProcessarContaContabilResult := NIL 
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSContaContabil
Local oClone := WSContaContabil():New()
	oClone:_URL          := ::_URL 
	oClone:_CERT         := ::_CERT 
	oClone:_PRIVKEY      := ::_PRIVKEY 
	oClone:_PASSPHRASE   := ::_PASSPHRASE 
	oClone:oWSlstContaContabil :=  IIF(::oWSlstContaContabil = NIL , NIL ,::oWSlstContaContabil:Clone() )
	oClone:oWSProcessarContaContabilResult :=  IIF(::oWSProcessarContaContabilResult = NIL , NIL ,::oWSProcessarContaContabilResult:Clone() )
Return oClone

// WSDL Method ProcessarContaContabil of Service WSContaContabil

WSMETHOD ProcessarContaContabil WSSEND oWSlstContaContabil WSRECEIVE oWSProcessarContaContabilResult WSCLIENT WSContaContabil
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ProcessarContaContabil xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("lstContaContabil", ::oWSlstContaContabil, oWSlstContaContabil , "ArrayOfContaContabilDTO", .F. , .F., 0 , "http://tempuri.org/", .F.,.F.) 
cSoap += "</ProcessarContaContabil>"

Self:_HEADOUT := { "Authorization: Bearer " + U_NewToken() }
oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tempuri.org/IContaContabil/ProcessarContaContabil",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	Lower(AllTrim(GetMv("MV_XPARURL"))) + "/services/ContaContabil.svc")

::Init()
::oWSProcessarContaContabilResult:SoapRecv( WSAdvValue( oXmlRet,"_PROCESSARCONTACONTABILRESPONSE:_PROCESSARCONTACONTABILRESULT","RetornoDTO",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return {.T.,cSoap}


// WSDL Data Structure ArrayOfContaContabilDTO

WSSTRUCT ContaContabil_ArrayOfContaContabilDTO
	WSDATA   oWSContaContabilDTO       AS ContaContabil_ContaContabilDTO OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT ContaContabil_ArrayOfContaContabilDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT ContaContabil_ArrayOfContaContabilDTO
	::oWSContaContabilDTO  := {} // Array Of  ContaContabil_CONTACONTABILDTO():New()
Return

WSMETHOD CLONE WSCLIENT ContaContabil_ArrayOfContaContabilDTO
	Local oClone := ContaContabil_ArrayOfContaContabilDTO():NEW()
	oClone:oWSContaContabilDTO := NIL
	If ::oWSContaContabilDTO <> NIL 
		oClone:oWSContaContabilDTO := {}
		aEval( ::oWSContaContabilDTO , { |x| aadd( oClone:oWSContaContabilDTO , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT ContaContabil_ArrayOfContaContabilDTO
	Local cSoap := ""
	aEval( ::oWSContaContabilDTO , {|x| cSoap := cSoap  +  WSSoapValue("ContaContabilDTO", x , x , "ContaContabilDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.)  } ) 
Return cSoap

// WSDL Data Structure RetornoDTO

WSSTRUCT ContaContabil_RetornoDTO
	WSDATA   oWSlstWbtLogDTO           AS ContaContabil_ArrayOfWbtLogDTO OPTIONAL
	WSDATA   nnIdRetorno               AS long OPTIONAL
	WSDATA   csNrToken                 AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT ContaContabil_RetornoDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT ContaContabil_RetornoDTO
Return

WSMETHOD CLONE WSCLIENT ContaContabil_RetornoDTO
	Local oClone := ContaContabil_RetornoDTO():NEW()
	oClone:oWSlstWbtLogDTO      := IIF(::oWSlstWbtLogDTO = NIL , NIL , ::oWSlstWbtLogDTO:Clone() )
	oClone:nnIdRetorno          := ::nnIdRetorno
	oClone:csNrToken            := ::csNrToken
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT ContaContabil_RetornoDTO
	Local oNode1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_LSTWBTLOGDTO","ArrayOfWbtLogDTO",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode1 != NIL
		::oWSlstWbtLogDTO := ContaContabil_ArrayOfWbtLogDTO():New()
		::oWSlstWbtLogDTO:SoapRecv(oNode1)
	EndIf
	::nnIdRetorno        :=  WSAdvValue( oResponse,"_NIDRETORNO","long",NIL,NIL,NIL,"N",NIL,NIL) 
	::csNrToken          :=  WSAdvValue( oResponse,"_SNRTOKEN","string",NIL,NIL,NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure ContaContabilDTO

WSSTRUCT ContaContabil_ContaContabilDTO
	WSDATA   nbFlAtivo                 AS int OPTIONAL
	WSDATA   csCdContaContabil         AS string OPTIONAL
	WSDATA   csCdContaContabilPai      AS string OPTIONAL
	WSDATA   csCdEmpresa               AS string OPTIONAL
	WSDATA   csDsContaContabil         AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT ContaContabil_ContaContabilDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT ContaContabil_ContaContabilDTO
Return

WSMETHOD CLONE WSCLIENT ContaContabil_ContaContabilDTO
	Local oClone := ContaContabil_ContaContabilDTO():NEW()
	oClone:nbFlAtivo            := ::nbFlAtivo
	oClone:csCdContaContabil    := ::csCdContaContabil
	oClone:csCdContaContabilPai := ::csCdContaContabilPai
	oClone:csCdEmpresa          := ::csCdEmpresa
	oClone:csDsContaContabil    := ::csDsContaContabil
Return oClone

WSMETHOD SOAPSEND WSCLIENT ContaContabil_ContaContabilDTO
	Local cSoap := ""
	cSoap += WSSoapValue("bFlAtivo", ::nbFlAtivo, ::nbFlAtivo , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdContaContabil", ::csCdContaContabil, ::csCdContaContabil , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdContaContabilPai", ::csCdContaContabilPai, ::csCdContaContabilPai , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdEmpresa", ::csCdEmpresa, ::csCdEmpresa , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sDsContaContabil", ::csDsContaContabil, ::csDsContaContabil , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
Return cSoap

// WSDL Data Structure ArrayOfWbtLogDTO

WSSTRUCT ContaContabil_ArrayOfWbtLogDTO
	WSDATA   oWSWbtLogDTO              AS ContaContabil_WbtLogDTO OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT ContaContabil_ArrayOfWbtLogDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT ContaContabil_ArrayOfWbtLogDTO
	::oWSWbtLogDTO         := {} // Array Of  ContaContabil_WBTLOGDTO():New()
Return

WSMETHOD CLONE WSCLIENT ContaContabil_ArrayOfWbtLogDTO
	Local oClone := ContaContabil_ArrayOfWbtLogDTO():NEW()
	oClone:oWSWbtLogDTO := NIL
	If ::oWSWbtLogDTO <> NIL 
		oClone:oWSWbtLogDTO := {}
		aEval( ::oWSWbtLogDTO , { |x| aadd( oClone:oWSWbtLogDTO , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT ContaContabil_ArrayOfWbtLogDTO
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_WBTLOGDTO","WbtLogDTO",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSWbtLogDTO , ContaContabil_WbtLogDTO():New() )
			::oWSWbtLogDTO[len(::oWSWbtLogDTO)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure WbtLogDTO

WSSTRUCT ContaContabil_WbtLogDTO
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

WSMETHOD NEW WSCLIENT ContaContabil_WbtLogDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT ContaContabil_WbtLogDTO
Return

WSMETHOD CLONE WSCLIENT ContaContabil_WbtLogDTO
	Local oClone := ContaContabil_WbtLogDTO():NEW()
	oClone:nnCdLog              := ::nnCdLog
	oClone:nnIdRetorno          := ::nnIdRetorno
	oClone:csCdOrigem           := ::csCdOrigem
	oClone:csDsLog              := ::csDsLog
	oClone:csDsTipoDocumento    := ::csDsTipoDocumento
	oClone:csNrToken            := ::csNrToken
	oClone:ctDtLog              := ::ctDtLog
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT ContaContabil_WbtLogDTO
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


