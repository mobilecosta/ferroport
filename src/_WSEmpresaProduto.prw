#INCLUDE "protheus.ch"
#INCLUDE "apwebsrv.ch"

/*=================================================================================================================*\
|| ############################################################################################################### ||
||																	                                               ||
|| # WSDL Service Empresa/Produto																				 # ||
|| # WSDL Location: https://srm-hml.paradigmabs.com.br/cassi-hml/services/EmpresaProduto.svc?wsdl				 # ||
||																	                                               ||
|| # Data - 26/09/2019 																							 # ||
||																	                                               ||
|| # Desc: WebService de cadastro de Empresa/Produto.															 # ||
||																	                                               ||
|| # Obs: Alterações neste arquivo podem causar funcionamento incorreto.										 # ||
||																	                                               ||
|| ############################################################################################################### ||
\*=================================================================================================================*/
User Function _MGOFRPF ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSEmpresaProduto
------------------------------------------------------------------------------- */

WSCLIENT WSEmpresaProduto

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD ProcessarEmpresaProduto
	WSMETHOD RemoverEmpresaProduto

	WSDATA   _URL                      AS String
	WSDATA   _CERT                     AS String
	WSDATA   _PRIVKEY                  AS String
	WSDATA   _PASSPHRASE               AS String
	WSDATA   _HEADOUT                  AS Array of String
	WSDATA   _COOKIES                  AS Array of String
	WSDATA   oWSlstItemFornecedor      AS EmpresaProduto_ArrayOfEmpresaProdutoDetalheDTO
	WSDATA   oWSProcessarEmpresaProdutoResult AS EmpresaProduto_RetornoDTO
	WSDATA   oWSdto                    AS EmpresaProduto_EmpresaProdutoDetalhePesquisaDTO
	WSDATA   oWSRemoverEmpresaProdutoResult AS EmpresaProduto_RetornoDTO

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSEmpresaProduto
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.131227A-20190114 NG] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSEmpresaProduto
	::oWSlstItemFornecedor := EmpresaProduto_ARRAYOFEMPRESAPRODUTODETALHEDTO():New()
	::oWSProcessarEmpresaProdutoResult := EmpresaProduto_RETORNODTO():New()
	::oWSdto             := EmpresaProduto_EMPRESAPRODUTODETALHEPESQUISADTO():New()
	::oWSRemoverEmpresaProdutoResult := EmpresaProduto_RETORNODTO():New()
Return

WSMETHOD RESET WSCLIENT WSEmpresaProduto
	::oWSlstItemFornecedor := NIL 
	::oWSProcessarEmpresaProdutoResult := NIL 
	::oWSdto             := NIL 
	::oWSRemoverEmpresaProdutoResult := NIL 
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSEmpresaProduto
Local oClone := WSEmpresaProduto():New()
	oClone:_URL          := ::_URL 
	oClone:_CERT         := ::_CERT 
	oClone:_PRIVKEY      := ::_PRIVKEY 
	oClone:_PASSPHRASE   := ::_PASSPHRASE 
	oClone:oWSlstItemFornecedor :=  IIF(::oWSlstItemFornecedor = NIL , NIL ,::oWSlstItemFornecedor:Clone() )
	oClone:oWSProcessarEmpresaProdutoResult :=  IIF(::oWSProcessarEmpresaProdutoResult = NIL , NIL ,::oWSProcessarEmpresaProdutoResult:Clone() )
	oClone:oWSdto        :=  IIF(::oWSdto = NIL , NIL ,::oWSdto:Clone() )
	oClone:oWSRemoverEmpresaProdutoResult :=  IIF(::oWSRemoverEmpresaProdutoResult = NIL , NIL ,::oWSRemoverEmpresaProdutoResult:Clone() )
Return oClone

// WSDL Method ProcessarEmpresaProduto of Service WSEmpresaProduto

WSMETHOD ProcessarEmpresaProduto WSSEND oWSlstItemFornecedor WSRECEIVE oWSProcessarEmpresaProdutoResult WSCLIENT WSEmpresaProduto
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ProcessarEmpresaProduto xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("lstItemFornecedor", ::oWSlstItemFornecedor, oWSlstItemFornecedor , "ArrayOfEmpresaProdutoDetalheDTO", .F. , .F., 0 , "http://tempuri.org/", .F.,.F.) 
cSoap += "</ProcessarEmpresaProduto>"

Self:_HEADOUT := { "Authorization: Bearer " + U_NewToken() }
oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tempuri.org/IEmpresaProduto/ProcessarEmpresaProduto",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	Lower(AllTrim(GetMv("MV_XPARURL"))) + "/services/EmpresaProduto.svc")

::Init()
::oWSProcessarEmpresaProdutoResult:SoapRecv( WSAdvValue( oXmlRet,"_PROCESSAREMPRESAPRODUTORESPONSE:_PROCESSAREMPRESAPRODUTORESULT","RetornoDTO",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method RemoverEmpresaProduto of Service WSEmpresaProduto

WSMETHOD RemoverEmpresaProduto WSSEND oWSdto WSRECEIVE oWSRemoverEmpresaProdutoResult WSCLIENT WSEmpresaProduto
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<RemoverEmpresaProduto xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("dto", ::oWSdto, oWSdto , "EmpresaProdutoDetalhePesquisaDTO", .F. , .F., 0 , "http://tempuri.org/", .F.,.F.) 
cSoap += "</RemoverEmpresaProduto>"

Self:_HEADOUT := { "Authorization: Bearer " + U_NewToken() }
oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tempuri.org/IEmpresaProduto/RemoverEmpresaProduto",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	Lower(AllTrim(GetMv("MV_XPARURL"))) + "/services/EmpresaProduto.svc")

::Init()
::oWSRemoverEmpresaProdutoResult:SoapRecv( WSAdvValue( oXmlRet,"_REMOVEREMPRESAPRODUTORESPONSE:_REMOVEREMPRESAPRODUTORESULT","RetornoDTO",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.


// WSDL Data Structure ArrayOfEmpresaProdutoDetalheDTO

WSSTRUCT EmpresaProduto_ArrayOfEmpresaProdutoDetalheDTO
	WSDATA   oWSEmpresaProdutoDetalheDTO AS EmpresaProduto_EmpresaProdutoDetalheDTO OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT EmpresaProduto_ArrayOfEmpresaProdutoDetalheDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT EmpresaProduto_ArrayOfEmpresaProdutoDetalheDTO
	::oWSEmpresaProdutoDetalheDTO := {} // Array Of  EmpresaProduto_EMPRESAPRODUTODETALHEDTO():New()
Return

WSMETHOD CLONE WSCLIENT EmpresaProduto_ArrayOfEmpresaProdutoDetalheDTO
	Local oClone := EmpresaProduto_ArrayOfEmpresaProdutoDetalheDTO():NEW()
	oClone:oWSEmpresaProdutoDetalheDTO := NIL
	If ::oWSEmpresaProdutoDetalheDTO <> NIL 
		oClone:oWSEmpresaProdutoDetalheDTO := {}
		aEval( ::oWSEmpresaProdutoDetalheDTO , { |x| aadd( oClone:oWSEmpresaProdutoDetalheDTO , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT EmpresaProduto_ArrayOfEmpresaProdutoDetalheDTO
	Local cSoap := ""
	aEval( ::oWSEmpresaProdutoDetalheDTO , {|x| cSoap := cSoap  +  WSSoapValue("EmpresaProdutoDetalheDTO", x , x , "EmpresaProdutoDetalheDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.)  } ) 
Return cSoap

// WSDL Data Structure RetornoDTO

WSSTRUCT EmpresaProduto_RetornoDTO
	WSDATA   oWSlstWbtLogDTO           AS EmpresaProduto_ArrayOfWbtLogDTO OPTIONAL
	WSDATA   nnIdRetorno               AS long OPTIONAL
	WSDATA   csNrToken                 AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT EmpresaProduto_RetornoDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT EmpresaProduto_RetornoDTO
Return

WSMETHOD CLONE WSCLIENT EmpresaProduto_RetornoDTO
	Local oClone := EmpresaProduto_RetornoDTO():NEW()
	oClone:oWSlstWbtLogDTO      := IIF(::oWSlstWbtLogDTO = NIL , NIL , ::oWSlstWbtLogDTO:Clone() )
	oClone:nnIdRetorno          := ::nnIdRetorno
	oClone:csNrToken            := ::csNrToken
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT EmpresaProduto_RetornoDTO
	Local oNode1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_LSTWBTLOGDTO","ArrayOfWbtLogDTO",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode1 != NIL
		::oWSlstWbtLogDTO := EmpresaProduto_ArrayOfWbtLogDTO():New()
		::oWSlstWbtLogDTO:SoapRecv(oNode1)
	EndIf
	::nnIdRetorno        :=  WSAdvValue( oResponse,"_NIDRETORNO","long",NIL,NIL,NIL,"N",NIL,NIL) 
	::csNrToken          :=  WSAdvValue( oResponse,"_SNRTOKEN","string",NIL,NIL,NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure EmpresaProdutoDetalhePesquisaDTO

WSSTRUCT EmpresaProduto_EmpresaProdutoDetalhePesquisaDTO
	WSDATA   csCdComprador             AS string OPTIONAL
	WSDATA   csCdProduto               AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT EmpresaProduto_EmpresaProdutoDetalhePesquisaDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT EmpresaProduto_EmpresaProdutoDetalhePesquisaDTO
Return

WSMETHOD CLONE WSCLIENT EmpresaProduto_EmpresaProdutoDetalhePesquisaDTO
	Local oClone := EmpresaProduto_EmpresaProdutoDetalhePesquisaDTO():NEW()
	oClone:csCdComprador        := ::csCdComprador
	oClone:csCdProduto          := ::csCdProduto
Return oClone

WSMETHOD SOAPSEND WSCLIENT EmpresaProduto_EmpresaProdutoDetalhePesquisaDTO
	Local cSoap := ""
	cSoap += WSSoapValue("sCdComprador", ::csCdComprador, ::csCdComprador , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdProduto", ::csCdProduto, ::csCdProduto , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
Return cSoap

// WSDL Data Structure EmpresaProdutoDetalheDTO

WSSTRUCT EmpresaProduto_EmpresaProdutoDetalheDTO
	WSDATA   nbFlHomologado            AS int OPTIONAL
	WSDATA   ndVlConversao             AS decimal OPTIONAL
	WSDATA   nnNrDiasLeadTime          AS int OPTIONAL
	WSDATA   nnNrDiasTransitTime       AS int OPTIONAL
	WSDATA   csCdComprador             AS string OPTIONAL
	WSDATA   csCdEmpresa               AS string OPTIONAL
	WSDATA   csCdIva                   AS string OPTIONAL
	WSDATA   csCdProduto               AS string OPTIONAL
	WSDATA   csCdUnidadeFornecedor     AS string OPTIONAL
	WSDATA   csDsDescricao             AS string OPTIONAL
	WSDATA   csDsDescricaoDetalhada    AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT EmpresaProduto_EmpresaProdutoDetalheDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT EmpresaProduto_EmpresaProdutoDetalheDTO
Return

WSMETHOD CLONE WSCLIENT EmpresaProduto_EmpresaProdutoDetalheDTO
	Local oClone := EmpresaProduto_EmpresaProdutoDetalheDTO():NEW()
	oClone:nbFlHomologado       := ::nbFlHomologado
	oClone:ndVlConversao        := ::ndVlConversao
	oClone:nnNrDiasLeadTime     := ::nnNrDiasLeadTime
	oClone:nnNrDiasTransitTime  := ::nnNrDiasTransitTime
	oClone:csCdComprador        := ::csCdComprador
	oClone:csCdEmpresa          := ::csCdEmpresa
	oClone:csCdIva              := ::csCdIva
	oClone:csCdProduto          := ::csCdProduto
	oClone:csCdUnidadeFornecedor := ::csCdUnidadeFornecedor
	oClone:csDsDescricao        := ::csDsDescricao
	oClone:csDsDescricaoDetalhada := ::csDsDescricaoDetalhada
Return oClone

WSMETHOD SOAPSEND WSCLIENT EmpresaProduto_EmpresaProdutoDetalheDTO
	Local cSoap := ""
	cSoap += WSSoapValue("bFlHomologado", ::nbFlHomologado, ::nbFlHomologado , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("dVlConversao", ::ndVlConversao, ::ndVlConversao , "decimal", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("nNrDiasLeadTime", ::nnNrDiasLeadTime, ::nnNrDiasLeadTime , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("nNrDiasTransitTime", ::nnNrDiasTransitTime, ::nnNrDiasTransitTime , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdComprador", ::csCdComprador, ::csCdComprador , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdEmpresa", ::csCdEmpresa, ::csCdEmpresa , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdIva", ::csCdIva, ::csCdIva , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdProduto", ::csCdProduto, ::csCdProduto , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdUnidadeFornecedor", ::csCdUnidadeFornecedor, ::csCdUnidadeFornecedor , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sDsDescricao", ::csDsDescricao, ::csDsDescricao , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sDsDescricaoDetalhada", ::csDsDescricaoDetalhada, ::csDsDescricaoDetalhada , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
Return cSoap

// WSDL Data Structure ArrayOfWbtLogDTO

WSSTRUCT EmpresaProduto_ArrayOfWbtLogDTO
	WSDATA   oWSWbtLogDTO              AS EmpresaProduto_WbtLogDTO OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT EmpresaProduto_ArrayOfWbtLogDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT EmpresaProduto_ArrayOfWbtLogDTO
	::oWSWbtLogDTO         := {} // Array Of  EmpresaProduto_WBTLOGDTO():New()
Return

WSMETHOD CLONE WSCLIENT EmpresaProduto_ArrayOfWbtLogDTO
	Local oClone := EmpresaProduto_ArrayOfWbtLogDTO():NEW()
	oClone:oWSWbtLogDTO := NIL
	If ::oWSWbtLogDTO <> NIL 
		oClone:oWSWbtLogDTO := {}
		aEval( ::oWSWbtLogDTO , { |x| aadd( oClone:oWSWbtLogDTO , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT EmpresaProduto_ArrayOfWbtLogDTO
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_WBTLOGDTO","WbtLogDTO",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSWbtLogDTO , EmpresaProduto_WbtLogDTO():New() )
			::oWSWbtLogDTO[len(::oWSWbtLogDTO)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure WbtLogDTO

WSSTRUCT EmpresaProduto_WbtLogDTO
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

WSMETHOD NEW WSCLIENT EmpresaProduto_WbtLogDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT EmpresaProduto_WbtLogDTO
Return

WSMETHOD CLONE WSCLIENT EmpresaProduto_WbtLogDTO
	Local oClone := EmpresaProduto_WbtLogDTO():NEW()
	oClone:nnCdLog              := ::nnCdLog
	oClone:nnIdRetorno          := ::nnIdRetorno
	oClone:csCdOrigem           := ::csCdOrigem
	oClone:csDsLog              := ::csDsLog
	oClone:csDsTipoDocumento    := ::csDsTipoDocumento
	oClone:csNrToken            := ::csNrToken
	oClone:ctDtLog              := ::ctDtLog
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT EmpresaProduto_WbtLogDTO
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


