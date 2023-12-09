#INCLUDE "protheus.ch"
#INCLUDE "apwebsrv.ch"

/*=================================================================================================================*\
|| ############################################################################################################### ||
||																	                                               ||
|| # WSDL Service Natureza de Despesa																			 # ||
|| # WSDL Location: https://srm-hml.paradigmabs.com.br/cassi-hml/services/NaturezaDespesa.svc?wsdl				 # ||
||																	                                               ||
|| # Data - 26/09/2019 																							 # ||
||																	                                               ||
|| # Desc: WebService de cadastro de Natureza de Despesa.														 # ||
||																	                                               ||
|| # Obs: Alterações neste arquivo podem causar funcionamento incorreto.										 # ||
||																	                                               ||
|| ############################################################################################################### ||
\*=================================================================================================================*/
User Function _OEFQPEX ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSNaturezaDespesa
------------------------------------------------------------------------------- */

WSCLIENT WSNaturezaDespesa

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD ProcessarNaturezaDespesa
	WSMETHOD RetornarNaturezaDespesaPorProduto

	WSDATA   _URL                      AS String
	WSDATA   _CERT                     AS String
	WSDATA   _PRIVKEY                  AS String
	WSDATA   _PASSPHRASE               AS String
	WSDATA   _HEADOUT                  AS Array of String
	WSDATA   _COOKIES                  AS Array of String
	WSDATA   oWSlstNaturezaDespesa     AS NaturezaDespesa_ArrayOfNaturezaDespesaDTO
	WSDATA   oWSProcessarNaturezaDespesaResult AS NaturezaDespesa_RetornoDTO
	WSDATA   csCdProduto               AS string
	WSDATA   oWSRetornarNaturezaDespesaPorProdutoResult AS NaturezaDespesa_RetornoListaNaturezaDespesaDTO

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSNaturezaDespesa
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.131227A-20190114 NG] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSNaturezaDespesa
	::oWSlstNaturezaDespesa := NaturezaDespesa_ARRAYOFNATUREZADESPESADTO():New()
	::oWSProcessarNaturezaDespesaResult := NaturezaDespesa_RETORNODTO():New()
	::oWSRetornarNaturezaDespesaPorProdutoResult := NaturezaDespesa_RETORNOLISTANATUREZADESPESADTO():New()
Return

WSMETHOD RESET WSCLIENT WSNaturezaDespesa
	::oWSlstNaturezaDespesa := NIL 
	::oWSProcessarNaturezaDespesaResult := NIL 
	::csCdProduto        := NIL 
	::oWSRetornarNaturezaDespesaPorProdutoResult := NIL 
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSNaturezaDespesa
Local oClone := WSNaturezaDespesa():New()
	oClone:_URL          := ::_URL 
	oClone:_CERT         := ::_CERT 
	oClone:_PRIVKEY      := ::_PRIVKEY 
	oClone:_PASSPHRASE   := ::_PASSPHRASE 
	oClone:oWSlstNaturezaDespesa :=  IIF(::oWSlstNaturezaDespesa = NIL , NIL ,::oWSlstNaturezaDespesa:Clone() )
	oClone:oWSProcessarNaturezaDespesaResult :=  IIF(::oWSProcessarNaturezaDespesaResult = NIL , NIL ,::oWSProcessarNaturezaDespesaResult:Clone() )
	oClone:csCdProduto   := ::csCdProduto
	oClone:oWSRetornarNaturezaDespesaPorProdutoResult :=  IIF(::oWSRetornarNaturezaDespesaPorProdutoResult = NIL , NIL ,::oWSRetornarNaturezaDespesaPorProdutoResult:Clone() )
Return oClone

// WSDL Method ProcessarNaturezaDespesa of Service WSNaturezaDespesa

WSMETHOD ProcessarNaturezaDespesa WSSEND oWSlstNaturezaDespesa WSRECEIVE oWSProcessarNaturezaDespesaResult WSCLIENT WSNaturezaDespesa
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ProcessarNaturezaDespesa xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("lstNaturezaDespesa", ::oWSlstNaturezaDespesa, oWSlstNaturezaDespesa , "ArrayOfNaturezaDespesaDTO", .F. , .F., 0 , "http://tempuri.org/", .F.,.F.) 
cSoap += "</ProcessarNaturezaDespesa>"

Self:_HEADOUT := { "Authorization: Bearer " + U_NewToken() }
oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tempuri.org/INaturezaDespesa/ProcessarNaturezaDespesa",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	Lower(AllTrim(GetMv("MV_XPARURL"))) + "/services/NaturezaDespesa.svc")

::Init()
::oWSProcessarNaturezaDespesaResult:SoapRecv( WSAdvValue( oXmlRet,"_PROCESSARNATUREZADESPESARESPONSE:_PROCESSARNATUREZADESPESARESULT","RetornoDTO",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method RetornarNaturezaDespesaPorProduto of Service WSNaturezaDespesa

WSMETHOD RetornarNaturezaDespesaPorProduto WSSEND csCdProduto WSRECEIVE oWSRetornarNaturezaDespesaPorProdutoResult WSCLIENT WSNaturezaDespesa
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<RetornarNaturezaDespesaPorProduto xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("sCdProduto", ::csCdProduto, csCdProduto , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</RetornarNaturezaDespesaPorProduto>"

Self:_HEADOUT := { "Authorization: Bearer " + U_NewToken() }
oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tempuri.org/INaturezaDespesa/RetornarNaturezaDespesaPorProduto",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	Lower(AllTrim(GetMv("MV_XPARURL"))) + "/services/NaturezaDespesa.svc")

::Init()
::oWSRetornarNaturezaDespesaPorProdutoResult:SoapRecv( WSAdvValue( oXmlRet,"_RETORNARNATUREZADESPESAPORPRODUTORESPONSE:_RETORNARNATUREZADESPESAPORPRODUTORESULT","RetornoListaNaturezaDespesaDTO",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.


// WSDL Data Structure RetornoDTO

WSSTRUCT NaturezaDespesa_RetornoDTO
	WSDATA   oWSlstWbtLogDTO           AS NaturezaDespesa_ArrayOfWbtLogDTO OPTIONAL
	WSDATA   nnIdRetorno               AS long OPTIONAL
	WSDATA   csNrToken                 AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT NaturezaDespesa_RetornoDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT NaturezaDespesa_RetornoDTO
Return

WSMETHOD CLONE WSCLIENT NaturezaDespesa_RetornoDTO
	Local oClone := NaturezaDespesa_RetornoDTO():NEW()
	oClone:oWSlstWbtLogDTO      := IIF(::oWSlstWbtLogDTO = NIL , NIL , ::oWSlstWbtLogDTO:Clone() )
	oClone:nnIdRetorno          := ::nnIdRetorno
	oClone:csNrToken            := ::csNrToken
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT NaturezaDespesa_RetornoDTO
	Local oNode1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_LSTWBTLOGDTO","ArrayOfWbtLogDTO",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode1 != NIL
		::oWSlstWbtLogDTO := NaturezaDespesa_ArrayOfWbtLogDTO():New()
		::oWSlstWbtLogDTO:SoapRecv(oNode1)
	EndIf
	::nnIdRetorno        :=  WSAdvValue( oResponse,"_NIDRETORNO","long",NIL,NIL,NIL,"N",NIL,NIL) 
	::csNrToken          :=  WSAdvValue( oResponse,"_SNRTOKEN","string",NIL,NIL,NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure RetornoListaNaturezaDespesaDTO

WSSTRUCT NaturezaDespesa_RetornoListaNaturezaDespesaDTO
	WSDATA   oWSlstObjetoRetorno       AS NaturezaDespesa_ArrayOfNaturezaDespesaDTO OPTIONAL
	WSDATA   nnQtRegistrosRetorno      AS int OPTIONAL
	WSDATA   nnQtRegistrosTotal        AS int OPTIONAL
	WSDATA   oWSoRetornoDTO            AS NaturezaDespesa_RetornoDTO OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT NaturezaDespesa_RetornoListaNaturezaDespesaDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT NaturezaDespesa_RetornoListaNaturezaDespesaDTO
Return

WSMETHOD CLONE WSCLIENT NaturezaDespesa_RetornoListaNaturezaDespesaDTO
	Local oClone := NaturezaDespesa_RetornoListaNaturezaDespesaDTO():NEW()
	oClone:oWSlstObjetoRetorno  := IIF(::oWSlstObjetoRetorno = NIL , NIL , ::oWSlstObjetoRetorno:Clone() )
	oClone:nnQtRegistrosRetorno := ::nnQtRegistrosRetorno
	oClone:nnQtRegistrosTotal   := ::nnQtRegistrosTotal
	oClone:oWSoRetornoDTO       := IIF(::oWSoRetornoDTO = NIL , NIL , ::oWSoRetornoDTO:Clone() )
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT NaturezaDespesa_RetornoListaNaturezaDespesaDTO
	Local oNode1
	Local oNode4
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_LSTOBJETORETORNO","ArrayOfNaturezaDespesaDTO",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode1 != NIL
		::oWSlstObjetoRetorno := NaturezaDespesa_ArrayOfNaturezaDespesaDTO():New()
		::oWSlstObjetoRetorno:SoapRecv(oNode1)
	EndIf
	::nnQtRegistrosRetorno :=  WSAdvValue( oResponse,"_NQTREGISTROSRETORNO","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::nnQtRegistrosTotal :=  WSAdvValue( oResponse,"_NQTREGISTROSTOTAL","int",NIL,NIL,NIL,"N",NIL,NIL) 
	oNode4 :=  WSAdvValue( oResponse,"_ORETORNODTO","RetornoDTO",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode4 != NIL
		::oWSoRetornoDTO := NaturezaDespesa_RetornoDTO():New()
		::oWSoRetornoDTO:SoapRecv(oNode4)
	EndIf
Return

// WSDL Data Structure ArrayOfWbtLogDTO

WSSTRUCT NaturezaDespesa_ArrayOfWbtLogDTO
	WSDATA   oWSWbtLogDTO              AS NaturezaDespesa_WbtLogDTO OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT NaturezaDespesa_ArrayOfWbtLogDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT NaturezaDespesa_ArrayOfWbtLogDTO
	::oWSWbtLogDTO         := {} // Array Of  NaturezaDespesa_WBTLOGDTO():New()
Return

WSMETHOD CLONE WSCLIENT NaturezaDespesa_ArrayOfWbtLogDTO
	Local oClone := NaturezaDespesa_ArrayOfWbtLogDTO():NEW()
	oClone:oWSWbtLogDTO := NIL
	If ::oWSWbtLogDTO <> NIL 
		oClone:oWSWbtLogDTO := {}
		aEval( ::oWSWbtLogDTO , { |x| aadd( oClone:oWSWbtLogDTO , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT NaturezaDespesa_ArrayOfWbtLogDTO
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_WBTLOGDTO","WbtLogDTO",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSWbtLogDTO , NaturezaDespesa_WbtLogDTO():New() )
			::oWSWbtLogDTO[len(::oWSWbtLogDTO)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure ArrayOfNaturezaDespesaDTO

WSSTRUCT NaturezaDespesa_ArrayOfNaturezaDespesaDTO
	WSDATA   oWSNaturezaDespesaDTO     AS NaturezaDespesa_NaturezaDespesaDTO OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT NaturezaDespesa_ArrayOfNaturezaDespesaDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT NaturezaDespesa_ArrayOfNaturezaDespesaDTO
	::oWSNaturezaDespesaDTO := {} // Array Of  NaturezaDespesa_NATUREZADESPESADTO():New()
Return

WSMETHOD CLONE WSCLIENT NaturezaDespesa_ArrayOfNaturezaDespesaDTO
	Local oClone := NaturezaDespesa_ArrayOfNaturezaDespesaDTO():NEW()
	oClone:oWSNaturezaDespesaDTO := NIL
	If ::oWSNaturezaDespesaDTO <> NIL 
		oClone:oWSNaturezaDespesaDTO := {}
		aEval( ::oWSNaturezaDespesaDTO , { |x| aadd( oClone:oWSNaturezaDespesaDTO , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT NaturezaDespesa_ArrayOfNaturezaDespesaDTO
	Local cSoap := ""
	aEval( ::oWSNaturezaDespesaDTO , {|x| cSoap := cSoap  +  WSSoapValue("NaturezaDespesaDTO", x , x , "NaturezaDespesaDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.)  } ) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT NaturezaDespesa_ArrayOfNaturezaDespesaDTO
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_NATUREZADESPESADTO","NaturezaDespesaDTO",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSNaturezaDespesaDTO , NaturezaDespesa_NaturezaDespesaDTO():New() )
			::oWSNaturezaDespesaDTO[len(::oWSNaturezaDespesaDTO)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure WbtLogDTO

WSSTRUCT NaturezaDespesa_WbtLogDTO
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

WSMETHOD NEW WSCLIENT NaturezaDespesa_WbtLogDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT NaturezaDespesa_WbtLogDTO
Return

WSMETHOD CLONE WSCLIENT NaturezaDespesa_WbtLogDTO
	Local oClone := NaturezaDespesa_WbtLogDTO():NEW()
	oClone:nnCdLog              := ::nnCdLog
	oClone:nnIdRetorno          := ::nnIdRetorno
	oClone:csCdOrigem           := ::csCdOrigem
	oClone:csDsLog              := ::csDsLog
	oClone:csDsTipoDocumento    := ::csDsTipoDocumento
	oClone:csNrToken            := ::csNrToken
	oClone:ctDtLog              := ::ctDtLog
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT NaturezaDespesa_WbtLogDTO
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

// WSDL Data Structure NaturezaDespesaDTO

WSSTRUCT NaturezaDespesa_NaturezaDespesaDTO
	WSDATA   nbFlAtivo                 AS int OPTIONAL
	WSDATA   csCdCodigo                AS string OPTIONAL
	WSDATA   csCdNaturezaDespesa       AS string OPTIONAL
	WSDATA   csCdNaturezaDespesaPai    AS string OPTIONAL
	WSDATA   csDsNaturezaDespesa       AS string OPTIONAL
	WSDATA   ctDtFimVigencia           AS dateTime OPTIONAL
	WSDATA   ctDtInicioVigencia        AS dateTime OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT NaturezaDespesa_NaturezaDespesaDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT NaturezaDespesa_NaturezaDespesaDTO
Return

WSMETHOD CLONE WSCLIENT NaturezaDespesa_NaturezaDespesaDTO
	Local oClone := NaturezaDespesa_NaturezaDespesaDTO():NEW()
	oClone:nbFlAtivo            := ::nbFlAtivo
	oClone:csCdCodigo           := ::csCdCodigo
	oClone:csCdNaturezaDespesa  := ::csCdNaturezaDespesa
	oClone:csCdNaturezaDespesaPai := ::csCdNaturezaDespesaPai
	oClone:csDsNaturezaDespesa  := ::csDsNaturezaDespesa
	oClone:ctDtFimVigencia      := ::ctDtFimVigencia
	oClone:ctDtInicioVigencia   := ::ctDtInicioVigencia
Return oClone

WSMETHOD SOAPSEND WSCLIENT NaturezaDespesa_NaturezaDespesaDTO
	Local cSoap := ""
	cSoap += WSSoapValue("bFlAtivo", ::nbFlAtivo, ::nbFlAtivo , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdCodigo", ::csCdCodigo, ::csCdCodigo , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdNaturezaDespesa", ::csCdNaturezaDespesa, ::csCdNaturezaDespesa , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdNaturezaDespesaPai", ::csCdNaturezaDespesaPai, ::csCdNaturezaDespesaPai , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sDsNaturezaDespesa", ::csDsNaturezaDespesa, ::csDsNaturezaDespesa , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("tDtFimVigencia", ::ctDtFimVigencia, ::ctDtFimVigencia , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("tDtInicioVigencia", ::ctDtInicioVigencia, ::ctDtInicioVigencia , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT NaturezaDespesa_NaturezaDespesaDTO
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::nbFlAtivo          :=  WSAdvValue( oResponse,"_BFLATIVO","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::csCdCodigo         :=  WSAdvValue( oResponse,"_SCDCODIGO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdNaturezaDespesa :=  WSAdvValue( oResponse,"_SCDNATUREZADESPESA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdNaturezaDespesaPai :=  WSAdvValue( oResponse,"_SCDNATUREZADESPESAPAI","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csDsNaturezaDespesa :=  WSAdvValue( oResponse,"_SDSNATUREZADESPESA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::ctDtFimVigencia    :=  WSAdvValue( oResponse,"_TDTFIMVIGENCIA","dateTime",NIL,NIL,NIL,"S",NIL,NIL) 
	::ctDtInicioVigencia :=  WSAdvValue( oResponse,"_TDTINICIOVIGENCIA","dateTime",NIL,NIL,NIL,"S",NIL,NIL) 
Return


