#INCLUDE "protheus.ch"
#INCLUDE "apwebsrv.ch"

/*=================================================================================================================*\
|| ############################################################################################################### ||
||																	                                               ||
|| # WSDL Service Moeda																			 				 # ||
|| # WSDL Location: https://srm-hml.paradigmabs.com.br/cassi-hml/services/Moeda.svc?wsdl						 # ||
||																	                                               ||
|| # Data - 26/09/2019 																							 # ||
||																	                                               ||
|| # Desc: WebService de cadastro de Moeda.																		 # ||
||																	                                               ||
|| # Obs: Alterações neste arquivo podem causar funcionamento incorreto.										 # ||
||																	                                               ||
|| ############################################################################################################### ||
\*=================================================================================================================*/
User Function _RVUNPEE ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSMoeda
------------------------------------------------------------------------------- */

WSCLIENT WSMoeda

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD ProcessarMoeda

	WSDATA   _URL                      AS String
	WSDATA   _CERT                     AS String
	WSDATA   _PRIVKEY                  AS String
	WSDATA   _PASSPHRASE               AS String
	WSDATA   _HEADOUT                  AS Array of String
	WSDATA   _COOKIES                  AS Array of String
	WSDATA   oWSlstMoeda               AS Moeda_ArrayOfMoedaDTO
	WSDATA   oWSProcessarMoedaResult   AS Moeda_RetornoDTO

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSMoeda
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.131227A-20190114 NG] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSMoeda
	::oWSlstMoeda        := Moeda_ARRAYOFMOEDADTO():New()
	::oWSProcessarMoedaResult := Moeda_RETORNODTO():New()
Return

WSMETHOD RESET WSCLIENT WSMoeda
	::oWSlstMoeda        := NIL 
	::oWSProcessarMoedaResult := NIL 
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSMoeda
Local oClone := WSMoeda():New()
	oClone:_URL          := ::_URL 
	oClone:_CERT         := ::_CERT 
	oClone:_PRIVKEY      := ::_PRIVKEY 
	oClone:_PASSPHRASE   := ::_PASSPHRASE 
	oClone:oWSlstMoeda   :=  IIF(::oWSlstMoeda = NIL , NIL ,::oWSlstMoeda:Clone() )
	oClone:oWSProcessarMoedaResult :=  IIF(::oWSProcessarMoedaResult = NIL , NIL ,::oWSProcessarMoedaResult:Clone() )
Return oClone

// WSDL Method ProcessarMoeda of Service WSMoeda

WSMETHOD ProcessarMoeda WSSEND oWSlstMoeda WSRECEIVE oWSProcessarMoedaResult WSCLIENT WSMoeda

Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ProcessarMoeda xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("lstMoeda", ::oWSlstMoeda, oWSlstMoeda , "ArrayOfMoedaDTO", .F. , .F., 0 , "http://tempuri.org/", .F.,.F.) 
cSoap += "</ProcessarMoeda>"

Self:_HEADOUT := { "Authorization: Bearer " + U_NewToken() }
oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tempuri.org/IMoeda/ProcessarMoeda",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	Lower(AllTrim(GetMv("MV_XPARURL"))) + "/services/Moeda.svc")

::Init()
::oWSProcessarMoedaResult:SoapRecv( WSAdvValue( oXmlRet,"_PROCESSARMOEDARESPONSE:_PROCESSARMOEDARESULT","RetornoDTO",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return {.T.,cSoap}


// WSDL Data Structure ArrayOfMoedaDTO

WSSTRUCT Moeda_ArrayOfMoedaDTO
	WSDATA   oWSMoedaDTO               AS Moeda_MoedaDTO OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Moeda_ArrayOfMoedaDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Moeda_ArrayOfMoedaDTO
	::oWSMoedaDTO          := {} // Array Of  Moeda_MOEDADTO():New()
Return

WSMETHOD CLONE WSCLIENT Moeda_ArrayOfMoedaDTO
	Local oClone := Moeda_ArrayOfMoedaDTO():NEW()
	oClone:oWSMoedaDTO := NIL
	If ::oWSMoedaDTO <> NIL 
		oClone:oWSMoedaDTO := {}
		aEval( ::oWSMoedaDTO , { |x| aadd( oClone:oWSMoedaDTO , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT Moeda_ArrayOfMoedaDTO
	Local cSoap := ""
	aEval( ::oWSMoedaDTO , {|x| cSoap := cSoap  +  WSSoapValue("MoedaDTO", x , x , "MoedaDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.)  } ) 
Return cSoap

// WSDL Data Structure RetornoDTO

WSSTRUCT Moeda_RetornoDTO
	WSDATA   oWSlstWbtLogDTO           AS Moeda_ArrayOfWbtLogDTO OPTIONAL
	WSDATA   nnIdRetorno               AS long OPTIONAL
	WSDATA   csNrToken                 AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Moeda_RetornoDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Moeda_RetornoDTO
Return

WSMETHOD CLONE WSCLIENT Moeda_RetornoDTO
	Local oClone := Moeda_RetornoDTO():NEW()
	oClone:oWSlstWbtLogDTO      := IIF(::oWSlstWbtLogDTO = NIL , NIL , ::oWSlstWbtLogDTO:Clone() )
	oClone:nnIdRetorno          := ::nnIdRetorno
	oClone:csNrToken            := ::csNrToken
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Moeda_RetornoDTO
	Local oNode1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_LSTWBTLOGDTO","ArrayOfWbtLogDTO",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode1 != NIL
		::oWSlstWbtLogDTO := Moeda_ArrayOfWbtLogDTO():New()
		::oWSlstWbtLogDTO:SoapRecv(oNode1)
	EndIf
	::nnIdRetorno        :=  WSAdvValue( oResponse,"_NIDRETORNO","long",NIL,NIL,NIL,"N",NIL,NIL) 
	::csNrToken          :=  WSAdvValue( oResponse,"_SNRTOKEN","string",NIL,NIL,NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure MoedaDTO

WSSTRUCT Moeda_MoedaDTO
	WSDATA   oWSlstMoedaIdioma         AS Moeda_ArrayOfMoedaIdiomaDTO OPTIONAL
	WSDATA   csCdMoeda                 AS string OPTIONAL
	WSDATA   csDsMoeda                 AS string OPTIONAL
	WSDATA   csSgMoeda                 AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Moeda_MoedaDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Moeda_MoedaDTO
Return

WSMETHOD CLONE WSCLIENT Moeda_MoedaDTO
	Local oClone := Moeda_MoedaDTO():NEW()
	oClone:oWSlstMoedaIdioma    := IIF(::oWSlstMoedaIdioma = NIL , NIL , ::oWSlstMoedaIdioma:Clone() )
	oClone:csCdMoeda            := ::csCdMoeda
	oClone:csDsMoeda            := ::csDsMoeda
	oClone:csSgMoeda            := ::csSgMoeda
Return oClone

WSMETHOD SOAPSEND WSCLIENT Moeda_MoedaDTO
	Local cSoap := ""
	cSoap += WSSoapValue("lstMoedaIdioma", ::oWSlstMoedaIdioma, ::oWSlstMoedaIdioma , "ArrayOfMoedaIdiomaDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdMoeda", ::csCdMoeda, ::csCdMoeda , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sDsMoeda", ::csDsMoeda, ::csDsMoeda , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sSgMoeda", ::csSgMoeda, ::csSgMoeda , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
Return cSoap

// WSDL Data Structure ArrayOfWbtLogDTO

WSSTRUCT Moeda_ArrayOfWbtLogDTO
	WSDATA   oWSWbtLogDTO              AS Moeda_WbtLogDTO OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Moeda_ArrayOfWbtLogDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Moeda_ArrayOfWbtLogDTO
	::oWSWbtLogDTO         := {} // Array Of  Moeda_WBTLOGDTO():New()
Return

WSMETHOD CLONE WSCLIENT Moeda_ArrayOfWbtLogDTO
	Local oClone := Moeda_ArrayOfWbtLogDTO():NEW()
	oClone:oWSWbtLogDTO := NIL
	If ::oWSWbtLogDTO <> NIL 
		oClone:oWSWbtLogDTO := {}
		aEval( ::oWSWbtLogDTO , { |x| aadd( oClone:oWSWbtLogDTO , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Moeda_ArrayOfWbtLogDTO
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_WBTLOGDTO","WbtLogDTO",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSWbtLogDTO , Moeda_WbtLogDTO():New() )
			::oWSWbtLogDTO[len(::oWSWbtLogDTO)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure ArrayOfMoedaIdiomaDTO

WSSTRUCT Moeda_ArrayOfMoedaIdiomaDTO
	WSDATA   oWSMoedaIdiomaDTO         AS Moeda_MoedaIdiomaDTO OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Moeda_ArrayOfMoedaIdiomaDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Moeda_ArrayOfMoedaIdiomaDTO
	::oWSMoedaIdiomaDTO    := {} // Array Of  Moeda_MOEDAIDIOMADTO():New()
Return

WSMETHOD CLONE WSCLIENT Moeda_ArrayOfMoedaIdiomaDTO
	Local oClone := Moeda_ArrayOfMoedaIdiomaDTO():NEW()
	oClone:oWSMoedaIdiomaDTO := NIL
	If ::oWSMoedaIdiomaDTO <> NIL 
		oClone:oWSMoedaIdiomaDTO := {}
		aEval( ::oWSMoedaIdiomaDTO , { |x| aadd( oClone:oWSMoedaIdiomaDTO , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT Moeda_ArrayOfMoedaIdiomaDTO
	Local cSoap := ""
	aEval( ::oWSMoedaIdiomaDTO , {|x| cSoap := cSoap  +  WSSoapValue("MoedaIdiomaDTO", x , x , "MoedaIdiomaDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.)  } ) 
Return cSoap

// WSDL Data Structure WbtLogDTO

WSSTRUCT Moeda_WbtLogDTO
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

WSMETHOD NEW WSCLIENT Moeda_WbtLogDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Moeda_WbtLogDTO
Return

WSMETHOD CLONE WSCLIENT Moeda_WbtLogDTO
	Local oClone := Moeda_WbtLogDTO():NEW()
	oClone:nnCdLog              := ::nnCdLog
	oClone:nnIdRetorno          := ::nnIdRetorno
	oClone:csCdOrigem           := ::csCdOrigem
	oClone:csDsLog              := ::csDsLog
	oClone:csDsTipoDocumento    := ::csDsTipoDocumento
	oClone:csNrToken            := ::csNrToken
	oClone:ctDtLog              := ::ctDtLog
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Moeda_WbtLogDTO
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

// WSDL Data Structure MoedaIdiomaDTO

WSSTRUCT Moeda_MoedaIdiomaDTO
	WSDATA   csDsMoeda                 AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Moeda_MoedaIdiomaDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Moeda_MoedaIdiomaDTO
Return

WSMETHOD CLONE WSCLIENT Moeda_MoedaIdiomaDTO
	Local oClone := Moeda_MoedaIdiomaDTO():NEW()
	oClone:csDsMoeda            := ::csDsMoeda
Return oClone

WSMETHOD SOAPSEND WSCLIENT Moeda_MoedaIdiomaDTO
	Local cSoap := ""
	cSoap += WSSoapValue("sDsMoeda", ::csDsMoeda, ::csDsMoeda , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
Return cSoap


