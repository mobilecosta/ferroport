#INCLUDE "protheus.ch"
#INCLUDE "apwebsrv.ch"

/*=================================================================================================================*\
|| ############################################################################################################### ||
||																	                                               ||
|| # WSDL Service Ordem de Compra																				 # ||
|| # WSDL Location: https://srm-hml.paradigmabs.com.br/cassi-hml/services/OrdemCompra.svc?wsdl					 # ||
||																	                                               ||
|| # Data - 26/09/2019 																							 # ||
||																	                                               ||
|| # Desc: WebService de cadastro de Ordem de Compra.															 # ||
||																	                                               ||
|| # Obs: Alterações neste arquivo podem causar funcionamento incorreto.										 # ||
||																	                                               ||
|| ############################################################################################################### ||
\*=================================================================================================================*/
User Function _BVXUOMK ; Return  // "dummy" function - Internal Use 


/* ====================== SERVICE WARNING MESSAGES ======================
Definition for OrdemCompraItemDTO as complexType NOT FOUND. This Object HAS NO RETURN.
====================================================================== */

/* -------------------------------------------------------------------------------
WSDL Service WSOrdemCompra
------------------------------------------------------------------------------- */

WSCLIENT WSOrdemCompra

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD RetornarOrdemCompra
	WSMETHOD RetornarOrdemCompraConsumo
	WSMETHOD RetornarOrdemCompraTipo
	WSMETHOD ProcessarOrdemCompra

	WSDATA   _URL                      AS String
	WSDATA   _CERT                     AS String
	WSDATA   _PRIVKEY                  AS String
	WSDATA   _PASSPHRASE               AS String
	WSDATA   _HEADOUT                  AS Array of String
	WSDATA   _COOKIES                  AS Array of String
	WSDATA   nnQtRegistros             AS int
	WSDATA   nnCdTipoOrdemCompra       AS int
	WSDATA   nnCdOrdemCompra           AS int
	WSDATA   csCdOrdemCompraEmpresa    AS string
	WSDATA   oWSRetornarOrdemCompraResult AS OrdemCompra_RetornoListaOrdemCompraDTO
	WSDATA   oWSRetornarOrdemCompraConsumoResult AS OrdemCompra_RetornoListaOrdemCompraConsumoDTO
	WSDATA   oWSRetornarOrdemCompraTipoResult AS OrdemCompra_RetornoListaOrdemCompraTipoDTO
	WSDATA   oWSlstOrdemCompra         AS OrdemCompra_ArrayOfOrdemCompraDTO
	WSDATA   oWSProcessarOrdemCompraResult AS OrdemCompra_RetornoDTO

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSOrdemCompra
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.131227A-20190114 NG] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSOrdemCompra
	::oWSRetornarOrdemCompraResult := OrdemCompra_RETORNOLISTAORDEMCOMPRADTO():New()
	::oWSRetornarOrdemCompraConsumoResult := OrdemCompra_RETORNOLISTAORDEMCOMPRACONSUMODTO():New()
	::oWSRetornarOrdemCompraTipoResult := OrdemCompra_RETORNOLISTAORDEMCOMPRATIPODTO():New()
	::oWSlstOrdemCompra  := OrdemCompra_ARRAYOFORDEMCOMPRADTO():New()
	::oWSProcessarOrdemCompraResult := OrdemCompra_RETORNODTO():New()
Return

WSMETHOD RESET WSCLIENT WSOrdemCompra
	::nnQtRegistros      := NIL 
	::nnCdTipoOrdemCompra := NIL 
	::nnCdOrdemCompra    := NIL 
	::csCdOrdemCompraEmpresa := NIL 
	::oWSRetornarOrdemCompraResult := NIL 
	::oWSRetornarOrdemCompraConsumoResult := NIL 
	::oWSRetornarOrdemCompraTipoResult := NIL 
	::oWSlstOrdemCompra  := NIL 
	::oWSProcessarOrdemCompraResult := NIL 
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSOrdemCompra
Local oClone := WSOrdemCompra():New()
	oClone:_URL          := ::_URL 
	oClone:_CERT         := ::_CERT 
	oClone:_PRIVKEY      := ::_PRIVKEY 
	oClone:_PASSPHRASE   := ::_PASSPHRASE 
	oClone:nnQtRegistros := ::nnQtRegistros
	oClone:nnCdTipoOrdemCompra := ::nnCdTipoOrdemCompra
	oClone:nnCdOrdemCompra := ::nnCdOrdemCompra
	oClone:csCdOrdemCompraEmpresa := ::csCdOrdemCompraEmpresa
	oClone:oWSRetornarOrdemCompraResult :=  IIF(::oWSRetornarOrdemCompraResult = NIL , NIL ,::oWSRetornarOrdemCompraResult:Clone() )
	oClone:oWSRetornarOrdemCompraConsumoResult :=  IIF(::oWSRetornarOrdemCompraConsumoResult = NIL , NIL ,::oWSRetornarOrdemCompraConsumoResult:Clone() )
	oClone:oWSRetornarOrdemCompraTipoResult :=  IIF(::oWSRetornarOrdemCompraTipoResult = NIL , NIL ,::oWSRetornarOrdemCompraTipoResult:Clone() )
	oClone:oWSlstOrdemCompra :=  IIF(::oWSlstOrdemCompra = NIL , NIL ,::oWSlstOrdemCompra:Clone() )
	oClone:oWSProcessarOrdemCompraResult :=  IIF(::oWSProcessarOrdemCompraResult = NIL , NIL ,::oWSProcessarOrdemCompraResult:Clone() )
Return oClone

// WSDL Method RetornarOrdemCompra of Service WSOrdemCompra

WSMETHOD RetornarOrdemCompra WSSEND nnQtRegistros,nnCdTipoOrdemCompra,nnCdOrdemCompra,csCdOrdemCompraEmpresa WSRECEIVE oWSRetornarOrdemCompraResult WSCLIENT WSOrdemCompra
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<RetornarOrdemCompra xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("nQtRegistros", ::nnQtRegistros, nnQtRegistros , "int", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("nCdTipoOrdemCompra", ::nnCdTipoOrdemCompra, nnCdTipoOrdemCompra , "int", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("nCdOrdemCompra", ::nnCdOrdemCompra, nnCdOrdemCompra , "int", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("sCdOrdemCompraEmpresa", ::csCdOrdemCompraEmpresa, csCdOrdemCompraEmpresa , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</RetornarOrdemCompra>"

Self:_HEADOUT := { "Authorization: Bearer " + U_NewToken() }
oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tempuri.org/IOrdemCompra/RetornarOrdemCompra",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	Lower(AllTrim(GetMv("MV_XPARURL"))) + "/services/OrdemCompra.svc")

::Init()
::oWSRetornarOrdemCompraResult:SoapRecv( WSAdvValue( oXmlRet,"_RETORNARORDEMCOMPRARESPONSE:_RETORNARORDEMCOMPRARESULT","RetornoListaOrdemCompraDTO",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method RetornarOrdemCompraConsumo of Service WSOrdemCompra

WSMETHOD RetornarOrdemCompraConsumo WSSEND nnQtRegistros,nnCdTipoOrdemCompra,nnCdOrdemCompra WSRECEIVE oWSRetornarOrdemCompraConsumoResult WSCLIENT WSOrdemCompra
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<RetornarOrdemCompraConsumo xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("nQtRegistros", ::nnQtRegistros, nnQtRegistros , "int", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("nCdTipoOrdemCompra", ::nnCdTipoOrdemCompra, nnCdTipoOrdemCompra , "int", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("nCdOrdemCompra", ::nnCdOrdemCompra, nnCdOrdemCompra , "int", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</RetornarOrdemCompraConsumo>"

Self:_HEADOUT := { "Authorization: Bearer " + U_NewToken() }
oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tempuri.org/IOrdemCompra/RetornarOrdemCompraConsumo",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	Lower(AllTrim(GetMv("MV_XPARURL"))) + "/services/OrdemCompra.svc")

::Init()
::oWSRetornarOrdemCompraConsumoResult:SoapRecv( WSAdvValue( oXmlRet,"_RETORNARORDEMCOMPRACONSUMORESPONSE:_RETORNARORDEMCOMPRACONSUMORESULT","RetornoListaOrdemCompraConsumoDTO",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method RetornarOrdemCompraTipo of Service WSOrdemCompra

WSMETHOD RetornarOrdemCompraTipo WSSEND NULLPARAM WSRECEIVE oWSRetornarOrdemCompraTipoResult WSCLIENT WSOrdemCompra
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<RetornarOrdemCompraTipo xmlns="http://tempuri.org/">'
cSoap += "</RetornarOrdemCompraTipo>"

Self:_HEADOUT := { "Authorization: Bearer " + U_NewToken() }
oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tempuri.org/IOrdemCompra/RetornarOrdemCompraTipo",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	Lower(AllTrim(GetMv("MV_XPARURL"))) + "/services/OrdemCompra.svc")

::Init()
::oWSRetornarOrdemCompraTipoResult:SoapRecv( WSAdvValue( oXmlRet,"_RETORNARORDEMCOMPRATIPORESPONSE:_RETORNARORDEMCOMPRATIPORESULT","RetornoListaOrdemCompraTipoDTO",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method ProcessarOrdemCompra of Service WSOrdemCompra

WSMETHOD ProcessarOrdemCompra WSSEND oWSlstOrdemCompra WSRECEIVE oWSProcessarOrdemCompraResult WSCLIENT WSOrdemCompra
	Local cSoap := "" , oXmlRet, nHandle
	
	BEGIN WSMETHOD
	
	cSoap += '<ProcessarOrdemCompra xmlns="http://tempuri.org/">'
	cSoap += WSSoapValue("lstOrdemCompra", ::oWSlstOrdemCompra, oWSlstOrdemCompra , "ArrayOfOrdemCompraDTO", .F. , .F., 0 , "http://tempuri.org/", .F.,.F.) 
	cSoap += "</ProcessarOrdemCompra>"
	
	Conout(cSoap)
	/*nHandle := FCREATE( 'c:/temp/ProcessarOrdemCompra.xml' )
	If nHandle >= 0
		FWrite(nHandle, cSoap) 	// Insere texto no arquivo	 
		FClose(nHandle) // Fecha arquivo
	EndIf*/
	
	Self:_HEADOUT := { "Authorization: Bearer " + U_NewToken() }
	oXmlRet := SvcSoapCall(Self,cSoap,; 
		"http://tempuri.org/IOrdemCompra/ProcessarOrdemCompra",; 
		"DOCUMENT","http://tempuri.org/",,,; 
		Lower(AllTrim(GetMv("MV_XPARURL"))) + "/services/OrdemCompra.svc")
	
	::Init()
	::oWSProcessarOrdemCompraResult:SoapRecv( WSAdvValue( oXmlRet,"_PROCESSARORDEMCOMPRARESPONSE:_PROCESSARORDEMCOMPRARESULT","RetornoDTO",NIL,NIL,NIL,NIL,NIL,NIL) )
	
	END WSMETHOD
	
	oXmlRet := NIL
Return .T.


// WSDL Data Structure RetornoListaOrdemCompraDTO

WSSTRUCT OrdemCompra_RetornoListaOrdemCompraDTO
	WSDATA   oWSlstObjetoRetorno       AS OrdemCompra_ArrayOfOrdemCompraDTO OPTIONAL
	WSDATA   nnQtRegistrosRetorno      AS int OPTIONAL
	WSDATA   nnQtRegistrosTotal        AS int OPTIONAL
	WSDATA   oWSoRetornoDTO            AS OrdemCompra_RetornoDTO OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT OrdemCompra_RetornoListaOrdemCompraDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT OrdemCompra_RetornoListaOrdemCompraDTO
Return

WSMETHOD CLONE WSCLIENT OrdemCompra_RetornoListaOrdemCompraDTO
	Local oClone := OrdemCompra_RetornoListaOrdemCompraDTO():NEW()
	oClone:oWSlstObjetoRetorno  := IIF(::oWSlstObjetoRetorno = NIL , NIL , ::oWSlstObjetoRetorno:Clone() )
	oClone:nnQtRegistrosRetorno := ::nnQtRegistrosRetorno
	oClone:nnQtRegistrosTotal   := ::nnQtRegistrosTotal
	oClone:oWSoRetornoDTO       := IIF(::oWSoRetornoDTO = NIL , NIL , ::oWSoRetornoDTO:Clone() )
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT OrdemCompra_RetornoListaOrdemCompraDTO
	Local oNode1
	Local oNode4
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_LSTOBJETORETORNO","ArrayOfOrdemCompraDTO",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode1 != NIL
		::oWSlstObjetoRetorno := OrdemCompra_ArrayOfOrdemCompraDTO():New()
		::oWSlstObjetoRetorno:SoapRecv(oNode1)
	EndIf
	::nnQtRegistrosRetorno :=  WSAdvValue( oResponse,"_NQTREGISTROSRETORNO","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::nnQtRegistrosTotal :=  WSAdvValue( oResponse,"_NQTREGISTROSTOTAL","int",NIL,NIL,NIL,"N",NIL,NIL) 
	oNode4 :=  WSAdvValue( oResponse,"_ORETORNODTO","RetornoDTO",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode4 != NIL
		::oWSoRetornoDTO := OrdemCompra_RetornoDTO():New()
		::oWSoRetornoDTO:SoapRecv(oNode4)
	EndIf
Return

// WSDL Data Structure RetornoListaOrdemCompraConsumoDTO

WSSTRUCT OrdemCompra_RetornoListaOrdemCompraConsumoDTO
	WSDATA   oWSlstObjetoRetorno       AS OrdemCompra_ArrayOfOrdemCompraConsumoDTO OPTIONAL
	WSDATA   nnQtRegistrosRetorno      AS int OPTIONAL
	WSDATA   nnQtRegistrosTotal        AS int OPTIONAL
	WSDATA   oWSoRetornoDTO            AS OrdemCompra_RetornoDTO OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT OrdemCompra_RetornoListaOrdemCompraConsumoDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT OrdemCompra_RetornoListaOrdemCompraConsumoDTO
Return

WSMETHOD CLONE WSCLIENT OrdemCompra_RetornoListaOrdemCompraConsumoDTO
	Local oClone := OrdemCompra_RetornoListaOrdemCompraConsumoDTO():NEW()
	oClone:oWSlstObjetoRetorno  := IIF(::oWSlstObjetoRetorno = NIL , NIL , ::oWSlstObjetoRetorno:Clone() )
	oClone:nnQtRegistrosRetorno := ::nnQtRegistrosRetorno
	oClone:nnQtRegistrosTotal   := ::nnQtRegistrosTotal
	oClone:oWSoRetornoDTO       := IIF(::oWSoRetornoDTO = NIL , NIL , ::oWSoRetornoDTO:Clone() )
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT OrdemCompra_RetornoListaOrdemCompraConsumoDTO
	Local oNode1
	Local oNode4
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_LSTOBJETORETORNO","ArrayOfOrdemCompraConsumoDTO",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode1 != NIL
		::oWSlstObjetoRetorno := OrdemCompra_ArrayOfOrdemCompraConsumoDTO():New()
		::oWSlstObjetoRetorno:SoapRecv(oNode1)
	EndIf
	::nnQtRegistrosRetorno :=  WSAdvValue( oResponse,"_NQTREGISTROSRETORNO","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::nnQtRegistrosTotal :=  WSAdvValue( oResponse,"_NQTREGISTROSTOTAL","int",NIL,NIL,NIL,"N",NIL,NIL) 
	oNode4 :=  WSAdvValue( oResponse,"_ORETORNODTO","RetornoDTO",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode4 != NIL
		::oWSoRetornoDTO := OrdemCompra_RetornoDTO():New()
		::oWSoRetornoDTO:SoapRecv(oNode4)
	EndIf
Return

// WSDL Data Structure RetornoListaOrdemCompraTipoDTO

WSSTRUCT OrdemCompra_RetornoListaOrdemCompraTipoDTO
	WSDATA   oWSlstObjetoRetorno       AS OrdemCompra_ArrayOfOrdemCompraTipoDTO OPTIONAL
	WSDATA   nnQtRegistrosRetorno      AS int OPTIONAL
	WSDATA   nnQtRegistrosTotal        AS int OPTIONAL
	WSDATA   oWSoRetornoDTO            AS OrdemCompra_RetornoDTO OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT OrdemCompra_RetornoListaOrdemCompraTipoDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT OrdemCompra_RetornoListaOrdemCompraTipoDTO
Return

WSMETHOD CLONE WSCLIENT OrdemCompra_RetornoListaOrdemCompraTipoDTO
	Local oClone := OrdemCompra_RetornoListaOrdemCompraTipoDTO():NEW()
	oClone:oWSlstObjetoRetorno  := IIF(::oWSlstObjetoRetorno = NIL , NIL , ::oWSlstObjetoRetorno:Clone() )
	oClone:nnQtRegistrosRetorno := ::nnQtRegistrosRetorno
	oClone:nnQtRegistrosTotal   := ::nnQtRegistrosTotal
	oClone:oWSoRetornoDTO       := IIF(::oWSoRetornoDTO = NIL , NIL , ::oWSoRetornoDTO:Clone() )
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT OrdemCompra_RetornoListaOrdemCompraTipoDTO
	Local oNode1
	Local oNode4
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_LSTOBJETORETORNO","ArrayOfOrdemCompraTipoDTO",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode1 != NIL
		::oWSlstObjetoRetorno := OrdemCompra_ArrayOfOrdemCompraTipoDTO():New()
		::oWSlstObjetoRetorno:SoapRecv(oNode1)
	EndIf
	::nnQtRegistrosRetorno :=  WSAdvValue( oResponse,"_NQTREGISTROSRETORNO","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::nnQtRegistrosTotal :=  WSAdvValue( oResponse,"_NQTREGISTROSTOTAL","int",NIL,NIL,NIL,"N",NIL,NIL) 
	oNode4 :=  WSAdvValue( oResponse,"_ORETORNODTO","RetornoDTO",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode4 != NIL
		::oWSoRetornoDTO := OrdemCompra_RetornoDTO():New()
		::oWSoRetornoDTO:SoapRecv(oNode4)
	EndIf
Return

// WSDL Data Structure ArrayOfOrdemCompraDTO

WSSTRUCT OrdemCompra_ArrayOfOrdemCompraDTO
	WSDATA   oWSOrdemCompraDTO         AS OrdemCompra_OrdemCompraDTO OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT OrdemCompra_ArrayOfOrdemCompraDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT OrdemCompra_ArrayOfOrdemCompraDTO
	::oWSOrdemCompraDTO    := {} // Array Of  OrdemCompra_ORDEMCOMPRADTO():New()
Return

WSMETHOD CLONE WSCLIENT OrdemCompra_ArrayOfOrdemCompraDTO
	Local oClone := OrdemCompra_ArrayOfOrdemCompraDTO():NEW()
	oClone:oWSOrdemCompraDTO := NIL
	If ::oWSOrdemCompraDTO <> NIL 
		oClone:oWSOrdemCompraDTO := {}
		aEval( ::oWSOrdemCompraDTO , { |x| aadd( oClone:oWSOrdemCompraDTO , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT OrdemCompra_ArrayOfOrdemCompraDTO
	Local cSoap := ""
	aEval( ::oWSOrdemCompraDTO , {|x| cSoap := cSoap  +  WSSoapValue("OrdemCompraDTO", x , x , "OrdemCompraDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.)  } ) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT OrdemCompra_ArrayOfOrdemCompraDTO
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_ORDEMCOMPRADTO","OrdemCompraDTO",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSOrdemCompraDTO , OrdemCompra_OrdemCompraDTO():New() )
			::oWSOrdemCompraDTO[len(::oWSOrdemCompraDTO)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure RetornoDTO

WSSTRUCT OrdemCompra_RetornoDTO
	WSDATA   oWSlstWbtLogDTO           AS OrdemCompra_ArrayOfWbtLogDTO OPTIONAL
	WSDATA   nnIdRetorno               AS long OPTIONAL
	WSDATA   csNrToken                 AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT OrdemCompra_RetornoDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT OrdemCompra_RetornoDTO
Return

WSMETHOD CLONE WSCLIENT OrdemCompra_RetornoDTO
	Local oClone := OrdemCompra_RetornoDTO():NEW()
	oClone:oWSlstWbtLogDTO      := IIF(::oWSlstWbtLogDTO = NIL , NIL , ::oWSlstWbtLogDTO:Clone() )
	oClone:nnIdRetorno          := ::nnIdRetorno
	oClone:csNrToken            := ::csNrToken
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT OrdemCompra_RetornoDTO
	Local oNode1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_LSTWBTLOGDTO","ArrayOfWbtLogDTO",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode1 != NIL
		::oWSlstWbtLogDTO := OrdemCompra_ArrayOfWbtLogDTO():New()
		::oWSlstWbtLogDTO:SoapRecv(oNode1)
	EndIf
	::nnIdRetorno        :=  WSAdvValue( oResponse,"_NIDRETORNO","long",NIL,NIL,NIL,"N",NIL,NIL) 
	::csNrToken          :=  WSAdvValue( oResponse,"_SNRTOKEN","string",NIL,NIL,NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure ArrayOfOrdemCompraConsumoDTO

WSSTRUCT OrdemCompra_ArrayOfOrdemCompraConsumoDTO
	WSDATA   oWSOrdemCompraConsumoDTO  AS OrdemCompra_OrdemCompraConsumoDTO OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT OrdemCompra_ArrayOfOrdemCompraConsumoDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT OrdemCompra_ArrayOfOrdemCompraConsumoDTO
	::oWSOrdemCompraConsumoDTO := {} // Array Of  OrdemCompra_ORDEMCOMPRACONSUMODTO():New()
Return

WSMETHOD CLONE WSCLIENT OrdemCompra_ArrayOfOrdemCompraConsumoDTO
	Local oClone := OrdemCompra_ArrayOfOrdemCompraConsumoDTO():NEW()
	oClone:oWSOrdemCompraConsumoDTO := NIL
	If ::oWSOrdemCompraConsumoDTO <> NIL 
		oClone:oWSOrdemCompraConsumoDTO := {}
		aEval( ::oWSOrdemCompraConsumoDTO , { |x| aadd( oClone:oWSOrdemCompraConsumoDTO , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT OrdemCompra_ArrayOfOrdemCompraConsumoDTO
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_ORDEMCOMPRACONSUMODTO","OrdemCompraConsumoDTO",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSOrdemCompraConsumoDTO , OrdemCompra_OrdemCompraConsumoDTO():New() )
			::oWSOrdemCompraConsumoDTO[len(::oWSOrdemCompraConsumoDTO)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure ArrayOfOrdemCompraTipoDTO

WSSTRUCT OrdemCompra_ArrayOfOrdemCompraTipoDTO
	WSDATA   oWSOrdemCompraTipoDTO     AS OrdemCompra_OrdemCompraTipoDTO OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT OrdemCompra_ArrayOfOrdemCompraTipoDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT OrdemCompra_ArrayOfOrdemCompraTipoDTO
	::oWSOrdemCompraTipoDTO := {} // Array Of  OrdemCompra_ORDEMCOMPRATIPODTO():New()
Return

WSMETHOD CLONE WSCLIENT OrdemCompra_ArrayOfOrdemCompraTipoDTO
	Local oClone := OrdemCompra_ArrayOfOrdemCompraTipoDTO():NEW()
	oClone:oWSOrdemCompraTipoDTO := NIL
	If ::oWSOrdemCompraTipoDTO <> NIL 
		oClone:oWSOrdemCompraTipoDTO := {}
		aEval( ::oWSOrdemCompraTipoDTO , { |x| aadd( oClone:oWSOrdemCompraTipoDTO , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT OrdemCompra_ArrayOfOrdemCompraTipoDTO
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_ORDEMCOMPRATIPODTO","OrdemCompraTipoDTO",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSOrdemCompraTipoDTO , OrdemCompra_OrdemCompraTipoDTO():New() )
			::oWSOrdemCompraTipoDTO[len(::oWSOrdemCompraTipoDTO)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure OrdemCompraDTO

WSSTRUCT OrdemCompra_OrdemCompraDTO
	WSDATA   ndVlTotalEstimado         AS decimal OPTIONAL
	WSDATA   oWSlstOrdemCompraItem     AS OrdemCompra_ArrayOfOrdemCompraItemDTO OPTIONAL
	WSDATA   nnCdAplicacao             AS long OPTIONAL
	WSDATA   nnCdClassificacao         AS long OPTIONAL
	WSDATA   nnCdCriterioPlanejamento  AS long OPTIONAL
	WSDATA   nnCdModalidade            AS long OPTIONAL
	WSDATA   nnCdOrdemCompra           AS long OPTIONAL
	WSDATA   nnCdPrioridade            AS long OPTIONAL
	WSDATA   nnCdSituacao              AS long OPTIONAL
	WSDATA   nnCdTipoOrdemCompra       AS long OPTIONAL
	WSDATA   oWSoAplicacaoDetalhe      AS OrdemCompra_AplicacaoDetalheDTO OPTIONAL
	WSDATA   oWSoCentroCustoDetalhe    AS OrdemCompra_CentroCustoDetalheDTO OPTIONAL
	WSDATA   oWSoDepartamentoDetalhe   AS OrdemCompra_DepartamentoDetalheDTO OPTIONAL
	WSDATA   oWSoEmpresaDetalhe        AS OrdemCompra_EmpresaDetalheDTO OPTIONAL
	WSDATA   oWSoEnderecoCobrancaDetalhe AS OrdemCompra_EnderecoDTO OPTIONAL
	WSDATA   oWSoEnderecoEntregaDetalhe AS OrdemCompra_EnderecoDTO OPTIONAL
	WSDATA   oWSoEnderecoFaturamentoDetalhe AS OrdemCompra_EnderecoDTO OPTIONAL
	WSDATA   oWSoPrioridadeDetalhe     AS OrdemCompra_PrioridadeDetalheDTO OPTIONAL
	WSDATA   oWSoUsuarioCompradorDetalhe AS OrdemCompra_UsuarioDetalheDTO OPTIONAL
	WSDATA   oWSoUsuarioResponsavelDetalhe AS OrdemCompra_UsuarioDetalheDTO OPTIONAL
	WSDATA   csCdAlmoxarifado          AS string OPTIONAL
	WSDATA   csCdCentroCusto           AS string OPTIONAL
	WSDATA   csCdCobrancaEndereco      AS string OPTIONAL
	WSDATA   csCdContaContabil         AS string OPTIONAL
	WSDATA   csCdDepartamento          AS string OPTIONAL
	WSDATA   csCdEmpresa               AS string OPTIONAL
	WSDATA   csCdEmpresaCobrancaEndereco AS string OPTIONAL
	WSDATA   csCdEmpresaEntregaEndereco AS string OPTIONAL
	WSDATA   csCdEmpresaFaturamentoEndereco AS string OPTIONAL
	WSDATA   csCdEntregaEndereco       AS string OPTIONAL
	WSDATA   csCdFaturamentoEndereco   AS string OPTIONAL
	WSDATA   csCdGestao                AS string OPTIONAL
	WSDATA   csCdOrdemCompraEmpresa    AS string OPTIONAL
	WSDATA   csCdUsuarioComprador      AS string OPTIONAL
	WSDATA   csCdUsuarioResponsavel    AS string OPTIONAL
	WSDATA   csDsJustificativa         AS string OPTIONAL
	WSDATA   csDsOrdemCompra           AS string OPTIONAL
	WSDATA   ctDtCadastro              AS dateTime OPTIONAL
	WSDATA   ctDtEmissao               AS dateTime OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT OrdemCompra_OrdemCompraDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT OrdemCompra_OrdemCompraDTO
Return

WSMETHOD CLONE WSCLIENT OrdemCompra_OrdemCompraDTO
	Local oClone := OrdemCompra_OrdemCompraDTO():NEW()
	oClone:ndVlTotalEstimado    := ::ndVlTotalEstimado
	oClone:oWSlstOrdemCompraItem := IIF(::oWSlstOrdemCompraItem = NIL , NIL , ::oWSlstOrdemCompraItem:Clone() )
	oClone:nnCdAplicacao        := ::nnCdAplicacao
	oClone:nnCdClassificacao    := ::nnCdClassificacao
	oClone:nnCdCriterioPlanejamento := ::nnCdCriterioPlanejamento
	oClone:nnCdModalidade       := ::nnCdModalidade
	oClone:nnCdOrdemCompra      := ::nnCdOrdemCompra
	oClone:nnCdPrioridade       := ::nnCdPrioridade
	oClone:nnCdSituacao         := ::nnCdSituacao
	oClone:nnCdTipoOrdemCompra  := ::nnCdTipoOrdemCompra
	oClone:oWSoAplicacaoDetalhe := IIF(::oWSoAplicacaoDetalhe = NIL , NIL , ::oWSoAplicacaoDetalhe:Clone() )
	oClone:oWSoCentroCustoDetalhe := IIF(::oWSoCentroCustoDetalhe = NIL , NIL , ::oWSoCentroCustoDetalhe:Clone() )
	oClone:oWSoDepartamentoDetalhe := IIF(::oWSoDepartamentoDetalhe = NIL , NIL , ::oWSoDepartamentoDetalhe:Clone() )
	oClone:oWSoEmpresaDetalhe   := IIF(::oWSoEmpresaDetalhe = NIL , NIL , ::oWSoEmpresaDetalhe:Clone() )
	oClone:oWSoEnderecoCobrancaDetalhe := IIF(::oWSoEnderecoCobrancaDetalhe = NIL , NIL , ::oWSoEnderecoCobrancaDetalhe:Clone() )
	oClone:oWSoEnderecoEntregaDetalhe := IIF(::oWSoEnderecoEntregaDetalhe = NIL , NIL , ::oWSoEnderecoEntregaDetalhe:Clone() )
	oClone:oWSoEnderecoFaturamentoDetalhe := IIF(::oWSoEnderecoFaturamentoDetalhe = NIL , NIL , ::oWSoEnderecoFaturamentoDetalhe:Clone() )
	oClone:oWSoPrioridadeDetalhe := IIF(::oWSoPrioridadeDetalhe = NIL , NIL , ::oWSoPrioridadeDetalhe:Clone() )
	oClone:oWSoUsuarioCompradorDetalhe := IIF(::oWSoUsuarioCompradorDetalhe = NIL , NIL , ::oWSoUsuarioCompradorDetalhe:Clone() )
	oClone:oWSoUsuarioResponsavelDetalhe := IIF(::oWSoUsuarioResponsavelDetalhe = NIL , NIL , ::oWSoUsuarioResponsavelDetalhe:Clone() )
	oClone:csCdAlmoxarifado     := ::csCdAlmoxarifado
	oClone:csCdCentroCusto      := ::csCdCentroCusto
	oClone:csCdCobrancaEndereco := ::csCdCobrancaEndereco
	oClone:csCdContaContabil    := ::csCdContaContabil
	oClone:csCdDepartamento     := ::csCdDepartamento
	oClone:csCdEmpresa          := ::csCdEmpresa
	oClone:csCdEmpresaCobrancaEndereco := ::csCdEmpresaCobrancaEndereco
	oClone:csCdEmpresaEntregaEndereco := ::csCdEmpresaEntregaEndereco
	oClone:csCdEmpresaFaturamentoEndereco := ::csCdEmpresaFaturamentoEndereco
	oClone:csCdEntregaEndereco  := ::csCdEntregaEndereco
	oClone:csCdFaturamentoEndereco := ::csCdFaturamentoEndereco
	oClone:csCdGestao           := ::csCdGestao
	oClone:csCdOrdemCompraEmpresa := ::csCdOrdemCompraEmpresa
	oClone:csCdUsuarioComprador := ::csCdUsuarioComprador
	oClone:csCdUsuarioResponsavel := ::csCdUsuarioResponsavel
	oClone:csDsJustificativa    := ::csDsJustificativa
	oClone:csDsOrdemCompra      := ::csDsOrdemCompra
	oClone:ctDtCadastro         := ::ctDtCadastro
	oClone:ctDtEmissao          := ::ctDtEmissao
Return oClone

WSMETHOD SOAPSEND WSCLIENT OrdemCompra_OrdemCompraDTO
	Local cSoap := ""
	cSoap += WSSoapValue("dVlTotalEstimado", ::ndVlTotalEstimado, ::ndVlTotalEstimado , "decimal", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("lstOrdemCompraItem", ::oWSlstOrdemCompraItem, ::oWSlstOrdemCompraItem , "ArrayOfOrdemCompraItemDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("nCdAplicacao", ::nnCdAplicacao, ::nnCdAplicacao , "long", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("nCdClassificacao", ::nnCdClassificacao, ::nnCdClassificacao , "long", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("nCdCriterioPlanejamento", ::nnCdCriterioPlanejamento, ::nnCdCriterioPlanejamento , "long", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("nCdModalidade", ::nnCdModalidade, ::nnCdModalidade , "long", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("nCdOrdemCompra", ::nnCdOrdemCompra, ::nnCdOrdemCompra , "long", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("nCdPrioridade", ::nnCdPrioridade, ::nnCdPrioridade , "long", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("nCdSituacao", ::nnCdSituacao, ::nnCdSituacao , "long", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("nCdTipoOrdemCompra", ::nnCdTipoOrdemCompra, ::nnCdTipoOrdemCompra , "long", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("oAplicacaoDetalhe", ::oWSoAplicacaoDetalhe, ::oWSoAplicacaoDetalhe , "AplicacaoDetalheDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("oCentroCustoDetalhe", ::oWSoCentroCustoDetalhe, ::oWSoCentroCustoDetalhe , "CentroCustoDetalheDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("oDepartamentoDetalhe", ::oWSoDepartamentoDetalhe, ::oWSoDepartamentoDetalhe , "DepartamentoDetalheDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("oEmpresaDetalhe", ::oWSoEmpresaDetalhe, ::oWSoEmpresaDetalhe , "EmpresaDetalheDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("oEnderecoCobrancaDetalhe", ::oWSoEnderecoCobrancaDetalhe, ::oWSoEnderecoCobrancaDetalhe , "EnderecoDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("oEnderecoEntregaDetalhe", ::oWSoEnderecoEntregaDetalhe, ::oWSoEnderecoEntregaDetalhe , "EnderecoDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("oEnderecoFaturamentoDetalhe", ::oWSoEnderecoFaturamentoDetalhe, ::oWSoEnderecoFaturamentoDetalhe , "EnderecoDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("oPrioridadeDetalhe", ::oWSoPrioridadeDetalhe, ::oWSoPrioridadeDetalhe , "PrioridadeDetalheDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("oUsuarioCompradorDetalhe", ::oWSoUsuarioCompradorDetalhe, ::oWSoUsuarioCompradorDetalhe , "UsuarioDetalheDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("oUsuarioResponsavelDetalhe", ::oWSoUsuarioResponsavelDetalhe, ::oWSoUsuarioResponsavelDetalhe , "UsuarioDetalheDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdAlmoxarifado", ::csCdAlmoxarifado, ::csCdAlmoxarifado , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdCentroCusto", ::csCdCentroCusto, ::csCdCentroCusto , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdCobrancaEndereco", ::csCdCobrancaEndereco, ::csCdCobrancaEndereco , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdContaContabil", ::csCdContaContabil, ::csCdContaContabil , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdDepartamento", ::csCdDepartamento, ::csCdDepartamento , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdEmpresa", ::csCdEmpresa, ::csCdEmpresa , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdEmpresaCobrancaEndereco", ::csCdEmpresaCobrancaEndereco, ::csCdEmpresaCobrancaEndereco , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdEmpresaEntregaEndereco", ::csCdEmpresaEntregaEndereco, ::csCdEmpresaEntregaEndereco , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdEmpresaFaturamentoEndereco", ::csCdEmpresaFaturamentoEndereco, ::csCdEmpresaFaturamentoEndereco , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdEntregaEndereco", ::csCdEntregaEndereco, ::csCdEntregaEndereco , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdFaturamentoEndereco", ::csCdFaturamentoEndereco, ::csCdFaturamentoEndereco , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdGestao", ::csCdGestao, ::csCdGestao , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdOrdemCompraEmpresa", ::csCdOrdemCompraEmpresa, ::csCdOrdemCompraEmpresa , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdUsuarioComprador", ::csCdUsuarioComprador, ::csCdUsuarioComprador , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdUsuarioResponsavel", ::csCdUsuarioResponsavel, ::csCdUsuarioResponsavel , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sDsJustificativa", ::csDsJustificativa, ::csDsJustificativa , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sDsOrdemCompra", ::csDsOrdemCompra, ::csDsOrdemCompra , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("tDtCadastro", ::ctDtCadastro, ::ctDtCadastro , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("tDtEmissao", ::ctDtEmissao, ::ctDtEmissao , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT OrdemCompra_OrdemCompraDTO
	Local oNode2
	Local oNode11
	Local oNode12
	Local oNode13
	Local oNode14
	Local oNode15
	Local oNode16
	Local oNode17
	Local oNode18
	Local oNode19
	Local oNode20
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::ndVlTotalEstimado  :=  WSAdvValue( oResponse,"_DVLTOTALESTIMADO","decimal",NIL,NIL,NIL,"N",NIL,NIL) 
	oNode2 :=  WSAdvValue( oResponse,"_LSTORDEMCOMPRAITEM","ArrayOfOrdemCompraItemDTO",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode2 != NIL
		::oWSlstOrdemCompraItem := OrdemCompra_ArrayOfOrdemCompraItemDTO():New()
		::oWSlstOrdemCompraItem:SoapRecv(oNode2)
	EndIf
	::nnCdAplicacao      :=  WSAdvValue( oResponse,"_NCDAPLICACAO","long",NIL,NIL,NIL,"N",NIL,NIL) 
	::nnCdClassificacao  :=  WSAdvValue( oResponse,"_NCDCLASSIFICACAO","long",NIL,NIL,NIL,"N",NIL,NIL) 
	::nnCdCriterioPlanejamento :=  WSAdvValue( oResponse,"_NCDCRITERIOPLANEJAMENTO","long",NIL,NIL,NIL,"N",NIL,NIL) 
	::nnCdModalidade     :=  WSAdvValue( oResponse,"_NCDMODALIDADE","long",NIL,NIL,NIL,"N",NIL,NIL) 
	::nnCdOrdemCompra    :=  WSAdvValue( oResponse,"_NCDORDEMCOMPRA","long",NIL,NIL,NIL,"N",NIL,NIL) 
	::nnCdPrioridade     :=  WSAdvValue( oResponse,"_NCDPRIORIDADE","long",NIL,NIL,NIL,"N",NIL,NIL) 
	::nnCdSituacao       :=  WSAdvValue( oResponse,"_NCDSITUACAO","long",NIL,NIL,NIL,"N",NIL,NIL) 
	::nnCdTipoOrdemCompra :=  WSAdvValue( oResponse,"_NCDTIPOORDEMCOMPRA","long",NIL,NIL,NIL,"N",NIL,NIL) 
	oNode11 :=  WSAdvValue( oResponse,"_OAPLICACAODETALHE","AplicacaoDetalheDTO",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode11 != NIL
		::oWSoAplicacaoDetalhe := OrdemCompra_AplicacaoDetalheDTO():New()
		::oWSoAplicacaoDetalhe:SoapRecv(oNode11)
	EndIf
	oNode12 :=  WSAdvValue( oResponse,"_OCENTROCUSTODETALHE","CentroCustoDetalheDTO",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode12 != NIL
		::oWSoCentroCustoDetalhe := OrdemCompra_CentroCustoDetalheDTO():New()
		::oWSoCentroCustoDetalhe:SoapRecv(oNode12)
	EndIf
	oNode13 :=  WSAdvValue( oResponse,"_ODEPARTAMENTODETALHE","DepartamentoDetalheDTO",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode13 != NIL
		::oWSoDepartamentoDetalhe := OrdemCompra_DepartamentoDetalheDTO():New()
		::oWSoDepartamentoDetalhe:SoapRecv(oNode13)
	EndIf
	oNode14 :=  WSAdvValue( oResponse,"_OEMPRESADETALHE","EmpresaDetalheDTO",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode14 != NIL
		::oWSoEmpresaDetalhe := OrdemCompra_EmpresaDetalheDTO():New()
		::oWSoEmpresaDetalhe:SoapRecv(oNode14)
	EndIf
	oNode15 :=  WSAdvValue( oResponse,"_OENDERECOCOBRANCADETALHE","EnderecoDTO",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode15 != NIL
		::oWSoEnderecoCobrancaDetalhe := OrdemCompra_EnderecoDTO():New()
		::oWSoEnderecoCobrancaDetalhe:SoapRecv(oNode15)
	EndIf
	oNode16 :=  WSAdvValue( oResponse,"_OENDERECOENTREGADETALHE","EnderecoDTO",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode16 != NIL
		::oWSoEnderecoEntregaDetalhe := OrdemCompra_EnderecoDTO():New()
		::oWSoEnderecoEntregaDetalhe:SoapRecv(oNode16)
	EndIf
	oNode17 :=  WSAdvValue( oResponse,"_OENDERECOFATURAMENTODETALHE","EnderecoDTO",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode17 != NIL
		::oWSoEnderecoFaturamentoDetalhe := OrdemCompra_EnderecoDTO():New()
		::oWSoEnderecoFaturamentoDetalhe:SoapRecv(oNode17)
	EndIf
	oNode18 :=  WSAdvValue( oResponse,"_OPRIORIDADEDETALHE","PrioridadeDetalheDTO",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode18 != NIL
		::oWSoPrioridadeDetalhe := OrdemCompra_PrioridadeDetalheDTO():New()
		::oWSoPrioridadeDetalhe:SoapRecv(oNode18)
	EndIf
	oNode19 :=  WSAdvValue( oResponse,"_OUSUARIOCOMPRADORDETALHE","UsuarioDetalheDTO",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode19 != NIL
		::oWSoUsuarioCompradorDetalhe := OrdemCompra_UsuarioDetalheDTO():New()
		::oWSoUsuarioCompradorDetalhe:SoapRecv(oNode19)
	EndIf
	oNode20 :=  WSAdvValue( oResponse,"_OUSUARIORESPONSAVELDETALHE","UsuarioDetalheDTO",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode20 != NIL
		::oWSoUsuarioResponsavelDetalhe := OrdemCompra_UsuarioDetalheDTO():New()
		::oWSoUsuarioResponsavelDetalhe:SoapRecv(oNode20)
	EndIf
	::csCdAlmoxarifado   :=  WSAdvValue( oResponse,"_SCDALMOXARIFADO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdCentroCusto    :=  WSAdvValue( oResponse,"_SCDCENTROCUSTO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdCobrancaEndereco :=  WSAdvValue( oResponse,"_SCDCOBRANCAENDERECO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdContaContabil  :=  WSAdvValue( oResponse,"_SCDCONTACONTABIL","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdDepartamento   :=  WSAdvValue( oResponse,"_SCDDEPARTAMENTO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdEmpresa        :=  WSAdvValue( oResponse,"_SCDEMPRESA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdEmpresaCobrancaEndereco :=  WSAdvValue( oResponse,"_SCDEMPRESACOBRANCAENDERECO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdEmpresaEntregaEndereco :=  WSAdvValue( oResponse,"_SCDEMPRESAENTREGAENDERECO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdEmpresaFaturamentoEndereco :=  WSAdvValue( oResponse,"_SCDEMPRESAFATURAMENTOENDERECO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdEntregaEndereco :=  WSAdvValue( oResponse,"_SCDENTREGAENDERECO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdFaturamentoEndereco :=  WSAdvValue( oResponse,"_SCDFATURAMENTOENDERECO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdGestao         :=  WSAdvValue( oResponse,"_SCDGESTAO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdOrdemCompraEmpresa :=  WSAdvValue( oResponse,"_SCDORDEMCOMPRAEMPRESA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdUsuarioComprador :=  WSAdvValue( oResponse,"_SCDUSUARIOCOMPRADOR","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdUsuarioResponsavel :=  WSAdvValue( oResponse,"_SCDUSUARIORESPONSAVEL","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csDsJustificativa  :=  WSAdvValue( oResponse,"_SDSJUSTIFICATIVA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csDsOrdemCompra    :=  WSAdvValue( oResponse,"_SDSORDEMCOMPRA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::ctDtCadastro       :=  WSAdvValue( oResponse,"_TDTCADASTRO","dateTime",NIL,NIL,NIL,"S",NIL,NIL) 
	::ctDtEmissao        :=  WSAdvValue( oResponse,"_TDTEMISSAO","dateTime",NIL,NIL,NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure ArrayOfWbtLogDTO

WSSTRUCT OrdemCompra_ArrayOfWbtLogDTO
	WSDATA   oWSWbtLogDTO              AS OrdemCompra_WbtLogDTO OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT OrdemCompra_ArrayOfWbtLogDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT OrdemCompra_ArrayOfWbtLogDTO
	::oWSWbtLogDTO         := {} // Array Of  OrdemCompra_WBTLOGDTO():New()
Return

WSMETHOD CLONE WSCLIENT OrdemCompra_ArrayOfWbtLogDTO
	Local oClone := OrdemCompra_ArrayOfWbtLogDTO():NEW()
	oClone:oWSWbtLogDTO := NIL
	If ::oWSWbtLogDTO <> NIL 
		oClone:oWSWbtLogDTO := {}
		aEval( ::oWSWbtLogDTO , { |x| aadd( oClone:oWSWbtLogDTO , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT OrdemCompra_ArrayOfWbtLogDTO
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_WBTLOGDTO","WbtLogDTO",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSWbtLogDTO , OrdemCompra_WbtLogDTO():New() )
			::oWSWbtLogDTO[len(::oWSWbtLogDTO)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure OrdemCompraConsumoDTO

WSSTRUCT OrdemCompra_OrdemCompraConsumoDTO
	WSDATA   nnCdEmpresaTipo           AS long OPTIONAL
	WSDATA   nnCdRegistroPreco         AS long OPTIONAL
	WSDATA   csCdProcessoConsumo       AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT OrdemCompra_OrdemCompraConsumoDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT OrdemCompra_OrdemCompraConsumoDTO
Return

WSMETHOD CLONE WSCLIENT OrdemCompra_OrdemCompraConsumoDTO
	Local oClone := OrdemCompra_OrdemCompraConsumoDTO():NEW()
	oClone:nnCdEmpresaTipo      := ::nnCdEmpresaTipo
	oClone:nnCdRegistroPreco    := ::nnCdRegistroPreco
	oClone:csCdProcessoConsumo  := ::csCdProcessoConsumo
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT OrdemCompra_OrdemCompraConsumoDTO
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::nnCdEmpresaTipo    :=  WSAdvValue( oResponse,"_NCDEMPRESATIPO","long",NIL,NIL,NIL,"N",NIL,NIL) 
	::nnCdRegistroPreco  :=  WSAdvValue( oResponse,"_NCDREGISTROPRECO","long",NIL,NIL,NIL,"N",NIL,NIL) 
	::csCdProcessoConsumo :=  WSAdvValue( oResponse,"_SCDPROCESSOCONSUMO","string",NIL,NIL,NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure OrdemCompraTipoDTO

WSSTRUCT OrdemCompra_OrdemCompraTipoDTO
	WSDATA   nbFlVisivel               AS int OPTIONAL
	WSDATA   nnCdTipoOrdemCompra       AS long OPTIONAL
	WSDATA   csDsTipoOrdemCompra       AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT OrdemCompra_OrdemCompraTipoDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT OrdemCompra_OrdemCompraTipoDTO
Return

WSMETHOD CLONE WSCLIENT OrdemCompra_OrdemCompraTipoDTO
	Local oClone := OrdemCompra_OrdemCompraTipoDTO():NEW()
	oClone:nbFlVisivel          := ::nbFlVisivel
	oClone:nnCdTipoOrdemCompra  := ::nnCdTipoOrdemCompra
	oClone:csDsTipoOrdemCompra  := ::csDsTipoOrdemCompra
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT OrdemCompra_OrdemCompraTipoDTO
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::nbFlVisivel        :=  WSAdvValue( oResponse,"_BFLVISIVEL","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::nnCdTipoOrdemCompra :=  WSAdvValue( oResponse,"_NCDTIPOORDEMCOMPRA","long",NIL,NIL,NIL,"N",NIL,NIL) 
	::csDsTipoOrdemCompra :=  WSAdvValue( oResponse,"_SDSTIPOORDEMCOMPRA","string",NIL,NIL,NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure ArrayOfOrdemCompraItemDTO

WSSTRUCT OrdemCompra_ArrayOfOrdemCompraItemDTO
	WSDATA   oWSOrdemCompraItemDTO     AS OrdemCompra_OrdemCompraItemDTO OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT OrdemCompra_ArrayOfOrdemCompraItemDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT OrdemCompra_ArrayOfOrdemCompraItemDTO
	::oWSOrdemCompraItemDTO := {} // Array Of  OrdemCompra_ORDEMCOMPRAITEMDTO():New()
Return

WSMETHOD CLONE WSCLIENT OrdemCompra_ArrayOfOrdemCompraItemDTO
	Local oClone := OrdemCompra_ArrayOfOrdemCompraItemDTO():NEW()
	oClone:oWSOrdemCompraItemDTO := NIL
	If ::oWSOrdemCompraItemDTO <> NIL 
		oClone:oWSOrdemCompraItemDTO := {}
		aEval( ::oWSOrdemCompraItemDTO , { |x| aadd( oClone:oWSOrdemCompraItemDTO , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT OrdemCompra_ArrayOfOrdemCompraItemDTO
	Local cSoap := ""
	aEval( ::oWSOrdemCompraItemDTO , {|x| cSoap := cSoap  +  WSSoapValue("OrdemCompraItemDTO", x , x , "OrdemCompraItemDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.)  } ) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT OrdemCompra_ArrayOfOrdemCompraItemDTO
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_ORDEMCOMPRAITEMDTO","OrdemCompraItemDTO",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSOrdemCompraItemDTO , OrdemCompra_OrdemCompraItemDTO():New() )
			::oWSOrdemCompraItemDTO[len(::oWSOrdemCompraItemDTO)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure AplicacaoDetalheDTO

WSSTRUCT OrdemCompra_AplicacaoDetalheDTO
	WSDATA   csDsAplicacao             AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT OrdemCompra_AplicacaoDetalheDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT OrdemCompra_AplicacaoDetalheDTO
Return

WSMETHOD CLONE WSCLIENT OrdemCompra_AplicacaoDetalheDTO
	Local oClone := OrdemCompra_AplicacaoDetalheDTO():NEW()
	oClone:csDsAplicacao        := ::csDsAplicacao
Return oClone

WSMETHOD SOAPSEND WSCLIENT OrdemCompra_AplicacaoDetalheDTO
	Local cSoap := ""
	cSoap += WSSoapValue("sDsAplicacao", ::csDsAplicacao, ::csDsAplicacao , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT OrdemCompra_AplicacaoDetalheDTO
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::csDsAplicacao      :=  WSAdvValue( oResponse,"_SDSAPLICACAO","string",NIL,NIL,NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure CentroCustoDetalheDTO

WSSTRUCT OrdemCompra_CentroCustoDetalheDTO
	WSDATA   csDsCentroCusto           AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT OrdemCompra_CentroCustoDetalheDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT OrdemCompra_CentroCustoDetalheDTO
Return

WSMETHOD CLONE WSCLIENT OrdemCompra_CentroCustoDetalheDTO
	Local oClone := OrdemCompra_CentroCustoDetalheDTO():NEW()
	oClone:csDsCentroCusto      := ::csDsCentroCusto
Return oClone

WSMETHOD SOAPSEND WSCLIENT OrdemCompra_CentroCustoDetalheDTO
	Local cSoap := ""
	cSoap += WSSoapValue("sDsCentroCusto", ::csDsCentroCusto, ::csDsCentroCusto , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT OrdemCompra_CentroCustoDetalheDTO
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::csDsCentroCusto    :=  WSAdvValue( oResponse,"_SDSCENTROCUSTO","string",NIL,NIL,NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure DepartamentoDetalheDTO

WSSTRUCT OrdemCompra_DepartamentoDetalheDTO
	WSDATA   csDsDepartamento          AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT OrdemCompra_DepartamentoDetalheDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT OrdemCompra_DepartamentoDetalheDTO
Return

WSMETHOD CLONE WSCLIENT OrdemCompra_DepartamentoDetalheDTO
	Local oClone := OrdemCompra_DepartamentoDetalheDTO():NEW()
	oClone:csDsDepartamento     := ::csDsDepartamento
Return oClone

WSMETHOD SOAPSEND WSCLIENT OrdemCompra_DepartamentoDetalheDTO
	Local cSoap := ""
	cSoap += WSSoapValue("sDsDepartamento", ::csDsDepartamento, ::csDsDepartamento , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT OrdemCompra_DepartamentoDetalheDTO
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::csDsDepartamento   :=  WSAdvValue( oResponse,"_SDSDEPARTAMENTO","string",NIL,NIL,NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure EmpresaDetalheDTO

WSSTRUCT OrdemCompra_EmpresaDetalheDTO
	WSDATA   csNmEmpresa               AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT OrdemCompra_EmpresaDetalheDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT OrdemCompra_EmpresaDetalheDTO
Return

WSMETHOD CLONE WSCLIENT OrdemCompra_EmpresaDetalheDTO
	Local oClone := OrdemCompra_EmpresaDetalheDTO():NEW()
	oClone:csNmEmpresa          := ::csNmEmpresa
Return oClone

WSMETHOD SOAPSEND WSCLIENT OrdemCompra_EmpresaDetalheDTO
	Local cSoap := ""
	cSoap += WSSoapValue("sNmEmpresa", ::csNmEmpresa, ::csNmEmpresa , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT OrdemCompra_EmpresaDetalheDTO
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::csNmEmpresa        :=  WSAdvValue( oResponse,"_SNMEMPRESA","string",NIL,NIL,NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure EnderecoDTO

WSSTRUCT OrdemCompra_EnderecoDTO
	WSDATA   csCdCep                   AS string OPTIONAL
	WSDATA   csDsComplemento           AS string OPTIONAL
	WSDATA   csDsEndereco              AS string OPTIONAL
	WSDATA   csNmBairro                AS string OPTIONAL
	WSDATA   csNmCidade                AS string OPTIONAL
	WSDATA   csNrEndereco              AS string OPTIONAL
	WSDATA   csSgEstado                AS string OPTIONAL
	WSDATA   csSgPais                  AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT OrdemCompra_EnderecoDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT OrdemCompra_EnderecoDTO
Return

WSMETHOD CLONE WSCLIENT OrdemCompra_EnderecoDTO
	Local oClone := OrdemCompra_EnderecoDTO():NEW()
	oClone:csCdCep              := ::csCdCep
	oClone:csDsComplemento      := ::csDsComplemento
	oClone:csDsEndereco         := ::csDsEndereco
	oClone:csNmBairro           := ::csNmBairro
	oClone:csNmCidade           := ::csNmCidade
	oClone:csNrEndereco         := ::csNrEndereco
	oClone:csSgEstado           := ::csSgEstado
	oClone:csSgPais             := ::csSgPais
Return oClone

WSMETHOD SOAPSEND WSCLIENT OrdemCompra_EnderecoDTO
	Local cSoap := ""
	cSoap += WSSoapValue("sCdCep", ::csCdCep, ::csCdCep , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sDsComplemento", ::csDsComplemento, ::csDsComplemento , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sDsEndereco", ::csDsEndereco, ::csDsEndereco , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sNmBairro", ::csNmBairro, ::csNmBairro , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sNmCidade", ::csNmCidade, ::csNmCidade , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sNrEndereco", ::csNrEndereco, ::csNrEndereco , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sSgEstado", ::csSgEstado, ::csSgEstado , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sSgPais", ::csSgPais, ::csSgPais , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT OrdemCompra_EnderecoDTO
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::csCdCep            :=  WSAdvValue( oResponse,"_SCDCEP","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csDsComplemento    :=  WSAdvValue( oResponse,"_SDSCOMPLEMENTO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csDsEndereco       :=  WSAdvValue( oResponse,"_SDSENDERECO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csNmBairro         :=  WSAdvValue( oResponse,"_SNMBAIRRO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csNmCidade         :=  WSAdvValue( oResponse,"_SNMCIDADE","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csNrEndereco       :=  WSAdvValue( oResponse,"_SNRENDERECO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csSgEstado         :=  WSAdvValue( oResponse,"_SSGESTADO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csSgPais           :=  WSAdvValue( oResponse,"_SSGPAIS","string",NIL,NIL,NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure PrioridadeDetalheDTO

WSSTRUCT OrdemCompra_PrioridadeDetalheDTO
	WSDATA   csDsPrioridade            AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT OrdemCompra_PrioridadeDetalheDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT OrdemCompra_PrioridadeDetalheDTO
Return

WSMETHOD CLONE WSCLIENT OrdemCompra_PrioridadeDetalheDTO
	Local oClone := OrdemCompra_PrioridadeDetalheDTO():NEW()
	oClone:csDsPrioridade       := ::csDsPrioridade
Return oClone

WSMETHOD SOAPSEND WSCLIENT OrdemCompra_PrioridadeDetalheDTO
	Local cSoap := ""
	cSoap += WSSoapValue("sDsPrioridade", ::csDsPrioridade, ::csDsPrioridade , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT OrdemCompra_PrioridadeDetalheDTO
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::csDsPrioridade     :=  WSAdvValue( oResponse,"_SDSPRIORIDADE","string",NIL,NIL,NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure UsuarioDetalheDTO

WSSTRUCT OrdemCompra_UsuarioDetalheDTO
	WSDATA   csNmUsuario               AS string OPTIONAL
	WSDATA   csNrCnpjEmpresa           AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT OrdemCompra_UsuarioDetalheDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT OrdemCompra_UsuarioDetalheDTO
Return

WSMETHOD CLONE WSCLIENT OrdemCompra_UsuarioDetalheDTO
	Local oClone := OrdemCompra_UsuarioDetalheDTO():NEW()
	oClone:csNmUsuario          := ::csNmUsuario
	oClone:csNrCnpjEmpresa      := ::csNrCnpjEmpresa
Return oClone

WSMETHOD SOAPSEND WSCLIENT OrdemCompra_UsuarioDetalheDTO
	Local cSoap := ""
	cSoap += WSSoapValue("sNmUsuario", ::csNmUsuario, ::csNmUsuario , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sNrCnpjEmpresa", ::csNrCnpjEmpresa, ::csNrCnpjEmpresa , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT OrdemCompra_UsuarioDetalheDTO
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::csNmUsuario        :=  WSAdvValue( oResponse,"_SNMUSUARIO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csNrCnpjEmpresa    :=  WSAdvValue( oResponse,"_SNRCNPJEMPRESA","string",NIL,NIL,NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure WbtLogDTO

WSSTRUCT OrdemCompra_WbtLogDTO
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

WSMETHOD NEW WSCLIENT OrdemCompra_WbtLogDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT OrdemCompra_WbtLogDTO
Return

WSMETHOD CLONE WSCLIENT OrdemCompra_WbtLogDTO
	Local oClone := OrdemCompra_WbtLogDTO():NEW()
	oClone:nnCdLog              := ::nnCdLog
	oClone:nnIdRetorno          := ::nnIdRetorno
	oClone:csCdOrigem           := ::csCdOrigem
	oClone:csDsLog              := ::csDsLog
	oClone:csDsTipoDocumento    := ::csDsTipoDocumento
	oClone:csNrToken            := ::csNrToken
	oClone:ctDtLog              := ::ctDtLog
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT OrdemCompra_WbtLogDTO
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

// WSDL Data Structure OrdemCompraItemDTO

WSSTRUCT OrdemCompra_OrdemCompraItemDTO
	//propriedades adicionadas manualmente NÃO REMOVER
	WSDATA nbFlSubcontratacao 				As int OPTIONAL
	WSDATA ndQtEntrega 						As decimal OPTIONAL
	WSDATA nnCdAplicacao	 				As long OPTIONAL
	WSDATA nnCdMarca	 					As long OPTIONAL
	WSDATA nnCdSituacao		 				As long OPTIONAL
	WSDATA csCdCentroCusto 					As string OPTIONAL
	WSDATA csCdClasse 						As string OPTIONAL
	WSDATA csCdEmpresa 						As string OPTIONAL
	WSDATA csCdEmpresaCobrancaEndereco		As string OPTIONAL
	WSDATA csCdEmpresaEntregaEndereco		As string OPTIONAL
	WSDATA csCdEmpresaFaturamentoEndereco	As string OPTIONAL
	WSDATA csCdItemEmpresa 					As string OPTIONAL
	WSDATA csCdProduto 						As string OPTIONAL
	WSDATA csCdRequisicaoEmpresa 			As string OPTIONAL
	WSDATA csCdUnidadeMedida 				As string OPTIONAL
	WSDATA csCdUsuarioComprador 			As string OPTIONAL
	WSDATA csCdUsuarioResponsavel 			As string OPTIONAL
	WSDATA csDsJustificativa 				As string OPTIONAL
	WSDATA csDsObservacao	 				As string OPTIONAL
	WSDATA csDsProdutoRequisicao			As string OPTIONAL
	WSDATA ctDtCriacao 						As dateTime OPTIONAL
	WSDATA ctDtEntrega 						As dateTime OPTIONAL
	WSDATA ctDtLiberacao					As dateTime OPTIONAL
	WSDATA ctDtMoedaCotacao					As dateTime OPTIONAL
	
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT OrdemCompra_OrdemCompraItemDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT OrdemCompra_OrdemCompraItemDTO
Return

WSMETHOD CLONE WSCLIENT OrdemCompra_OrdemCompraItemDTO
	Local oClone := OrdemCompra_OrdemCompraItemDTO():NEW()
	oClone:nbFlSubcontratacao 				:= ::nbFlSubcontratacao
	oClone:ndQtEntrega 						:= ::ndQtEntrega
	oClone:nnCdAplicacao 					:= ::nnCdAplicacao
	oClone:nnCdMarca 						:= ::nnCdMarca
	oClone:nnCdSituacao 					:= ::nnCdSituacao
	oClone:csCdCentroCusto 					:= ::csCdCentroCusto
	oClone:csCdClasse 						:= ::csCdClasse
	oClone:csCdEmpresa 						:= ::csCdEmpresa
	oClone:csCdEmpresaCobrancaEndereco		:= ::csCdEmpresaCobrancaEndereco
	oClone:csCdEmpresaEntregaEndereco		:= ::csCdEmpresaEntregaEndereco
	oClone:csCdEmpresaFaturamentoEndereco 	:= ::csCdEmpresaFaturamentoEndereco
	oClone:csCdItemEmpresa 					:= ::csCdItemEmpresa
	oClone:csCdProduto 						:= ::csCdProduto
	oClone:csCdRequisicaoEmpresa			:= ::csCdRequisicaoEmpresa
	oClone:csCdUnidadeMedida 				:= ::csCdUnidadeMedida
	oClone:csCdUsuarioComprador 			:= ::csCdUsuarioComprador
	oClone:csCdUsuarioResponsavel 			:= ::csCdUsuarioResponsavel
	oClone:csDsJustificativa 				:= ::csDsJustificativa
	oClone:csDsObservacao 					:= ::csDsObservacao
	oClone:csDsProdutoRequisicao 			:= ::csDsProdutoRequisicao
	oClone:ctDtCriacao	 					:= ::ctDtCriacao
	oClone:ctDtEntrega 						:= ::ctDtEntrega
	oClone:ctDtLiberacao 					:= ::ctDtLiberacao
	oClone:ctDtMoedaCotacao 				:= ::ctDtMoedaCotacao
	
Return oClone

WSMETHOD SOAPSEND WSCLIENT OrdemCompra_OrdemCompraItemDTO
	Local cSoap := ""
	//propriedades adicionadas manualmente NÃO REMOVER
	//<xs:element minOccurs="0" name="bFlSubcontratacao" type="xs:int"/>
	cSoap += WSSoapValue("bFlSubcontratacao"   , ::nbFlSubcontratacao   , ::nbFlSubcontratacao   , "int"     , .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.)
	//<xs:element name="dQtEntrega" nillable="true" type="xs:decimal"/>
	cSoap += WSSoapValue("dQtEntrega"          , ::ndQtEntrega          , ::ndQtEntrega          , "decimal" , .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.)
	//<xs:element minOccurs="0" name="dVlReferencia" nillable="true" type="xs:decimal"/>
	//cSoap += WSSoapValue("dVlReferencia"       , ::ndVlReferencia       , ::ndVlReferencia       , "decimal" , .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.)
	//<xs:element minOccurs="0" name="lstRequisicaoEmpresaDTO" nillable="true" type="tns:ArrayOfRequisicaoEmpresaDTO"/>
	//<xs:element minOccurs="0" name="lstRequisicaoIdioma" nillable="true" type="tns:ArrayOfRequisicaoIdiomaDTO"/>
	//<xs:element name="nCdAplicacao" nillable="true" type="xs:long"/>
	cSoap += WSSoapValue("nCdAplicacao"        , ::nnCdAplicacao        , ::nnCdAplicacao        , "long"     , .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.)
	//<xs:element minOccurs="0" name="nCdMarca" nillable="true" type="xs:long"/>
	cSoap += WSSoapValue("nCdMarca"        , ::nnCdMarca        , ::nnCdMarca        , "long"     , .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.)
	//<xs:element minOccurs="0" name="nCdMoeda" nillable="true" type="xs:long"/>
	//<xs:element minOccurs="0" name="nCdOrigem" type="xs:long"/>
	//<xs:element minOccurs="0" name="nCdRequisicao" type="xs:long"/>
	//<xs:element name="nCdSituacao" nillable="true" type="xs:long"/>
	cSoap += WSSoapValue("nCdSituacao"         , ::nnCdSituacao        , ::nnCdSituacao          , "long"     , .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.)
	//<xs:element minOccurs="0" name="nIdTipoOrigem" type="xs:long"/>
	//<xs:element minOccurs="0" name="nIdTipoRequisicao" nillable="true" type="xs:int"/>
	//<xs:element minOccurs="0" name="oAplicacaoDetalhe" nillable="true" type="tns:AplicacaoDetalheDTO"/>
	//<xs:element minOccurs="0" name="oContaContabilDetalhe" nillable="true" type="tns:ContaContabilDetalheDTO"/>
	//<xs:element minOccurs="0" name="oCriterioDetalhe" nillable="true" type="tns:CriterioDetalheDTO"/>
	//<xs:element minOccurs="0" name="oMarcaDetalhe" nillable="true" type="tns:MarcaDetalheDTO"/>
	//<xs:element minOccurs="0" name="oNaturezaDespesaDetalhe" nillable="true" type="tns:NaturezaDespesaDetalheDTO"/>
	//<xs:element minOccurs="0" name="oUnidadeMedidaDetalhe" nillable="true" type="tns:UnidadeMedidaDetalheDTO"/>
	//<xs:element minOccurs="0" name="sCdCentroCusto" nillable="true" type="xs:string"/>
	cSoap += WSSoapValue("sCdCentroCusto"      , ::csCdCentroCusto      , ::csCdCentroCusto      , "string"  , .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.)
	//<xs:element name="sCdClasse" nillable="true" type="xs:string"/> 
	cSoap += WSSoapValue("sCdClasse"           , ::csCdClasse           , ::csCdClasse           , "string"  , .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.)
	//<xs:element minOccurs="0" name="sCdCobrancaEndereco" nillable="true" type="xs:string"/>
	//<xs:element minOccurs="0" name="sCdContaContabil" nillable="true" type="xs:string"/>
	//<xs:element minOccurs="0" name="sCdDepartamento" nillable="true" type="xs:string"/>
	//<xs:element name="sCdEmpresa" nillable="true" type="xs:string"/>
	cSoap += WSSoapValue("sCdEmpresa"          , ::csCdEmpresa          , ::csCdEmpresa          , "string"  , .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.)
	//<xs:element minOccurs="0" name="sCdEmpresaCobrancaEndereco" nillable="true" type="xs:string"/>
	cSoap += WSSoapValue("sCdEmpresaCobrancaEndereco"          , ::csCdEmpresaCobrancaEndereco          , ::csCdEmpresaCobrancaEndereco          , "string"  , .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.)
	//<xs:element minOccurs="0" name="sCdEmpresaEntregaEndereco" nillable="true" type="xs:string"/>
	cSoap += WSSoapValue("sCdEmpresaEntregaEndereco"          , ::csCdEmpresaEntregaEndereco          , ::csCdEmpresaEntregaEndereco          , "string"  , .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.)
	//<xs:element minOccurs="0" name="sCdEmpresaFaturamentoEndereco" nillable="true" type="xs:string"/>
	cSoap += WSSoapValue("sCdEmpresaFaturamentoEndereco"          , ::csCdEmpresaFaturamentoEndereco          , ::csCdEmpresaFaturamentoEndereco          , "string"  , .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.)
	//<xs:element minOccurs="0" name="sCdEntregaEndereco" nillable="true" type="xs:string"/>
	//<xs:element minOccurs="0" name="sCdFaturamentoEndereco" nillable="true" type="xs:string"/>
	//<xs:element minOccurs="0" name="sCdFonteRecurso" nillable="true" type="xs:string"/>
	//<xs:element minOccurs="0" name="sCdGrupoCompra" nillable="true" type="xs:string"/>
	//<xs:element name="sCdItemEmpresa" nillable="true" type="xs:string"/>
	cSoap += WSSoapValue("sCdItemEmpresa"      , ::csCdItemEmpresa      , ::csCdItemEmpresa      , "string"  , .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.)
	//<xs:element minOccurs="0" name="sCdMoeda" nillable="true" type="xs:string"/>
	//<xs:element minOccurs="0" name="sCdNaturezaDespesa" nillable="true" type="xs:string"/>
	//<xs:element name="sCdProduto" nillable="true" type="xs:string"/>
	cSoap += WSSoapValue("sCdProduto"          , ::csCdProduto          , ::csCdProduto          , "string"  , .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.)
	//<xs:element minOccurs="0" name="sCdProjeto" nillable="true" type="xs:string"/>
	//<xs:element name="sCdRequisicaoEmpresa" nillable="true" type="xs:string"/>
	cSoap += WSSoapValue("sCdRequisicaoEmpresa", ::csCdRequisicaoEmpresa, ::csCdRequisicaoEmpresa, "string"  , .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.)
	//<xs:element name="sCdUnidadeMedida" nillable="true" type="xs:string"/>
	cSoap += WSSoapValue("sCdUnidadeMedida", ::csCdUnidadeMedida, ::csCdUnidadeMedida, "string"  , .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.)
	//<xs:element minOccurs="0" name="sCdUnidadeNegocio" nillable="true" type="xs:string"/>
	//<xs:element minOccurs="0" name="sCdUsuarioComprador" nillable="true" type="xs:string"/>
	cSoap += WSSoapValue("sCdUsuarioComprador", ::csCdUsuarioComprador, ::csCdUsuarioComprador, "string"  , .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.)
	//<xs:element name="sCdUsuarioResponsavel" nillable="true" type="xs:string"/>
	cSoap += WSSoapValue("sCdUsuarioResponsavel", ::csCdUsuarioResponsavel, ::csCdUsuarioResponsavel, "string"  , .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.)
	//<xs:element minOccurs="0" name="sDsAnexo" nillable="true" type="xs:string"/>
	//<xs:element minOccurs="0" name="sDsDetalheCliente" nillable="true" type="xs:string"/>
	//<xs:element name="sDsJustificativa" nillable="true" type="xs:string"/>
	cSoap += WSSoapValue("sDsJustificativa", ::csDsJustificativa, ::csDsJustificativa, "string"  , .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.)
	//<xs:element minOccurs="0" name="sDsObservacao" nillable="true" type="xs:string"/>
	cSoap += WSSoapValue("sDsObservacao", ::csDsObservacao, ::csDsObservacao, "string"  , .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.)
	//<xs:element minOccurs="0" name="sDsObservacaoInterna" nillable="true" type="xs:string"/>
	//<xs:element name="sDsProdutoRequisicao" nillable="true" type="xs:string"/>
	cSoap += WSSoapValue("sDsProdutoRequisicao", ::csDsProdutoRequisicao, ::csDsProdutoRequisicao, "string"  , .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.)
	//<xs:element minOccurs="0" name="sNrOportunidade" nillable="true" type="xs:string"/>
	//<xs:element minOccurs="0" name="sNrRecap" nillable="true" type="xs:string"/>
	//<xs:element minOccurs="0" name="tDtCriacao" type="xs:dateTime"/>
	cSoap += WSSoapValue("tDtCriacao"          , ::ctDtCriacao          , ::ctDtCriacao          , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.)
	//<xs:element name="tDtEntrega" nillable="true" type="xs:dateTime"/>
	cSoap += WSSoapValue("tDtEntrega"          , ::ctDtEntrega          , ::ctDtEntrega          , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.)
	//<xs:element minOccurs="0" name="tDtLiberacao" type="xs:dateTime"/>
	cSoap += WSSoapValue("tDtLiberacao"          , ::ctDtLiberacao          , ::ctDtLiberacao          , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.)
	//<xs:element minOccurs="0" name="tDtMoedaCotacao" type="xs:dateTime"/>
	cSoap += WSSoapValue("tDtMoedaCotacao"          , ::ctDtMoedaCotacao          , ::ctDtMoedaCotacao          , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.)
	//<xs:element minOccurs="0" name="tDtProcesso" type="xs:dateTime"/> 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT OrdemCompra_OrdemCompraItemDTO
	::Init()
	If oResponse = NIL ; Return ; Endif
	//propriedades adicionadas manualmente NÃO REMOVER
	::nbFlSubcontratacao    := WSAdvValue(oResponse, "_BFLSUBCONTRATACAO"   , "int"     ,NIL, NIL, NIL, "N", NIL, NIL)
	::ndQtEntrega           := WSAdvValue(oResponse, "_DQTENTREGA"          , "decimal" ,Nil, Nil, Nil, "N", Nil, Nil)
	::nnCdAplicacao		    := WSAdvValue(oResponse, "_NCDAPLICACAO"    	, "int"     ,NIL, NIL, NIL, "N", NIL, NIL)
	::nnCdSituacao		    := WSAdvValue(oResponse, "_NCDSITUACAO"			, "int"     ,NIL, NIL, NIL, "N", NIL, NIL)
	::csCdCentroCusto       := WSAdvValue(oResponse, "_SCDCENTROCUSTO"      , "string"  ,Nil, Nil, Nil, "S", Nil, Nil)
	::csCdClasse            := WSAdvValue(oResponse, "_SCDCLASSE"           , "string"  ,Nil, Nil, Nil, "S", Nil, Nil)
	::csCdItemEmpresa       := WSAdvValue(oResponse, "_SCDITEMEMPRESA"      , "string"  ,Nil, Nil, Nil, "S", Nil, Nil)
	::csCdProduto           := WSAdvValue(oResponse, "_SCDPRODUTO"          , "string"  ,Nil, Nil, Nil, "S", Nil, Nil)
	::csCdRequisicaoEmpresa := WSAdvValue(oResponse, "_SCDREQUISICAOEMPRESA", "string"  ,Nil, Nil, Nil, "S", Nil, Nil)
	::csCdUnidadeMedida     := WSAdvValue(oResponse, "_SCDUNIDADEMEDIDA"    , "string"  ,Nil, Nil, Nil, "S", Nil, Nil)
	::csCdUsuarioComprador  := WSAdvValue(oResponse, "_SCDUSUARIOCOMPRADOR" , "string"  ,Nil, Nil, Nil, "S", Nil, Nil)
	::csCdUsuarioResponsavel:= WSAdvValue(oResponse, "_SCDUSUARIORESPONSABEL","string"  ,Nil, Nil, Nil, "S", Nil, Nil)
	::csDsJustificativa     := WSAdvValue(oResponse, "_SDSJUSTIFICATIVA"    , "string"  ,Nil, Nil, Nil, "S", Nil, Nil)
	::csDsObservacao	    := WSAdvValue(oResponse, "_SDSOBSERVACAO"    	, "string"  ,Nil, Nil, Nil, "S", Nil, Nil)
	::csDsProdutoRequisicao := WSAdvValue(oResponse, "_SDSPRODUTOREQUISICAO", "string"  ,Nil, Nil, Nil, "S", Nil, Nil)
	::ctDtCriacao           := WSAdvValue(oResponse, "_TDTCRIACAO"          , "dateTime",Nil, Nil, Nil, "S", Nil, Nil)
	::ctDtEntrega           := WSAdvValue(oResponse, "_TDTENTREGA"          , "dateTime",Nil, Nil, Nil, "S", Nil, Nil)
	::ctDtLiberacao         := WSAdvValue(oResponse, "_TDTLIBERACAO"        , "dateTime",Nil, Nil, Nil, "S", Nil, Nil)
	::ctDtMoedaCotacao      := WSAdvValue(oResponse, "_TDTMOEDACOTACAO"     , "dateTime",Nil, Nil, Nil, "S", Nil, Nil)

Return


