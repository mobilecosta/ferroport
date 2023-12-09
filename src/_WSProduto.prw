#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"

/*=================================================================================================================*\
|| ############################################################################################################### ||
||																	                                               ||
|| # WSDL Service WSParProduto																					 # ||
|| # WSDL Location: https://srm-hml.paradigmabs.com.br/cassi-hml/services/Produto.svc?wsdl						 # ||
||																	                                               ||
|| # Data - 26/09/2019 																							 # ||
||																	                                               ||
|| # Desc: WebService de cadastro de Produto.																	 # ||
||																	                                               ||
|| # Obs: Alterações neste arquivo podem causar funcionamento incorreto.										 # ||
||																	                                               ||
|| ############################################################################################################### ||
\*=================================================================================================================*/
User Function _MOOPOMH ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSParProduto
------------------------------------------------------------------------------- */

WSCLIENT WSParProduto

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD ProcessarProduto
	WSMETHOD RetornarProduto
	WSMETHOD RetornarProdutoPorCategoria
	WSMETHOD RetornarProdutoSemDePara
	WSMETHOD RetornarProdutoPorCodigo
	WSMETHOD RetornarProdutoPorDescricao
	WSMETHOD RetornarProdutoEmContratoPorDescricao
	WSMETHOD ProcessarDataProdutoHpf

	WSDATA   _URL                      AS String
	WSDATA   _CERT                     AS String
	WSDATA   _PRIVKEY                  AS String
	WSDATA   _PASSPHRASE               AS String
	WSDATA   _HEADOUT                  AS Array of String
	WSDATA   _COOKIES                  AS Array of String
	WSDATA   oWSlstProduto             AS Produto_ArrayOfProdutoDTO
	WSDATA   oWSProcessarProdutoResult AS Produto_RetornoDTO
	WSDATA   csCdProdutoErp            AS string
	WSDATA   oWSRetornarProdutoResult  AS Produto_ProdutoDTO
	WSDATA   csCdClasse                AS string
	WSDATA   oWSRetornarProdutoPorCategoriaResult AS Produto_ArrayOfProdutoDTO
	WSDATA   csCdEmpresa               AS string
	WSDATA   oWSRetornarProdutoSemDeParaResult AS Produto_ArrayOfProdutoDTO
	WSDATA   csCdProduto               AS string
	WSDATA   nnNrPagina                AS int
	WSDATA   oWSRetornarProdutoPorCodigoResult AS Produto_RetornoListaProdutoDTO
	WSDATA   csDsProduto               AS string
	WSDATA   csStProduto               AS string
	WSDATA   oWSRetornarProdutoPorDescricaoResult AS Produto_RetornoListaProdutoDTO
	WSDATA   oWSRetornarProdutoEmContratoPorDescricaoResult AS Produto_RetornoListaProdutoDTO
	WSDATA   oWSlstProdutoHpf          AS Produto_ArrayOfProdutoHpfDTO
	WSDATA   oWSProcessarDataProdutoHpfResult AS Produto_RetornoDTO

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSParProduto
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.131227A-20190114 NG] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSParProduto
	::oWSlstProduto      := Produto_ARRAYOFPRODUTODTO():New()
	::oWSProcessarProdutoResult := Produto_RETORNODTO():New()
	::oWSRetornarProdutoResult := Produto_PRODUTODTO():New()
	::oWSRetornarProdutoPorCategoriaResult := Produto_ARRAYOFPRODUTODTO():New()
	::oWSRetornarProdutoSemDeParaResult := Produto_ARRAYOFPRODUTODTO():New()
	::oWSRetornarProdutoPorCodigoResult := Produto_RETORNOLISTAPRODUTODTO():New()
	::oWSRetornarProdutoPorDescricaoResult := Produto_RETORNOLISTAPRODUTODTO():New()
	::oWSRetornarProdutoEmContratoPorDescricaoResult := Produto_RETORNOLISTAPRODUTODTO():New()
	::oWSlstProdutoHpf   := Produto_ARRAYOFPRODUTOHPFDTO():New()
	::oWSProcessarDataProdutoHpfResult := Produto_RETORNODTO():New()
Return

WSMETHOD RESET WSCLIENT WSParProduto
	::oWSlstProduto      := NIL 
	::oWSProcessarProdutoResult := NIL 
	::csCdProdutoErp     := NIL 
	::oWSRetornarProdutoResult := NIL 
	::csCdClasse         := NIL 
	::oWSRetornarProdutoPorCategoriaResult := NIL 
	::csCdEmpresa        := NIL 
	::oWSRetornarProdutoSemDeParaResult := NIL 
	::csCdProduto        := NIL 
	::nnNrPagina         := NIL 
	::oWSRetornarProdutoPorCodigoResult := NIL 
	::csDsProduto        := NIL 
	::csStProduto        := NIL 
	::oWSRetornarProdutoPorDescricaoResult := NIL 
	::oWSRetornarProdutoEmContratoPorDescricaoResult := NIL 
	::oWSlstProdutoHpf   := NIL 
	::oWSProcessarDataProdutoHpfResult := NIL 
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSParProduto
Local oClone := WSParProduto():New()
	oClone:_URL          := ::_URL 
	oClone:_CERT         := ::_CERT 
	oClone:_PRIVKEY      := ::_PRIVKEY 
	oClone:_PASSPHRASE   := ::_PASSPHRASE 
	oClone:oWSlstProduto :=  IIF(::oWSlstProduto = NIL , NIL ,::oWSlstProduto:Clone() )
	oClone:oWSProcessarProdutoResult :=  IIF(::oWSProcessarProdutoResult = NIL , NIL ,::oWSProcessarProdutoResult:Clone() )
	oClone:csCdProdutoErp := ::csCdProdutoErp
	oClone:oWSRetornarProdutoResult :=  IIF(::oWSRetornarProdutoResult = NIL , NIL ,::oWSRetornarProdutoResult:Clone() )
	oClone:csCdClasse    := ::csCdClasse
	oClone:oWSRetornarProdutoPorCategoriaResult :=  IIF(::oWSRetornarProdutoPorCategoriaResult = NIL , NIL ,::oWSRetornarProdutoPorCategoriaResult:Clone() )
	oClone:csCdEmpresa   := ::csCdEmpresa
	oClone:oWSRetornarProdutoSemDeParaResult :=  IIF(::oWSRetornarProdutoSemDeParaResult = NIL , NIL ,::oWSRetornarProdutoSemDeParaResult:Clone() )
	oClone:csCdProduto   := ::csCdProduto
	oClone:nnNrPagina    := ::nnNrPagina
	oClone:oWSRetornarProdutoPorCodigoResult :=  IIF(::oWSRetornarProdutoPorCodigoResult = NIL , NIL ,::oWSRetornarProdutoPorCodigoResult:Clone() )
	oClone:csDsProduto   := ::csDsProduto
	oClone:csStProduto   := ::csStProduto
	oClone:oWSRetornarProdutoPorDescricaoResult :=  IIF(::oWSRetornarProdutoPorDescricaoResult = NIL , NIL ,::oWSRetornarProdutoPorDescricaoResult:Clone() )
	oClone:oWSRetornarProdutoEmContratoPorDescricaoResult :=  IIF(::oWSRetornarProdutoEmContratoPorDescricaoResult = NIL , NIL ,::oWSRetornarProdutoEmContratoPorDescricaoResult:Clone() )
	oClone:oWSlstProdutoHpf :=  IIF(::oWSlstProdutoHpf = NIL , NIL ,::oWSlstProdutoHpf:Clone() )
	oClone:oWSProcessarDataProdutoHpfResult :=  IIF(::oWSProcessarDataProdutoHpfResult = NIL , NIL ,::oWSProcessarDataProdutoHpfResult:Clone() )
Return oClone

// WSDL Method ProcessarProduto of Service WSParProduto

WSMETHOD ProcessarProduto WSSEND oWSlstProduto WSRECEIVE oWSProcessarProdutoResult WSCLIENT WSParProduto
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ProcessarProduto xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("lstProduto", ::oWSlstProduto, oWSlstProduto , "ArrayOfProdutoDTO", .F. , .F., 0 , "http://tempuri.org/", .F.,.F.) 
cSoap += "</ProcessarProduto>"

Self:_HEADOUT := { "Authorization: Bearer " + U_NewToken() }
oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tempuri.org/IProduto/ProcessarProduto",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	Lower(AllTrim(GetMv("MV_XPARURL"))) + "/services/Produto.svc")

::Init()
::oWSProcessarProdutoResult:SoapRecv( WSAdvValue( oXmlRet,"_PROCESSARPRODUTORESPONSE:_PROCESSARPRODUTORESULT","RetornoDTO",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return {.T.,csoap}

// WSDL Method RetornarProduto of Service WSParProduto

WSMETHOD RetornarProduto WSSEND csCdProdutoErp WSRECEIVE oWSRetornarProdutoResult WSCLIENT WSParProduto
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<RetornarProduto xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("sCdProdutoErp", ::csCdProdutoErp, csCdProdutoErp , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</RetornarProduto>"

Self:_HEADOUT := { "Authorization: Bearer " + U_NewToken() }
oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tempuri.org/IProduto/RetornarProduto",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	Lower(AllTrim(GetMv("MV_XPARURL"))) + "/services/Produto.svc")

::Init()
::oWSRetornarProdutoResult:SoapRecv( WSAdvValue( oXmlRet,"_RETORNARPRODUTORESPONSE:_RETORNARPRODUTORESULT","ProdutoDTO",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method RetornarProdutoPorCategoria of Service WSParProduto

WSMETHOD RetornarProdutoPorCategoria WSSEND csCdClasse WSRECEIVE oWSRetornarProdutoPorCategoriaResult WSCLIENT WSParProduto
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<RetornarProdutoPorCategoria xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("sCdClasse", ::csCdClasse, csCdClasse , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</RetornarProdutoPorCategoria>"

Self:_HEADOUT := { "Authorization: Bearer " + U_NewToken() }
oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tempuri.org/IProduto/RetornarProdutoPorCategoria",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	Lower(AllTrim(GetMv("MV_XPARURL"))) + "/services/Produto.svc")

::Init()
::oWSRetornarProdutoPorCategoriaResult:SoapRecv( WSAdvValue( oXmlRet,"_RETORNARPRODUTOPORCATEGORIARESPONSE:_RETORNARPRODUTOPORCATEGORIARESULT","ArrayOfProdutoDTO",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method RetornarProdutoSemDePara of Service WSParProduto

WSMETHOD RetornarProdutoSemDePara WSSEND csCdEmpresa WSRECEIVE oWSRetornarProdutoSemDeParaResult WSCLIENT WSParProduto
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<RetornarProdutoSemDePara xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("sCdEmpresa", ::csCdEmpresa, csCdEmpresa , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</RetornarProdutoSemDePara>"

Self:_HEADOUT := { "Authorization: Bearer " + U_NewToken() }
oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tempuri.org/IProduto/RetornarProdutoSemDePara",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	Lower(AllTrim(GetMv("MV_XPARURL"))) + "/services/Produto.svc")

::Init()
::oWSRetornarProdutoSemDeParaResult:SoapRecv( WSAdvValue( oXmlRet,"_RETORNARPRODUTOSEMDEPARARESPONSE:_RETORNARPRODUTOSEMDEPARARESULT","ArrayOfProdutoDTO",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method RetornarProdutoPorCodigo of Service WSParProduto

WSMETHOD RetornarProdutoPorCodigo WSSEND csCdProduto,nnNrPagina WSRECEIVE oWSRetornarProdutoPorCodigoResult WSCLIENT WSParProduto
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<RetornarProdutoPorCodigo xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("sCdProduto", ::csCdProduto, csCdProduto , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("nNrPagina", ::nnNrPagina, nnNrPagina , "int", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</RetornarProdutoPorCodigo>"

Self:_HEADOUT := { "Authorization: Bearer " + U_NewToken() }
oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tempuri.org/IProduto/RetornarProdutoPorCodigo",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	Lower(AllTrim(GetMv("MV_XPARURL"))) + "/services/Produto.svc")

::Init()
::oWSRetornarProdutoPorCodigoResult:SoapRecv( WSAdvValue( oXmlRet,"_RETORNARPRODUTOPORCODIGORESPONSE:_RETORNARPRODUTOPORCODIGORESULT","RetornoListaProdutoDTO",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method RetornarProdutoPorDescricao of Service WSParProduto

WSMETHOD RetornarProdutoPorDescricao WSSEND csDsProduto,csStProduto,nnNrPagina WSRECEIVE oWSRetornarProdutoPorDescricaoResult WSCLIENT WSParProduto
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<RetornarProdutoPorDescricao xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("sDsProduto", ::csDsProduto, csDsProduto , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("sStProduto", ::csStProduto, csStProduto , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("nNrPagina", ::nnNrPagina, nnNrPagina , "int", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</RetornarProdutoPorDescricao>"

Self:_HEADOUT := { "Authorization: Bearer " + U_NewToken() }
oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tempuri.org/IProduto/RetornarProdutoPorDescricao",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	Lower(AllTrim(GetMv("MV_XPARURL"))) + "/services/Produto.svc")

::Init()
::oWSRetornarProdutoPorDescricaoResult:SoapRecv( WSAdvValue( oXmlRet,"_RETORNARPRODUTOPORDESCRICAORESPONSE:_RETORNARPRODUTOPORDESCRICAORESULT","RetornoListaProdutoDTO",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method RetornarProdutoEmContratoPorDescricao of Service WSParProduto

WSMETHOD RetornarProdutoEmContratoPorDescricao WSSEND csDsProduto,csStProduto,nnNrPagina WSRECEIVE oWSRetornarProdutoEmContratoPorDescricaoResult WSCLIENT WSParProduto
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<RetornarProdutoEmContratoPorDescricao xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("sDsProduto", ::csDsProduto, csDsProduto , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("sStProduto", ::csStProduto, csStProduto , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("nNrPagina", ::nnNrPagina, nnNrPagina , "int", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</RetornarProdutoEmContratoPorDescricao>"

Self:_HEADOUT := { "Authorization: Bearer " + U_NewToken() }
oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tempuri.org/IProduto/RetornarProdutoEmContratoPorDescricao",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	Lower(AllTrim(GetMv("MV_XPARURL"))) + "/services/Produto.svc")

::Init()
::oWSRetornarProdutoEmContratoPorDescricaoResult:SoapRecv( WSAdvValue( oXmlRet,"_RETORNARPRODUTOEMCONTRATOPORDESCRICAORESPONSE:_RETORNARPRODUTOEMCONTRATOPORDESCRICAORESULT","RetornoListaProdutoDTO",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method ProcessarDataProdutoHpf of Service WSParProduto

WSMETHOD ProcessarDataProdutoHpf WSSEND oWSlstProdutoHpf WSRECEIVE oWSProcessarDataProdutoHpfResult WSCLIENT WSParProduto
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ProcessarDataProdutoHpf xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("lstProdutoHpf", ::oWSlstProdutoHpf, oWSlstProdutoHpf , "ArrayOfProdutoHpfDTO", .F. , .F., 0 , "http://tempuri.org/", .F.,.F.) 
cSoap += "</ProcessarDataProdutoHpf>"

Self:_HEADOUT := { "Authorization: Bearer " + U_NewToken() }
oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tempuri.org/IProduto/ProcessarDataProdutoHpf",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	Lower(AllTrim(GetMv("MV_XPARURL"))) + "/services/Produto.svc")

::Init()
::oWSProcessarDataProdutoHpfResult:SoapRecv( WSAdvValue( oXmlRet,"_PROCESSARDATAPRODUTOHPFRESPONSE:_PROCESSARDATAPRODUTOHPFRESULT","RetornoDTO",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.


// WSDL Data Structure ArrayOfProdutoDTO

WSSTRUCT Produto_ArrayOfProdutoDTO
	WSDATA   oWSParProdutoDTO             AS Produto_ProdutoDTO OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Produto_ArrayOfProdutoDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Produto_ArrayOfProdutoDTO
	::oWSParProdutoDTO        := {} // Array Of  Produto_PRODUTODTO():New()
Return

WSMETHOD CLONE WSCLIENT Produto_ArrayOfProdutoDTO
	Local oClone := Produto_ArrayOfProdutoDTO():NEW()
	oClone:oWSParProdutoDTO := NIL
	If ::oWSParProdutoDTO <> NIL 
		oClone:oWSParProdutoDTO := {}
		aEval( ::oWSParProdutoDTO , { |x| aadd( oClone:oWSParProdutoDTO , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT Produto_ArrayOfProdutoDTO
	Local cSoap := ""
	aEval( ::oWSParProdutoDTO , {|x| cSoap := cSoap  +  WSSoapValue("ProdutoDTO", x , x , "ProdutoDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.)  } ) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Produto_ArrayOfProdutoDTO
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_PRODUTODTO","ProdutoDTO",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSParProdutoDTO , Produto_ProdutoDTO():New() )
			::oWSParProdutoDTO[len(::oWSParProdutoDTO)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure RetornoDTO

WSSTRUCT Produto_RetornoDTO
	WSDATA   oWSlstWbtLogDTO           AS Produto_ArrayOfWbtLogDTO OPTIONAL
	WSDATA   nnIdRetorno               AS long OPTIONAL
	WSDATA   csNrToken                 AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Produto_RetornoDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Produto_RetornoDTO
Return

WSMETHOD CLONE WSCLIENT Produto_RetornoDTO
	Local oClone := Produto_RetornoDTO():NEW()
	oClone:oWSlstWbtLogDTO      := IIF(::oWSlstWbtLogDTO = NIL , NIL , ::oWSlstWbtLogDTO:Clone() )
	oClone:nnIdRetorno          := ::nnIdRetorno
	oClone:csNrToken            := ::csNrToken
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Produto_RetornoDTO
	Local oNode1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_LSTWBTLOGDTO","ArrayOfWbtLogDTO",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode1 != NIL
		::oWSlstWbtLogDTO := Produto_ArrayOfWbtLogDTO():New()
		::oWSlstWbtLogDTO:SoapRecv(oNode1)
	EndIf
	::nnIdRetorno        :=  WSAdvValue( oResponse,"_NIDRETORNO","long",NIL,NIL,NIL,"N",NIL,NIL) 
	::csNrToken          :=  WSAdvValue( oResponse,"_SNRTOKEN","string",NIL,NIL,NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure ProdutoDTO

WSSTRUCT Produto_ProdutoDTO
	WSDATA   ndQtConsumoMedio          AS decimal OPTIONAL
	WSDATA   ndVlPeso                  AS decimal OPTIONAL
	WSDATA   oWSlstProdutoIdioma       AS Produto_ArrayOfProdutoIdiomaDTO OPTIONAL
	WSDATA   nnCdGrupoDespesaTipo      AS long OPTIONAL
	WSDATA   nnCdProdutoTipo           AS int OPTIONAL
	WSDATA   nnCdTipoSituacaoMapDestinacao AS int OPTIONAL
	WSDATA   nnSituacaoProduto         AS long OPTIONAL
	WSDATA   oWSoGrupoDespesaTipo      AS Produto_GrupoDespesaTipoDetalheDTO OPTIONAL
	WSDATA   oWSoUnidadeMedidaDetalhe  AS Produto_UnidadeMedidaDetalheDTO OPTIONAL
	WSDATA   csCdClasse                AS string OPTIONAL
	WSDATA   csCdEmpresa               AS string OPTIONAL
	WSDATA   csCdProduto               AS string OPTIONAL
	WSDATA   nsCdProdutoWBC            AS long OPTIONAL
	WSDATA   csCdUnidadeMedida         AS string OPTIONAL
	WSDATA   csDsDetalhe               AS string OPTIONAL
	WSDATA   csDsProduto               AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Produto_ProdutoDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Produto_ProdutoDTO
Return

WSMETHOD CLONE WSCLIENT Produto_ProdutoDTO
	Local oClone := Produto_ProdutoDTO():NEW()
	oClone:ndQtConsumoMedio     := ::ndQtConsumoMedio
	oClone:ndVlPeso             := ::ndVlPeso
	oClone:oWSlstProdutoIdioma  := IIF(::oWSlstProdutoIdioma = NIL , NIL , ::oWSlstProdutoIdioma:Clone() )
	oClone:nnCdGrupoDespesaTipo := ::nnCdGrupoDespesaTipo
	oClone:nnCdProdutoTipo      := ::nnCdProdutoTipo
	oClone:nnCdTipoSituacaoMapDestinacao := ::nnCdTipoSituacaoMapDestinacao
	oClone:nnSituacaoProduto    := ::nnSituacaoProduto
	oClone:oWSoGrupoDespesaTipo := IIF(::oWSoGrupoDespesaTipo = NIL , NIL , ::oWSoGrupoDespesaTipo:Clone() )
	oClone:oWSoUnidadeMedidaDetalhe := IIF(::oWSoUnidadeMedidaDetalhe = NIL , NIL , ::oWSoUnidadeMedidaDetalhe:Clone() )
	oClone:csCdClasse           := ::csCdClasse
	oClone:csCdEmpresa          := ::csCdEmpresa
	oClone:csCdProduto          := ::csCdProduto
	oClone:nsCdProdutoWBC       := ::nsCdProdutoWBC
	oClone:csCdUnidadeMedida    := ::csCdUnidadeMedida
	oClone:csDsDetalhe          := ::csDsDetalhe
	oClone:csDsProduto          := ::csDsProduto
Return oClone

WSMETHOD SOAPSEND WSCLIENT Produto_ProdutoDTO
	Local cSoap := ""
	cSoap += WSSoapValue("dQtConsumoMedio", ::ndQtConsumoMedio, ::ndQtConsumoMedio , "decimal", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("dVlPeso", ::ndVlPeso, ::ndVlPeso , "decimal", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("lstProdutoIdioma", ::oWSlstProdutoIdioma, ::oWSlstProdutoIdioma , "ArrayOfProdutoIdiomaDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("nCdGrupoDespesaTipo", ::nnCdGrupoDespesaTipo, ::nnCdGrupoDespesaTipo , "long", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("nCdProdutoTipo", ::nnCdProdutoTipo, ::nnCdProdutoTipo , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("nCdTipoSituacaoMapDestinacao", ::nnCdTipoSituacaoMapDestinacao, ::nnCdTipoSituacaoMapDestinacao , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("nSituacaoProduto", ::nnSituacaoProduto, ::nnSituacaoProduto , "long", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("oGrupoDespesaTipo", ::oWSoGrupoDespesaTipo, ::oWSoGrupoDespesaTipo , "GrupoDespesaTipoDetalheDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("oUnidadeMedidaDetalhe", ::oWSoUnidadeMedidaDetalhe, ::oWSoUnidadeMedidaDetalhe , "UnidadeMedidaDetalheDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdClasse", ::csCdClasse, ::csCdClasse , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdEmpresa", ::csCdEmpresa, ::csCdEmpresa , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdProduto", ::csCdProduto, ::csCdProduto , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdProdutoWBC", ::nsCdProdutoWBC, ::nsCdProdutoWBC , "long", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdUnidadeMedida", ::csCdUnidadeMedida, ::csCdUnidadeMedida , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sDsDetalhe", ::csDsDetalhe, ::csDsDetalhe , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sDsProduto", ::csDsProduto, ::csDsProduto , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Produto_ProdutoDTO
	Local oNode3
	Local oNode8
	Local oNode9
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::ndQtConsumoMedio   :=  WSAdvValue( oResponse,"_DQTCONSUMOMEDIO","decimal",NIL,NIL,NIL,"N",NIL,NIL) 
	::ndVlPeso           :=  WSAdvValue( oResponse,"_DVLPESO","decimal",NIL,NIL,NIL,"N",NIL,NIL) 
	oNode3 :=  WSAdvValue( oResponse,"_LSTPRODUTOIDIOMA","ArrayOfProdutoIdiomaDTO",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode3 != NIL
		::oWSlstProdutoIdioma := Produto_ArrayOfProdutoIdiomaDTO():New()
		::oWSlstProdutoIdioma:SoapRecv(oNode3)
	EndIf
	::nnCdGrupoDespesaTipo :=  WSAdvValue( oResponse,"_NCDGRUPODESPESATIPO","long",NIL,NIL,NIL,"N",NIL,NIL) 
	::nnCdProdutoTipo    :=  WSAdvValue( oResponse,"_NCDPRODUTOTIPO","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::nnCdTipoSituacaoMapDestinacao :=  WSAdvValue( oResponse,"_NCDTIPOSITUACAOMAPDESTINACAO","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::nnSituacaoProduto  :=  WSAdvValue( oResponse,"_NSITUACAOPRODUTO","long",NIL,NIL,NIL,"N",NIL,NIL) 
	oNode8 :=  WSAdvValue( oResponse,"_OGRUPODESPESATIPO","GrupoDespesaTipoDetalheDTO",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode8 != NIL
		::oWSoGrupoDespesaTipo := Produto_GrupoDespesaTipoDetalheDTO():New()
		::oWSoGrupoDespesaTipo:SoapRecv(oNode8)
	EndIf
	oNode9 :=  WSAdvValue( oResponse,"_OUNIDADEMEDIDADETALHE","UnidadeMedidaDetalheDTO",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode9 != NIL
		::oWSoUnidadeMedidaDetalhe := Produto_UnidadeMedidaDetalheDTO():New()
		::oWSoUnidadeMedidaDetalhe:SoapRecv(oNode9)
	EndIf
	::csCdClasse         :=  WSAdvValue( oResponse,"_SCDCLASSE","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdEmpresa        :=  WSAdvValue( oResponse,"_SCDEMPRESA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdProduto        :=  WSAdvValue( oResponse,"_SCDPRODUTO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::nsCdProdutoWBC     :=  WSAdvValue( oResponse,"_SCDPRODUTOWBC","long",NIL,NIL,NIL,"N",NIL,NIL) 
	::csCdUnidadeMedida  :=  WSAdvValue( oResponse,"_SCDUNIDADEMEDIDA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csDsDetalhe        :=  WSAdvValue( oResponse,"_SDSDETALHE","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csDsProduto        :=  WSAdvValue( oResponse,"_SDSPRODUTO","string",NIL,NIL,NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure RetornoListaProdutoDTO

WSSTRUCT Produto_RetornoListaProdutoDTO
	WSDATA   oWSlstObjetoRetorno       AS Produto_ArrayOfProdutoDTO OPTIONAL
	WSDATA   nnQtRegistrosRetorno      AS int OPTIONAL
	WSDATA   nnQtRegistrosTotal        AS int OPTIONAL
	WSDATA   oWSoRetornoDTO            AS Produto_RetornoDTO OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Produto_RetornoListaProdutoDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Produto_RetornoListaProdutoDTO
Return

WSMETHOD CLONE WSCLIENT Produto_RetornoListaProdutoDTO
	Local oClone := Produto_RetornoListaProdutoDTO():NEW()
	oClone:oWSlstObjetoRetorno  := IIF(::oWSlstObjetoRetorno = NIL , NIL , ::oWSlstObjetoRetorno:Clone() )
	oClone:nnQtRegistrosRetorno := ::nnQtRegistrosRetorno
	oClone:nnQtRegistrosTotal   := ::nnQtRegistrosTotal
	oClone:oWSoRetornoDTO       := IIF(::oWSoRetornoDTO = NIL , NIL , ::oWSoRetornoDTO:Clone() )
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Produto_RetornoListaProdutoDTO
	Local oNode1
	Local oNode4
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_LSTOBJETORETORNO","ArrayOfProdutoDTO",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode1 != NIL
		::oWSlstObjetoRetorno := Produto_ArrayOfProdutoDTO():New()
		::oWSlstObjetoRetorno:SoapRecv(oNode1)
	EndIf
	::nnQtRegistrosRetorno :=  WSAdvValue( oResponse,"_NQTREGISTROSRETORNO","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::nnQtRegistrosTotal :=  WSAdvValue( oResponse,"_NQTREGISTROSTOTAL","int",NIL,NIL,NIL,"N",NIL,NIL) 
	oNode4 :=  WSAdvValue( oResponse,"_ORETORNODTO","RetornoDTO",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode4 != NIL
		::oWSoRetornoDTO := Produto_RetornoDTO():New()
		::oWSoRetornoDTO:SoapRecv(oNode4)
	EndIf
Return

// WSDL Data Structure ArrayOfProdutoHpfDTO

WSSTRUCT Produto_ArrayOfProdutoHpfDTO
	WSDATA   oWSParProdutoHpfDTO          AS Produto_ProdutoHpfDTO OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Produto_ArrayOfProdutoHpfDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Produto_ArrayOfProdutoHpfDTO
	::oWSParProdutoHpfDTO     := {} // Array Of  Produto_PRODUTOHPFDTO():New()
Return

WSMETHOD CLONE WSCLIENT Produto_ArrayOfProdutoHpfDTO
	Local oClone := Produto_ArrayOfProdutoHpfDTO():NEW()
	oClone:oWSParProdutoHpfDTO := NIL
	If ::oWSParProdutoHpfDTO <> NIL 
		oClone:oWSParProdutoHpfDTO := {}
		aEval( ::oWSParProdutoHpfDTO , { |x| aadd( oClone:oWSParProdutoHpfDTO , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT Produto_ArrayOfProdutoHpfDTO
	Local cSoap := ""
	aEval( ::oWSParProdutoHpfDTO , {|x| cSoap := cSoap  +  WSSoapValue("ProdutoHpfDTO", x , x , "ProdutoHpfDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.)  } ) 
Return cSoap

// WSDL Data Structure ArrayOfWbtLogDTO

WSSTRUCT Produto_ArrayOfWbtLogDTO
	WSDATA   oWSWbtLogDTO              AS Produto_WbtLogDTO OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Produto_ArrayOfWbtLogDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Produto_ArrayOfWbtLogDTO
	::oWSWbtLogDTO         := {} // Array Of  Produto_WBTLOGDTO():New()
Return

WSMETHOD CLONE WSCLIENT Produto_ArrayOfWbtLogDTO
	Local oClone := Produto_ArrayOfWbtLogDTO():NEW()
	oClone:oWSWbtLogDTO := NIL
	If ::oWSWbtLogDTO <> NIL 
		oClone:oWSWbtLogDTO := {}
		aEval( ::oWSWbtLogDTO , { |x| aadd( oClone:oWSWbtLogDTO , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Produto_ArrayOfWbtLogDTO
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_WBTLOGDTO","WbtLogDTO",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSWbtLogDTO , Produto_WbtLogDTO():New() )
			::oWSWbtLogDTO[len(::oWSWbtLogDTO)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure ArrayOfProdutoIdiomaDTO

WSSTRUCT Produto_ArrayOfProdutoIdiomaDTO
	WSDATA   oWSParProdutoIdiomaDTO       AS Produto_ProdutoIdiomaDTO OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Produto_ArrayOfProdutoIdiomaDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Produto_ArrayOfProdutoIdiomaDTO
	::oWSParProdutoIdiomaDTO  := {} // Array Of  Produto_PRODUTOIDIOMADTO():New()
Return

WSMETHOD CLONE WSCLIENT Produto_ArrayOfProdutoIdiomaDTO
	Local oClone := Produto_ArrayOfProdutoIdiomaDTO():NEW()
	oClone:oWSParProdutoIdiomaDTO := NIL
	If ::oWSParProdutoIdiomaDTO <> NIL 
		oClone:oWSParProdutoIdiomaDTO := {}
		aEval( ::oWSParProdutoIdiomaDTO , { |x| aadd( oClone:oWSParProdutoIdiomaDTO , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT Produto_ArrayOfProdutoIdiomaDTO
	Local cSoap := ""
	aEval( ::oWSParProdutoIdiomaDTO , {|x| cSoap := cSoap  +  WSSoapValue("ProdutoIdiomaDTO", x , x , "ProdutoIdiomaDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.)  } ) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Produto_ArrayOfProdutoIdiomaDTO
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_PRODUTOIDIOMADTO","ProdutoIdiomaDTO",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSParProdutoIdiomaDTO , Produto_ProdutoIdiomaDTO():New() )
			::oWSParProdutoIdiomaDTO[len(::oWSParProdutoIdiomaDTO)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure GrupoDespesaTipoDetalheDTO

WSSTRUCT Produto_GrupoDespesaTipoDetalheDTO
	WSDATA   csDsGrupoDespesaTipo      AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Produto_GrupoDespesaTipoDetalheDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Produto_GrupoDespesaTipoDetalheDTO
Return

WSMETHOD CLONE WSCLIENT Produto_GrupoDespesaTipoDetalheDTO
	Local oClone := Produto_GrupoDespesaTipoDetalheDTO():NEW()
	oClone:csDsGrupoDespesaTipo := ::csDsGrupoDespesaTipo
Return oClone

WSMETHOD SOAPSEND WSCLIENT Produto_GrupoDespesaTipoDetalheDTO
	Local cSoap := ""
	cSoap += WSSoapValue("sDsGrupoDespesaTipo", ::csDsGrupoDespesaTipo, ::csDsGrupoDespesaTipo , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Produto_GrupoDespesaTipoDetalheDTO
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::csDsGrupoDespesaTipo :=  WSAdvValue( oResponse,"_SDSGRUPODESPESATIPO","string",NIL,NIL,NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure UnidadeMedidaDetalheDTO

WSSTRUCT Produto_UnidadeMedidaDetalheDTO
	WSDATA   csDsUnidadeMedida         AS string OPTIONAL
	WSDATA   csSgUnidadeMedida         AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Produto_UnidadeMedidaDetalheDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Produto_UnidadeMedidaDetalheDTO
Return

WSMETHOD CLONE WSCLIENT Produto_UnidadeMedidaDetalheDTO
	Local oClone := Produto_UnidadeMedidaDetalheDTO():NEW()
	oClone:csDsUnidadeMedida    := ::csDsUnidadeMedida
	oClone:csSgUnidadeMedida    := ::csSgUnidadeMedida
Return oClone

WSMETHOD SOAPSEND WSCLIENT Produto_UnidadeMedidaDetalheDTO
	Local cSoap := ""
	cSoap += WSSoapValue("sDsUnidadeMedida", ::csDsUnidadeMedida, ::csDsUnidadeMedida , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sSgUnidadeMedida", ::csSgUnidadeMedida, ::csSgUnidadeMedida , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Produto_UnidadeMedidaDetalheDTO
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::csDsUnidadeMedida  :=  WSAdvValue( oResponse,"_SDSUNIDADEMEDIDA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csSgUnidadeMedida  :=  WSAdvValue( oResponse,"_SSGUNIDADEMEDIDA","string",NIL,NIL,NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure ProdutoHpfDTO

WSSTRUCT Produto_ProdutoHpfDTO
	WSDATA   csCdEmpresa               AS string OPTIONAL
	WSDATA   csCdProduto               AS string OPTIONAL
	WSDATA   ctDtProdutoHpf            AS dateTime OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Produto_ProdutoHpfDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Produto_ProdutoHpfDTO
Return

WSMETHOD CLONE WSCLIENT Produto_ProdutoHpfDTO
	Local oClone := Produto_ProdutoHpfDTO():NEW()
	oClone:csCdEmpresa          := ::csCdEmpresa
	oClone:csCdProduto          := ::csCdProduto
	oClone:ctDtProdutoHpf       := ::ctDtProdutoHpf
Return oClone

WSMETHOD SOAPSEND WSCLIENT Produto_ProdutoHpfDTO
	Local cSoap := ""
	cSoap += WSSoapValue("sCdEmpresa", ::csCdEmpresa, ::csCdEmpresa , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdProduto", ::csCdProduto, ::csCdProduto , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("tDtProdutoHpf", ::ctDtProdutoHpf, ::ctDtProdutoHpf , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
Return cSoap

// WSDL Data Structure WbtLogDTO

WSSTRUCT Produto_WbtLogDTO
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

WSMETHOD NEW WSCLIENT Produto_WbtLogDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Produto_WbtLogDTO
Return

WSMETHOD CLONE WSCLIENT Produto_WbtLogDTO
	Local oClone := Produto_WbtLogDTO():NEW()
	oClone:nnCdLog              := ::nnCdLog
	oClone:nnIdRetorno          := ::nnIdRetorno
	oClone:csCdOrigem           := ::csCdOrigem
	oClone:csDsLog              := ::csDsLog
	oClone:csDsTipoDocumento    := ::csDsTipoDocumento
	oClone:csNrToken            := ::csNrToken
	oClone:ctDtLog              := ::ctDtLog
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Produto_WbtLogDTO
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

// WSDL Data Structure ProdutoIdiomaDTO

WSSTRUCT Produto_ProdutoIdiomaDTO
	WSDATA   csDsDetalhe               AS string OPTIONAL
	WSDATA   csDsProduto               AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Produto_ProdutoIdiomaDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Produto_ProdutoIdiomaDTO
Return

WSMETHOD CLONE WSCLIENT Produto_ProdutoIdiomaDTO
	Local oClone := Produto_ProdutoIdiomaDTO():NEW()
	oClone:csDsDetalhe          := ::csDsDetalhe
	oClone:csDsProduto          := ::csDsProduto
Return oClone

WSMETHOD SOAPSEND WSCLIENT Produto_ProdutoIdiomaDTO
	Local cSoap := ""
	cSoap += WSSoapValue("sDsDetalhe", ::csDsDetalhe, ::csDsDetalhe , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sDsProduto", ::csDsProduto, ::csDsProduto , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Produto_ProdutoIdiomaDTO
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::csDsDetalhe        :=  WSAdvValue( oResponse,"_SDSDETALHE","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csDsProduto        :=  WSAdvValue( oResponse,"_SDSPRODUTO","string",NIL,NIL,NIL,"S",NIL,NIL) 
Return


