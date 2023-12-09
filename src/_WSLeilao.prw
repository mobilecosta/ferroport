#INCLUDE "protheus.ch"
#INCLUDE "apwebsrv.ch"

/*=================================================================================================================*\
|| ############################################################################################################### ||
||																	                                               ||
|| # WSDL Service Leilao																			 			 # ||
|| # WSDL Location: https://srm-hml.paradigmabs.com.br/cassi-hml/services/Leilao.svc?wsdl						 # ||
||																	                                               ||
|| # Data - 26/09/2019 																							 # ||
||																	                                               ||
|| # Desc: WebService de cadastro de Leilao.																	 # ||
||																	                                               ||
|| # Obs: Alterações neste arquivo podem causar funcionamento incorreto.										 # ||
||																	                                               ||
|| ############################################################################################################### ||
\*=================================================================================================================*/
User Function _ARZFKQP ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSLeilao
------------------------------------------------------------------------------- */

WSCLIENT WSLeilao

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD RetornarLeilao
	WSMETHOD ProcessarLeilao
	WSMETHOD RetornarLeilaoComEmpresaSemDePara
	WSMETHOD HabilitarRetornarLeilao

	WSDATA   _URL                      AS String
	WSDATA   _CERT                     AS String
	WSDATA   _PRIVKEY                  AS String
	WSDATA   _PASSPHRASE               AS String
	WSDATA   _HEADOUT                  AS Array of String
	WSDATA   _COOKIES                  AS Array of String
	WSDATA   oWSRetornarLeilaoResult   AS Leilao_ArrayOfLeilaoDTO
	WSDATA   oWSlstLeilao              AS Leilao_ArrayOfLeilaoDTO
	WSDATA   oWSProcessarLeilaoResult  AS Leilao_RetornoDTO
	WSDATA   nnFlParticipa             AS int
	WSDATA   oWSRetornarLeilaoComEmpresaSemDeParaResult AS Leilao_ArrayOfProcessoLeilaoDTO
	WSDATA   oWSlstConfirmacaoNegociacaoDTO AS Leilao_ArrayOfConfirmacaoNegociacaoDTO
	WSDATA   oWSHabilitarRetornarLeilaoResult AS Leilao_RetornoDTO

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSLeilao
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.131227A-20190114 NG] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSLeilao
	::oWSRetornarLeilaoResult := Leilao_ARRAYOFLEILAODTO():New()
	::oWSlstLeilao       := Leilao_ARRAYOFLEILAODTO():New()
	::oWSProcessarLeilaoResult := Leilao_RETORNODTO():New()
	::oWSRetornarLeilaoComEmpresaSemDeParaResult := Leilao_ARRAYOFPROCESSOLEILAODTO():New()
	::oWSlstConfirmacaoNegociacaoDTO := Leilao_ARRAYOFCONFIRMACAONEGOCIACAODTO():New()
	::oWSHabilitarRetornarLeilaoResult := Leilao_RETORNODTO():New()
Return

WSMETHOD RESET WSCLIENT WSLeilao
	::oWSRetornarLeilaoResult := NIL 
	::oWSlstLeilao       := NIL 
	::oWSProcessarLeilaoResult := NIL 
	::nnFlParticipa      := NIL 
	::oWSRetornarLeilaoComEmpresaSemDeParaResult := NIL 
	::oWSlstConfirmacaoNegociacaoDTO := NIL 
	::oWSHabilitarRetornarLeilaoResult := NIL 
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSLeilao
Local oClone := WSLeilao():New()
	oClone:_URL          := ::_URL 
	oClone:_CERT         := ::_CERT 
	oClone:_PRIVKEY      := ::_PRIVKEY 
	oClone:_PASSPHRASE   := ::_PASSPHRASE 
	oClone:oWSRetornarLeilaoResult :=  IIF(::oWSRetornarLeilaoResult = NIL , NIL ,::oWSRetornarLeilaoResult:Clone() )
	oClone:oWSlstLeilao  :=  IIF(::oWSlstLeilao = NIL , NIL ,::oWSlstLeilao:Clone() )
	oClone:oWSProcessarLeilaoResult :=  IIF(::oWSProcessarLeilaoResult = NIL , NIL ,::oWSProcessarLeilaoResult:Clone() )
	oClone:nnFlParticipa := ::nnFlParticipa
	oClone:oWSRetornarLeilaoComEmpresaSemDeParaResult :=  IIF(::oWSRetornarLeilaoComEmpresaSemDeParaResult = NIL , NIL ,::oWSRetornarLeilaoComEmpresaSemDeParaResult:Clone() )
	oClone:oWSlstConfirmacaoNegociacaoDTO :=  IIF(::oWSlstConfirmacaoNegociacaoDTO = NIL , NIL ,::oWSlstConfirmacaoNegociacaoDTO:Clone() )
	oClone:oWSHabilitarRetornarLeilaoResult :=  IIF(::oWSHabilitarRetornarLeilaoResult = NIL , NIL ,::oWSHabilitarRetornarLeilaoResult:Clone() )
Return oClone

// WSDL Method RetornarLeilao of Service WSLeilao

WSMETHOD RetornarLeilao WSSEND NULLPARAM WSRECEIVE oWSRetornarLeilaoResult WSCLIENT WSLeilao
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<RetornarLeilao xmlns="http://tempuri.org/">'
cSoap += "</RetornarLeilao>"

Self:_HEADOUT := { "Authorization: Bearer " + U_NewToken() }
oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tempuri.org/ILeilao/RetornarLeilao",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	Lower(AllTrim(GetMv("MV_XPARURL"))) + "/services/Leilao.svc")

::Init()
::oWSRetornarLeilaoResult:SoapRecv( WSAdvValue( oXmlRet,"_RETORNARLEILAORESPONSE:_RETORNARLEILAORESULT","ArrayOfLeilaoDTO",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method ProcessarLeilao of Service WSLeilao

WSMETHOD ProcessarLeilao WSSEND oWSlstLeilao WSRECEIVE oWSProcessarLeilaoResult WSCLIENT WSLeilao
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ProcessarLeilao xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("lstLeilao", ::oWSlstLeilao, oWSlstLeilao , "ArrayOfLeilaoDTO", .F. , .F., 0 , "http://tempuri.org/", .F.,.F.) 
cSoap += "</ProcessarLeilao>"

Self:_HEADOUT := { "Authorization: Bearer " + U_NewToken() }
oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tempuri.org/ILeilao/ProcessarLeilao",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	Lower(AllTrim(GetMv("MV_XPARURL"))) + "/services/Leilao.svc")

::Init()
::oWSProcessarLeilaoResult:SoapRecv( WSAdvValue( oXmlRet,"_PROCESSARLEILAORESPONSE:_PROCESSARLEILAORESULT","RetornoDTO",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method RetornarLeilaoComEmpresaSemDePara of Service WSLeilao

WSMETHOD RetornarLeilaoComEmpresaSemDePara WSSEND nnFlParticipa WSRECEIVE oWSRetornarLeilaoComEmpresaSemDeParaResult WSCLIENT WSLeilao
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<RetornarLeilaoComEmpresaSemDePara xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("nFlParticipa", ::nnFlParticipa, nnFlParticipa , "int", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</RetornarLeilaoComEmpresaSemDePara>"

Self:_HEADOUT := { "Authorization: Bearer " + U_NewToken() }
oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tempuri.org/ILeilao/RetornarLeilaoComEmpresaSemDePara",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	Lower(AllTrim(GetMv("MV_XPARURL"))) + "/services/Leilao.svc")

::Init()
::oWSRetornarLeilaoComEmpresaSemDeParaResult:SoapRecv( WSAdvValue( oXmlRet,"_RETORNARLEILAOCOMEMPRESASEMDEPARARESPONSE:_RETORNARLEILAOCOMEMPRESASEMDEPARARESULT","ArrayOfProcessoLeilaoDTO",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method HabilitarRetornarLeilao of Service WSLeilao

WSMETHOD HabilitarRetornarLeilao WSSEND oWSlstConfirmacaoNegociacaoDTO WSRECEIVE oWSHabilitarRetornarLeilaoResult WSCLIENT WSLeilao
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<HabilitarRetornarLeilao xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("lstConfirmacaoNegociacaoDTO", ::oWSlstConfirmacaoNegociacaoDTO, oWSlstConfirmacaoNegociacaoDTO , "ArrayOfConfirmacaoNegociacaoDTO", .F. , .F., 0 , "http://tempuri.org/", .F.,.F.) 
cSoap += "</HabilitarRetornarLeilao>"

Self:_HEADOUT := { "Authorization: Bearer " + U_NewToken() }
oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tempuri.org/ILeilao/HabilitarRetornarLeilao",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	Lower(AllTrim(GetMv("MV_XPARURL"))) + "/services/Leilao.svc")

::Init()
::oWSHabilitarRetornarLeilaoResult:SoapRecv( WSAdvValue( oXmlRet,"_HABILITARRETORNARLEILAORESPONSE:_HABILITARRETORNARLEILAORESULT","RetornoDTO",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.


// WSDL Data Structure ArrayOfLeilaoDTO

WSSTRUCT Leilao_ArrayOfLeilaoDTO
	WSDATA   oWSLeilaoDTO              AS Leilao_LeilaoDTO OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Leilao_ArrayOfLeilaoDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Leilao_ArrayOfLeilaoDTO
	::oWSLeilaoDTO         := {} // Array Of  Leilao_LEILAODTO():New()
Return

WSMETHOD CLONE WSCLIENT Leilao_ArrayOfLeilaoDTO
	Local oClone := Leilao_ArrayOfLeilaoDTO():NEW()
	oClone:oWSLeilaoDTO := NIL
	If ::oWSLeilaoDTO <> NIL 
		oClone:oWSLeilaoDTO := {}
		aEval( ::oWSLeilaoDTO , { |x| aadd( oClone:oWSLeilaoDTO , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT Leilao_ArrayOfLeilaoDTO
	Local cSoap := ""
	aEval( ::oWSLeilaoDTO , {|x| cSoap := cSoap  +  WSSoapValue("LeilaoDTO", x , x , "LeilaoDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.)  } ) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Leilao_ArrayOfLeilaoDTO
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_LEILAODTO","LeilaoDTO",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSLeilaoDTO , Leilao_LeilaoDTO():New() )
			::oWSLeilaoDTO[len(::oWSLeilaoDTO)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure RetornoDTO

WSSTRUCT Leilao_RetornoDTO
	WSDATA   oWSlstWbtLogDTO           AS Leilao_ArrayOfWbtLogDTO OPTIONAL
	WSDATA   nnIdRetorno               AS long OPTIONAL
	WSDATA   csNrToken                 AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Leilao_RetornoDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Leilao_RetornoDTO
Return

WSMETHOD CLONE WSCLIENT Leilao_RetornoDTO
	Local oClone := Leilao_RetornoDTO():NEW()
	oClone:oWSlstWbtLogDTO      := IIF(::oWSlstWbtLogDTO = NIL , NIL , ::oWSlstWbtLogDTO:Clone() )
	oClone:nnIdRetorno          := ::nnIdRetorno
	oClone:csNrToken            := ::csNrToken
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Leilao_RetornoDTO
	Local oNode1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_LSTWBTLOGDTO","ArrayOfWbtLogDTO",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode1 != NIL
		::oWSlstWbtLogDTO := Leilao_ArrayOfWbtLogDTO():New()
		::oWSlstWbtLogDTO:SoapRecv(oNode1)
	EndIf
	::nnIdRetorno        :=  WSAdvValue( oResponse,"_NIDRETORNO","long",NIL,NIL,NIL,"N",NIL,NIL) 
	::csNrToken          :=  WSAdvValue( oResponse,"_SNRTOKEN","string",NIL,NIL,NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure ArrayOfProcessoLeilaoDTO

WSSTRUCT Leilao_ArrayOfProcessoLeilaoDTO
	WSDATA   oWSProcessoLeilaoDTO      AS Leilao_ProcessoLeilaoDTO OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Leilao_ArrayOfProcessoLeilaoDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Leilao_ArrayOfProcessoLeilaoDTO
	::oWSProcessoLeilaoDTO := {} // Array Of  Leilao_PROCESSOLEILAODTO():New()
Return

WSMETHOD CLONE WSCLIENT Leilao_ArrayOfProcessoLeilaoDTO
	Local oClone := Leilao_ArrayOfProcessoLeilaoDTO():NEW()
	oClone:oWSProcessoLeilaoDTO := NIL
	If ::oWSProcessoLeilaoDTO <> NIL 
		oClone:oWSProcessoLeilaoDTO := {}
		aEval( ::oWSProcessoLeilaoDTO , { |x| aadd( oClone:oWSProcessoLeilaoDTO , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Leilao_ArrayOfProcessoLeilaoDTO
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_PROCESSOLEILAODTO","ProcessoLeilaoDTO",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSProcessoLeilaoDTO , Leilao_ProcessoLeilaoDTO():New() )
			::oWSProcessoLeilaoDTO[len(::oWSProcessoLeilaoDTO)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure ArrayOfConfirmacaoNegociacaoDTO

WSSTRUCT Leilao_ArrayOfConfirmacaoNegociacaoDTO
	WSDATA   oWSConfirmacaoNegociacaoDTO AS Leilao_ConfirmacaoNegociacaoDTO OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Leilao_ArrayOfConfirmacaoNegociacaoDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Leilao_ArrayOfConfirmacaoNegociacaoDTO
	::oWSConfirmacaoNegociacaoDTO := {} // Array Of  Leilao_CONFIRMACAONEGOCIACAODTO():New()
Return

WSMETHOD CLONE WSCLIENT Leilao_ArrayOfConfirmacaoNegociacaoDTO
	Local oClone := Leilao_ArrayOfConfirmacaoNegociacaoDTO():NEW()
	oClone:oWSConfirmacaoNegociacaoDTO := NIL
	If ::oWSConfirmacaoNegociacaoDTO <> NIL 
		oClone:oWSConfirmacaoNegociacaoDTO := {}
		aEval( ::oWSConfirmacaoNegociacaoDTO , { |x| aadd( oClone:oWSConfirmacaoNegociacaoDTO , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT Leilao_ArrayOfConfirmacaoNegociacaoDTO
	Local cSoap := ""
	aEval( ::oWSConfirmacaoNegociacaoDTO , {|x| cSoap := cSoap  +  WSSoapValue("ConfirmacaoNegociacaoDTO", x , x , "ConfirmacaoNegociacaoDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.)  } ) 
Return cSoap

// WSDL Data Structure LeilaoDTO

WSSTRUCT Leilao_LeilaoDTO
	WSDATA   nbFlChatBilateral         AS int OPTIONAL
	WSDATA   nbFlFaseAnalise           AS int OPTIONAL
	WSDATA   nbFlMostraParticipante    AS int OPTIONAL
	WSDATA   nbFlProrroga              AS int OPTIONAL
	WSDATA   nbFlRestrita              AS int OPTIONAL
	WSDATA   nbFlTermo                 AS int OPTIONAL
	WSDATA   ndVlVariacaoMax           AS decimal OPTIONAL
	WSDATA   ndVlVariacaoMin           AS decimal OPTIONAL
	WSDATA   oWSlstLeilaoItemDTO       AS Leilao_ArrayOfLeilaoItemDTO OPTIONAL
	WSDATA   oWSlstLeilaoParticipanteDTO AS Leilao_ArrayOfLeilaoParticipanteDTO OPTIONAL
	WSDATA   nnCdSituacao              AS long OPTIONAL
	WSDATA   nnIdApuracao              AS int OPTIONAL
	WSDATA   nnIdEstilo                AS int OPTIONAL
	WSDATA   nnIdLeilao                AS int OPTIONAL
	WSDATA   nnIdTipoNegociacao        AS int OPTIONAL
	WSDATA   nnIdVariacao              AS int OPTIONAL
	WSDATA   nnVlProrroga              AS decimal OPTIONAL
	WSDATA   nnVlProrrogaCondicao      AS decimal OPTIONAL
	WSDATA   csCdCondicaoPagamento     AS string OPTIONAL
	WSDATA   csCdEmpresa               AS string OPTIONAL
	WSDATA   csCdEmpresaRequisicao     AS string OPTIONAL
	WSDATA   csCdFrete                 AS string OPTIONAL
	WSDATA   csCdLeilaoErp             AS string OPTIONAL
	WSDATA   csCdLeilaoWbc             AS string OPTIONAL
	WSDATA   csCdMoeda                 AS string OPTIONAL
	WSDATA   csCdUsuario               AS string OPTIONAL
	WSDATA   csDsLeilao                AS string OPTIONAL
	WSDATA   csDsTermo                 AS string OPTIONAL
	WSDATA   ctDtCadastro              AS dateTime OPTIONAL
	WSDATA   ctDtFinal                 AS dateTime OPTIONAL
	WSDATA   ctDtInicial               AS dateTime OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Leilao_LeilaoDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Leilao_LeilaoDTO
Return

WSMETHOD CLONE WSCLIENT Leilao_LeilaoDTO
	Local oClone := Leilao_LeilaoDTO():NEW()
	oClone:nbFlChatBilateral    := ::nbFlChatBilateral
	oClone:nbFlFaseAnalise      := ::nbFlFaseAnalise
	oClone:nbFlMostraParticipante := ::nbFlMostraParticipante
	oClone:nbFlProrroga         := ::nbFlProrroga
	oClone:nbFlRestrita         := ::nbFlRestrita
	oClone:nbFlTermo            := ::nbFlTermo
	oClone:ndVlVariacaoMax      := ::ndVlVariacaoMax
	oClone:ndVlVariacaoMin      := ::ndVlVariacaoMin
	oClone:oWSlstLeilaoItemDTO  := IIF(::oWSlstLeilaoItemDTO = NIL , NIL , ::oWSlstLeilaoItemDTO:Clone() )
	oClone:oWSlstLeilaoParticipanteDTO := IIF(::oWSlstLeilaoParticipanteDTO = NIL , NIL , ::oWSlstLeilaoParticipanteDTO:Clone() )
	oClone:nnCdSituacao         := ::nnCdSituacao
	oClone:nnIdApuracao         := ::nnIdApuracao
	oClone:nnIdEstilo           := ::nnIdEstilo
	oClone:nnIdLeilao           := ::nnIdLeilao
	oClone:nnIdTipoNegociacao   := ::nnIdTipoNegociacao
	oClone:nnIdVariacao         := ::nnIdVariacao
	oClone:nnVlProrroga         := ::nnVlProrroga
	oClone:nnVlProrrogaCondicao := ::nnVlProrrogaCondicao
	oClone:csCdCondicaoPagamento := ::csCdCondicaoPagamento
	oClone:csCdEmpresa          := ::csCdEmpresa
	oClone:csCdEmpresaRequisicao := ::csCdEmpresaRequisicao
	oClone:csCdFrete            := ::csCdFrete
	oClone:csCdLeilaoErp        := ::csCdLeilaoErp
	oClone:csCdLeilaoWbc        := ::csCdLeilaoWbc
	oClone:csCdMoeda            := ::csCdMoeda
	oClone:csCdUsuario          := ::csCdUsuario
	oClone:csDsLeilao           := ::csDsLeilao
	oClone:csDsTermo            := ::csDsTermo
	oClone:ctDtCadastro         := ::ctDtCadastro
	oClone:ctDtFinal            := ::ctDtFinal
	oClone:ctDtInicial          := ::ctDtInicial
Return oClone

WSMETHOD SOAPSEND WSCLIENT Leilao_LeilaoDTO
	Local cSoap := ""
	cSoap += WSSoapValue("bFlChatBilateral", ::nbFlChatBilateral, ::nbFlChatBilateral , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("bFlFaseAnalise", ::nbFlFaseAnalise, ::nbFlFaseAnalise , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("bFlMostraParticipante", ::nbFlMostraParticipante, ::nbFlMostraParticipante , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("bFlProrroga", ::nbFlProrroga, ::nbFlProrroga , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("bFlRestrita", ::nbFlRestrita, ::nbFlRestrita , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("bFlTermo", ::nbFlTermo, ::nbFlTermo , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("dVlVariacaoMax", ::ndVlVariacaoMax, ::ndVlVariacaoMax , "decimal", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("dVlVariacaoMin", ::ndVlVariacaoMin, ::ndVlVariacaoMin , "decimal", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("lstLeilaoItemDTO", ::oWSlstLeilaoItemDTO, ::oWSlstLeilaoItemDTO , "ArrayOfLeilaoItemDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("lstLeilaoParticipanteDTO", ::oWSlstLeilaoParticipanteDTO, ::oWSlstLeilaoParticipanteDTO , "ArrayOfLeilaoParticipanteDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("nCdSituacao", ::nnCdSituacao, ::nnCdSituacao , "long", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("nIdApuracao", ::nnIdApuracao, ::nnIdApuracao , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("nIdEstilo", ::nnIdEstilo, ::nnIdEstilo , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("nIdLeilao", ::nnIdLeilao, ::nnIdLeilao , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("nIdTipoNegociacao", ::nnIdTipoNegociacao, ::nnIdTipoNegociacao , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("nIdVariacao", ::nnIdVariacao, ::nnIdVariacao , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("nVlProrroga", ::nnVlProrroga, ::nnVlProrroga , "decimal", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("nVlProrrogaCondicao", ::nnVlProrrogaCondicao, ::nnVlProrrogaCondicao , "decimal", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdCondicaoPagamento", ::csCdCondicaoPagamento, ::csCdCondicaoPagamento , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdEmpresa", ::csCdEmpresa, ::csCdEmpresa , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdEmpresaRequisicao", ::csCdEmpresaRequisicao, ::csCdEmpresaRequisicao , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdFrete", ::csCdFrete, ::csCdFrete , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdLeilaoErp", ::csCdLeilaoErp, ::csCdLeilaoErp , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdLeilaoWbc", ::csCdLeilaoWbc, ::csCdLeilaoWbc , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdMoeda", ::csCdMoeda, ::csCdMoeda , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdUsuario", ::csCdUsuario, ::csCdUsuario , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sDsLeilao", ::csDsLeilao, ::csDsLeilao , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sDsTermo", ::csDsTermo, ::csDsTermo , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("tDtCadastro", ::ctDtCadastro, ::ctDtCadastro , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("tDtFinal", ::ctDtFinal, ::ctDtFinal , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("tDtInicial", ::ctDtInicial, ::ctDtInicial , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Leilao_LeilaoDTO
	Local oNode9
	Local oNode10
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::nbFlChatBilateral  :=  WSAdvValue( oResponse,"_BFLCHATBILATERAL","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::nbFlFaseAnalise    :=  WSAdvValue( oResponse,"_BFLFASEANALISE","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::nbFlMostraParticipante :=  WSAdvValue( oResponse,"_BFLMOSTRAPARTICIPANTE","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::nbFlProrroga       :=  WSAdvValue( oResponse,"_BFLPRORROGA","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::nbFlRestrita       :=  WSAdvValue( oResponse,"_BFLRESTRITA","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::nbFlTermo          :=  WSAdvValue( oResponse,"_BFLTERMO","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::ndVlVariacaoMax    :=  WSAdvValue( oResponse,"_DVLVARIACAOMAX","decimal",NIL,NIL,NIL,"N",NIL,NIL) 
	::ndVlVariacaoMin    :=  WSAdvValue( oResponse,"_DVLVARIACAOMIN","decimal",NIL,NIL,NIL,"N",NIL,NIL) 
	oNode9 :=  WSAdvValue( oResponse,"_LSTLEILAOITEMDTO","ArrayOfLeilaoItemDTO",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode9 != NIL
		::oWSlstLeilaoItemDTO := Leilao_ArrayOfLeilaoItemDTO():New()
		::oWSlstLeilaoItemDTO:SoapRecv(oNode9)
	EndIf
	oNode10 :=  WSAdvValue( oResponse,"_LSTLEILAOPARTICIPANTEDTO","ArrayOfLeilaoParticipanteDTO",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode10 != NIL
		::oWSlstLeilaoParticipanteDTO := Leilao_ArrayOfLeilaoParticipanteDTO():New()
		::oWSlstLeilaoParticipanteDTO:SoapRecv(oNode10)
	EndIf
	::nnCdSituacao       :=  WSAdvValue( oResponse,"_NCDSITUACAO","long",NIL,NIL,NIL,"N",NIL,NIL) 
	::nnIdApuracao       :=  WSAdvValue( oResponse,"_NIDAPURACAO","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::nnIdEstilo         :=  WSAdvValue( oResponse,"_NIDESTILO","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::nnIdLeilao         :=  WSAdvValue( oResponse,"_NIDLEILAO","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::nnIdTipoNegociacao :=  WSAdvValue( oResponse,"_NIDTIPONEGOCIACAO","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::nnIdVariacao       :=  WSAdvValue( oResponse,"_NIDVARIACAO","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::nnVlProrroga       :=  WSAdvValue( oResponse,"_NVLPRORROGA","decimal",NIL,NIL,NIL,"N",NIL,NIL) 
	::nnVlProrrogaCondicao :=  WSAdvValue( oResponse,"_NVLPRORROGACONDICAO","decimal",NIL,NIL,NIL,"N",NIL,NIL) 
	::csCdCondicaoPagamento :=  WSAdvValue( oResponse,"_SCDCONDICAOPAGAMENTO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdEmpresa        :=  WSAdvValue( oResponse,"_SCDEMPRESA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdEmpresaRequisicao :=  WSAdvValue( oResponse,"_SCDEMPRESAREQUISICAO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdFrete          :=  WSAdvValue( oResponse,"_SCDFRETE","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdLeilaoErp      :=  WSAdvValue( oResponse,"_SCDLEILAOERP","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdLeilaoWbc      :=  WSAdvValue( oResponse,"_SCDLEILAOWBC","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdMoeda          :=  WSAdvValue( oResponse,"_SCDMOEDA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdUsuario        :=  WSAdvValue( oResponse,"_SCDUSUARIO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csDsLeilao         :=  WSAdvValue( oResponse,"_SDSLEILAO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csDsTermo          :=  WSAdvValue( oResponse,"_SDSTERMO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::ctDtCadastro       :=  WSAdvValue( oResponse,"_TDTCADASTRO","dateTime",NIL,NIL,NIL,"S",NIL,NIL) 
	::ctDtFinal          :=  WSAdvValue( oResponse,"_TDTFINAL","dateTime",NIL,NIL,NIL,"S",NIL,NIL) 
	::ctDtInicial        :=  WSAdvValue( oResponse,"_TDTINICIAL","dateTime",NIL,NIL,NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure ArrayOfWbtLogDTO

WSSTRUCT Leilao_ArrayOfWbtLogDTO
	WSDATA   oWSWbtLogDTO              AS Leilao_WbtLogDTO OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Leilao_ArrayOfWbtLogDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Leilao_ArrayOfWbtLogDTO
	::oWSWbtLogDTO         := {} // Array Of  Leilao_WBTLOGDTO():New()
Return

WSMETHOD CLONE WSCLIENT Leilao_ArrayOfWbtLogDTO
	Local oClone := Leilao_ArrayOfWbtLogDTO():NEW()
	oClone:oWSWbtLogDTO := NIL
	If ::oWSWbtLogDTO <> NIL 
		oClone:oWSWbtLogDTO := {}
		aEval( ::oWSWbtLogDTO , { |x| aadd( oClone:oWSWbtLogDTO , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Leilao_ArrayOfWbtLogDTO
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_WBTLOGDTO","WbtLogDTO",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSWbtLogDTO , Leilao_WbtLogDTO():New() )
			::oWSWbtLogDTO[len(::oWSWbtLogDTO)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure ProcessoLeilaoDTO

WSSTRUCT Leilao_ProcessoLeilaoDTO
	WSDATA   csCdLeilaoWBC             AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Leilao_ProcessoLeilaoDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Leilao_ProcessoLeilaoDTO
Return

WSMETHOD CLONE WSCLIENT Leilao_ProcessoLeilaoDTO
	Local oClone := Leilao_ProcessoLeilaoDTO():NEW()
	oClone:csCdLeilaoWBC        := ::csCdLeilaoWBC
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Leilao_ProcessoLeilaoDTO
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::csCdLeilaoWBC      :=  WSAdvValue( oResponse,"_SCDLEILAOWBC","string",NIL,NIL,NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure ConfirmacaoNegociacaoDTO

WSSTRUCT Leilao_ConfirmacaoNegociacaoDTO
	WSDATA   oWSlstConfirmacaoNegociacaoItemDTO AS Leilao_ArrayOfConfirmacaoNegociacaoItemDTO OPTIONAL
	WSDATA   nnIdTipoProcesso          AS int OPTIONAL
	WSDATA   csCdProcessoWbc           AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Leilao_ConfirmacaoNegociacaoDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Leilao_ConfirmacaoNegociacaoDTO
Return

WSMETHOD CLONE WSCLIENT Leilao_ConfirmacaoNegociacaoDTO
	Local oClone := Leilao_ConfirmacaoNegociacaoDTO():NEW()
	oClone:oWSlstConfirmacaoNegociacaoItemDTO := IIF(::oWSlstConfirmacaoNegociacaoItemDTO = NIL , NIL , ::oWSlstConfirmacaoNegociacaoItemDTO:Clone() )
	oClone:nnIdTipoProcesso     := ::nnIdTipoProcesso
	oClone:csCdProcessoWbc      := ::csCdProcessoWbc
Return oClone

WSMETHOD SOAPSEND WSCLIENT Leilao_ConfirmacaoNegociacaoDTO
	Local cSoap := ""
	cSoap += WSSoapValue("lstConfirmacaoNegociacaoItemDTO", ::oWSlstConfirmacaoNegociacaoItemDTO, ::oWSlstConfirmacaoNegociacaoItemDTO , "ArrayOfConfirmacaoNegociacaoItemDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("nIdTipoProcesso", ::nnIdTipoProcesso, ::nnIdTipoProcesso , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdProcessoWbc", ::csCdProcessoWbc, ::csCdProcessoWbc , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
Return cSoap

// WSDL Data Structure ArrayOfLeilaoItemDTO

WSSTRUCT Leilao_ArrayOfLeilaoItemDTO
	WSDATA   oWSLeilaoItemDTO          AS Leilao_LeilaoItemDTO OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Leilao_ArrayOfLeilaoItemDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Leilao_ArrayOfLeilaoItemDTO
	::oWSLeilaoItemDTO     := {} // Array Of  Leilao_LEILAOITEMDTO():New()
Return

WSMETHOD CLONE WSCLIENT Leilao_ArrayOfLeilaoItemDTO
	Local oClone := Leilao_ArrayOfLeilaoItemDTO():NEW()
	oClone:oWSLeilaoItemDTO := NIL
	If ::oWSLeilaoItemDTO <> NIL 
		oClone:oWSLeilaoItemDTO := {}
		aEval( ::oWSLeilaoItemDTO , { |x| aadd( oClone:oWSLeilaoItemDTO , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT Leilao_ArrayOfLeilaoItemDTO
	Local cSoap := ""
	aEval( ::oWSLeilaoItemDTO , {|x| cSoap := cSoap  +  WSSoapValue("LeilaoItemDTO", x , x , "LeilaoItemDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.)  } ) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Leilao_ArrayOfLeilaoItemDTO
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_LEILAOITEMDTO","LeilaoItemDTO",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSLeilaoItemDTO , Leilao_LeilaoItemDTO():New() )
			::oWSLeilaoItemDTO[len(::oWSLeilaoItemDTO)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure ArrayOfLeilaoParticipanteDTO

WSSTRUCT Leilao_ArrayOfLeilaoParticipanteDTO
	WSDATA   oWSLeilaoParticipanteDTO  AS Leilao_LeilaoParticipanteDTO OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Leilao_ArrayOfLeilaoParticipanteDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Leilao_ArrayOfLeilaoParticipanteDTO
	::oWSLeilaoParticipanteDTO := {} // Array Of  Leilao_LEILAOPARTICIPANTEDTO():New()
Return

WSMETHOD CLONE WSCLIENT Leilao_ArrayOfLeilaoParticipanteDTO
	Local oClone := Leilao_ArrayOfLeilaoParticipanteDTO():NEW()
	oClone:oWSLeilaoParticipanteDTO := NIL
	If ::oWSLeilaoParticipanteDTO <> NIL 
		oClone:oWSLeilaoParticipanteDTO := {}
		aEval( ::oWSLeilaoParticipanteDTO , { |x| aadd( oClone:oWSLeilaoParticipanteDTO , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT Leilao_ArrayOfLeilaoParticipanteDTO
	Local cSoap := ""
	aEval( ::oWSLeilaoParticipanteDTO , {|x| cSoap := cSoap  +  WSSoapValue("LeilaoParticipanteDTO", x , x , "LeilaoParticipanteDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.)  } ) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Leilao_ArrayOfLeilaoParticipanteDTO
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_LEILAOPARTICIPANTEDTO","LeilaoParticipanteDTO",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSLeilaoParticipanteDTO , Leilao_LeilaoParticipanteDTO():New() )
			::oWSLeilaoParticipanteDTO[len(::oWSLeilaoParticipanteDTO)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure WbtLogDTO

WSSTRUCT Leilao_WbtLogDTO
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

WSMETHOD NEW WSCLIENT Leilao_WbtLogDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Leilao_WbtLogDTO
Return

WSMETHOD CLONE WSCLIENT Leilao_WbtLogDTO
	Local oClone := Leilao_WbtLogDTO():NEW()
	oClone:nnCdLog              := ::nnCdLog
	oClone:nnIdRetorno          := ::nnIdRetorno
	oClone:csCdOrigem           := ::csCdOrigem
	oClone:csDsLog              := ::csDsLog
	oClone:csDsTipoDocumento    := ::csDsTipoDocumento
	oClone:csNrToken            := ::csNrToken
	oClone:ctDtLog              := ::ctDtLog
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Leilao_WbtLogDTO
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

WSSTRUCT Leilao_ArrayOfConfirmacaoNegociacaoItemDTO
	WSDATA   oWSConfirmacaoNegociacaoItemDTO AS Leilao_ConfirmacaoNegociacaoItemDTO OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Leilao_ArrayOfConfirmacaoNegociacaoItemDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Leilao_ArrayOfConfirmacaoNegociacaoItemDTO
	::oWSConfirmacaoNegociacaoItemDTO := {} // Array Of  Leilao_CONFIRMACAONEGOCIACAOITEMDTO():New()
Return

WSMETHOD CLONE WSCLIENT Leilao_ArrayOfConfirmacaoNegociacaoItemDTO
	Local oClone := Leilao_ArrayOfConfirmacaoNegociacaoItemDTO():NEW()
	oClone:oWSConfirmacaoNegociacaoItemDTO := NIL
	If ::oWSConfirmacaoNegociacaoItemDTO <> NIL 
		oClone:oWSConfirmacaoNegociacaoItemDTO := {}
		aEval( ::oWSConfirmacaoNegociacaoItemDTO , { |x| aadd( oClone:oWSConfirmacaoNegociacaoItemDTO , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT Leilao_ArrayOfConfirmacaoNegociacaoItemDTO
	Local cSoap := ""
	aEval( ::oWSConfirmacaoNegociacaoItemDTO , {|x| cSoap := cSoap  +  WSSoapValue("ConfirmacaoNegociacaoItemDTO", x , x , "ConfirmacaoNegociacaoItemDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.)  } ) 
Return cSoap

// WSDL Data Structure LeilaoItemDTO

WSSTRUCT Leilao_LeilaoItemDTO
	WSDATA   ndQtItem                  AS decimal OPTIONAL
	WSDATA   ndVlAlvo                  AS decimal OPTIONAL
	WSDATA   ndVlReferencia            AS decimal OPTIONAL
	WSDATA   ndVlVariacaoMax           AS decimal OPTIONAL
	WSDATA   ndVlVariacaoMin           AS decimal OPTIONAL
	WSDATA   oWSlstLeilaoItemEnderecoDTO AS Leilao_ArrayOfLeilaoItemEnderecoDTO OPTIONAL
	WSDATA   oWSlstLeilaoItemParticipanteDTO AS Leilao_ArrayOfLeilaoItemParticipanteDTO OPTIONAL
	WSDATA   oWSlstLeilaoLanceDTO      AS Leilao_ArrayOfLeilaoLanceDTO OPTIONAL
	WSDATA   nnCdSituacao              AS long OPTIONAL
	WSDATA   nnIdVariacao              AS int OPTIONAL
	WSDATA   csCdClasse                AS string OPTIONAL
	WSDATA   csCdCondicaoPagamento     AS string OPTIONAL
	WSDATA   csCdItemEmpresa           AS string OPTIONAL
	WSDATA   csCdItemWbc               AS string OPTIONAL
	WSDATA   csCdMarca                 AS string OPTIONAL
	WSDATA   csCdMoeda                 AS string OPTIONAL
	WSDATA   csCdProduto               AS string OPTIONAL
	WSDATA   csCdUnidadeMedida         AS string OPTIONAL
	WSDATA   csDsJustificativa         AS string OPTIONAL
	WSDATA   csDsProdutoLeilao         AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Leilao_LeilaoItemDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Leilao_LeilaoItemDTO
Return

WSMETHOD CLONE WSCLIENT Leilao_LeilaoItemDTO
	Local oClone := Leilao_LeilaoItemDTO():NEW()
	oClone:ndQtItem             := ::ndQtItem
	oClone:ndVlAlvo             := ::ndVlAlvo
	oClone:ndVlReferencia       := ::ndVlReferencia
	oClone:ndVlVariacaoMax      := ::ndVlVariacaoMax
	oClone:ndVlVariacaoMin      := ::ndVlVariacaoMin
	oClone:oWSlstLeilaoItemEnderecoDTO := IIF(::oWSlstLeilaoItemEnderecoDTO = NIL , NIL , ::oWSlstLeilaoItemEnderecoDTO:Clone() )
	oClone:oWSlstLeilaoItemParticipanteDTO := IIF(::oWSlstLeilaoItemParticipanteDTO = NIL , NIL , ::oWSlstLeilaoItemParticipanteDTO:Clone() )
	oClone:oWSlstLeilaoLanceDTO := IIF(::oWSlstLeilaoLanceDTO = NIL , NIL , ::oWSlstLeilaoLanceDTO:Clone() )
	oClone:nnCdSituacao         := ::nnCdSituacao
	oClone:nnIdVariacao         := ::nnIdVariacao
	oClone:csCdClasse           := ::csCdClasse
	oClone:csCdCondicaoPagamento := ::csCdCondicaoPagamento
	oClone:csCdItemEmpresa      := ::csCdItemEmpresa
	oClone:csCdItemWbc          := ::csCdItemWbc
	oClone:csCdMarca            := ::csCdMarca
	oClone:csCdMoeda            := ::csCdMoeda
	oClone:csCdProduto          := ::csCdProduto
	oClone:csCdUnidadeMedida    := ::csCdUnidadeMedida
	oClone:csDsJustificativa    := ::csDsJustificativa
	oClone:csDsProdutoLeilao    := ::csDsProdutoLeilao
Return oClone

WSMETHOD SOAPSEND WSCLIENT Leilao_LeilaoItemDTO
	Local cSoap := ""
	cSoap += WSSoapValue("dQtItem", ::ndQtItem, ::ndQtItem , "decimal", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("dVlAlvo", ::ndVlAlvo, ::ndVlAlvo , "decimal", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("dVlReferencia", ::ndVlReferencia, ::ndVlReferencia , "decimal", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("dVlVariacaoMax", ::ndVlVariacaoMax, ::ndVlVariacaoMax , "decimal", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("dVlVariacaoMin", ::ndVlVariacaoMin, ::ndVlVariacaoMin , "decimal", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("lstLeilaoItemEnderecoDTO", ::oWSlstLeilaoItemEnderecoDTO, ::oWSlstLeilaoItemEnderecoDTO , "ArrayOfLeilaoItemEnderecoDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("lstLeilaoItemParticipanteDTO", ::oWSlstLeilaoItemParticipanteDTO, ::oWSlstLeilaoItemParticipanteDTO , "ArrayOfLeilaoItemParticipanteDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("lstLeilaoLanceDTO", ::oWSlstLeilaoLanceDTO, ::oWSlstLeilaoLanceDTO , "ArrayOfLeilaoLanceDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("nCdSituacao", ::nnCdSituacao, ::nnCdSituacao , "long", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("nIdVariacao", ::nnIdVariacao, ::nnIdVariacao , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdClasse", ::csCdClasse, ::csCdClasse , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdCondicaoPagamento", ::csCdCondicaoPagamento, ::csCdCondicaoPagamento , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdItemEmpresa", ::csCdItemEmpresa, ::csCdItemEmpresa , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdItemWbc", ::csCdItemWbc, ::csCdItemWbc , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdMarca", ::csCdMarca, ::csCdMarca , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdMoeda", ::csCdMoeda, ::csCdMoeda , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdProduto", ::csCdProduto, ::csCdProduto , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdUnidadeMedida", ::csCdUnidadeMedida, ::csCdUnidadeMedida , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sDsJustificativa", ::csDsJustificativa, ::csDsJustificativa , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sDsProdutoLeilao", ::csDsProdutoLeilao, ::csDsProdutoLeilao , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Leilao_LeilaoItemDTO
	Local oNode6
	Local oNode7
	Local oNode8
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::ndQtItem           :=  WSAdvValue( oResponse,"_DQTITEM","decimal",NIL,NIL,NIL,"N",NIL,NIL) 
	::ndVlAlvo           :=  WSAdvValue( oResponse,"_DVLALVO","decimal",NIL,NIL,NIL,"N",NIL,NIL) 
	::ndVlReferencia     :=  WSAdvValue( oResponse,"_DVLREFERENCIA","decimal",NIL,NIL,NIL,"N",NIL,NIL) 
	::ndVlVariacaoMax    :=  WSAdvValue( oResponse,"_DVLVARIACAOMAX","decimal",NIL,NIL,NIL,"N",NIL,NIL) 
	::ndVlVariacaoMin    :=  WSAdvValue( oResponse,"_DVLVARIACAOMIN","decimal",NIL,NIL,NIL,"N",NIL,NIL) 
	oNode6 :=  WSAdvValue( oResponse,"_LSTLEILAOITEMENDERECODTO","ArrayOfLeilaoItemEnderecoDTO",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode6 != NIL
		::oWSlstLeilaoItemEnderecoDTO := Leilao_ArrayOfLeilaoItemEnderecoDTO():New()
		::oWSlstLeilaoItemEnderecoDTO:SoapRecv(oNode6)
	EndIf
	oNode7 :=  WSAdvValue( oResponse,"_LSTLEILAOITEMPARTICIPANTEDTO","ArrayOfLeilaoItemParticipanteDTO",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode7 != NIL
		::oWSlstLeilaoItemParticipanteDTO := Leilao_ArrayOfLeilaoItemParticipanteDTO():New()
		::oWSlstLeilaoItemParticipanteDTO:SoapRecv(oNode7)
	EndIf
	oNode8 :=  WSAdvValue( oResponse,"_LSTLEILAOLANCEDTO","ArrayOfLeilaoLanceDTO",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode8 != NIL
		::oWSlstLeilaoLanceDTO := Leilao_ArrayOfLeilaoLanceDTO():New()
		::oWSlstLeilaoLanceDTO:SoapRecv(oNode8)
	EndIf
	::nnCdSituacao       :=  WSAdvValue( oResponse,"_NCDSITUACAO","long",NIL,NIL,NIL,"N",NIL,NIL) 
	::nnIdVariacao       :=  WSAdvValue( oResponse,"_NIDVARIACAO","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::csCdClasse         :=  WSAdvValue( oResponse,"_SCDCLASSE","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdCondicaoPagamento :=  WSAdvValue( oResponse,"_SCDCONDICAOPAGAMENTO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdItemEmpresa    :=  WSAdvValue( oResponse,"_SCDITEMEMPRESA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdItemWbc        :=  WSAdvValue( oResponse,"_SCDITEMWBC","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdMarca          :=  WSAdvValue( oResponse,"_SCDMARCA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdMoeda          :=  WSAdvValue( oResponse,"_SCDMOEDA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdProduto        :=  WSAdvValue( oResponse,"_SCDPRODUTO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdUnidadeMedida  :=  WSAdvValue( oResponse,"_SCDUNIDADEMEDIDA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csDsJustificativa  :=  WSAdvValue( oResponse,"_SDSJUSTIFICATIVA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csDsProdutoLeilao  :=  WSAdvValue( oResponse,"_SDSPRODUTOLEILAO","string",NIL,NIL,NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure LeilaoParticipanteDTO

WSSTRUCT Leilao_LeilaoParticipanteDTO
	WSDATA   nnStParticipacao          AS int OPTIONAL
	WSDATA   csCdEmpresa               AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Leilao_LeilaoParticipanteDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Leilao_LeilaoParticipanteDTO
Return

WSMETHOD CLONE WSCLIENT Leilao_LeilaoParticipanteDTO
	Local oClone := Leilao_LeilaoParticipanteDTO():NEW()
	oClone:nnStParticipacao     := ::nnStParticipacao
	oClone:csCdEmpresa          := ::csCdEmpresa
Return oClone

WSMETHOD SOAPSEND WSCLIENT Leilao_LeilaoParticipanteDTO
	Local cSoap := ""
	cSoap += WSSoapValue("nStParticipacao", ::nnStParticipacao, ::nnStParticipacao , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdEmpresa", ::csCdEmpresa, ::csCdEmpresa , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Leilao_LeilaoParticipanteDTO
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::nnStParticipacao   :=  WSAdvValue( oResponse,"_NSTPARTICIPACAO","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::csCdEmpresa        :=  WSAdvValue( oResponse,"_SCDEMPRESA","string",NIL,NIL,NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure ConfirmacaoNegociacaoItemDTO

WSSTRUCT Leilao_ConfirmacaoNegociacaoItemDTO
	WSDATA   csCdProcessoItemWbc       AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Leilao_ConfirmacaoNegociacaoItemDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Leilao_ConfirmacaoNegociacaoItemDTO
Return

WSMETHOD CLONE WSCLIENT Leilao_ConfirmacaoNegociacaoItemDTO
	Local oClone := Leilao_ConfirmacaoNegociacaoItemDTO():NEW()
	oClone:csCdProcessoItemWbc  := ::csCdProcessoItemWbc
Return oClone

WSMETHOD SOAPSEND WSCLIENT Leilao_ConfirmacaoNegociacaoItemDTO
	Local cSoap := ""
	cSoap += WSSoapValue("sCdProcessoItemWbc", ::csCdProcessoItemWbc, ::csCdProcessoItemWbc , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
Return cSoap

// WSDL Data Structure ArrayOfLeilaoItemEnderecoDTO

WSSTRUCT Leilao_ArrayOfLeilaoItemEnderecoDTO
	WSDATA   oWSLeilaoItemEnderecoDTO  AS Leilao_LeilaoItemEnderecoDTO OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Leilao_ArrayOfLeilaoItemEnderecoDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Leilao_ArrayOfLeilaoItemEnderecoDTO
	::oWSLeilaoItemEnderecoDTO := {} // Array Of  Leilao_LEILAOITEMENDERECODTO():New()
Return

WSMETHOD CLONE WSCLIENT Leilao_ArrayOfLeilaoItemEnderecoDTO
	Local oClone := Leilao_ArrayOfLeilaoItemEnderecoDTO():NEW()
	oClone:oWSLeilaoItemEnderecoDTO := NIL
	If ::oWSLeilaoItemEnderecoDTO <> NIL 
		oClone:oWSLeilaoItemEnderecoDTO := {}
		aEval( ::oWSLeilaoItemEnderecoDTO , { |x| aadd( oClone:oWSLeilaoItemEnderecoDTO , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT Leilao_ArrayOfLeilaoItemEnderecoDTO
	Local cSoap := ""
	aEval( ::oWSLeilaoItemEnderecoDTO , {|x| cSoap := cSoap  +  WSSoapValue("LeilaoItemEnderecoDTO", x , x , "LeilaoItemEnderecoDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.)  } ) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Leilao_ArrayOfLeilaoItemEnderecoDTO
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_LEILAOITEMENDERECODTO","LeilaoItemEnderecoDTO",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSLeilaoItemEnderecoDTO , Leilao_LeilaoItemEnderecoDTO():New() )
			::oWSLeilaoItemEnderecoDTO[len(::oWSLeilaoItemEnderecoDTO)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure ArrayOfLeilaoItemParticipanteDTO

WSSTRUCT Leilao_ArrayOfLeilaoItemParticipanteDTO
	WSDATA   oWSLeilaoItemParticipanteDTO AS Leilao_LeilaoItemParticipanteDTO OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Leilao_ArrayOfLeilaoItemParticipanteDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Leilao_ArrayOfLeilaoItemParticipanteDTO
	::oWSLeilaoItemParticipanteDTO := {} // Array Of  Leilao_LEILAOITEMPARTICIPANTEDTO():New()
Return

WSMETHOD CLONE WSCLIENT Leilao_ArrayOfLeilaoItemParticipanteDTO
	Local oClone := Leilao_ArrayOfLeilaoItemParticipanteDTO():NEW()
	oClone:oWSLeilaoItemParticipanteDTO := NIL
	If ::oWSLeilaoItemParticipanteDTO <> NIL 
		oClone:oWSLeilaoItemParticipanteDTO := {}
		aEval( ::oWSLeilaoItemParticipanteDTO , { |x| aadd( oClone:oWSLeilaoItemParticipanteDTO , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT Leilao_ArrayOfLeilaoItemParticipanteDTO
	Local cSoap := ""
	aEval( ::oWSLeilaoItemParticipanteDTO , {|x| cSoap := cSoap  +  WSSoapValue("LeilaoItemParticipanteDTO", x , x , "LeilaoItemParticipanteDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.)  } ) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Leilao_ArrayOfLeilaoItemParticipanteDTO
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_LEILAOITEMPARTICIPANTEDTO","LeilaoItemParticipanteDTO",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSLeilaoItemParticipanteDTO , Leilao_LeilaoItemParticipanteDTO():New() )
			::oWSLeilaoItemParticipanteDTO[len(::oWSLeilaoItemParticipanteDTO)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure ArrayOfLeilaoLanceDTO

WSSTRUCT Leilao_ArrayOfLeilaoLanceDTO
	WSDATA   oWSLeilaoLanceDTO         AS Leilao_LeilaoLanceDTO OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Leilao_ArrayOfLeilaoLanceDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Leilao_ArrayOfLeilaoLanceDTO
	::oWSLeilaoLanceDTO    := {} // Array Of  Leilao_LEILAOLANCEDTO():New()
Return

WSMETHOD CLONE WSCLIENT Leilao_ArrayOfLeilaoLanceDTO
	Local oClone := Leilao_ArrayOfLeilaoLanceDTO():NEW()
	oClone:oWSLeilaoLanceDTO := NIL
	If ::oWSLeilaoLanceDTO <> NIL 
		oClone:oWSLeilaoLanceDTO := {}
		aEval( ::oWSLeilaoLanceDTO , { |x| aadd( oClone:oWSLeilaoLanceDTO , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT Leilao_ArrayOfLeilaoLanceDTO
	Local cSoap := ""
	aEval( ::oWSLeilaoLanceDTO , {|x| cSoap := cSoap  +  WSSoapValue("LeilaoLanceDTO", x , x , "LeilaoLanceDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.)  } ) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Leilao_ArrayOfLeilaoLanceDTO
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_LEILAOLANCEDTO","LeilaoLanceDTO",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSLeilaoLanceDTO , Leilao_LeilaoLanceDTO():New() )
			::oWSLeilaoLanceDTO[len(::oWSLeilaoLanceDTO)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure LeilaoItemEnderecoDTO

WSSTRUCT Leilao_LeilaoItemEnderecoDTO
	WSDATA   ndQtEntrega               AS decimal OPTIONAL
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

WSMETHOD NEW WSCLIENT Leilao_LeilaoItemEnderecoDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Leilao_LeilaoItemEnderecoDTO
Return

WSMETHOD CLONE WSCLIENT Leilao_LeilaoItemEnderecoDTO
	Local oClone := Leilao_LeilaoItemEnderecoDTO():NEW()
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

WSMETHOD SOAPSEND WSCLIENT Leilao_LeilaoItemEnderecoDTO
	Local cSoap := ""
	cSoap += WSSoapValue("dQtEntrega", ::ndQtEntrega, ::ndQtEntrega , "decimal", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
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

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Leilao_LeilaoItemEnderecoDTO
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::ndQtEntrega        :=  WSAdvValue( oResponse,"_DQTENTREGA","decimal",NIL,NIL,NIL,"N",NIL,NIL) 
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

// WSDL Data Structure LeilaoItemParticipanteDTO

WSSTRUCT Leilao_LeilaoItemParticipanteDTO
	WSDATA   nbFlHomologado            AS int OPTIONAL
	WSDATA   csCdEmpresa               AS string OPTIONAL
	WSDATA   nsCdItem                  AS long OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Leilao_LeilaoItemParticipanteDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Leilao_LeilaoItemParticipanteDTO
Return

WSMETHOD CLONE WSCLIENT Leilao_LeilaoItemParticipanteDTO
	Local oClone := Leilao_LeilaoItemParticipanteDTO():NEW()
	oClone:nbFlHomologado       := ::nbFlHomologado
	oClone:csCdEmpresa          := ::csCdEmpresa
	oClone:nsCdItem             := ::nsCdItem
Return oClone

WSMETHOD SOAPSEND WSCLIENT Leilao_LeilaoItemParticipanteDTO
	Local cSoap := ""
	cSoap += WSSoapValue("bFlHomologado", ::nbFlHomologado, ::nbFlHomologado , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdEmpresa", ::csCdEmpresa, ::csCdEmpresa , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdItem", ::nsCdItem, ::nsCdItem , "long", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Leilao_LeilaoItemParticipanteDTO
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::nbFlHomologado     :=  WSAdvValue( oResponse,"_BFLHOMOLOGADO","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::csCdEmpresa        :=  WSAdvValue( oResponse,"_SCDEMPRESA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::nsCdItem           :=  WSAdvValue( oResponse,"_SCDITEM","long",NIL,NIL,NIL,"N",NIL,NIL) 
Return

// WSDL Data Structure LeilaoLanceDTO

WSSTRUCT Leilao_LeilaoLanceDTO
	WSDATA   nbFlDesclassificado       AS int OPTIONAL
	WSDATA   ndVlLance                 AS decimal OPTIONAL
	WSDATA   nnCdSituacao              AS long OPTIONAL
	WSDATA   nnIdVencedor              AS int OPTIONAL
	WSDATA   nnNrRanking               AS long OPTIONAL
	WSDATA   csCdEmpresa               AS string OPTIONAL
	WSDATA   csCdUsuario               AS string OPTIONAL
	WSDATA   csDsMotivoDesclassificado AS string OPTIONAL
	WSDATA   ctDtLance                 AS dateTime OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Leilao_LeilaoLanceDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Leilao_LeilaoLanceDTO
Return

WSMETHOD CLONE WSCLIENT Leilao_LeilaoLanceDTO
	Local oClone := Leilao_LeilaoLanceDTO():NEW()
	oClone:nbFlDesclassificado  := ::nbFlDesclassificado
	oClone:ndVlLance            := ::ndVlLance
	oClone:nnCdSituacao         := ::nnCdSituacao
	oClone:nnIdVencedor         := ::nnIdVencedor
	oClone:nnNrRanking          := ::nnNrRanking
	oClone:csCdEmpresa          := ::csCdEmpresa
	oClone:csCdUsuario          := ::csCdUsuario
	oClone:csDsMotivoDesclassificado := ::csDsMotivoDesclassificado
	oClone:ctDtLance            := ::ctDtLance
Return oClone

WSMETHOD SOAPSEND WSCLIENT Leilao_LeilaoLanceDTO
	Local cSoap := ""
	cSoap += WSSoapValue("bFlDesclassificado", ::nbFlDesclassificado, ::nbFlDesclassificado , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("dVlLance", ::ndVlLance, ::ndVlLance , "decimal", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("nCdSituacao", ::nnCdSituacao, ::nnCdSituacao , "long", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("nIdVencedor", ::nnIdVencedor, ::nnIdVencedor , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("nNrRanking", ::nnNrRanking, ::nnNrRanking , "long", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdEmpresa", ::csCdEmpresa, ::csCdEmpresa , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdUsuario", ::csCdUsuario, ::csCdUsuario , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sDsMotivoDesclassificado", ::csDsMotivoDesclassificado, ::csDsMotivoDesclassificado , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("tDtLance", ::ctDtLance, ::ctDtLance , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Leilao_LeilaoLanceDTO
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::nbFlDesclassificado :=  WSAdvValue( oResponse,"_BFLDESCLASSIFICADO","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::ndVlLance          :=  WSAdvValue( oResponse,"_DVLLANCE","decimal",NIL,NIL,NIL,"N",NIL,NIL) 
	::nnCdSituacao       :=  WSAdvValue( oResponse,"_NCDSITUACAO","long",NIL,NIL,NIL,"N",NIL,NIL) 
	::nnIdVencedor       :=  WSAdvValue( oResponse,"_NIDVENCEDOR","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::nnNrRanking        :=  WSAdvValue( oResponse,"_NNRRANKING","long",NIL,NIL,NIL,"N",NIL,NIL) 
	::csCdEmpresa        :=  WSAdvValue( oResponse,"_SCDEMPRESA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdUsuario        :=  WSAdvValue( oResponse,"_SCDUSUARIO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csDsMotivoDesclassificado :=  WSAdvValue( oResponse,"_SDSMOTIVODESCLASSIFICADO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::ctDtLance          :=  WSAdvValue( oResponse,"_TDTLANCE","dateTime",NIL,NIL,NIL,"S",NIL,NIL) 
Return


