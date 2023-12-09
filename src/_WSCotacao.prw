#INCLUDE "protheus.ch"
#INCLUDE "apwebsrv.ch"

/*=================================================================================================================*\
|| ############################################################################################################### ||
||																	                                               ||
|| # WSDL Service Cotacao																						 # ||
|| # WSDL Location: https://srm-hml.paradigmabs.com.br/cassi-hml/services/Cotacao.svc?wsdl						 # ||
||																	                                               ||
|| # Data - 26/09/2019 																							 # ||
||																	                                               ||
|| # Desc: WebService de cadastro de Cotacao.																	 # ||
||																	                                               ||
|| # Obs: Alterações neste arquivo podem causar funcionamento incorreto.										 # ||
||																	                                               ||
|| ############################################################################################################### ||
\*=================================================================================================================*/
User Function _KKQHLUJ ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSCotacao
------------------------------------------------------------------------------- */

WSCLIENT WSCotacao

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD ProcessarCotacao
	WSMETHOD RetornarCotacao
	WSMETHOD RetornarCotacaoItem
	WSMETHOD RetornarCotacaoOrcamento
	WSMETHOD ReabrirCotacao
	WSMETHOD HabilitarRetornarCotacao
	WSMETHOD ReabrirCotacaoItem
	WSMETHOD HabilitarRetornarCotacaoItem
	WSMETHOD RetornarCotacaoComEmpresaSemDePara
	WSMETHOD HabilitarRetornarCotacaoPorEmpresa

	WSDATA   _URL                      AS String
	WSDATA   _CERT                     AS String
	WSDATA   _PRIVKEY                  AS String
	WSDATA   _PASSPHRASE               AS String
	WSDATA   _HEADOUT                  AS Array of String
	WSDATA   _COOKIES                  AS Array of String
	WSDATA   oWSlstCotacao             AS Cotacao_ArrayOfCotacaoDTO
	WSDATA   oWSProcessarCotacaoResult AS Cotacao_RetornoDTO
	WSDATA   oWSRetornarCotacaoResult  AS Cotacao_ArrayOfCotacaoDTO
	WSDATA   oWSRetornarCotacaoItemResult AS Cotacao_ArrayOfCotacaoDTO
	WSDATA   oWSRetornarCotacaoOrcamentoResult AS Cotacao_ArrayOfCotacaoDTO
	WSDATA   oWSlstConfirmacaoNegociacaoDTO AS Cotacao_ArrayOfConfirmacaoNegociacaoDTO
	WSDATA   oWSReabrirCotacaoResult   AS Cotacao_RetornoDTO
	WSDATA   oWSHabilitarRetornarCotacaoResult AS Cotacao_RetornoDTO
	WSDATA   oWSReabrirCotacaoItemResult AS Cotacao_RetornoDTO
	WSDATA   oWSHabilitarRetornarCotacaoItemResult AS Cotacao_RetornoDTO
	WSDATA   nnFlParticipa             AS int
	WSDATA   oWSRetornarCotacaoComEmpresaSemDeParaResult AS Cotacao_ArrayOfProcessoCotacaoDTO
	WSDATA   oWSHabilitarRetornarCotacaoPorEmpresaResult AS Cotacao_RetornoDTO

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSCotacao
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.131227A-20190114 NG] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSCotacao
	::oWSlstCotacao      := Cotacao_ARRAYOFCOTACAODTO():New()
	::oWSProcessarCotacaoResult := Cotacao_RETORNODTO():New()
	::oWSRetornarCotacaoResult := Cotacao_ARRAYOFCOTACAODTO():New()
	::oWSRetornarCotacaoItemResult := Cotacao_ARRAYOFCOTACAODTO():New()
	::oWSRetornarCotacaoOrcamentoResult := Cotacao_ARRAYOFCOTACAODTO():New()
	::oWSlstConfirmacaoNegociacaoDTO := Cotacao_ARRAYOFCONFIRMACAONEGOCIACAODTO():New()
	::oWSReabrirCotacaoResult := Cotacao_RETORNODTO():New()
	::oWSHabilitarRetornarCotacaoResult := Cotacao_RETORNODTO():New()
	::oWSReabrirCotacaoItemResult := Cotacao_RETORNODTO():New()
	::oWSHabilitarRetornarCotacaoItemResult := Cotacao_RETORNODTO():New()
	::oWSRetornarCotacaoComEmpresaSemDeParaResult := Cotacao_ARRAYOFPROCESSOCOTACAODTO():New()
	::oWSHabilitarRetornarCotacaoPorEmpresaResult := Cotacao_RETORNODTO():New()
Return

WSMETHOD RESET WSCLIENT WSCotacao
	::oWSlstCotacao      := NIL 
	::oWSProcessarCotacaoResult := NIL 
	::oWSRetornarCotacaoResult := NIL 
	::oWSRetornarCotacaoItemResult := NIL 
	::oWSRetornarCotacaoOrcamentoResult := NIL 
	::oWSlstConfirmacaoNegociacaoDTO := NIL 
	::oWSReabrirCotacaoResult := NIL 
	::oWSHabilitarRetornarCotacaoResult := NIL 
	::oWSReabrirCotacaoItemResult := NIL 
	::oWSHabilitarRetornarCotacaoItemResult := NIL 
	::nnFlParticipa      := NIL 
	::oWSRetornarCotacaoComEmpresaSemDeParaResult := NIL 
	::oWSHabilitarRetornarCotacaoPorEmpresaResult := NIL 
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSCotacao
Local oClone := WSCotacao():New()
	oClone:_URL          := ::_URL 
	oClone:_CERT         := ::_CERT 
	oClone:_PRIVKEY      := ::_PRIVKEY 
	oClone:_PASSPHRASE   := ::_PASSPHRASE 
	oClone:oWSlstCotacao :=  IIF(::oWSlstCotacao = NIL , NIL ,::oWSlstCotacao:Clone() )
	oClone:oWSProcessarCotacaoResult :=  IIF(::oWSProcessarCotacaoResult = NIL , NIL ,::oWSProcessarCotacaoResult:Clone() )
	oClone:oWSRetornarCotacaoResult :=  IIF(::oWSRetornarCotacaoResult = NIL , NIL ,::oWSRetornarCotacaoResult:Clone() )
	oClone:oWSRetornarCotacaoItemResult :=  IIF(::oWSRetornarCotacaoItemResult = NIL , NIL ,::oWSRetornarCotacaoItemResult:Clone() )
	oClone:oWSRetornarCotacaoOrcamentoResult :=  IIF(::oWSRetornarCotacaoOrcamentoResult = NIL , NIL ,::oWSRetornarCotacaoOrcamentoResult:Clone() )
	oClone:oWSlstConfirmacaoNegociacaoDTO :=  IIF(::oWSlstConfirmacaoNegociacaoDTO = NIL , NIL ,::oWSlstConfirmacaoNegociacaoDTO:Clone() )
	oClone:oWSReabrirCotacaoResult :=  IIF(::oWSReabrirCotacaoResult = NIL , NIL ,::oWSReabrirCotacaoResult:Clone() )
	oClone:oWSHabilitarRetornarCotacaoResult :=  IIF(::oWSHabilitarRetornarCotacaoResult = NIL , NIL ,::oWSHabilitarRetornarCotacaoResult:Clone() )
	oClone:oWSReabrirCotacaoItemResult :=  IIF(::oWSReabrirCotacaoItemResult = NIL , NIL ,::oWSReabrirCotacaoItemResult:Clone() )
	oClone:oWSHabilitarRetornarCotacaoItemResult :=  IIF(::oWSHabilitarRetornarCotacaoItemResult = NIL , NIL ,::oWSHabilitarRetornarCotacaoItemResult:Clone() )
	oClone:nnFlParticipa := ::nnFlParticipa
	oClone:oWSRetornarCotacaoComEmpresaSemDeParaResult :=  IIF(::oWSRetornarCotacaoComEmpresaSemDeParaResult = NIL , NIL ,::oWSRetornarCotacaoComEmpresaSemDeParaResult:Clone() )
	oClone:oWSHabilitarRetornarCotacaoPorEmpresaResult :=  IIF(::oWSHabilitarRetornarCotacaoPorEmpresaResult = NIL , NIL ,::oWSHabilitarRetornarCotacaoPorEmpresaResult:Clone() )
Return oClone

// WSDL Method ProcessarCotacao of Service WSCotacao

WSMETHOD ProcessarCotacao WSSEND oWSlstCotacao WSRECEIVE oWSProcessarCotacaoResult WSCLIENT WSCotacao
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ProcessarCotacao xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("lstCotacao", ::oWSlstCotacao, oWSlstCotacao , "ArrayOfCotacaoDTO", .F. , .F., 0 , "http://tempuri.org/", .F.,.F.) 
cSoap += "</ProcessarCotacao>"

Self:_HEADOUT := { "Authorization: Bearer " + U_NewToken() }
oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tempuri.org/ICotacao/ProcessarCotacao",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	Lower(AllTrim(GetMv("MV_XPARURL"))) + "/services/Cotacao.svc")

::Init()
::oWSProcessarCotacaoResult:SoapRecv( WSAdvValue( oXmlRet,"_PROCESSARCOTACAORESPONSE:_PROCESSARCOTACAORESULT","RetornoDTO",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method RetornarCotacao of Service WSCotacao

WSMETHOD RetornarCotacao WSSEND NULLPARAM WSRECEIVE oWSRetornarCotacaoResult WSCLIENT WSCotacao
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<RetornarCotacao xmlns="http://tempuri.org/">'
cSoap += "</RetornarCotacao>"

Self:_HEADOUT := { "Authorization: Bearer " + U_NewToken() }
oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tempuri.org/ICotacao/RetornarCotacao",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	Lower(AllTrim(GetMv("MV_XPARURL"))) + "/services/Cotacao.svc")

::Init()
::oWSRetornarCotacaoResult:SoapRecv( WSAdvValue( oXmlRet,"_RETORNARCOTACAORESPONSE:_RETORNARCOTACAORESULT","ArrayOfCotacaoDTO",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method RetornarCotacaoItem of Service WSCotacao

WSMETHOD RetornarCotacaoItem WSSEND NULLPARAM WSRECEIVE oWSRetornarCotacaoItemResult WSCLIENT WSCotacao
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<RetornarCotacaoItem xmlns="http://tempuri.org/">'
cSoap += "</RetornarCotacaoItem>"

Self:_HEADOUT := { "Authorization: Bearer " + U_NewToken() }
oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tempuri.org/ICotacao/RetornarCotacaoItem",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	Lower(AllTrim(GetMv("MV_XPARURL"))) + "/services/Cotacao.svc")

::Init()
::oWSRetornarCotacaoItemResult:SoapRecv( WSAdvValue( oXmlRet,"_RETORNARCOTACAOITEMRESPONSE:_RETORNARCOTACAOITEMRESULT","ArrayOfCotacaoDTO",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method RetornarCotacaoOrcamento of Service WSCotacao

WSMETHOD RetornarCotacaoOrcamento WSSEND NULLPARAM WSRECEIVE oWSRetornarCotacaoOrcamentoResult WSCLIENT WSCotacao
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<RetornarCotacaoOrcamento xmlns="http://tempuri.org/">'
cSoap += "</RetornarCotacaoOrcamento>"

Self:_HEADOUT := { "Authorization: Bearer " + U_NewToken() }
oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tempuri.org/ICotacao/RetornarCotacaoOrcamento",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	Lower(AllTrim(GetMv("MV_XPARURL"))) + "/services/Cotacao.svc")

::Init()
::oWSRetornarCotacaoOrcamentoResult:SoapRecv( WSAdvValue( oXmlRet,"_RETORNARCOTACAOORCAMENTORESPONSE:_RETORNARCOTACAOORCAMENTORESULT","ArrayOfCotacaoDTO",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method ReabrirCotacao of Service WSCotacao

WSMETHOD ReabrirCotacao WSSEND oWSlstConfirmacaoNegociacaoDTO WSRECEIVE oWSReabrirCotacaoResult WSCLIENT WSCotacao
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ReabrirCotacao xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("lstConfirmacaoNegociacaoDTO", ::oWSlstConfirmacaoNegociacaoDTO, oWSlstConfirmacaoNegociacaoDTO , "ArrayOfConfirmacaoNegociacaoDTO", .F. , .F., 0 , "http://tempuri.org/", .F.,.F.) 
cSoap += "</ReabrirCotacao>"

Self:_HEADOUT := { "Authorization: Bearer " + U_NewToken() }
oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tempuri.org/ICotacao/ReabrirCotacao",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	Lower(AllTrim(GetMv("MV_XPARURL"))) + "/services/Cotacao.svc")

::Init()
::oWSReabrirCotacaoResult:SoapRecv( WSAdvValue( oXmlRet,"_REABRIRCOTACAORESPONSE:_REABRIRCOTACAORESULT","RetornoDTO",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method HabilitarRetornarCotacao of Service WSCotacao

WSMETHOD HabilitarRetornarCotacao WSSEND oWSlstConfirmacaoNegociacaoDTO WSRECEIVE oWSHabilitarRetornarCotacaoResult WSCLIENT WSCotacao
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<HabilitarRetornarCotacao xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("lstConfirmacaoNegociacaoDTO", ::oWSlstConfirmacaoNegociacaoDTO, oWSlstConfirmacaoNegociacaoDTO , "ArrayOfConfirmacaoNegociacaoDTO", .F. , .F., 0 , "http://tempuri.org/", .F.,.F.) 
cSoap += "</HabilitarRetornarCotacao>"

Self:_HEADOUT := { "Authorization: Bearer " + U_NewToken() }
oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tempuri.org/ICotacao/HabilitarRetornarCotacao",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	Lower(AllTrim(GetMv("MV_XPARURL"))) + "/services/Cotacao.svc")

::Init()
::oWSHabilitarRetornarCotacaoResult:SoapRecv( WSAdvValue( oXmlRet,"_HABILITARRETORNARCOTACAORESPONSE:_HABILITARRETORNARCOTACAORESULT","RetornoDTO",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method ReabrirCotacaoItem of Service WSCotacao

WSMETHOD ReabrirCotacaoItem WSSEND oWSlstConfirmacaoNegociacaoDTO WSRECEIVE oWSReabrirCotacaoItemResult WSCLIENT WSCotacao
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ReabrirCotacaoItem xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("lstConfirmacaoNegociacaoDTO", ::oWSlstConfirmacaoNegociacaoDTO, oWSlstConfirmacaoNegociacaoDTO , "ArrayOfConfirmacaoNegociacaoDTO", .F. , .F., 0 , "http://tempuri.org/", .F.,.F.) 
cSoap += "</ReabrirCotacaoItem>"

Self:_HEADOUT := { "Authorization: Bearer " + U_NewToken() }
oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tempuri.org/ICotacao/ReabrirCotacaoItem",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	Lower(AllTrim(GetMv("MV_XPARURL"))) + "/services/Cotacao.svc")

::Init()
::oWSReabrirCotacaoItemResult:SoapRecv( WSAdvValue( oXmlRet,"_REABRIRCOTACAOITEMRESPONSE:_REABRIRCOTACAOITEMRESULT","RetornoDTO",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method HabilitarRetornarCotacaoItem of Service WSCotacao

WSMETHOD HabilitarRetornarCotacaoItem WSSEND oWSlstConfirmacaoNegociacaoDTO WSRECEIVE oWSHabilitarRetornarCotacaoItemResult WSCLIENT WSCotacao
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<HabilitarRetornarCotacaoItem xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("lstConfirmacaoNegociacaoDTO", ::oWSlstConfirmacaoNegociacaoDTO, oWSlstConfirmacaoNegociacaoDTO , "ArrayOfConfirmacaoNegociacaoDTO", .F. , .F., 0 , "http://tempuri.org/", .F.,.F.) 
cSoap += "</HabilitarRetornarCotacaoItem>"

Self:_HEADOUT := { "Authorization: Bearer " + U_NewToken() }
oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tempuri.org/ICotacao/HabilitarRetornarCotacaoItem",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	Lower(AllTrim(GetMv("MV_XPARURL"))) + "/services/Cotacao.svc")

::Init()
::oWSHabilitarRetornarCotacaoItemResult:SoapRecv( WSAdvValue( oXmlRet,"_HABILITARRETORNARCOTACAOITEMRESPONSE:_HABILITARRETORNARCOTACAOITEMRESULT","RetornoDTO",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method RetornarCotacaoComEmpresaSemDePara of Service WSCotacao

WSMETHOD RetornarCotacaoComEmpresaSemDePara WSSEND nnFlParticipa WSRECEIVE oWSRetornarCotacaoComEmpresaSemDeParaResult WSCLIENT WSCotacao
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<RetornarCotacaoComEmpresaSemDePara xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("nFlParticipa", ::nnFlParticipa, nnFlParticipa , "int", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</RetornarCotacaoComEmpresaSemDePara>"

Self:_HEADOUT := { "Authorization: Bearer " + U_NewToken() }
oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tempuri.org/ICotacao/RetornarCotacaoComEmpresaSemDePara",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	Lower(AllTrim(GetMv("MV_XPARURL"))) + "/services/Cotacao.svc")

::Init()
::oWSRetornarCotacaoComEmpresaSemDeParaResult:SoapRecv( WSAdvValue( oXmlRet,"_RETORNARCOTACAOCOMEMPRESASEMDEPARARESPONSE:_RETORNARCOTACAOCOMEMPRESASEMDEPARARESULT","ArrayOfProcessoCotacaoDTO",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method HabilitarRetornarCotacaoPorEmpresa of Service WSCotacao

WSMETHOD HabilitarRetornarCotacaoPorEmpresa WSSEND oWSlstConfirmacaoNegociacaoDTO WSRECEIVE oWSHabilitarRetornarCotacaoPorEmpresaResult WSCLIENT WSCotacao
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<HabilitarRetornarCotacaoPorEmpresa xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("lstConfirmacaoNegociacaoDTO", ::oWSlstConfirmacaoNegociacaoDTO, oWSlstConfirmacaoNegociacaoDTO , "ArrayOfConfirmacaoNegociacaoPorEmpresaDTO", .F. , .F., 0 , "http://tempuri.org/", .F.,.F.) 
cSoap += "</HabilitarRetornarCotacaoPorEmpresa>"

Self:_HEADOUT := { "Authorization: Bearer " + U_NewToken() }
oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tempuri.org/ICotacao/HabilitarRetornarCotacaoPorEmpresa",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	Lower(AllTrim(GetMv("MV_XPARURL"))) + "/services/Cotacao.svc")

::Init()
::oWSHabilitarRetornarCotacaoPorEmpresaResult:SoapRecv( WSAdvValue( oXmlRet,"_HABILITARRETORNARCOTACAOPOREMPRESARESPONSE:_HABILITARRETORNARCOTACAOPOREMPRESARESULT","RetornoDTO",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.


// WSDL Data Structure ArrayOfCotacaoDTO

WSSTRUCT Cotacao_ArrayOfCotacaoDTO
	WSDATA   oWSCotacaoDTO             AS Cotacao_CotacaoDTO OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Cotacao_ArrayOfCotacaoDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Cotacao_ArrayOfCotacaoDTO
	::oWSCotacaoDTO        := {} // Array Of  Cotacao_COTACAODTO():New()
Return

WSMETHOD CLONE WSCLIENT Cotacao_ArrayOfCotacaoDTO
	Local oClone := Cotacao_ArrayOfCotacaoDTO():NEW()
	oClone:oWSCotacaoDTO := NIL
	If ::oWSCotacaoDTO <> NIL 
		oClone:oWSCotacaoDTO := {}
		aEval( ::oWSCotacaoDTO , { |x| aadd( oClone:oWSCotacaoDTO , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT Cotacao_ArrayOfCotacaoDTO
	Local cSoap := ""
	aEval( ::oWSCotacaoDTO , {|x| cSoap := cSoap  +  WSSoapValue("CotacaoDTO", x , x , "CotacaoDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.)  } ) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Cotacao_ArrayOfCotacaoDTO
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_COTACAODTO","CotacaoDTO",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSCotacaoDTO , Cotacao_CotacaoDTO():New() )
			::oWSCotacaoDTO[len(::oWSCotacaoDTO)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure RetornoDTO

WSSTRUCT Cotacao_RetornoDTO
	WSDATA   oWSlstWbtLogDTO           AS Cotacao_ArrayOfWbtLogDTO OPTIONAL
	WSDATA   nnIdRetorno               AS long OPTIONAL
	WSDATA   csNrToken                 AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Cotacao_RetornoDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Cotacao_RetornoDTO
Return

WSMETHOD CLONE WSCLIENT Cotacao_RetornoDTO
	Local oClone := Cotacao_RetornoDTO():NEW()
	oClone:oWSlstWbtLogDTO      := IIF(::oWSlstWbtLogDTO = NIL , NIL , ::oWSlstWbtLogDTO:Clone() )
	oClone:nnIdRetorno          := ::nnIdRetorno
	oClone:csNrToken            := ::csNrToken
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Cotacao_RetornoDTO
	Local oNode1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_LSTWBTLOGDTO","ArrayOfWbtLogDTO",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode1 != NIL
		::oWSlstWbtLogDTO := Cotacao_ArrayOfWbtLogDTO():New()
		::oWSlstWbtLogDTO:SoapRecv(oNode1)
	EndIf
	::nnIdRetorno        :=  WSAdvValue( oResponse,"_NIDRETORNO","long",NIL,NIL,NIL,"N",NIL,NIL) 
	::csNrToken          :=  WSAdvValue( oResponse,"_SNRTOKEN","string",NIL,NIL,NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure ArrayOfConfirmacaoNegociacaoDTO

WSSTRUCT Cotacao_ArrayOfConfirmacaoNegociacaoDTO
	WSDATA   oWSConfirmacaoNegociacaoDTO AS Cotacao_ConfirmacaoNegociacaoDTO OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Cotacao_ArrayOfConfirmacaoNegociacaoDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Cotacao_ArrayOfConfirmacaoNegociacaoDTO
	::oWSConfirmacaoNegociacaoDTO := {} // Array Of  Cotacao_CONFIRMACAONEGOCIACAODTO():New()
Return

WSMETHOD CLONE WSCLIENT Cotacao_ArrayOfConfirmacaoNegociacaoDTO
	Local oClone := Cotacao_ArrayOfConfirmacaoNegociacaoDTO():NEW()
	oClone:oWSConfirmacaoNegociacaoDTO := NIL
	If ::oWSConfirmacaoNegociacaoDTO <> NIL 
		oClone:oWSConfirmacaoNegociacaoDTO := {}
		aEval( ::oWSConfirmacaoNegociacaoDTO , { |x| aadd( oClone:oWSConfirmacaoNegociacaoDTO , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT Cotacao_ArrayOfConfirmacaoNegociacaoDTO
	Local cSoap := ""
	aEval( ::oWSConfirmacaoNegociacaoDTO , {|x| cSoap := cSoap  +  WSSoapValue("ConfirmacaoNegociacaoDTO", x , x , "ConfirmacaoNegociacaoDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.)  } ) 
Return cSoap

// WSDL Data Structure ArrayOfProcessoCotacaoDTO

WSSTRUCT Cotacao_ArrayOfProcessoCotacaoDTO
	WSDATA   oWSProcessoCotacaoDTO     AS Cotacao_ProcessoCotacaoDTO OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Cotacao_ArrayOfProcessoCotacaoDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Cotacao_ArrayOfProcessoCotacaoDTO
	::oWSProcessoCotacaoDTO := {} // Array Of  Cotacao_PROCESSOCOTACAODTO():New()
Return

WSMETHOD CLONE WSCLIENT Cotacao_ArrayOfProcessoCotacaoDTO
	Local oClone := Cotacao_ArrayOfProcessoCotacaoDTO():NEW()
	oClone:oWSProcessoCotacaoDTO := NIL
	If ::oWSProcessoCotacaoDTO <> NIL 
		oClone:oWSProcessoCotacaoDTO := {}
		aEval( ::oWSProcessoCotacaoDTO , { |x| aadd( oClone:oWSProcessoCotacaoDTO , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Cotacao_ArrayOfProcessoCotacaoDTO
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_PROCESSOCOTACAODTO","ProcessoCotacaoDTO",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSProcessoCotacaoDTO , Cotacao_ProcessoCotacaoDTO():New() )
			::oWSProcessoCotacaoDTO[len(::oWSProcessoCotacaoDTO)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure CotacaoDTO

WSSTRUCT Cotacao_CotacaoDTO
	WSDATA   nbFlAlteraCondicaoPagamento AS int OPTIONAL
	WSDATA   nbFlCotacaoAberta         AS int OPTIONAL
	WSDATA   nbFlPermissaoEmpresaClic  AS int OPTIONAL
	WSDATA   nbFlPermiteAlterarFrete   AS int OPTIONAL
	WSDATA   nbFlRestrita              AS int OPTIONAL
	WSDATA   nbFlTermo                 AS int OPTIONAL
	WSDATA   nbFlVisivelClic           AS int OPTIONAL
	WSDATA   oWSlstCotacaoItemDTO      AS Cotacao_ArrayOfCotacaoItemDTO OPTIONAL
	WSDATA   oWSlstCotacaoMoedaDTO     AS Cotacao_ArrayOfCotacaoMoedaDTO OPTIONAL
	WSDATA   oWSlstCotacaoParticipanteDTO AS Cotacao_ArrayOfCotacaoParticipanteDTO OPTIONAL
	WSDATA   nnCdSituacao              AS long OPTIONAL
	WSDATA   nnIdTipoNegociacao        AS int OPTIONAL
	WSDATA   nnNrCasasDecimais         AS int OPTIONAL
	WSDATA   csCdCotacaoERP            AS string OPTIONAL
	WSDATA   csCdCotacaoWbc            AS string OPTIONAL
	WSDATA   csCdCotacaoWbcPai         AS string OPTIONAL
	WSDATA   csCdEmpresa               AS string OPTIONAL
	WSDATA   csCdEmpresaRequisicao     AS string OPTIONAL
	WSDATA   csCdFrete                 AS string OPTIONAL
	WSDATA   csCdMoeda                 AS string OPTIONAL
	WSDATA   csCdProjeto               AS string OPTIONAL
	WSDATA   csCdUsuario               AS string OPTIONAL
	WSDATA   csDsCotacao               AS string OPTIONAL
	WSDATA   csDsJustificativa         AS string OPTIONAL
	WSDATA   csDsObservacao            AS string OPTIONAL
	WSDATA   csDsResumoNegociacaoClic  AS string OPTIONAL
	WSDATA   csDsTermo                 AS string OPTIONAL
	WSDATA   ctDtCadastro              AS dateTime OPTIONAL
	WSDATA   ctDtFinal                 AS dateTime OPTIONAL
	WSDATA   ctDtFinalContrato         AS dateTime OPTIONAL
	WSDATA   ctDtInicial               AS dateTime OPTIONAL
	WSDATA   ctDtInicialContrato       AS dateTime OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Cotacao_CotacaoDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Cotacao_CotacaoDTO
Return

WSMETHOD CLONE WSCLIENT Cotacao_CotacaoDTO
	Local oClone := Cotacao_CotacaoDTO():NEW()
	oClone:nbFlAlteraCondicaoPagamento := ::nbFlAlteraCondicaoPagamento
	oClone:nbFlCotacaoAberta    := ::nbFlCotacaoAberta
	oClone:nbFlPermissaoEmpresaClic := ::nbFlPermissaoEmpresaClic
	oClone:nbFlPermiteAlterarFrete := ::nbFlPermiteAlterarFrete
	oClone:nbFlRestrita         := ::nbFlRestrita
	oClone:nbFlTermo            := ::nbFlTermo
	oClone:nbFlVisivelClic      := ::nbFlVisivelClic
	oClone:oWSlstCotacaoItemDTO := IIF(::oWSlstCotacaoItemDTO = NIL , NIL , ::oWSlstCotacaoItemDTO:Clone() )
	oClone:oWSlstCotacaoMoedaDTO := IIF(::oWSlstCotacaoMoedaDTO = NIL , NIL , ::oWSlstCotacaoMoedaDTO:Clone() )
	oClone:oWSlstCotacaoParticipanteDTO := IIF(::oWSlstCotacaoParticipanteDTO = NIL , NIL , ::oWSlstCotacaoParticipanteDTO:Clone() )
	oClone:nnCdSituacao         := ::nnCdSituacao
	oClone:nnIdTipoNegociacao   := ::nnIdTipoNegociacao
	oClone:nnNrCasasDecimais    := ::nnNrCasasDecimais
	oClone:csCdCotacaoERP       := ::csCdCotacaoERP
	oClone:csCdCotacaoWbc       := ::csCdCotacaoWbc
	oClone:csCdCotacaoWbcPai    := ::csCdCotacaoWbcPai
	oClone:csCdEmpresa          := ::csCdEmpresa
	oClone:csCdEmpresaRequisicao := ::csCdEmpresaRequisicao
	oClone:csCdFrete            := ::csCdFrete
	oClone:csCdMoeda            := ::csCdMoeda
	oClone:csCdProjeto          := ::csCdProjeto
	oClone:csCdUsuario          := ::csCdUsuario
	oClone:csDsCotacao          := ::csDsCotacao
	oClone:csDsJustificativa    := ::csDsJustificativa
	oClone:csDsObservacao       := ::csDsObservacao
	oClone:csDsResumoNegociacaoClic := ::csDsResumoNegociacaoClic
	oClone:csDsTermo            := ::csDsTermo
	oClone:ctDtCadastro         := ::ctDtCadastro
	oClone:ctDtFinal            := ::ctDtFinal
	oClone:ctDtFinalContrato    := ::ctDtFinalContrato
	oClone:ctDtInicial          := ::ctDtInicial
	oClone:ctDtInicialContrato  := ::ctDtInicialContrato
Return oClone

WSMETHOD SOAPSEND WSCLIENT Cotacao_CotacaoDTO
	Local cSoap := ""
	cSoap += WSSoapValue("bFlAlteraCondicaoPagamento", ::nbFlAlteraCondicaoPagamento, ::nbFlAlteraCondicaoPagamento , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("bFlCotacaoAberta", ::nbFlCotacaoAberta, ::nbFlCotacaoAberta , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("bFlPermissaoEmpresaClic", ::nbFlPermissaoEmpresaClic, ::nbFlPermissaoEmpresaClic , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("bFlPermiteAlterarFrete", ::nbFlPermiteAlterarFrete, ::nbFlPermiteAlterarFrete , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("bFlRestrita", ::nbFlRestrita, ::nbFlRestrita , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("bFlTermo", ::nbFlTermo, ::nbFlTermo , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("bFlVisivelClic", ::nbFlVisivelClic, ::nbFlVisivelClic , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("lstCotacaoItemDTO", ::oWSlstCotacaoItemDTO, ::oWSlstCotacaoItemDTO , "ArrayOfCotacaoItemDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("lstCotacaoMoedaDTO", ::oWSlstCotacaoMoedaDTO, ::oWSlstCotacaoMoedaDTO , "ArrayOfCotacaoMoedaDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("lstCotacaoParticipanteDTO", ::oWSlstCotacaoParticipanteDTO, ::oWSlstCotacaoParticipanteDTO , "ArrayOfCotacaoParticipanteDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("nCdSituacao", ::nnCdSituacao, ::nnCdSituacao , "long", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("nIdTipoNegociacao", ::nnIdTipoNegociacao, ::nnIdTipoNegociacao , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("nNrCasasDecimais", ::nnNrCasasDecimais, ::nnNrCasasDecimais , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdCotacaoERP", ::csCdCotacaoERP, ::csCdCotacaoERP , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdCotacaoWbc", ::csCdCotacaoWbc, ::csCdCotacaoWbc , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdCotacaoWbcPai", ::csCdCotacaoWbcPai, ::csCdCotacaoWbcPai , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdEmpresa", ::csCdEmpresa, ::csCdEmpresa , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdEmpresaRequisicao", ::csCdEmpresaRequisicao, ::csCdEmpresaRequisicao , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdFrete", ::csCdFrete, ::csCdFrete , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdMoeda", ::csCdMoeda, ::csCdMoeda , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdProjeto", ::csCdProjeto, ::csCdProjeto , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdUsuario", ::csCdUsuario, ::csCdUsuario , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sDsCotacao", ::csDsCotacao, ::csDsCotacao , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sDsJustificativa", ::csDsJustificativa, ::csDsJustificativa , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sDsObservacao", ::csDsObservacao, ::csDsObservacao , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sDsResumoNegociacaoClic", ::csDsResumoNegociacaoClic, ::csDsResumoNegociacaoClic , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sDsTermo", ::csDsTermo, ::csDsTermo , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("tDtCadastro", ::ctDtCadastro, ::ctDtCadastro , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("tDtFinal", ::ctDtFinal, ::ctDtFinal , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("tDtFinalContrato", ::ctDtFinalContrato, ::ctDtFinalContrato , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("tDtInicial", ::ctDtInicial, ::ctDtInicial , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("tDtInicialContrato", ::ctDtInicialContrato, ::ctDtInicialContrato , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Cotacao_CotacaoDTO
	Local oNode8
	Local oNode9
	Local oNode10
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::nbFlAlteraCondicaoPagamento :=  WSAdvValue( oResponse,"_BFLALTERACONDICAOPAGAMENTO","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::nbFlCotacaoAberta  :=  WSAdvValue( oResponse,"_BFLCOTACAOABERTA","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::nbFlPermissaoEmpresaClic :=  WSAdvValue( oResponse,"_BFLPERMISSAOEMPRESACLIC","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::nbFlPermiteAlterarFrete :=  WSAdvValue( oResponse,"_BFLPERMITEALTERARFRETE","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::nbFlRestrita       :=  WSAdvValue( oResponse,"_BFLRESTRITA","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::nbFlTermo          :=  WSAdvValue( oResponse,"_BFLTERMO","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::nbFlVisivelClic    :=  WSAdvValue( oResponse,"_BFLVISIVELCLIC","int",NIL,NIL,NIL,"N",NIL,NIL) 
	oNode8 :=  WSAdvValue( oResponse,"_LSTCOTACAOITEMDTO","ArrayOfCotacaoItemDTO",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode8 != NIL
		::oWSlstCotacaoItemDTO := Cotacao_ArrayOfCotacaoItemDTO():New()
		::oWSlstCotacaoItemDTO:SoapRecv(oNode8)
	EndIf
	oNode9 :=  WSAdvValue( oResponse,"_LSTCOTACAOMOEDADTO","ArrayOfCotacaoMoedaDTO",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode9 != NIL
		::oWSlstCotacaoMoedaDTO := Cotacao_ArrayOfCotacaoMoedaDTO():New()
		::oWSlstCotacaoMoedaDTO:SoapRecv(oNode9)
	EndIf
	oNode10 :=  WSAdvValue( oResponse,"_LSTCOTACAOPARTICIPANTEDTO","ArrayOfCotacaoParticipanteDTO",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode10 != NIL
		::oWSlstCotacaoParticipanteDTO := Cotacao_ArrayOfCotacaoParticipanteDTO():New()
		::oWSlstCotacaoParticipanteDTO:SoapRecv(oNode10)
	EndIf
	::nnCdSituacao       :=  WSAdvValue( oResponse,"_NCDSITUACAO","long",NIL,NIL,NIL,"N",NIL,NIL) 
	::nnIdTipoNegociacao :=  WSAdvValue( oResponse,"_NIDTIPONEGOCIACAO","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::nnNrCasasDecimais  :=  WSAdvValue( oResponse,"_NNRCASASDECIMAIS","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::csCdCotacaoERP     :=  WSAdvValue( oResponse,"_SCDCOTACAOERP","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdCotacaoWbc     :=  WSAdvValue( oResponse,"_SCDCOTACAOWBC","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdCotacaoWbcPai  :=  WSAdvValue( oResponse,"_SCDCOTACAOWBCPAI","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdEmpresa        :=  WSAdvValue( oResponse,"_SCDEMPRESA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdEmpresaRequisicao :=  WSAdvValue( oResponse,"_SCDEMPRESAREQUISICAO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdFrete          :=  WSAdvValue( oResponse,"_SCDFRETE","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdMoeda          :=  WSAdvValue( oResponse,"_SCDMOEDA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdProjeto        :=  WSAdvValue( oResponse,"_SCDPROJETO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdUsuario        :=  WSAdvValue( oResponse,"_SCDUSUARIO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csDsCotacao        :=  WSAdvValue( oResponse,"_SDSCOTACAO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csDsJustificativa  :=  WSAdvValue( oResponse,"_SDSJUSTIFICATIVA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csDsObservacao     :=  WSAdvValue( oResponse,"_SDSOBSERVACAO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csDsResumoNegociacaoClic :=  WSAdvValue( oResponse,"_SDSRESUMONEGOCIACAOCLIC","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csDsTermo          :=  WSAdvValue( oResponse,"_SDSTERMO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::ctDtCadastro       :=  WSAdvValue( oResponse,"_TDTCADASTRO","dateTime",NIL,NIL,NIL,"S",NIL,NIL) 
	::ctDtFinal          :=  WSAdvValue( oResponse,"_TDTFINAL","dateTime",NIL,NIL,NIL,"S",NIL,NIL) 
	::ctDtFinalContrato  :=  WSAdvValue( oResponse,"_TDTFINALCONTRATO","dateTime",NIL,NIL,NIL,"S",NIL,NIL) 
	::ctDtInicial        :=  WSAdvValue( oResponse,"_TDTINICIAL","dateTime",NIL,NIL,NIL,"S",NIL,NIL) 
	::ctDtInicialContrato :=  WSAdvValue( oResponse,"_TDTINICIALCONTRATO","dateTime",NIL,NIL,NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure ArrayOfWbtLogDTO

WSSTRUCT Cotacao_ArrayOfWbtLogDTO
	WSDATA   oWSWbtLogDTO              AS Cotacao_WbtLogDTO OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Cotacao_ArrayOfWbtLogDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Cotacao_ArrayOfWbtLogDTO
	::oWSWbtLogDTO         := {} // Array Of  Cotacao_WBTLOGDTO():New()
Return

WSMETHOD CLONE WSCLIENT Cotacao_ArrayOfWbtLogDTO
	Local oClone := Cotacao_ArrayOfWbtLogDTO():NEW()
	oClone:oWSWbtLogDTO := NIL
	If ::oWSWbtLogDTO <> NIL 
		oClone:oWSWbtLogDTO := {}
		aEval( ::oWSWbtLogDTO , { |x| aadd( oClone:oWSWbtLogDTO , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Cotacao_ArrayOfWbtLogDTO
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_WBTLOGDTO","WbtLogDTO",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSWbtLogDTO , Cotacao_WbtLogDTO():New() )
			::oWSWbtLogDTO[len(::oWSWbtLogDTO)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure ConfirmacaoNegociacaoDTO

WSSTRUCT Cotacao_ConfirmacaoNegociacaoDTO
	WSDATA   oWSlstConfirmacaoNegociacaoItemDTO AS Cotacao_ArrayOfConfirmacaoNegociacaoItemDTO OPTIONAL
	WSDATA   nnIdTipoProcesso          AS int OPTIONAL
	WSDATA   csCdProcessoWbc           AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Cotacao_ConfirmacaoNegociacaoDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Cotacao_ConfirmacaoNegociacaoDTO
Return

WSMETHOD CLONE WSCLIENT Cotacao_ConfirmacaoNegociacaoDTO
	Local oClone := Cotacao_ConfirmacaoNegociacaoDTO():NEW()
	oClone:oWSlstConfirmacaoNegociacaoItemDTO := IIF(::oWSlstConfirmacaoNegociacaoItemDTO = NIL , NIL , ::oWSlstConfirmacaoNegociacaoItemDTO:Clone() )
	oClone:nnIdTipoProcesso     := ::nnIdTipoProcesso
	oClone:csCdProcessoWbc      := ::csCdProcessoWbc
Return oClone

WSMETHOD SOAPSEND WSCLIENT Cotacao_ConfirmacaoNegociacaoDTO
	Local cSoap := ""
	cSoap += WSSoapValue("lstConfirmacaoNegociacaoItemDTO", ::oWSlstConfirmacaoNegociacaoItemDTO, ::oWSlstConfirmacaoNegociacaoItemDTO , "ArrayOfConfirmacaoNegociacaoItemDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("nIdTipoProcesso", ::nnIdTipoProcesso, ::nnIdTipoProcesso , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdProcessoWbc", ::csCdProcessoWbc, ::csCdProcessoWbc , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
Return cSoap

// WSDL Data Structure ProcessoCotacaoDTO

WSSTRUCT Cotacao_ProcessoCotacaoDTO
	WSDATA   csCdCotacaoWBC            AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Cotacao_ProcessoCotacaoDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Cotacao_ProcessoCotacaoDTO
Return

WSMETHOD CLONE WSCLIENT Cotacao_ProcessoCotacaoDTO
	Local oClone := Cotacao_ProcessoCotacaoDTO():NEW()
	oClone:csCdCotacaoWBC       := ::csCdCotacaoWBC
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Cotacao_ProcessoCotacaoDTO
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::csCdCotacaoWBC     :=  WSAdvValue( oResponse,"_SCDCOTACAOWBC","string",NIL,NIL,NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure ArrayOfCotacaoItemDTO

WSSTRUCT Cotacao_ArrayOfCotacaoItemDTO
	WSDATA   oWSCotacaoItemDTO         AS Cotacao_CotacaoItemDTO OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Cotacao_ArrayOfCotacaoItemDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Cotacao_ArrayOfCotacaoItemDTO
	::oWSCotacaoItemDTO    := {} // Array Of  Cotacao_COTACAOITEMDTO():New()
Return

WSMETHOD CLONE WSCLIENT Cotacao_ArrayOfCotacaoItemDTO
	Local oClone := Cotacao_ArrayOfCotacaoItemDTO():NEW()
	oClone:oWSCotacaoItemDTO := NIL
	If ::oWSCotacaoItemDTO <> NIL 
		oClone:oWSCotacaoItemDTO := {}
		aEval( ::oWSCotacaoItemDTO , { |x| aadd( oClone:oWSCotacaoItemDTO , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT Cotacao_ArrayOfCotacaoItemDTO
	Local cSoap := ""
	aEval( ::oWSCotacaoItemDTO , {|x| cSoap := cSoap  +  WSSoapValue("CotacaoItemDTO", x , x , "CotacaoItemDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.)  } ) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Cotacao_ArrayOfCotacaoItemDTO
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_COTACAOITEMDTO","CotacaoItemDTO",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSCotacaoItemDTO , Cotacao_CotacaoItemDTO():New() )
			::oWSCotacaoItemDTO[len(::oWSCotacaoItemDTO)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure ArrayOfCotacaoMoedaDTO

WSSTRUCT Cotacao_ArrayOfCotacaoMoedaDTO
	WSDATA   oWSCotacaoMoedaDTO        AS Cotacao_CotacaoMoedaDTO OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Cotacao_ArrayOfCotacaoMoedaDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Cotacao_ArrayOfCotacaoMoedaDTO
	::oWSCotacaoMoedaDTO   := {} // Array Of  Cotacao_COTACAOMOEDADTO():New()
Return

WSMETHOD CLONE WSCLIENT Cotacao_ArrayOfCotacaoMoedaDTO
	Local oClone := Cotacao_ArrayOfCotacaoMoedaDTO():NEW()
	oClone:oWSCotacaoMoedaDTO := NIL
	If ::oWSCotacaoMoedaDTO <> NIL 
		oClone:oWSCotacaoMoedaDTO := {}
		aEval( ::oWSCotacaoMoedaDTO , { |x| aadd( oClone:oWSCotacaoMoedaDTO , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT Cotacao_ArrayOfCotacaoMoedaDTO
	Local cSoap := ""
	aEval( ::oWSCotacaoMoedaDTO , {|x| cSoap := cSoap  +  WSSoapValue("CotacaoMoedaDTO", x , x , "CotacaoMoedaDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.)  } ) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Cotacao_ArrayOfCotacaoMoedaDTO
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_COTACAOMOEDADTO","CotacaoMoedaDTO",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSCotacaoMoedaDTO , Cotacao_CotacaoMoedaDTO():New() )
			::oWSCotacaoMoedaDTO[len(::oWSCotacaoMoedaDTO)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure ArrayOfCotacaoParticipanteDTO

WSSTRUCT Cotacao_ArrayOfCotacaoParticipanteDTO
	WSDATA   oWSCotacaoParticipanteDTO AS Cotacao_CotacaoParticipanteDTO OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Cotacao_ArrayOfCotacaoParticipanteDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Cotacao_ArrayOfCotacaoParticipanteDTO
	::oWSCotacaoParticipanteDTO := {} // Array Of  Cotacao_COTACAOPARTICIPANTEDTO():New()
Return

WSMETHOD CLONE WSCLIENT Cotacao_ArrayOfCotacaoParticipanteDTO
	Local oClone := Cotacao_ArrayOfCotacaoParticipanteDTO():NEW()
	oClone:oWSCotacaoParticipanteDTO := NIL
	If ::oWSCotacaoParticipanteDTO <> NIL 
		oClone:oWSCotacaoParticipanteDTO := {}
		aEval( ::oWSCotacaoParticipanteDTO , { |x| aadd( oClone:oWSCotacaoParticipanteDTO , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT Cotacao_ArrayOfCotacaoParticipanteDTO
	Local cSoap := ""
	aEval( ::oWSCotacaoParticipanteDTO , {|x| cSoap := cSoap  +  WSSoapValue("CotacaoParticipanteDTO", x , x , "CotacaoParticipanteDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.)  } ) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Cotacao_ArrayOfCotacaoParticipanteDTO
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_COTACAOPARTICIPANTEDTO","CotacaoParticipanteDTO",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSCotacaoParticipanteDTO , Cotacao_CotacaoParticipanteDTO():New() )
			::oWSCotacaoParticipanteDTO[len(::oWSCotacaoParticipanteDTO)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure WbtLogDTO

WSSTRUCT Cotacao_WbtLogDTO
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

WSMETHOD NEW WSCLIENT Cotacao_WbtLogDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Cotacao_WbtLogDTO
Return

WSMETHOD CLONE WSCLIENT Cotacao_WbtLogDTO
	Local oClone := Cotacao_WbtLogDTO():NEW()
	oClone:nnCdLog              := ::nnCdLog
	oClone:nnIdRetorno          := ::nnIdRetorno
	oClone:csCdOrigem           := ::csCdOrigem
	oClone:csDsLog              := ::csDsLog
	oClone:csDsTipoDocumento    := ::csDsTipoDocumento
	oClone:csNrToken            := ::csNrToken
	oClone:ctDtLog              := ::ctDtLog
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Cotacao_WbtLogDTO
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

// WSDL Data Structure ArrayOfConfirmacaoNegociacaoItemDTO

WSSTRUCT Cotacao_ArrayOfConfirmacaoNegociacaoItemDTO
	WSDATA   oWSConfirmacaoNegociacaoItemDTO AS Cotacao_ConfirmacaoNegociacaoItemDTO OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Cotacao_ArrayOfConfirmacaoNegociacaoItemDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Cotacao_ArrayOfConfirmacaoNegociacaoItemDTO
	::oWSConfirmacaoNegociacaoItemDTO := {} // Array Of  Cotacao_CONFIRMACAONEGOCIACAOITEMDTO():New()
Return

WSMETHOD CLONE WSCLIENT Cotacao_ArrayOfConfirmacaoNegociacaoItemDTO
	Local oClone := Cotacao_ArrayOfConfirmacaoNegociacaoItemDTO():NEW()
	oClone:oWSConfirmacaoNegociacaoItemDTO := NIL
	If ::oWSConfirmacaoNegociacaoItemDTO <> NIL 
		oClone:oWSConfirmacaoNegociacaoItemDTO := {}
		aEval( ::oWSConfirmacaoNegociacaoItemDTO , { |x| aadd( oClone:oWSConfirmacaoNegociacaoItemDTO , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT Cotacao_ArrayOfConfirmacaoNegociacaoItemDTO
	Local cSoap := ""
	aEval( ::oWSConfirmacaoNegociacaoItemDTO , {|x| cSoap := cSoap  +  WSSoapValue("ConfirmacaoNegociacaoItemDTO", x , x , "ConfirmacaoNegociacaoItemDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.)  } ) 
Return cSoap

// WSDL Data Structure CotacaoItemDTO

WSSTRUCT Cotacao_CotacaoItemDTO
	WSDATA   nbFlCalculaReferencia     AS int OPTIONAL
	WSDATA   nbFlUtilizarRecap         AS int OPTIONAL
	WSDATA   ndQtItem                  AS decimal OPTIONAL
	WSDATA   ndVlProdutoUltimaCompra   AS decimal OPTIONAL
	WSDATA   ndVlReferencia            AS decimal OPTIONAL
	WSDATA   oWSlstCotacaoItemEnderecoDTO AS Cotacao_ArrayOfCotacaoItemEnderecoDTO OPTIONAL
	WSDATA   oWSlstCotacaoItemParticipanteDTO AS Cotacao_ArrayOfCotacaoItemParticipanteDTO OPTIONAL
	WSDATA   oWSlstCotacaoItemTaxaDTO  AS Cotacao_ArrayOfCotacaoItemTaxaDTO OPTIONAL
	WSDATA   oWSlstCotacaoPropostaDTO  AS Cotacao_ArrayOfCotacaoPropostaDTO OPTIONAL
	WSDATA   nnCdAplicacao             AS long OPTIONAL
	WSDATA   nnCdSituacao              AS long OPTIONAL
	WSDATA   csCdClasse                AS string OPTIONAL
	WSDATA   csCdCondicaoPagamento     AS string OPTIONAL
	WSDATA   csCdCotacao               AS string OPTIONAL
	WSDATA   csCdItemEmpresa           AS string OPTIONAL
	WSDATA   csCdItemWbc               AS string OPTIONAL
	WSDATA   csCdItemWbcPai            AS string OPTIONAL
	WSDATA   csCdMarca                 AS string OPTIONAL
	WSDATA   csCdProduto               AS string OPTIONAL
	WSDATA   csCdProjeto               AS string OPTIONAL
	WSDATA   csCdTipoPedidoERP         AS string OPTIONAL
	WSDATA   csCdUnidadeMedida         AS string OPTIONAL
	WSDATA   csDsItem                  AS string OPTIONAL
	WSDATA   csDsJustificativa         AS string OPTIONAL
	WSDATA   csDsJustificativaERP      AS string OPTIONAL
	WSDATA   csDsObservacao            AS string OPTIONAL
	WSDATA   csDsObservacaoInterna     AS string OPTIONAL
	WSDATA   csNrRecap                 AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Cotacao_CotacaoItemDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Cotacao_CotacaoItemDTO
Return

WSMETHOD CLONE WSCLIENT Cotacao_CotacaoItemDTO
	Local oClone := Cotacao_CotacaoItemDTO():NEW()
	oClone:nbFlCalculaReferencia := ::nbFlCalculaReferencia
	oClone:nbFlUtilizarRecap    := ::nbFlUtilizarRecap
	oClone:ndQtItem             := ::ndQtItem
	oClone:ndVlProdutoUltimaCompra := ::ndVlProdutoUltimaCompra
	oClone:ndVlReferencia       := ::ndVlReferencia
	oClone:oWSlstCotacaoItemEnderecoDTO := IIF(::oWSlstCotacaoItemEnderecoDTO = NIL , NIL , ::oWSlstCotacaoItemEnderecoDTO:Clone() )
	oClone:oWSlstCotacaoItemParticipanteDTO := IIF(::oWSlstCotacaoItemParticipanteDTO = NIL , NIL , ::oWSlstCotacaoItemParticipanteDTO:Clone() )
	oClone:oWSlstCotacaoItemTaxaDTO := IIF(::oWSlstCotacaoItemTaxaDTO = NIL , NIL , ::oWSlstCotacaoItemTaxaDTO:Clone() )
	oClone:oWSlstCotacaoPropostaDTO := IIF(::oWSlstCotacaoPropostaDTO = NIL , NIL , ::oWSlstCotacaoPropostaDTO:Clone() )
	oClone:nnCdAplicacao        := ::nnCdAplicacao
	oClone:nnCdSituacao         := ::nnCdSituacao
	oClone:csCdClasse           := ::csCdClasse
	oClone:csCdCondicaoPagamento := ::csCdCondicaoPagamento
	oClone:csCdCotacao          := ::csCdCotacao
	oClone:csCdItemEmpresa      := ::csCdItemEmpresa
	oClone:csCdItemWbc          := ::csCdItemWbc
	oClone:csCdItemWbcPai       := ::csCdItemWbcPai
	oClone:csCdMarca            := ::csCdMarca
	oClone:csCdProduto          := ::csCdProduto
	oClone:csCdProjeto          := ::csCdProjeto
	oClone:csCdTipoPedidoERP    := ::csCdTipoPedidoERP
	oClone:csCdUnidadeMedida    := ::csCdUnidadeMedida
	oClone:csDsItem             := ::csDsItem
	oClone:csDsJustificativa    := ::csDsJustificativa
	oClone:csDsJustificativaERP := ::csDsJustificativaERP
	oClone:csDsObservacao       := ::csDsObservacao
	oClone:csDsObservacaoInterna := ::csDsObservacaoInterna
	oClone:csNrRecap            := ::csNrRecap
Return oClone

WSMETHOD SOAPSEND WSCLIENT Cotacao_CotacaoItemDTO
	Local cSoap := ""
	cSoap += WSSoapValue("bFlCalculaReferencia", ::nbFlCalculaReferencia, ::nbFlCalculaReferencia , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("bFlUtilizarRecap", ::nbFlUtilizarRecap, ::nbFlUtilizarRecap , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("dQtItem", ::ndQtItem, ::ndQtItem , "decimal", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("dVlProdutoUltimaCompra", ::ndVlProdutoUltimaCompra, ::ndVlProdutoUltimaCompra , "decimal", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("dVlReferencia", ::ndVlReferencia, ::ndVlReferencia , "decimal", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("lstCotacaoItemEnderecoDTO", ::oWSlstCotacaoItemEnderecoDTO, ::oWSlstCotacaoItemEnderecoDTO , "ArrayOfCotacaoItemEnderecoDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("lstCotacaoItemParticipanteDTO", ::oWSlstCotacaoItemParticipanteDTO, ::oWSlstCotacaoItemParticipanteDTO , "ArrayOfCotacaoItemParticipanteDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("lstCotacaoItemTaxaDTO", ::oWSlstCotacaoItemTaxaDTO, ::oWSlstCotacaoItemTaxaDTO , "ArrayOfCotacaoItemTaxaDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("lstCotacaoPropostaDTO", ::oWSlstCotacaoPropostaDTO, ::oWSlstCotacaoPropostaDTO , "ArrayOfCotacaoPropostaDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("nCdAplicacao", ::nnCdAplicacao, ::nnCdAplicacao , "long", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("nCdSituacao", ::nnCdSituacao, ::nnCdSituacao , "long", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdClasse", ::csCdClasse, ::csCdClasse , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdCondicaoPagamento", ::csCdCondicaoPagamento, ::csCdCondicaoPagamento , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdCotacao", ::csCdCotacao, ::csCdCotacao , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdItemEmpresa", ::csCdItemEmpresa, ::csCdItemEmpresa , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdItemWbc", ::csCdItemWbc, ::csCdItemWbc , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdItemWbcPai", ::csCdItemWbcPai, ::csCdItemWbcPai , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdMarca", ::csCdMarca, ::csCdMarca , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdProduto", ::csCdProduto, ::csCdProduto , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdProjeto", ::csCdProjeto, ::csCdProjeto , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdTipoPedidoERP", ::csCdTipoPedidoERP, ::csCdTipoPedidoERP , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdUnidadeMedida", ::csCdUnidadeMedida, ::csCdUnidadeMedida , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sDsItem", ::csDsItem, ::csDsItem , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sDsJustificativa", ::csDsJustificativa, ::csDsJustificativa , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sDsJustificativaERP", ::csDsJustificativaERP, ::csDsJustificativaERP , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sDsObservacao", ::csDsObservacao, ::csDsObservacao , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sDsObservacaoInterna", ::csDsObservacaoInterna, ::csDsObservacaoInterna , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sNrRecap", ::csNrRecap, ::csNrRecap , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Cotacao_CotacaoItemDTO
	Local oNode6
	Local oNode7
	Local oNode8
	Local oNode9
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::nbFlCalculaReferencia :=  WSAdvValue( oResponse,"_BFLCALCULAREFERENCIA","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::nbFlUtilizarRecap  :=  WSAdvValue( oResponse,"_BFLUTILIZARRECAP","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::ndQtItem           :=  WSAdvValue( oResponse,"_DQTITEM","decimal",NIL,NIL,NIL,"N",NIL,NIL) 
	::ndVlProdutoUltimaCompra :=  WSAdvValue( oResponse,"_DVLPRODUTOULTIMACOMPRA","decimal",NIL,NIL,NIL,"N",NIL,NIL) 
	::ndVlReferencia     :=  WSAdvValue( oResponse,"_DVLREFERENCIA","decimal",NIL,NIL,NIL,"N",NIL,NIL) 
	oNode6 :=  WSAdvValue( oResponse,"_LSTCOTACAOITEMENDERECODTO","ArrayOfCotacaoItemEnderecoDTO",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode6 != NIL
		::oWSlstCotacaoItemEnderecoDTO := Cotacao_ArrayOfCotacaoItemEnderecoDTO():New()
		::oWSlstCotacaoItemEnderecoDTO:SoapRecv(oNode6)
	EndIf
	oNode7 :=  WSAdvValue( oResponse,"_LSTCOTACAOITEMPARTICIPANTEDTO","ArrayOfCotacaoItemParticipanteDTO",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode7 != NIL
		::oWSlstCotacaoItemParticipanteDTO := Cotacao_ArrayOfCotacaoItemParticipanteDTO():New()
		::oWSlstCotacaoItemParticipanteDTO:SoapRecv(oNode7)
	EndIf
	oNode8 :=  WSAdvValue( oResponse,"_LSTCOTACAOITEMTAXADTO","ArrayOfCotacaoItemTaxaDTO",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode8 != NIL
		::oWSlstCotacaoItemTaxaDTO := Cotacao_ArrayOfCotacaoItemTaxaDTO():New()
		::oWSlstCotacaoItemTaxaDTO:SoapRecv(oNode8)
	EndIf
	oNode9 :=  WSAdvValue( oResponse,"_LSTCOTACAOPROPOSTADTO","ArrayOfCotacaoPropostaDTO",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode9 != NIL
		::oWSlstCotacaoPropostaDTO := Cotacao_ArrayOfCotacaoPropostaDTO():New()
		::oWSlstCotacaoPropostaDTO:SoapRecv(oNode9)
	EndIf
	::nnCdAplicacao      :=  WSAdvValue( oResponse,"_NCDAPLICACAO","long",NIL,NIL,NIL,"N",NIL,NIL) 
	::nnCdSituacao       :=  WSAdvValue( oResponse,"_NCDSITUACAO","long",NIL,NIL,NIL,"N",NIL,NIL) 
	::csCdClasse         :=  WSAdvValue( oResponse,"_SCDCLASSE","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdCondicaoPagamento :=  WSAdvValue( oResponse,"_SCDCONDICAOPAGAMENTO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdCotacao        :=  WSAdvValue( oResponse,"_SCDCOTACAO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdItemEmpresa    :=  WSAdvValue( oResponse,"_SCDITEMEMPRESA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdItemWbc        :=  WSAdvValue( oResponse,"_SCDITEMWBC","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdItemWbcPai     :=  WSAdvValue( oResponse,"_SCDITEMWBCPAI","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdMarca          :=  WSAdvValue( oResponse,"_SCDMARCA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdProduto        :=  WSAdvValue( oResponse,"_SCDPRODUTO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdProjeto        :=  WSAdvValue( oResponse,"_SCDPROJETO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdTipoPedidoERP  :=  WSAdvValue( oResponse,"_SCDTIPOPEDIDOERP","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdUnidadeMedida  :=  WSAdvValue( oResponse,"_SCDUNIDADEMEDIDA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csDsItem           :=  WSAdvValue( oResponse,"_SDSITEM","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csDsJustificativa  :=  WSAdvValue( oResponse,"_SDSJUSTIFICATIVA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csDsJustificativaERP :=  WSAdvValue( oResponse,"_SDSJUSTIFICATIVAERP","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csDsObservacao     :=  WSAdvValue( oResponse,"_SDSOBSERVACAO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csDsObservacaoInterna :=  WSAdvValue( oResponse,"_SDSOBSERVACAOINTERNA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csNrRecap          :=  WSAdvValue( oResponse,"_SNRRECAP","string",NIL,NIL,NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure CotacaoMoedaDTO

WSSTRUCT Cotacao_CotacaoMoedaDTO
	WSDATA   nbFlAtivo                 AS int OPTIONAL
	WSDATA   ndVlIndice                AS decimal OPTIONAL
	WSDATA   nnCdSituacao              AS long OPTIONAL
	WSDATA   nnNrCasasDecimais         AS int OPTIONAL
	WSDATA   csCdMoeda                 AS string OPTIONAL
	WSDATA   ctDtCotacao               AS dateTime OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Cotacao_CotacaoMoedaDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Cotacao_CotacaoMoedaDTO
Return

WSMETHOD CLONE WSCLIENT Cotacao_CotacaoMoedaDTO
	Local oClone := Cotacao_CotacaoMoedaDTO():NEW()
	oClone:nbFlAtivo            := ::nbFlAtivo
	oClone:ndVlIndice           := ::ndVlIndice
	oClone:nnCdSituacao         := ::nnCdSituacao
	oClone:nnNrCasasDecimais    := ::nnNrCasasDecimais
	oClone:csCdMoeda            := ::csCdMoeda
	oClone:ctDtCotacao          := ::ctDtCotacao
Return oClone

WSMETHOD SOAPSEND WSCLIENT Cotacao_CotacaoMoedaDTO
	Local cSoap := ""
	cSoap += WSSoapValue("bFlAtivo", ::nbFlAtivo, ::nbFlAtivo , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("dVlIndice", ::ndVlIndice, ::ndVlIndice , "decimal", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("nCdSituacao", ::nnCdSituacao, ::nnCdSituacao , "long", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("nNrCasasDecimais", ::nnNrCasasDecimais, ::nnNrCasasDecimais , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdMoeda", ::csCdMoeda, ::csCdMoeda , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("tDtCotacao", ::ctDtCotacao, ::ctDtCotacao , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Cotacao_CotacaoMoedaDTO
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::nbFlAtivo          :=  WSAdvValue( oResponse,"_BFLATIVO","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::ndVlIndice         :=  WSAdvValue( oResponse,"_DVLINDICE","decimal",NIL,NIL,NIL,"N",NIL,NIL) 
	::nnCdSituacao       :=  WSAdvValue( oResponse,"_NCDSITUACAO","long",NIL,NIL,NIL,"N",NIL,NIL) 
	::nnNrCasasDecimais  :=  WSAdvValue( oResponse,"_NNRCASASDECIMAIS","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::csCdMoeda          :=  WSAdvValue( oResponse,"_SCDMOEDA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::ctDtCotacao        :=  WSAdvValue( oResponse,"_TDTCOTACAO","dateTime",NIL,NIL,NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure CotacaoParticipanteDTO

WSSTRUCT Cotacao_CotacaoParticipanteDTO
	WSDATA   nnStParticipacao          AS int OPTIONAL
	WSDATA   csCdEmpresa               AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Cotacao_CotacaoParticipanteDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Cotacao_CotacaoParticipanteDTO
Return

WSMETHOD CLONE WSCLIENT Cotacao_CotacaoParticipanteDTO
	Local oClone := Cotacao_CotacaoParticipanteDTO():NEW()
	oClone:nnStParticipacao     := ::nnStParticipacao
	oClone:csCdEmpresa          := ::csCdEmpresa
Return oClone

WSMETHOD SOAPSEND WSCLIENT Cotacao_CotacaoParticipanteDTO
	Local cSoap := ""
	cSoap += WSSoapValue("nStParticipacao", ::nnStParticipacao, ::nnStParticipacao , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdEmpresa", ::csCdEmpresa, ::csCdEmpresa , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Cotacao_CotacaoParticipanteDTO
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::nnStParticipacao   :=  WSAdvValue( oResponse,"_NSTPARTICIPACAO","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::csCdEmpresa        :=  WSAdvValue( oResponse,"_SCDEMPRESA","string",NIL,NIL,NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure ConfirmacaoNegociacaoItemDTO

WSSTRUCT Cotacao_ConfirmacaoNegociacaoItemDTO
	WSDATA   csCdProcessoItemWbc       AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Cotacao_ConfirmacaoNegociacaoItemDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Cotacao_ConfirmacaoNegociacaoItemDTO
Return

WSMETHOD CLONE WSCLIENT Cotacao_ConfirmacaoNegociacaoItemDTO
	Local oClone := Cotacao_ConfirmacaoNegociacaoItemDTO():NEW()
	oClone:csCdProcessoItemWbc  := ::csCdProcessoItemWbc
Return oClone

WSMETHOD SOAPSEND WSCLIENT Cotacao_ConfirmacaoNegociacaoItemDTO
	Local cSoap := ""
	cSoap += WSSoapValue("sCdProcessoItemWbc", ::csCdProcessoItemWbc, ::csCdProcessoItemWbc , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
Return cSoap

// WSDL Data Structure ArrayOfCotacaoItemEnderecoDTO

WSSTRUCT Cotacao_ArrayOfCotacaoItemEnderecoDTO
	WSDATA   oWSCotacaoItemEnderecoDTO AS Cotacao_CotacaoItemEnderecoDTO OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Cotacao_ArrayOfCotacaoItemEnderecoDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Cotacao_ArrayOfCotacaoItemEnderecoDTO
	::oWSCotacaoItemEnderecoDTO := {} // Array Of  Cotacao_COTACAOITEMENDERECODTO():New()
Return

WSMETHOD CLONE WSCLIENT Cotacao_ArrayOfCotacaoItemEnderecoDTO
	Local oClone := Cotacao_ArrayOfCotacaoItemEnderecoDTO():NEW()
	oClone:oWSCotacaoItemEnderecoDTO := NIL
	If ::oWSCotacaoItemEnderecoDTO <> NIL 
		oClone:oWSCotacaoItemEnderecoDTO := {}
		aEval( ::oWSCotacaoItemEnderecoDTO , { |x| aadd( oClone:oWSCotacaoItemEnderecoDTO , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT Cotacao_ArrayOfCotacaoItemEnderecoDTO
	Local cSoap := ""
	aEval( ::oWSCotacaoItemEnderecoDTO , {|x| cSoap := cSoap  +  WSSoapValue("CotacaoItemEnderecoDTO", x , x , "CotacaoItemEnderecoDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.)  } ) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Cotacao_ArrayOfCotacaoItemEnderecoDTO
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_COTACAOITEMENDERECODTO","CotacaoItemEnderecoDTO",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSCotacaoItemEnderecoDTO , Cotacao_CotacaoItemEnderecoDTO():New() )
			::oWSCotacaoItemEnderecoDTO[len(::oWSCotacaoItemEnderecoDTO)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure ArrayOfCotacaoItemParticipanteDTO

WSSTRUCT Cotacao_ArrayOfCotacaoItemParticipanteDTO
	WSDATA   oWSCotacaoItemParticipanteDTO AS Cotacao_CotacaoItemParticipanteDTO OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Cotacao_ArrayOfCotacaoItemParticipanteDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Cotacao_ArrayOfCotacaoItemParticipanteDTO
	::oWSCotacaoItemParticipanteDTO := {} // Array Of  Cotacao_COTACAOITEMPARTICIPANTEDTO():New()
Return

WSMETHOD CLONE WSCLIENT Cotacao_ArrayOfCotacaoItemParticipanteDTO
	Local oClone := Cotacao_ArrayOfCotacaoItemParticipanteDTO():NEW()
	oClone:oWSCotacaoItemParticipanteDTO := NIL
	If ::oWSCotacaoItemParticipanteDTO <> NIL 
		oClone:oWSCotacaoItemParticipanteDTO := {}
		aEval( ::oWSCotacaoItemParticipanteDTO , { |x| aadd( oClone:oWSCotacaoItemParticipanteDTO , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT Cotacao_ArrayOfCotacaoItemParticipanteDTO
	Local cSoap := ""
	aEval( ::oWSCotacaoItemParticipanteDTO , {|x| cSoap := cSoap  +  WSSoapValue("CotacaoItemParticipanteDTO", x , x , "CotacaoItemParticipanteDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.)  } ) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Cotacao_ArrayOfCotacaoItemParticipanteDTO
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_COTACAOITEMPARTICIPANTEDTO","CotacaoItemParticipanteDTO",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSCotacaoItemParticipanteDTO , Cotacao_CotacaoItemParticipanteDTO():New() )
			::oWSCotacaoItemParticipanteDTO[len(::oWSCotacaoItemParticipanteDTO)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure ArrayOfCotacaoItemTaxaDTO

WSSTRUCT Cotacao_ArrayOfCotacaoItemTaxaDTO
	WSDATA   oWSCotacaoItemTaxaDTO     AS Cotacao_CotacaoItemTaxaDTO OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Cotacao_ArrayOfCotacaoItemTaxaDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Cotacao_ArrayOfCotacaoItemTaxaDTO
	::oWSCotacaoItemTaxaDTO := {} // Array Of  Cotacao_COTACAOITEMTAXADTO():New()
Return

WSMETHOD CLONE WSCLIENT Cotacao_ArrayOfCotacaoItemTaxaDTO
	Local oClone := Cotacao_ArrayOfCotacaoItemTaxaDTO():NEW()
	oClone:oWSCotacaoItemTaxaDTO := NIL
	If ::oWSCotacaoItemTaxaDTO <> NIL 
		oClone:oWSCotacaoItemTaxaDTO := {}
		aEval( ::oWSCotacaoItemTaxaDTO , { |x| aadd( oClone:oWSCotacaoItemTaxaDTO , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT Cotacao_ArrayOfCotacaoItemTaxaDTO
	Local cSoap := ""
	aEval( ::oWSCotacaoItemTaxaDTO , {|x| cSoap := cSoap  +  WSSoapValue("CotacaoItemTaxaDTO", x , x , "CotacaoItemTaxaDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.)  } ) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Cotacao_ArrayOfCotacaoItemTaxaDTO
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_COTACAOITEMTAXADTO","CotacaoItemTaxaDTO",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSCotacaoItemTaxaDTO , Cotacao_CotacaoItemTaxaDTO():New() )
			::oWSCotacaoItemTaxaDTO[len(::oWSCotacaoItemTaxaDTO)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure ArrayOfCotacaoPropostaDTO

WSSTRUCT Cotacao_ArrayOfCotacaoPropostaDTO
	WSDATA   oWSCotacaoPropostaDTO     AS Cotacao_CotacaoPropostaDTO OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Cotacao_ArrayOfCotacaoPropostaDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Cotacao_ArrayOfCotacaoPropostaDTO
	::oWSCotacaoPropostaDTO := {} // Array Of  Cotacao_COTACAOPROPOSTADTO():New()
Return

WSMETHOD CLONE WSCLIENT Cotacao_ArrayOfCotacaoPropostaDTO
	Local oClone := Cotacao_ArrayOfCotacaoPropostaDTO():NEW()
	oClone:oWSCotacaoPropostaDTO := NIL
	If ::oWSCotacaoPropostaDTO <> NIL 
		oClone:oWSCotacaoPropostaDTO := {}
		aEval( ::oWSCotacaoPropostaDTO , { |x| aadd( oClone:oWSCotacaoPropostaDTO , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT Cotacao_ArrayOfCotacaoPropostaDTO
	Local cSoap := ""
	aEval( ::oWSCotacaoPropostaDTO , {|x| cSoap := cSoap  +  WSSoapValue("CotacaoPropostaDTO", x , x , "CotacaoPropostaDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.)  } ) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Cotacao_ArrayOfCotacaoPropostaDTO
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_COTACAOPROPOSTADTO","CotacaoPropostaDTO",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSCotacaoPropostaDTO , Cotacao_CotacaoPropostaDTO():New() )
			::oWSCotacaoPropostaDTO[len(::oWSCotacaoPropostaDTO)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure CotacaoItemEnderecoDTO

WSSTRUCT Cotacao_CotacaoItemEnderecoDTO
	WSDATA   ndQtEntrega               AS int OPTIONAL
	WSDATA   nnSqItemEndereco          AS int OPTIONAL
	WSDATA   csCdCobrancaEndereco      AS string OPTIONAL
	WSDATA   csCdEmpresaCobrancaEndereco AS string OPTIONAL
	WSDATA   csCdEmpresaEntregaEndereco AS string OPTIONAL
	WSDATA   csCdEmpresaFaturamentoEndereco AS string OPTIONAL
	WSDATA   csCdEntregaEndereco       AS string OPTIONAL
	WSDATA   csCdFaturamentoEndereco   AS string OPTIONAL
	WSDATA   csCdItemRequisicaoEmpresa AS string OPTIONAL
	WSDATA   csCdRequisicaoEmpresa     AS string OPTIONAL
	WSDATA   ctDtEntrega               AS dateTime OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Cotacao_CotacaoItemEnderecoDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Cotacao_CotacaoItemEnderecoDTO
Return

WSMETHOD CLONE WSCLIENT Cotacao_CotacaoItemEnderecoDTO
	Local oClone := Cotacao_CotacaoItemEnderecoDTO():NEW()
	oClone:ndQtEntrega          := ::ndQtEntrega
	oClone:nnSqItemEndereco     := ::nnSqItemEndereco
	oClone:csCdCobrancaEndereco := ::csCdCobrancaEndereco
	oClone:csCdEmpresaCobrancaEndereco := ::csCdEmpresaCobrancaEndereco
	oClone:csCdEmpresaEntregaEndereco := ::csCdEmpresaEntregaEndereco
	oClone:csCdEmpresaFaturamentoEndereco := ::csCdEmpresaFaturamentoEndereco
	oClone:csCdEntregaEndereco  := ::csCdEntregaEndereco
	oClone:csCdFaturamentoEndereco := ::csCdFaturamentoEndereco
	oClone:csCdItemRequisicaoEmpresa := ::csCdItemRequisicaoEmpresa
	oClone:csCdRequisicaoEmpresa := ::csCdRequisicaoEmpresa
	oClone:ctDtEntrega          := ::ctDtEntrega
Return oClone

WSMETHOD SOAPSEND WSCLIENT Cotacao_CotacaoItemEnderecoDTO
	Local cSoap := ""
	cSoap += WSSoapValue("dQtEntrega", ::ndQtEntrega, ::ndQtEntrega , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("nSqItemEndereco", ::nnSqItemEndereco, ::nnSqItemEndereco , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdCobrancaEndereco", ::csCdCobrancaEndereco, ::csCdCobrancaEndereco , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdEmpresaCobrancaEndereco", ::csCdEmpresaCobrancaEndereco, ::csCdEmpresaCobrancaEndereco , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdEmpresaEntregaEndereco", ::csCdEmpresaEntregaEndereco, ::csCdEmpresaEntregaEndereco , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdEmpresaFaturamentoEndereco", ::csCdEmpresaFaturamentoEndereco, ::csCdEmpresaFaturamentoEndereco , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdEntregaEndereco", ::csCdEntregaEndereco, ::csCdEntregaEndereco , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdFaturamentoEndereco", ::csCdFaturamentoEndereco, ::csCdFaturamentoEndereco , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdItemRequisicaoEmpresa", ::csCdItemRequisicaoEmpresa, ::csCdItemRequisicaoEmpresa , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdRequisicaoEmpresa", ::csCdRequisicaoEmpresa, ::csCdRequisicaoEmpresa , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("tDtEntrega", ::ctDtEntrega, ::ctDtEntrega , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Cotacao_CotacaoItemEnderecoDTO
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::ndQtEntrega        :=  WSAdvValue( oResponse,"_DQTENTREGA","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::nnSqItemEndereco   :=  WSAdvValue( oResponse,"_NSQITEMENDERECO","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::csCdCobrancaEndereco :=  WSAdvValue( oResponse,"_SCDCOBRANCAENDERECO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdEmpresaCobrancaEndereco :=  WSAdvValue( oResponse,"_SCDEMPRESACOBRANCAENDERECO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdEmpresaEntregaEndereco :=  WSAdvValue( oResponse,"_SCDEMPRESAENTREGAENDERECO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdEmpresaFaturamentoEndereco :=  WSAdvValue( oResponse,"_SCDEMPRESAFATURAMENTOENDERECO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdEntregaEndereco :=  WSAdvValue( oResponse,"_SCDENTREGAENDERECO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdFaturamentoEndereco :=  WSAdvValue( oResponse,"_SCDFATURAMENTOENDERECO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdItemRequisicaoEmpresa :=  WSAdvValue( oResponse,"_SCDITEMREQUISICAOEMPRESA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdRequisicaoEmpresa :=  WSAdvValue( oResponse,"_SCDREQUISICAOEMPRESA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::ctDtEntrega        :=  WSAdvValue( oResponse,"_TDTENTREGA","dateTime",NIL,NIL,NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure CotacaoItemParticipanteDTO

WSSTRUCT Cotacao_CotacaoItemParticipanteDTO
	WSDATA   nbFlHomologado            AS int OPTIONAL
	WSDATA   nnCdItem                  AS long OPTIONAL
	WSDATA   csCdEmpresa               AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Cotacao_CotacaoItemParticipanteDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Cotacao_CotacaoItemParticipanteDTO
Return

WSMETHOD CLONE WSCLIENT Cotacao_CotacaoItemParticipanteDTO
	Local oClone := Cotacao_CotacaoItemParticipanteDTO():NEW()
	oClone:nbFlHomologado       := ::nbFlHomologado
	oClone:nnCdItem             := ::nnCdItem
	oClone:csCdEmpresa          := ::csCdEmpresa
Return oClone

WSMETHOD SOAPSEND WSCLIENT Cotacao_CotacaoItemParticipanteDTO
	Local cSoap := ""
	cSoap += WSSoapValue("bFlHomologado", ::nbFlHomologado, ::nbFlHomologado , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("nCdItem", ::nnCdItem, ::nnCdItem , "long", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdEmpresa", ::csCdEmpresa, ::csCdEmpresa , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Cotacao_CotacaoItemParticipanteDTO
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::nbFlHomologado     :=  WSAdvValue( oResponse,"_BFLHOMOLOGADO","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::nnCdItem           :=  WSAdvValue( oResponse,"_NCDITEM","long",NIL,NIL,NIL,"N",NIL,NIL) 
	::csCdEmpresa        :=  WSAdvValue( oResponse,"_SCDEMPRESA","string",NIL,NIL,NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure CotacaoItemTaxaDTO

WSSTRUCT Cotacao_CotacaoItemTaxaDTO
	WSDATA   nbFlIncluso               AS long OPTIONAL
	WSDATA   nnCdItem                  AS long OPTIONAL
	WSDATA   nnCdTaxa                  AS long OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Cotacao_CotacaoItemTaxaDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Cotacao_CotacaoItemTaxaDTO
Return

WSMETHOD CLONE WSCLIENT Cotacao_CotacaoItemTaxaDTO
	Local oClone := Cotacao_CotacaoItemTaxaDTO():NEW()
	oClone:nbFlIncluso          := ::nbFlIncluso
	oClone:nnCdItem             := ::nnCdItem
	oClone:nnCdTaxa             := ::nnCdTaxa
Return oClone

WSMETHOD SOAPSEND WSCLIENT Cotacao_CotacaoItemTaxaDTO
	Local cSoap := ""
	cSoap += WSSoapValue("bFlIncluso", ::nbFlIncluso, ::nbFlIncluso , "long", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("nCdItem", ::nnCdItem, ::nnCdItem , "long", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("nCdTaxa", ::nnCdTaxa, ::nnCdTaxa , "long", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Cotacao_CotacaoItemTaxaDTO
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::nbFlIncluso        :=  WSAdvValue( oResponse,"_BFLINCLUSO","long",NIL,NIL,NIL,"N",NIL,NIL) 
	::nnCdItem           :=  WSAdvValue( oResponse,"_NCDITEM","long",NIL,NIL,NIL,"N",NIL,NIL) 
	::nnCdTaxa           :=  WSAdvValue( oResponse,"_NCDTAXA","long",NIL,NIL,NIL,"N",NIL,NIL) 
Return

// WSDL Data Structure CotacaoPropostaDTO

WSSTRUCT Cotacao_CotacaoPropostaDTO
	WSDATA   nbFlComRecap              AS int OPTIONAL
	WSDATA   ndPcDesconto              AS decimal OPTIONAL
	WSDATA   ndVlLiquido               AS decimal OPTIONAL
	WSDATA   ndVlProposta              AS decimal OPTIONAL
	WSDATA   ndVlUnidade               AS decimal OPTIONAL
	WSDATA   ndVlUnitario              AS decimal OPTIONAL
	WSDATA   oWSlstCotacaoPropostaEnderecoDTO AS Cotacao_ArrayOfCotacaoPropostaEnderecoDTO OPTIONAL
	WSDATA   oWSlstCotacaoPropostaTaxaDTO AS Cotacao_ArrayOfCotacaoPropostaTaxaDTO OPTIONAL
	WSDATA   oWSlstPropostaRequisicaoDTO AS Cotacao_ArrayOfPropostaRequisicaoDTO OPTIONAL
	WSDATA   nnCdOrigem                AS long OPTIONAL
	WSDATA   nnCdProposta              AS long OPTIONAL
	WSDATA   nnCdSituacao              AS long OPTIONAL
	WSDATA   nnIdVencedor              AS int OPTIONAL
	WSDATA   nnNrRanking               AS int OPTIONAL
	WSDATA   nnQtLoteMinimo            AS decimal OPTIONAL
	WSDATA   nnQtLoteMultiplo          AS decimal OPTIONAL
	WSDATA   csCdCondicaoPagamento     AS string OPTIONAL
	WSDATA   csCdEmpresa               AS string OPTIONAL
	WSDATA   csCdFrete                 AS string OPTIONAL
	WSDATA   csCdIva                   AS string OPTIONAL
	WSDATA   csCdMarca                 AS string OPTIONAL
	WSDATA   csCdNmb                   AS string OPTIONAL
	WSDATA   csCdProdutoFornecedor     AS string OPTIONAL
	WSDATA   csCdUsuario               AS string OPTIONAL
	WSDATA   csDsMotivoDesclassificado AS string OPTIONAL
	WSDATA   csDsObservacao            AS string OPTIONAL
	WSDATA   ctDtAlteracao             AS dateTime OPTIONAL
	WSDATA   ctDtProposta              AS dateTime OPTIONAL
	WSDATA   ctDtValidade              AS dateTime OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Cotacao_CotacaoPropostaDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Cotacao_CotacaoPropostaDTO
Return

WSMETHOD CLONE WSCLIENT Cotacao_CotacaoPropostaDTO
	Local oClone := Cotacao_CotacaoPropostaDTO():NEW()
	oClone:nbFlComRecap         := ::nbFlComRecap
	oClone:ndPcDesconto         := ::ndPcDesconto
	oClone:ndVlLiquido          := ::ndVlLiquido
	oClone:ndVlProposta         := ::ndVlProposta
	oClone:ndVlUnidade          := ::ndVlUnidade
	oClone:ndVlUnitario         := ::ndVlUnitario
	oClone:oWSlstCotacaoPropostaEnderecoDTO := IIF(::oWSlstCotacaoPropostaEnderecoDTO = NIL , NIL , ::oWSlstCotacaoPropostaEnderecoDTO:Clone() )
	oClone:oWSlstCotacaoPropostaTaxaDTO := IIF(::oWSlstCotacaoPropostaTaxaDTO = NIL , NIL , ::oWSlstCotacaoPropostaTaxaDTO:Clone() )
	oClone:oWSlstPropostaRequisicaoDTO := IIF(::oWSlstPropostaRequisicaoDTO = NIL , NIL , ::oWSlstPropostaRequisicaoDTO:Clone() )
	oClone:nnCdOrigem           := ::nnCdOrigem
	oClone:nnCdProposta         := ::nnCdProposta
	oClone:nnCdSituacao         := ::nnCdSituacao
	oClone:nnIdVencedor         := ::nnIdVencedor
	oClone:nnNrRanking          := ::nnNrRanking
	oClone:nnQtLoteMinimo       := ::nnQtLoteMinimo
	oClone:nnQtLoteMultiplo     := ::nnQtLoteMultiplo
	oClone:csCdCondicaoPagamento := ::csCdCondicaoPagamento
	oClone:csCdEmpresa          := ::csCdEmpresa
	oClone:csCdFrete            := ::csCdFrete
	oClone:csCdIva              := ::csCdIva
	oClone:csCdMarca            := ::csCdMarca
	oClone:csCdNmb              := ::csCdNmb
	oClone:csCdProdutoFornecedor := ::csCdProdutoFornecedor
	oClone:csCdUsuario          := ::csCdUsuario
	oClone:csDsMotivoDesclassificado := ::csDsMotivoDesclassificado
	oClone:csDsObservacao       := ::csDsObservacao
	oClone:ctDtAlteracao        := ::ctDtAlteracao
	oClone:ctDtProposta         := ::ctDtProposta
	oClone:ctDtValidade         := ::ctDtValidade
Return oClone

WSMETHOD SOAPSEND WSCLIENT Cotacao_CotacaoPropostaDTO
	Local cSoap := ""
	cSoap += WSSoapValue("bFlComRecap", ::nbFlComRecap, ::nbFlComRecap , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("dPcDesconto", ::ndPcDesconto, ::ndPcDesconto , "decimal", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("dVlLiquido", ::ndVlLiquido, ::ndVlLiquido , "decimal", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("dVlProposta", ::ndVlProposta, ::ndVlProposta , "decimal", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("dVlUnidade", ::ndVlUnidade, ::ndVlUnidade , "decimal", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("dVlUnitario", ::ndVlUnitario, ::ndVlUnitario , "decimal", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("lstCotacaoPropostaEnderecoDTO", ::oWSlstCotacaoPropostaEnderecoDTO, ::oWSlstCotacaoPropostaEnderecoDTO , "ArrayOfCotacaoPropostaEnderecoDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("lstCotacaoPropostaTaxaDTO", ::oWSlstCotacaoPropostaTaxaDTO, ::oWSlstCotacaoPropostaTaxaDTO , "ArrayOfCotacaoPropostaTaxaDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("lstPropostaRequisicaoDTO", ::oWSlstPropostaRequisicaoDTO, ::oWSlstPropostaRequisicaoDTO , "ArrayOfPropostaRequisicaoDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("nCdOrigem", ::nnCdOrigem, ::nnCdOrigem , "long", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("nCdProposta", ::nnCdProposta, ::nnCdProposta , "long", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("nCdSituacao", ::nnCdSituacao, ::nnCdSituacao , "long", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("nIdVencedor", ::nnIdVencedor, ::nnIdVencedor , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("nNrRanking", ::nnNrRanking, ::nnNrRanking , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("nQtLoteMinimo", ::nnQtLoteMinimo, ::nnQtLoteMinimo , "decimal", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("nQtLoteMultiplo", ::nnQtLoteMultiplo, ::nnQtLoteMultiplo , "decimal", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdCondicaoPagamento", ::csCdCondicaoPagamento, ::csCdCondicaoPagamento , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdEmpresa", ::csCdEmpresa, ::csCdEmpresa , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdFrete", ::csCdFrete, ::csCdFrete , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdIva", ::csCdIva, ::csCdIva , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdMarca", ::csCdMarca, ::csCdMarca , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdNmb", ::csCdNmb, ::csCdNmb , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdProdutoFornecedor", ::csCdProdutoFornecedor, ::csCdProdutoFornecedor , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdUsuario", ::csCdUsuario, ::csCdUsuario , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sDsMotivoDesclassificado", ::csDsMotivoDesclassificado, ::csDsMotivoDesclassificado , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sDsObservacao", ::csDsObservacao, ::csDsObservacao , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("tDtAlteracao", ::ctDtAlteracao, ::ctDtAlteracao , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("tDtProposta", ::ctDtProposta, ::ctDtProposta , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("tDtValidade", ::ctDtValidade, ::ctDtValidade , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Cotacao_CotacaoPropostaDTO
	Local oNode7
	Local oNode8
	Local oNode9
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::nbFlComRecap       :=  WSAdvValue( oResponse,"_BFLCOMRECAP","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::ndPcDesconto       :=  WSAdvValue( oResponse,"_DPCDESCONTO","decimal",NIL,NIL,NIL,"N",NIL,NIL) 
	::ndVlLiquido        :=  WSAdvValue( oResponse,"_DVLLIQUIDO","decimal",NIL,NIL,NIL,"N",NIL,NIL) 
	::ndVlProposta       :=  WSAdvValue( oResponse,"_DVLPROPOSTA","decimal",NIL,NIL,NIL,"N",NIL,NIL) 
	::ndVlUnidade        :=  WSAdvValue( oResponse,"_DVLUNIDADE","decimal",NIL,NIL,NIL,"N",NIL,NIL) 
	::ndVlUnitario       :=  WSAdvValue( oResponse,"_DVLUNITARIO","decimal",NIL,NIL,NIL,"N",NIL,NIL) 
	oNode7 :=  WSAdvValue( oResponse,"_LSTCOTACAOPROPOSTAENDERECODTO","ArrayOfCotacaoPropostaEnderecoDTO",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode7 != NIL
		::oWSlstCotacaoPropostaEnderecoDTO := Cotacao_ArrayOfCotacaoPropostaEnderecoDTO():New()
		::oWSlstCotacaoPropostaEnderecoDTO:SoapRecv(oNode7)
	EndIf
	oNode8 :=  WSAdvValue( oResponse,"_LSTCOTACAOPROPOSTATAXADTO","ArrayOfCotacaoPropostaTaxaDTO",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode8 != NIL
		::oWSlstCotacaoPropostaTaxaDTO := Cotacao_ArrayOfCotacaoPropostaTaxaDTO():New()
		::oWSlstCotacaoPropostaTaxaDTO:SoapRecv(oNode8)
	EndIf
	oNode9 :=  WSAdvValue( oResponse,"_LSTPROPOSTAREQUISICAODTO","ArrayOfPropostaRequisicaoDTO",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode9 != NIL
		::oWSlstPropostaRequisicaoDTO := Cotacao_ArrayOfPropostaRequisicaoDTO():New()
		::oWSlstPropostaRequisicaoDTO:SoapRecv(oNode9)
	EndIf
	::nnCdOrigem         :=  WSAdvValue( oResponse,"_NCDORIGEM","long",NIL,NIL,NIL,"N",NIL,NIL) 
	::nnCdProposta       :=  WSAdvValue( oResponse,"_NCDPROPOSTA","long",NIL,NIL,NIL,"N",NIL,NIL) 
	::nnCdSituacao       :=  WSAdvValue( oResponse,"_NCDSITUACAO","long",NIL,NIL,NIL,"N",NIL,NIL) 
	::nnIdVencedor       :=  WSAdvValue( oResponse,"_NIDVENCEDOR","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::nnNrRanking        :=  WSAdvValue( oResponse,"_NNRRANKING","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::nnQtLoteMinimo     :=  WSAdvValue( oResponse,"_NQTLOTEMINIMO","decimal",NIL,NIL,NIL,"N",NIL,NIL) 
	::nnQtLoteMultiplo   :=  WSAdvValue( oResponse,"_NQTLOTEMULTIPLO","decimal",NIL,NIL,NIL,"N",NIL,NIL) 
	::csCdCondicaoPagamento :=  WSAdvValue( oResponse,"_SCDCONDICAOPAGAMENTO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdEmpresa        :=  WSAdvValue( oResponse,"_SCDEMPRESA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdFrete          :=  WSAdvValue( oResponse,"_SCDFRETE","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdIva            :=  WSAdvValue( oResponse,"_SCDIVA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdMarca          :=  WSAdvValue( oResponse,"_SCDMARCA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdNmb            :=  WSAdvValue( oResponse,"_SCDNMB","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdProdutoFornecedor :=  WSAdvValue( oResponse,"_SCDPRODUTOFORNECEDOR","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdUsuario        :=  WSAdvValue( oResponse,"_SCDUSUARIO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csDsMotivoDesclassificado :=  WSAdvValue( oResponse,"_SDSMOTIVODESCLASSIFICADO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csDsObservacao     :=  WSAdvValue( oResponse,"_SDSOBSERVACAO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::ctDtAlteracao      :=  WSAdvValue( oResponse,"_TDTALTERACAO","dateTime",NIL,NIL,NIL,"S",NIL,NIL) 
	::ctDtProposta       :=  WSAdvValue( oResponse,"_TDTPROPOSTA","dateTime",NIL,NIL,NIL,"S",NIL,NIL) 
	::ctDtValidade       :=  WSAdvValue( oResponse,"_TDTVALIDADE","dateTime",NIL,NIL,NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure ArrayOfCotacaoPropostaEnderecoDTO

WSSTRUCT Cotacao_ArrayOfCotacaoPropostaEnderecoDTO
	WSDATA   oWSCotacaoPropostaEnderecoDTO AS Cotacao_CotacaoPropostaEnderecoDTO OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Cotacao_ArrayOfCotacaoPropostaEnderecoDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Cotacao_ArrayOfCotacaoPropostaEnderecoDTO
	::oWSCotacaoPropostaEnderecoDTO := {} // Array Of  Cotacao_COTACAOPROPOSTAENDERECODTO():New()
Return

WSMETHOD CLONE WSCLIENT Cotacao_ArrayOfCotacaoPropostaEnderecoDTO
	Local oClone := Cotacao_ArrayOfCotacaoPropostaEnderecoDTO():NEW()
	oClone:oWSCotacaoPropostaEnderecoDTO := NIL
	If ::oWSCotacaoPropostaEnderecoDTO <> NIL 
		oClone:oWSCotacaoPropostaEnderecoDTO := {}
		aEval( ::oWSCotacaoPropostaEnderecoDTO , { |x| aadd( oClone:oWSCotacaoPropostaEnderecoDTO , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT Cotacao_ArrayOfCotacaoPropostaEnderecoDTO
	Local cSoap := ""
	aEval( ::oWSCotacaoPropostaEnderecoDTO , {|x| cSoap := cSoap  +  WSSoapValue("CotacaoPropostaEnderecoDTO", x , x , "CotacaoPropostaEnderecoDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.)  } ) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Cotacao_ArrayOfCotacaoPropostaEnderecoDTO
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_COTACAOPROPOSTAENDERECODTO","CotacaoPropostaEnderecoDTO",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSCotacaoPropostaEnderecoDTO , Cotacao_CotacaoPropostaEnderecoDTO():New() )
			::oWSCotacaoPropostaEnderecoDTO[len(::oWSCotacaoPropostaEnderecoDTO)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure ArrayOfCotacaoPropostaTaxaDTO

WSSTRUCT Cotacao_ArrayOfCotacaoPropostaTaxaDTO
	WSDATA   oWSCotacaoPropostaTaxaDTO AS Cotacao_CotacaoPropostaTaxaDTO OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Cotacao_ArrayOfCotacaoPropostaTaxaDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Cotacao_ArrayOfCotacaoPropostaTaxaDTO
	::oWSCotacaoPropostaTaxaDTO := {} // Array Of  Cotacao_COTACAOPROPOSTATAXADTO():New()
Return

WSMETHOD CLONE WSCLIENT Cotacao_ArrayOfCotacaoPropostaTaxaDTO
	Local oClone := Cotacao_ArrayOfCotacaoPropostaTaxaDTO():NEW()
	oClone:oWSCotacaoPropostaTaxaDTO := NIL
	If ::oWSCotacaoPropostaTaxaDTO <> NIL 
		oClone:oWSCotacaoPropostaTaxaDTO := {}
		aEval( ::oWSCotacaoPropostaTaxaDTO , { |x| aadd( oClone:oWSCotacaoPropostaTaxaDTO , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT Cotacao_ArrayOfCotacaoPropostaTaxaDTO
	Local cSoap := ""
	aEval( ::oWSCotacaoPropostaTaxaDTO , {|x| cSoap := cSoap  +  WSSoapValue("CotacaoPropostaTaxaDTO", x , x , "CotacaoPropostaTaxaDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.)  } ) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Cotacao_ArrayOfCotacaoPropostaTaxaDTO
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_COTACAOPROPOSTATAXADTO","CotacaoPropostaTaxaDTO",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSCotacaoPropostaTaxaDTO , Cotacao_CotacaoPropostaTaxaDTO():New() )
			::oWSCotacaoPropostaTaxaDTO[len(::oWSCotacaoPropostaTaxaDTO)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure ArrayOfPropostaRequisicaoDTO

WSSTRUCT Cotacao_ArrayOfPropostaRequisicaoDTO
	WSDATA   oWSPropostaRequisicaoDTO  AS Cotacao_PropostaRequisicaoDTO OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Cotacao_ArrayOfPropostaRequisicaoDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Cotacao_ArrayOfPropostaRequisicaoDTO
	::oWSPropostaRequisicaoDTO := {} // Array Of  Cotacao_PROPOSTAREQUISICAODTO():New()
Return

WSMETHOD CLONE WSCLIENT Cotacao_ArrayOfPropostaRequisicaoDTO
	Local oClone := Cotacao_ArrayOfPropostaRequisicaoDTO():NEW()
	oClone:oWSPropostaRequisicaoDTO := NIL
	If ::oWSPropostaRequisicaoDTO <> NIL 
		oClone:oWSPropostaRequisicaoDTO := {}
		aEval( ::oWSPropostaRequisicaoDTO , { |x| aadd( oClone:oWSPropostaRequisicaoDTO , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT Cotacao_ArrayOfPropostaRequisicaoDTO
	Local cSoap := ""
	aEval( ::oWSPropostaRequisicaoDTO , {|x| cSoap := cSoap  +  WSSoapValue("PropostaRequisicaoDTO", x , x , "PropostaRequisicaoDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.)  } ) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Cotacao_ArrayOfPropostaRequisicaoDTO
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_PROPOSTAREQUISICAODTO","PropostaRequisicaoDTO",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSPropostaRequisicaoDTO , Cotacao_PropostaRequisicaoDTO():New() )
			::oWSPropostaRequisicaoDTO[len(::oWSPropostaRequisicaoDTO)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure CotacaoPropostaEnderecoDTO

WSSTRUCT Cotacao_CotacaoPropostaEnderecoDTO
	WSDATA   ndPcQuantidadeItem        AS decimal OPTIONAL
	WSDATA   ndQtFornecimento          AS decimal OPTIONAL
	WSDATA   ndQtPorUnidade            AS decimal OPTIONAL
	WSDATA   ndQtUnidade               AS decimal OPTIONAL
	WSDATA   ndVlFrete                 AS decimal OPTIONAL
	WSDATA   nnCdPropostaEndereco      AS long OPTIONAL
	WSDATA   nnQtDiasEntrega           AS decimal OPTIONAL
	WSDATA   nnSqItemEndereco          AS int OPTIONAL
	WSDATA   csCdTransportadora        AS string OPTIONAL
	WSDATA   csCdUnidadeFornecimento   AS string OPTIONAL
	WSDATA   csNmTransportadora        AS string OPTIONAL
	WSDATA   ctDtFornecimento          AS dateTime OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Cotacao_CotacaoPropostaEnderecoDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Cotacao_CotacaoPropostaEnderecoDTO
Return

WSMETHOD CLONE WSCLIENT Cotacao_CotacaoPropostaEnderecoDTO
	Local oClone := Cotacao_CotacaoPropostaEnderecoDTO():NEW()
	oClone:ndPcQuantidadeItem   := ::ndPcQuantidadeItem
	oClone:ndQtFornecimento     := ::ndQtFornecimento
	oClone:ndQtPorUnidade       := ::ndQtPorUnidade
	oClone:ndQtUnidade          := ::ndQtUnidade
	oClone:ndVlFrete            := ::ndVlFrete
	oClone:nnCdPropostaEndereco := ::nnCdPropostaEndereco
	oClone:nnQtDiasEntrega      := ::nnQtDiasEntrega
	oClone:nnSqItemEndereco     := ::nnSqItemEndereco
	oClone:csCdTransportadora   := ::csCdTransportadora
	oClone:csCdUnidadeFornecimento := ::csCdUnidadeFornecimento
	oClone:csNmTransportadora   := ::csNmTransportadora
	oClone:ctDtFornecimento     := ::ctDtFornecimento
Return oClone

WSMETHOD SOAPSEND WSCLIENT Cotacao_CotacaoPropostaEnderecoDTO
	Local cSoap := ""
	cSoap += WSSoapValue("dPcQuantidadeItem", ::ndPcQuantidadeItem, ::ndPcQuantidadeItem , "decimal", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("dQtFornecimento", ::ndQtFornecimento, ::ndQtFornecimento , "decimal", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("dQtPorUnidade", ::ndQtPorUnidade, ::ndQtPorUnidade , "decimal", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("dQtUnidade", ::ndQtUnidade, ::ndQtUnidade , "decimal", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("dVlFrete", ::ndVlFrete, ::ndVlFrete , "decimal", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("nCdPropostaEndereco", ::nnCdPropostaEndereco, ::nnCdPropostaEndereco , "long", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("nQtDiasEntrega", ::nnQtDiasEntrega, ::nnQtDiasEntrega , "decimal", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("nSqItemEndereco", ::nnSqItemEndereco, ::nnSqItemEndereco , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdTransportadora", ::csCdTransportadora, ::csCdTransportadora , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdUnidadeFornecimento", ::csCdUnidadeFornecimento, ::csCdUnidadeFornecimento , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sNmTransportadora", ::csNmTransportadora, ::csNmTransportadora , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("tDtFornecimento", ::ctDtFornecimento, ::ctDtFornecimento , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Cotacao_CotacaoPropostaEnderecoDTO
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::ndPcQuantidadeItem :=  WSAdvValue( oResponse,"_DPCQUANTIDADEITEM","decimal",NIL,NIL,NIL,"N",NIL,NIL) 
	::ndQtFornecimento   :=  WSAdvValue( oResponse,"_DQTFORNECIMENTO","decimal",NIL,NIL,NIL,"N",NIL,NIL) 
	::ndQtPorUnidade     :=  WSAdvValue( oResponse,"_DQTPORUNIDADE","decimal",NIL,NIL,NIL,"N",NIL,NIL) 
	::ndQtUnidade        :=  WSAdvValue( oResponse,"_DQTUNIDADE","decimal",NIL,NIL,NIL,"N",NIL,NIL) 
	::ndVlFrete          :=  WSAdvValue( oResponse,"_DVLFRETE","decimal",NIL,NIL,NIL,"N",NIL,NIL) 
	::nnCdPropostaEndereco :=  WSAdvValue( oResponse,"_NCDPROPOSTAENDERECO","long",NIL,NIL,NIL,"N",NIL,NIL) 
	::nnQtDiasEntrega    :=  WSAdvValue( oResponse,"_NQTDIASENTREGA","decimal",NIL,NIL,NIL,"N",NIL,NIL) 
	::nnSqItemEndereco   :=  WSAdvValue( oResponse,"_NSQITEMENDERECO","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::csCdTransportadora :=  WSAdvValue( oResponse,"_SCDTRANSPORTADORA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdUnidadeFornecimento :=  WSAdvValue( oResponse,"_SCDUNIDADEFORNECIMENTO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csNmTransportadora :=  WSAdvValue( oResponse,"_SNMTRANSPORTADORA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::ctDtFornecimento   :=  WSAdvValue( oResponse,"_TDTFORNECIMENTO","dateTime",NIL,NIL,NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure CotacaoPropostaTaxaDTO

WSSTRUCT Cotacao_CotacaoPropostaTaxaDTO
	WSDATA   nbFlIncluso               AS int OPTIONAL
	WSDATA   ndPcTaxa                  AS decimal OPTIONAL
	WSDATA   nnCdTaxa                  AS long OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Cotacao_CotacaoPropostaTaxaDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Cotacao_CotacaoPropostaTaxaDTO
Return

WSMETHOD CLONE WSCLIENT Cotacao_CotacaoPropostaTaxaDTO
	Local oClone := Cotacao_CotacaoPropostaTaxaDTO():NEW()
	oClone:nbFlIncluso          := ::nbFlIncluso
	oClone:ndPcTaxa             := ::ndPcTaxa
	oClone:nnCdTaxa             := ::nnCdTaxa
Return oClone

WSMETHOD SOAPSEND WSCLIENT Cotacao_CotacaoPropostaTaxaDTO
	Local cSoap := ""
	cSoap += WSSoapValue("bFlIncluso", ::nbFlIncluso, ::nbFlIncluso , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("dPcTaxa", ::ndPcTaxa, ::ndPcTaxa , "decimal", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("nCdTaxa", ::nnCdTaxa, ::nnCdTaxa , "long", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Cotacao_CotacaoPropostaTaxaDTO
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::nbFlIncluso        :=  WSAdvValue( oResponse,"_BFLINCLUSO","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::ndPcTaxa           :=  WSAdvValue( oResponse,"_DPCTAXA","decimal",NIL,NIL,NIL,"N",NIL,NIL) 
	::nnCdTaxa           :=  WSAdvValue( oResponse,"_NCDTAXA","long",NIL,NIL,NIL,"N",NIL,NIL) 
Return

// WSDL Data Structure PropostaRequisicaoDTO

WSSTRUCT Cotacao_PropostaRequisicaoDTO
	WSDATA   ndVlFrete                 AS decimal OPTIONAL
	WSDATA   oWSlstPropostaEntrega     AS Cotacao_ArrayOfPropostaEntregaDTO OPTIONAL
	WSDATA   nnCdPropostaEndereco      AS long OPTIONAL
	WSDATA   csCdRequisicaoEmpresa     AS string OPTIONAL
	WSDATA   csCdTransportadora        AS string OPTIONAL
	WSDATA   csNmTransportadora        AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Cotacao_PropostaRequisicaoDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Cotacao_PropostaRequisicaoDTO
Return

WSMETHOD CLONE WSCLIENT Cotacao_PropostaRequisicaoDTO
	Local oClone := Cotacao_PropostaRequisicaoDTO():NEW()
	oClone:ndVlFrete            := ::ndVlFrete
	oClone:oWSlstPropostaEntrega := IIF(::oWSlstPropostaEntrega = NIL , NIL , ::oWSlstPropostaEntrega:Clone() )
	oClone:nnCdPropostaEndereco := ::nnCdPropostaEndereco
	oClone:csCdRequisicaoEmpresa := ::csCdRequisicaoEmpresa
	oClone:csCdTransportadora   := ::csCdTransportadora
	oClone:csNmTransportadora   := ::csNmTransportadora
Return oClone

WSMETHOD SOAPSEND WSCLIENT Cotacao_PropostaRequisicaoDTO
	Local cSoap := ""
	cSoap += WSSoapValue("dVlFrete", ::ndVlFrete, ::ndVlFrete , "decimal", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("lstPropostaEntrega", ::oWSlstPropostaEntrega, ::oWSlstPropostaEntrega , "ArrayOfPropostaEntregaDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("nCdPropostaEndereco", ::nnCdPropostaEndereco, ::nnCdPropostaEndereco , "long", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdRequisicaoEmpresa", ::csCdRequisicaoEmpresa, ::csCdRequisicaoEmpresa , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdTransportadora", ::csCdTransportadora, ::csCdTransportadora , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sNmTransportadora", ::csNmTransportadora, ::csNmTransportadora , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Cotacao_PropostaRequisicaoDTO
	Local oNode2
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::ndVlFrete          :=  WSAdvValue( oResponse,"_DVLFRETE","decimal",NIL,NIL,NIL,"N",NIL,NIL) 
	oNode2 :=  WSAdvValue( oResponse,"_LSTPROPOSTAENTREGA","ArrayOfPropostaEntregaDTO",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode2 != NIL
		::oWSlstPropostaEntrega := Cotacao_ArrayOfPropostaEntregaDTO():New()
		::oWSlstPropostaEntrega:SoapRecv(oNode2)
	EndIf
	::nnCdPropostaEndereco :=  WSAdvValue( oResponse,"_NCDPROPOSTAENDERECO","long",NIL,NIL,NIL,"N",NIL,NIL) 
	::csCdRequisicaoEmpresa :=  WSAdvValue( oResponse,"_SCDREQUISICAOEMPRESA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdTransportadora :=  WSAdvValue( oResponse,"_SCDTRANSPORTADORA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csNmTransportadora :=  WSAdvValue( oResponse,"_SNMTRANSPORTADORA","string",NIL,NIL,NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure ArrayOfPropostaEntregaDTO

WSSTRUCT Cotacao_ArrayOfPropostaEntregaDTO
	WSDATA   oWSPropostaEntregaDTO     AS Cotacao_PropostaEntregaDTO OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Cotacao_ArrayOfPropostaEntregaDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Cotacao_ArrayOfPropostaEntregaDTO
	::oWSPropostaEntregaDTO := {} // Array Of  Cotacao_PROPOSTAENTREGADTO():New()
Return

WSMETHOD CLONE WSCLIENT Cotacao_ArrayOfPropostaEntregaDTO
	Local oClone := Cotacao_ArrayOfPropostaEntregaDTO():NEW()
	oClone:oWSPropostaEntregaDTO := NIL
	If ::oWSPropostaEntregaDTO <> NIL 
		oClone:oWSPropostaEntregaDTO := {}
		aEval( ::oWSPropostaEntregaDTO , { |x| aadd( oClone:oWSPropostaEntregaDTO , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT Cotacao_ArrayOfPropostaEntregaDTO
	Local cSoap := ""
	aEval( ::oWSPropostaEntregaDTO , {|x| cSoap := cSoap  +  WSSoapValue("PropostaEntregaDTO", x , x , "PropostaEntregaDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.)  } ) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Cotacao_ArrayOfPropostaEntregaDTO
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_PROPOSTAENTREGADTO","PropostaEntregaDTO",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSPropostaEntregaDTO , Cotacao_PropostaEntregaDTO():New() )
			::oWSPropostaEntregaDTO[len(::oWSPropostaEntregaDTO)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure PropostaEntregaDTO

WSSTRUCT Cotacao_PropostaEntregaDTO
	WSDATA   ndQtFornecimento          AS decimal OPTIONAL
	WSDATA   csCdItemRequisicaoEmpresa AS string OPTIONAL
	WSDATA   ctDtFornecimento          AS dateTime OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Cotacao_PropostaEntregaDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Cotacao_PropostaEntregaDTO
Return

WSMETHOD CLONE WSCLIENT Cotacao_PropostaEntregaDTO
	Local oClone := Cotacao_PropostaEntregaDTO():NEW()
	oClone:ndQtFornecimento     := ::ndQtFornecimento
	oClone:csCdItemRequisicaoEmpresa := ::csCdItemRequisicaoEmpresa
	oClone:ctDtFornecimento     := ::ctDtFornecimento
Return oClone

WSMETHOD SOAPSEND WSCLIENT Cotacao_PropostaEntregaDTO
	Local cSoap := ""
	cSoap += WSSoapValue("dQtFornecimento", ::ndQtFornecimento, ::ndQtFornecimento , "decimal", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdItemRequisicaoEmpresa", ::csCdItemRequisicaoEmpresa, ::csCdItemRequisicaoEmpresa , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("tDtFornecimento", ::ctDtFornecimento, ::ctDtFornecimento , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Cotacao_PropostaEntregaDTO
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::ndQtFornecimento   :=  WSAdvValue( oResponse,"_DQTFORNECIMENTO","decimal",NIL,NIL,NIL,"N",NIL,NIL) 
	::csCdItemRequisicaoEmpresa :=  WSAdvValue( oResponse,"_SCDITEMREQUISICAOEMPRESA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::ctDtFornecimento   :=  WSAdvValue( oResponse,"_TDTFORNECIMENTO","dateTime",NIL,NIL,NIL,"S",NIL,NIL) 
Return


