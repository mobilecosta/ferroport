#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"

/*=================================================================================================================*\
|| ############################################################################################################### ||
||																	                                               ||
|| # WSDL Service WSCondicaoPagamento																			 # ||
|| # WSDL Location: https://srm-hml.paradigmabs.com.br/cassi-hml/services/CondicaoPagamento.svc?wsdl			 # ||
||																	                                               ||
|| # Data - 26/09/2019 																							 # ||
||																	                                               ||
|| # Desc: WebService de cadastro de Condição de Pagamento.														 # ||
||																	                                               ||
|| # Obs: Alterações neste arquivo podem causar funcionamento incorreto.										 # ||
||																	                                               ||
|| ############################################################################################################### ||
\*=================================================================================================================*/
User Function _JPHPSFB ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSCondicaoPagamento
------------------------------------------------------------------------------- */

WSCLIENT WSCondicaoPagamento

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD ProcessarCondicaoPagamento
	WSMETHOD RetornarCondicaoPagamento
	WSMETHOD RetornarCondicaoPagamentoAtiva

	WSDATA   _URL                      AS String
	WSDATA   _CERT                     AS String
	WSDATA   _PRIVKEY                  AS String
	WSDATA   _PASSPHRASE               AS String
	WSDATA   _HEADOUT                  AS Array of String
	WSDATA   _COOKIES                  AS Array of String
	WSDATA   oWSlstCondicaoPagamento   AS CondicaoPagamento_ArrayOfCondicaoPagamentoDTO
	WSDATA   oWSProcessarCondicaoPagamentoResult AS CondicaoPagamento_RetornoDTO
	WSDATA   csCdCondicaoPagamentoErp  AS string
	WSDATA   oWSRetornarCondicaoPagamentoResult AS CondicaoPagamento_CondicaoPagamentoDTO
	WSDATA   oWSRetornarCondicaoPagamentoAtivaResult AS CondicaoPagamento_RetornoListaCondicaoPagamentoDTO

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSCondicaoPagamento
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.131227A-20190114 NG] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSCondicaoPagamento
	::oWSlstCondicaoPagamento := CondicaoPagamento_ARRAYOFCONDICAOPAGAMENTODTO():New()
	::oWSProcessarCondicaoPagamentoResult := CondicaoPagamento_RETORNODTO():New()
	::oWSRetornarCondicaoPagamentoResult := CondicaoPagamento_CONDICAOPAGAMENTODTO():New()
	::oWSRetornarCondicaoPagamentoAtivaResult := CondicaoPagamento_RETORNOLISTACONDICAOPAGAMENTODTO():New()
Return

WSMETHOD RESET WSCLIENT WSCondicaoPagamento
	::oWSlstCondicaoPagamento := NIL 
	::oWSProcessarCondicaoPagamentoResult := NIL 
	::csCdCondicaoPagamentoErp := NIL 
	::oWSRetornarCondicaoPagamentoResult := NIL 
	::oWSRetornarCondicaoPagamentoAtivaResult := NIL 
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSCondicaoPagamento
Local oClone := WSCondicaoPagamento():New()
	oClone:_URL          := ::_URL 
	oClone:_CERT         := ::_CERT 
	oClone:_PRIVKEY      := ::_PRIVKEY 
	oClone:_PASSPHRASE   := ::_PASSPHRASE 
	oClone:oWSlstCondicaoPagamento :=  IIF(::oWSlstCondicaoPagamento = NIL , NIL ,::oWSlstCondicaoPagamento:Clone() )
	oClone:oWSProcessarCondicaoPagamentoResult :=  IIF(::oWSProcessarCondicaoPagamentoResult = NIL , NIL ,::oWSProcessarCondicaoPagamentoResult:Clone() )
	oClone:csCdCondicaoPagamentoErp := ::csCdCondicaoPagamentoErp
	oClone:oWSRetornarCondicaoPagamentoResult :=  IIF(::oWSRetornarCondicaoPagamentoResult = NIL , NIL ,::oWSRetornarCondicaoPagamentoResult:Clone() )
	oClone:oWSRetornarCondicaoPagamentoAtivaResult :=  IIF(::oWSRetornarCondicaoPagamentoAtivaResult = NIL , NIL ,::oWSRetornarCondicaoPagamentoAtivaResult:Clone() )
Return oClone

// WSDL Method ProcessarCondicaoPagamento of Service WSCondicaoPagamento

WSMETHOD ProcessarCondicaoPagamento WSSEND oWSlstCondicaoPagamento WSRECEIVE oWSProcessarCondicaoPagamentoResult WSCLIENT WSCondicaoPagamento
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ProcessarCondicaoPagamento xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("lstCondicaoPagamento", ::oWSlstCondicaoPagamento, oWSlstCondicaoPagamento , "ArrayOfCondicaoPagamentoDTO", .F. , .F., 0 , "http://tempuri.org/", .F.,.F.) 
cSoap += "</ProcessarCondicaoPagamento>"

Self:_HEADOUT := { "Authorization: Bearer " + U_NewToken() }
oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tempuri.org/ICondicaoPagamento/ProcessarCondicaoPagamento",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	Lower(AllTrim(GetMv("MV_XPARURL"))) + "/services/CondicaoPagamento.svc")

::Init()
::oWSProcessarCondicaoPagamentoResult:SoapRecv( WSAdvValue( oXmlRet,"_PROCESSARCONDICAOPAGAMENTORESPONSE:_PROCESSARCONDICAOPAGAMENTORESULT","RetornoDTO",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return {.T.,cSoap}

// WSDL Method RetornarCondicaoPagamento of Service WSCondicaoPagamento

WSMETHOD RetornarCondicaoPagamento WSSEND csCdCondicaoPagamentoErp WSRECEIVE oWSRetornarCondicaoPagamentoResult WSCLIENT WSCondicaoPagamento
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<RetornarCondicaoPagamento xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("sCdCondicaoPagamentoErp", ::csCdCondicaoPagamentoErp, csCdCondicaoPagamentoErp , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</RetornarCondicaoPagamento>"

Self:_HEADOUT := { "Authorization: Bearer " + U_NewToken() }
oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tempuri.org/ICondicaoPagamento/RetornarCondicaoPagamento",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	Lower(AllTrim(GetMv("MV_XPARURL"))) + "/services/CondicaoPagamento.svc")

::Init()
::oWSRetornarCondicaoPagamentoResult:SoapRecv( WSAdvValue( oXmlRet,"_RETORNARCONDICAOPAGAMENTORESPONSE:_RETORNARCONDICAOPAGAMENTORESULT","CondicaoPagamentoDTO",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method RetornarCondicaoPagamentoAtiva of Service WSCondicaoPagamento

WSMETHOD RetornarCondicaoPagamentoAtiva WSSEND NULLPARAM WSRECEIVE oWSRetornarCondicaoPagamentoAtivaResult WSCLIENT WSCondicaoPagamento
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<RetornarCondicaoPagamentoAtiva xmlns="http://tempuri.org/">'
cSoap += "</RetornarCondicaoPagamentoAtiva>"

Self:_HEADOUT := { "Authorization: Bearer " + U_NewToken() }
oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tempuri.org/ICondicaoPagamento/RetornarCondicaoPagamentoAtiva",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	Lower(AllTrim(GetMv("MV_XPARURL"))) + "/services/CondicaoPagamento.svc")

::Init()
::oWSRetornarCondicaoPagamentoAtivaResult:SoapRecv( WSAdvValue( oXmlRet,"_RETORNARCONDICAOPAGAMENTOATIVARESPONSE:_RETORNARCONDICAOPAGAMENTOATIVARESULT","RetornoListaCondicaoPagamentoDTO",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.


// WSDL Data Structure RetornoDTO

WSSTRUCT CondicaoPagamento_RetornoDTO
	WSDATA   oWSlstWbtLogDTO           AS CondicaoPagamento_ArrayOfWbtLogDTO OPTIONAL
	WSDATA   nnIdRetorno               AS long OPTIONAL
	WSDATA   csNrToken                 AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT CondicaoPagamento_RetornoDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT CondicaoPagamento_RetornoDTO
Return

WSMETHOD CLONE WSCLIENT CondicaoPagamento_RetornoDTO
	Local oClone := CondicaoPagamento_RetornoDTO():NEW()
	oClone:oWSlstWbtLogDTO      := IIF(::oWSlstWbtLogDTO = NIL , NIL , ::oWSlstWbtLogDTO:Clone() )
	oClone:nnIdRetorno          := ::nnIdRetorno
	oClone:csNrToken            := ::csNrToken
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT CondicaoPagamento_RetornoDTO
	Local oNode1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_LSTWBTLOGDTO","ArrayOfWbtLogDTO",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode1 != NIL
		::oWSlstWbtLogDTO := CondicaoPagamento_ArrayOfWbtLogDTO():New()
		::oWSlstWbtLogDTO:SoapRecv(oNode1)
	EndIf
	::nnIdRetorno        :=  WSAdvValue( oResponse,"_NIDRETORNO","long",NIL,NIL,NIL,"N",NIL,NIL) 
	::csNrToken          :=  WSAdvValue( oResponse,"_SNRTOKEN","string",NIL,NIL,NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure RetornoListaCondicaoPagamentoDTO

WSSTRUCT CondicaoPagamento_RetornoListaCondicaoPagamentoDTO
	WSDATA   oWSlstObjetoRetorno       AS CondicaoPagamento_ArrayOfCondicaoPagamentoDTO OPTIONAL
	WSDATA   nnQtRegistrosRetorno      AS int OPTIONAL
	WSDATA   nnQtRegistrosTotal        AS int OPTIONAL
	WSDATA   oWSoRetornoDTO            AS CondicaoPagamento_RetornoDTO OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT CondicaoPagamento_RetornoListaCondicaoPagamentoDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT CondicaoPagamento_RetornoListaCondicaoPagamentoDTO
Return

WSMETHOD CLONE WSCLIENT CondicaoPagamento_RetornoListaCondicaoPagamentoDTO
	Local oClone := CondicaoPagamento_RetornoListaCondicaoPagamentoDTO():NEW()
	oClone:oWSlstObjetoRetorno  := IIF(::oWSlstObjetoRetorno = NIL , NIL , ::oWSlstObjetoRetorno:Clone() )
	oClone:nnQtRegistrosRetorno := ::nnQtRegistrosRetorno
	oClone:nnQtRegistrosTotal   := ::nnQtRegistrosTotal
	oClone:oWSoRetornoDTO       := IIF(::oWSoRetornoDTO = NIL , NIL , ::oWSoRetornoDTO:Clone() )
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT CondicaoPagamento_RetornoListaCondicaoPagamentoDTO
	Local oNode1
	Local oNode4
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_LSTOBJETORETORNO","ArrayOfCondicaoPagamentoDTO",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode1 != NIL
		::oWSlstObjetoRetorno := CondicaoPagamento_ArrayOfCondicaoPagamentoDTO():New()
		::oWSlstObjetoRetorno:SoapRecv(oNode1)
	EndIf
	::nnQtRegistrosRetorno :=  WSAdvValue( oResponse,"_NQTREGISTROSRETORNO","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::nnQtRegistrosTotal :=  WSAdvValue( oResponse,"_NQTREGISTROSTOTAL","int",NIL,NIL,NIL,"N",NIL,NIL) 
	oNode4 :=  WSAdvValue( oResponse,"_ORETORNODTO","RetornoDTO",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode4 != NIL
		::oWSoRetornoDTO := CondicaoPagamento_RetornoDTO():New()
		::oWSoRetornoDTO:SoapRecv(oNode4)
	EndIf
Return

// WSDL Data Structure ArrayOfWbtLogDTO

WSSTRUCT CondicaoPagamento_ArrayOfWbtLogDTO
	WSDATA   oWSWbtLogDTO              AS CondicaoPagamento_WbtLogDTO OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT CondicaoPagamento_ArrayOfWbtLogDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT CondicaoPagamento_ArrayOfWbtLogDTO
	::oWSWbtLogDTO         := {} // Array Of  CondicaoPagamento_WBTLOGDTO():New()
Return

WSMETHOD CLONE WSCLIENT CondicaoPagamento_ArrayOfWbtLogDTO
	Local oClone := CondicaoPagamento_ArrayOfWbtLogDTO():NEW()
	oClone:oWSWbtLogDTO := NIL
	If ::oWSWbtLogDTO <> NIL 
		oClone:oWSWbtLogDTO := {}
		aEval( ::oWSWbtLogDTO , { |x| aadd( oClone:oWSWbtLogDTO , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT CondicaoPagamento_ArrayOfWbtLogDTO
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_WBTLOGDTO","WbtLogDTO",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSWbtLogDTO , CondicaoPagamento_WbtLogDTO():New() )
			::oWSWbtLogDTO[len(::oWSWbtLogDTO)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure ArrayOfCondicaoPagamentoDTO

WSSTRUCT CondicaoPagamento_ArrayOfCondicaoPagamentoDTO
	WSDATA   oWSCondicaoPagamentoDTO   AS CondicaoPagamento_CondicaoPagamentoDTO OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT CondicaoPagamento_ArrayOfCondicaoPagamentoDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT CondicaoPagamento_ArrayOfCondicaoPagamentoDTO
	::oWSCondicaoPagamentoDTO := {} // Array Of  CondicaoPagamento_CONDICAOPAGAMENTODTO():New()
Return

WSMETHOD CLONE WSCLIENT CondicaoPagamento_ArrayOfCondicaoPagamentoDTO
	Local oClone := CondicaoPagamento_ArrayOfCondicaoPagamentoDTO():NEW()
	oClone:oWSCondicaoPagamentoDTO := NIL
	If ::oWSCondicaoPagamentoDTO <> NIL 
		oClone:oWSCondicaoPagamentoDTO := {}
		aEval( ::oWSCondicaoPagamentoDTO , { |x| aadd( oClone:oWSCondicaoPagamentoDTO , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT CondicaoPagamento_ArrayOfCondicaoPagamentoDTO
	Local cSoap := ""
	aEval( ::oWSCondicaoPagamentoDTO , {|x| cSoap := cSoap  +  WSSoapValue("CondicaoPagamentoDTO", x , x , "CondicaoPagamentoDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.)  } ) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT CondicaoPagamento_ArrayOfCondicaoPagamentoDTO
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_CONDICAOPAGAMENTODTO","CondicaoPagamentoDTO",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSCondicaoPagamentoDTO , CondicaoPagamento_CondicaoPagamentoDTO():New() )
			::oWSCondicaoPagamentoDTO[len(::oWSCondicaoPagamentoDTO)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure WbtLogDTO

WSSTRUCT CondicaoPagamento_WbtLogDTO
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

WSMETHOD NEW WSCLIENT CondicaoPagamento_WbtLogDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT CondicaoPagamento_WbtLogDTO
Return

WSMETHOD CLONE WSCLIENT CondicaoPagamento_WbtLogDTO
	Local oClone := CondicaoPagamento_WbtLogDTO():NEW()
	oClone:nnCdLog              := ::nnCdLog
	oClone:nnIdRetorno          := ::nnIdRetorno
	oClone:csCdOrigem           := ::csCdOrigem
	oClone:csDsLog              := ::csDsLog
	oClone:csDsTipoDocumento    := ::csDsTipoDocumento
	oClone:csNrToken            := ::csNrToken
	oClone:ctDtLog              := ::ctDtLog
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT CondicaoPagamento_WbtLogDTO
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

// WSDL Data Structure CondicaoPagamentoDTO

WSSTRUCT CondicaoPagamento_CondicaoPagamentoDTO
	WSDATA   oWSlstCondicaoPagamentoIdioma AS CondicaoPagamento_ArrayOfCondicaoPagamentoIdimaDTO OPTIONAL
	WSDATA   oWSlstCondicaoPagamentoItem AS CondicaoPagamento_ArrayOfCondicaoItemDTO OPTIONAL
	WSDATA   csCdCondicaoPagamento     AS string OPTIONAL
	WSDATA   csCdEmpresa               AS string OPTIONAL
	WSDATA   csDsCondicaoPagamento     AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT CondicaoPagamento_CondicaoPagamentoDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT CondicaoPagamento_CondicaoPagamentoDTO
Return

WSMETHOD CLONE WSCLIENT CondicaoPagamento_CondicaoPagamentoDTO
	Local oClone := CondicaoPagamento_CondicaoPagamentoDTO():NEW()
	oClone:oWSlstCondicaoPagamentoIdioma := IIF(::oWSlstCondicaoPagamentoIdioma = NIL , NIL , ::oWSlstCondicaoPagamentoIdioma:Clone() )
	oClone:oWSlstCondicaoPagamentoItem := IIF(::oWSlstCondicaoPagamentoItem = NIL , NIL , ::oWSlstCondicaoPagamentoItem:Clone() )
	oClone:csCdCondicaoPagamento := ::csCdCondicaoPagamento
	oClone:csCdEmpresa          := ::csCdEmpresa
	oClone:csDsCondicaoPagamento := ::csDsCondicaoPagamento
Return oClone

WSMETHOD SOAPSEND WSCLIENT CondicaoPagamento_CondicaoPagamentoDTO
	Local cSoap := ""
	cSoap += WSSoapValue("lstCondicaoPagamentoIdioma", ::oWSlstCondicaoPagamentoIdioma, ::oWSlstCondicaoPagamentoIdioma , "ArrayOfCondicaoPagamentoIdimaDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("lstCondicaoPagamentoItem", ::oWSlstCondicaoPagamentoItem, ::oWSlstCondicaoPagamentoItem , "ArrayOfCondicaoItemDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdCondicaoPagamento", ::csCdCondicaoPagamento, ::csCdCondicaoPagamento , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdEmpresa", ::csCdEmpresa, ::csCdEmpresa , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sDsCondicaoPagamento", ::csDsCondicaoPagamento, ::csDsCondicaoPagamento , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT CondicaoPagamento_CondicaoPagamentoDTO
	Local oNode1
	Local oNode2
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_LSTCONDICAOPAGAMENTOIDIOMA","ArrayOfCondicaoPagamentoIdimaDTO",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode1 != NIL
		::oWSlstCondicaoPagamentoIdioma := CondicaoPagamento_ArrayOfCondicaoPagamentoIdimaDTO():New()
		::oWSlstCondicaoPagamentoIdioma:SoapRecv(oNode1)
	EndIf
	oNode2 :=  WSAdvValue( oResponse,"_LSTCONDICAOPAGAMENTOITEM","ArrayOfCondicaoItemDTO",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode2 != NIL
		::oWSlstCondicaoPagamentoItem := CondicaoPagamento_ArrayOfCondicaoItemDTO():New()
		::oWSlstCondicaoPagamentoItem:SoapRecv(oNode2)
	EndIf
	::csCdCondicaoPagamento :=  WSAdvValue( oResponse,"_SCDCONDICAOPAGAMENTO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdEmpresa        :=  WSAdvValue( oResponse,"_SCDEMPRESA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csDsCondicaoPagamento :=  WSAdvValue( oResponse,"_SDSCONDICAOPAGAMENTO","string",NIL,NIL,NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure ArrayOfCondicaoPagamentoIdimaDTO

WSSTRUCT CondicaoPagamento_ArrayOfCondicaoPagamentoIdimaDTO
	WSDATA   oWSCondicaoPagamentoIdimaDTO AS CondicaoPagamento_CondicaoPagamentoIdimaDTO OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT CondicaoPagamento_ArrayOfCondicaoPagamentoIdimaDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT CondicaoPagamento_ArrayOfCondicaoPagamentoIdimaDTO
	::oWSCondicaoPagamentoIdimaDTO := {} // Array Of  CondicaoPagamento_CONDICAOPAGAMENTOIDIMADTO():New()
Return

WSMETHOD CLONE WSCLIENT CondicaoPagamento_ArrayOfCondicaoPagamentoIdimaDTO
	Local oClone := CondicaoPagamento_ArrayOfCondicaoPagamentoIdimaDTO():NEW()
	oClone:oWSCondicaoPagamentoIdimaDTO := NIL
	If ::oWSCondicaoPagamentoIdimaDTO <> NIL 
		oClone:oWSCondicaoPagamentoIdimaDTO := {}
		aEval( ::oWSCondicaoPagamentoIdimaDTO , { |x| aadd( oClone:oWSCondicaoPagamentoIdimaDTO , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT CondicaoPagamento_ArrayOfCondicaoPagamentoIdimaDTO
	Local cSoap := ""
	aEval( ::oWSCondicaoPagamentoIdimaDTO , {|x| cSoap := cSoap  +  WSSoapValue("CondicaoPagamentoIdimaDTO", x , x , "CondicaoPagamentoIdimaDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.)  } ) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT CondicaoPagamento_ArrayOfCondicaoPagamentoIdimaDTO
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_CONDICAOPAGAMENTOIDIMADTO","CondicaoPagamentoIdimaDTO",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSCondicaoPagamentoIdimaDTO , CondicaoPagamento_CondicaoPagamentoIdimaDTO():New() )
			::oWSCondicaoPagamentoIdimaDTO[len(::oWSCondicaoPagamentoIdimaDTO)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure ArrayOfCondicaoItemDTO

WSSTRUCT CondicaoPagamento_ArrayOfCondicaoItemDTO
	WSDATA   oWSCondicaoItemDTO        AS CondicaoPagamento_CondicaoItemDTO OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT CondicaoPagamento_ArrayOfCondicaoItemDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT CondicaoPagamento_ArrayOfCondicaoItemDTO
	::oWSCondicaoItemDTO   := {} // Array Of  CondicaoPagamento_CONDICAOITEMDTO():New()
Return

WSMETHOD CLONE WSCLIENT CondicaoPagamento_ArrayOfCondicaoItemDTO
	Local oClone := CondicaoPagamento_ArrayOfCondicaoItemDTO():NEW()
	oClone:oWSCondicaoItemDTO := NIL
	If ::oWSCondicaoItemDTO <> NIL 
		oClone:oWSCondicaoItemDTO := {}
		aEval( ::oWSCondicaoItemDTO , { |x| aadd( oClone:oWSCondicaoItemDTO , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT CondicaoPagamento_ArrayOfCondicaoItemDTO
	Local cSoap := ""
	aEval( ::oWSCondicaoItemDTO , {|x| cSoap := cSoap  +  WSSoapValue("CondicaoItemDTO", x , x , "CondicaoItemDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.)  } ) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT CondicaoPagamento_ArrayOfCondicaoItemDTO
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_CONDICAOITEMDTO","CondicaoItemDTO",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSCondicaoItemDTO , CondicaoPagamento_CondicaoItemDTO():New() )
			::oWSCondicaoItemDTO[len(::oWSCondicaoItemDTO)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure CondicaoPagamentoIdimaDTO

WSSTRUCT CondicaoPagamento_CondicaoPagamentoIdimaDTO
	WSDATA   csDsCondicaoPagamento     AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT CondicaoPagamento_CondicaoPagamentoIdimaDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT CondicaoPagamento_CondicaoPagamentoIdimaDTO
Return

WSMETHOD CLONE WSCLIENT CondicaoPagamento_CondicaoPagamentoIdimaDTO
	Local oClone := CondicaoPagamento_CondicaoPagamentoIdimaDTO():NEW()
	oClone:csDsCondicaoPagamento := ::csDsCondicaoPagamento
Return oClone

WSMETHOD SOAPSEND WSCLIENT CondicaoPagamento_CondicaoPagamentoIdimaDTO
	Local cSoap := ""
	cSoap += WSSoapValue("sDsCondicaoPagamento", ::csDsCondicaoPagamento, ::csDsCondicaoPagamento , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT CondicaoPagamento_CondicaoPagamentoIdimaDTO
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::csDsCondicaoPagamento :=  WSAdvValue( oResponse,"_SDSCONDICAOPAGAMENTO","string",NIL,NIL,NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure CondicaoItemDTO

WSSTRUCT CondicaoPagamento_CondicaoItemDTO
	WSDATA   ndPcParcela               AS decimal OPTIONAL
	WSDATA   nnNrDias                  AS long OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT CondicaoPagamento_CondicaoItemDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT CondicaoPagamento_CondicaoItemDTO
Return

WSMETHOD CLONE WSCLIENT CondicaoPagamento_CondicaoItemDTO
	Local oClone := CondicaoPagamento_CondicaoItemDTO():NEW()
	oClone:ndPcParcela          := ::ndPcParcela
	oClone:nnNrDias             := ::nnNrDias
Return oClone

WSMETHOD SOAPSEND WSCLIENT CondicaoPagamento_CondicaoItemDTO
	Local cSoap := ""
	cSoap += WSSoapValue("dPcParcela", ::ndPcParcela, ::ndPcParcela , "decimal", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("nNrDias", ::nnNrDias, ::nnNrDias , "long", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT CondicaoPagamento_CondicaoItemDTO
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::ndPcParcela        :=  WSAdvValue( oResponse,"_DPCPARCELA","decimal",NIL,NIL,NIL,"N",NIL,NIL) 
	::nnNrDias           :=  WSAdvValue( oResponse,"_NNRDIAS","long",NIL,NIL,NIL,"N",NIL,NIL) 
Return


