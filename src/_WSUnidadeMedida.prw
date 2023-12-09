#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"

/*=================================================================================================================*\
|| ############################################################################################################### ||
||																	                                               ||
|| # WSDL Service WSUnidadeMedida																				 # ||
|| # WSDL Location: https://srm-hml.paradigmabs.com.br/cassi-hml/services/UnidadeMedida.svc?wsdl				 # ||
||																	                                               ||
|| # Data - 26/09/2019 																							 # ||
||																	                                               ||
|| # Desc: WebService de cadastro de Unidade de Medida.															 # ||
||																	                                               ||
|| # Obs: Alterações neste arquivo podem causar funcionamento incorreto.										 # ||
||																	                                               ||
|| ############################################################################################################### ||
\*=================================================================================================================*/
User Function _PHMQQGO ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSUnidadeMedida
------------------------------------------------------------------------------- */

WSCLIENT WSUnidadeMedida

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD ProcessarUnidadeMedida
	WSMETHOD RetornarUnidadeMedida
	WSMETHOD RetornarUnidadeMedidaAtiva
	WSMETHOD RetornarUnidadeMedidaSemDePara

	WSDATA   _URL                      AS String
	WSDATA   _CERT                     AS String
	WSDATA   _PRIVKEY                  AS String
	WSDATA   _PASSPHRASE               AS String
	WSDATA   _HEADOUT                  AS Array of String
	WSDATA   _COOKIES                  AS Array of String
	WSDATA   oWSlstUnidadeMedida       AS UnidadeMedida_ArrayOfUnidadeMedidaDTO
	WSDATA   oWSProcessarUnidadeMedidaResult AS UnidadeMedida_RetornoDTO
	WSDATA   csCdUnidadeMedidaErp      AS string
	WSDATA   oWSRetornarUnidadeMedidaResult AS UnidadeMedida_UnidadeMedidaDTO
	WSDATA   oWSRetornarUnidadeMedidaAtivaResult AS UnidadeMedida_RetornoListaUnidadeMedidaDTO
	WSDATA   csCdEmpresa               AS string
	WSDATA   oWSRetornarUnidadeMedidaSemDeParaResult AS UnidadeMedida_ArrayOfUnidadeMedidaDTO

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSUnidadeMedida
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.131227A-20190114 NG] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSUnidadeMedida
	::oWSlstUnidadeMedida := UnidadeMedida_ARRAYOFUNIDADEMEDIDADTO():New()
	::oWSProcessarUnidadeMedidaResult := UnidadeMedida_RETORNODTO():New()
	::oWSRetornarUnidadeMedidaResult := UnidadeMedida_UNIDADEMEDIDADTO():New()
	::oWSRetornarUnidadeMedidaAtivaResult := UnidadeMedida_RETORNOLISTAUNIDADEMEDIDADTO():New()
	::oWSRetornarUnidadeMedidaSemDeParaResult := UnidadeMedida_ARRAYOFUNIDADEMEDIDADTO():New()
Return

WSMETHOD RESET WSCLIENT WSUnidadeMedida
	::oWSlstUnidadeMedida := NIL 
	::oWSProcessarUnidadeMedidaResult := NIL 
	::csCdUnidadeMedidaErp := NIL 
	::oWSRetornarUnidadeMedidaResult := NIL 
	::oWSRetornarUnidadeMedidaAtivaResult := NIL 
	::csCdEmpresa        := NIL 
	::oWSRetornarUnidadeMedidaSemDeParaResult := NIL 
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSUnidadeMedida
Local oClone := WSUnidadeMedida():New()
	oClone:_URL          := ::_URL 
	oClone:_CERT         := ::_CERT 
	oClone:_PRIVKEY      := ::_PRIVKEY 
	oClone:_PASSPHRASE   := ::_PASSPHRASE 
	oClone:oWSlstUnidadeMedida :=  IIF(::oWSlstUnidadeMedida = NIL , NIL ,::oWSlstUnidadeMedida:Clone() )
	oClone:oWSProcessarUnidadeMedidaResult :=  IIF(::oWSProcessarUnidadeMedidaResult = NIL , NIL ,::oWSProcessarUnidadeMedidaResult:Clone() )
	oClone:csCdUnidadeMedidaErp := ::csCdUnidadeMedidaErp
	oClone:oWSRetornarUnidadeMedidaResult :=  IIF(::oWSRetornarUnidadeMedidaResult = NIL , NIL ,::oWSRetornarUnidadeMedidaResult:Clone() )
	oClone:oWSRetornarUnidadeMedidaAtivaResult :=  IIF(::oWSRetornarUnidadeMedidaAtivaResult = NIL , NIL ,::oWSRetornarUnidadeMedidaAtivaResult:Clone() )
	oClone:csCdEmpresa   := ::csCdEmpresa
	oClone:oWSRetornarUnidadeMedidaSemDeParaResult :=  IIF(::oWSRetornarUnidadeMedidaSemDeParaResult = NIL , NIL ,::oWSRetornarUnidadeMedidaSemDeParaResult:Clone() )
Return oClone

// WSDL Method ProcessarUnidadeMedida of Service WSUnidadeMedida

WSMETHOD ProcessarUnidadeMedida WSSEND oWSlstUnidadeMedida WSRECEIVE oWSProcessarUnidadeMedidaResult WSCLIENT WSUnidadeMedida
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ProcessarUnidadeMedida xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("lstUnidadeMedida", ::oWSlstUnidadeMedida, oWSlstUnidadeMedida , "ArrayOfUnidadeMedidaDTO", .F. , .F., 0 , "http://tempuri.org/", .F.,.F.) 
cSoap += "</ProcessarUnidadeMedida>"

Self:_HEADOUT := { "Authorization: Bearer " + U_NewToken() }
oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tempuri.org/IUnidadeMedida/ProcessarUnidadeMedida",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	Lower(AllTrim(GetMv("MV_XPARURL"))) + "/services/UnidadeMedida.svc")

::Init()
::oWSProcessarUnidadeMedidaResult:SoapRecv( WSAdvValue( oXmlRet,"_PROCESSARUNIDADEMEDIDARESPONSE:_PROCESSARUNIDADEMEDIDARESULT","RetornoDTO",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return {.T.,cSoap}
// Return .T.

// WSDL Method RetornarUnidadeMedida of Service WSUnidadeMedida

WSMETHOD RetornarUnidadeMedida WSSEND csCdUnidadeMedidaErp WSRECEIVE oWSRetornarUnidadeMedidaResult WSCLIENT WSUnidadeMedida
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<RetornarUnidadeMedida xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("sCdUnidadeMedidaErp", ::csCdUnidadeMedidaErp, csCdUnidadeMedidaErp , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</RetornarUnidadeMedida>"

Self:_HEADOUT := { "Authorization: Bearer " + U_NewToken() }
oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tempuri.org/IUnidadeMedida/RetornarUnidadeMedida",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	Lower(AllTrim(GetMv("MV_XPARURL"))) + "/services/UnidadeMedida.svc")

::Init()
::oWSRetornarUnidadeMedidaResult:SoapRecv( WSAdvValue( oXmlRet,"_RETORNARUNIDADEMEDIDARESPONSE:_RETORNARUNIDADEMEDIDARESULT","UnidadeMedidaDTO",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method RetornarUnidadeMedidaAtiva of Service WSUnidadeMedida

WSMETHOD RetornarUnidadeMedidaAtiva WSSEND NULLPARAM WSRECEIVE oWSRetornarUnidadeMedidaAtivaResult WSCLIENT WSUnidadeMedida
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<RetornarUnidadeMedidaAtiva xmlns="http://tempuri.org/">'
cSoap += "</RetornarUnidadeMedidaAtiva>"

Self:_HEADOUT := { "Authorization: Bearer " + U_NewToken() }
oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tempuri.org/IUnidadeMedida/RetornarUnidadeMedidaAtiva",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	Lower(AllTrim(GetMv("MV_XPARURL"))) + "/services/UnidadeMedida.svc")

::Init()
::oWSRetornarUnidadeMedidaAtivaResult:SoapRecv( WSAdvValue( oXmlRet,"_RETORNARUNIDADEMEDIDAATIVARESPONSE:_RETORNARUNIDADEMEDIDAATIVARESULT","RetornoListaUnidadeMedidaDTO",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method RetornarUnidadeMedidaSemDePara of Service WSUnidadeMedida

WSMETHOD RetornarUnidadeMedidaSemDePara WSSEND csCdEmpresa WSRECEIVE oWSRetornarUnidadeMedidaSemDeParaResult WSCLIENT WSUnidadeMedida
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<RetornarUnidadeMedidaSemDePara xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("sCdEmpresa", ::csCdEmpresa, csCdEmpresa , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</RetornarUnidadeMedidaSemDePara>"

Self:_HEADOUT := { "Authorization: Bearer " + U_NewToken() }
oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tempuri.org/IUnidadeMedida/RetornarUnidadeMedidaSemDePara",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	Lower(AllTrim(GetMv("MV_XPARURL"))) + "/services/UnidadeMedida.svc")

::Init()
::oWSRetornarUnidadeMedidaSemDeParaResult:SoapRecv( WSAdvValue( oXmlRet,"_RETORNARUNIDADEMEDIDASEMDEPARARESPONSE:_RETORNARUNIDADEMEDIDASEMDEPARARESULT","ArrayOfUnidadeMedidaDTO",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.


// WSDL Data Structure ArrayOfUnidadeMedidaDTO

WSSTRUCT UnidadeMedida_ArrayOfUnidadeMedidaDTO
	WSDATA   oWSUnidadeMedidaDTO       AS UnidadeMedida_UnidadeMedidaDTO OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT UnidadeMedida_ArrayOfUnidadeMedidaDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT UnidadeMedida_ArrayOfUnidadeMedidaDTO
	::oWSUnidadeMedidaDTO  := {} // Array Of  UnidadeMedida_UNIDADEMEDIDADTO():New()
Return

WSMETHOD CLONE WSCLIENT UnidadeMedida_ArrayOfUnidadeMedidaDTO
	Local oClone := UnidadeMedida_ArrayOfUnidadeMedidaDTO():NEW()
	oClone:oWSUnidadeMedidaDTO := NIL
	If ::oWSUnidadeMedidaDTO <> NIL 
		oClone:oWSUnidadeMedidaDTO := {}
		aEval( ::oWSUnidadeMedidaDTO , { |x| aadd( oClone:oWSUnidadeMedidaDTO , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT UnidadeMedida_ArrayOfUnidadeMedidaDTO
	Local cSoap := ""
	aEval( ::oWSUnidadeMedidaDTO , {|x| cSoap := cSoap  +  WSSoapValue("UnidadeMedidaDTO", x , x , "UnidadeMedidaDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.)  } ) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT UnidadeMedida_ArrayOfUnidadeMedidaDTO
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_UNIDADEMEDIDADTO","UnidadeMedidaDTO",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSUnidadeMedidaDTO , UnidadeMedida_UnidadeMedidaDTO():New() )
			::oWSUnidadeMedidaDTO[len(::oWSUnidadeMedidaDTO)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure RetornoDTO

WSSTRUCT UnidadeMedida_RetornoDTO
	WSDATA   oWSlstWbtLogDTO           AS UnidadeMedida_ArrayOfWbtLogDTO OPTIONAL
	WSDATA   nnIdRetorno               AS long OPTIONAL
	WSDATA   csNrToken                 AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT UnidadeMedida_RetornoDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT UnidadeMedida_RetornoDTO
Return

WSMETHOD CLONE WSCLIENT UnidadeMedida_RetornoDTO
	Local oClone := UnidadeMedida_RetornoDTO():NEW()
	oClone:oWSlstWbtLogDTO      := IIF(::oWSlstWbtLogDTO = NIL , NIL , ::oWSlstWbtLogDTO:Clone() )
	oClone:nnIdRetorno          := ::nnIdRetorno
	oClone:csNrToken            := ::csNrToken
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT UnidadeMedida_RetornoDTO
	Local oNode1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_LSTWBTLOGDTO","ArrayOfWbtLogDTO",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode1 != NIL
		::oWSlstWbtLogDTO := UnidadeMedida_ArrayOfWbtLogDTO():New()
		::oWSlstWbtLogDTO:SoapRecv(oNode1)
	EndIf
	::nnIdRetorno        :=  WSAdvValue( oResponse,"_NIDRETORNO","long",NIL,NIL,NIL,"N",NIL,NIL) 
	::csNrToken          :=  WSAdvValue( oResponse,"_SNRTOKEN","string",NIL,NIL,NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure UnidadeMedidaDTO

WSSTRUCT UnidadeMedida_UnidadeMedidaDTO
	WSDATA   nbFlStatus                AS int OPTIONAL
	WSDATA   oWSlstUnidadeMedidaIdioma AS UnidadeMedida_ArrayOfUnidadeMedidaIdiomaDTO OPTIONAL
	WSDATA   csCdEmpresa               AS string OPTIONAL
	WSDATA   csCdUnidadeMedida         AS string OPTIONAL
	WSDATA   csDsUnidadeMedida         AS string OPTIONAL
	WSDATA   csSgUnidadeMedida         AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT UnidadeMedida_UnidadeMedidaDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT UnidadeMedida_UnidadeMedidaDTO
Return

WSMETHOD CLONE WSCLIENT UnidadeMedida_UnidadeMedidaDTO
	Local oClone := UnidadeMedida_UnidadeMedidaDTO():NEW()
	oClone:nbFlStatus           := ::nbFlStatus
	oClone:oWSlstUnidadeMedidaIdioma := IIF(::oWSlstUnidadeMedidaIdioma = NIL , NIL , ::oWSlstUnidadeMedidaIdioma:Clone() )
	oClone:csCdEmpresa          := ::csCdEmpresa
	oClone:csCdUnidadeMedida    := ::csCdUnidadeMedida
	oClone:csDsUnidadeMedida    := ::csDsUnidadeMedida
	oClone:csSgUnidadeMedida    := ::csSgUnidadeMedida
Return oClone

WSMETHOD SOAPSEND WSCLIENT UnidadeMedida_UnidadeMedidaDTO
	Local cSoap := ""
	cSoap += WSSoapValue("bFlStatus", ::nbFlStatus, ::nbFlStatus , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("lstUnidadeMedidaIdioma", ::oWSlstUnidadeMedidaIdioma, ::oWSlstUnidadeMedidaIdioma , "ArrayOfUnidadeMedidaIdiomaDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdEmpresa", ::csCdEmpresa, ::csCdEmpresa , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdUnidadeMedida", ::csCdUnidadeMedida, ::csCdUnidadeMedida , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sDsUnidadeMedida", ::csDsUnidadeMedida, ::csDsUnidadeMedida , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sSgUnidadeMedida", ::csSgUnidadeMedida, ::csSgUnidadeMedida , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT UnidadeMedida_UnidadeMedidaDTO
	Local oNode2
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::nbFlStatus         :=  WSAdvValue( oResponse,"_BFLSTATUS","int",NIL,NIL,NIL,"N",NIL,NIL) 
	oNode2 :=  WSAdvValue( oResponse,"_LSTUNIDADEMEDIDAIDIOMA","ArrayOfUnidadeMedidaIdiomaDTO",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode2 != NIL
		::oWSlstUnidadeMedidaIdioma := UnidadeMedida_ArrayOfUnidadeMedidaIdiomaDTO():New()
		::oWSlstUnidadeMedidaIdioma:SoapRecv(oNode2)
	EndIf
	::csCdEmpresa        :=  WSAdvValue( oResponse,"_SCDEMPRESA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdUnidadeMedida  :=  WSAdvValue( oResponse,"_SCDUNIDADEMEDIDA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csDsUnidadeMedida  :=  WSAdvValue( oResponse,"_SDSUNIDADEMEDIDA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csSgUnidadeMedida  :=  WSAdvValue( oResponse,"_SSGUNIDADEMEDIDA","string",NIL,NIL,NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure RetornoListaUnidadeMedidaDTO

WSSTRUCT UnidadeMedida_RetornoListaUnidadeMedidaDTO
	WSDATA   oWSlstObjetoRetorno       AS UnidadeMedida_ArrayOfUnidadeMedidaDTO OPTIONAL
	WSDATA   nnQtRegistrosRetorno      AS int OPTIONAL
	WSDATA   nnQtRegistrosTotal        AS int OPTIONAL
	WSDATA   oWSoRetornoDTO            AS UnidadeMedida_RetornoDTO OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT UnidadeMedida_RetornoListaUnidadeMedidaDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT UnidadeMedida_RetornoListaUnidadeMedidaDTO
Return

WSMETHOD CLONE WSCLIENT UnidadeMedida_RetornoListaUnidadeMedidaDTO
	Local oClone := UnidadeMedida_RetornoListaUnidadeMedidaDTO():NEW()
	oClone:oWSlstObjetoRetorno  := IIF(::oWSlstObjetoRetorno = NIL , NIL , ::oWSlstObjetoRetorno:Clone() )
	oClone:nnQtRegistrosRetorno := ::nnQtRegistrosRetorno
	oClone:nnQtRegistrosTotal   := ::nnQtRegistrosTotal
	oClone:oWSoRetornoDTO       := IIF(::oWSoRetornoDTO = NIL , NIL , ::oWSoRetornoDTO:Clone() )
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT UnidadeMedida_RetornoListaUnidadeMedidaDTO
	Local oNode1
	Local oNode4
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_LSTOBJETORETORNO","ArrayOfUnidadeMedidaDTO",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode1 != NIL
		::oWSlstObjetoRetorno := UnidadeMedida_ArrayOfUnidadeMedidaDTO():New()
		::oWSlstObjetoRetorno:SoapRecv(oNode1)
	EndIf
	::nnQtRegistrosRetorno :=  WSAdvValue( oResponse,"_NQTREGISTROSRETORNO","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::nnQtRegistrosTotal :=  WSAdvValue( oResponse,"_NQTREGISTROSTOTAL","int",NIL,NIL,NIL,"N",NIL,NIL) 
	oNode4 :=  WSAdvValue( oResponse,"_ORETORNODTO","RetornoDTO",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode4 != NIL
		::oWSoRetornoDTO := UnidadeMedida_RetornoDTO():New()
		::oWSoRetornoDTO:SoapRecv(oNode4)
	EndIf
Return

// WSDL Data Structure ArrayOfWbtLogDTO

WSSTRUCT UnidadeMedida_ArrayOfWbtLogDTO
	WSDATA   oWSWbtLogDTO              AS UnidadeMedida_WbtLogDTO OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT UnidadeMedida_ArrayOfWbtLogDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT UnidadeMedida_ArrayOfWbtLogDTO
	::oWSWbtLogDTO         := {} // Array Of  UnidadeMedida_WBTLOGDTO():New()
Return

WSMETHOD CLONE WSCLIENT UnidadeMedida_ArrayOfWbtLogDTO
	Local oClone := UnidadeMedida_ArrayOfWbtLogDTO():NEW()
	oClone:oWSWbtLogDTO := NIL
	If ::oWSWbtLogDTO <> NIL 
		oClone:oWSWbtLogDTO := {}
		aEval( ::oWSWbtLogDTO , { |x| aadd( oClone:oWSWbtLogDTO , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT UnidadeMedida_ArrayOfWbtLogDTO
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_WBTLOGDTO","WbtLogDTO",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSWbtLogDTO , UnidadeMedida_WbtLogDTO():New() )
			::oWSWbtLogDTO[len(::oWSWbtLogDTO)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure ArrayOfUnidadeMedidaIdiomaDTO

WSSTRUCT UnidadeMedida_ArrayOfUnidadeMedidaIdiomaDTO
	WSDATA   oWSUnidadeMedidaIdiomaDTO AS UnidadeMedida_UnidadeMedidaIdiomaDTO OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT UnidadeMedida_ArrayOfUnidadeMedidaIdiomaDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT UnidadeMedida_ArrayOfUnidadeMedidaIdiomaDTO
	::oWSUnidadeMedidaIdiomaDTO := {} // Array Of  UnidadeMedida_UNIDADEMEDIDAIDIOMADTO():New()
Return

WSMETHOD CLONE WSCLIENT UnidadeMedida_ArrayOfUnidadeMedidaIdiomaDTO
	Local oClone := UnidadeMedida_ArrayOfUnidadeMedidaIdiomaDTO():NEW()
	oClone:oWSUnidadeMedidaIdiomaDTO := NIL
	If ::oWSUnidadeMedidaIdiomaDTO <> NIL 
		oClone:oWSUnidadeMedidaIdiomaDTO := {}
		aEval( ::oWSUnidadeMedidaIdiomaDTO , { |x| aadd( oClone:oWSUnidadeMedidaIdiomaDTO , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT UnidadeMedida_ArrayOfUnidadeMedidaIdiomaDTO
	Local cSoap := ""
	aEval( ::oWSUnidadeMedidaIdiomaDTO , {|x| cSoap := cSoap  +  WSSoapValue("UnidadeMedidaIdiomaDTO", x , x , "UnidadeMedidaIdiomaDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.)  } ) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT UnidadeMedida_ArrayOfUnidadeMedidaIdiomaDTO
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_UNIDADEMEDIDAIDIOMADTO","UnidadeMedidaIdiomaDTO",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSUnidadeMedidaIdiomaDTO , UnidadeMedida_UnidadeMedidaIdiomaDTO():New() )
			::oWSUnidadeMedidaIdiomaDTO[len(::oWSUnidadeMedidaIdiomaDTO)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure WbtLogDTO

WSSTRUCT UnidadeMedida_WbtLogDTO
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

WSMETHOD NEW WSCLIENT UnidadeMedida_WbtLogDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT UnidadeMedida_WbtLogDTO
Return

WSMETHOD CLONE WSCLIENT UnidadeMedida_WbtLogDTO
	Local oClone := UnidadeMedida_WbtLogDTO():NEW()
	oClone:nnCdLog              := ::nnCdLog
	oClone:nnIdRetorno          := ::nnIdRetorno
	oClone:csCdOrigem           := ::csCdOrigem
	oClone:csDsLog              := ::csDsLog
	oClone:csDsTipoDocumento    := ::csDsTipoDocumento
	oClone:csNrToken            := ::csNrToken
	oClone:ctDtLog              := ::ctDtLog
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT UnidadeMedida_WbtLogDTO
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

// WSDL Data Structure UnidadeMedidaIdiomaDTO

WSSTRUCT UnidadeMedida_UnidadeMedidaIdiomaDTO
	WSDATA   csDsUnidadeMedida         AS string OPTIONAL
	WSDATA   csSgUnidadeMedida         AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT UnidadeMedida_UnidadeMedidaIdiomaDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT UnidadeMedida_UnidadeMedidaIdiomaDTO
Return

WSMETHOD CLONE WSCLIENT UnidadeMedida_UnidadeMedidaIdiomaDTO
	Local oClone := UnidadeMedida_UnidadeMedidaIdiomaDTO():NEW()
	oClone:csDsUnidadeMedida    := ::csDsUnidadeMedida
	oClone:csSgUnidadeMedida    := ::csSgUnidadeMedida
Return oClone

WSMETHOD SOAPSEND WSCLIENT UnidadeMedida_UnidadeMedidaIdiomaDTO
	Local cSoap := ""
	cSoap += WSSoapValue("sDsUnidadeMedida", ::csDsUnidadeMedida, ::csDsUnidadeMedida , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sSgUnidadeMedida", ::csSgUnidadeMedida, ::csSgUnidadeMedida , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT UnidadeMedida_UnidadeMedidaIdiomaDTO
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::csDsUnidadeMedida  :=  WSAdvValue( oResponse,"_SDSUNIDADEMEDIDA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csSgUnidadeMedida  :=  WSAdvValue( oResponse,"_SSGUNIDADEMEDIDA","string",NIL,NIL,NIL,"S",NIL,NIL) 
Return


