#INCLUDE "protheus.ch"
#INCLUDE "apwebsrv.ch"

/*=================================================================================================================*\
|| ############################################################################################################### ||
||																	                                               ||
|| # WSDL Service Categoria																						 # ||
|| # WSDL Location: https://srm-hml.paradigmabs.com.br/cassi-hml/services/Categoria.svc?wsdl					 # ||
||																	                                               ||
|| # Data - 26/09/2019 																							 # ||
||																	                                               ||
|| # Desc: WebService de cadastro de Categoria.																	 # ||
||																	                                               ||
|| # Obs: Alterações neste arquivo podem causar funcionamento incorreto.										 # ||
||																	                                               ||
|| ############################################################################################################### ||
\*=================================================================================================================*/
User Function _RVPFXOO ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSParCategoria
------------------------------------------------------------------------------- */

WSCLIENT WSParCategoria

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD ProcessarCategoriaProduto
	WSMETHOD RetornarCategoriaProduto
	WSMETHOD RetornarCategoriaProdutoAtiva
	WSMETHOD RetornarCategoriaSemDePara

	WSDATA   _URL                      AS String
	WSDATA   _CERT                     AS String
	WSDATA   _PRIVKEY                  AS String
	WSDATA   _PASSPHRASE               AS String
	WSDATA   _HEADOUT                  AS Array of String
	WSDATA   _COOKIES                  AS Array of String
	WSDATA   oWSlstCategoria           AS Categoria_ArrayOfCategoriaDTO
	WSDATA   oWSProcessarCategoriaProdutoResult AS Categoria_RetornoDTO
	WSDATA   csCdCategoriaProdutpERP   AS string
	WSDATA   oWSRetornarCategoriaProdutoResult AS Categoria_CategoriaDTO
	WSDATA   oWSRetornarCategoriaProdutoAtivaResult AS Categoria_RetornoListaCategoriaDTO
	WSDATA   csCdEmpresa               AS string
	WSDATA   oWSRetornarCategoriaSemDeParaResult AS Categoria_ArrayOfCategoriaDTO

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSParCategoria
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.131227A-20190114 NG] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSParCategoria
	::oWSlstCategoria    := Categoria_ARRAYOFCATEGORIADTO():New()
	::oWSProcessarCategoriaProdutoResult := Categoria_RETORNODTO():New()
	::oWSRetornarCategoriaProdutoResult := Categoria_CATEGORIADTO():New()
	::oWSRetornarCategoriaProdutoAtivaResult := Categoria_RETORNOLISTACATEGORIADTO():New()
	::oWSRetornarCategoriaSemDeParaResult := Categoria_ARRAYOFCATEGORIADTO():New()
Return

WSMETHOD RESET WSCLIENT WSParCategoria
	::oWSlstCategoria    := NIL 
	::oWSProcessarCategoriaProdutoResult := NIL 
	::csCdCategoriaProdutpERP := NIL 
	::oWSRetornarCategoriaProdutoResult := NIL 
	::oWSRetornarCategoriaProdutoAtivaResult := NIL 
	::csCdEmpresa        := NIL 
	::oWSRetornarCategoriaSemDeParaResult := NIL 
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSParCategoria
Local oClone := WSParCategoria():New()
	oClone:_URL          := ::_URL 
	oClone:_CERT         := ::_CERT 
	oClone:_PRIVKEY      := ::_PRIVKEY 
	oClone:_PASSPHRASE   := ::_PASSPHRASE 
	oClone:oWSlstCategoria :=  IIF(::oWSlstCategoria = NIL , NIL ,::oWSlstCategoria:Clone() )
	oClone:oWSProcessarCategoriaProdutoResult :=  IIF(::oWSProcessarCategoriaProdutoResult = NIL , NIL ,::oWSProcessarCategoriaProdutoResult:Clone() )
	oClone:csCdCategoriaProdutpERP := ::csCdCategoriaProdutpERP
	oClone:oWSRetornarCategoriaProdutoResult :=  IIF(::oWSRetornarCategoriaProdutoResult = NIL , NIL ,::oWSRetornarCategoriaProdutoResult:Clone() )
	oClone:oWSRetornarCategoriaProdutoAtivaResult :=  IIF(::oWSRetornarCategoriaProdutoAtivaResult = NIL , NIL ,::oWSRetornarCategoriaProdutoAtivaResult:Clone() )
	oClone:csCdEmpresa   := ::csCdEmpresa
	oClone:oWSRetornarCategoriaSemDeParaResult :=  IIF(::oWSRetornarCategoriaSemDeParaResult = NIL , NIL ,::oWSRetornarCategoriaSemDeParaResult:Clone() )
Return oClone

// WSDL Method ProcessarCategoriaProduto of Service WSParCategoria

WSMETHOD ProcessarCategoriaProduto WSSEND oWSlstCategoria WSRECEIVE oWSProcessarCategoriaProdutoResult WSCLIENT WSParCategoria
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ProcessarCategoriaProduto xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("lstCategoria", ::oWSlstCategoria, oWSlstCategoria , "ArrayOfCategoriaDTO", .F. , .F., 0 , "http://tempuri.org/", .F.,.F.) 
cSoap += "</ProcessarCategoriaProduto>"

Self:_HEADOUT := { "Authorization: Bearer " + U_NewToken() }
oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tempuri.org/ICategoria/ProcessarCategoriaProduto",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	Lower(AllTrim(GetMv("MV_XPARURL"))) + "/services/Categoria.svc")

::Init()
::oWSProcessarCategoriaProdutoResult:SoapRecv( WSAdvValue( oXmlRet,"_PROCESSARCATEGORIAPRODUTORESPONSE:_PROCESSARCATEGORIAPRODUTORESULT","RetornoDTO",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return {.T.,cSoap}

// WSDL Method RetornarCategoriaProduto of Service WSParCategoria

WSMETHOD RetornarCategoriaProduto WSSEND csCdCategoriaProdutpERP WSRECEIVE oWSRetornarCategoriaProdutoResult WSCLIENT WSParCategoria
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<RetornarCategoriaProduto xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("sCdCategoriaProdutpERP", ::csCdCategoriaProdutpERP, csCdCategoriaProdutpERP , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</RetornarCategoriaProduto>"

Self:_HEADOUT := { "Authorization: Bearer " + U_NewToken() }
oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tempuri.org/ICategoria/RetornarCategoriaProduto",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	Lower(AllTrim(GetMv("MV_XPARURL"))) + "/services/Categoria.svc")

::Init()
::oWSRetornarCategoriaProdutoResult:SoapRecv( WSAdvValue( oXmlRet,"_RETORNARCATEGORIAPRODUTORESPONSE:_RETORNARCATEGORIAPRODUTORESULT","CategoriaDTO",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method RetornarCategoriaProdutoAtiva of Service WSParCategoria

WSMETHOD RetornarCategoriaProdutoAtiva WSSEND NULLPARAM WSRECEIVE oWSRetornarCategoriaProdutoAtivaResult WSCLIENT WSParCategoria
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<RetornarCategoriaProdutoAtiva xmlns="http://tempuri.org/">'
cSoap += "</RetornarCategoriaProdutoAtiva>"

Self:_HEADOUT := { "Authorization: Bearer " + U_NewToken() }
oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tempuri.org/ICategoria/RetornarCategoriaProdutoAtiva",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	Lower(AllTrim(GetMv("MV_XPARURL"))) + "/services/Categoria.svc")

::Init()
::oWSRetornarCategoriaProdutoAtivaResult:SoapRecv( WSAdvValue( oXmlRet,"_RETORNARCATEGORIAPRODUTOATIVARESPONSE:_RETORNARCATEGORIAPRODUTOATIVARESULT","RetornoListaCategoriaDTO",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method RetornarCategoriaSemDePara of Service WSParCategoria

WSMETHOD RetornarCategoriaSemDePara WSSEND csCdEmpresa WSRECEIVE oWSRetornarCategoriaSemDeParaResult WSCLIENT WSParCategoria
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<RetornarCategoriaSemDePara xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("sCdEmpresa", ::csCdEmpresa, csCdEmpresa , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</RetornarCategoriaSemDePara>"

Self:_HEADOUT := { "Authorization: Bearer " + U_NewToken() }
oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tempuri.org/ICategoria/RetornarCategoriaSemDePara",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	Lower(AllTrim(GetMv("MV_XPARURL"))) + "/services/Categoria.svc")

::Init()
::oWSRetornarCategoriaSemDeParaResult:SoapRecv( WSAdvValue( oXmlRet,"_RETORNARCATEGORIASEMDEPARARESPONSE:_RETORNARCATEGORIASEMDEPARARESULT","ArrayOfCategoriaDTO",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.


// WSDL Data Structure ArrayOfCategoriaDTO

WSSTRUCT Categoria_ArrayOfCategoriaDTO
	WSDATA   oWSParCategoriaDTO           AS Categoria_CategoriaDTO OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Categoria_ArrayOfCategoriaDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Categoria_ArrayOfCategoriaDTO
	::oWSParCategoriaDTO      := {} // Array Of  Categoria_CATEGORIADTO():New()
Return

WSMETHOD CLONE WSCLIENT Categoria_ArrayOfCategoriaDTO
	Local oClone := Categoria_ArrayOfCategoriaDTO():NEW()
	oClone:oWSParCategoriaDTO := NIL
	If ::oWSParCategoriaDTO <> NIL 
		oClone:oWSParCategoriaDTO := {}
		aEval( ::oWSParCategoriaDTO , { |x| aadd( oClone:oWSParCategoriaDTO , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT Categoria_ArrayOfCategoriaDTO
	Local cSoap := ""
	aEval( ::oWSParCategoriaDTO , {|x| cSoap := cSoap  +  WSSoapValue("CategoriaDTO", x , x , "CategoriaDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.)  } ) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Categoria_ArrayOfCategoriaDTO
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_CATEGORIADTO","CategoriaDTO",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSParCategoriaDTO , Categoria_CategoriaDTO():New() )
			::oWSParCategoriaDTO[len(::oWSParCategoriaDTO)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure RetornoDTO

WSSTRUCT Categoria_RetornoDTO
	WSDATA   oWSlstWbtLogDTO           AS Categoria_ArrayOfWbtLogDTO OPTIONAL
	WSDATA   nnIdRetorno               AS long OPTIONAL
	WSDATA   csNrToken                 AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Categoria_RetornoDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Categoria_RetornoDTO
Return

WSMETHOD CLONE WSCLIENT Categoria_RetornoDTO
	Local oClone := Categoria_RetornoDTO():NEW()
	oClone:oWSlstWbtLogDTO      := IIF(::oWSlstWbtLogDTO = NIL , NIL , ::oWSlstWbtLogDTO:Clone() )
	oClone:nnIdRetorno          := ::nnIdRetorno
	oClone:csNrToken            := ::csNrToken
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Categoria_RetornoDTO
	Local oNode1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_LSTWBTLOGDTO","ArrayOfWbtLogDTO",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode1 != NIL
		::oWSlstWbtLogDTO := Categoria_ArrayOfWbtLogDTO():New()
		::oWSlstWbtLogDTO:SoapRecv(oNode1)
	EndIf
	::nnIdRetorno        :=  WSAdvValue( oResponse,"_NIDRETORNO","long",NIL,NIL,NIL,"N",NIL,NIL) 
	::csNrToken          :=  WSAdvValue( oResponse,"_SNRTOKEN","string",NIL,NIL,NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure CategoriaDTO

WSSTRUCT Categoria_CategoriaDTO
	WSDATA   oWSlstCategoriaIdioma     AS Categoria_ArrayOfCategoriaIdiomaDTO OPTIONAL
	WSDATA   csCdClasse                AS string OPTIONAL
	WSDATA   csCdClasseEmpresa         AS string OPTIONAL
	WSDATA   csCdClassePai             AS string OPTIONAL
	WSDATA   csCdEmpresa               AS string OPTIONAL
	WSDATA   csCdSituacao              AS string OPTIONAL
	WSDATA   csDsClasse                AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Categoria_CategoriaDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Categoria_CategoriaDTO
Return

WSMETHOD CLONE WSCLIENT Categoria_CategoriaDTO
	Local oClone := Categoria_CategoriaDTO():NEW()
	oClone:oWSlstCategoriaIdioma := IIF(::oWSlstCategoriaIdioma = NIL , NIL , ::oWSlstCategoriaIdioma:Clone() )
	oClone:csCdClasse           := ::csCdClasse
	oClone:csCdClasseEmpresa    := ::csCdClasseEmpresa
	oClone:csCdClassePai        := ::csCdClassePai
	oClone:csCdEmpresa          := ::csCdEmpresa
	oClone:csCdSituacao         := ::csCdSituacao
	oClone:csDsClasse           := ::csDsClasse
Return oClone

WSMETHOD SOAPSEND WSCLIENT Categoria_CategoriaDTO
	Local cSoap := ""
	cSoap += WSSoapValue("lstCategoriaIdioma", ::oWSlstCategoriaIdioma, ::oWSlstCategoriaIdioma , "ArrayOfCategoriaIdiomaDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdClasse", ::csCdClasse, ::csCdClasse , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdClasseEmpresa", ::csCdClasseEmpresa, ::csCdClasseEmpresa , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdClassePai", ::csCdClassePai, ::csCdClassePai , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdEmpresa", ::csCdEmpresa, ::csCdEmpresa , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdSituacao", ::csCdSituacao, ::csCdSituacao , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sDsClasse", ::csDsClasse, ::csDsClasse , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Categoria_CategoriaDTO
	Local oNode1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_LSTCATEGORIAIDIOMA","ArrayOfCategoriaIdiomaDTO",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode1 != NIL
		::oWSlstCategoriaIdioma := Categoria_ArrayOfCategoriaIdiomaDTO():New()
		::oWSlstCategoriaIdioma:SoapRecv(oNode1)
	EndIf
	::csCdClasse         :=  WSAdvValue( oResponse,"_SCDCLASSE","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdClasseEmpresa  :=  WSAdvValue( oResponse,"_SCDCLASSEEMPRESA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdClassePai      :=  WSAdvValue( oResponse,"_SCDCLASSEPAI","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdEmpresa        :=  WSAdvValue( oResponse,"_SCDEMPRESA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdSituacao       :=  WSAdvValue( oResponse,"_SCDSITUACAO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csDsClasse         :=  WSAdvValue( oResponse,"_SDSCLASSE","string",NIL,NIL,NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure RetornoListaCategoriaDTO

WSSTRUCT Categoria_RetornoListaCategoriaDTO
	WSDATA   oWSlstObjetoRetorno       AS Categoria_ArrayOfCategoriaDTO OPTIONAL
	WSDATA   nnQtRegistrosRetorno      AS int OPTIONAL
	WSDATA   nnQtRegistrosTotal        AS int OPTIONAL
	WSDATA   oWSoRetornoDTO            AS Categoria_RetornoDTO OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Categoria_RetornoListaCategoriaDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Categoria_RetornoListaCategoriaDTO
Return

WSMETHOD CLONE WSCLIENT Categoria_RetornoListaCategoriaDTO
	Local oClone := Categoria_RetornoListaCategoriaDTO():NEW()
	oClone:oWSlstObjetoRetorno  := IIF(::oWSlstObjetoRetorno = NIL , NIL , ::oWSlstObjetoRetorno:Clone() )
	oClone:nnQtRegistrosRetorno := ::nnQtRegistrosRetorno
	oClone:nnQtRegistrosTotal   := ::nnQtRegistrosTotal
	oClone:oWSoRetornoDTO       := IIF(::oWSoRetornoDTO = NIL , NIL , ::oWSoRetornoDTO:Clone() )
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Categoria_RetornoListaCategoriaDTO
	Local oNode1
	Local oNode4
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_LSTOBJETORETORNO","ArrayOfCategoriaDTO",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode1 != NIL
		::oWSlstObjetoRetorno := Categoria_ArrayOfCategoriaDTO():New()
		::oWSlstObjetoRetorno:SoapRecv(oNode1)
	EndIf
	::nnQtRegistrosRetorno :=  WSAdvValue( oResponse,"_NQTREGISTROSRETORNO","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::nnQtRegistrosTotal :=  WSAdvValue( oResponse,"_NQTREGISTROSTOTAL","int",NIL,NIL,NIL,"N",NIL,NIL) 
	oNode4 :=  WSAdvValue( oResponse,"_ORETORNODTO","RetornoDTO",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode4 != NIL
		::oWSoRetornoDTO := Categoria_RetornoDTO():New()
		::oWSoRetornoDTO:SoapRecv(oNode4)
	EndIf
Return

// WSDL Data Structure ArrayOfWbtLogDTO

WSSTRUCT Categoria_ArrayOfWbtLogDTO
	WSDATA   oWSWbtLogDTO              AS Categoria_WbtLogDTO OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Categoria_ArrayOfWbtLogDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Categoria_ArrayOfWbtLogDTO
	::oWSWbtLogDTO         := {} // Array Of  Categoria_WBTLOGDTO():New()
Return

WSMETHOD CLONE WSCLIENT Categoria_ArrayOfWbtLogDTO
	Local oClone := Categoria_ArrayOfWbtLogDTO():NEW()
	oClone:oWSWbtLogDTO := NIL
	If ::oWSWbtLogDTO <> NIL 
		oClone:oWSWbtLogDTO := {}
		aEval( ::oWSWbtLogDTO , { |x| aadd( oClone:oWSWbtLogDTO , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Categoria_ArrayOfWbtLogDTO
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_WBTLOGDTO","WbtLogDTO",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSWbtLogDTO , Categoria_WbtLogDTO():New() )
			::oWSWbtLogDTO[len(::oWSWbtLogDTO)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure ArrayOfCategoriaIdiomaDTO

WSSTRUCT Categoria_ArrayOfCategoriaIdiomaDTO
	WSDATA   oWSParCategoriaIdiomaDTO     AS Categoria_CategoriaIdiomaDTO OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Categoria_ArrayOfCategoriaIdiomaDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Categoria_ArrayOfCategoriaIdiomaDTO
	::oWSParCategoriaIdiomaDTO := {} // Array Of  Categoria_CATEGORIAIDIOMADTO():New()
Return

WSMETHOD CLONE WSCLIENT Categoria_ArrayOfCategoriaIdiomaDTO
	Local oClone := Categoria_ArrayOfCategoriaIdiomaDTO():NEW()
	oClone:oWSParCategoriaIdiomaDTO := NIL
	If ::oWSParCategoriaIdiomaDTO <> NIL 
		oClone:oWSParCategoriaIdiomaDTO := {}
		aEval( ::oWSParCategoriaIdiomaDTO , { |x| aadd( oClone:oWSParCategoriaIdiomaDTO , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT Categoria_ArrayOfCategoriaIdiomaDTO
	Local cSoap := ""
	aEval( ::oWSParCategoriaIdiomaDTO , {|x| cSoap := cSoap  +  WSSoapValue("CategoriaIdiomaDTO", x , x , "CategoriaIdiomaDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.)  } ) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Categoria_ArrayOfCategoriaIdiomaDTO
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_CATEGORIAIDIOMADTO","CategoriaIdiomaDTO",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSParCategoriaIdiomaDTO , Categoria_CategoriaIdiomaDTO():New() )
			::oWSParCategoriaIdiomaDTO[len(::oWSParCategoriaIdiomaDTO)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure WbtLogDTO

WSSTRUCT Categoria_WbtLogDTO
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

WSMETHOD NEW WSCLIENT Categoria_WbtLogDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Categoria_WbtLogDTO
Return

WSMETHOD CLONE WSCLIENT Categoria_WbtLogDTO
	Local oClone := Categoria_WbtLogDTO():NEW()
	oClone:nnCdLog              := ::nnCdLog
	oClone:nnIdRetorno          := ::nnIdRetorno
	oClone:csCdOrigem           := ::csCdOrigem
	oClone:csDsLog              := ::csDsLog
	oClone:csDsTipoDocumento    := ::csDsTipoDocumento
	oClone:csNrToken            := ::csNrToken
	oClone:ctDtLog              := ::ctDtLog
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Categoria_WbtLogDTO
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

// WSDL Data Structure CategoriaIdiomaDTO

WSSTRUCT Categoria_CategoriaIdiomaDTO
	WSDATA   csDsClasse                AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Categoria_CategoriaIdiomaDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Categoria_CategoriaIdiomaDTO
Return

WSMETHOD CLONE WSCLIENT Categoria_CategoriaIdiomaDTO
	Local oClone := Categoria_CategoriaIdiomaDTO():NEW()
	oClone:csDsClasse           := ::csDsClasse
Return oClone

WSMETHOD SOAPSEND WSCLIENT Categoria_CategoriaIdiomaDTO
	Local cSoap := ""
	cSoap += WSSoapValue("sDsClasse", ::csDsClasse, ::csDsClasse , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Categoria_CategoriaIdiomaDTO
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::csDsClasse         :=  WSAdvValue( oResponse,"_SDSCLASSE","string",NIL,NIL,NIL,"S",NIL,NIL) 
Return


