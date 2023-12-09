#INCLUDE "protheus.ch"
#INCLUDE "apwebsrv.ch"

/*=================================================================================================================*\
|| ############################################################################################################### ||
||																	                                               ||
|| # WSDL Service Usuário																						 # ||
|| # WSDL Location: https://srm-hml.paradigmabs.com.br/cassi-hml/services/Usuario.svc?wsdl						 # ||
||																	                                               ||
|| # Data - 26/09/2019 																							 # ||
||																	                                               ||
|| # Desc: WebService de cadastro de Usuário.																	 # ||
||																	                                               ||
|| # Obs: Alterações neste arquivo podem causar funcionamento incorreto.										 # ||
||																	                                               ||
|| ############################################################################################################### ||
\*=================================================================================================================*/
User Function _RWSRHUK ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSUsuario
------------------------------------------------------------------------------- */

WSCLIENT WSUsuario

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD ProcessarUsuario
	WSMETHOD RetornarUsuario
	WSMETHOD RetornarUsuarioPorEmpresa
	WSMETHOD RetornarUsuarioComprador

	WSDATA   _URL                      AS String
	WSDATA   _CERT                     AS String
	WSDATA   _PRIVKEY                  AS String
	WSDATA   _PASSPHRASE               AS String
	WSDATA   _HEADOUT                  AS Array of String
	WSDATA   _COOKIES                  AS Array of String
	WSDATA   oWSlstUsuario             AS Usuario_ArrayOfUsuarioDTO
	WSDATA   oWSProcessarUsuarioResult AS Usuario_RetornoDTO
	WSDATA   csCdUsuario               AS string
	WSDATA   oWSRetornarUsuarioResult  AS Usuario_UsuarioDTO
	WSDATA   csCdEmpresa               AS string
	WSDATA   oWSRetornarUsuarioPorEmpresaResult AS Usuario_RetornoListaUsuarioDTO
	WSDATA   csLstCdStUsuario          AS string
	WSDATA   nnNrPagina                AS int
	WSDATA   oWSRetornarUsuarioCompradorResult AS Usuario_RetornoListaUsuarioDTO

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSUsuario
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.131227A-20190114 NG] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSUsuario
	::oWSlstUsuario      := Usuario_ARRAYOFUSUARIODTO():New()
	::oWSProcessarUsuarioResult := Usuario_RETORNODTO():New()
	::oWSRetornarUsuarioResult := Usuario_USUARIODTO():New()
	::oWSRetornarUsuarioPorEmpresaResult := Usuario_RETORNOLISTAUSUARIODTO():New()
	::oWSRetornarUsuarioCompradorResult := Usuario_RETORNOLISTAUSUARIODTO():New()
Return

WSMETHOD RESET WSCLIENT WSUsuario
	::oWSlstUsuario      := NIL 
	::oWSProcessarUsuarioResult := NIL 
	::csCdUsuario        := NIL 
	::oWSRetornarUsuarioResult := NIL 
	::csCdEmpresa        := NIL 
	::oWSRetornarUsuarioPorEmpresaResult := NIL 
	::csLstCdStUsuario   := NIL 
	::nnNrPagina         := NIL 
	::oWSRetornarUsuarioCompradorResult := NIL 
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSUsuario
Local oClone := WSUsuario():New()
	oClone:_URL          := ::_URL 
	oClone:_CERT         := ::_CERT 
	oClone:_PRIVKEY      := ::_PRIVKEY 
	oClone:_PASSPHRASE   := ::_PASSPHRASE 
	oClone:oWSlstUsuario :=  IIF(::oWSlstUsuario = NIL , NIL ,::oWSlstUsuario:Clone() )
	oClone:oWSProcessarUsuarioResult :=  IIF(::oWSProcessarUsuarioResult = NIL , NIL ,::oWSProcessarUsuarioResult:Clone() )
	oClone:csCdUsuario   := ::csCdUsuario
	oClone:oWSRetornarUsuarioResult :=  IIF(::oWSRetornarUsuarioResult = NIL , NIL ,::oWSRetornarUsuarioResult:Clone() )
	oClone:csCdEmpresa   := ::csCdEmpresa
	oClone:oWSRetornarUsuarioPorEmpresaResult :=  IIF(::oWSRetornarUsuarioPorEmpresaResult = NIL , NIL ,::oWSRetornarUsuarioPorEmpresaResult:Clone() )
	oClone:csLstCdStUsuario := ::csLstCdStUsuario
	oClone:nnNrPagina    := ::nnNrPagina
	oClone:oWSRetornarUsuarioCompradorResult :=  IIF(::oWSRetornarUsuarioCompradorResult = NIL , NIL ,::oWSRetornarUsuarioCompradorResult:Clone() )
Return oClone

// WSDL Method ProcessarUsuario of Service WSUsuario

WSMETHOD ProcessarUsuario WSSEND oWSlstUsuario WSRECEIVE oWSProcessarUsuarioResult WSCLIENT WSUsuario
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ProcessarUsuario xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("lstUsuario", ::oWSlstUsuario, oWSlstUsuario , "ArrayOfUsuarioDTO", .F. , .F., 0 , "http://tempuri.org/", .F.,.F.) 
cSoap += "</ProcessarUsuario>"

Self:_HEADOUT := { "Authorization: Bearer " + U_NewToken() }
oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tempuri.org/IUsuario/ProcessarUsuario",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	Lower(AllTrim(GetMv("MV_XPARURL"))) + "/services/Usuario.svc")

::Init()
::oWSProcessarUsuarioResult:SoapRecv( WSAdvValue( oXmlRet,"_PROCESSARUSUARIORESPONSE:_PROCESSARUSUARIORESULT","RetornoDTO",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return {.T.,cSoap}

// WSDL Method RetornarUsuario of Service WSUsuario

WSMETHOD RetornarUsuario WSSEND csCdUsuario WSRECEIVE oWSRetornarUsuarioResult WSCLIENT WSUsuario
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<RetornarUsuario xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("sCdUsuario", ::csCdUsuario, csCdUsuario , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</RetornarUsuario>"

Self:_HEADOUT := { "Authorization: Bearer " + U_NewToken() }
oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tempuri.org/IUsuario/RetornarUsuario",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	Lower(AllTrim(GetMv("MV_XPARURL"))) + "/services/Usuario.svc")

::Init()
::oWSRetornarUsuarioResult:SoapRecv( WSAdvValue( oXmlRet,"_RETORNARUSUARIORESPONSE:_RETORNARUSUARIORESULT","UsuarioDTO",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method RetornarUsuarioPorEmpresa of Service WSUsuario

WSMETHOD RetornarUsuarioPorEmpresa WSSEND csCdEmpresa WSRECEIVE oWSRetornarUsuarioPorEmpresaResult WSCLIENT WSUsuario
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<RetornarUsuarioPorEmpresa xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("sCdEmpresa", ::csCdEmpresa, csCdEmpresa , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</RetornarUsuarioPorEmpresa>"

Self:_HEADOUT := { "Authorization: Bearer " + U_NewToken() }
oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tempuri.org/IUsuario/RetornarUsuarioPorEmpresa",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	Lower(AllTrim(GetMv("MV_XPARURL"))) + "/services/Usuario.svc")

::Init()
::oWSRetornarUsuarioPorEmpresaResult:SoapRecv( WSAdvValue( oXmlRet,"_RETORNARUSUARIOPOREMPRESARESPONSE:_RETORNARUSUARIOPOREMPRESARESULT","RetornoListaUsuarioDTO",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method RetornarUsuarioComprador of Service WSUsuario

WSMETHOD RetornarUsuarioComprador WSSEND csCdEmpresa,csLstCdStUsuario,nnNrPagina WSRECEIVE oWSRetornarUsuarioCompradorResult WSCLIENT WSUsuario
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<RetornarUsuarioComprador xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("sCdEmpresa", ::csCdEmpresa, csCdEmpresa , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("sLstCdStUsuario", ::csLstCdStUsuario, csLstCdStUsuario , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("nNrPagina", ::nnNrPagina, nnNrPagina , "int", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</RetornarUsuarioComprador>"

Self:_HEADOUT := { "Authorization: Bearer " + U_NewToken() }
oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tempuri.org/IUsuario/RetornarUsuarioComprador",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	Lower(AllTrim(GetMv("MV_XPARURL"))) + "/services/Usuario.svc")

::Init()
::oWSRetornarUsuarioCompradorResult:SoapRecv( WSAdvValue( oXmlRet,"_RETORNARUSUARIOCOMPRADORRESPONSE:_RETORNARUSUARIOCOMPRADORRESULT","RetornoListaUsuarioDTO",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.


// WSDL Data Structure ArrayOfUsuarioDTO

WSSTRUCT Usuario_ArrayOfUsuarioDTO
	WSDATA   oWSUsuarioDTO             AS Usuario_UsuarioDTO OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Usuario_ArrayOfUsuarioDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Usuario_ArrayOfUsuarioDTO
	::oWSUsuarioDTO        := {} // Array Of  Usuario_USUARIODTO():New()
Return

WSMETHOD CLONE WSCLIENT Usuario_ArrayOfUsuarioDTO
	Local oClone := Usuario_ArrayOfUsuarioDTO():NEW()
	oClone:oWSUsuarioDTO := NIL
	If ::oWSUsuarioDTO <> NIL 
		oClone:oWSUsuarioDTO := {}
		aEval( ::oWSUsuarioDTO , { |x| aadd( oClone:oWSUsuarioDTO , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT Usuario_ArrayOfUsuarioDTO
	Local cSoap := ""
	aEval( ::oWSUsuarioDTO , {|x| cSoap := cSoap  +  WSSoapValue("UsuarioDTO", x , x , "UsuarioDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.)  } ) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Usuario_ArrayOfUsuarioDTO
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_USUARIODTO","UsuarioDTO",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSUsuarioDTO , Usuario_UsuarioDTO():New() )
			::oWSUsuarioDTO[len(::oWSUsuarioDTO)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure RetornoDTO

WSSTRUCT Usuario_RetornoDTO
	WSDATA   oWSlstWbtLogDTO           AS Usuario_ArrayOfWbtLogDTO OPTIONAL
	WSDATA   nnIdRetorno               AS long OPTIONAL
	WSDATA   csNrToken                 AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Usuario_RetornoDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Usuario_RetornoDTO
Return

WSMETHOD CLONE WSCLIENT Usuario_RetornoDTO
	Local oClone := Usuario_RetornoDTO():NEW()
	oClone:oWSlstWbtLogDTO      := IIF(::oWSlstWbtLogDTO = NIL , NIL , ::oWSlstWbtLogDTO:Clone() )
	oClone:nnIdRetorno          := ::nnIdRetorno
	oClone:csNrToken            := ::csNrToken
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Usuario_RetornoDTO
	Local oNode1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_LSTWBTLOGDTO","ArrayOfWbtLogDTO",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode1 != NIL
		::oWSlstWbtLogDTO := Usuario_ArrayOfWbtLogDTO():New()
		::oWSlstWbtLogDTO:SoapRecv(oNode1)
	EndIf
	::nnIdRetorno        :=  WSAdvValue( oResponse,"_NIDRETORNO","long",NIL,NIL,NIL,"N",NIL,NIL) 
	::csNrToken          :=  WSAdvValue( oResponse,"_SNRTOKEN","string",NIL,NIL,NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure UsuarioDTO

WSSTRUCT Usuario_UsuarioDTO
	WSDATA   oWSlstGrupoUsuario        AS Usuario_ArrayOfGrupoUsuarioDTO OPTIONAL
	WSDATA   oWSlstIdPerfil            AS Usuario_ArrayOfint OPTIONAL
	WSDATA   oWSlstUsuarioEmpresa      AS Usuario_ArrayOfUsuarioEmpresaDTO OPTIONAL
	WSDATA   nnCdSituacao              AS int OPTIONAL
	WSDATA   nnIdRepresentante         AS int OPTIONAL
	WSDATA   csCdDepartamento          AS string OPTIONAL
	WSDATA   csCdEmpresa               AS string OPTIONAL
	WSDATA   csCdUsuario               AS string OPTIONAL
	WSDATA   csCdUsuarioEmpresa        AS string OPTIONAL
	WSDATA   csDsEmailContato          AS string OPTIONAL
	WSDATA   csNmUsuario               AS string OPTIONAL
	WSDATA   csNrCPF                   AS string OPTIONAL
	WSDATA   csNrTelefone              AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Usuario_UsuarioDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Usuario_UsuarioDTO
Return

WSMETHOD CLONE WSCLIENT Usuario_UsuarioDTO
	Local oClone := Usuario_UsuarioDTO():NEW()
	oClone:oWSlstGrupoUsuario   := IIF(::oWSlstGrupoUsuario = NIL , NIL , ::oWSlstGrupoUsuario:Clone() )
	oClone:oWSlstIdPerfil       := IIF(::oWSlstIdPerfil = NIL , NIL , ::oWSlstIdPerfil:Clone() )
	oClone:oWSlstUsuarioEmpresa := IIF(::oWSlstUsuarioEmpresa = NIL , NIL , ::oWSlstUsuarioEmpresa:Clone() )
	oClone:nnCdSituacao         := ::nnCdSituacao
	oClone:nnIdRepresentante    := ::nnIdRepresentante
	oClone:csCdDepartamento     := ::csCdDepartamento
	oClone:csCdEmpresa          := ::csCdEmpresa
	oClone:csCdUsuario          := ::csCdUsuario
	oClone:csCdUsuarioEmpresa   := ::csCdUsuarioEmpresa
	oClone:csDsEmailContato     := ::csDsEmailContato
	oClone:csNmUsuario          := ::csNmUsuario
	oClone:csNrCPF              := ::csNrCPF
	oClone:csNrTelefone         := ::csNrTelefone
Return oClone

WSMETHOD SOAPSEND WSCLIENT Usuario_UsuarioDTO
	Local cSoap := ""
	cSoap += WSSoapValue("lstGrupoUsuario", ::oWSlstGrupoUsuario, ::oWSlstGrupoUsuario , "ArrayOfGrupoUsuarioDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("lstIdPerfil", ::oWSlstIdPerfil, ::oWSlstIdPerfil , "ArrayOfint", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("lstUsuarioEmpresa", ::oWSlstUsuarioEmpresa, ::oWSlstUsuarioEmpresa , "ArrayOfUsuarioEmpresaDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("nCdSituacao", ::nnCdSituacao, ::nnCdSituacao , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("nIdRepresentante", ::nnIdRepresentante, ::nnIdRepresentante , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdDepartamento", ::csCdDepartamento, ::csCdDepartamento , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdEmpresa", ::csCdEmpresa, ::csCdEmpresa , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdUsuario", ::csCdUsuario, ::csCdUsuario , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdUsuarioEmpresa", ::csCdUsuarioEmpresa, ::csCdUsuarioEmpresa , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sDsEmailContato", ::csDsEmailContato, ::csDsEmailContato , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sNmUsuario", ::csNmUsuario, ::csNmUsuario , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sNrCPF", ::csNrCPF, ::csNrCPF , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sNrTelefone", ::csNrTelefone, ::csNrTelefone , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Usuario_UsuarioDTO
	Local oNode1
	Local oNode2
	Local oNode3
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_LSTGRUPOUSUARIO","ArrayOfGrupoUsuarioDTO",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode1 != NIL
		::oWSlstGrupoUsuario := Usuario_ArrayOfGrupoUsuarioDTO():New()
		::oWSlstGrupoUsuario:SoapRecv(oNode1)
	EndIf
	oNode2 :=  WSAdvValue( oResponse,"_LSTIDPERFIL","ArrayOfint",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode2 != NIL
		::oWSlstIdPerfil := Usuario_ArrayOfint():New()
		::oWSlstIdPerfil:SoapRecv(oNode2)
	EndIf
	oNode3 :=  WSAdvValue( oResponse,"_LSTUSUARIOEMPRESA","ArrayOfUsuarioEmpresaDTO",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode3 != NIL
		::oWSlstUsuarioEmpresa := Usuario_ArrayOfUsuarioEmpresaDTO():New()
		::oWSlstUsuarioEmpresa:SoapRecv(oNode3)
	EndIf
	::nnCdSituacao       :=  WSAdvValue( oResponse,"_NCDSITUACAO","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::nnIdRepresentante  :=  WSAdvValue( oResponse,"_NIDREPRESENTANTE","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::csCdDepartamento   :=  WSAdvValue( oResponse,"_SCDDEPARTAMENTO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdEmpresa        :=  WSAdvValue( oResponse,"_SCDEMPRESA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdUsuario        :=  WSAdvValue( oResponse,"_SCDUSUARIO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdUsuarioEmpresa :=  WSAdvValue( oResponse,"_SCDUSUARIOEMPRESA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csDsEmailContato   :=  WSAdvValue( oResponse,"_SDSEMAILCONTATO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csNmUsuario        :=  WSAdvValue( oResponse,"_SNMUSUARIO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csNrCPF            :=  WSAdvValue( oResponse,"_SNRCPF","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csNrTelefone       :=  WSAdvValue( oResponse,"_SNRTELEFONE","string",NIL,NIL,NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure RetornoListaUsuarioDTO

WSSTRUCT Usuario_RetornoListaUsuarioDTO
	WSDATA   oWSlstObjetoRetorno       AS Usuario_ArrayOfUsuarioDTO OPTIONAL
	WSDATA   nnQtRegistrosRetorno      AS int OPTIONAL
	WSDATA   nnQtRegistrosTotal        AS int OPTIONAL
	WSDATA   oWSoRetornoDTO            AS Usuario_RetornoDTO OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Usuario_RetornoListaUsuarioDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Usuario_RetornoListaUsuarioDTO
Return

WSMETHOD CLONE WSCLIENT Usuario_RetornoListaUsuarioDTO
	Local oClone := Usuario_RetornoListaUsuarioDTO():NEW()
	oClone:oWSlstObjetoRetorno  := IIF(::oWSlstObjetoRetorno = NIL , NIL , ::oWSlstObjetoRetorno:Clone() )
	oClone:nnQtRegistrosRetorno := ::nnQtRegistrosRetorno
	oClone:nnQtRegistrosTotal   := ::nnQtRegistrosTotal
	oClone:oWSoRetornoDTO       := IIF(::oWSoRetornoDTO = NIL , NIL , ::oWSoRetornoDTO:Clone() )
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Usuario_RetornoListaUsuarioDTO
	Local oNode1
	Local oNode4
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_LSTOBJETORETORNO","ArrayOfUsuarioDTO",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode1 != NIL
		::oWSlstObjetoRetorno := Usuario_ArrayOfUsuarioDTO():New()
		::oWSlstObjetoRetorno:SoapRecv(oNode1)
	EndIf
	::nnQtRegistrosRetorno :=  WSAdvValue( oResponse,"_NQTREGISTROSRETORNO","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::nnQtRegistrosTotal :=  WSAdvValue( oResponse,"_NQTREGISTROSTOTAL","int",NIL,NIL,NIL,"N",NIL,NIL) 
	oNode4 :=  WSAdvValue( oResponse,"_ORETORNODTO","RetornoDTO",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode4 != NIL
		::oWSoRetornoDTO := Usuario_RetornoDTO():New()
		::oWSoRetornoDTO:SoapRecv(oNode4)
	EndIf
Return

// WSDL Data Structure ArrayOfWbtLogDTO

WSSTRUCT Usuario_ArrayOfWbtLogDTO
	WSDATA   oWSWbtLogDTO              AS Usuario_WbtLogDTO OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Usuario_ArrayOfWbtLogDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Usuario_ArrayOfWbtLogDTO
	::oWSWbtLogDTO         := {} // Array Of  Usuario_WBTLOGDTO():New()
Return

WSMETHOD CLONE WSCLIENT Usuario_ArrayOfWbtLogDTO
	Local oClone := Usuario_ArrayOfWbtLogDTO():NEW()
	oClone:oWSWbtLogDTO := NIL
	If ::oWSWbtLogDTO <> NIL 
		oClone:oWSWbtLogDTO := {}
		aEval( ::oWSWbtLogDTO , { |x| aadd( oClone:oWSWbtLogDTO , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Usuario_ArrayOfWbtLogDTO
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_WBTLOGDTO","WbtLogDTO",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSWbtLogDTO , Usuario_WbtLogDTO():New() )
			::oWSWbtLogDTO[len(::oWSWbtLogDTO)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure ArrayOfGrupoUsuarioDTO

WSSTRUCT Usuario_ArrayOfGrupoUsuarioDTO
	WSDATA   oWSGrupoUsuarioDTO        AS Usuario_GrupoUsuarioDTO OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Usuario_ArrayOfGrupoUsuarioDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Usuario_ArrayOfGrupoUsuarioDTO
	::oWSGrupoUsuarioDTO   := {} // Array Of  Usuario_GRUPOUSUARIODTO():New()
Return

WSMETHOD CLONE WSCLIENT Usuario_ArrayOfGrupoUsuarioDTO
	Local oClone := Usuario_ArrayOfGrupoUsuarioDTO():NEW()
	oClone:oWSGrupoUsuarioDTO := NIL
	If ::oWSGrupoUsuarioDTO <> NIL 
		oClone:oWSGrupoUsuarioDTO := {}
		aEval( ::oWSGrupoUsuarioDTO , { |x| aadd( oClone:oWSGrupoUsuarioDTO , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT Usuario_ArrayOfGrupoUsuarioDTO
	Local cSoap := ""
	aEval( ::oWSGrupoUsuarioDTO , {|x| cSoap := cSoap  +  WSSoapValue("GrupoUsuarioDTO", x , x , "GrupoUsuarioDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.)  } ) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Usuario_ArrayOfGrupoUsuarioDTO
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_GRUPOUSUARIODTO","GrupoUsuarioDTO",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSGrupoUsuarioDTO , Usuario_GrupoUsuarioDTO():New() )
			::oWSGrupoUsuarioDTO[len(::oWSGrupoUsuarioDTO)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure ArrayOfint

WSSTRUCT Usuario_ArrayOfint
	WSDATA   nint                      AS int OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Usuario_ArrayOfint
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Usuario_ArrayOfint
	::nint                 := {} // Array Of  0
Return

WSMETHOD CLONE WSCLIENT Usuario_ArrayOfint
	Local oClone := Usuario_ArrayOfint():NEW()
	oClone:nint                 := IIf(::nint <> NIL , aClone(::nint) , NIL )
Return oClone

WSMETHOD SOAPSEND WSCLIENT Usuario_ArrayOfint
	Local cSoap := ""
	aEval( ::nint , {|x| cSoap := cSoap  +  WSSoapValue("int", x , x , "int", .F. , .F., 0 , "http://schemas.microsoft.com/2003/10/Serialization/Arrays", .F.,.F.)  } ) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Usuario_ArrayOfint
	Local oNodes1 :=  WSAdvValue( oResponse,"_INT","int",{},NIL,.T.,"N",NIL,"a") 
	::Init()
	If oResponse = NIL ; Return ; Endif 
	aEval(oNodes1 , { |x| aadd(::nint ,  val(x:TEXT)  ) } )
Return

// WSDL Data Structure ArrayOfUsuarioEmpresaDTO

WSSTRUCT Usuario_ArrayOfUsuarioEmpresaDTO
	WSDATA   oWSUsuarioEmpresaDTO      AS Usuario_UsuarioEmpresaDTO OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Usuario_ArrayOfUsuarioEmpresaDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Usuario_ArrayOfUsuarioEmpresaDTO
	::oWSUsuarioEmpresaDTO := {} // Array Of  Usuario_USUARIOEMPRESADTO():New()
Return

WSMETHOD CLONE WSCLIENT Usuario_ArrayOfUsuarioEmpresaDTO
	Local oClone := Usuario_ArrayOfUsuarioEmpresaDTO():NEW()
	oClone:oWSUsuarioEmpresaDTO := NIL
	If ::oWSUsuarioEmpresaDTO <> NIL 
		oClone:oWSUsuarioEmpresaDTO := {}
		aEval( ::oWSUsuarioEmpresaDTO , { |x| aadd( oClone:oWSUsuarioEmpresaDTO , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT Usuario_ArrayOfUsuarioEmpresaDTO
	Local cSoap := ""
	aEval( ::oWSUsuarioEmpresaDTO , {|x| cSoap := cSoap  +  WSSoapValue("UsuarioEmpresaDTO", x , x , "UsuarioEmpresaDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.)  } ) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Usuario_ArrayOfUsuarioEmpresaDTO
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_USUARIOEMPRESADTO","UsuarioEmpresaDTO",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSUsuarioEmpresaDTO , Usuario_UsuarioEmpresaDTO():New() )
			::oWSUsuarioEmpresaDTO[len(::oWSUsuarioEmpresaDTO)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure WbtLogDTO

WSSTRUCT Usuario_WbtLogDTO
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

WSMETHOD NEW WSCLIENT Usuario_WbtLogDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Usuario_WbtLogDTO
Return

WSMETHOD CLONE WSCLIENT Usuario_WbtLogDTO
	Local oClone := Usuario_WbtLogDTO():NEW()
	oClone:nnCdLog              := ::nnCdLog
	oClone:nnIdRetorno          := ::nnIdRetorno
	oClone:csCdOrigem           := ::csCdOrigem
	oClone:csDsLog              := ::csDsLog
	oClone:csDsTipoDocumento    := ::csDsTipoDocumento
	oClone:csNrToken            := ::csNrToken
	oClone:ctDtLog              := ::ctDtLog
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Usuario_WbtLogDTO
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

// WSDL Data Structure GrupoUsuarioDTO

WSSTRUCT Usuario_GrupoUsuarioDTO
	WSDATA   nnCdGrupo                 AS long OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Usuario_GrupoUsuarioDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Usuario_GrupoUsuarioDTO
Return

WSMETHOD CLONE WSCLIENT Usuario_GrupoUsuarioDTO
	Local oClone := Usuario_GrupoUsuarioDTO():NEW()
	oClone:nnCdGrupo            := ::nnCdGrupo
Return oClone

WSMETHOD SOAPSEND WSCLIENT Usuario_GrupoUsuarioDTO
	Local cSoap := ""
	cSoap += WSSoapValue("nCdGrupo", ::nnCdGrupo, ::nnCdGrupo , "long", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Usuario_GrupoUsuarioDTO
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::nnCdGrupo          :=  WSAdvValue( oResponse,"_NCDGRUPO","long",NIL,NIL,NIL,"N",NIL,NIL) 
Return

// WSDL Data Structure UsuarioEmpresaDTO

WSSTRUCT Usuario_UsuarioEmpresaDTO
	WSDATA   csCdEmpresa               AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Usuario_UsuarioEmpresaDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Usuario_UsuarioEmpresaDTO
Return

WSMETHOD CLONE WSCLIENT Usuario_UsuarioEmpresaDTO
	Local oClone := Usuario_UsuarioEmpresaDTO():NEW()
	oClone:csCdEmpresa          := ::csCdEmpresa
Return oClone

WSMETHOD SOAPSEND WSCLIENT Usuario_UsuarioEmpresaDTO
	Local cSoap := ""
	cSoap += WSSoapValue("sCdEmpresa", ::csCdEmpresa, ::csCdEmpresa , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Usuario_UsuarioEmpresaDTO
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::csCdEmpresa        :=  WSAdvValue( oResponse,"_SCDEMPRESA","string",NIL,NIL,NIL,"S",NIL,NIL) 
Return


