#INCLUDE "protheus.ch"
#INCLUDE "apwebsrv.ch"

/*=================================================================================================================*\
|| ############################################################################################################### ||
||																	                                               ||
|| # WSDL Service Grupo de Compra																			 	 # ||
|| # WSDL Location: https://srm-hml.paradigmabs.com.br/cassi-hml/services/GrupoCompra.svc?wsdl					 # ||
||																	                                               ||
|| # Data - 26/09/2019 																							 # ||
||																	                                               ||
|| # Desc: WebService de cadastro de Grupo de Compra.															 # ||
||																	                                               ||
|| # Obs: Alterações neste arquivo podem causar funcionamento incorreto.										 # ||
||																	                                               ||
|| ############################################################################################################### ||
\*=================================================================================================================*/
User Function _TVJHJPK ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSGrupoCompra
------------------------------------------------------------------------------- */

WSCLIENT WSGrupoCompra

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD ProcessarGrupoCompra

	WSDATA   _URL                      AS String
	WSDATA   _CERT                     AS String
	WSDATA   _PRIVKEY                  AS String
	WSDATA   _PASSPHRASE               AS String
	WSDATA   _HEADOUT                  AS Array of String
	WSDATA   _COOKIES                  AS Array of String
	WSDATA   oWSlstGrupoCompra         AS GrupoCompra_ArrayOfGrupoCompraDTO
	WSDATA   oWSProcessarGrupoCompraResult AS GrupoCompra_RetornoDTO

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSGrupoCompra
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.131227A-20190114 NG] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSGrupoCompra
	::oWSlstGrupoCompra  := GrupoCompra_ARRAYOFGRUPOCOMPRADTO():New()
	::oWSProcessarGrupoCompraResult := GrupoCompra_RETORNODTO():New()
Return

WSMETHOD RESET WSCLIENT WSGrupoCompra
	::oWSlstGrupoCompra  := NIL 
	::oWSProcessarGrupoCompraResult := NIL 
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSGrupoCompra
Local oClone := WSGrupoCompra():New()
	oClone:_URL          := ::_URL 
	oClone:_CERT         := ::_CERT 
	oClone:_PRIVKEY      := ::_PRIVKEY 
	oClone:_PASSPHRASE   := ::_PASSPHRASE 
	oClone:oWSlstGrupoCompra :=  IIF(::oWSlstGrupoCompra = NIL , NIL ,::oWSlstGrupoCompra:Clone() )
	oClone:oWSProcessarGrupoCompraResult :=  IIF(::oWSProcessarGrupoCompraResult = NIL , NIL ,::oWSProcessarGrupoCompraResult:Clone() )
Return oClone

// WSDL Method ProcessarGrupoCompra of Service WSGrupoCompra

WSMETHOD ProcessarGrupoCompra WSSEND oWSlstGrupoCompra WSRECEIVE oWSProcessarGrupoCompraResult WSCLIENT WSGrupoCompra
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ProcessarGrupoCompra xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("lstGrupoCompra", ::oWSlstGrupoCompra, oWSlstGrupoCompra , "ArrayOfGrupoCompraDTO", .F. , .F., 0 , "http://tempuri.org/", .F.,.F.) 
cSoap += "</ProcessarGrupoCompra>"

Self:_HEADOUT := { "Authorization: Bearer " + U_NewToken() }
oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tempuri.org/IGrupoCompra/ProcessarGrupoCompra",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	Lower(AllTrim(GetMv("MV_XPARURL"))) + "/services/GrupoCompra.svc")

::Init()
::oWSProcessarGrupoCompraResult:SoapRecv( WSAdvValue( oXmlRet,"_PROCESSARGRUPOCOMPRARESPONSE:_PROCESSARGRUPOCOMPRARESULT","RetornoDTO",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.


// WSDL Data Structure ArrayOfGrupoCompraDTO

WSSTRUCT GrupoCompra_ArrayOfGrupoCompraDTO
	WSDATA   oWSGrupoCompraDTO         AS GrupoCompra_GrupoCompraDTO OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT GrupoCompra_ArrayOfGrupoCompraDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT GrupoCompra_ArrayOfGrupoCompraDTO
	::oWSGrupoCompraDTO    := {} // Array Of  GrupoCompra_GRUPOCOMPRADTO():New()
Return

WSMETHOD CLONE WSCLIENT GrupoCompra_ArrayOfGrupoCompraDTO
	Local oClone := GrupoCompra_ArrayOfGrupoCompraDTO():NEW()
	oClone:oWSGrupoCompraDTO := NIL
	If ::oWSGrupoCompraDTO <> NIL 
		oClone:oWSGrupoCompraDTO := {}
		aEval( ::oWSGrupoCompraDTO , { |x| aadd( oClone:oWSGrupoCompraDTO , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT GrupoCompra_ArrayOfGrupoCompraDTO
	Local cSoap := ""
	aEval( ::oWSGrupoCompraDTO , {|x| cSoap := cSoap  +  WSSoapValue("GrupoCompraDTO", x , x , "GrupoCompraDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.)  } ) 
Return cSoap

// WSDL Data Structure RetornoDTO

WSSTRUCT GrupoCompra_RetornoDTO
	WSDATA   oWSlstWbtLogDTO           AS GrupoCompra_ArrayOfWbtLogDTO OPTIONAL
	WSDATA   nnIdRetorno               AS long OPTIONAL
	WSDATA   csNrToken                 AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT GrupoCompra_RetornoDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT GrupoCompra_RetornoDTO
Return

WSMETHOD CLONE WSCLIENT GrupoCompra_RetornoDTO
	Local oClone := GrupoCompra_RetornoDTO():NEW()
	oClone:oWSlstWbtLogDTO      := IIF(::oWSlstWbtLogDTO = NIL , NIL , ::oWSlstWbtLogDTO:Clone() )
	oClone:nnIdRetorno          := ::nnIdRetorno
	oClone:csNrToken            := ::csNrToken
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT GrupoCompra_RetornoDTO
	Local oNode1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_LSTWBTLOGDTO","ArrayOfWbtLogDTO",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode1 != NIL
		::oWSlstWbtLogDTO := GrupoCompra_ArrayOfWbtLogDTO():New()
		::oWSlstWbtLogDTO:SoapRecv(oNode1)
	EndIf
	::nnIdRetorno        :=  WSAdvValue( oResponse,"_NIDRETORNO","long",NIL,NIL,NIL,"N",NIL,NIL) 
	::csNrToken          :=  WSAdvValue( oResponse,"_SNRTOKEN","string",NIL,NIL,NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure GrupoCompraDTO

WSSTRUCT GrupoCompra_GrupoCompraDTO
	WSDATA   oWSlstCategoria           AS GrupoCompra_ArrayOfClasseDTO OPTIONAL
	WSDATA   oWSlstGrupoCompraIdioma   AS GrupoCompra_ArrayOfGrupoCompraIdiomaDTO OPTIONAL
	WSDATA   csCdGrupoCompra           AS string OPTIONAL
	WSDATA   csDsGrupoCompra           AS string OPTIONAL
	WSDATA   csSgGrupoCompra           AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT GrupoCompra_GrupoCompraDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT GrupoCompra_GrupoCompraDTO
Return

WSMETHOD CLONE WSCLIENT GrupoCompra_GrupoCompraDTO
	Local oClone := GrupoCompra_GrupoCompraDTO():NEW()
	oClone:oWSlstCategoria      := IIF(::oWSlstCategoria = NIL , NIL , ::oWSlstCategoria:Clone() )
	oClone:oWSlstGrupoCompraIdioma := IIF(::oWSlstGrupoCompraIdioma = NIL , NIL , ::oWSlstGrupoCompraIdioma:Clone() )
	oClone:csCdGrupoCompra      := ::csCdGrupoCompra
	oClone:csDsGrupoCompra      := ::csDsGrupoCompra
	oClone:csSgGrupoCompra      := ::csSgGrupoCompra
Return oClone

WSMETHOD SOAPSEND WSCLIENT GrupoCompra_GrupoCompraDTO
	Local cSoap := ""
	cSoap += WSSoapValue("lstCategoria", ::oWSlstCategoria, ::oWSlstCategoria , "ArrayOfClasseDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("lstGrupoCompraIdioma", ::oWSlstGrupoCompraIdioma, ::oWSlstGrupoCompraIdioma , "ArrayOfGrupoCompraIdiomaDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdGrupoCompra", ::csCdGrupoCompra, ::csCdGrupoCompra , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sDsGrupoCompra", ::csDsGrupoCompra, ::csDsGrupoCompra , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sSgGrupoCompra", ::csSgGrupoCompra, ::csSgGrupoCompra , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
Return cSoap

// WSDL Data Structure ArrayOfWbtLogDTO

WSSTRUCT GrupoCompra_ArrayOfWbtLogDTO
	WSDATA   oWSWbtLogDTO              AS GrupoCompra_WbtLogDTO OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT GrupoCompra_ArrayOfWbtLogDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT GrupoCompra_ArrayOfWbtLogDTO
	::oWSWbtLogDTO         := {} // Array Of  GrupoCompra_WBTLOGDTO():New()
Return

WSMETHOD CLONE WSCLIENT GrupoCompra_ArrayOfWbtLogDTO
	Local oClone := GrupoCompra_ArrayOfWbtLogDTO():NEW()
	oClone:oWSWbtLogDTO := NIL
	If ::oWSWbtLogDTO <> NIL 
		oClone:oWSWbtLogDTO := {}
		aEval( ::oWSWbtLogDTO , { |x| aadd( oClone:oWSWbtLogDTO , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT GrupoCompra_ArrayOfWbtLogDTO
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_WBTLOGDTO","WbtLogDTO",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSWbtLogDTO , GrupoCompra_WbtLogDTO():New() )
			::oWSWbtLogDTO[len(::oWSWbtLogDTO)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure ArrayOfClasseDTO

WSSTRUCT GrupoCompra_ArrayOfClasseDTO
	WSDATA   oWSClasseDTO              AS GrupoCompra_ClasseDTO OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT GrupoCompra_ArrayOfClasseDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT GrupoCompra_ArrayOfClasseDTO
	::oWSClasseDTO         := {} // Array Of  GrupoCompra_CLASSEDTO():New()
Return

WSMETHOD CLONE WSCLIENT GrupoCompra_ArrayOfClasseDTO
	Local oClone := GrupoCompra_ArrayOfClasseDTO():NEW()
	oClone:oWSClasseDTO := NIL
	If ::oWSClasseDTO <> NIL 
		oClone:oWSClasseDTO := {}
		aEval( ::oWSClasseDTO , { |x| aadd( oClone:oWSClasseDTO , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT GrupoCompra_ArrayOfClasseDTO
	Local cSoap := ""
	aEval( ::oWSClasseDTO , {|x| cSoap := cSoap  +  WSSoapValue("ClasseDTO", x , x , "ClasseDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO.Negocio", .F.,.F.)  } ) 
Return cSoap

// WSDL Data Structure ArrayOfGrupoCompraIdiomaDTO

WSSTRUCT GrupoCompra_ArrayOfGrupoCompraIdiomaDTO
	WSDATA   oWSGrupoCompraIdiomaDTO   AS GrupoCompra_GrupoCompraIdiomaDTO OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT GrupoCompra_ArrayOfGrupoCompraIdiomaDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT GrupoCompra_ArrayOfGrupoCompraIdiomaDTO
	::oWSGrupoCompraIdiomaDTO := {} // Array Of  GrupoCompra_GRUPOCOMPRAIDIOMADTO():New()
Return

WSMETHOD CLONE WSCLIENT GrupoCompra_ArrayOfGrupoCompraIdiomaDTO
	Local oClone := GrupoCompra_ArrayOfGrupoCompraIdiomaDTO():NEW()
	oClone:oWSGrupoCompraIdiomaDTO := NIL
	If ::oWSGrupoCompraIdiomaDTO <> NIL 
		oClone:oWSGrupoCompraIdiomaDTO := {}
		aEval( ::oWSGrupoCompraIdiomaDTO , { |x| aadd( oClone:oWSGrupoCompraIdiomaDTO , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT GrupoCompra_ArrayOfGrupoCompraIdiomaDTO
	Local cSoap := ""
	aEval( ::oWSGrupoCompraIdiomaDTO , {|x| cSoap := cSoap  +  WSSoapValue("GrupoCompraIdiomaDTO", x , x , "GrupoCompraIdiomaDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.)  } ) 
Return cSoap

// WSDL Data Structure WbtLogDTO

WSSTRUCT GrupoCompra_WbtLogDTO
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

WSMETHOD NEW WSCLIENT GrupoCompra_WbtLogDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT GrupoCompra_WbtLogDTO
Return

WSMETHOD CLONE WSCLIENT GrupoCompra_WbtLogDTO
	Local oClone := GrupoCompra_WbtLogDTO():NEW()
	oClone:nnCdLog              := ::nnCdLog
	oClone:nnIdRetorno          := ::nnIdRetorno
	oClone:csCdOrigem           := ::csCdOrigem
	oClone:csDsLog              := ::csDsLog
	oClone:csDsTipoDocumento    := ::csDsTipoDocumento
	oClone:csNrToken            := ::csNrToken
	oClone:ctDtLog              := ::ctDtLog
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT GrupoCompra_WbtLogDTO
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

// WSDL Data Structure ClasseDTO

WSSTRUCT GrupoCompra_ClasseDTO
	WSDATA   csCdClasse                AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT GrupoCompra_ClasseDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT GrupoCompra_ClasseDTO
Return

WSMETHOD CLONE WSCLIENT GrupoCompra_ClasseDTO
	Local oClone := GrupoCompra_ClasseDTO():NEW()
	oClone:csCdClasse           := ::csCdClasse
Return oClone

WSMETHOD SOAPSEND WSCLIENT GrupoCompra_ClasseDTO
	Local cSoap := ""
	cSoap += WSSoapValue("sCdClasse", ::csCdClasse, ::csCdClasse , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO.Negocio", .F.,.F.) 
Return cSoap

// WSDL Data Structure GrupoCompraIdiomaDTO

WSSTRUCT GrupoCompra_GrupoCompraIdiomaDTO
	WSDATA   csDsGrupoCompra           AS string OPTIONAL
	WSDATA   csSgGrupoCompra           AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT GrupoCompra_GrupoCompraIdiomaDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT GrupoCompra_GrupoCompraIdiomaDTO
Return

WSMETHOD CLONE WSCLIENT GrupoCompra_GrupoCompraIdiomaDTO
	Local oClone := GrupoCompra_GrupoCompraIdiomaDTO():NEW()
	oClone:csDsGrupoCompra      := ::csDsGrupoCompra
	oClone:csSgGrupoCompra      := ::csSgGrupoCompra
Return oClone

WSMETHOD SOAPSEND WSCLIENT GrupoCompra_GrupoCompraIdiomaDTO
	Local cSoap := ""
	cSoap += WSSoapValue("sDsGrupoCompra", ::csDsGrupoCompra, ::csDsGrupoCompra , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sSgGrupoCompra", ::csSgGrupoCompra, ::csSgGrupoCompra , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
Return cSoap


