#INCLUDE "protheus.ch"
#INCLUDE "apwebsrv.ch"

/*=================================================================================================================*\
|| ############################################################################################################### ||
||																	                                               ||
|| # WSDL Service Contrato																						 # ||
|| # WSDL Location: https://srm-hml.paradigmabs.com.br/cassi-hml/services/Contrato.svc?wsdl						 # ||
||																	                                               ||
|| # Data - 14/10/2019 																							 # ||
||																	                                               ||
|| # Desc: WebService de cadastro de Contrato.																	 # ||
||																	                                               ||
|| # Obs: Alterações neste arquivo podem causar funcionamento incorreto.										 # ||
||																	                                               ||
|| ############################################################################################################### ||
\*=================================================================================================================*/
User Function _HLZBRKT ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSContrato
------------------------------------------------------------------------------- */

WSCLIENT WSContrato

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD ProcessarContrato
	WSMETHOD RetornarContratoCotacao
	WSMETHOD RetornarContratoLeilao
	WSMETHOD RetornarContratoAtivo
	WSMETHOD RetornarContratoRescindido
	WSMETHOD RetornarContratoPorTermoAditivo
	WSMETHOD RetornarContratoEncerrado
	WSMETHOD RetornarContratoPorComprador
	WSMETHOD RetornarContratoPorFornecedor
	WSMETHOD RetornarContratoPorItem
	WSMETHOD RetornarContratoPorCompradorItem
	WSMETHOD RetornarContratoPorFornecedorItem
	WSMETHOD RetornarCodigoContratoSequencia

	WSDATA   _URL                      AS String
	WSDATA   _CERT                     AS String
	WSDATA   _PRIVKEY                  AS String
	WSDATA   _PASSPHRASE               AS String
	WSDATA   _HEADOUT                  AS Array of String
	WSDATA   _COOKIES                  AS Array of String
	WSDATA   oWSlstContrato            AS Contrato_ArrayOfContratoDTO
	WSDATA   lbFlNaoUtilizaDePara      AS boolean
	WSDATA   oWSProcessarContratoResult AS Contrato_RetornoDTO
	WSDATA   oWSRetornarContratoCotacaoResult AS Contrato_ArrayOfContratoDTO
	WSDATA   oWSRetornarContratoLeilaoResult AS Contrato_ArrayOfContratoDTO
	WSDATA   oWSRetornarContratoAtivoResult AS Contrato_ArrayOfContratoDTO
	WSDATA   oWSRetornarContratoRescindidoResult AS Contrato_ArrayOfContratoDTO
	WSDATA   oWSRetornarContratoPorTermoAditivoResult AS Contrato_ArrayOfContratoDTO
	WSDATA   oWSRetornarContratoEncerradoResult AS Contrato_ArrayOfContratoDTO
	WSDATA   csCdEmpresaContratante    AS string
	WSDATA   oWSRetornarContratoPorCompradorResult AS Contrato_ArrayOfContratoDTO
	WSDATA   csCdEmpresaFornecedor     AS string
	WSDATA   oWSRetornarContratoPorFornecedorResult AS Contrato_ArrayOfContratoDTO
	WSDATA   csCdProduto               AS string
	WSDATA   oWSRetornarContratoPorItemResult AS Contrato_ArrayOfContratoDTO
	WSDATA   oWSoContratoPesquisaDTO   AS Contrato_ContratoPesquisaDTO
	WSDATA   oWSRetornarContratoPorCompradorItemResult AS Contrato_ArrayOfContratoDTO
	WSDATA   oWSRetornarContratoPorFornecedorItemResult AS Contrato_ArrayOfContratoDTO
	WSDATA   csCdEmpresaContratate     AS string
	WSDATA   cRetornarCodigoContratoSequenciaResult AS string

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSContrato
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.131227A-20190114 NG] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSContrato
	::oWSlstContrato     := Contrato_ARRAYOFCONTRATODTO():New()
	::oWSProcessarContratoResult := Contrato_RETORNODTO():New()
	::oWSRetornarContratoCotacaoResult := Contrato_ARRAYOFCONTRATODTO():New()
	::oWSRetornarContratoLeilaoResult := Contrato_ARRAYOFCONTRATODTO():New()
	::oWSRetornarContratoAtivoResult := Contrato_ARRAYOFCONTRATODTO():New()
	::oWSRetornarContratoRescindidoResult := Contrato_ARRAYOFCONTRATODTO():New()
	::oWSRetornarContratoPorTermoAditivoResult := Contrato_ARRAYOFCONTRATODTO():New()
	::oWSRetornarContratoEncerradoResult := Contrato_ARRAYOFCONTRATODTO():New()
	::oWSRetornarContratoPorCompradorResult := Contrato_ARRAYOFCONTRATODTO():New()
	::oWSRetornarContratoPorFornecedorResult := Contrato_ARRAYOFCONTRATODTO():New()
	::oWSRetornarContratoPorItemResult := Contrato_ARRAYOFCONTRATODTO():New()
	::oWSoContratoPesquisaDTO := Contrato_CONTRATOPESQUISADTO():New()
	::oWSRetornarContratoPorCompradorItemResult := Contrato_ARRAYOFCONTRATODTO():New()
	::oWSRetornarContratoPorFornecedorItemResult := Contrato_ARRAYOFCONTRATODTO():New()
Return

WSMETHOD RESET WSCLIENT WSContrato
	::oWSlstContrato     := NIL 
	::lbFlNaoUtilizaDePara := NIL 
	::oWSProcessarContratoResult := NIL 
	::oWSRetornarContratoCotacaoResult := NIL 
	::oWSRetornarContratoLeilaoResult := NIL 
	::oWSRetornarContratoAtivoResult := NIL 
	::oWSRetornarContratoRescindidoResult := NIL 
	::oWSRetornarContratoPorTermoAditivoResult := NIL 
	::oWSRetornarContratoEncerradoResult := NIL 
	::csCdEmpresaContratante := NIL 
	::oWSRetornarContratoPorCompradorResult := NIL 
	::csCdEmpresaFornecedor := NIL 
	::oWSRetornarContratoPorFornecedorResult := NIL 
	::csCdProduto        := NIL 
	::oWSRetornarContratoPorItemResult := NIL 
	::oWSoContratoPesquisaDTO := NIL 
	::oWSRetornarContratoPorCompradorItemResult := NIL 
	::oWSRetornarContratoPorFornecedorItemResult := NIL 
	::csCdEmpresaContratate := NIL 
	::cRetornarCodigoContratoSequenciaResult := NIL 
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSContrato
Local oClone := WSContrato():New()
	oClone:_URL          := ::_URL 
	oClone:_CERT         := ::_CERT 
	oClone:_PRIVKEY      := ::_PRIVKEY 
	oClone:_PASSPHRASE   := ::_PASSPHRASE 
	oClone:oWSlstContrato :=  IIF(::oWSlstContrato = NIL , NIL ,::oWSlstContrato:Clone() )
	oClone:lbFlNaoUtilizaDePara := ::lbFlNaoUtilizaDePara
	oClone:oWSProcessarContratoResult :=  IIF(::oWSProcessarContratoResult = NIL , NIL ,::oWSProcessarContratoResult:Clone() )
	oClone:oWSRetornarContratoCotacaoResult :=  IIF(::oWSRetornarContratoCotacaoResult = NIL , NIL ,::oWSRetornarContratoCotacaoResult:Clone() )
	oClone:oWSRetornarContratoLeilaoResult :=  IIF(::oWSRetornarContratoLeilaoResult = NIL , NIL ,::oWSRetornarContratoLeilaoResult:Clone() )
	oClone:oWSRetornarContratoAtivoResult :=  IIF(::oWSRetornarContratoAtivoResult = NIL , NIL ,::oWSRetornarContratoAtivoResult:Clone() )
	oClone:oWSRetornarContratoRescindidoResult :=  IIF(::oWSRetornarContratoRescindidoResult = NIL , NIL ,::oWSRetornarContratoRescindidoResult:Clone() )
	oClone:oWSRetornarContratoPorTermoAditivoResult :=  IIF(::oWSRetornarContratoPorTermoAditivoResult = NIL , NIL ,::oWSRetornarContratoPorTermoAditivoResult:Clone() )
	oClone:oWSRetornarContratoEncerradoResult :=  IIF(::oWSRetornarContratoEncerradoResult = NIL , NIL ,::oWSRetornarContratoEncerradoResult:Clone() )
	oClone:csCdEmpresaContratante := ::csCdEmpresaContratante
	oClone:oWSRetornarContratoPorCompradorResult :=  IIF(::oWSRetornarContratoPorCompradorResult = NIL , NIL ,::oWSRetornarContratoPorCompradorResult:Clone() )
	oClone:csCdEmpresaFornecedor := ::csCdEmpresaFornecedor
	oClone:oWSRetornarContratoPorFornecedorResult :=  IIF(::oWSRetornarContratoPorFornecedorResult = NIL , NIL ,::oWSRetornarContratoPorFornecedorResult:Clone() )
	oClone:csCdProduto   := ::csCdProduto
	oClone:oWSRetornarContratoPorItemResult :=  IIF(::oWSRetornarContratoPorItemResult = NIL , NIL ,::oWSRetornarContratoPorItemResult:Clone() )
	oClone:oWSoContratoPesquisaDTO :=  IIF(::oWSoContratoPesquisaDTO = NIL , NIL ,::oWSoContratoPesquisaDTO:Clone() )
	oClone:oWSRetornarContratoPorCompradorItemResult :=  IIF(::oWSRetornarContratoPorCompradorItemResult = NIL , NIL ,::oWSRetornarContratoPorCompradorItemResult:Clone() )
	oClone:oWSRetornarContratoPorFornecedorItemResult :=  IIF(::oWSRetornarContratoPorFornecedorItemResult = NIL , NIL ,::oWSRetornarContratoPorFornecedorItemResult:Clone() )
	oClone:csCdEmpresaContratate := ::csCdEmpresaContratate
	oClone:cRetornarCodigoContratoSequenciaResult := ::cRetornarCodigoContratoSequenciaResult
Return oClone

// WSDL Method ProcessarContrato of Service WSContrato

WSMETHOD ProcessarContrato WSSEND oWSlstContrato,lbFlNaoUtilizaDePara WSRECEIVE oWSProcessarContratoResult WSCLIENT WSContrato
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ProcessarContrato xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("lstContrato", ::oWSlstContrato, oWSlstContrato , "ArrayOfContratoDTO", .F. , .F., 0 , "http://tempuri.org/", .F.,.F.) 
cSoap += WSSoapValue("bFlNaoUtilizaDePara", ::lbFlNaoUtilizaDePara, lbFlNaoUtilizaDePara , "boolean", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</ProcessarContrato>"

Self:_HEADOUT := { "Authorization: Bearer " + U_NewToken() }
oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tempuri.org/IContrato/ProcessarContrato",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://srm-hml.paradigmabs.com.br/cassi-hml/services/Contrato.svc")

::Init()
::oWSProcessarContratoResult:SoapRecv( WSAdvValue( oXmlRet,"_PROCESSARCONTRATORESPONSE:_PROCESSARCONTRATORESULT","RetornoDTO",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method RetornarContratoCotacao of Service WSContrato

WSMETHOD RetornarContratoCotacao WSSEND lbFlNaoUtilizaDePara WSRECEIVE oWSRetornarContratoCotacaoResult WSCLIENT WSContrato
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<RetornarContratoCotacao xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("bFlNaoUtilizaDePara", ::lbFlNaoUtilizaDePara, lbFlNaoUtilizaDePara , "boolean", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</RetornarContratoCotacao>"

Self:_HEADOUT := { "Authorization: Bearer " + U_NewToken() }
oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tempuri.org/IContrato/RetornarContratoCotacao",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://srm-hml.paradigmabs.com.br/cassi-hml/services/Contrato.svc")

::Init()
::oWSRetornarContratoCotacaoResult:SoapRecv( WSAdvValue( oXmlRet,"_RETORNARCONTRATOCOTACAORESPONSE:_RETORNARCONTRATOCOTACAORESULT","ArrayOfContratoDTO",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method RetornarContratoLeilao of Service WSContrato

WSMETHOD RetornarContratoLeilao WSSEND lbFlNaoUtilizaDePara WSRECEIVE oWSRetornarContratoLeilaoResult WSCLIENT WSContrato
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<RetornarContratoLeilao xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("bFlNaoUtilizaDePara", ::lbFlNaoUtilizaDePara, lbFlNaoUtilizaDePara , "boolean", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</RetornarContratoLeilao>"

Self:_HEADOUT := { "Authorization: Bearer " + U_NewToken() }
oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tempuri.org/IContrato/RetornarContratoLeilao",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://srm-hml.paradigmabs.com.br/cassi-hml/services/Contrato.svc")

::Init()
::oWSRetornarContratoLeilaoResult:SoapRecv( WSAdvValue( oXmlRet,"_RETORNARCONTRATOLEILAORESPONSE:_RETORNARCONTRATOLEILAORESULT","ArrayOfContratoDTO",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method RetornarContratoAtivo of Service WSContrato

WSMETHOD RetornarContratoAtivo WSSEND NULLPARAM WSRECEIVE oWSRetornarContratoAtivoResult WSCLIENT WSContrato
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<RetornarContratoAtivo xmlns="http://tempuri.org/">'
cSoap += "</RetornarContratoAtivo>"

Self:_HEADOUT := { "Authorization: Bearer " + U_NewToken() }
oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tempuri.org/IContrato/RetornarContratoAtivo",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://srm-hml.paradigmabs.com.br/cassi-hml/services/Contrato.svc")

::Init()
::oWSRetornarContratoAtivoResult:SoapRecv( WSAdvValue( oXmlRet,"_RETORNARCONTRATOATIVORESPONSE:_RETORNARCONTRATOATIVORESULT","ArrayOfContratoDTO",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method RetornarContratoRescindido of Service WSContrato

WSMETHOD RetornarContratoRescindido WSSEND NULLPARAM WSRECEIVE oWSRetornarContratoRescindidoResult WSCLIENT WSContrato
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<RetornarContratoRescindido xmlns="http://tempuri.org/">'
cSoap += "</RetornarContratoRescindido>"

Self:_HEADOUT := { "Authorization: Bearer " + U_NewToken() }
oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tempuri.org/IContrato/RetornarContratoRescindido",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://srm-hml.paradigmabs.com.br/cassi-hml/services/Contrato.svc")

::Init()
::oWSRetornarContratoRescindidoResult:SoapRecv( WSAdvValue( oXmlRet,"_RETORNARCONTRATORESCINDIDORESPONSE:_RETORNARCONTRATORESCINDIDORESULT","ArrayOfContratoDTO",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method RetornarContratoPorTermoAditivo of Service WSContrato

WSMETHOD RetornarContratoPorTermoAditivo WSSEND NULLPARAM WSRECEIVE oWSRetornarContratoPorTermoAditivoResult WSCLIENT WSContrato
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<RetornarContratoPorTermoAditivo xmlns="http://tempuri.org/">'
cSoap += "</RetornarContratoPorTermoAditivo>"

Self:_HEADOUT := { "Authorization: Bearer " + U_NewToken() }
oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tempuri.org/IContrato/RetornarContratoPorTermoAditivo",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://srm-hml.paradigmabs.com.br/cassi-hml/services/Contrato.svc")

::Init()
::oWSRetornarContratoPorTermoAditivoResult:SoapRecv( WSAdvValue( oXmlRet,"_RETORNARCONTRATOPORTERMOADITIVORESPONSE:_RETORNARCONTRATOPORTERMOADITIVORESULT","ArrayOfContratoDTO",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method RetornarContratoEncerrado of Service WSContrato

WSMETHOD RetornarContratoEncerrado WSSEND NULLPARAM WSRECEIVE oWSRetornarContratoEncerradoResult WSCLIENT WSContrato
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<RetornarContratoEncerrado xmlns="http://tempuri.org/">'
cSoap += "</RetornarContratoEncerrado>"

Self:_HEADOUT := { "Authorization: Bearer " + U_NewToken() }
oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tempuri.org/IContrato/RetornarContratoEncerrado",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://srm-hml.paradigmabs.com.br/cassi-hml/services/Contrato.svc")

::Init()
::oWSRetornarContratoEncerradoResult:SoapRecv( WSAdvValue( oXmlRet,"_RETORNARCONTRATOENCERRADORESPONSE:_RETORNARCONTRATOENCERRADORESULT","ArrayOfContratoDTO",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method RetornarContratoPorComprador of Service WSContrato

WSMETHOD RetornarContratoPorComprador WSSEND csCdEmpresaContratante WSRECEIVE oWSRetornarContratoPorCompradorResult WSCLIENT WSContrato
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<RetornarContratoPorComprador xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("sCdEmpresaContratante", ::csCdEmpresaContratante, csCdEmpresaContratante , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</RetornarContratoPorComprador>"

Self:_HEADOUT := { "Authorization: Bearer " + U_NewToken() }
oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tempuri.org/IContrato/RetornarContratoPorComprador",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://srm-hml.paradigmabs.com.br/cassi-hml/services/Contrato.svc")

::Init()
::oWSRetornarContratoPorCompradorResult:SoapRecv( WSAdvValue( oXmlRet,"_RETORNARCONTRATOPORCOMPRADORRESPONSE:_RETORNARCONTRATOPORCOMPRADORRESULT","ArrayOfContratoDTO",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method RetornarContratoPorFornecedor of Service WSContrato

WSMETHOD RetornarContratoPorFornecedor WSSEND csCdEmpresaFornecedor WSRECEIVE oWSRetornarContratoPorFornecedorResult WSCLIENT WSContrato
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<RetornarContratoPorFornecedor xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("sCdEmpresaFornecedor", ::csCdEmpresaFornecedor, csCdEmpresaFornecedor , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</RetornarContratoPorFornecedor>"

Self:_HEADOUT := { "Authorization: Bearer " + U_NewToken() }
oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tempuri.org/IContrato/RetornarContratoPorFornecedor",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://srm-hml.paradigmabs.com.br/cassi-hml/services/Contrato.svc")

::Init()
::oWSRetornarContratoPorFornecedorResult:SoapRecv( WSAdvValue( oXmlRet,"_RETORNARCONTRATOPORFORNECEDORRESPONSE:_RETORNARCONTRATOPORFORNECEDORRESULT","ArrayOfContratoDTO",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method RetornarContratoPorItem of Service WSContrato

WSMETHOD RetornarContratoPorItem WSSEND csCdProduto WSRECEIVE oWSRetornarContratoPorItemResult WSCLIENT WSContrato
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<RetornarContratoPorItem xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("sCdProduto", ::csCdProduto, csCdProduto , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</RetornarContratoPorItem>"

Self:_HEADOUT := { "Authorization: Bearer " + U_NewToken() }
oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tempuri.org/IContrato/RetornarContratoPorItem",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://srm-hml.paradigmabs.com.br/cassi-hml/services/Contrato.svc")

::Init()
::oWSRetornarContratoPorItemResult:SoapRecv( WSAdvValue( oXmlRet,"_RETORNARCONTRATOPORITEMRESPONSE:_RETORNARCONTRATOPORITEMRESULT","ArrayOfContratoDTO",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method RetornarContratoPorCompradorItem of Service WSContrato

WSMETHOD RetornarContratoPorCompradorItem WSSEND oWSoContratoPesquisaDTO WSRECEIVE oWSRetornarContratoPorCompradorItemResult WSCLIENT WSContrato
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<RetornarContratoPorCompradorItem xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("oContratoPesquisaDTO", ::oWSoContratoPesquisaDTO, oWSoContratoPesquisaDTO , "ContratoPesquisaDTO", .F. , .F., 0 , "http://tempuri.org/", .F.,.F.) 
cSoap += "</RetornarContratoPorCompradorItem>"

Self:_HEADOUT := { "Authorization: Bearer " + U_NewToken() }
oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tempuri.org/IContrato/RetornarContratoPorCompradorItem",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://srm-hml.paradigmabs.com.br/cassi-hml/services/Contrato.svc")

::Init()
::oWSRetornarContratoPorCompradorItemResult:SoapRecv( WSAdvValue( oXmlRet,"_RETORNARCONTRATOPORCOMPRADORITEMRESPONSE:_RETORNARCONTRATOPORCOMPRADORITEMRESULT","ArrayOfContratoDTO",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method RetornarContratoPorFornecedorItem of Service WSContrato

WSMETHOD RetornarContratoPorFornecedorItem WSSEND oWSoContratoPesquisaDTO WSRECEIVE oWSRetornarContratoPorFornecedorItemResult WSCLIENT WSContrato
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<RetornarContratoPorFornecedorItem xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("oContratoPesquisaDTO", ::oWSoContratoPesquisaDTO, oWSoContratoPesquisaDTO , "ContratoPesquisaDTO", .F. , .F., 0 , "http://tempuri.org/", .F.,.F.) 
cSoap += "</RetornarContratoPorFornecedorItem>"

Self:_HEADOUT := { "Authorization: Bearer " + U_NewToken() }
oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tempuri.org/IContrato/RetornarContratoPorFornecedorItem",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://srm-hml.paradigmabs.com.br/cassi-hml/services/Contrato.svc")

::Init()
::oWSRetornarContratoPorFornecedorItemResult:SoapRecv( WSAdvValue( oXmlRet,"_RETORNARCONTRATOPORFORNECEDORITEMRESPONSE:_RETORNARCONTRATOPORFORNECEDORITEMRESULT","ArrayOfContratoDTO",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method RetornarCodigoContratoSequencia of Service WSContrato

WSMETHOD RetornarCodigoContratoSequencia WSSEND csCdEmpresaContratate,lbFlNaoUtilizaDePara WSRECEIVE cRetornarCodigoContratoSequenciaResult WSCLIENT WSContrato
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<RetornarCodigoContratoSequencia xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("sCdEmpresaContratate", ::csCdEmpresaContratate, csCdEmpresaContratate , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("bFlNaoUtilizaDePara", ::lbFlNaoUtilizaDePara, lbFlNaoUtilizaDePara , "boolean", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</RetornarCodigoContratoSequencia>"

Self:_HEADOUT := { "Authorization: Bearer " + U_NewToken() }
oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tempuri.org/IContrato/RetornarCodigoContratoSequencia",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://srm-hml.paradigmabs.com.br/cassi-hml/services/Contrato.svc")

::Init()
::cRetornarCodigoContratoSequenciaResult :=  WSAdvValue( oXmlRet,"_RETORNARCODIGOCONTRATOSEQUENCIARESPONSE:_RETORNARCODIGOCONTRATOSEQUENCIARESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.


// WSDL Data Structure ArrayOfContratoDTO

WSSTRUCT Contrato_ArrayOfContratoDTO
	WSDATA   oWSContratoDTO            AS Contrato_ContratoDTO OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Contrato_ArrayOfContratoDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Contrato_ArrayOfContratoDTO
	::oWSContratoDTO       := {} // Array Of  Contrato_CONTRATODTO():New()
Return

WSMETHOD CLONE WSCLIENT Contrato_ArrayOfContratoDTO
	Local oClone := Contrato_ArrayOfContratoDTO():NEW()
	oClone:oWSContratoDTO := NIL
	If ::oWSContratoDTO <> NIL 
		oClone:oWSContratoDTO := {}
		aEval( ::oWSContratoDTO , { |x| aadd( oClone:oWSContratoDTO , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT Contrato_ArrayOfContratoDTO
	Local cSoap := ""
	aEval( ::oWSContratoDTO , {|x| cSoap := cSoap  +  WSSoapValue("ContratoDTO", x , x , "ContratoDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.)  } ) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Contrato_ArrayOfContratoDTO
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_CONTRATODTO","ContratoDTO",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSContratoDTO , Contrato_ContratoDTO():New() )
			::oWSContratoDTO[len(::oWSContratoDTO)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure RetornoDTO

WSSTRUCT Contrato_RetornoDTO
	WSDATA   oWSlstWbtLogDTO           AS Contrato_ArrayOfWbtLogDTO OPTIONAL
	WSDATA   nnIdRetorno               AS long OPTIONAL
	WSDATA   csNrToken                 AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Contrato_RetornoDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Contrato_RetornoDTO
Return

WSMETHOD CLONE WSCLIENT Contrato_RetornoDTO
	Local oClone := Contrato_RetornoDTO():NEW()
	oClone:oWSlstWbtLogDTO      := IIF(::oWSlstWbtLogDTO = NIL , NIL , ::oWSlstWbtLogDTO:Clone() )
	oClone:nnIdRetorno          := ::nnIdRetorno
	oClone:csNrToken            := ::csNrToken
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Contrato_RetornoDTO
	Local oNode1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_LSTWBTLOGDTO","ArrayOfWbtLogDTO",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode1 != NIL
		::oWSlstWbtLogDTO := Contrato_ArrayOfWbtLogDTO():New()
		::oWSlstWbtLogDTO:SoapRecv(oNode1)
	EndIf
	::nnIdRetorno        :=  WSAdvValue( oResponse,"_NIDRETORNO","long",NIL,NIL,NIL,"N",NIL,NIL) 
	::csNrToken          :=  WSAdvValue( oResponse,"_SNRTOKEN","string",NIL,NIL,NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure ContratoPesquisaDTO

WSSTRUCT Contrato_ContratoPesquisaDTO
	WSDATA   csCdEmpresa               AS string OPTIONAL
	WSDATA   csCdProduto               AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Contrato_ContratoPesquisaDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Contrato_ContratoPesquisaDTO
Return

WSMETHOD CLONE WSCLIENT Contrato_ContratoPesquisaDTO
	Local oClone := Contrato_ContratoPesquisaDTO():NEW()
	oClone:csCdEmpresa          := ::csCdEmpresa
	oClone:csCdProduto          := ::csCdProduto
Return oClone

WSMETHOD SOAPSEND WSCLIENT Contrato_ContratoPesquisaDTO
	Local cSoap := ""
	cSoap += WSSoapValue("sCdEmpresa", ::csCdEmpresa, ::csCdEmpresa , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdProduto", ::csCdProduto, ::csCdProduto , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
Return cSoap

// WSDL Data Structure ContratoDTO

WSSTRUCT Contrato_ContratoDTO
	WSDATA   nbFlPrazoIndeterminado    AS int OPTIONAL
	WSDATA   nbFlRenovacaoAuto         AS int OPTIONAL
	WSDATA   ndVlContrato              AS decimal OPTIONAL
	WSDATA   oWSlstContratoItemDTO     AS Contrato_ArrayOfContratoItemDTO OPTIONAL
	WSDATA   nnCdSituacao              AS long OPTIONAL
	WSDATA   nnCdTipo                  AS long OPTIONAL
	WSDATA   nnIdTipo                  AS int OPTIONAL
	WSDATA   nnIdTipoOrigem            AS int OPTIONAL
	WSDATA   nnNrDiasAvisoFim          AS long OPTIONAL
	WSDATA   nnNrDiasAvisoPedido       AS long OPTIONAL
	WSDATA   nnNrDiasAvisoRescisao     AS long OPTIONAL
	WSDATA   nnNrDuracao               AS long OPTIONAL
	WSDATA   csCdContrato              AS string OPTIONAL
	WSDATA   csCdContratoErp           AS string OPTIONAL
	WSDATA   csCdContratoErpPai        AS string OPTIONAL
	WSDATA   csCdContratoWbc           AS string OPTIONAL
	WSDATA   csCdDepartamento          AS string OPTIONAL
	WSDATA   csCdEmpresaContratada     AS string OPTIONAL
	WSDATA   csCdEmpresaContratante    AS string OPTIONAL
	WSDATA   csCdMoeda                 AS string OPTIONAL
	WSDATA   csCdNegociacaoWbc         AS string OPTIONAL
	WSDATA   csCdProjeto               AS string OPTIONAL
	WSDATA   csCdTransportadora        AS string OPTIONAL
	WSDATA   csCdUsuario               AS string OPTIONAL
	WSDATA   csCdUsuarioCriador        AS string OPTIONAL
	WSDATA   csCdUsuarioGestor         AS string OPTIONAL
	WSDATA   csDsAuditoria             AS string OPTIONAL
	WSDATA   csDsContrato              AS string OPTIONAL
	WSDATA   csDsObjeto                AS string OPTIONAL
	WSDATA   ctDtAssinatuta            AS dateTime OPTIONAL
	WSDATA   ctDtCadastro              AS dateTime OPTIONAL
	WSDATA   ctDtFinal                 AS dateTime OPTIONAL
	WSDATA   ctDtInicial               AS dateTime OPTIONAL
	WSDATA   ctDtReajuste              AS dateTime OPTIONAL
	WSDATA   ctDtRescisao              AS dateTime OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Contrato_ContratoDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Contrato_ContratoDTO
Return

WSMETHOD CLONE WSCLIENT Contrato_ContratoDTO
	Local oClone := Contrato_ContratoDTO():NEW()
	oClone:nbFlPrazoIndeterminado := ::nbFlPrazoIndeterminado
	oClone:nbFlRenovacaoAuto    := ::nbFlRenovacaoAuto
	oClone:ndVlContrato         := ::ndVlContrato
	oClone:oWSlstContratoItemDTO := IIF(::oWSlstContratoItemDTO = NIL , NIL , ::oWSlstContratoItemDTO:Clone() )
	oClone:nnCdSituacao         := ::nnCdSituacao
	oClone:nnCdTipo             := ::nnCdTipo
	oClone:nnIdTipo             := ::nnIdTipo
	oClone:nnIdTipoOrigem       := ::nnIdTipoOrigem
	oClone:nnNrDiasAvisoFim     := ::nnNrDiasAvisoFim
	oClone:nnNrDiasAvisoPedido  := ::nnNrDiasAvisoPedido
	oClone:nnNrDiasAvisoRescisao := ::nnNrDiasAvisoRescisao
	oClone:nnNrDuracao          := ::nnNrDuracao
	oClone:csCdContrato         := ::csCdContrato
	oClone:csCdContratoErp      := ::csCdContratoErp
	oClone:csCdContratoErpPai   := ::csCdContratoErpPai
	oClone:csCdContratoWbc      := ::csCdContratoWbc
	oClone:csCdDepartamento     := ::csCdDepartamento
	oClone:csCdEmpresaContratada := ::csCdEmpresaContratada
	oClone:csCdEmpresaContratante := ::csCdEmpresaContratante
	oClone:csCdMoeda            := ::csCdMoeda
	oClone:csCdNegociacaoWbc    := ::csCdNegociacaoWbc
	oClone:csCdProjeto          := ::csCdProjeto
	oClone:csCdTransportadora   := ::csCdTransportadora
	oClone:csCdUsuario          := ::csCdUsuario
	oClone:csCdUsuarioCriador   := ::csCdUsuarioCriador
	oClone:csCdUsuarioGestor    := ::csCdUsuarioGestor
	oClone:csDsAuditoria        := ::csDsAuditoria
	oClone:csDsContrato         := ::csDsContrato
	oClone:csDsObjeto           := ::csDsObjeto
	oClone:ctDtAssinatuta       := ::ctDtAssinatuta
	oClone:ctDtCadastro         := ::ctDtCadastro
	oClone:ctDtFinal            := ::ctDtFinal
	oClone:ctDtInicial          := ::ctDtInicial
	oClone:ctDtReajuste         := ::ctDtReajuste
	oClone:ctDtRescisao         := ::ctDtRescisao
Return oClone

WSMETHOD SOAPSEND WSCLIENT Contrato_ContratoDTO
	Local cSoap := ""
	cSoap += WSSoapValue("bFlPrazoIndeterminado", ::nbFlPrazoIndeterminado, ::nbFlPrazoIndeterminado , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("bFlRenovacaoAuto", ::nbFlRenovacaoAuto, ::nbFlRenovacaoAuto , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("dVlContrato", ::ndVlContrato, ::ndVlContrato , "decimal", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("lstContratoItemDTO", ::oWSlstContratoItemDTO, ::oWSlstContratoItemDTO , "ArrayOfContratoItemDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("nCdSituacao", ::nnCdSituacao, ::nnCdSituacao , "long", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("nCdTipo", ::nnCdTipo, ::nnCdTipo , "long", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("nIdTipo", ::nnIdTipo, ::nnIdTipo , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("nIdTipoOrigem", ::nnIdTipoOrigem, ::nnIdTipoOrigem , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("nNrDiasAvisoFim", ::nnNrDiasAvisoFim, ::nnNrDiasAvisoFim , "long", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("nNrDiasAvisoPedido", ::nnNrDiasAvisoPedido, ::nnNrDiasAvisoPedido , "long", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("nNrDiasAvisoRescisao", ::nnNrDiasAvisoRescisao, ::nnNrDiasAvisoRescisao , "long", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("nNrDuracao", ::nnNrDuracao, ::nnNrDuracao , "long", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdContrato", ::csCdContrato, ::csCdContrato , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdContratoErp", ::csCdContratoErp, ::csCdContratoErp , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdContratoErpPai", ::csCdContratoErpPai, ::csCdContratoErpPai , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdContratoWbc", ::csCdContratoWbc, ::csCdContratoWbc , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdDepartamento", ::csCdDepartamento, ::csCdDepartamento , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdEmpresaContratada", ::csCdEmpresaContratada, ::csCdEmpresaContratada , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdEmpresaContratante", ::csCdEmpresaContratante, ::csCdEmpresaContratante , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdMoeda", ::csCdMoeda, ::csCdMoeda , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdNegociacaoWbc", ::csCdNegociacaoWbc, ::csCdNegociacaoWbc , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdProjeto", ::csCdProjeto, ::csCdProjeto , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdTransportadora", ::csCdTransportadora, ::csCdTransportadora , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdUsuario", ::csCdUsuario, ::csCdUsuario , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdUsuarioCriador", ::csCdUsuarioCriador, ::csCdUsuarioCriador , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdUsuarioGestor", ::csCdUsuarioGestor, ::csCdUsuarioGestor , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sDsAuditoria", ::csDsAuditoria, ::csDsAuditoria , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sDsContrato", ::csDsContrato, ::csDsContrato , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sDsObjeto", ::csDsObjeto, ::csDsObjeto , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("tDtAssinatuta", ::ctDtAssinatuta, ::ctDtAssinatuta , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("tDtCadastro", ::ctDtCadastro, ::ctDtCadastro , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("tDtFinal", ::ctDtFinal, ::ctDtFinal , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("tDtInicial", ::ctDtInicial, ::ctDtInicial , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("tDtReajuste", ::ctDtReajuste, ::ctDtReajuste , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("tDtRescisao", ::ctDtRescisao, ::ctDtRescisao , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Contrato_ContratoDTO
	Local oNode4
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::nbFlPrazoIndeterminado :=  WSAdvValue( oResponse,"_BFLPRAZOINDETERMINADO","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::nbFlRenovacaoAuto  :=  WSAdvValue( oResponse,"_BFLRENOVACAOAUTO","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::ndVlContrato       :=  WSAdvValue( oResponse,"_DVLCONTRATO","decimal",NIL,NIL,NIL,"N",NIL,NIL) 
	oNode4 :=  WSAdvValue( oResponse,"_LSTCONTRATOITEMDTO","ArrayOfContratoItemDTO",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode4 != NIL
		::oWSlstContratoItemDTO := Contrato_ArrayOfContratoItemDTO():New()
		::oWSlstContratoItemDTO:SoapRecv(oNode4)
	EndIf
	::nnCdSituacao       :=  WSAdvValue( oResponse,"_NCDSITUACAO","long",NIL,NIL,NIL,"N",NIL,NIL) 
	::nnCdTipo           :=  WSAdvValue( oResponse,"_NCDTIPO","long",NIL,NIL,NIL,"N",NIL,NIL) 
	::nnIdTipo           :=  WSAdvValue( oResponse,"_NIDTIPO","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::nnIdTipoOrigem     :=  WSAdvValue( oResponse,"_NIDTIPOORIGEM","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::nnNrDiasAvisoFim   :=  WSAdvValue( oResponse,"_NNRDIASAVISOFIM","long",NIL,NIL,NIL,"N",NIL,NIL) 
	::nnNrDiasAvisoPedido :=  WSAdvValue( oResponse,"_NNRDIASAVISOPEDIDO","long",NIL,NIL,NIL,"N",NIL,NIL) 
	::nnNrDiasAvisoRescisao :=  WSAdvValue( oResponse,"_NNRDIASAVISORESCISAO","long",NIL,NIL,NIL,"N",NIL,NIL) 
	::nnNrDuracao        :=  WSAdvValue( oResponse,"_NNRDURACAO","long",NIL,NIL,NIL,"N",NIL,NIL) 
	::csCdContrato       :=  WSAdvValue( oResponse,"_SCDCONTRATO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdContratoErp    :=  WSAdvValue( oResponse,"_SCDCONTRATOERP","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdContratoErpPai :=  WSAdvValue( oResponse,"_SCDCONTRATOERPPAI","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdContratoWbc    :=  WSAdvValue( oResponse,"_SCDCONTRATOWBC","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdDepartamento   :=  WSAdvValue( oResponse,"_SCDDEPARTAMENTO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdEmpresaContratada :=  WSAdvValue( oResponse,"_SCDEMPRESACONTRATADA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdEmpresaContratante :=  WSAdvValue( oResponse,"_SCDEMPRESACONTRATANTE","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdMoeda          :=  WSAdvValue( oResponse,"_SCDMOEDA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdNegociacaoWbc  :=  WSAdvValue( oResponse,"_SCDNEGOCIACAOWBC","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdProjeto        :=  WSAdvValue( oResponse,"_SCDPROJETO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdTransportadora :=  WSAdvValue( oResponse,"_SCDTRANSPORTADORA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdUsuario        :=  WSAdvValue( oResponse,"_SCDUSUARIO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdUsuarioCriador :=  WSAdvValue( oResponse,"_SCDUSUARIOCRIADOR","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdUsuarioGestor  :=  WSAdvValue( oResponse,"_SCDUSUARIOGESTOR","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csDsAuditoria      :=  WSAdvValue( oResponse,"_SDSAUDITORIA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csDsContrato       :=  WSAdvValue( oResponse,"_SDSCONTRATO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csDsObjeto         :=  WSAdvValue( oResponse,"_SDSOBJETO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::ctDtAssinatuta     :=  WSAdvValue( oResponse,"_TDTASSINATUTA","dateTime",NIL,NIL,NIL,"S",NIL,NIL) 
	::ctDtCadastro       :=  WSAdvValue( oResponse,"_TDTCADASTRO","dateTime",NIL,NIL,NIL,"S",NIL,NIL) 
	::ctDtFinal          :=  WSAdvValue( oResponse,"_TDTFINAL","dateTime",NIL,NIL,NIL,"S",NIL,NIL) 
	::ctDtInicial        :=  WSAdvValue( oResponse,"_TDTINICIAL","dateTime",NIL,NIL,NIL,"S",NIL,NIL) 
	::ctDtReajuste       :=  WSAdvValue( oResponse,"_TDTREAJUSTE","dateTime",NIL,NIL,NIL,"S",NIL,NIL) 
	::ctDtRescisao       :=  WSAdvValue( oResponse,"_TDTRESCISAO","dateTime",NIL,NIL,NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure ArrayOfWbtLogDTO

WSSTRUCT Contrato_ArrayOfWbtLogDTO
	WSDATA   oWSWbtLogDTO              AS Contrato_WbtLogDTO OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Contrato_ArrayOfWbtLogDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Contrato_ArrayOfWbtLogDTO
	::oWSWbtLogDTO         := {} // Array Of  Contrato_WBTLOGDTO():New()
Return

WSMETHOD CLONE WSCLIENT Contrato_ArrayOfWbtLogDTO
	Local oClone := Contrato_ArrayOfWbtLogDTO():NEW()
	oClone:oWSWbtLogDTO := NIL
	If ::oWSWbtLogDTO <> NIL 
		oClone:oWSWbtLogDTO := {}
		aEval( ::oWSWbtLogDTO , { |x| aadd( oClone:oWSWbtLogDTO , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Contrato_ArrayOfWbtLogDTO
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_WBTLOGDTO","WbtLogDTO",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSWbtLogDTO , Contrato_WbtLogDTO():New() )
			::oWSWbtLogDTO[len(::oWSWbtLogDTO)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure ArrayOfContratoItemDTO

WSSTRUCT Contrato_ArrayOfContratoItemDTO
	WSDATA   oWSContratoItemDTO        AS Contrato_ContratoItemDTO OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Contrato_ArrayOfContratoItemDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Contrato_ArrayOfContratoItemDTO
	::oWSContratoItemDTO   := {} // Array Of  Contrato_CONTRATOITEMDTO():New()
Return

WSMETHOD CLONE WSCLIENT Contrato_ArrayOfContratoItemDTO
	Local oClone := Contrato_ArrayOfContratoItemDTO():NEW()
	oClone:oWSContratoItemDTO := NIL
	If ::oWSContratoItemDTO <> NIL 
		oClone:oWSContratoItemDTO := {}
		aEval( ::oWSContratoItemDTO , { |x| aadd( oClone:oWSContratoItemDTO , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT Contrato_ArrayOfContratoItemDTO
	Local cSoap := ""
	aEval( ::oWSContratoItemDTO , {|x| cSoap := cSoap  +  WSSoapValue("ContratoItemDTO", x , x , "ContratoItemDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.)  } ) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Contrato_ArrayOfContratoItemDTO
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_CONTRATOITEMDTO","ContratoItemDTO",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSContratoItemDTO , Contrato_ContratoItemDTO():New() )
			::oWSContratoItemDTO[len(::oWSContratoItemDTO)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure WbtLogDTO

WSSTRUCT Contrato_WbtLogDTO
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

WSMETHOD NEW WSCLIENT Contrato_WbtLogDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Contrato_WbtLogDTO
Return

WSMETHOD CLONE WSCLIENT Contrato_WbtLogDTO
	Local oClone := Contrato_WbtLogDTO():NEW()
	oClone:nnCdLog              := ::nnCdLog
	oClone:nnIdRetorno          := ::nnIdRetorno
	oClone:csCdOrigem           := ::csCdOrigem
	oClone:csDsLog              := ::csDsLog
	oClone:csDsTipoDocumento    := ::csDsTipoDocumento
	oClone:csNrToken            := ::csNrToken
	oClone:ctDtLog              := ::ctDtLog
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Contrato_WbtLogDTO
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

// WSDL Data Structure ContratoItemDTO

WSSTRUCT Contrato_ContratoItemDTO
	WSDATA   ndQtItemPrevisto          AS decimal OPTIONAL
	WSDATA   ndQtItemRealizado         AS decimal OPTIONAL
	WSDATA   ndQtLoteMinimo            AS decimal OPTIONAL
	WSDATA   ndQtLoteMultiplo          AS decimal OPTIONAL
	WSDATA   ndVlItem                  AS decimal OPTIONAL
	WSDATA   oWSlstContratoItemEnderecoDTO AS Contrato_ArrayOfContratoItemEnderecoDTO OPTIONAL
	WSDATA   nnCdSituacaoItem          AS long OPTIONAL
	WSDATA   csCdClasse                AS string OPTIONAL
	WSDATA   csCdCondicaoPagamento     AS string OPTIONAL
	WSDATA   csCdFrete                 AS string OPTIONAL
	WSDATA   csCdGarantia              AS string OPTIONAL
	WSDATA   csCdItemErp               AS string OPTIONAL
	WSDATA   csCdItemPaiErp            AS string OPTIONAL
	WSDATA   csCdItemWbc               AS string OPTIONAL
	WSDATA   csCdIva                   AS string OPTIONAL
	WSDATA   csCdMarca                 AS string OPTIONAL
	WSDATA   csCdNegociacaoItemWbc     AS string OPTIONAL
	WSDATA   csCdProduto               AS string OPTIONAL
	WSDATA   csCdProjeto               AS string OPTIONAL
	WSDATA   csCdUnidadeMedida         AS string OPTIONAL
	WSDATA   csDsObservacoes           AS string OPTIONAL
	WSDATA   csDsProdutoContrato       AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Contrato_ContratoItemDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Contrato_ContratoItemDTO
Return

WSMETHOD CLONE WSCLIENT Contrato_ContratoItemDTO
	Local oClone := Contrato_ContratoItemDTO():NEW()
	oClone:ndQtItemPrevisto     := ::ndQtItemPrevisto
	oClone:ndQtItemRealizado    := ::ndQtItemRealizado
	oClone:ndQtLoteMinimo       := ::ndQtLoteMinimo
	oClone:ndQtLoteMultiplo     := ::ndQtLoteMultiplo
	oClone:ndVlItem             := ::ndVlItem
	oClone:oWSlstContratoItemEnderecoDTO := IIF(::oWSlstContratoItemEnderecoDTO = NIL , NIL , ::oWSlstContratoItemEnderecoDTO:Clone() )
	oClone:nnCdSituacaoItem     := ::nnCdSituacaoItem
	oClone:csCdClasse           := ::csCdClasse
	oClone:csCdCondicaoPagamento := ::csCdCondicaoPagamento
	oClone:csCdFrete            := ::csCdFrete
	oClone:csCdGarantia         := ::csCdGarantia
	oClone:csCdItemErp          := ::csCdItemErp
	oClone:csCdItemPaiErp       := ::csCdItemPaiErp
	oClone:csCdItemWbc          := ::csCdItemWbc
	oClone:csCdIva              := ::csCdIva
	oClone:csCdMarca            := ::csCdMarca
	oClone:csCdNegociacaoItemWbc := ::csCdNegociacaoItemWbc
	oClone:csCdProduto          := ::csCdProduto
	oClone:csCdProjeto          := ::csCdProjeto
	oClone:csCdUnidadeMedida    := ::csCdUnidadeMedida
	oClone:csDsObservacoes      := ::csDsObservacoes
	oClone:csDsProdutoContrato  := ::csDsProdutoContrato
Return oClone

WSMETHOD SOAPSEND WSCLIENT Contrato_ContratoItemDTO
	Local cSoap := ""
	cSoap += WSSoapValue("dQtItemPrevisto", ::ndQtItemPrevisto, ::ndQtItemPrevisto , "decimal", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("dQtItemRealizado", ::ndQtItemRealizado, ::ndQtItemRealizado , "decimal", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("dQtLoteMinimo", ::ndQtLoteMinimo, ::ndQtLoteMinimo , "decimal", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("dQtLoteMultiplo", ::ndQtLoteMultiplo, ::ndQtLoteMultiplo , "decimal", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("dVlItem", ::ndVlItem, ::ndVlItem , "decimal", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("lstContratoItemEnderecoDTO", ::oWSlstContratoItemEnderecoDTO, ::oWSlstContratoItemEnderecoDTO , "ArrayOfContratoItemEnderecoDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("nCdSituacaoItem", ::nnCdSituacaoItem, ::nnCdSituacaoItem , "long", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdClasse", ::csCdClasse, ::csCdClasse , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdCondicaoPagamento", ::csCdCondicaoPagamento, ::csCdCondicaoPagamento , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdFrete", ::csCdFrete, ::csCdFrete , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdGarantia", ::csCdGarantia, ::csCdGarantia , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdItemErp", ::csCdItemErp, ::csCdItemErp , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdItemPaiErp", ::csCdItemPaiErp, ::csCdItemPaiErp , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdItemWbc", ::csCdItemWbc, ::csCdItemWbc , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdIva", ::csCdIva, ::csCdIva , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdMarca", ::csCdMarca, ::csCdMarca , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdNegociacaoItemWbc", ::csCdNegociacaoItemWbc, ::csCdNegociacaoItemWbc , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdProduto", ::csCdProduto, ::csCdProduto , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdProjeto", ::csCdProjeto, ::csCdProjeto , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdUnidadeMedida", ::csCdUnidadeMedida, ::csCdUnidadeMedida , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sDsObservacoes", ::csDsObservacoes, ::csDsObservacoes , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sDsProdutoContrato", ::csDsProdutoContrato, ::csDsProdutoContrato , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Contrato_ContratoItemDTO
	Local oNode6
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::ndQtItemPrevisto   :=  WSAdvValue( oResponse,"_DQTITEMPREVISTO","decimal",NIL,NIL,NIL,"N",NIL,NIL) 
	::ndQtItemRealizado  :=  WSAdvValue( oResponse,"_DQTITEMREALIZADO","decimal",NIL,NIL,NIL,"N",NIL,NIL) 
	::ndQtLoteMinimo     :=  WSAdvValue( oResponse,"_DQTLOTEMINIMO","decimal",NIL,NIL,NIL,"N",NIL,NIL) 
	::ndQtLoteMultiplo   :=  WSAdvValue( oResponse,"_DQTLOTEMULTIPLO","decimal",NIL,NIL,NIL,"N",NIL,NIL) 
	::ndVlItem           :=  WSAdvValue( oResponse,"_DVLITEM","decimal",NIL,NIL,NIL,"N",NIL,NIL) 
	oNode6 :=  WSAdvValue( oResponse,"_LSTCONTRATOITEMENDERECODTO","ArrayOfContratoItemEnderecoDTO",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode6 != NIL
		::oWSlstContratoItemEnderecoDTO := Contrato_ArrayOfContratoItemEnderecoDTO():New()
		::oWSlstContratoItemEnderecoDTO:SoapRecv(oNode6)
	EndIf
	::nnCdSituacaoItem   :=  WSAdvValue( oResponse,"_NCDSITUACAOITEM","long",NIL,NIL,NIL,"N",NIL,NIL) 
	::csCdClasse         :=  WSAdvValue( oResponse,"_SCDCLASSE","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdCondicaoPagamento :=  WSAdvValue( oResponse,"_SCDCONDICAOPAGAMENTO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdFrete          :=  WSAdvValue( oResponse,"_SCDFRETE","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdGarantia       :=  WSAdvValue( oResponse,"_SCDGARANTIA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdItemErp        :=  WSAdvValue( oResponse,"_SCDITEMERP","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdItemPaiErp     :=  WSAdvValue( oResponse,"_SCDITEMPAIERP","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdItemWbc        :=  WSAdvValue( oResponse,"_SCDITEMWBC","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdIva            :=  WSAdvValue( oResponse,"_SCDIVA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdMarca          :=  WSAdvValue( oResponse,"_SCDMARCA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdNegociacaoItemWbc :=  WSAdvValue( oResponse,"_SCDNEGOCIACAOITEMWBC","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdProduto        :=  WSAdvValue( oResponse,"_SCDPRODUTO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdProjeto        :=  WSAdvValue( oResponse,"_SCDPROJETO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdUnidadeMedida  :=  WSAdvValue( oResponse,"_SCDUNIDADEMEDIDA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csDsObservacoes    :=  WSAdvValue( oResponse,"_SDSOBSERVACOES","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csDsProdutoContrato :=  WSAdvValue( oResponse,"_SDSPRODUTOCONTRATO","string",NIL,NIL,NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure ArrayOfContratoItemEnderecoDTO

WSSTRUCT Contrato_ArrayOfContratoItemEnderecoDTO
	WSDATA   oWSContratoItemEnderecoDTO AS Contrato_ContratoItemEnderecoDTO OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Contrato_ArrayOfContratoItemEnderecoDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Contrato_ArrayOfContratoItemEnderecoDTO
	::oWSContratoItemEnderecoDTO := {} // Array Of  Contrato_CONTRATOITEMENDERECODTO():New()
Return

WSMETHOD CLONE WSCLIENT Contrato_ArrayOfContratoItemEnderecoDTO
	Local oClone := Contrato_ArrayOfContratoItemEnderecoDTO():NEW()
	oClone:oWSContratoItemEnderecoDTO := NIL
	If ::oWSContratoItemEnderecoDTO <> NIL 
		oClone:oWSContratoItemEnderecoDTO := {}
		aEval( ::oWSContratoItemEnderecoDTO , { |x| aadd( oClone:oWSContratoItemEnderecoDTO , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT Contrato_ArrayOfContratoItemEnderecoDTO
	Local cSoap := ""
	aEval( ::oWSContratoItemEnderecoDTO , {|x| cSoap := cSoap  +  WSSoapValue("ContratoItemEnderecoDTO", x , x , "ContratoItemEnderecoDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.)  } ) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Contrato_ArrayOfContratoItemEnderecoDTO
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_CONTRATOITEMENDERECODTO","ContratoItemEnderecoDTO",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSContratoItemEnderecoDTO , Contrato_ContratoItemEnderecoDTO():New() )
			::oWSContratoItemEnderecoDTO[len(::oWSContratoItemEnderecoDTO)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure ContratoItemEnderecoDTO

WSSTRUCT Contrato_ContratoItemEnderecoDTO
	WSDATA   ndQtItemPrevista          AS decimal OPTIONAL
	WSDATA   ndQtItemRealizado         AS decimal OPTIONAL
	WSDATA   ndVlAliquota              AS decimal OPTIONAL
	WSDATA   oWSlstContratoItemEnderecoTaxaDTO AS Contrato_ArrayOfContratoItemTaxaDTO OPTIONAL
	WSDATA   nnIdSuperSimples          AS int OPTIONAL
	WSDATA   csCdCobrancaEndereco      AS string OPTIONAL
	WSDATA   csCdEmpresaCobrancaEndereco AS string OPTIONAL
	WSDATA   csCdEmpresaEntregaEndereco AS string OPTIONAL
	WSDATA   csCdEmpresaFaturamentoEndereco AS string OPTIONAL
	WSDATA   csCdEntregaEndereco       AS string OPTIONAL
	WSDATA   csCdFaturamentoEndereco   AS string OPTIONAL
	WSDATA   csCdItemEnderecoWbc       AS string OPTIONAL
	WSDATA   ctDtEntregaPrevista       AS dateTime OPTIONAL
	WSDATA   ctDtEntregaRealizado      AS dateTime OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Contrato_ContratoItemEnderecoDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Contrato_ContratoItemEnderecoDTO
Return

WSMETHOD CLONE WSCLIENT Contrato_ContratoItemEnderecoDTO
	Local oClone := Contrato_ContratoItemEnderecoDTO():NEW()
	oClone:ndQtItemPrevista     := ::ndQtItemPrevista
	oClone:ndQtItemRealizado    := ::ndQtItemRealizado
	oClone:ndVlAliquota         := ::ndVlAliquota
	oClone:oWSlstContratoItemEnderecoTaxaDTO := IIF(::oWSlstContratoItemEnderecoTaxaDTO = NIL , NIL , ::oWSlstContratoItemEnderecoTaxaDTO:Clone() )
	oClone:nnIdSuperSimples     := ::nnIdSuperSimples
	oClone:csCdCobrancaEndereco := ::csCdCobrancaEndereco
	oClone:csCdEmpresaCobrancaEndereco := ::csCdEmpresaCobrancaEndereco
	oClone:csCdEmpresaEntregaEndereco := ::csCdEmpresaEntregaEndereco
	oClone:csCdEmpresaFaturamentoEndereco := ::csCdEmpresaFaturamentoEndereco
	oClone:csCdEntregaEndereco  := ::csCdEntregaEndereco
	oClone:csCdFaturamentoEndereco := ::csCdFaturamentoEndereco
	oClone:csCdItemEnderecoWbc  := ::csCdItemEnderecoWbc
	oClone:ctDtEntregaPrevista  := ::ctDtEntregaPrevista
	oClone:ctDtEntregaRealizado := ::ctDtEntregaRealizado
Return oClone

WSMETHOD SOAPSEND WSCLIENT Contrato_ContratoItemEnderecoDTO
	Local cSoap := ""
	cSoap += WSSoapValue("dQtItemPrevista", ::ndQtItemPrevista, ::ndQtItemPrevista , "decimal", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("dQtItemRealizado", ::ndQtItemRealizado, ::ndQtItemRealizado , "decimal", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("dVlAliquota", ::ndVlAliquota, ::ndVlAliquota , "decimal", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("lstContratoItemEnderecoTaxaDTO", ::oWSlstContratoItemEnderecoTaxaDTO, ::oWSlstContratoItemEnderecoTaxaDTO , "ArrayOfContratoItemTaxaDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("nIdSuperSimples", ::nnIdSuperSimples, ::nnIdSuperSimples , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdCobrancaEndereco", ::csCdCobrancaEndereco, ::csCdCobrancaEndereco , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdEmpresaCobrancaEndereco", ::csCdEmpresaCobrancaEndereco, ::csCdEmpresaCobrancaEndereco , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdEmpresaEntregaEndereco", ::csCdEmpresaEntregaEndereco, ::csCdEmpresaEntregaEndereco , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdEmpresaFaturamentoEndereco", ::csCdEmpresaFaturamentoEndereco, ::csCdEmpresaFaturamentoEndereco , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdEntregaEndereco", ::csCdEntregaEndereco, ::csCdEntregaEndereco , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdFaturamentoEndereco", ::csCdFaturamentoEndereco, ::csCdFaturamentoEndereco , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdItemEnderecoWbc", ::csCdItemEnderecoWbc, ::csCdItemEnderecoWbc , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("tDtEntregaPrevista", ::ctDtEntregaPrevista, ::ctDtEntregaPrevista , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("tDtEntregaRealizado", ::ctDtEntregaRealizado, ::ctDtEntregaRealizado , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Contrato_ContratoItemEnderecoDTO
	Local oNode4
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::ndQtItemPrevista   :=  WSAdvValue( oResponse,"_DQTITEMPREVISTA","decimal",NIL,NIL,NIL,"N",NIL,NIL) 
	::ndQtItemRealizado  :=  WSAdvValue( oResponse,"_DQTITEMREALIZADO","decimal",NIL,NIL,NIL,"N",NIL,NIL) 
	::ndVlAliquota       :=  WSAdvValue( oResponse,"_DVLALIQUOTA","decimal",NIL,NIL,NIL,"N",NIL,NIL) 
	oNode4 :=  WSAdvValue( oResponse,"_LSTCONTRATOITEMENDERECOTAXADTO","ArrayOfContratoItemTaxaDTO",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode4 != NIL
		::oWSlstContratoItemEnderecoTaxaDTO := Contrato_ArrayOfContratoItemTaxaDTO():New()
		::oWSlstContratoItemEnderecoTaxaDTO:SoapRecv(oNode4)
	EndIf
	::nnIdSuperSimples   :=  WSAdvValue( oResponse,"_NIDSUPERSIMPLES","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::csCdCobrancaEndereco :=  WSAdvValue( oResponse,"_SCDCOBRANCAENDERECO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdEmpresaCobrancaEndereco :=  WSAdvValue( oResponse,"_SCDEMPRESACOBRANCAENDERECO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdEmpresaEntregaEndereco :=  WSAdvValue( oResponse,"_SCDEMPRESAENTREGAENDERECO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdEmpresaFaturamentoEndereco :=  WSAdvValue( oResponse,"_SCDEMPRESAFATURAMENTOENDERECO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdEntregaEndereco :=  WSAdvValue( oResponse,"_SCDENTREGAENDERECO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdFaturamentoEndereco :=  WSAdvValue( oResponse,"_SCDFATURAMENTOENDERECO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdItemEnderecoWbc :=  WSAdvValue( oResponse,"_SCDITEMENDERECOWBC","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::ctDtEntregaPrevista :=  WSAdvValue( oResponse,"_TDTENTREGAPREVISTA","dateTime",NIL,NIL,NIL,"S",NIL,NIL) 
	::ctDtEntregaRealizado :=  WSAdvValue( oResponse,"_TDTENTREGAREALIZADO","dateTime",NIL,NIL,NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure ArrayOfContratoItemTaxaDTO

WSSTRUCT Contrato_ArrayOfContratoItemTaxaDTO
	WSDATA   oWSContratoItemTaxaDTO    AS Contrato_ContratoItemTaxaDTO OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Contrato_ArrayOfContratoItemTaxaDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Contrato_ArrayOfContratoItemTaxaDTO
	::oWSContratoItemTaxaDTO := {} // Array Of  Contrato_CONTRATOITEMTAXADTO():New()
Return

WSMETHOD CLONE WSCLIENT Contrato_ArrayOfContratoItemTaxaDTO
	Local oClone := Contrato_ArrayOfContratoItemTaxaDTO():NEW()
	oClone:oWSContratoItemTaxaDTO := NIL
	If ::oWSContratoItemTaxaDTO <> NIL 
		oClone:oWSContratoItemTaxaDTO := {}
		aEval( ::oWSContratoItemTaxaDTO , { |x| aadd( oClone:oWSContratoItemTaxaDTO , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT Contrato_ArrayOfContratoItemTaxaDTO
	Local cSoap := ""
	aEval( ::oWSContratoItemTaxaDTO , {|x| cSoap := cSoap  +  WSSoapValue("ContratoItemTaxaDTO", x , x , "ContratoItemTaxaDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.)  } ) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Contrato_ArrayOfContratoItemTaxaDTO
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_CONTRATOITEMTAXADTO","ContratoItemTaxaDTO",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSContratoItemTaxaDTO , Contrato_ContratoItemTaxaDTO():New() )
			::oWSContratoItemTaxaDTO[len(::oWSContratoItemTaxaDTO)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure ContratoItemTaxaDTO

WSSTRUCT Contrato_ContratoItemTaxaDTO
	WSDATA   nbFlIncluso               AS int OPTIONAL
	WSDATA   ndPcTaxa                  AS decimal OPTIONAL
	WSDATA   nnCdTaxa                  AS long OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Contrato_ContratoItemTaxaDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Contrato_ContratoItemTaxaDTO
Return

WSMETHOD CLONE WSCLIENT Contrato_ContratoItemTaxaDTO
	Local oClone := Contrato_ContratoItemTaxaDTO():NEW()
	oClone:nbFlIncluso          := ::nbFlIncluso
	oClone:ndPcTaxa             := ::ndPcTaxa
	oClone:nnCdTaxa             := ::nnCdTaxa
Return oClone

WSMETHOD SOAPSEND WSCLIENT Contrato_ContratoItemTaxaDTO
	Local cSoap := ""
	cSoap += WSSoapValue("bFlIncluso", ::nbFlIncluso, ::nbFlIncluso , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("dPcTaxa", ::ndPcTaxa, ::ndPcTaxa , "decimal", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("nCdTaxa", ::nnCdTaxa, ::nnCdTaxa , "long", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Contrato_ContratoItemTaxaDTO
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::nbFlIncluso        :=  WSAdvValue( oResponse,"_BFLINCLUSO","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::ndPcTaxa           :=  WSAdvValue( oResponse,"_DPCTAXA","decimal",NIL,NIL,NIL,"N",NIL,NIL) 
	::nnCdTaxa           :=  WSAdvValue( oResponse,"_NCDTAXA","long",NIL,NIL,NIL,"N",NIL,NIL) 
Return


