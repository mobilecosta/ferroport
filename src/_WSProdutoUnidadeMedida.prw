#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"

/*=================================================================================================================*\
|| ############################################################################################################### ||
||																	                                               ||
|| # WSDL Service WSProdutoUnidadeMedida																		 # ||
|| # WSDL Location: https://srm-hml.paradigmabs.com.br/cassi-hml/services/ProdutoUnidadeMedida.svc?wsdl			 # ||
||																	                                               ||
|| # Data - 10/05/2019 																							 # ||
||																	                                               ||
|| # Desc: WebService de cadastro de Unidade de Medida de Produto.												 # ||
||																	                                               ||
|| # Obs: Alterações neste arquivo podem causar funcionamento incorreto.										 # ||
||																	                                               ||
|| ############################################################################################################### ||
\*=================================================================================================================*/
User Function _AFQOKFY ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSProdutoUnidadeMedida
------------------------------------------------------------------------------- */

WSCLIENT WSProdutoUnidadeMedida

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD ProcessarProdutoUnidadeMedida

	WSDATA   _URL                      AS String
	WSDATA   _CERT                     AS String
	WSDATA   _PRIVKEY                  AS String
	WSDATA   _PASSPHRASE               AS String
	WSDATA   _HEADOUT                  AS Array of String
	WSDATA   _COOKIES                  AS Array of String
	WSDATA   oWSlstProdutoUnidadeMedida AS ProdutoUnidadeMedida_ArrayOfProdutoUnidadeMedidaDTO
	WSDATA   oWSProcessarProdutoUnidadeMedidaResult AS ProdutoUnidadeMedida_RetornoDTO

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSProdutoUnidadeMedida
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.131227A-20190114 NG] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSProdutoUnidadeMedida
	::oWSlstProdutoUnidadeMedida := ProdutoUnidadeMedida_ARRAYOFPRODUTOUNIDADEMEDIDADTO():New()
	::oWSProcessarProdutoUnidadeMedidaResult := ProdutoUnidadeMedida_RETORNODTO():New()
Return

WSMETHOD RESET WSCLIENT WSProdutoUnidadeMedida
	::oWSlstProdutoUnidadeMedida := NIL 
	::oWSProcessarProdutoUnidadeMedidaResult := NIL 
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSProdutoUnidadeMedida
Local oClone := WSProdutoUnidadeMedida():New()
	oClone:_URL          := ::_URL 
	oClone:_CERT         := ::_CERT 
	oClone:_PRIVKEY      := ::_PRIVKEY 
	oClone:_PASSPHRASE   := ::_PASSPHRASE 
	oClone:oWSlstProdutoUnidadeMedida :=  IIF(::oWSlstProdutoUnidadeMedida = NIL , NIL ,::oWSlstProdutoUnidadeMedida:Clone() )
	oClone:oWSProcessarProdutoUnidadeMedidaResult :=  IIF(::oWSProcessarProdutoUnidadeMedidaResult = NIL , NIL ,::oWSProcessarProdutoUnidadeMedidaResult:Clone() )
Return oClone

// WSDL Method ProcessarProdutoUnidadeMedida of Service WSProdutoUnidadeMedida

WSMETHOD ProcessarProdutoUnidadeMedida WSSEND oWSlstProdutoUnidadeMedida WSRECEIVE oWSProcessarProdutoUnidadeMedidaResult WSCLIENT WSProdutoUnidadeMedida
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ProcessarProdutoUnidadeMedida xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("lstProdutoUnidadeMedida", ::oWSlstProdutoUnidadeMedida, oWSlstProdutoUnidadeMedida , "ArrayOfProdutoUnidadeMedidaDTO", .F. , .F., 0 , "http://tempuri.org/", .F.,.F.) 
cSoap += "</ProcessarProdutoUnidadeMedida>"

Self:_HEADOUT := { "Authorization: Bearer " + U_NewToken() }
oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tempuri.org/IProdutoUnidadeMedida/ProcessarProdutoUnidadeMedida",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	Lower(AllTrim(GetMv("MV_XPARURL"))) + "/services/ProdutoUnidadeMedida.svc")

::Init()
::oWSProcessarProdutoUnidadeMedidaResult:SoapRecv( WSAdvValue( oXmlRet,"_PROCESSARPRODUTOUNIDADEMEDIDARESPONSE:_PROCESSARPRODUTOUNIDADEMEDIDARESULT","RetornoDTO",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return {.T.,cSoap}


// WSDL Data Structure ArrayOfProdutoUnidadeMedidaDTO

WSSTRUCT ProdutoUnidadeMedida_ArrayOfProdutoUnidadeMedidaDTO
	WSDATA   oWSProdutoUnidadeMedidaDTO AS ProdutoUnidadeMedida_ProdutoUnidadeMedidaDTO OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT ProdutoUnidadeMedida_ArrayOfProdutoUnidadeMedidaDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT ProdutoUnidadeMedida_ArrayOfProdutoUnidadeMedidaDTO
	::oWSProdutoUnidadeMedidaDTO := {} // Array Of  ProdutoUnidadeMedida_PRODUTOUNIDADEMEDIDADTO():New()
Return

WSMETHOD CLONE WSCLIENT ProdutoUnidadeMedida_ArrayOfProdutoUnidadeMedidaDTO
	Local oClone := ProdutoUnidadeMedida_ArrayOfProdutoUnidadeMedidaDTO():NEW()
	oClone:oWSProdutoUnidadeMedidaDTO := NIL
	If ::oWSProdutoUnidadeMedidaDTO <> NIL 
		oClone:oWSProdutoUnidadeMedidaDTO := {}
		aEval( ::oWSProdutoUnidadeMedidaDTO , { |x| aadd( oClone:oWSProdutoUnidadeMedidaDTO , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT ProdutoUnidadeMedida_ArrayOfProdutoUnidadeMedidaDTO
	Local cSoap := ""
	aEval( ::oWSProdutoUnidadeMedidaDTO , {|x| cSoap := cSoap  +  WSSoapValue("ProdutoUnidadeMedidaDTO", x , x , "ProdutoUnidadeMedidaDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.)  } ) 
Return cSoap

// WSDL Data Structure RetornoDTO

WSSTRUCT ProdutoUnidadeMedida_RetornoDTO
	WSDATA   oWSlstWbtLogDTO           AS ProdutoUnidadeMedida_ArrayOfWbtLogDTO OPTIONAL
	WSDATA   nnIdRetorno               AS long OPTIONAL
	WSDATA   csNrToken                 AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT ProdutoUnidadeMedida_RetornoDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT ProdutoUnidadeMedida_RetornoDTO
Return

WSMETHOD CLONE WSCLIENT ProdutoUnidadeMedida_RetornoDTO
	Local oClone := ProdutoUnidadeMedida_RetornoDTO():NEW()
	oClone:oWSlstWbtLogDTO      := IIF(::oWSlstWbtLogDTO = NIL , NIL , ::oWSlstWbtLogDTO:Clone() )
	oClone:nnIdRetorno          := ::nnIdRetorno
	oClone:csNrToken            := ::csNrToken
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT ProdutoUnidadeMedida_RetornoDTO
	Local oNode1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_LSTWBTLOGDTO","ArrayOfWbtLogDTO",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode1 != NIL
		::oWSlstWbtLogDTO := ProdutoUnidadeMedida_ArrayOfWbtLogDTO():New()
		::oWSlstWbtLogDTO:SoapRecv(oNode1)
	EndIf
	::nnIdRetorno        :=  WSAdvValue( oResponse,"_NIDRETORNO","long",NIL,NIL,NIL,"N",NIL,NIL) 
	::csNrToken          :=  WSAdvValue( oResponse,"_SNRTOKEN","string",NIL,NIL,NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure ProdutoUnidadeMedidaDTO

WSSTRUCT ProdutoUnidadeMedida_ProdutoUnidadeMedidaDTO
	WSDATA   csCdProduto               AS string OPTIONAL
	WSDATA   csCdUnidadeMedida         AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT ProdutoUnidadeMedida_ProdutoUnidadeMedidaDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT ProdutoUnidadeMedida_ProdutoUnidadeMedidaDTO
Return

WSMETHOD CLONE WSCLIENT ProdutoUnidadeMedida_ProdutoUnidadeMedidaDTO
	Local oClone := ProdutoUnidadeMedida_ProdutoUnidadeMedidaDTO():NEW()
	oClone:csCdProduto          := ::csCdProduto
	oClone:csCdUnidadeMedida    := ::csCdUnidadeMedida
Return oClone

WSMETHOD SOAPSEND WSCLIENT ProdutoUnidadeMedida_ProdutoUnidadeMedidaDTO
	Local cSoap := ""
	cSoap += WSSoapValue("sCdProduto", ::csCdProduto, ::csCdProduto , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdUnidadeMedida", ::csCdUnidadeMedida, ::csCdUnidadeMedida , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
Return cSoap

// WSDL Data Structure ArrayOfWbtLogDTO

WSSTRUCT ProdutoUnidadeMedida_ArrayOfWbtLogDTO
	WSDATA   oWSWbtLogDTO              AS ProdutoUnidadeMedida_WbtLogDTO OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT ProdutoUnidadeMedida_ArrayOfWbtLogDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT ProdutoUnidadeMedida_ArrayOfWbtLogDTO
	::oWSWbtLogDTO         := {} // Array Of  ProdutoUnidadeMedida_WBTLOGDTO():New()
Return

WSMETHOD CLONE WSCLIENT ProdutoUnidadeMedida_ArrayOfWbtLogDTO
	Local oClone := ProdutoUnidadeMedida_ArrayOfWbtLogDTO():NEW()
	oClone:oWSWbtLogDTO := NIL
	If ::oWSWbtLogDTO <> NIL 
		oClone:oWSWbtLogDTO := {}
		aEval( ::oWSWbtLogDTO , { |x| aadd( oClone:oWSWbtLogDTO , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT ProdutoUnidadeMedida_ArrayOfWbtLogDTO
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_WBTLOGDTO","WbtLogDTO",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSWbtLogDTO , ProdutoUnidadeMedida_WbtLogDTO():New() )
			::oWSWbtLogDTO[len(::oWSWbtLogDTO)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure WbtLogDTO

WSSTRUCT ProdutoUnidadeMedida_WbtLogDTO
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

WSMETHOD NEW WSCLIENT ProdutoUnidadeMedida_WbtLogDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT ProdutoUnidadeMedida_WbtLogDTO
Return

WSMETHOD CLONE WSCLIENT ProdutoUnidadeMedida_WbtLogDTO
	Local oClone := ProdutoUnidadeMedida_WbtLogDTO():NEW()
	oClone:nnCdLog              := ::nnCdLog
	oClone:nnIdRetorno          := ::nnIdRetorno
	oClone:csCdOrigem           := ::csCdOrigem
	oClone:csDsLog              := ::csDsLog
	oClone:csDsTipoDocumento    := ::csDsTipoDocumento
	oClone:csNrToken            := ::csNrToken
	oClone:ctDtLog              := ::ctDtLog
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT ProdutoUnidadeMedida_WbtLogDTO
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


