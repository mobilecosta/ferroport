#INCLUDE "protheus.ch"
#INCLUDE "apwebsrv.ch"

/*=================================================================================================================*\
|| ############################################################################################################### ||
||																	                                               ||
|| # WSDL Service Banco																							 # ||
|| # WSDL Location: https://srm-hml.paradigmabs.com.br/cassi-hml/services//Banco.svc?wsdl						 # ||
||																	                                               ||
|| # Data - 26/09/2019 																							 # ||
||																	                                               ||
|| # Desc: WebService de cadastro de Banco.																		 # ||
||																	                                               ||
|| # Obs: Alterações neste arquivo podem causar funcionamento incorreto.										 # ||
||																	                                               ||
|| ############################################################################################################### ||
\*=================================================================================================================*/
User Function _TMUEEMN ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSBanco
------------------------------------------------------------------------------- */

WSCLIENT WSParBanco

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD ProcessarBanco
	WSMETHOD ExcluirAgenciaBanco

	WSDATA   _URL                      AS String
	WSDATA   _CERT                     AS String
	WSDATA   _PRIVKEY                  AS String
	WSDATA   _PASSPHRASE               AS String
	WSDATA   _HEADOUT                  AS Array of String
	WSDATA   _COOKIES                  AS Array of String
	WSDATA   oWSlstBanco               AS Banco_ArrayOfBancoDTO
	WSDATA   oWSProcessarBancoResult   AS Banco_RetornoDTO
	WSDATA   oWSlstAgenciaBanco        AS Banco_ArrayOfAgenciaBancoExclusaoDTO
	WSDATA   oWSExcluirAgenciaBancoResult AS Banco_RetornoDTO

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSParBanco
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.131227A-20190114 NG] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSParBanco
	::oWSlstBanco        := Banco_ARRAYOFBANCODTO():New()
	::oWSProcessarBancoResult := Banco_RETORNODTO():New()
	::oWSlstAgenciaBanco := Banco_ARRAYOFAGENCIABANCOEXCLUSAODTO():New()
	::oWSExcluirAgenciaBancoResult := Banco_RETORNODTO():New()
Return

WSMETHOD RESET WSCLIENT WSParBanco
	::oWSlstBanco        := NIL 
	::oWSProcessarBancoResult := NIL 
	::oWSlstAgenciaBanco := NIL 
	::oWSExcluirAgenciaBancoResult := NIL 
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSParBanco
Local oClone := WSBanco():New()
	oClone:_URL          := ::_URL 
	oClone:_CERT         := ::_CERT 
	oClone:_PRIVKEY      := ::_PRIVKEY 
	oClone:_PASSPHRASE   := ::_PASSPHRASE 
	oClone:oWSlstBanco   :=  IIF(::oWSlstBanco = NIL , NIL ,::oWSlstBanco:Clone() )
	oClone:oWSProcessarBancoResult :=  IIF(::oWSProcessarBancoResult = NIL , NIL ,::oWSProcessarBancoResult:Clone() )
	oClone:oWSlstAgenciaBanco :=  IIF(::oWSlstAgenciaBanco = NIL , NIL ,::oWSlstAgenciaBanco:Clone() )
	oClone:oWSExcluirAgenciaBancoResult :=  IIF(::oWSExcluirAgenciaBancoResult = NIL , NIL ,::oWSExcluirAgenciaBancoResult:Clone() )
Return oClone

// WSDL Method ProcessarBanco of Service WSBanco

WSMETHOD ProcessarBanco WSSEND oWSlstBanco WSRECEIVE oWSProcessarBancoResult WSCLIENT WSParBanco
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ProcessarBanco xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("lstBanco", ::oWSlstBanco, oWSlstBanco , "ArrayOfBancoDTO", .F. , .F., 0 , "http://tempuri.org/", .F.,.F.) 
cSoap += "</ProcessarBanco>"

Self:_HEADOUT := { "Authorization: Bearer " + U_NewToken() }
oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tempuri.org/IBanco/ProcessarBanco",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	Lower(AllTrim(GetMv("MV_XPARURL"))) + "/services/Banco.svc")

::Init()
::oWSProcessarBancoResult:SoapRecv( WSAdvValue( oXmlRet,"_PROCESSARBANCORESPONSE:_PROCESSARBANCORESULT","RetornoDTO",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return {.T.,cSoap}

// WSDL Method ExcluirAgenciaBanco of Service WSBanco

WSMETHOD ExcluirAgenciaBanco WSSEND oWSlstAgenciaBanco WSRECEIVE oWSExcluirAgenciaBancoResult WSCLIENT WSParBanco
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ExcluirAgenciaBanco xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("lstAgenciaBanco", ::oWSlstAgenciaBanco, oWSlstAgenciaBanco , "ArrayOfAgenciaBancoExclusaoDTO", .F. , .F., 0 , "http://tempuri.org/", .F.,.F.) 
cSoap += "</ExcluirAgenciaBanco>"

Self:_HEADOUT := { "Authorization: Bearer " + U_NewToken() }
oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tempuri.org/IBanco/ExcluirAgenciaBanco",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	Lower(AllTrim(GetMv("MV_XPARURL"))) + "/services/Banco.svc")

::Init()
::oWSExcluirAgenciaBancoResult:SoapRecv( WSAdvValue( oXmlRet,"_EXCLUIRAGENCIABANCORESPONSE:_EXCLUIRAGENCIABANCORESULT","RetornoDTO",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.


// WSDL Data Structure ArrayOfBancoDTO

WSSTRUCT Banco_ArrayOfBancoDTO
	WSDATA   oWSBancoDTO               AS Banco_BancoDTO OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Banco_ArrayOfBancoDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Banco_ArrayOfBancoDTO
	::oWSBancoDTO          := {} // Array Of  Banco_BANCODTO():New()
Return

WSMETHOD CLONE WSCLIENT Banco_ArrayOfBancoDTO
	Local oClone := Banco_ArrayOfBancoDTO():NEW()
	oClone:oWSBancoDTO := NIL
	If ::oWSBancoDTO <> NIL 
		oClone:oWSBancoDTO := {}
		aEval( ::oWSBancoDTO , { |x| aadd( oClone:oWSBancoDTO , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT Banco_ArrayOfBancoDTO
	Local cSoap := ""
	aEval( ::oWSBancoDTO , {|x| cSoap := cSoap  +  WSSoapValue("BancoDTO", x , x , "BancoDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.)  } ) 
Return cSoap

// WSDL Data Structure RetornoDTO

WSSTRUCT Banco_RetornoDTO
	WSDATA   oWSlstWbtLogDTO           AS Banco_ArrayOfWbtLogDTO OPTIONAL
	WSDATA   nnIdRetorno               AS long OPTIONAL
	WSDATA   csNrToken                 AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Banco_RetornoDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Banco_RetornoDTO
Return

WSMETHOD CLONE WSCLIENT Banco_RetornoDTO
	Local oClone := Banco_RetornoDTO():NEW()
	oClone:oWSlstWbtLogDTO      := IIF(::oWSlstWbtLogDTO = NIL , NIL , ::oWSlstWbtLogDTO:Clone() )
	oClone:nnIdRetorno          := ::nnIdRetorno
	oClone:csNrToken            := ::csNrToken
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Banco_RetornoDTO
	Local oNode1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_LSTWBTLOGDTO","ArrayOfWbtLogDTO",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode1 != NIL
		::oWSlstWbtLogDTO := Banco_ArrayOfWbtLogDTO():New()
		::oWSlstWbtLogDTO:SoapRecv(oNode1)
	EndIf
	::nnIdRetorno        :=  WSAdvValue( oResponse,"_NIDRETORNO","long",NIL,NIL,NIL,"N",NIL,NIL) 
	::csNrToken          :=  WSAdvValue( oResponse,"_SNRTOKEN","string",NIL,NIL,NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure ArrayOfAgenciaBancoExclusaoDTO

WSSTRUCT Banco_ArrayOfAgenciaBancoExclusaoDTO
	WSDATA   oWSAgenciaBancoExclusaoDTO AS Banco_AgenciaBancoExclusaoDTO OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Banco_ArrayOfAgenciaBancoExclusaoDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Banco_ArrayOfAgenciaBancoExclusaoDTO
	::oWSAgenciaBancoExclusaoDTO := {} // Array Of  Banco_AGENCIABANCOEXCLUSAODTO():New()
Return

WSMETHOD CLONE WSCLIENT Banco_ArrayOfAgenciaBancoExclusaoDTO
	Local oClone := Banco_ArrayOfAgenciaBancoExclusaoDTO():NEW()
	oClone:oWSAgenciaBancoExclusaoDTO := NIL
	If ::oWSAgenciaBancoExclusaoDTO <> NIL 
		oClone:oWSAgenciaBancoExclusaoDTO := {}
		aEval( ::oWSAgenciaBancoExclusaoDTO , { |x| aadd( oClone:oWSAgenciaBancoExclusaoDTO , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT Banco_ArrayOfAgenciaBancoExclusaoDTO
	Local cSoap := ""
	aEval( ::oWSAgenciaBancoExclusaoDTO , {|x| cSoap := cSoap  +  WSSoapValue("AgenciaBancoExclusaoDTO", x , x , "AgenciaBancoExclusaoDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.)  } ) 
Return cSoap

// WSDL Data Structure BancoDTO

WSSTRUCT Banco_BancoDTO
	WSDATA   oWSlstAgenciaDTO          AS Banco_ArrayOfAgenciaBancoDTO OPTIONAL
	WSDATA   nnNrBanco                 AS int OPTIONAL
	WSDATA   nnNrDigitoBanco           AS int OPTIONAL
	WSDATA   csCdBanco                 AS string OPTIONAL
	WSDATA   csCdPais                  AS string OPTIONAL
	WSDATA   csNmBanco                 AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Banco_BancoDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Banco_BancoDTO
Return

WSMETHOD CLONE WSCLIENT Banco_BancoDTO
	Local oClone := Banco_BancoDTO():NEW()
	oClone:oWSlstAgenciaDTO     := IIF(::oWSlstAgenciaDTO = NIL , NIL , ::oWSlstAgenciaDTO:Clone() )
	oClone:nnNrBanco            := ::nnNrBanco
	oClone:nnNrDigitoBanco      := ::nnNrDigitoBanco
	oClone:csCdBanco            := ::csCdBanco
	oClone:csCdPais             := ::csCdPais
	oClone:csNmBanco            := ::csNmBanco
Return oClone

WSMETHOD SOAPSEND WSCLIENT Banco_BancoDTO
	Local cSoap := ""
	cSoap += WSSoapValue("lstAgenciaDTO", ::oWSlstAgenciaDTO, ::oWSlstAgenciaDTO , "ArrayOfAgenciaBancoDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("nNrBanco", ::nnNrBanco, ::nnNrBanco , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("nNrDigitoBanco", ::nnNrDigitoBanco, ::nnNrDigitoBanco , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdBanco", ::csCdBanco, ::csCdBanco , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdPais", ::csCdPais, ::csCdPais , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sNmBanco", ::csNmBanco, ::csNmBanco , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
Return cSoap

// WSDL Data Structure ArrayOfWbtLogDTO

WSSTRUCT Banco_ArrayOfWbtLogDTO
	WSDATA   oWSWbtLogDTO              AS Banco_WbtLogDTO OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Banco_ArrayOfWbtLogDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Banco_ArrayOfWbtLogDTO
	::oWSWbtLogDTO         := {} // Array Of  Banco_WBTLOGDTO():New()
Return

WSMETHOD CLONE WSCLIENT Banco_ArrayOfWbtLogDTO
	Local oClone := Banco_ArrayOfWbtLogDTO():NEW()
	oClone:oWSWbtLogDTO := NIL
	If ::oWSWbtLogDTO <> NIL 
		oClone:oWSWbtLogDTO := {}
		aEval( ::oWSWbtLogDTO , { |x| aadd( oClone:oWSWbtLogDTO , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Banco_ArrayOfWbtLogDTO
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_WBTLOGDTO","WbtLogDTO",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSWbtLogDTO , Banco_WbtLogDTO():New() )
			::oWSWbtLogDTO[len(::oWSWbtLogDTO)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure AgenciaBancoExclusaoDTO

WSSTRUCT Banco_AgenciaBancoExclusaoDTO
	WSDATA   csCdAgencia               AS string OPTIONAL
	WSDATA   csCdBanco                 AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Banco_AgenciaBancoExclusaoDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Banco_AgenciaBancoExclusaoDTO
Return

WSMETHOD CLONE WSCLIENT Banco_AgenciaBancoExclusaoDTO
	Local oClone := Banco_AgenciaBancoExclusaoDTO():NEW()
	oClone:csCdAgencia          := ::csCdAgencia
	oClone:csCdBanco            := ::csCdBanco
Return oClone

WSMETHOD SOAPSEND WSCLIENT Banco_AgenciaBancoExclusaoDTO
	Local cSoap := ""
	cSoap += WSSoapValue("sCdAgencia", ::csCdAgencia, ::csCdAgencia , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdBanco", ::csCdBanco, ::csCdBanco , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
Return cSoap

// WSDL Data Structure ArrayOfAgenciaBancoDTO

WSSTRUCT Banco_ArrayOfAgenciaBancoDTO
	WSDATA   oWSAgenciaBancoDTO        AS Banco_AgenciaBancoDTO OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Banco_ArrayOfAgenciaBancoDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Banco_ArrayOfAgenciaBancoDTO
	::oWSAgenciaBancoDTO   := {} // Array Of  Banco_AGENCIABANCODTO():New()
Return

WSMETHOD CLONE WSCLIENT Banco_ArrayOfAgenciaBancoDTO
	Local oClone := Banco_ArrayOfAgenciaBancoDTO():NEW()
	oClone:oWSAgenciaBancoDTO := NIL
	If ::oWSAgenciaBancoDTO <> NIL 
		oClone:oWSAgenciaBancoDTO := {}
		aEval( ::oWSAgenciaBancoDTO , { |x| aadd( oClone:oWSAgenciaBancoDTO , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT Banco_ArrayOfAgenciaBancoDTO
	Local cSoap := ""
	aEval( ::oWSAgenciaBancoDTO , {|x| cSoap := cSoap  +  WSSoapValue("AgenciaBancoDTO", x , x , "AgenciaBancoDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.)  } ) 
Return cSoap

// WSDL Data Structure WbtLogDTO

WSSTRUCT Banco_WbtLogDTO
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

WSMETHOD NEW WSCLIENT Banco_WbtLogDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Banco_WbtLogDTO
Return

WSMETHOD CLONE WSCLIENT Banco_WbtLogDTO
	Local oClone := Banco_WbtLogDTO():NEW()
	oClone:nnCdLog              := ::nnCdLog
	oClone:nnIdRetorno          := ::nnIdRetorno
	oClone:csCdOrigem           := ::csCdOrigem
	oClone:csDsLog              := ::csDsLog
	oClone:csDsTipoDocumento    := ::csDsTipoDocumento
	oClone:csNrToken            := ::csNrToken
	oClone:ctDtLog              := ::ctDtLog
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Banco_WbtLogDTO
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

// WSDL Data Structure AgenciaBancoDTO

WSSTRUCT Banco_AgenciaBancoDTO
	WSDATA   csCdAgencia               AS string OPTIONAL
	WSDATA   nsCdAgenciaBanco          AS int OPTIONAL
	WSDATA   csNmAgencia               AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Banco_AgenciaBancoDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Banco_AgenciaBancoDTO
Return

WSMETHOD CLONE WSCLIENT Banco_AgenciaBancoDTO
	Local oClone := Banco_AgenciaBancoDTO():NEW()
	oClone:csCdAgencia          := ::csCdAgencia
	oClone:nsCdAgenciaBanco     := ::nsCdAgenciaBanco
	oClone:csNmAgencia          := ::csNmAgencia
Return oClone

WSMETHOD SOAPSEND WSCLIENT Banco_AgenciaBancoDTO
	Local cSoap := ""
	cSoap += WSSoapValue("sCdAgencia", ::csCdAgencia, ::csCdAgencia , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdAgenciaBanco", ::nsCdAgenciaBanco, ::nsCdAgenciaBanco , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sNmAgencia", ::csNmAgencia, ::csNmAgencia , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
Return cSoap


