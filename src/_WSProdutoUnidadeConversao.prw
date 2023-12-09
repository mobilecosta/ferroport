#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"

/*=================================================================================================================*\
|| ############################################################################################################### ||
||																	                                               ||
|| # WSDL Service WSProdutoUnidadeConversao																		 # ||
|| # WSDL Location: https://srm-hml.paradigmabs.com.br/cassi-hml/services/ProdutoUnidadeConversao.svc?wsdl		 # ||
||																	                                               ||
|| # Data - 26/09/2019 																							 # ||
||																	                                               ||
|| # Desc: WebService de cadastro de Unidade de Conversão de Produto.											 # ||
||																	                                               ||
|| # Obs: Alterações neste arquivo podem causar funcionamento incorreto.										 # ||
||																	                                               ||
|| ############################################################################################################### ||
\*=================================================================================================================*/
User Function _FMJLMRH ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSProdutoUnidadeConversao
------------------------------------------------------------------------------- */

WSCLIENT WSProdutoUnidadeConversao

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD ProcessarProdutoUnidadeConversao

	WSDATA   _URL                      AS String
	WSDATA   _CERT                     AS String
	WSDATA   _PRIVKEY                  AS String
	WSDATA   _PASSPHRASE               AS String
	WSDATA   _HEADOUT                  AS Array of String
	WSDATA   _COOKIES                  AS Array of String
	WSDATA   oWSlstProdutoUnidadeConversao AS ProdutoUnidadeConversao_ArrayOfProdutoUnidadeConversaoDTO
	WSDATA   oWSProcessarProdutoUnidadeConversaoResult AS ProdutoUnidadeConversao_RetornoDTO

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSProdutoUnidadeConversao
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.131227A-20190114 NG] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSProdutoUnidadeConversao
	::oWSlstProdutoUnidadeConversao := ProdutoUnidadeConversao_ARRAYOFPRODUTOUNIDADECONVERSAODTO():New()
	::oWSProcessarProdutoUnidadeConversaoResult := ProdutoUnidadeConversao_RETORNODTO():New()
Return

WSMETHOD RESET WSCLIENT WSProdutoUnidadeConversao
	::oWSlstProdutoUnidadeConversao := NIL 
	::oWSProcessarProdutoUnidadeConversaoResult := NIL 
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSProdutoUnidadeConversao
Local oClone := WSProdutoUnidadeConversao():New()
	oClone:_URL          := ::_URL 
	oClone:_CERT         := ::_CERT 
	oClone:_PRIVKEY      := ::_PRIVKEY 
	oClone:_PASSPHRASE   := ::_PASSPHRASE 
	oClone:oWSlstProdutoUnidadeConversao :=  IIF(::oWSlstProdutoUnidadeConversao = NIL , NIL ,::oWSlstProdutoUnidadeConversao:Clone() )
	oClone:oWSProcessarProdutoUnidadeConversaoResult :=  IIF(::oWSProcessarProdutoUnidadeConversaoResult = NIL , NIL ,::oWSProcessarProdutoUnidadeConversaoResult:Clone() )
Return oClone

// WSDL Method ProcessarProdutoUnidadeConversao of Service WSProdutoUnidadeConversao

WSMETHOD ProcessarProdutoUnidadeConversao WSSEND oWSlstProdutoUnidadeConversao WSRECEIVE oWSProcessarProdutoUnidadeConversaoResult WSCLIENT WSProdutoUnidadeConversao
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ProcessarProdutoUnidadeConversao xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("lstProdutoUnidadeConversao", ::oWSlstProdutoUnidadeConversao, oWSlstProdutoUnidadeConversao , "ArrayOfProdutoUnidadeConversaoDTO", .F. , .F., 0 , "http://tempuri.org/", .F.,.F.) 
cSoap += "</ProcessarProdutoUnidadeConversao>"

Self:_HEADOUT := { "Authorization: Bearer " + U_NewToken() }
oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tempuri.org/IProdutoUnidadeConversao/ProcessarProdutoUnidadeConversao",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	Lower(AllTrim(GetMv("MV_XPARURL"))) + "/services/ProdutoUnidadeConversao.svc")

::Init()
::oWSProcessarProdutoUnidadeConversaoResult:SoapRecv( WSAdvValue( oXmlRet,"_PROCESSARPRODUTOUNIDADECONVERSAORESPONSE:_PROCESSARPRODUTOUNIDADECONVERSAORESULT","RetornoDTO",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.


// WSDL Data Structure ArrayOfProdutoUnidadeConversaoDTO

WSSTRUCT ProdutoUnidadeConversao_ArrayOfProdutoUnidadeConversaoDTO
	WSDATA   oWSProdutoUnidadeConversaoDTO AS ProdutoUnidadeConversao_ProdutoUnidadeConversaoDTO OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT ProdutoUnidadeConversao_ArrayOfProdutoUnidadeConversaoDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT ProdutoUnidadeConversao_ArrayOfProdutoUnidadeConversaoDTO
	::oWSProdutoUnidadeConversaoDTO := {} // Array Of  ProdutoUnidadeConversao_PRODUTOUNIDADECONVERSAODTO():New()
Return

WSMETHOD CLONE WSCLIENT ProdutoUnidadeConversao_ArrayOfProdutoUnidadeConversaoDTO
	Local oClone := ProdutoUnidadeConversao_ArrayOfProdutoUnidadeConversaoDTO():NEW()
	oClone:oWSProdutoUnidadeConversaoDTO := NIL
	If ::oWSProdutoUnidadeConversaoDTO <> NIL 
		oClone:oWSProdutoUnidadeConversaoDTO := {}
		aEval( ::oWSProdutoUnidadeConversaoDTO , { |x| aadd( oClone:oWSProdutoUnidadeConversaoDTO , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT ProdutoUnidadeConversao_ArrayOfProdutoUnidadeConversaoDTO
	Local cSoap := ""
	aEval( ::oWSProdutoUnidadeConversaoDTO , {|x| cSoap := cSoap  +  WSSoapValue("ProdutoUnidadeConversaoDTO", x , x , "ProdutoUnidadeConversaoDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.)  } ) 
Return cSoap

// WSDL Data Structure RetornoDTO

WSSTRUCT ProdutoUnidadeConversao_RetornoDTO
	WSDATA   oWSlstWbtLogDTO           AS ProdutoUnidadeConversao_ArrayOfWbtLogDTO OPTIONAL
	WSDATA   nnIdRetorno               AS long OPTIONAL
	WSDATA   csNrToken                 AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT ProdutoUnidadeConversao_RetornoDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT ProdutoUnidadeConversao_RetornoDTO
Return

WSMETHOD CLONE WSCLIENT ProdutoUnidadeConversao_RetornoDTO
	Local oClone := ProdutoUnidadeConversao_RetornoDTO():NEW()
	oClone:oWSlstWbtLogDTO      := IIF(::oWSlstWbtLogDTO = NIL , NIL , ::oWSlstWbtLogDTO:Clone() )
	oClone:nnIdRetorno          := ::nnIdRetorno
	oClone:csNrToken            := ::csNrToken
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT ProdutoUnidadeConversao_RetornoDTO
	Local oNode1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_LSTWBTLOGDTO","ArrayOfWbtLogDTO",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode1 != NIL
		::oWSlstWbtLogDTO := ProdutoUnidadeConversao_ArrayOfWbtLogDTO():New()
		::oWSlstWbtLogDTO:SoapRecv(oNode1)
	EndIf
	::nnIdRetorno        :=  WSAdvValue( oResponse,"_NIDRETORNO","long",NIL,NIL,NIL,"N",NIL,NIL) 
	::csNrToken          :=  WSAdvValue( oResponse,"_SNRTOKEN","string",NIL,NIL,NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure ProdutoUnidadeConversaoDTO

WSSTRUCT ProdutoUnidadeConversao_ProdutoUnidadeConversaoDTO
	WSDATA   ndQtConversao             AS decimal OPTIONAL
	WSDATA   csCdProduto               AS string OPTIONAL
	WSDATA   csCdUnidadeMedidaDestino  AS string OPTIONAL
	WSDATA   csCdUnidadeMedidaOrigem   AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT ProdutoUnidadeConversao_ProdutoUnidadeConversaoDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT ProdutoUnidadeConversao_ProdutoUnidadeConversaoDTO
Return

WSMETHOD CLONE WSCLIENT ProdutoUnidadeConversao_ProdutoUnidadeConversaoDTO
	Local oClone := ProdutoUnidadeConversao_ProdutoUnidadeConversaoDTO():NEW()
	oClone:ndQtConversao        := ::ndQtConversao
	oClone:csCdProduto          := ::csCdProduto
	oClone:csCdUnidadeMedidaDestino := ::csCdUnidadeMedidaDestino
	oClone:csCdUnidadeMedidaOrigem := ::csCdUnidadeMedidaOrigem
Return oClone

WSMETHOD SOAPSEND WSCLIENT ProdutoUnidadeConversao_ProdutoUnidadeConversaoDTO
	Local cSoap := ""
	cSoap += WSSoapValue("dQtConversao", ::ndQtConversao, ::ndQtConversao , "decimal", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdProduto", ::csCdProduto, ::csCdProduto , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdUnidadeMedidaDestino", ::csCdUnidadeMedidaDestino, ::csCdUnidadeMedidaDestino , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdUnidadeMedidaOrigem", ::csCdUnidadeMedidaOrigem, ::csCdUnidadeMedidaOrigem , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
Return cSoap

// WSDL Data Structure ArrayOfWbtLogDTO

WSSTRUCT ProdutoUnidadeConversao_ArrayOfWbtLogDTO
	WSDATA   oWSWbtLogDTO              AS ProdutoUnidadeConversao_WbtLogDTO OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT ProdutoUnidadeConversao_ArrayOfWbtLogDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT ProdutoUnidadeConversao_ArrayOfWbtLogDTO
	::oWSWbtLogDTO         := {} // Array Of  ProdutoUnidadeConversao_WBTLOGDTO():New()
Return

WSMETHOD CLONE WSCLIENT ProdutoUnidadeConversao_ArrayOfWbtLogDTO
	Local oClone := ProdutoUnidadeConversao_ArrayOfWbtLogDTO():NEW()
	oClone:oWSWbtLogDTO := NIL
	If ::oWSWbtLogDTO <> NIL 
		oClone:oWSWbtLogDTO := {}
		aEval( ::oWSWbtLogDTO , { |x| aadd( oClone:oWSWbtLogDTO , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT ProdutoUnidadeConversao_ArrayOfWbtLogDTO
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_WBTLOGDTO","WbtLogDTO",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSWbtLogDTO , ProdutoUnidadeConversao_WbtLogDTO():New() )
			::oWSWbtLogDTO[len(::oWSWbtLogDTO)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure WbtLogDTO

WSSTRUCT ProdutoUnidadeConversao_WbtLogDTO
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

WSMETHOD NEW WSCLIENT ProdutoUnidadeConversao_WbtLogDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT ProdutoUnidadeConversao_WbtLogDTO
Return

WSMETHOD CLONE WSCLIENT ProdutoUnidadeConversao_WbtLogDTO
	Local oClone := ProdutoUnidadeConversao_WbtLogDTO():NEW()
	oClone:nnCdLog              := ::nnCdLog
	oClone:nnIdRetorno          := ::nnIdRetorno
	oClone:csCdOrigem           := ::csCdOrigem
	oClone:csDsLog              := ::csDsLog
	oClone:csDsTipoDocumento    := ::csDsTipoDocumento
	oClone:csNrToken            := ::csNrToken
	oClone:ctDtLog              := ::ctDtLog
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT ProdutoUnidadeConversao_WbtLogDTO
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


