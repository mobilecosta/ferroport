#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"

/*=================================================================================================================*\
|| ############################################################################################################### ||
||																	                                               ||
|| # WSDL Service Centro de Custo																				 # ||
|| # WSDL Location: https://srm-hml.paradigmabs.com.br/cassi-hml/services/CentroCusto.svc?wsdl					 # ||
||																	                                               ||
|| # Data - 26/09/2019 																							 # ||
||																	                                               ||
|| # Desc: WebService de cadastro de Centro de Custo.															 # ||
||																	                                               ||
|| # Obs: Alterações neste arquivo podem causar funcionamento incorreto.										 # ||
||																	                                               ||
|| ############################################################################################################### ||
\*=================================================================================================================*/
User Function _XSGFRWU ; Return  // "dummy" function - Internal Use 

/*=================================================================================================================*\
|| # WSDL Service: WSCentroCusto	                                   	                        	             # ||
\*=================================================================================================================*/
WSCLIENT WSCentroCusto

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD ProcessarCentroCusto
	WSMETHOD RetornarCentroCustoPorDepartamento
	WSMETHOD ProcessarInativarCentroCustoDePara

	WSDATA   _URL                      AS String
	WSDATA   _CERT                     AS String
	WSDATA   _PRIVKEY                  AS String
	WSDATA   _PASSPHRASE               AS String
	WSDATA   _HEADOUT                  AS Array of String
	WSDATA   _COOKIES                  AS Array of String
	WSDATA   oWSlstCentroCusto         AS CentroCusto_ArrayOfCentroCustoDTO
	WSDATA   oWSProcessarCentroCustoResult AS CentroCusto_RetornoDTO
	WSDATA   csCdDepartamento          AS string
	WSDATA   csFlAtivo                 AS string
	WSDATA   oWSRetornarCentroCustoPorDepartamentoResult AS CentroCusto_RetornoListaCentroCustoDTO
	WSDATA   oWSlstCentroCustoInativarDTO AS CentroCusto_ArrayOfCentroCustoDTO
	WSDATA   oWSProcessarInativarCentroCustoDeParaResult AS CentroCusto_RetornoDTO

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSCentroCusto
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.131227A-20190114 NG] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSCentroCusto
	::oWSlstCentroCusto  := CentroCusto_ARRAYOFCENTROCUSTODTO():New()
	::oWSProcessarCentroCustoResult := CentroCusto_RETORNODTO():New()
	::oWSRetornarCentroCustoPorDepartamentoResult := CentroCusto_RETORNOLISTACENTROCUSTODTO():New()
	::oWSlstCentroCustoInativarDTO := CentroCusto_ARRAYOFCENTROCUSTODTO():New()
	::oWSProcessarInativarCentroCustoDeParaResult := CentroCusto_RETORNODTO():New()
Return

WSMETHOD RESET WSCLIENT WSCentroCusto
	::oWSlstCentroCusto  := NIL 
	::oWSProcessarCentroCustoResult := NIL 
	::csCdDepartamento   := NIL 
	::csFlAtivo          := NIL 
	::oWSRetornarCentroCustoPorDepartamentoResult := NIL 
	::oWSlstCentroCustoInativarDTO := NIL 
	::oWSProcessarInativarCentroCustoDeParaResult := NIL 
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSCentroCusto
Local oClone := WSCentroCusto():New()
	oClone:_URL          := ::_URL 
	oClone:_CERT         := ::_CERT 
	oClone:_PRIVKEY      := ::_PRIVKEY 
	oClone:_PASSPHRASE   := ::_PASSPHRASE 
	oClone:oWSlstCentroCusto :=  IIF(::oWSlstCentroCusto = NIL , NIL ,::oWSlstCentroCusto:Clone() )
	oClone:oWSProcessarCentroCustoResult :=  IIF(::oWSProcessarCentroCustoResult = NIL , NIL ,::oWSProcessarCentroCustoResult:Clone() )
	oClone:csCdDepartamento := ::csCdDepartamento
	oClone:csFlAtivo     := ::csFlAtivo
	oClone:oWSRetornarCentroCustoPorDepartamentoResult :=  IIF(::oWSRetornarCentroCustoPorDepartamentoResult = NIL , NIL ,::oWSRetornarCentroCustoPorDepartamentoResult:Clone() )
	oClone:oWSlstCentroCustoInativarDTO :=  IIF(::oWSlstCentroCustoInativarDTO = NIL , NIL ,::oWSlstCentroCustoInativarDTO:Clone() )
	oClone:oWSProcessarInativarCentroCustoDeParaResult :=  IIF(::oWSProcessarInativarCentroCustoDeParaResult = NIL , NIL ,::oWSProcessarInativarCentroCustoDeParaResult:Clone() )
Return oClone

/*=================================================================================================================*\
|| # WSDL Method: ProcessarCentroCusto	                                   	                        	         # ||
\*=================================================================================================================*/
WSMETHOD ProcessarCentroCusto WSSEND oWSlstCentroCusto WSRECEIVE oWSProcessarCentroCustoResult WSCLIENT WSCentroCusto
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ProcessarCentroCusto xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("lstCentroCusto", ::oWSlstCentroCusto, oWSlstCentroCusto , "ArrayOfCentroCustoDTO", .F. , .F., 0 , "http://tempuri.org/", .F.,.F.) 
cSoap += "</ProcessarCentroCusto>"

Self:_HEADOUT := { "Authorization: Bearer " + U_NewToken() }
oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tempuri.org/ICentroCusto/ProcessarCentroCusto",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	Lower(AllTrim(GetMv("MV_XPARURL"))) + "/services/CentroCusto.svc")

::Init()
::oWSProcessarCentroCustoResult:SoapRecv( WSAdvValue( oXmlRet,"_PROCESSARCENTROCUSTORESPONSE:_PROCESSARCENTROCUSTORESULT","RetornoDTO",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return {.T.,cSoap}

/*=================================================================================================================*\
|| # WSDL Method: RetornarCentroCustoPorDepartamento															 # ||
\*=================================================================================================================*/
WSMETHOD RetornarCentroCustoPorDepartamento WSSEND csCdDepartamento,csFlAtivo WSRECEIVE oWSRetornarCentroCustoPorDepartamentoResult WSCLIENT WSCentroCusto
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<RetornarCentroCustoPorDepartamento xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("sCdDepartamento", ::csCdDepartamento, csCdDepartamento , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("sFlAtivo", ::csFlAtivo, csFlAtivo , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</RetornarCentroCustoPorDepartamento>"

Self:_HEADOUT := { "Authorization: Bearer " + U_NewToken() }
oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tempuri.org/ICentroCusto/RetornarCentroCustoPorDepartamento",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	Lower(AllTrim(GetMv("MV_XPARURL"))) + "/services/CentroCusto.svc")

::Init()
::oWSRetornarCentroCustoPorDepartamentoResult:SoapRecv( WSAdvValue( oXmlRet,"_RETORNARCENTROCUSTOPORDEPARTAMENTORESPONSE:_RETORNARCENTROCUSTOPORDEPARTAMENTORESULT","RetornoListaCentroCustoDTO",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

/*=================================================================================================================*\
|| # WSDL Method: ProcessarInativarCentroCustoDePara															 # ||
\*=================================================================================================================*/
WSMETHOD ProcessarInativarCentroCustoDePara WSSEND oWSlstCentroCustoInativarDTO WSRECEIVE oWSProcessarInativarCentroCustoDeParaResult WSCLIENT WSCentroCusto
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ProcessarInativarCentroCustoDePara xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("lstCentroCustoInativarDTO", ::oWSlstCentroCustoInativarDTO, oWSlstCentroCustoInativarDTO , "ArrayOfCentroCustoDTO", .F. , .F., 0 , "http://tempuri.org/", .F.,.F.) 
cSoap += "</ProcessarInativarCentroCustoDePara>"

Self:_HEADOUT := { "Authorization: Bearer " + U_NewToken() }
oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tempuri.org/ICentroCusto/ProcessarInativarCentroCustoDePara",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	Lower(AllTrim(GetMv("MV_XPARURL"))) + "/services/CentroCusto.svc")

::Init()
::oWSProcessarInativarCentroCustoDeParaResult:SoapRecv( WSAdvValue( oXmlRet,"_PROCESSARINATIVARCENTROCUSTODEPARARESPONSE:_PROCESSARINATIVARCENTROCUSTODEPARARESULT","RetornoDTO",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

/*=================================================================================================================*\
|| # WSDL Structure: CentroCusto_RetornoDTO																		 # ||
\*=================================================================================================================*/
WSSTRUCT CentroCusto_RetornoDTO
	WSDATA   oWSlstWbtLogDTO           AS CentroCusto_ArrayOfWbtLogDTO OPTIONAL
	WSDATA   nnIdRetorno               AS long OPTIONAL
	WSDATA   csNrToken                 AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT CentroCusto_RetornoDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT CentroCusto_RetornoDTO
Return

WSMETHOD CLONE WSCLIENT CentroCusto_RetornoDTO
	Local oClone := CentroCusto_RetornoDTO():NEW()
	oClone:oWSlstWbtLogDTO      := IIF(::oWSlstWbtLogDTO = NIL , NIL , ::oWSlstWbtLogDTO:Clone() )
	oClone:nnIdRetorno          := ::nnIdRetorno
	oClone:csNrToken            := ::csNrToken
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT CentroCusto_RetornoDTO
	Local oNode1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_LSTWBTLOGDTO","ArrayOfWbtLogDTO",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode1 != NIL
		::oWSlstWbtLogDTO := CentroCusto_ArrayOfWbtLogDTO():New()
		::oWSlstWbtLogDTO:SoapRecv(oNode1)
	EndIf
	::nnIdRetorno        :=  WSAdvValue( oResponse,"_NIDRETORNO","long",NIL,NIL,NIL,"N",NIL,NIL) 
	::csNrToken          :=  WSAdvValue( oResponse,"_SNRTOKEN","string",NIL,NIL,NIL,"S",NIL,NIL) 
Return

/*=================================================================================================================*\
|| # WSDL Structure: RetornoListaCentroCustoDTO																	 # ||
\*=================================================================================================================*/
WSSTRUCT CentroCusto_RetornoListaCentroCustoDTO
	WSDATA   oWSlstObjetoRetorno       AS CentroCusto_ArrayOfCentroCustoDTO OPTIONAL
	WSDATA   nnQtRegistrosRetorno      AS int OPTIONAL
	WSDATA   nnQtRegistrosTotal        AS int OPTIONAL
	WSDATA   oWSoRetornoDTO            AS CentroCusto_RetornoDTO OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT CentroCusto_RetornoListaCentroCustoDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT CentroCusto_RetornoListaCentroCustoDTO
Return

WSMETHOD CLONE WSCLIENT CentroCusto_RetornoListaCentroCustoDTO
	Local oClone := CentroCusto_RetornoListaCentroCustoDTO():NEW()
	oClone:oWSlstObjetoRetorno  := IIF(::oWSlstObjetoRetorno = NIL , NIL , ::oWSlstObjetoRetorno:Clone() )
	oClone:nnQtRegistrosRetorno := ::nnQtRegistrosRetorno
	oClone:nnQtRegistrosTotal   := ::nnQtRegistrosTotal
	oClone:oWSoRetornoDTO       := IIF(::oWSoRetornoDTO = NIL , NIL , ::oWSoRetornoDTO:Clone() )
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT CentroCusto_RetornoListaCentroCustoDTO
	Local oNode1
	Local oNode4
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_LSTOBJETORETORNO","ArrayOfCentroCustoDTO",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode1 != NIL
		::oWSlstObjetoRetorno := CentroCusto_ArrayOfCentroCustoDTO():New()
		::oWSlstObjetoRetorno:SoapRecv(oNode1)
	EndIf
	::nnQtRegistrosRetorno :=  WSAdvValue( oResponse,"_NQTREGISTROSRETORNO","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::nnQtRegistrosTotal :=  WSAdvValue( oResponse,"_NQTREGISTROSTOTAL","int",NIL,NIL,NIL,"N",NIL,NIL) 
	oNode4 :=  WSAdvValue( oResponse,"_ORETORNODTO","RetornoDTO",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode4 != NIL
		::oWSoRetornoDTO := CentroCusto_RetornoDTO():New()
		::oWSoRetornoDTO:SoapRecv(oNode4)
	EndIf
Return

/*=================================================================================================================*\
|| # WSDL Structure: CentroCusto_ArrayOfCentroCustoDTO															 # ||
\*=================================================================================================================*/
WSSTRUCT CentroCusto_ArrayOfCentroCustoDTO
	WSDATA   oWSCentroCustoDTO         AS CentroCusto_CentroCustoDTO OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT CentroCusto_ArrayOfCentroCustoDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT CentroCusto_ArrayOfCentroCustoDTO
	::oWSCentroCustoDTO    := {} // Array Of  CentroCusto_CENTROCUSTODTO():New()
Return

WSMETHOD CLONE WSCLIENT CentroCusto_ArrayOfCentroCustoDTO
	Local oClone := CentroCusto_ArrayOfCentroCustoDTO():NEW()
	oClone:oWSCentroCustoDTO := NIL
	If ::oWSCentroCustoDTO <> NIL 
		oClone:oWSCentroCustoDTO := {}
		aEval( ::oWSCentroCustoDTO , { |x| aadd( oClone:oWSCentroCustoDTO , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT CentroCusto_ArrayOfCentroCustoDTO
	Local cSoap := ""
	aEval( ::oWSCentroCustoDTO , {|x| cSoap := cSoap  +  WSSoapValue("CentroCustoDTO", x , x , "CentroCustoDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.)  } ) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT CentroCusto_ArrayOfCentroCustoDTO
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_CENTROCUSTODTO","CentroCustoDTO",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSCentroCustoDTO , CentroCusto_CentroCustoDTO():New() )
			::oWSCentroCustoDTO[len(::oWSCentroCustoDTO)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

/*=================================================================================================================*\
|| # WSDL Structure: CentroCusto_CentroCustoDTO																	 # ||
\*=================================================================================================================*/
WSSTRUCT CentroCusto_CentroCustoDTO
	WSDATA   nbFlAtivo                 AS int OPTIONAL
	WSDATA   oWSlstCentroCustoIdioma   AS CentroCusto_ArrayOfCentroCustoIdiomaDTO OPTIONAL
	WSDATA   csCdCentroCusto           AS string OPTIONAL
	WSDATA   csCdCentroCustoPai        AS string OPTIONAL
	WSDATA   csCdEmpresa               AS string OPTIONAL
	WSDATA   csDsCentroCusto           AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT CentroCusto_CentroCustoDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT CentroCusto_CentroCustoDTO
Return

WSMETHOD CLONE WSCLIENT CentroCusto_CentroCustoDTO
	Local oClone := CentroCusto_CentroCustoDTO():NEW()
	oClone:nbFlAtivo            := ::nbFlAtivo
	oClone:oWSlstCentroCustoIdioma := IIF(::oWSlstCentroCustoIdioma = NIL , NIL , ::oWSlstCentroCustoIdioma:Clone() )
	oClone:csCdCentroCusto      := ::csCdCentroCusto
	oClone:csCdCentroCustoPai   := ::csCdCentroCustoPai
	oClone:csCdEmpresa          := ::csCdEmpresa
	oClone:csDsCentroCusto      := ::csDsCentroCusto
Return oClone

WSMETHOD SOAPSEND WSCLIENT CentroCusto_CentroCustoDTO
	Local cSoap := ""
	cSoap += WSSoapValue("bFlAtivo", ::nbFlAtivo, ::nbFlAtivo , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("lstCentroCustoIdioma", ::oWSlstCentroCustoIdioma, ::oWSlstCentroCustoIdioma , "ArrayOfCentroCustoIdiomaDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdCentroCusto", ::csCdCentroCusto, ::csCdCentroCusto , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdCentroCustoPai", ::csCdCentroCustoPai, ::csCdCentroCustoPai , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdEmpresa", ::csCdEmpresa, ::csCdEmpresa , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sDsCentroCusto", ::csDsCentroCusto, ::csDsCentroCusto , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT CentroCusto_CentroCustoDTO
	Local oNode2
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::nbFlAtivo          :=  WSAdvValue( oResponse,"_BFLATIVO","int",NIL,NIL,NIL,"N",NIL,NIL) 
	oNode2 :=  WSAdvValue( oResponse,"_LSTCENTROCUSTOIDIOMA","ArrayOfCentroCustoIdiomaDTO",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode2 != NIL
		::oWSlstCentroCustoIdioma := CentroCusto_ArrayOfCentroCustoIdiomaDTO():New()
		::oWSlstCentroCustoIdioma:SoapRecv(oNode2)
	EndIf
	::csCdCentroCusto    :=  WSAdvValue( oResponse,"_SCDCENTROCUSTO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdCentroCustoPai :=  WSAdvValue( oResponse,"_SCDCENTROCUSTOPAI","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdEmpresa        :=  WSAdvValue( oResponse,"_SCDEMPRESA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csDsCentroCusto    :=  WSAdvValue( oResponse,"_SDSCENTROCUSTO","string",NIL,NIL,NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure ArrayOfWbtLogDTO

WSSTRUCT CentroCusto_ArrayOfWbtLogDTO
	WSDATA   oWSWbtLogDTO              AS CentroCusto_WbtLogDTO OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT CentroCusto_ArrayOfWbtLogDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT CentroCusto_ArrayOfWbtLogDTO
	::oWSWbtLogDTO         := {} // Array Of  CentroCusto_WBTLOGDTO():New()
Return

WSMETHOD CLONE WSCLIENT CentroCusto_ArrayOfWbtLogDTO
	Local oClone := CentroCusto_ArrayOfWbtLogDTO():NEW()
	oClone:oWSWbtLogDTO := NIL
	If ::oWSWbtLogDTO <> NIL 
		oClone:oWSWbtLogDTO := {}
		aEval( ::oWSWbtLogDTO , { |x| aadd( oClone:oWSWbtLogDTO , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT CentroCusto_ArrayOfWbtLogDTO
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_WBTLOGDTO","WbtLogDTO",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSWbtLogDTO , CentroCusto_WbtLogDTO():New() )
			::oWSWbtLogDTO[len(::oWSWbtLogDTO)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure ArrayOfCentroCustoIdiomaDTO

WSSTRUCT CentroCusto_ArrayOfCentroCustoIdiomaDTO
	WSDATA   oWSCentroCustoIdiomaDTO   AS CentroCusto_CentroCustoIdiomaDTO OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT CentroCusto_ArrayOfCentroCustoIdiomaDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT CentroCusto_ArrayOfCentroCustoIdiomaDTO
	::oWSCentroCustoIdiomaDTO := {} // Array Of  CentroCusto_CENTROCUSTOIDIOMADTO():New()
Return

WSMETHOD CLONE WSCLIENT CentroCusto_ArrayOfCentroCustoIdiomaDTO
	Local oClone := CentroCusto_ArrayOfCentroCustoIdiomaDTO():NEW()
	oClone:oWSCentroCustoIdiomaDTO := NIL
	If ::oWSCentroCustoIdiomaDTO <> NIL 
		oClone:oWSCentroCustoIdiomaDTO := {}
		aEval( ::oWSCentroCustoIdiomaDTO , { |x| aadd( oClone:oWSCentroCustoIdiomaDTO , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT CentroCusto_ArrayOfCentroCustoIdiomaDTO
	Local cSoap := ""
	aEval( ::oWSCentroCustoIdiomaDTO , {|x| cSoap := cSoap  +  WSSoapValue("CentroCustoIdiomaDTO", x , x , "CentroCustoIdiomaDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.)  } ) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT CentroCusto_ArrayOfCentroCustoIdiomaDTO
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_CENTROCUSTOIDIOMADTO","CentroCustoIdiomaDTO",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSCentroCustoIdiomaDTO , CentroCusto_CentroCustoIdiomaDTO():New() )
			::oWSCentroCustoIdiomaDTO[len(::oWSCentroCustoIdiomaDTO)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure WbtLogDTO

WSSTRUCT CentroCusto_WbtLogDTO
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

WSMETHOD NEW WSCLIENT CentroCusto_WbtLogDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT CentroCusto_WbtLogDTO
Return

WSMETHOD CLONE WSCLIENT CentroCusto_WbtLogDTO
	Local oClone := CentroCusto_WbtLogDTO():NEW()
	oClone:nnCdLog              := ::nnCdLog
	oClone:nnIdRetorno          := ::nnIdRetorno
	oClone:csCdOrigem           := ::csCdOrigem
	oClone:csDsLog              := ::csDsLog
	oClone:csDsTipoDocumento    := ::csDsTipoDocumento
	oClone:csNrToken            := ::csNrToken
	oClone:ctDtLog              := ::ctDtLog
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT CentroCusto_WbtLogDTO
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

// WSDL Data Structure CentroCustoIdiomaDTO

WSSTRUCT CentroCusto_CentroCustoIdiomaDTO
	WSDATA   csDsCentroCusto           AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT CentroCusto_CentroCustoIdiomaDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT CentroCusto_CentroCustoIdiomaDTO
Return

WSMETHOD CLONE WSCLIENT CentroCusto_CentroCustoIdiomaDTO
	Local oClone := CentroCusto_CentroCustoIdiomaDTO():NEW()
	oClone:csDsCentroCusto      := ::csDsCentroCusto
Return oClone

WSMETHOD SOAPSEND WSCLIENT CentroCusto_CentroCustoIdiomaDTO
	Local cSoap := ""
	cSoap += WSSoapValue("sDsCentroCusto", ::csDsCentroCusto, ::csDsCentroCusto , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT CentroCusto_CentroCustoIdiomaDTO
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::csDsCentroCusto    :=  WSAdvValue( oResponse,"_SDSCENTROCUSTO","string",NIL,NIL,NIL,"S",NIL,NIL) 
Return
