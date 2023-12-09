#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"

/*=================================================================================================================*\
|| ############################################################################################################### ||
||																	                                               ||
|| # WSDL Service WSEmpresaClasse																				 # ||
|| # WSDL Location: https://srm-hml.paradigmabs.com.br/cassi-hml/services/EmpresaClasse.svc?wsdl				 # ||
||																	                                               ||
|| # Data - 30/09/2019 																							 # ||
||																	                                               ||
|| # Desc: WebService de cadastro de Empresas.																	 # ||
||																	                                               ||
|| # Obs: Alterações neste arquivo podem causar funcionamento incorreto.										 # ||
||																	                                               ||
|| ############################################################################################################### ||
\*=================================================================================================================*/
User Function _HTBJCBR ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSEmpresaClasse
------------------------------------------------------------------------------- */

WSCLIENT WSEmpresaClasse

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD ProcessarEmpresaCategoria
	WSMETHOD ProcessarArvoreCategoriaEmpresa
	WSMETHOD ExcluirEmpresaCategoria
	WSMETHOD AtualizarEmpresaCategoria
	WSMETHOD RetornarEmpresaCategoria

	WSDATA   _URL                      AS String
	WSDATA   _CERT                     AS String
	WSDATA   _PRIVKEY                  AS String
	WSDATA   _PASSPHRASE               AS String
	WSDATA   _HEADOUT                  AS Array of String
	WSDATA   _COOKIES                  AS Array of String
	WSDATA   oWSlstEmpresaClasse       AS EmpresaClasse_ArrayOfEmpresaClasseDTO
	WSDATA   oWSProcessarEmpresaCategoriaResult AS EmpresaClasse_RetornoDTO
	WSDATA   oWSProcessarArvoreCategoriaEmpresaResult AS EmpresaClasse_RetornoDTO
	WSDATA   oWSExcluirEmpresaCategoriaResult AS EmpresaClasse_RetornoDTO
	WSDATA   oWSAtualizarEmpresaCategoriaResult AS EmpresaClasse_RetornoDTO
	WSDATA   csCdEmpresaErp            AS string
	WSDATA   oWSRetornarEmpresaCategoriaResult AS EmpresaClasse_ArrayOfEmpresaClasseDTO

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSEmpresaClasse
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.131227A-20190114 NG] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSEmpresaClasse
	::oWSlstEmpresaClasse := EmpresaClasse_ARRAYOFEMPRESACLASSEDTO():New()
	::oWSProcessarEmpresaCategoriaResult := EmpresaClasse_RETORNODTO():New()
	::oWSProcessarArvoreCategoriaEmpresaResult := EmpresaClasse_RETORNODTO():New()
	::oWSExcluirEmpresaCategoriaResult := EmpresaClasse_RETORNODTO():New()
	::oWSAtualizarEmpresaCategoriaResult := EmpresaClasse_RETORNODTO():New()
	::oWSRetornarEmpresaCategoriaResult := EmpresaClasse_ARRAYOFEMPRESACLASSEDTO():New()
Return

WSMETHOD RESET WSCLIENT WSEmpresaClasse
	::oWSlstEmpresaClasse := NIL 
	::oWSProcessarEmpresaCategoriaResult := NIL 
	::oWSProcessarArvoreCategoriaEmpresaResult := NIL 
	::oWSExcluirEmpresaCategoriaResult := NIL 
	::oWSAtualizarEmpresaCategoriaResult := NIL 
	::csCdEmpresaErp     := NIL 
	::oWSRetornarEmpresaCategoriaResult := NIL 
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSEmpresaClasse
Local oClone := WSEmpresaClasse():New()
	oClone:_URL          := ::_URL 
	oClone:_CERT         := ::_CERT 
	oClone:_PRIVKEY      := ::_PRIVKEY 
	oClone:_PASSPHRASE   := ::_PASSPHRASE 
	oClone:oWSlstEmpresaClasse :=  IIF(::oWSlstEmpresaClasse = NIL , NIL ,::oWSlstEmpresaClasse:Clone() )
	oClone:oWSProcessarEmpresaCategoriaResult :=  IIF(::oWSProcessarEmpresaCategoriaResult = NIL , NIL ,::oWSProcessarEmpresaCategoriaResult:Clone() )
	oClone:oWSProcessarArvoreCategoriaEmpresaResult :=  IIF(::oWSProcessarArvoreCategoriaEmpresaResult = NIL , NIL ,::oWSProcessarArvoreCategoriaEmpresaResult:Clone() )
	oClone:oWSExcluirEmpresaCategoriaResult :=  IIF(::oWSExcluirEmpresaCategoriaResult = NIL , NIL ,::oWSExcluirEmpresaCategoriaResult:Clone() )
	oClone:oWSAtualizarEmpresaCategoriaResult :=  IIF(::oWSAtualizarEmpresaCategoriaResult = NIL , NIL ,::oWSAtualizarEmpresaCategoriaResult:Clone() )
	oClone:csCdEmpresaErp := ::csCdEmpresaErp
	oClone:oWSRetornarEmpresaCategoriaResult :=  IIF(::oWSRetornarEmpresaCategoriaResult = NIL , NIL ,::oWSRetornarEmpresaCategoriaResult:Clone() )
Return oClone

// WSDL Method ProcessarEmpresaCategoria of Service WSEmpresaClasse

WSMETHOD ProcessarEmpresaCategoria WSSEND oWSlstEmpresaClasse WSRECEIVE oWSProcessarEmpresaCategoriaResult WSCLIENT WSEmpresaClasse
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ProcessarEmpresaCategoria xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("lstEmpresaClasse", ::oWSlstEmpresaClasse, oWSlstEmpresaClasse , "ArrayOfEmpresaClasseDTO", .F. , .F., 0 , "http://tempuri.org/", .F.,.F.) 
cSoap += "</ProcessarEmpresaCategoria>"

Self:_HEADOUT := { "Authorization: Bearer " + U_NewToken() }
oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tempuri.org/IEmpresaClasse/ProcessarEmpresaCategoria",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	Lower(AllTrim(GetMv("MV_XPARURL"))) + "/services/EmpresaClasse.svc")

::Init()
::oWSProcessarEmpresaCategoriaResult:SoapRecv( WSAdvValue( oXmlRet,"_PROCESSAREMPRESACATEGORIARESPONSE:_PROCESSAREMPRESACATEGORIARESULT","RetornoDTO",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method ProcessarArvoreCategoriaEmpresa of Service WSEmpresaClasse

WSMETHOD ProcessarArvoreCategoriaEmpresa WSSEND oWSlstEmpresaClasse WSRECEIVE oWSProcessarArvoreCategoriaEmpresaResult WSCLIENT WSEmpresaClasse
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ProcessarArvoreCategoriaEmpresa xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("lstEmpresaClasse", ::oWSlstEmpresaClasse, oWSlstEmpresaClasse , "ArrayOfEmpresaClasseDTO", .F. , .F., 0 , "http://tempuri.org/", .F.,.F.) 
cSoap += "</ProcessarArvoreCategoriaEmpresa>"

Self:_HEADOUT := { "Authorization: Bearer " + U_NewToken() }
oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tempuri.org/IEmpresaClasse/ProcessarArvoreCategoriaEmpresa",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	Lower(AllTrim(GetMv("MV_XPARURL"))) + "/services/EmpresaClasse.svc")

::Init()
::oWSProcessarArvoreCategoriaEmpresaResult:SoapRecv( WSAdvValue( oXmlRet,"_PROCESSARARVORECATEGORIAEMPRESARESPONSE:_PROCESSARARVORECATEGORIAEMPRESARESULT","RetornoDTO",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method ExcluirEmpresaCategoria of Service WSEmpresaClasse

WSMETHOD ExcluirEmpresaCategoria WSSEND oWSlstEmpresaClasse WSRECEIVE oWSExcluirEmpresaCategoriaResult WSCLIENT WSEmpresaClasse
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ExcluirEmpresaCategoria xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("lstEmpresaClasse", ::oWSlstEmpresaClasse, oWSlstEmpresaClasse , "ArrayOfEmpresaClasseDTO", .F. , .F., 0 , "http://tempuri.org/", .F.,.F.) 
cSoap += "</ExcluirEmpresaCategoria>"

Self:_HEADOUT := { "Authorization: Bearer " + U_NewToken() }
oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tempuri.org/IEmpresaClasse/ExcluirEmpresaCategoria",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	Lower(AllTrim(GetMv("MV_XPARURL"))) + "/services/EmpresaClasse.svc")

::Init()
::oWSExcluirEmpresaCategoriaResult:SoapRecv( WSAdvValue( oXmlRet,"_EXCLUIREMPRESACATEGORIARESPONSE:_EXCLUIREMPRESACATEGORIARESULT","RetornoDTO",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method AtualizarEmpresaCategoria of Service WSEmpresaClasse

WSMETHOD AtualizarEmpresaCategoria WSSEND oWSlstEmpresaClasse WSRECEIVE oWSAtualizarEmpresaCategoriaResult WSCLIENT WSEmpresaClasse
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<AtualizarEmpresaCategoria xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("lstEmpresaClasse", ::oWSlstEmpresaClasse, oWSlstEmpresaClasse , "ArrayOfEmpresaListaClasseDTO", .F. , .F., 0 , "http://tempuri.org/", .F.,.F.) 
cSoap += "</AtualizarEmpresaCategoria>"

Self:_HEADOUT := { "Authorization: Bearer " + U_NewToken() }
oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tempuri.org/IEmpresaClasse/AtualizarEmpresaCategoria",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	Lower(AllTrim(GetMv("MV_XPARURL"))) + "/services/EmpresaClasse.svc")

::Init()
::oWSAtualizarEmpresaCategoriaResult:SoapRecv( WSAdvValue( oXmlRet,"_ATUALIZAREMPRESACATEGORIARESPONSE:_ATUALIZAREMPRESACATEGORIARESULT","RetornoDTO",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method RetornarEmpresaCategoria of Service WSEmpresaClasse

WSMETHOD RetornarEmpresaCategoria WSSEND csCdEmpresaErp WSRECEIVE oWSRetornarEmpresaCategoriaResult WSCLIENT WSEmpresaClasse
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<RetornarEmpresaCategoria xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("sCdEmpresaErp", ::csCdEmpresaErp, csCdEmpresaErp , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</RetornarEmpresaCategoria>"

Self:_HEADOUT := { "Authorization: Bearer " + U_NewToken() }
oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tempuri.org/IEmpresaClasse/RetornarEmpresaCategoria",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	Lower(AllTrim(GetMv("MV_XPARURL"))) + "/services/EmpresaClasse.svc")

::Init()
::oWSRetornarEmpresaCategoriaResult:SoapRecv( WSAdvValue( oXmlRet,"_RETORNAREMPRESACATEGORIARESPONSE:_RETORNAREMPRESACATEGORIARESULT","ArrayOfEmpresaClasseDTO",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.


// WSDL Data Structure ArrayOfEmpresaClasseDTO

WSSTRUCT EmpresaClasse_ArrayOfEmpresaClasseDTO
	WSDATA   oWSEmpresaClasseDTO       AS EmpresaClasse_EmpresaClasseDTO OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT EmpresaClasse_ArrayOfEmpresaClasseDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT EmpresaClasse_ArrayOfEmpresaClasseDTO
	::oWSEmpresaClasseDTO  := {} // Array Of  EmpresaClasse_EMPRESACLASSEDTO():New()
Return

WSMETHOD CLONE WSCLIENT EmpresaClasse_ArrayOfEmpresaClasseDTO
	Local oClone := EmpresaClasse_ArrayOfEmpresaClasseDTO():NEW()
	oClone:oWSEmpresaClasseDTO := NIL
	If ::oWSEmpresaClasseDTO <> NIL 
		oClone:oWSEmpresaClasseDTO := {}
		aEval( ::oWSEmpresaClasseDTO , { |x| aadd( oClone:oWSEmpresaClasseDTO , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT EmpresaClasse_ArrayOfEmpresaClasseDTO
	Local cSoap := ""
	aEval( ::oWSEmpresaClasseDTO , {|x| cSoap := cSoap  +  WSSoapValue("EmpresaClasseDTO", x , x , "EmpresaClasseDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.)  } ) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT EmpresaClasse_ArrayOfEmpresaClasseDTO
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_EMPRESACLASSEDTO","EmpresaClasseDTO",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSEmpresaClasseDTO , EmpresaClasse_EmpresaClasseDTO():New() )
			::oWSEmpresaClasseDTO[len(::oWSEmpresaClasseDTO)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure RetornoDTO

WSSTRUCT EmpresaClasse_RetornoDTO
	WSDATA   oWSlstWbtLogDTO           AS EmpresaClasse_ArrayOfWbtLogDTO OPTIONAL
	WSDATA   nnIdRetorno               AS long OPTIONAL
	WSDATA   csNrToken                 AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT EmpresaClasse_RetornoDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT EmpresaClasse_RetornoDTO
Return

WSMETHOD CLONE WSCLIENT EmpresaClasse_RetornoDTO
	Local oClone := EmpresaClasse_RetornoDTO():NEW()
	oClone:oWSlstWbtLogDTO      := IIF(::oWSlstWbtLogDTO = NIL , NIL , ::oWSlstWbtLogDTO:Clone() )
	oClone:nnIdRetorno          := ::nnIdRetorno
	oClone:csNrToken            := ::csNrToken
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT EmpresaClasse_RetornoDTO
	Local oNode1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_LSTWBTLOGDTO","ArrayOfWbtLogDTO",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode1 != NIL
		::oWSlstWbtLogDTO := EmpresaClasse_ArrayOfWbtLogDTO():New()
		::oWSlstWbtLogDTO:SoapRecv(oNode1)
	EndIf
	::nnIdRetorno        :=  WSAdvValue( oResponse,"_NIDRETORNO","long",NIL,NIL,NIL,"N",NIL,NIL) 
	::csNrToken          :=  WSAdvValue( oResponse,"_SNRTOKEN","string",NIL,NIL,NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure EmpresaClasseDTO

WSSTRUCT EmpresaClasse_EmpresaClasseDTO
	WSDATA   csCdClasse                AS string OPTIONAL
	WSDATA   csCdEmpresa               AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT EmpresaClasse_EmpresaClasseDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT EmpresaClasse_EmpresaClasseDTO
Return

WSMETHOD CLONE WSCLIENT EmpresaClasse_EmpresaClasseDTO
	Local oClone := EmpresaClasse_EmpresaClasseDTO():NEW()
	oClone:csCdClasse           := ::csCdClasse
	oClone:csCdEmpresa          := ::csCdEmpresa
Return oClone

WSMETHOD SOAPSEND WSCLIENT EmpresaClasse_EmpresaClasseDTO
	Local cSoap := ""
	cSoap += WSSoapValue("sCdClasse", ::csCdClasse, ::csCdClasse , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdEmpresa", ::csCdEmpresa, ::csCdEmpresa , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT EmpresaClasse_EmpresaClasseDTO
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::csCdClasse         :=  WSAdvValue( oResponse,"_SCDCLASSE","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdEmpresa        :=  WSAdvValue( oResponse,"_SCDEMPRESA","string",NIL,NIL,NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure ArrayOfWbtLogDTO

WSSTRUCT EmpresaClasse_ArrayOfWbtLogDTO
	WSDATA   oWSWbtLogDTO              AS EmpresaClasse_WbtLogDTO OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT EmpresaClasse_ArrayOfWbtLogDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT EmpresaClasse_ArrayOfWbtLogDTO
	::oWSWbtLogDTO         := {} // Array Of  EmpresaClasse_WBTLOGDTO():New()
Return

WSMETHOD CLONE WSCLIENT EmpresaClasse_ArrayOfWbtLogDTO
	Local oClone := EmpresaClasse_ArrayOfWbtLogDTO():NEW()
	oClone:oWSWbtLogDTO := NIL
	If ::oWSWbtLogDTO <> NIL 
		oClone:oWSWbtLogDTO := {}
		aEval( ::oWSWbtLogDTO , { |x| aadd( oClone:oWSWbtLogDTO , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT EmpresaClasse_ArrayOfWbtLogDTO
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_WBTLOGDTO","WbtLogDTO",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSWbtLogDTO , EmpresaClasse_WbtLogDTO():New() )
			::oWSWbtLogDTO[len(::oWSWbtLogDTO)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure WbtLogDTO

WSSTRUCT EmpresaClasse_WbtLogDTO
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

WSMETHOD NEW WSCLIENT EmpresaClasse_WbtLogDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT EmpresaClasse_WbtLogDTO
Return

WSMETHOD CLONE WSCLIENT EmpresaClasse_WbtLogDTO
	Local oClone := EmpresaClasse_WbtLogDTO():NEW()
	oClone:nnCdLog              := ::nnCdLog
	oClone:nnIdRetorno          := ::nnIdRetorno
	oClone:csCdOrigem           := ::csCdOrigem
	oClone:csDsLog              := ::csDsLog
	oClone:csDsTipoDocumento    := ::csDsTipoDocumento
	oClone:csNrToken            := ::csNrToken
	oClone:ctDtLog              := ::ctDtLog
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT EmpresaClasse_WbtLogDTO
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


