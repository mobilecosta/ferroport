#INCLUDE "protheus.ch"
#INCLUDE "apwebsrv.ch"

/* ===============================================================================
WSDL Location    https://srm-hml.paradigmabs.com.br/ferroport-hml/services/Requisicao.svc?wsdl
Gerado em        07/12/21 09:43:16
Observa��es      C�digo-Fonte gerado por ADVPL WSDL Client 1.120703
                 Altera��es neste arquivo podem causar funcionamento incorreto
                 e ser�o perdidas caso o c�digo-fonte seja gerado novamente.
=============================================================================== */

User Function _JRZNVOT ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSRequisicao
------------------------------------------------------------------------------- */

WSCLIENT WSRequisicao

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD ProcessarRequisicao
	WSMETHOD ProcessarRequisicaoCancelamento
	WSMETHOD RetornarRequisicaoCancelamento
	WSMETHOD RetornarRequisicaoEntregaCancelamento
	WSMETHOD RetornarRequisicaoNegociacao
	WSMETHOD HabilitarRetornarRequisicaoCancelamento
	WSMETHOD RetornarRequisicaoAtendidaEstoque
	WSMETHOD RetornarRequisicaoAtendidaEstoquePorEmpresa
	WSMETHOD HabilitarRetornarRequisicaoAtendidaEstoque
	WSMETHOD RetornarRequisicoesAssociadas
	WSMETHOD RetornarRequisicoesNaoAssociadas
	WSMETHOD RetornarRequisicaoHistoricoSituacao
	WSMETHOD RetornarRequisicaoRecusada
	WSMETHOD HabilitarRetornarRequisicaoRecusada
	WSMETHOD RetornarRequisicaoAlteracaoComprador

	WSDATA   _URL                      AS String
	WSDATA   _CERT                     AS String
	WSDATA   _PRIVKEY                  AS String
	WSDATA   _PASSPHRASE               AS String
	WSDATA   _HEADOUT                  AS Array of String
	WSDATA   _COOKIES                  AS Array of String
	WSDATA   oWSlstRequisicao          AS Requisicao_ArrayOfRequisicaoDTO
	WSDATA   oWSProcessarRequisicaoResult AS Requisicao_RetornoDTO
	WSDATA   oWSlstRequisicaoCancelar  AS Requisicao_ArrayOfRequisicaoAtualizarDTO
	WSDATA   oWSProcessarRequisicaoCancelamentoResult AS Requisicao_RetornoDTO
	WSDATA   oWSRetornarRequisicaoCancelamentoResult AS Requisicao_ArrayOfRequisicaoAtualizarDTO
	WSDATA   oWSRetornarRequisicaoEntregaCancelamentoResult AS Requisicao_ArrayOfRequisicaoEntregaAtualizarDTO
	WSDATA   oWSRetornarRequisicaoNegociacaoResult AS Requisicao_ArrayOfRequisicaoAtualizarDTO
	WSDATA   oWSsCdRequisicaoEmpresa   AS Requisicao_ArrayOfstring
	WSDATA   oWSHabilitarRetornarRequisicaoCancelamentoResult AS Requisicao_RetornoDTO
	WSDATA   oWSRetornarRequisicaoAtendidaEstoqueResult AS Requisicao_ArrayOfRequisicaoDTO
	WSDATA   oWSrequisicaoCompradorDTO AS Requisicao_RequisicaoCompradorDTO
	WSDATA   oWSRetornarRequisicaoAtendidaEstoquePorEmpresaResult AS Requisicao_ArrayOfRequisicaoDTO
	WSDATA   csCdItemEmpresa           AS string
	WSDATA   oWSHabilitarRetornarRequisicaoAtendidaEstoqueResult AS Requisicao_RetornoDTO
	WSDATA   oWSRetornarRequisicoesAssociadasResult AS Requisicao_ArrayOfRequisicaoAcompanhamentoDTO
	WSDATA   oWSRetornarRequisicoesNaoAssociadasResult AS Requisicao_ArrayOfRequisicaoAcompanhamentoDTO
	WSDATA   oWSRetornarRequisicaoHistoricoSituacaoResult AS Requisicao_RequisicaoDetalheDTO
	WSDATA   oWSRetornarRequisicaoRecusadaResult AS Requisicao_ArrayOfRequisicaoRecusadaDTO
	WSDATA   oWSlstCdRequisicaoEmpresa AS Requisicao_ArrayOfstring
	WSDATA   oWSHabilitarRetornarRequisicaoRecusadaResult AS Requisicao_RetornoDTO
	WSDATA   oWSRetornarRequisicaoAlteracaoCompradorResult AS Requisicao_ArrayOfRequisicaoCompradorAlteradoDTO

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSRequisicao
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O C�digo-Fonte Client atual requer os execut�veis do Protheus Build [7.00.191205P-20210114] ou superior. Atualize o Protheus ou gere o C�digo-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSRequisicao
	::oWSlstRequisicao   := Requisicao_ARRAYOFREQUISICAODTO():New()
	::oWSProcessarRequisicaoResult := Requisicao_RETORNODTO():New()
	::oWSlstRequisicaoCancelar := Requisicao_ARRAYOFREQUISICAOATUALIZARDTO():New()
	::oWSProcessarRequisicaoCancelamentoResult := Requisicao_RETORNODTO():New()
	::oWSRetornarRequisicaoCancelamentoResult := Requisicao_ARRAYOFREQUISICAOATUALIZARDTO():New()
	::oWSRetornarRequisicaoEntregaCancelamentoResult := Requisicao_ARRAYOFREQUISICAOENTREGAATUALIZARDTO():New()
	::oWSRetornarRequisicaoNegociacaoResult := Requisicao_ARRAYOFREQUISICAOATUALIZARDTO():New()
	::oWSsCdRequisicaoEmpresa := Requisicao_ARRAYOFSTRING():New()
	::oWSHabilitarRetornarRequisicaoCancelamentoResult := Requisicao_RETORNODTO():New()
	::oWSRetornarRequisicaoAtendidaEstoqueResult := Requisicao_ARRAYOFREQUISICAODTO():New()
	::oWSrequisicaoCompradorDTO := Requisicao_REQUISICAOCOMPRADORDTO():New()
	::oWSRetornarRequisicaoAtendidaEstoquePorEmpresaResult := Requisicao_ARRAYOFREQUISICAODTO():New()
	::oWSHabilitarRetornarRequisicaoAtendidaEstoqueResult := Requisicao_RETORNODTO():New()
	::oWSRetornarRequisicoesAssociadasResult := Requisicao_ARRAYOFREQUISICAOACOMPANHAMENTODTO():New()
	::oWSRetornarRequisicoesNaoAssociadasResult := Requisicao_ARRAYOFREQUISICAOACOMPANHAMENTODTO():New()
	::oWSRetornarRequisicaoHistoricoSituacaoResult := Requisicao_REQUISICAODETALHEDTO():New()
	::oWSRetornarRequisicaoRecusadaResult := Requisicao_ARRAYOFREQUISICAORECUSADADTO():New()
	::oWSlstCdRequisicaoEmpresa := Requisicao_ARRAYOFSTRING():New()
	::oWSHabilitarRetornarRequisicaoRecusadaResult := Requisicao_RETORNODTO():New()
	::oWSRetornarRequisicaoAlteracaoCompradorResult := Requisicao_ARRAYOFREQUISICAOCOMPRADORALTERADODTO():New()
Return

WSMETHOD RESET WSCLIENT WSRequisicao
	::oWSlstRequisicao   := NIL 
	::oWSProcessarRequisicaoResult := NIL 
	::oWSlstRequisicaoCancelar := NIL 
	::oWSProcessarRequisicaoCancelamentoResult := NIL 
	::oWSRetornarRequisicaoCancelamentoResult := NIL 
	::oWSRetornarRequisicaoEntregaCancelamentoResult := NIL 
	::oWSRetornarRequisicaoNegociacaoResult := NIL 
	::oWSsCdRequisicaoEmpresa := NIL 
	::oWSHabilitarRetornarRequisicaoCancelamentoResult := NIL 
	::oWSRetornarRequisicaoAtendidaEstoqueResult := NIL 
	::oWSrequisicaoCompradorDTO := NIL 
	::oWSRetornarRequisicaoAtendidaEstoquePorEmpresaResult := NIL 
	::csCdItemEmpresa    := NIL 
	::oWSHabilitarRetornarRequisicaoAtendidaEstoqueResult := NIL 
	::oWSRetornarRequisicoesAssociadasResult := NIL 
	::oWSRetornarRequisicoesNaoAssociadasResult := NIL 
	::oWSRetornarRequisicaoHistoricoSituacaoResult := NIL 
	::oWSRetornarRequisicaoRecusadaResult := NIL 
	::oWSlstCdRequisicaoEmpresa := NIL 
	::oWSHabilitarRetornarRequisicaoRecusadaResult := NIL 
	::oWSRetornarRequisicaoAlteracaoCompradorResult := NIL 
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSRequisicao
Local oClone := WSRequisicao():New()
	oClone:_URL          := ::_URL 
	oClone:_CERT         := ::_CERT 
	oClone:_PRIVKEY      := ::_PRIVKEY 
	oClone:_PASSPHRASE   := ::_PASSPHRASE 
	oClone:oWSlstRequisicao :=  IIF(::oWSlstRequisicao = NIL , NIL ,::oWSlstRequisicao:Clone() )
	oClone:oWSProcessarRequisicaoResult :=  IIF(::oWSProcessarRequisicaoResult = NIL , NIL ,::oWSProcessarRequisicaoResult:Clone() )
	oClone:oWSlstRequisicaoCancelar :=  IIF(::oWSlstRequisicaoCancelar = NIL , NIL ,::oWSlstRequisicaoCancelar:Clone() )
	oClone:oWSProcessarRequisicaoCancelamentoResult :=  IIF(::oWSProcessarRequisicaoCancelamentoResult = NIL , NIL ,::oWSProcessarRequisicaoCancelamentoResult:Clone() )
	oClone:oWSRetornarRequisicaoCancelamentoResult :=  IIF(::oWSRetornarRequisicaoCancelamentoResult = NIL , NIL ,::oWSRetornarRequisicaoCancelamentoResult:Clone() )
	oClone:oWSRetornarRequisicaoEntregaCancelamentoResult :=  IIF(::oWSRetornarRequisicaoEntregaCancelamentoResult = NIL , NIL ,::oWSRetornarRequisicaoEntregaCancelamentoResult:Clone() )
	oClone:oWSRetornarRequisicaoNegociacaoResult :=  IIF(::oWSRetornarRequisicaoNegociacaoResult = NIL , NIL ,::oWSRetornarRequisicaoNegociacaoResult:Clone() )
	oClone:oWSsCdRequisicaoEmpresa :=  IIF(::oWSsCdRequisicaoEmpresa = NIL , NIL ,::oWSsCdRequisicaoEmpresa:Clone() )
	oClone:oWSHabilitarRetornarRequisicaoCancelamentoResult :=  IIF(::oWSHabilitarRetornarRequisicaoCancelamentoResult = NIL , NIL ,::oWSHabilitarRetornarRequisicaoCancelamentoResult:Clone() )
	oClone:oWSRetornarRequisicaoAtendidaEstoqueResult :=  IIF(::oWSRetornarRequisicaoAtendidaEstoqueResult = NIL , NIL ,::oWSRetornarRequisicaoAtendidaEstoqueResult:Clone() )
	oClone:oWSrequisicaoCompradorDTO :=  IIF(::oWSrequisicaoCompradorDTO = NIL , NIL ,::oWSrequisicaoCompradorDTO:Clone() )
	oClone:oWSRetornarRequisicaoAtendidaEstoquePorEmpresaResult :=  IIF(::oWSRetornarRequisicaoAtendidaEstoquePorEmpresaResult = NIL , NIL ,::oWSRetornarRequisicaoAtendidaEstoquePorEmpresaResult:Clone() )
	oClone:csCdItemEmpresa := ::csCdItemEmpresa
	oClone:oWSHabilitarRetornarRequisicaoAtendidaEstoqueResult :=  IIF(::oWSHabilitarRetornarRequisicaoAtendidaEstoqueResult = NIL , NIL ,::oWSHabilitarRetornarRequisicaoAtendidaEstoqueResult:Clone() )
	oClone:oWSRetornarRequisicoesAssociadasResult :=  IIF(::oWSRetornarRequisicoesAssociadasResult = NIL , NIL ,::oWSRetornarRequisicoesAssociadasResult:Clone() )
	oClone:oWSRetornarRequisicoesNaoAssociadasResult :=  IIF(::oWSRetornarRequisicoesNaoAssociadasResult = NIL , NIL ,::oWSRetornarRequisicoesNaoAssociadasResult:Clone() )
	oClone:oWSRetornarRequisicaoHistoricoSituacaoResult :=  IIF(::oWSRetornarRequisicaoHistoricoSituacaoResult = NIL , NIL ,::oWSRetornarRequisicaoHistoricoSituacaoResult:Clone() )
	oClone:oWSRetornarRequisicaoRecusadaResult :=  IIF(::oWSRetornarRequisicaoRecusadaResult = NIL , NIL ,::oWSRetornarRequisicaoRecusadaResult:Clone() )
	oClone:oWSlstCdRequisicaoEmpresa :=  IIF(::oWSlstCdRequisicaoEmpresa = NIL , NIL ,::oWSlstCdRequisicaoEmpresa:Clone() )
	oClone:oWSHabilitarRetornarRequisicaoRecusadaResult :=  IIF(::oWSHabilitarRetornarRequisicaoRecusadaResult = NIL , NIL ,::oWSHabilitarRetornarRequisicaoRecusadaResult:Clone() )
	oClone:oWSRetornarRequisicaoAlteracaoCompradorResult :=  IIF(::oWSRetornarRequisicaoAlteracaoCompradorResult = NIL , NIL ,::oWSRetornarRequisicaoAlteracaoCompradorResult:Clone() )
Return oClone

// WSDL Method ProcessarRequisicao of Service WSRequisicao


WSMETHOD ProcessarRequisicao WSSEND oWSlstRequisicao WSRECEIVE oWSProcessarRequisicaoResult WSCLIENT WSRequisicao
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ProcessarRequisicao xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("lstRequisicao", ::oWSlstRequisicao, oWSlstRequisicao , "ArrayOfRequisicaoDTO", .F. , .F., 0 , "http://tempuri.org/", .F.,.F.) 
cSoap += "</ProcessarRequisicao>"

Self:_HEADOUT := { "Authorization: Bearer " + U_NewToken() }
oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tempuri.org/IRequisicao/ProcessarRequisicao",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	Lower(AllTrim(GetMv("MV_XPARURL"))) + "/services/Requisicao.svc")

::Init()
::oWSProcessarRequisicaoResult:SoapRecv( WSAdvValue( oXmlRet,"_PROCESSARREQUISICAORESPONSE:_PROCESSARREQUISICAORESULT","RetornoDTO",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return  {.T.,cSoap}

// WSDL Method ProcessarRequisicaoCancelamento of Service WSRequisicao

WSMETHOD ProcessarRequisicaoCancelamento WSSEND oWSlstRequisicaoCancelar WSRECEIVE oWSProcessarRequisicaoCancelamentoResult WSCLIENT WSRequisicao
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ProcessarRequisicaoCancelamento xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("lstRequisicaoCancelar", ::oWSlstRequisicaoCancelar, oWSlstRequisicaoCancelar , "ArrayOfRequisicaoAtualizarDTO", .F. , .F., 0 , "http://tempuri.org/", .F.,.F.) 
cSoap += "</ProcessarRequisicaoCancelamento>"

Self:_HEADOUT := { "Authorization: Bearer " + U_NewToken() }
oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tempuri.org/IRequisicao/ProcessarRequisicaoCancelamento",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	Lower(AllTrim(GetMv("MV_XPARURL"))) + "/services/Requisicao.svc")


::Init()
::oWSProcessarRequisicaoCancelamentoResult:SoapRecv( WSAdvValue( oXmlRet,"_PROCESSARREQUISICAOCANCELAMENTORESPONSE:_PROCESSARREQUISICAOCANCELAMENTORESULT","RetornoDTO",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method RetornarRequisicaoCancelamento of Service WSRequisicao

WSMETHOD RetornarRequisicaoCancelamento WSSEND NULLPARAM WSRECEIVE oWSRetornarRequisicaoCancelamentoResult WSCLIENT WSRequisicao
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<RetornarRequisicaoCancelamento xmlns="http://tempuri.org/">'
cSoap += "</RetornarRequisicaoCancelamento>"

Self:_HEADOUT := { "Authorization: Bearer " + U_NewToken() }
oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tempuri.org/IRequisicao/RetornarRequisicaoCancelamento",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	Lower(AllTrim(GetMv("MV_XPARURL"))) + "/services/Requisicao.svc")

::Init()
::oWSRetornarRequisicaoCancelamentoResult:SoapRecv( WSAdvValue( oXmlRet,"_RETORNARREQUISICAOCANCELAMENTORESPONSE:_RETORNARREQUISICAOCANCELAMENTORESULT","ArrayOfRequisicaoAtualizarDTO",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method RetornarRequisicaoEntregaCancelamento of Service WSRequisicao

WSMETHOD RetornarRequisicaoEntregaCancelamento WSSEND NULLPARAM WSRECEIVE oWSRetornarRequisicaoEntregaCancelamentoResult WSCLIENT WSRequisicao
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<RetornarRequisicaoEntregaCancelamento xmlns="http://tempuri.org/">'
cSoap += "</RetornarRequisicaoEntregaCancelamento>"

Self:_HEADOUT := { "Authorization: Bearer " + U_NewToken() }
oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tempuri.org/IRequisicao/RetornarRequisicaoEntregaCancelamento",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	Lower(AllTrim(GetMv("MV_XPARURL"))) + "/services/Requisicao.svc")

::Init()
::oWSRetornarRequisicaoEntregaCancelamentoResult:SoapRecv( WSAdvValue( oXmlRet,"_RETORNARREQUISICAOENTREGACANCELAMENTORESPONSE:_RETORNARREQUISICAOENTREGACANCELAMENTORESULT","ArrayOfRequisicaoEntregaAtualizarDTO",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method RetornarRequisicaoNegociacao of Service WSRequisicao

WSMETHOD RetornarRequisicaoNegociacao WSSEND NULLPARAM WSRECEIVE oWSRetornarRequisicaoNegociacaoResult WSCLIENT WSRequisicao
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<RetornarRequisicaoNegociacao xmlns="http://tempuri.org/">'
cSoap += "</RetornarRequisicaoNegociacao>"

Self:_HEADOUT := { "Authorization: Bearer " + U_NewToken() }
oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tempuri.org/IRequisicao/RetornarRequisicaoNegociacao",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	Lower(AllTrim(GetMv("MV_XPARURL"))) + "/services/Requisicao.svc")

::Init()
::oWSRetornarRequisicaoNegociacaoResult:SoapRecv( WSAdvValue( oXmlRet,"_RETORNARREQUISICAONEGOCIACAORESPONSE:_RETORNARREQUISICAONEGOCIACAORESULT","ArrayOfRequisicaoAtualizarDTO",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method HabilitarRetornarRequisicaoCancelamento of Service WSRequisicao

WSMETHOD HabilitarRetornarRequisicaoCancelamento WSSEND oWSsCdRequisicaoEmpresa WSRECEIVE oWSHabilitarRetornarRequisicaoCancelamentoResult WSCLIENT WSRequisicao
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<HabilitarRetornarRequisicaoCancelamento xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("sCdRequisicaoEmpresa", ::oWSsCdRequisicaoEmpresa, oWSsCdRequisicaoEmpresa , "ArrayOfstring", .F. , .F., 0 , "http://tempuri.org/", .F.,.F.) 
cSoap += "</HabilitarRetornarRequisicaoCancelamento>"

Self:_HEADOUT := { "Authorization: Bearer " + U_NewToken() }
oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tempuri.org/IRequisicao/HabilitarRetornarRequisicaoCancelamento",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	Lower(AllTrim(GetMv("MV_XPARURL"))) + "/services/Requisicao.svc")

::Init()
::oWSHabilitarRetornarRequisicaoCancelamentoResult:SoapRecv( WSAdvValue( oXmlRet,"_HABILITARRETORNARREQUISICAOCANCELAMENTORESPONSE:_HABILITARRETORNARREQUISICAOCANCELAMENTORESULT","RetornoDTO",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method RetornarRequisicaoAtendidaEstoque of Service WSRequisicao

WSMETHOD RetornarRequisicaoAtendidaEstoque WSSEND NULLPARAM WSRECEIVE oWSRetornarRequisicaoAtendidaEstoqueResult WSCLIENT WSRequisicao
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<RetornarRequisicaoAtendidaEstoque xmlns="http://tempuri.org/">'
cSoap += "</RetornarRequisicaoAtendidaEstoque>"

Self:_HEADOUT := { "Authorization: Bearer " + U_NewToken() }
oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tempuri.org/IRequisicao/RetornarRequisicaoAtendidaEstoque",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	Lower(AllTrim(GetMv("MV_XPARURL"))) + "/services/Requisicao.svc")

::Init()
::oWSRetornarRequisicaoAtendidaEstoqueResult:SoapRecv( WSAdvValue( oXmlRet,"_RETORNARREQUISICAOATENDIDAESTOQUERESPONSE:_RETORNARREQUISICAOATENDIDAESTOQUERESULT","ArrayOfRequisicaoDTO",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method RetornarRequisicaoAtendidaEstoquePorEmpresa of Service WSRequisicao

WSMETHOD RetornarRequisicaoAtendidaEstoquePorEmpresa WSSEND oWSrequisicaoCompradorDTO WSRECEIVE oWSRetornarRequisicaoAtendidaEstoquePorEmpresaResult WSCLIENT WSRequisicao
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<RetornarRequisicaoAtendidaEstoquePorEmpresa xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("requisicaoCompradorDTO", ::oWSrequisicaoCompradorDTO, oWSrequisicaoCompradorDTO , "RequisicaoCompradorDTO", .F. , .F., 0 , "http://tempuri.org/", .F.,.F.) 
cSoap += "</RetornarRequisicaoAtendidaEstoquePorEmpresa>"

Self:_HEADOUT := { "Authorization: Bearer " + U_NewToken() }
oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tempuri.org/IRequisicao/RetornarRequisicaoAtendidaEstoquePorEmpresa",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	Lower(AllTrim(GetMv("MV_XPARURL"))) + "/services/Requisicao.svc")

::Init()
::oWSRetornarRequisicaoAtendidaEstoquePorEmpresaResult:SoapRecv( WSAdvValue( oXmlRet,"_RETORNARREQUISICAOATENDIDAESTOQUEPOREMPRESARESPONSE:_RETORNARREQUISICAOATENDIDAESTOQUEPOREMPRESARESULT","ArrayOfRequisicaoDTO",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method HabilitarRetornarRequisicaoAtendidaEstoque of Service WSRequisicao

WSMETHOD HabilitarRetornarRequisicaoAtendidaEstoque WSSEND csCdRequisicaoEmpresa,csCdItemEmpresa WSRECEIVE oWSHabilitarRetornarRequisicaoAtendidaEstoqueResult WSCLIENT WSRequisicao
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<HabilitarRetornarRequisicaoAtendidaEstoque xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("sCdRequisicaoEmpresa", ::csCdRequisicaoEmpresa, csCdRequisicaoEmpresa , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("sCdItemEmpresa", ::csCdItemEmpresa, csCdItemEmpresa , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</HabilitarRetornarRequisicaoAtendidaEstoque>"

Self:_HEADOUT := { "Authorization: Bearer " + U_NewToken() }
oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tempuri.org/IRequisicao/HabilitarRetornarRequisicaoAtendidaEstoque",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	Lower(AllTrim(GetMv("MV_XPARURL"))) + "/services/Requisicao.svc")

::Init()
::oWSHabilitarRetornarRequisicaoAtendidaEstoqueResult:SoapRecv( WSAdvValue( oXmlRet,"_HABILITARRETORNARREQUISICAOATENDIDAESTOQUERESPONSE:_HABILITARRETORNARREQUISICAOATENDIDAESTOQUERESULT","RetornoDTO",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method RetornarRequisicoesAssociadas of Service WSRequisicao

WSMETHOD RetornarRequisicoesAssociadas WSSEND NULLPARAM WSRECEIVE oWSRetornarRequisicoesAssociadasResult WSCLIENT WSRequisicao
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<RetornarRequisicoesAssociadas xmlns="http://tempuri.org/">'
cSoap += "</RetornarRequisicoesAssociadas>"

Self:_HEADOUT := { "Authorization: Bearer " + U_NewToken() }
oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tempuri.org/IRequisicao/RetornarRequisicoesAssociadas",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	Lower(AllTrim(GetMv("MV_XPARURL"))) + "/services/Requisicao.svc")

::Init()
::oWSRetornarRequisicoesAssociadasResult:SoapRecv( WSAdvValue( oXmlRet,"_RETORNARREQUISICOESASSOCIADASRESPONSE:_RETORNARREQUISICOESASSOCIADASRESULT","ArrayOfRequisicaoAcompanhamentoDTO",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method RetornarRequisicoesNaoAssociadas of Service WSRequisicao

WSMETHOD RetornarRequisicoesNaoAssociadas WSSEND NULLPARAM WSRECEIVE oWSRetornarRequisicoesNaoAssociadasResult WSCLIENT WSRequisicao
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<RetornarRequisicoesNaoAssociadas xmlns="http://tempuri.org/">'
cSoap += "</RetornarRequisicoesNaoAssociadas>"

Self:_HEADOUT := { "Authorization: Bearer " + U_NewToken() }
oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tempuri.org/IRequisicao/RetornarRequisicoesNaoAssociadas",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	Lower(AllTrim(GetMv("MV_XPARURL"))) + "/services/Requisicao.svc")

::Init()
::oWSRetornarRequisicoesNaoAssociadasResult:SoapRecv( WSAdvValue( oXmlRet,"_RETORNARREQUISICOESNAOASSOCIADASRESPONSE:_RETORNARREQUISICOESNAOASSOCIADASRESULT","ArrayOfRequisicaoAcompanhamentoDTO",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method RetornarRequisicaoHistoricoSituacao of Service WSRequisicao

WSMETHOD RetornarRequisicaoHistoricoSituacao WSSEND csCdRequisicaoEmpresa,csCdItemEmpresa WSRECEIVE oWSRetornarRequisicaoHistoricoSituacaoResult WSCLIENT WSRequisicao
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<RetornarRequisicaoHistoricoSituacao xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("sCdRequisicaoEmpresa", ::csCdRequisicaoEmpresa, csCdRequisicaoEmpresa , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("sCdItemEmpresa", ::csCdItemEmpresa, csCdItemEmpresa , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</RetornarRequisicaoHistoricoSituacao>"

Self:_HEADOUT := { "Authorization: Bearer " + U_NewToken() }
oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tempuri.org/IRequisicao/RetornarRequisicaoHistoricoSituacao",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	Lower(AllTrim(GetMv("MV_XPARURL"))) + "/services/Requisicao.svc")

::Init()
::oWSRetornarRequisicaoHistoricoSituacaoResult:SoapRecv( WSAdvValue( oXmlRet,"_RETORNARREQUISICAOHISTORICOSITUACAORESPONSE:_RETORNARREQUISICAOHISTORICOSITUACAORESULT","RequisicaoDetalheDTO",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method RetornarRequisicaoRecusada of Service WSRequisicao

WSMETHOD RetornarRequisicaoRecusada WSSEND NULLPARAM WSRECEIVE oWSRetornarRequisicaoRecusadaResult WSCLIENT WSRequisicao
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<RetornarRequisicaoRecusada xmlns="http://tempuri.org/">'
cSoap += "</RetornarRequisicaoRecusada>"

Self:_HEADOUT := { "Authorization: Bearer " + U_NewToken() }
oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tempuri.org/IRequisicao/RetornarRequisicaoRecusada",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	Lower(AllTrim(GetMv("MV_XPARURL"))) + "/services/Requisicao.svc?wsdl")

::Init()
::oWSRetornarRequisicaoRecusadaResult:SoapRecv( WSAdvValue( oXmlRet,"_RETORNARREQUISICAORECUSADARESPONSE:_RETORNARREQUISICAORECUSADARESULT","ArrayOfRequisicaoRecusadaDTO",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method HabilitarRetornarRequisicaoRecusada of Service WSRequisicao

WSMETHOD HabilitarRetornarRequisicaoRecusada WSSEND oWSlstCdRequisicaoEmpresa WSRECEIVE oWSHabilitarRetornarRequisicaoRecusadaResult WSCLIENT WSRequisicao
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<HabilitarRetornarRequisicaoRecusada xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("lstCdRequisicaoEmpresa", ::oWSlstCdRequisicaoEmpresa, oWSlstCdRequisicaoEmpresa , "ArrayOfstring", .F. , .F., 0 , "http://tempuri.org/", .F.,.F.) 
cSoap += "</HabilitarRetornarRequisicaoRecusada>"

Self:_HEADOUT := { "Authorization: Bearer " + U_NewToken() }
oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tempuri.org/IRequisicao/HabilitarRetornarRequisicaoRecusada",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	Lower(AllTrim(GetMv("MV_XPARURL"))) + "/services/Requisicao.svc")

::Init()
::oWSHabilitarRetornarRequisicaoRecusadaResult:SoapRecv( WSAdvValue( oXmlRet,"_HABILITARRETORNARREQUISICAORECUSADARESPONSE:_HABILITARRETORNARREQUISICAORECUSADARESULT","RetornoDTO",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method RetornarRequisicaoAlteracaoComprador of Service WSRequisicao

WSMETHOD RetornarRequisicaoAlteracaoComprador WSSEND NULLPARAM WSRECEIVE oWSRetornarRequisicaoAlteracaoCompradorResult WSCLIENT WSRequisicao
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<RetornarRequisicaoAlteracaoComprador xmlns="http://tempuri.org/">'
cSoap += "</RetornarRequisicaoAlteracaoComprador>"

Self:_HEADOUT := { "Authorization: Bearer " + U_NewToken() }
oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tempuri.org/IRequisicao/RetornarRequisicaoAlteracaoComprador",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	Lower(AllTrim(GetMv("MV_XPARURL"))) + "/services/Requisicao.svc")

::Init()
::oWSRetornarRequisicaoAlteracaoCompradorResult:SoapRecv( WSAdvValue( oXmlRet,"_RETORNARREQUISICAOALTERACAOCOMPRADORRESPONSE:_RETORNARREQUISICAOALTERACAOCOMPRADORRESULT","ArrayOfRequisicaoCompradorAlteradoDTO",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.


// WSDL Data Structure ArrayOfRequisicaoDTO

WSSTRUCT Requisicao_ArrayOfRequisicaoDTO
	WSDATA   oWSRequisicaoDTO          AS Requisicao_RequisicaoDTO OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Requisicao_ArrayOfRequisicaoDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Requisicao_ArrayOfRequisicaoDTO
	::oWSRequisicaoDTO     := {} // Array Of  Requisicao_REQUISICAODTO():New()
Return

WSMETHOD CLONE WSCLIENT Requisicao_ArrayOfRequisicaoDTO
	Local oClone := Requisicao_ArrayOfRequisicaoDTO():NEW()
	oClone:oWSRequisicaoDTO := NIL
	If ::oWSRequisicaoDTO <> NIL 
		oClone:oWSRequisicaoDTO := {}
		aEval( ::oWSRequisicaoDTO , { |x| aadd( oClone:oWSRequisicaoDTO , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT Requisicao_ArrayOfRequisicaoDTO
	Local cSoap := ""
	aEval( ::oWSRequisicaoDTO , {|x| cSoap := cSoap  +  WSSoapValue("RequisicaoDTO", x , x , "RequisicaoDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.)  } ) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Requisicao_ArrayOfRequisicaoDTO
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_REQUISICAODTO","RequisicaoDTO",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSRequisicaoDTO , Requisicao_RequisicaoDTO():New() )
			::oWSRequisicaoDTO[len(::oWSRequisicaoDTO)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure RetornoDTO

WSSTRUCT Requisicao_RetornoDTO
	WSDATA   oWSlstWbtLogDTO           AS Requisicao_ArrayOfWbtLogDTO OPTIONAL
	WSDATA   nnIdRetorno               AS long OPTIONAL
	WSDATA   csNrToken                 AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Requisicao_RetornoDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Requisicao_RetornoDTO
Return

WSMETHOD CLONE WSCLIENT Requisicao_RetornoDTO
	Local oClone := Requisicao_RetornoDTO():NEW()
	oClone:oWSlstWbtLogDTO      := IIF(::oWSlstWbtLogDTO = NIL , NIL , ::oWSlstWbtLogDTO:Clone() )
	oClone:nnIdRetorno          := ::nnIdRetorno
	oClone:csNrToken            := ::csNrToken
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Requisicao_RetornoDTO
	Local oNode1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_LSTWBTLOGDTO","ArrayOfWbtLogDTO",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode1 != NIL
		::oWSlstWbtLogDTO := Requisicao_ArrayOfWbtLogDTO():New()
		::oWSlstWbtLogDTO:SoapRecv(oNode1)
	EndIf
	::nnIdRetorno        :=  WSAdvValue( oResponse,"_NIDRETORNO","long",NIL,NIL,NIL,"N",NIL,NIL) 
	::csNrToken          :=  WSAdvValue( oResponse,"_SNRTOKEN","string",NIL,NIL,NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure ArrayOfRequisicaoAtualizarDTO

WSSTRUCT Requisicao_ArrayOfRequisicaoAtualizarDTO
	WSDATA   oWSRequisicaoAtualizarDTO AS Requisicao_RequisicaoAtualizarDTO OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Requisicao_ArrayOfRequisicaoAtualizarDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Requisicao_ArrayOfRequisicaoAtualizarDTO
	::oWSRequisicaoAtualizarDTO := {} // Array Of  Requisicao_REQUISICAOATUALIZARDTO():New()
Return

WSMETHOD CLONE WSCLIENT Requisicao_ArrayOfRequisicaoAtualizarDTO
	Local oClone := Requisicao_ArrayOfRequisicaoAtualizarDTO():NEW()
	oClone:oWSRequisicaoAtualizarDTO := NIL
	If ::oWSRequisicaoAtualizarDTO <> NIL 
		oClone:oWSRequisicaoAtualizarDTO := {}
		aEval( ::oWSRequisicaoAtualizarDTO , { |x| aadd( oClone:oWSRequisicaoAtualizarDTO , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT Requisicao_ArrayOfRequisicaoAtualizarDTO
	Local cSoap := ""
	aEval( ::oWSRequisicaoAtualizarDTO , {|x| cSoap := cSoap  +  WSSoapValue("RequisicaoAtualizarDTO", x , x , "RequisicaoAtualizarDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.)  } ) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Requisicao_ArrayOfRequisicaoAtualizarDTO
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_REQUISICAOATUALIZARDTO","RequisicaoAtualizarDTO",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSRequisicaoAtualizarDTO , Requisicao_RequisicaoAtualizarDTO():New() )
			::oWSRequisicaoAtualizarDTO[len(::oWSRequisicaoAtualizarDTO)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure ArrayOfRequisicaoEntregaAtualizarDTO

WSSTRUCT Requisicao_ArrayOfRequisicaoEntregaAtualizarDTO
	WSDATA   oWSRequisicaoEntregaAtualizarDTO AS Requisicao_RequisicaoEntregaAtualizarDTO OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Requisicao_ArrayOfRequisicaoEntregaAtualizarDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Requisicao_ArrayOfRequisicaoEntregaAtualizarDTO
	::oWSRequisicaoEntregaAtualizarDTO := {} // Array Of  Requisicao_REQUISICAOENTREGAATUALIZARDTO():New()
Return

WSMETHOD CLONE WSCLIENT Requisicao_ArrayOfRequisicaoEntregaAtualizarDTO
	Local oClone := Requisicao_ArrayOfRequisicaoEntregaAtualizarDTO():NEW()
	oClone:oWSRequisicaoEntregaAtualizarDTO := NIL
	If ::oWSRequisicaoEntregaAtualizarDTO <> NIL 
		oClone:oWSRequisicaoEntregaAtualizarDTO := {}
		aEval( ::oWSRequisicaoEntregaAtualizarDTO , { |x| aadd( oClone:oWSRequisicaoEntregaAtualizarDTO , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Requisicao_ArrayOfRequisicaoEntregaAtualizarDTO
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_REQUISICAOENTREGAATUALIZARDTO","RequisicaoEntregaAtualizarDTO",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSRequisicaoEntregaAtualizarDTO , Requisicao_RequisicaoEntregaAtualizarDTO():New() )
			::oWSRequisicaoEntregaAtualizarDTO[len(::oWSRequisicaoEntregaAtualizarDTO)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure ArrayOfstring

WSSTRUCT Requisicao_ArrayOfstring
	WSDATA   cstring                   AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Requisicao_ArrayOfstring
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Requisicao_ArrayOfstring
	::cstring              := {} // Array Of  ""
Return

WSMETHOD CLONE WSCLIENT Requisicao_ArrayOfstring
	Local oClone := Requisicao_ArrayOfstring():NEW()
	oClone:cstring              := IIf(::cstring <> NIL , aClone(::cstring) , NIL )
Return oClone

WSMETHOD SOAPSEND WSCLIENT Requisicao_ArrayOfstring
	Local cSoap := ""
	aEval( ::cstring , {|x| cSoap := cSoap  +  WSSoapValue("string", x , x , "string", .F. , .F., 0 , "http://schemas.microsoft.com/2003/10/Serialization/Arrays", .F.,.F.)  } ) 
Return cSoap

// WSDL Data Structure RequisicaoCompradorDTO

WSSTRUCT Requisicao_RequisicaoCompradorDTO
	WSDATA   csCdComprador             AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Requisicao_RequisicaoCompradorDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Requisicao_RequisicaoCompradorDTO
Return

WSMETHOD CLONE WSCLIENT Requisicao_RequisicaoCompradorDTO
	Local oClone := Requisicao_RequisicaoCompradorDTO():NEW()
	oClone:csCdComprador        := ::csCdComprador
Return oClone

WSMETHOD SOAPSEND WSCLIENT Requisicao_RequisicaoCompradorDTO
	Local cSoap := ""
	cSoap += WSSoapValue("sCdComprador", ::csCdComprador, ::csCdComprador , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
Return cSoap

// WSDL Data Structure ArrayOfRequisicaoAcompanhamentoDTO

WSSTRUCT Requisicao_ArrayOfRequisicaoAcompanhamentoDTO
	WSDATA   oWSRequisicaoAcompanhamentoDTO AS Requisicao_RequisicaoAcompanhamentoDTO OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Requisicao_ArrayOfRequisicaoAcompanhamentoDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Requisicao_ArrayOfRequisicaoAcompanhamentoDTO
	::oWSRequisicaoAcompanhamentoDTO := {} // Array Of  Requisicao_REQUISICAOACOMPANHAMENTODTO():New()
Return

WSMETHOD CLONE WSCLIENT Requisicao_ArrayOfRequisicaoAcompanhamentoDTO
	Local oClone := Requisicao_ArrayOfRequisicaoAcompanhamentoDTO():NEW()
	oClone:oWSRequisicaoAcompanhamentoDTO := NIL
	If ::oWSRequisicaoAcompanhamentoDTO <> NIL 
		oClone:oWSRequisicaoAcompanhamentoDTO := {}
		aEval( ::oWSRequisicaoAcompanhamentoDTO , { |x| aadd( oClone:oWSRequisicaoAcompanhamentoDTO , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Requisicao_ArrayOfRequisicaoAcompanhamentoDTO
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_REQUISICAOACOMPANHAMENTODTO","RequisicaoAcompanhamentoDTO",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSRequisicaoAcompanhamentoDTO , Requisicao_RequisicaoAcompanhamentoDTO():New() )
			::oWSRequisicaoAcompanhamentoDTO[len(::oWSRequisicaoAcompanhamentoDTO)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure RequisicaoDetalheDTO

WSSTRUCT Requisicao_RequisicaoDetalheDTO
	WSDATA   oWSlstRequisicaoHistoricoSituacao AS Requisicao_ArrayOfRequisicaoHistoricoSituacaoDTO OPTIONAL
	WSDATA   nnIdTipo                  AS long OPTIONAL
	WSDATA   oWSoContratoResumo        AS Requisicao_ContratoResumoDTO OPTIONAL
	WSDATA   oWSoModalidadePresencialResumo AS Requisicao_ModalidadePresencialResumoDTO OPTIONAL
	WSDATA   oWSoPedidoResumo          AS Requisicao_PedidoResumoDTO OPTIONAL
	WSDATA   oWSoRequisicao            AS Requisicao_RequisicaoDTO OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Requisicao_RequisicaoDetalheDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Requisicao_RequisicaoDetalheDTO
Return

WSMETHOD CLONE WSCLIENT Requisicao_RequisicaoDetalheDTO
	Local oClone := Requisicao_RequisicaoDetalheDTO():NEW()
	oClone:oWSlstRequisicaoHistoricoSituacao := IIF(::oWSlstRequisicaoHistoricoSituacao = NIL , NIL , ::oWSlstRequisicaoHistoricoSituacao:Clone() )
	oClone:nnIdTipo             := ::nnIdTipo
	oClone:oWSoContratoResumo   := IIF(::oWSoContratoResumo = NIL , NIL , ::oWSoContratoResumo:Clone() )
	oClone:oWSoModalidadePresencialResumo := IIF(::oWSoModalidadePresencialResumo = NIL , NIL , ::oWSoModalidadePresencialResumo:Clone() )
	oClone:oWSoPedidoResumo     := IIF(::oWSoPedidoResumo = NIL , NIL , ::oWSoPedidoResumo:Clone() )
	oClone:oWSoRequisicao       := IIF(::oWSoRequisicao = NIL , NIL , ::oWSoRequisicao:Clone() )
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Requisicao_RequisicaoDetalheDTO
	Local oNode1
	Local oNode3
	Local oNode4
	Local oNode5
	Local oNode6
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_LSTREQUISICAOHISTORICOSITUACAO","ArrayOfRequisicaoHistoricoSituacaoDTO",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode1 != NIL
		::oWSlstRequisicaoHistoricoSituacao := Requisicao_ArrayOfRequisicaoHistoricoSituacaoDTO():New()
		::oWSlstRequisicaoHistoricoSituacao:SoapRecv(oNode1)
	EndIf
	::nnIdTipo           :=  WSAdvValue( oResponse,"_NIDTIPO","long",NIL,NIL,NIL,"N",NIL,NIL) 
	oNode3 :=  WSAdvValue( oResponse,"_OCONTRATORESUMO","ContratoResumoDTO",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode3 != NIL
		::oWSoContratoResumo := Requisicao_ContratoResumoDTO():New()
		::oWSoContratoResumo:SoapRecv(oNode3)
	EndIf
	oNode4 :=  WSAdvValue( oResponse,"_OMODALIDADEPRESENCIALRESUMO","ModalidadePresencialResumoDTO",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode4 != NIL
		::oWSoModalidadePresencialResumo := Requisicao_ModalidadePresencialResumoDTO():New()
		::oWSoModalidadePresencialResumo:SoapRecv(oNode4)
	EndIf
	oNode5 :=  WSAdvValue( oResponse,"_OPEDIDORESUMO","PedidoResumoDTO",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode5 != NIL
		::oWSoPedidoResumo := Requisicao_PedidoResumoDTO():New()
		::oWSoPedidoResumo:SoapRecv(oNode5)
	EndIf
	oNode6 :=  WSAdvValue( oResponse,"_OREQUISICAO","RequisicaoDTO",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode6 != NIL
		::oWSoRequisicao := Requisicao_RequisicaoDTO():New()
		::oWSoRequisicao:SoapRecv(oNode6)
	EndIf
Return

// WSDL Data Structure ArrayOfRequisicaoRecusadaDTO

WSSTRUCT Requisicao_ArrayOfRequisicaoRecusadaDTO
	WSDATA   oWSRequisicaoRecusadaDTO  AS Requisicao_RequisicaoRecusadaDTO OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Requisicao_ArrayOfRequisicaoRecusadaDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Requisicao_ArrayOfRequisicaoRecusadaDTO
	::oWSRequisicaoRecusadaDTO := {} // Array Of  Requisicao_REQUISICAORECUSADADTO():New()
Return

WSMETHOD CLONE WSCLIENT Requisicao_ArrayOfRequisicaoRecusadaDTO
	Local oClone := Requisicao_ArrayOfRequisicaoRecusadaDTO():NEW()
	oClone:oWSRequisicaoRecusadaDTO := NIL
	If ::oWSRequisicaoRecusadaDTO <> NIL 
		oClone:oWSRequisicaoRecusadaDTO := {}
		aEval( ::oWSRequisicaoRecusadaDTO , { |x| aadd( oClone:oWSRequisicaoRecusadaDTO , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Requisicao_ArrayOfRequisicaoRecusadaDTO
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_REQUISICAORECUSADADTO","RequisicaoRecusadaDTO",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSRequisicaoRecusadaDTO , Requisicao_RequisicaoRecusadaDTO():New() )
			::oWSRequisicaoRecusadaDTO[len(::oWSRequisicaoRecusadaDTO)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure ArrayOfRequisicaoCompradorAlteradoDTO

WSSTRUCT Requisicao_ArrayOfRequisicaoCompradorAlteradoDTO
	WSDATA   oWSRequisicaoCompradorAlteradoDTO AS Requisicao_RequisicaoCompradorAlteradoDTO OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Requisicao_ArrayOfRequisicaoCompradorAlteradoDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Requisicao_ArrayOfRequisicaoCompradorAlteradoDTO
	::oWSRequisicaoCompradorAlteradoDTO := {} // Array Of  Requisicao_REQUISICAOCOMPRADORALTERADODTO():New()
Return

WSMETHOD CLONE WSCLIENT Requisicao_ArrayOfRequisicaoCompradorAlteradoDTO
	Local oClone := Requisicao_ArrayOfRequisicaoCompradorAlteradoDTO():NEW()
	oClone:oWSRequisicaoCompradorAlteradoDTO := NIL
	If ::oWSRequisicaoCompradorAlteradoDTO <> NIL 
		oClone:oWSRequisicaoCompradorAlteradoDTO := {}
		aEval( ::oWSRequisicaoCompradorAlteradoDTO , { |x| aadd( oClone:oWSRequisicaoCompradorAlteradoDTO , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Requisicao_ArrayOfRequisicaoCompradorAlteradoDTO
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_REQUISICAOCOMPRADORALTERADODTO","RequisicaoCompradorAlteradoDTO",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSRequisicaoCompradorAlteradoDTO , Requisicao_RequisicaoCompradorAlteradoDTO():New() )
			::oWSRequisicaoCompradorAlteradoDTO[len(::oWSRequisicaoCompradorAlteradoDTO)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure RequisicaoDTO

WSSTRUCT Requisicao_RequisicaoDTO
	WSDATA   nbFlCritico               AS int OPTIONAL
	WSDATA   nbFlSubcontratacao        AS int OPTIONAL
	WSDATA   ndQtEntrega               AS decimal OPTIONAL
	WSDATA   ndVlOrcado                AS decimal OPTIONAL
	WSDATA   ndVlReferencia            AS decimal OPTIONAL
	WSDATA   oWSlstRequisicaoEmpresaDTO AS Requisicao_ArrayOfRequisicaoEmpresaDTO OPTIONAL
	WSDATA   oWSlstRequisicaoIdioma    AS Requisicao_ArrayOfRequisicaoIdiomaDTO OPTIONAL
	WSDATA   nnCdAplicacao             AS long OPTIONAL
	WSDATA   nnCdMarca                 AS long OPTIONAL
	WSDATA   nnCdMoeda                 AS long OPTIONAL
	WSDATA   nnCdOrigem                AS long OPTIONAL
	WSDATA   nnCdRequisicao            AS long OPTIONAL
	WSDATA   nnCdSituacao              AS long OPTIONAL
	WSDATA   nnIdTipoOrigem            AS long OPTIONAL
	WSDATA   nnIdTipoRequisicao        AS int OPTIONAL
	WSDATA   oWSoAplicacaoDetalhe      AS Requisicao_AplicacaoDetalheDTO OPTIONAL
	WSDATA   oWSoContaContabilDetalhe  AS Requisicao_ContaContabilDetalheDTO OPTIONAL
	WSDATA   oWSoCriterioDetalhe       AS Requisicao_CriterioDetalheDTO OPTIONAL
	WSDATA   oWSoMarcaDetalhe          AS Requisicao_MarcaDetalheDTO OPTIONAL
	WSDATA   oWSoNaturezaDespesaDetalhe AS Requisicao_NaturezaDespesaDetalheDTO OPTIONAL
	WSDATA   oWSoUnidadeMedidaDetalhe  AS Requisicao_UnidadeMedidaDetalheDTO OPTIONAL
	WSDATA   csCdCentroCusto           AS string OPTIONAL
	WSDATA   csCdClasse                AS string OPTIONAL
	WSDATA   csCdCobrancaEndereco      AS string OPTIONAL
	WSDATA   csCdContaContabil         AS string OPTIONAL
	WSDATA   csCdDepartamento          AS string OPTIONAL
	WSDATA   csCdEmpresa               AS string OPTIONAL
	WSDATA   csCdEmpresaCobrancaEndereco AS string OPTIONAL
	WSDATA   csCdEmpresaEntregaEndereco AS string OPTIONAL
	WSDATA   csCdEmpresaFaturamentoEndereco AS string OPTIONAL
	WSDATA   csCdEntregaEndereco       AS string OPTIONAL
	WSDATA   csCdFaturamentoEndereco   AS string OPTIONAL
	WSDATA   csCdFonteRecurso          AS string OPTIONAL
	WSDATA   csCdGrupoCompra           AS string OPTIONAL
	WSDATA   csCdItemEmpresa           AS string OPTIONAL
	WSDATA   csCdMarca                 AS string OPTIONAL
	WSDATA   csCdMoeda                 AS string OPTIONAL
	WSDATA   csCdNaturezaDespesa       AS string OPTIONAL
	WSDATA   csCdProduto               AS string OPTIONAL
	WSDATA   csCdProjeto               AS string OPTIONAL
	WSDATA   csCdRequisicaoEmpresa     AS string OPTIONAL
	WSDATA   csCdUnidadeMedida         AS string OPTIONAL
	WSDATA   csCdUnidadeNegocio        AS string OPTIONAL
	WSDATA   csCdUsuarioComprador      AS string OPTIONAL
	WSDATA   csCdUsuarioResponsavel    AS string OPTIONAL
	WSDATA   csDsAnexo                 AS string OPTIONAL
	WSDATA   csDsDetalheCliente        AS string OPTIONAL
	WSDATA   csDsJustificativa         AS string OPTIONAL
	WSDATA   csDsObservacao            AS string OPTIONAL
	WSDATA   csDsObservacaoInterna     AS string OPTIONAL
	WSDATA   csDsProdutoRequisicao     AS string OPTIONAL
	WSDATA   csNrOportunidade          AS string OPTIONAL
	WSDATA   csNrRecap                 AS string OPTIONAL
	WSDATA   ctDtCriacao               AS dateTime OPTIONAL
	WSDATA   ctDtEntrega               AS dateTime OPTIONAL
	WSDATA   ctDtLiberacao             AS dateTime OPTIONAL
	WSDATA   ctDtMoedaCotacao          AS dateTime OPTIONAL
	WSDATA   ctDtProcesso              AS dateTime OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Requisicao_RequisicaoDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Requisicao_RequisicaoDTO
Return

WSMETHOD CLONE WSCLIENT Requisicao_RequisicaoDTO
	Local oClone := Requisicao_RequisicaoDTO():NEW()
	oClone:nbFlCritico          := ::nbFlCritico
	oClone:nbFlSubcontratacao   := ::nbFlSubcontratacao
	oClone:ndQtEntrega          := ::ndQtEntrega
	oClone:ndVlOrcado           := ::ndVlOrcado
	oClone:ndVlReferencia       := ::ndVlReferencia
	oClone:oWSlstRequisicaoEmpresaDTO := IIF(::oWSlstRequisicaoEmpresaDTO = NIL , NIL , ::oWSlstRequisicaoEmpresaDTO:Clone() )
	oClone:oWSlstRequisicaoIdioma := IIF(::oWSlstRequisicaoIdioma = NIL , NIL , ::oWSlstRequisicaoIdioma:Clone() )
	oClone:nnCdAplicacao        := ::nnCdAplicacao
	oClone:nnCdMarca            := ::nnCdMarca
	oClone:nnCdMoeda            := ::nnCdMoeda
	oClone:nnCdOrigem           := ::nnCdOrigem
	oClone:nnCdRequisicao       := ::nnCdRequisicao
	oClone:nnCdSituacao         := ::nnCdSituacao
	oClone:nnIdTipoOrigem       := ::nnIdTipoOrigem
	oClone:nnIdTipoRequisicao   := ::nnIdTipoRequisicao
	oClone:oWSoAplicacaoDetalhe := IIF(::oWSoAplicacaoDetalhe = NIL , NIL , ::oWSoAplicacaoDetalhe:Clone() )
	oClone:oWSoContaContabilDetalhe := IIF(::oWSoContaContabilDetalhe = NIL , NIL , ::oWSoContaContabilDetalhe:Clone() )
	oClone:oWSoCriterioDetalhe  := IIF(::oWSoCriterioDetalhe = NIL , NIL , ::oWSoCriterioDetalhe:Clone() )
	oClone:oWSoMarcaDetalhe     := IIF(::oWSoMarcaDetalhe = NIL , NIL , ::oWSoMarcaDetalhe:Clone() )
	oClone:oWSoNaturezaDespesaDetalhe := IIF(::oWSoNaturezaDespesaDetalhe = NIL , NIL , ::oWSoNaturezaDespesaDetalhe:Clone() )
	oClone:oWSoUnidadeMedidaDetalhe := IIF(::oWSoUnidadeMedidaDetalhe = NIL , NIL , ::oWSoUnidadeMedidaDetalhe:Clone() )
	oClone:csCdCentroCusto      := ::csCdCentroCusto
	oClone:csCdClasse           := ::csCdClasse
	oClone:csCdCobrancaEndereco := ::csCdCobrancaEndereco
	oClone:csCdContaContabil    := ::csCdContaContabil
	oClone:csCdDepartamento     := ::csCdDepartamento
	oClone:csCdEmpresa          := ::csCdEmpresa
	oClone:csCdEmpresaCobrancaEndereco := ::csCdEmpresaCobrancaEndereco
	oClone:csCdEmpresaEntregaEndereco := ::csCdEmpresaEntregaEndereco
	oClone:csCdEmpresaFaturamentoEndereco := ::csCdEmpresaFaturamentoEndereco
	oClone:csCdEntregaEndereco  := ::csCdEntregaEndereco
	oClone:csCdFaturamentoEndereco := ::csCdFaturamentoEndereco
	oClone:csCdFonteRecurso     := ::csCdFonteRecurso
	oClone:csCdGrupoCompra      := ::csCdGrupoCompra
	oClone:csCdItemEmpresa      := ::csCdItemEmpresa
	oClone:csCdMarca            := ::csCdMarca
	oClone:csCdMoeda            := ::csCdMoeda
	oClone:csCdNaturezaDespesa  := ::csCdNaturezaDespesa
	oClone:csCdProduto          := ::csCdProduto
	oClone:csCdProjeto          := ::csCdProjeto
	oClone:csCdRequisicaoEmpresa := ::csCdRequisicaoEmpresa
	oClone:csCdUnidadeMedida    := ::csCdUnidadeMedida
	oClone:csCdUnidadeNegocio   := ::csCdUnidadeNegocio
	oClone:csCdUsuarioComprador := ::csCdUsuarioComprador
	oClone:csCdUsuarioResponsavel := ::csCdUsuarioResponsavel
	oClone:csDsAnexo            := ::csDsAnexo
	oClone:csDsDetalheCliente   := ::csDsDetalheCliente
	oClone:csDsJustificativa    := ::csDsJustificativa
	oClone:csDsObservacao       := ::csDsObservacao
	oClone:csDsObservacaoInterna := ::csDsObservacaoInterna
	oClone:csDsProdutoRequisicao := ::csDsProdutoRequisicao
	oClone:csNrOportunidade     := ::csNrOportunidade
	oClone:csNrRecap            := ::csNrRecap
	oClone:ctDtCriacao          := ::ctDtCriacao
	oClone:ctDtEntrega          := ::ctDtEntrega
	oClone:ctDtLiberacao        := ::ctDtLiberacao
	oClone:ctDtMoedaCotacao     := ::ctDtMoedaCotacao
	oClone:ctDtProcesso         := ::ctDtProcesso
Return oClone

WSMETHOD SOAPSEND WSCLIENT Requisicao_RequisicaoDTO
	Local cSoap := ""
	cSoap += WSSoapValue("bFlCritico", ::nbFlCritico, ::nbFlCritico , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("bFlSubcontratacao", ::nbFlSubcontratacao, ::nbFlSubcontratacao , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("dQtEntrega", ::ndQtEntrega, ::ndQtEntrega , "decimal", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("dVlOrcado", ::ndVlOrcado, ::ndVlOrcado , "decimal", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("dVlReferencia", ::ndVlReferencia, ::ndVlReferencia , "decimal", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("lstRequisicaoEmpresaDTO", ::oWSlstRequisicaoEmpresaDTO, ::oWSlstRequisicaoEmpresaDTO , "ArrayOfRequisicaoEmpresaDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("lstRequisicaoIdioma", ::oWSlstRequisicaoIdioma, ::oWSlstRequisicaoIdioma , "ArrayOfRequisicaoIdiomaDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("nCdAplicacao", ::nnCdAplicacao, ::nnCdAplicacao , "long", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("nCdMarca", ::nnCdMarca, ::nnCdMarca , "long", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("nCdMoeda", ::nnCdMoeda, ::nnCdMoeda , "long", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("nCdOrigem", ::nnCdOrigem, ::nnCdOrigem , "long", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("nCdRequisicao", ::nnCdRequisicao, ::nnCdRequisicao , "long", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("nCdSituacao", ::nnCdSituacao, ::nnCdSituacao , "long", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("nIdTipoOrigem", ::nnIdTipoOrigem, ::nnIdTipoOrigem , "long", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("nIdTipoRequisicao", ::nnIdTipoRequisicao, ::nnIdTipoRequisicao , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("oAplicacaoDetalhe", ::oWSoAplicacaoDetalhe, ::oWSoAplicacaoDetalhe , "AplicacaoDetalheDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("oContaContabilDetalhe", ::oWSoContaContabilDetalhe, ::oWSoContaContabilDetalhe , "ContaContabilDetalheDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("oCriterioDetalhe", ::oWSoCriterioDetalhe, ::oWSoCriterioDetalhe , "CriterioDetalheDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("oMarcaDetalhe", ::oWSoMarcaDetalhe, ::oWSoMarcaDetalhe , "MarcaDetalheDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("oNaturezaDespesaDetalhe", ::oWSoNaturezaDespesaDetalhe, ::oWSoNaturezaDespesaDetalhe , "NaturezaDespesaDetalheDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("oUnidadeMedidaDetalhe", ::oWSoUnidadeMedidaDetalhe, ::oWSoUnidadeMedidaDetalhe , "UnidadeMedidaDetalheDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdCentroCusto", ::csCdCentroCusto, ::csCdCentroCusto , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdClasse", ::csCdClasse, ::csCdClasse , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdCobrancaEndereco", ::csCdCobrancaEndereco, ::csCdCobrancaEndereco , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdContaContabil", ::csCdContaContabil, ::csCdContaContabil , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdDepartamento", ::csCdDepartamento, ::csCdDepartamento , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdEmpresa", ::csCdEmpresa, ::csCdEmpresa , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdEmpresaCobrancaEndereco", ::csCdEmpresaCobrancaEndereco, ::csCdEmpresaCobrancaEndereco , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdEmpresaEntregaEndereco", ::csCdEmpresaEntregaEndereco, ::csCdEmpresaEntregaEndereco , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdEmpresaFaturamentoEndereco", ::csCdEmpresaFaturamentoEndereco, ::csCdEmpresaFaturamentoEndereco , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdEntregaEndereco", ::csCdEntregaEndereco, ::csCdEntregaEndereco , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdFaturamentoEndereco", ::csCdFaturamentoEndereco, ::csCdFaturamentoEndereco , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdFonteRecurso", ::csCdFonteRecurso, ::csCdFonteRecurso , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdGrupoCompra", ::csCdGrupoCompra, ::csCdGrupoCompra , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdItemEmpresa", ::csCdItemEmpresa, ::csCdItemEmpresa , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdMarca", ::csCdMarca, ::csCdMarca , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdMoeda", ::csCdMoeda, ::csCdMoeda , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdNaturezaDespesa", ::csCdNaturezaDespesa, ::csCdNaturezaDespesa , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdProduto", ::csCdProduto, ::csCdProduto , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdProjeto", ::csCdProjeto, ::csCdProjeto , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdRequisicaoEmpresa", ::csCdRequisicaoEmpresa, ::csCdRequisicaoEmpresa , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdUnidadeMedida", ::csCdUnidadeMedida, ::csCdUnidadeMedida , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdUnidadeNegocio", ::csCdUnidadeNegocio, ::csCdUnidadeNegocio , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdUsuarioComprador", ::csCdUsuarioComprador, ::csCdUsuarioComprador , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdUsuarioResponsavel", ::csCdUsuarioResponsavel, ::csCdUsuarioResponsavel , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sDsAnexo", ::csDsAnexo, ::csDsAnexo , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sDsDetalheCliente", ::csDsDetalheCliente, ::csDsDetalheCliente , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sDsJustificativa", ::csDsJustificativa, ::csDsJustificativa , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sDsObservacao", ::csDsObservacao, ::csDsObservacao , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sDsObservacaoInterna", ::csDsObservacaoInterna, ::csDsObservacaoInterna , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sDsProdutoRequisicao", ::csDsProdutoRequisicao, ::csDsProdutoRequisicao , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sNrOportunidade", ::csNrOportunidade, ::csNrOportunidade , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sNrRecap", ::csNrRecap, ::csNrRecap , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("tDtCriacao", ::ctDtCriacao, ::ctDtCriacao , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("tDtEntrega", ::ctDtEntrega, ::ctDtEntrega , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("tDtLiberacao", ::ctDtLiberacao, ::ctDtLiberacao , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("tDtMoedaCotacao", ::ctDtMoedaCotacao, ::ctDtMoedaCotacao , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("tDtProcesso", ::ctDtProcesso, ::ctDtProcesso , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Requisicao_RequisicaoDTO
	Local oNode6
	Local oNode7
	Local oNode16
	Local oNode17
	Local oNode18
	Local oNode19
	Local oNode20
	Local oNode21
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::nbFlCritico        :=  WSAdvValue( oResponse,"_BFLCRITICO","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::nbFlSubcontratacao :=  WSAdvValue( oResponse,"_BFLSUBCONTRATACAO","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::ndQtEntrega        :=  WSAdvValue( oResponse,"_DQTENTREGA","decimal",NIL,NIL,NIL,"N",NIL,NIL) 
	::ndVlOrcado         :=  WSAdvValue( oResponse,"_DVLORCADO","decimal",NIL,NIL,NIL,"N",NIL,NIL) 
	::ndVlReferencia     :=  WSAdvValue( oResponse,"_DVLREFERENCIA","decimal",NIL,NIL,NIL,"N",NIL,NIL) 
	oNode6 :=  WSAdvValue( oResponse,"_LSTREQUISICAOEMPRESADTO","ArrayOfRequisicaoEmpresaDTO",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode6 != NIL
		::oWSlstRequisicaoEmpresaDTO := Requisicao_ArrayOfRequisicaoEmpresaDTO():New()
		::oWSlstRequisicaoEmpresaDTO:SoapRecv(oNode6)
	EndIf
	oNode7 :=  WSAdvValue( oResponse,"_LSTREQUISICAOIDIOMA","ArrayOfRequisicaoIdiomaDTO",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode7 != NIL
		::oWSlstRequisicaoIdioma := Requisicao_ArrayOfRequisicaoIdiomaDTO():New()
		::oWSlstRequisicaoIdioma:SoapRecv(oNode7)
	EndIf
	::nnCdAplicacao      :=  WSAdvValue( oResponse,"_NCDAPLICACAO","long",NIL,NIL,NIL,"N",NIL,NIL) 
	::nnCdMarca          :=  WSAdvValue( oResponse,"_NCDMARCA","long",NIL,NIL,NIL,"N",NIL,NIL) 
	::nnCdMoeda          :=  WSAdvValue( oResponse,"_NCDMOEDA","long",NIL,NIL,NIL,"N",NIL,NIL) 
	::nnCdOrigem         :=  WSAdvValue( oResponse,"_NCDORIGEM","long",NIL,NIL,NIL,"N",NIL,NIL) 
	::nnCdRequisicao     :=  WSAdvValue( oResponse,"_NCDREQUISICAO","long",NIL,NIL,NIL,"N",NIL,NIL) 
	::nnCdSituacao       :=  WSAdvValue( oResponse,"_NCDSITUACAO","long",NIL,NIL,NIL,"N",NIL,NIL) 
	::nnIdTipoOrigem     :=  WSAdvValue( oResponse,"_NIDTIPOORIGEM","long",NIL,NIL,NIL,"N",NIL,NIL) 
	::nnIdTipoRequisicao :=  WSAdvValue( oResponse,"_NIDTIPOREQUISICAO","int",NIL,NIL,NIL,"N",NIL,NIL) 
	oNode16 :=  WSAdvValue( oResponse,"_OAPLICACAODETALHE","AplicacaoDetalheDTO",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode16 != NIL
		::oWSoAplicacaoDetalhe := Requisicao_AplicacaoDetalheDTO():New()
		::oWSoAplicacaoDetalhe:SoapRecv(oNode16)
	EndIf
	oNode17 :=  WSAdvValue( oResponse,"_OCONTACONTABILDETALHE","ContaContabilDetalheDTO",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode17 != NIL
		::oWSoContaContabilDetalhe := Requisicao_ContaContabilDetalheDTO():New()
		::oWSoContaContabilDetalhe:SoapRecv(oNode17)
	EndIf
	oNode18 :=  WSAdvValue( oResponse,"_OCRITERIODETALHE","CriterioDetalheDTO",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode18 != NIL
		::oWSoCriterioDetalhe := Requisicao_CriterioDetalheDTO():New()
		::oWSoCriterioDetalhe:SoapRecv(oNode18)
	EndIf
	oNode19 :=  WSAdvValue( oResponse,"_OMARCADETALHE","MarcaDetalheDTO",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode19 != NIL
		::oWSoMarcaDetalhe := Requisicao_MarcaDetalheDTO():New()
		::oWSoMarcaDetalhe:SoapRecv(oNode19)
	EndIf
	oNode20 :=  WSAdvValue( oResponse,"_ONATUREZADESPESADETALHE","NaturezaDespesaDetalheDTO",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode20 != NIL
		::oWSoNaturezaDespesaDetalhe := Requisicao_NaturezaDespesaDetalheDTO():New()
		::oWSoNaturezaDespesaDetalhe:SoapRecv(oNode20)
	EndIf
	oNode21 :=  WSAdvValue( oResponse,"_OUNIDADEMEDIDADETALHE","UnidadeMedidaDetalheDTO",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode21 != NIL
		::oWSoUnidadeMedidaDetalhe := Requisicao_UnidadeMedidaDetalheDTO():New()
		::oWSoUnidadeMedidaDetalhe:SoapRecv(oNode21)
	EndIf
	::csCdCentroCusto    :=  WSAdvValue( oResponse,"_SCDCENTROCUSTO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdClasse         :=  WSAdvValue( oResponse,"_SCDCLASSE","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdCobrancaEndereco :=  WSAdvValue( oResponse,"_SCDCOBRANCAENDERECO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdContaContabil  :=  WSAdvValue( oResponse,"_SCDCONTACONTABIL","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdDepartamento   :=  WSAdvValue( oResponse,"_SCDDEPARTAMENTO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdEmpresa        :=  WSAdvValue( oResponse,"_SCDEMPRESA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdEmpresaCobrancaEndereco :=  WSAdvValue( oResponse,"_SCDEMPRESACOBRANCAENDERECO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdEmpresaEntregaEndereco :=  WSAdvValue( oResponse,"_SCDEMPRESAENTREGAENDERECO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdEmpresaFaturamentoEndereco :=  WSAdvValue( oResponse,"_SCDEMPRESAFATURAMENTOENDERECO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdEntregaEndereco :=  WSAdvValue( oResponse,"_SCDENTREGAENDERECO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdFaturamentoEndereco :=  WSAdvValue( oResponse,"_SCDFATURAMENTOENDERECO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdFonteRecurso   :=  WSAdvValue( oResponse,"_SCDFONTERECURSO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdGrupoCompra    :=  WSAdvValue( oResponse,"_SCDGRUPOCOMPRA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdItemEmpresa    :=  WSAdvValue( oResponse,"_SCDITEMEMPRESA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdMarca          :=  WSAdvValue( oResponse,"_SCDMARCA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdMoeda          :=  WSAdvValue( oResponse,"_SCDMOEDA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdNaturezaDespesa :=  WSAdvValue( oResponse,"_SCDNATUREZADESPESA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdProduto        :=  WSAdvValue( oResponse,"_SCDPRODUTO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdProjeto        :=  WSAdvValue( oResponse,"_SCDPROJETO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdRequisicaoEmpresa :=  WSAdvValue( oResponse,"_SCDREQUISICAOEMPRESA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdUnidadeMedida  :=  WSAdvValue( oResponse,"_SCDUNIDADEMEDIDA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdUnidadeNegocio :=  WSAdvValue( oResponse,"_SCDUNIDADENEGOCIO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdUsuarioComprador :=  WSAdvValue( oResponse,"_SCDUSUARIOCOMPRADOR","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdUsuarioResponsavel :=  WSAdvValue( oResponse,"_SCDUSUARIORESPONSAVEL","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csDsAnexo          :=  WSAdvValue( oResponse,"_SDSANEXO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csDsDetalheCliente :=  WSAdvValue( oResponse,"_SDSDETALHECLIENTE","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csDsJustificativa  :=  WSAdvValue( oResponse,"_SDSJUSTIFICATIVA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csDsObservacao     :=  WSAdvValue( oResponse,"_SDSOBSERVACAO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csDsObservacaoInterna :=  WSAdvValue( oResponse,"_SDSOBSERVACAOINTERNA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csDsProdutoRequisicao :=  WSAdvValue( oResponse,"_SDSPRODUTOREQUISICAO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csNrOportunidade   :=  WSAdvValue( oResponse,"_SNROPORTUNIDADE","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csNrRecap          :=  WSAdvValue( oResponse,"_SNRRECAP","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::ctDtCriacao        :=  WSAdvValue( oResponse,"_TDTCRIACAO","dateTime",NIL,NIL,NIL,"S",NIL,NIL) 
	::ctDtEntrega        :=  WSAdvValue( oResponse,"_TDTENTREGA","dateTime",NIL,NIL,NIL,"S",NIL,NIL) 
	::ctDtLiberacao      :=  WSAdvValue( oResponse,"_TDTLIBERACAO","dateTime",NIL,NIL,NIL,"S",NIL,NIL) 
	::ctDtMoedaCotacao   :=  WSAdvValue( oResponse,"_TDTMOEDACOTACAO","dateTime",NIL,NIL,NIL,"S",NIL,NIL) 
	::ctDtProcesso       :=  WSAdvValue( oResponse,"_TDTPROCESSO","dateTime",NIL,NIL,NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure ArrayOfWbtLogDTO

WSSTRUCT Requisicao_ArrayOfWbtLogDTO
	WSDATA   oWSWbtLogDTO              AS Requisicao_WbtLogDTO OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Requisicao_ArrayOfWbtLogDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Requisicao_ArrayOfWbtLogDTO
	::oWSWbtLogDTO         := {} // Array Of  Requisicao_WBTLOGDTO():New()
Return

WSMETHOD CLONE WSCLIENT Requisicao_ArrayOfWbtLogDTO
	Local oClone := Requisicao_ArrayOfWbtLogDTO():NEW()
	oClone:oWSWbtLogDTO := NIL
	If ::oWSWbtLogDTO <> NIL 
		oClone:oWSWbtLogDTO := {}
		aEval( ::oWSWbtLogDTO , { |x| aadd( oClone:oWSWbtLogDTO , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Requisicao_ArrayOfWbtLogDTO
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_WBTLOGDTO","WbtLogDTO",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSWbtLogDTO , Requisicao_WbtLogDTO():New() )
			::oWSWbtLogDTO[len(::oWSWbtLogDTO)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure RequisicaoAtualizarDTO

WSSTRUCT Requisicao_RequisicaoAtualizarDTO
	WSDATA   nnCdOrigem                AS long OPTIONAL
	WSDATA   nnCdSituacao              AS long OPTIONAL
	WSDATA   nnIdTipoOrigem            AS long OPTIONAL
	WSDATA   csCdEmpresa               AS string OPTIONAL
	WSDATA   csCdItemEmpresa           AS string OPTIONAL
	WSDATA   csCdRequisicaoEmpresa     AS string OPTIONAL
	WSDATA   csNrProcessoOrigem        AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Requisicao_RequisicaoAtualizarDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Requisicao_RequisicaoAtualizarDTO
Return

WSMETHOD CLONE WSCLIENT Requisicao_RequisicaoAtualizarDTO
	Local oClone := Requisicao_RequisicaoAtualizarDTO():NEW()
	oClone:nnCdOrigem           := ::nnCdOrigem
	oClone:nnCdSituacao         := ::nnCdSituacao
	oClone:nnIdTipoOrigem       := ::nnIdTipoOrigem
	oClone:csCdEmpresa          := ::csCdEmpresa
	oClone:csCdItemEmpresa      := ::csCdItemEmpresa
	oClone:csCdRequisicaoEmpresa := ::csCdRequisicaoEmpresa
	oClone:csNrProcessoOrigem   := ::csNrProcessoOrigem
Return oClone

WSMETHOD SOAPSEND WSCLIENT Requisicao_RequisicaoAtualizarDTO
	Local cSoap := ""
	cSoap += WSSoapValue("nCdOrigem", ::nnCdOrigem, ::nnCdOrigem , "long", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("nCdSituacao", ::nnCdSituacao, ::nnCdSituacao , "long", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("nIdTipoOrigem", ::nnIdTipoOrigem, ::nnIdTipoOrigem , "long", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdEmpresa", ::csCdEmpresa, ::csCdEmpresa , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdItemEmpresa", ::csCdItemEmpresa, ::csCdItemEmpresa , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdRequisicaoEmpresa", ::csCdRequisicaoEmpresa, ::csCdRequisicaoEmpresa , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sNrProcessoOrigem", ::csNrProcessoOrigem, ::csNrProcessoOrigem , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Requisicao_RequisicaoAtualizarDTO
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::nnCdOrigem         :=  WSAdvValue( oResponse,"_NCDORIGEM","long",NIL,NIL,NIL,"N",NIL,NIL) 
	::nnCdSituacao       :=  WSAdvValue( oResponse,"_NCDSITUACAO","long",NIL,NIL,NIL,"N",NIL,NIL) 
	::nnIdTipoOrigem     :=  WSAdvValue( oResponse,"_NIDTIPOORIGEM","long",NIL,NIL,NIL,"N",NIL,NIL) 
	::csCdEmpresa        :=  WSAdvValue( oResponse,"_SCDEMPRESA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdItemEmpresa    :=  WSAdvValue( oResponse,"_SCDITEMEMPRESA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdRequisicaoEmpresa :=  WSAdvValue( oResponse,"_SCDREQUISICAOEMPRESA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csNrProcessoOrigem :=  WSAdvValue( oResponse,"_SNRPROCESSOORIGEM","string",NIL,NIL,NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure RequisicaoEntregaAtualizarDTO

WSSTRUCT Requisicao_RequisicaoEntregaAtualizarDTO
	WSDATA   oWSlstRequisicaoEntregaDTO AS Requisicao_ArrayOfRequisicaoEntregaDTO OPTIONAL
	WSDATA   csCdRequisicaoEmpresa     AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Requisicao_RequisicaoEntregaAtualizarDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Requisicao_RequisicaoEntregaAtualizarDTO
Return

WSMETHOD CLONE WSCLIENT Requisicao_RequisicaoEntregaAtualizarDTO
	Local oClone := Requisicao_RequisicaoEntregaAtualizarDTO():NEW()
	oClone:oWSlstRequisicaoEntregaDTO := IIF(::oWSlstRequisicaoEntregaDTO = NIL , NIL , ::oWSlstRequisicaoEntregaDTO:Clone() )
	oClone:csCdRequisicaoEmpresa := ::csCdRequisicaoEmpresa
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Requisicao_RequisicaoEntregaAtualizarDTO
	Local oNode1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_LSTREQUISICAOENTREGADTO","ArrayOfRequisicaoEntregaDTO",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode1 != NIL
		::oWSlstRequisicaoEntregaDTO := Requisicao_ArrayOfRequisicaoEntregaDTO():New()
		::oWSlstRequisicaoEntregaDTO:SoapRecv(oNode1)
	EndIf
	::csCdRequisicaoEmpresa :=  WSAdvValue( oResponse,"_SCDREQUISICAOEMPRESA","string",NIL,NIL,NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure RequisicaoAcompanhamentoDTO

WSSTRUCT Requisicao_RequisicaoAcompanhamentoDTO
	WSDATA   csCdCotacaoERP            AS string OPTIONAL
	WSDATA   csCdEmpresa               AS string OPTIONAL
	WSDATA   csCdItemEmpresa           AS string OPTIONAL
	WSDATA   csCdRequisicaoEmpresa     AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Requisicao_RequisicaoAcompanhamentoDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Requisicao_RequisicaoAcompanhamentoDTO
Return

WSMETHOD CLONE WSCLIENT Requisicao_RequisicaoAcompanhamentoDTO
	Local oClone := Requisicao_RequisicaoAcompanhamentoDTO():NEW()
	oClone:csCdCotacaoERP       := ::csCdCotacaoERP
	oClone:csCdEmpresa          := ::csCdEmpresa
	oClone:csCdItemEmpresa      := ::csCdItemEmpresa
	oClone:csCdRequisicaoEmpresa := ::csCdRequisicaoEmpresa
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Requisicao_RequisicaoAcompanhamentoDTO
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::csCdCotacaoERP     :=  WSAdvValue( oResponse,"_SCDCOTACAOERP","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdEmpresa        :=  WSAdvValue( oResponse,"_SCDEMPRESA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdItemEmpresa    :=  WSAdvValue( oResponse,"_SCDITEMEMPRESA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdRequisicaoEmpresa :=  WSAdvValue( oResponse,"_SCDREQUISICAOEMPRESA","string",NIL,NIL,NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure ArrayOfRequisicaoHistoricoSituacaoDTO

WSSTRUCT Requisicao_ArrayOfRequisicaoHistoricoSituacaoDTO
	WSDATA   oWSRequisicaoHistoricoSituacaoDTO AS Requisicao_RequisicaoHistoricoSituacaoDTO OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Requisicao_ArrayOfRequisicaoHistoricoSituacaoDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Requisicao_ArrayOfRequisicaoHistoricoSituacaoDTO
	::oWSRequisicaoHistoricoSituacaoDTO := {} // Array Of  Requisicao_REQUISICAOHISTORICOSITUACAODTO():New()
Return

WSMETHOD CLONE WSCLIENT Requisicao_ArrayOfRequisicaoHistoricoSituacaoDTO
	Local oClone := Requisicao_ArrayOfRequisicaoHistoricoSituacaoDTO():NEW()
	oClone:oWSRequisicaoHistoricoSituacaoDTO := NIL
	If ::oWSRequisicaoHistoricoSituacaoDTO <> NIL 
		oClone:oWSRequisicaoHistoricoSituacaoDTO := {}
		aEval( ::oWSRequisicaoHistoricoSituacaoDTO , { |x| aadd( oClone:oWSRequisicaoHistoricoSituacaoDTO , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Requisicao_ArrayOfRequisicaoHistoricoSituacaoDTO
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_REQUISICAOHISTORICOSITUACAODTO","RequisicaoHistoricoSituacaoDTO",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSRequisicaoHistoricoSituacaoDTO , Requisicao_RequisicaoHistoricoSituacaoDTO():New() )
			::oWSRequisicaoHistoricoSituacaoDTO[len(::oWSRequisicaoHistoricoSituacaoDTO)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure ContratoResumoDTO

WSSTRUCT Requisicao_ContratoResumoDTO
	WSDATA   ndQtSaldoAtualItem        AS decimal OPTIONAL
	WSDATA   csCdContrato              AS string OPTIONAL
	WSDATA   csDsContrato              AS string OPTIONAL
	WSDATA   csDsSituacao              AS string OPTIONAL
	WSDATA   csNmEmpresaContratada     AS string OPTIONAL
	WSDATA   csNmEmpresaContratante    AS string OPTIONAL
	WSDATA   ctDtFinal                 AS dateTime OPTIONAL
	WSDATA   ctDtInicial               AS dateTime OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Requisicao_ContratoResumoDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Requisicao_ContratoResumoDTO
Return

WSMETHOD CLONE WSCLIENT Requisicao_ContratoResumoDTO
	Local oClone := Requisicao_ContratoResumoDTO():NEW()
	oClone:ndQtSaldoAtualItem   := ::ndQtSaldoAtualItem
	oClone:csCdContrato         := ::csCdContrato
	oClone:csDsContrato         := ::csDsContrato
	oClone:csDsSituacao         := ::csDsSituacao
	oClone:csNmEmpresaContratada := ::csNmEmpresaContratada
	oClone:csNmEmpresaContratante := ::csNmEmpresaContratante
	oClone:ctDtFinal            := ::ctDtFinal
	oClone:ctDtInicial          := ::ctDtInicial
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Requisicao_ContratoResumoDTO
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::ndQtSaldoAtualItem :=  WSAdvValue( oResponse,"_DQTSALDOATUALITEM","decimal",NIL,NIL,NIL,"N",NIL,NIL) 
	::csCdContrato       :=  WSAdvValue( oResponse,"_SCDCONTRATO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csDsContrato       :=  WSAdvValue( oResponse,"_SDSCONTRATO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csDsSituacao       :=  WSAdvValue( oResponse,"_SDSSITUACAO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csNmEmpresaContratada :=  WSAdvValue( oResponse,"_SNMEMPRESACONTRATADA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csNmEmpresaContratante :=  WSAdvValue( oResponse,"_SNMEMPRESACONTRATANTE","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::ctDtFinal          :=  WSAdvValue( oResponse,"_TDTFINAL","dateTime",NIL,NIL,NIL,"S",NIL,NIL) 
	::ctDtInicial        :=  WSAdvValue( oResponse,"_TDTINICIAL","dateTime",NIL,NIL,NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure ModalidadePresencialResumoDTO

WSSTRUCT Requisicao_ModalidadePresencialResumoDTO
	WSDATA   csNmPresencialTipo        AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Requisicao_ModalidadePresencialResumoDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Requisicao_ModalidadePresencialResumoDTO
Return

WSMETHOD CLONE WSCLIENT Requisicao_ModalidadePresencialResumoDTO
	Local oClone := Requisicao_ModalidadePresencialResumoDTO():NEW()
	oClone:csNmPresencialTipo   := ::csNmPresencialTipo
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Requisicao_ModalidadePresencialResumoDTO
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::csNmPresencialTipo :=  WSAdvValue( oResponse,"_SNMPRESENCIALTIPO","string",NIL,NIL,NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure PedidoResumoDTO

WSSTRUCT Requisicao_PedidoResumoDTO
	WSDATA   ndVlTotal                 AS decimal OPTIONAL
	WSDATA   csDsSituacao              AS string OPTIONAL
	WSDATA   csNmEmpresaCompradora     AS string OPTIONAL
	WSDATA   csNmEmpresaFornecedora    AS string OPTIONAL
	WSDATA   csNrCnpjEmpresaCompradora AS string OPTIONAL
	WSDATA   csNrCnpjEmpresaFornecedora AS string OPTIONAL
	WSDATA   csNrPedido                AS string OPTIONAL
	WSDATA   ctDtCriacao               AS dateTime OPTIONAL
	WSDATA   ctDtEmissao               AS dateTime OPTIONAL
	WSDATA   ctDtEntrega               AS dateTime OPTIONAL
	WSDATA   ctDtFaturamento           AS dateTime OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Requisicao_PedidoResumoDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Requisicao_PedidoResumoDTO
Return

WSMETHOD CLONE WSCLIENT Requisicao_PedidoResumoDTO
	Local oClone := Requisicao_PedidoResumoDTO():NEW()
	oClone:ndVlTotal            := ::ndVlTotal
	oClone:csDsSituacao         := ::csDsSituacao
	oClone:csNmEmpresaCompradora := ::csNmEmpresaCompradora
	oClone:csNmEmpresaFornecedora := ::csNmEmpresaFornecedora
	oClone:csNrCnpjEmpresaCompradora := ::csNrCnpjEmpresaCompradora
	oClone:csNrCnpjEmpresaFornecedora := ::csNrCnpjEmpresaFornecedora
	oClone:csNrPedido           := ::csNrPedido
	oClone:ctDtCriacao          := ::ctDtCriacao
	oClone:ctDtEmissao          := ::ctDtEmissao
	oClone:ctDtEntrega          := ::ctDtEntrega
	oClone:ctDtFaturamento      := ::ctDtFaturamento
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Requisicao_PedidoResumoDTO
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::ndVlTotal          :=  WSAdvValue( oResponse,"_DVLTOTAL","decimal",NIL,NIL,NIL,"N",NIL,NIL) 
	::csDsSituacao       :=  WSAdvValue( oResponse,"_SDSSITUACAO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csNmEmpresaCompradora :=  WSAdvValue( oResponse,"_SNMEMPRESACOMPRADORA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csNmEmpresaFornecedora :=  WSAdvValue( oResponse,"_SNMEMPRESAFORNECEDORA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csNrCnpjEmpresaCompradora :=  WSAdvValue( oResponse,"_SNRCNPJEMPRESACOMPRADORA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csNrCnpjEmpresaFornecedora :=  WSAdvValue( oResponse,"_SNRCNPJEMPRESAFORNECEDORA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csNrPedido         :=  WSAdvValue( oResponse,"_SNRPEDIDO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::ctDtCriacao        :=  WSAdvValue( oResponse,"_TDTCRIACAO","dateTime",NIL,NIL,NIL,"S",NIL,NIL) 
	::ctDtEmissao        :=  WSAdvValue( oResponse,"_TDTEMISSAO","dateTime",NIL,NIL,NIL,"S",NIL,NIL) 
	::ctDtEntrega        :=  WSAdvValue( oResponse,"_TDTENTREGA","dateTime",NIL,NIL,NIL,"S",NIL,NIL) 
	::ctDtFaturamento    :=  WSAdvValue( oResponse,"_TDTFATURAMENTO","dateTime",NIL,NIL,NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure RequisicaoRecusadaDTO

WSSTRUCT Requisicao_RequisicaoRecusadaDTO
	WSDATA   csCdEmpresa               AS string OPTIONAL
	WSDATA   csCdItemRequisicaoEmpresa AS string OPTIONAL
	WSDATA   csCdRequisicaoEmpresa     AS string OPTIONAL
	WSDATA   csCdUsuarioRecusa         AS string OPTIONAL
	WSDATA   csDsJustificativaRecusa   AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Requisicao_RequisicaoRecusadaDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Requisicao_RequisicaoRecusadaDTO
Return

WSMETHOD CLONE WSCLIENT Requisicao_RequisicaoRecusadaDTO
	Local oClone := Requisicao_RequisicaoRecusadaDTO():NEW()
	oClone:csCdEmpresa          := ::csCdEmpresa
	oClone:csCdItemRequisicaoEmpresa := ::csCdItemRequisicaoEmpresa
	oClone:csCdRequisicaoEmpresa := ::csCdRequisicaoEmpresa
	oClone:csCdUsuarioRecusa    := ::csCdUsuarioRecusa
	oClone:csDsJustificativaRecusa := ::csDsJustificativaRecusa
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Requisicao_RequisicaoRecusadaDTO
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::csCdEmpresa        :=  WSAdvValue( oResponse,"_SCDEMPRESA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdItemRequisicaoEmpresa :=  WSAdvValue( oResponse,"_SCDITEMREQUISICAOEMPRESA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdRequisicaoEmpresa :=  WSAdvValue( oResponse,"_SCDREQUISICAOEMPRESA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdUsuarioRecusa  :=  WSAdvValue( oResponse,"_SCDUSUARIORECUSA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csDsJustificativaRecusa :=  WSAdvValue( oResponse,"_SDSJUSTIFICATIVARECUSA","string",NIL,NIL,NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure RequisicaoCompradorAlteradoDTO

WSSTRUCT Requisicao_RequisicaoCompradorAlteradoDTO
	WSDATA   csCdItemRequisicaoEmpresa AS string OPTIONAL
	WSDATA   csCdRequisicaoEmpresa     AS string OPTIONAL
	WSDATA   csCdUsuarioComprador      AS string OPTIONAL
	WSDATA   csDsEmailContato          AS string OPTIONAL
	WSDATA   csNmUsuario               AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Requisicao_RequisicaoCompradorAlteradoDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Requisicao_RequisicaoCompradorAlteradoDTO
Return

WSMETHOD CLONE WSCLIENT Requisicao_RequisicaoCompradorAlteradoDTO
	Local oClone := Requisicao_RequisicaoCompradorAlteradoDTO():NEW()
	oClone:csCdItemRequisicaoEmpresa := ::csCdItemRequisicaoEmpresa
	oClone:csCdRequisicaoEmpresa := ::csCdRequisicaoEmpresa
	oClone:csCdUsuarioComprador := ::csCdUsuarioComprador
	oClone:csDsEmailContato     := ::csDsEmailContato
	oClone:csNmUsuario          := ::csNmUsuario
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Requisicao_RequisicaoCompradorAlteradoDTO
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::csCdItemRequisicaoEmpresa :=  WSAdvValue( oResponse,"_SCDITEMREQUISICAOEMPRESA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdRequisicaoEmpresa :=  WSAdvValue( oResponse,"_SCDREQUISICAOEMPRESA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdUsuarioComprador :=  WSAdvValue( oResponse,"_SCDUSUARIOCOMPRADOR","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csDsEmailContato   :=  WSAdvValue( oResponse,"_SDSEMAILCONTATO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csNmUsuario        :=  WSAdvValue( oResponse,"_SNMUSUARIO","string",NIL,NIL,NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure ArrayOfRequisicaoEmpresaDTO

WSSTRUCT Requisicao_ArrayOfRequisicaoEmpresaDTO
	WSDATA   oWSRequisicaoEmpresaDTO   AS Requisicao_RequisicaoEmpresaDTO OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Requisicao_ArrayOfRequisicaoEmpresaDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Requisicao_ArrayOfRequisicaoEmpresaDTO
	::oWSRequisicaoEmpresaDTO := {} // Array Of  Requisicao_REQUISICAOEMPRESADTO():New()
Return

WSMETHOD CLONE WSCLIENT Requisicao_ArrayOfRequisicaoEmpresaDTO
	Local oClone := Requisicao_ArrayOfRequisicaoEmpresaDTO():NEW()
	oClone:oWSRequisicaoEmpresaDTO := NIL
	If ::oWSRequisicaoEmpresaDTO <> NIL 
		oClone:oWSRequisicaoEmpresaDTO := {}
		aEval( ::oWSRequisicaoEmpresaDTO , { |x| aadd( oClone:oWSRequisicaoEmpresaDTO , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT Requisicao_ArrayOfRequisicaoEmpresaDTO
	Local cSoap := ""
	aEval( ::oWSRequisicaoEmpresaDTO , {|x| cSoap := cSoap  +  WSSoapValue("RequisicaoEmpresaDTO", x , x , "RequisicaoEmpresaDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.)  } ) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Requisicao_ArrayOfRequisicaoEmpresaDTO
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_REQUISICAOEMPRESADTO","RequisicaoEmpresaDTO",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSRequisicaoEmpresaDTO , Requisicao_RequisicaoEmpresaDTO():New() )
			::oWSRequisicaoEmpresaDTO[len(::oWSRequisicaoEmpresaDTO)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure ArrayOfRequisicaoIdiomaDTO

WSSTRUCT Requisicao_ArrayOfRequisicaoIdiomaDTO
	WSDATA   oWSRequisicaoIdiomaDTO    AS Requisicao_RequisicaoIdiomaDTO OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Requisicao_ArrayOfRequisicaoIdiomaDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Requisicao_ArrayOfRequisicaoIdiomaDTO
	::oWSRequisicaoIdiomaDTO := {} // Array Of  Requisicao_REQUISICAOIDIOMADTO():New()
Return

WSMETHOD CLONE WSCLIENT Requisicao_ArrayOfRequisicaoIdiomaDTO
	Local oClone := Requisicao_ArrayOfRequisicaoIdiomaDTO():NEW()
	oClone:oWSRequisicaoIdiomaDTO := NIL
	If ::oWSRequisicaoIdiomaDTO <> NIL 
		oClone:oWSRequisicaoIdiomaDTO := {}
		aEval( ::oWSRequisicaoIdiomaDTO , { |x| aadd( oClone:oWSRequisicaoIdiomaDTO , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT Requisicao_ArrayOfRequisicaoIdiomaDTO
	Local cSoap := ""
	aEval( ::oWSRequisicaoIdiomaDTO , {|x| cSoap := cSoap  +  WSSoapValue("RequisicaoIdiomaDTO", x , x , "RequisicaoIdiomaDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.)  } ) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Requisicao_ArrayOfRequisicaoIdiomaDTO
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_REQUISICAOIDIOMADTO","RequisicaoIdiomaDTO",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSRequisicaoIdiomaDTO , Requisicao_RequisicaoIdiomaDTO():New() )
			::oWSRequisicaoIdiomaDTO[len(::oWSRequisicaoIdiomaDTO)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure AplicacaoDetalheDTO

WSSTRUCT Requisicao_AplicacaoDetalheDTO
	WSDATA   csDsAplicacao             AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Requisicao_AplicacaoDetalheDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Requisicao_AplicacaoDetalheDTO
Return

WSMETHOD CLONE WSCLIENT Requisicao_AplicacaoDetalheDTO
	Local oClone := Requisicao_AplicacaoDetalheDTO():NEW()
	oClone:csDsAplicacao        := ::csDsAplicacao
Return oClone

WSMETHOD SOAPSEND WSCLIENT Requisicao_AplicacaoDetalheDTO
	Local cSoap := ""
	cSoap += WSSoapValue("sDsAplicacao", ::csDsAplicacao, ::csDsAplicacao , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Requisicao_AplicacaoDetalheDTO
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::csDsAplicacao      :=  WSAdvValue( oResponse,"_SDSAPLICACAO","string",NIL,NIL,NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure ContaContabilDetalheDTO

WSSTRUCT Requisicao_ContaContabilDetalheDTO
	WSDATA   csDsContaContabil         AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Requisicao_ContaContabilDetalheDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Requisicao_ContaContabilDetalheDTO
Return

WSMETHOD CLONE WSCLIENT Requisicao_ContaContabilDetalheDTO
	Local oClone := Requisicao_ContaContabilDetalheDTO():NEW()
	oClone:csDsContaContabil    := ::csDsContaContabil
Return oClone

WSMETHOD SOAPSEND WSCLIENT Requisicao_ContaContabilDetalheDTO
	Local cSoap := ""
	cSoap += WSSoapValue("sDsContaContabil", ::csDsContaContabil, ::csDsContaContabil , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Requisicao_ContaContabilDetalheDTO
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::csDsContaContabil  :=  WSAdvValue( oResponse,"_SDSCONTACONTABIL","string",NIL,NIL,NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure CriterioDetalheDTO

WSSTRUCT Requisicao_CriterioDetalheDTO
	WSDATA   csDsCriterio              AS string OPTIONAL
	WSDATA   csNrCriterio              AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Requisicao_CriterioDetalheDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Requisicao_CriterioDetalheDTO
Return

WSMETHOD CLONE WSCLIENT Requisicao_CriterioDetalheDTO
	Local oClone := Requisicao_CriterioDetalheDTO():NEW()
	oClone:csDsCriterio         := ::csDsCriterio
	oClone:csNrCriterio         := ::csNrCriterio
Return oClone

WSMETHOD SOAPSEND WSCLIENT Requisicao_CriterioDetalheDTO
	Local cSoap := ""
	cSoap += WSSoapValue("sDsCriterio", ::csDsCriterio, ::csDsCriterio , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sNrCriterio", ::csNrCriterio, ::csNrCriterio , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Requisicao_CriterioDetalheDTO
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::csDsCriterio       :=  WSAdvValue( oResponse,"_SDSCRITERIO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csNrCriterio       :=  WSAdvValue( oResponse,"_SNRCRITERIO","string",NIL,NIL,NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure MarcaDetalheDTO

WSSTRUCT Requisicao_MarcaDetalheDTO
	WSDATA   csDsMarca                 AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Requisicao_MarcaDetalheDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Requisicao_MarcaDetalheDTO
Return

WSMETHOD CLONE WSCLIENT Requisicao_MarcaDetalheDTO
	Local oClone := Requisicao_MarcaDetalheDTO():NEW()
	oClone:csDsMarca            := ::csDsMarca
Return oClone

WSMETHOD SOAPSEND WSCLIENT Requisicao_MarcaDetalheDTO
	Local cSoap := ""
	cSoap += WSSoapValue("sDsMarca", ::csDsMarca, ::csDsMarca , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Requisicao_MarcaDetalheDTO
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::csDsMarca          :=  WSAdvValue( oResponse,"_SDSMARCA","string",NIL,NIL,NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure NaturezaDespesaDetalheDTO

WSSTRUCT Requisicao_NaturezaDespesaDetalheDTO
	WSDATA   csDsNaturezaDespesa       AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Requisicao_NaturezaDespesaDetalheDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Requisicao_NaturezaDespesaDetalheDTO
Return

WSMETHOD CLONE WSCLIENT Requisicao_NaturezaDespesaDetalheDTO
	Local oClone := Requisicao_NaturezaDespesaDetalheDTO():NEW()
	oClone:csDsNaturezaDespesa  := ::csDsNaturezaDespesa
Return oClone

WSMETHOD SOAPSEND WSCLIENT Requisicao_NaturezaDespesaDetalheDTO
	Local cSoap := ""
	cSoap += WSSoapValue("sDsNaturezaDespesa", ::csDsNaturezaDespesa, ::csDsNaturezaDespesa , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Requisicao_NaturezaDespesaDetalheDTO
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::csDsNaturezaDespesa :=  WSAdvValue( oResponse,"_SDSNATUREZADESPESA","string",NIL,NIL,NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure UnidadeMedidaDetalheDTO

WSSTRUCT Requisicao_UnidadeMedidaDetalheDTO
	WSDATA   csDsUnidadeMedida         AS string OPTIONAL
	WSDATA   csSgUnidadeMedida         AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Requisicao_UnidadeMedidaDetalheDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Requisicao_UnidadeMedidaDetalheDTO
Return

WSMETHOD CLONE WSCLIENT Requisicao_UnidadeMedidaDetalheDTO
	Local oClone := Requisicao_UnidadeMedidaDetalheDTO():NEW()
	oClone:csDsUnidadeMedida    := ::csDsUnidadeMedida
	oClone:csSgUnidadeMedida    := ::csSgUnidadeMedida
Return oClone

WSMETHOD SOAPSEND WSCLIENT Requisicao_UnidadeMedidaDetalheDTO
	Local cSoap := ""
	cSoap += WSSoapValue("sDsUnidadeMedida", ::csDsUnidadeMedida, ::csDsUnidadeMedida , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sSgUnidadeMedida", ::csSgUnidadeMedida, ::csSgUnidadeMedida , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Requisicao_UnidadeMedidaDetalheDTO
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::csDsUnidadeMedida  :=  WSAdvValue( oResponse,"_SDSUNIDADEMEDIDA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csSgUnidadeMedida  :=  WSAdvValue( oResponse,"_SSGUNIDADEMEDIDA","string",NIL,NIL,NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure WbtLogDTO

WSSTRUCT Requisicao_WbtLogDTO
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

WSMETHOD NEW WSCLIENT Requisicao_WbtLogDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Requisicao_WbtLogDTO
Return

WSMETHOD CLONE WSCLIENT Requisicao_WbtLogDTO
	Local oClone := Requisicao_WbtLogDTO():NEW()
	oClone:nnCdLog              := ::nnCdLog
	oClone:nnIdRetorno          := ::nnIdRetorno
	oClone:csCdOrigem           := ::csCdOrigem
	oClone:csDsLog              := ::csDsLog
	oClone:csDsTipoDocumento    := ::csDsTipoDocumento
	oClone:csNrToken            := ::csNrToken
	oClone:ctDtLog              := ::ctDtLog
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Requisicao_WbtLogDTO
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

// WSDL Data Structure ArrayOfRequisicaoEntregaDTO

WSSTRUCT Requisicao_ArrayOfRequisicaoEntregaDTO
	WSDATA   oWSRequisicaoEntregaDTO   AS Requisicao_RequisicaoEntregaDTO OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Requisicao_ArrayOfRequisicaoEntregaDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Requisicao_ArrayOfRequisicaoEntregaDTO
	::oWSRequisicaoEntregaDTO := {} // Array Of  Requisicao_REQUISICAOENTREGADTO():New()
Return

WSMETHOD CLONE WSCLIENT Requisicao_ArrayOfRequisicaoEntregaDTO
	Local oClone := Requisicao_ArrayOfRequisicaoEntregaDTO():NEW()
	oClone:oWSRequisicaoEntregaDTO := NIL
	If ::oWSRequisicaoEntregaDTO <> NIL 
		oClone:oWSRequisicaoEntregaDTO := {}
		aEval( ::oWSRequisicaoEntregaDTO , { |x| aadd( oClone:oWSRequisicaoEntregaDTO , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Requisicao_ArrayOfRequisicaoEntregaDTO
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_REQUISICAOENTREGADTO","RequisicaoEntregaDTO",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSRequisicaoEntregaDTO , Requisicao_RequisicaoEntregaDTO():New() )
			::oWSRequisicaoEntregaDTO[len(::oWSRequisicaoEntregaDTO)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure RequisicaoHistoricoSituacaoDTO

WSSTRUCT Requisicao_RequisicaoHistoricoSituacaoDTO
	WSDATA   nnCdNegociacao            AS long OPTIONAL
	WSDATA   nnIdTipo                  AS long OPTIONAL
	WSDATA   csCdUsuario               AS string OPTIONAL
	WSDATA   csDsHistorico             AS string OPTIONAL
	WSDATA   csDsSituacaoNegociacao    AS string OPTIONAL
	WSDATA   csDsSituacaoRequisicao    AS string OPTIONAL
	WSDATA   csNrNegociacao            AS string OPTIONAL
	WSDATA   ctDtHistorico             AS dateTime OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Requisicao_RequisicaoHistoricoSituacaoDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Requisicao_RequisicaoHistoricoSituacaoDTO
Return

WSMETHOD CLONE WSCLIENT Requisicao_RequisicaoHistoricoSituacaoDTO
	Local oClone := Requisicao_RequisicaoHistoricoSituacaoDTO():NEW()
	oClone:nnCdNegociacao       := ::nnCdNegociacao
	oClone:nnIdTipo             := ::nnIdTipo
	oClone:csCdUsuario          := ::csCdUsuario
	oClone:csDsHistorico        := ::csDsHistorico
	oClone:csDsSituacaoNegociacao := ::csDsSituacaoNegociacao
	oClone:csDsSituacaoRequisicao := ::csDsSituacaoRequisicao
	oClone:csNrNegociacao       := ::csNrNegociacao
	oClone:ctDtHistorico        := ::ctDtHistorico
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Requisicao_RequisicaoHistoricoSituacaoDTO
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::nnCdNegociacao     :=  WSAdvValue( oResponse,"_NCDNEGOCIACAO","long",NIL,NIL,NIL,"N",NIL,NIL) 
	::nnIdTipo           :=  WSAdvValue( oResponse,"_NIDTIPO","long",NIL,NIL,NIL,"N",NIL,NIL) 
	::csCdUsuario        :=  WSAdvValue( oResponse,"_SCDUSUARIO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csDsHistorico      :=  WSAdvValue( oResponse,"_SDSHISTORICO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csDsSituacaoNegociacao :=  WSAdvValue( oResponse,"_SDSSITUACAONEGOCIACAO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csDsSituacaoRequisicao :=  WSAdvValue( oResponse,"_SDSSITUACAOREQUISICAO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csNrNegociacao     :=  WSAdvValue( oResponse,"_SNRNEGOCIACAO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::ctDtHistorico      :=  WSAdvValue( oResponse,"_TDTHISTORICO","dateTime",NIL,NIL,NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure RequisicaoEmpresaDTO

WSSTRUCT Requisicao_RequisicaoEmpresaDTO
	WSDATA   csCdEmpresa               AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Requisicao_RequisicaoEmpresaDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Requisicao_RequisicaoEmpresaDTO
Return

WSMETHOD CLONE WSCLIENT Requisicao_RequisicaoEmpresaDTO
	Local oClone := Requisicao_RequisicaoEmpresaDTO():NEW()
	oClone:csCdEmpresa          := ::csCdEmpresa
Return oClone

WSMETHOD SOAPSEND WSCLIENT Requisicao_RequisicaoEmpresaDTO
	Local cSoap := ""
	cSoap += WSSoapValue("sCdEmpresa", ::csCdEmpresa, ::csCdEmpresa , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Requisicao_RequisicaoEmpresaDTO
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::csCdEmpresa        :=  WSAdvValue( oResponse,"_SCDEMPRESA","string",NIL,NIL,NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure RequisicaoIdiomaDTO

WSSTRUCT Requisicao_RequisicaoIdiomaDTO
	WSDATA   csDsJustificativa         AS string OPTIONAL
	WSDATA   csDsObservacao            AS string OPTIONAL
	WSDATA   csDsProdutoRequisicao     AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Requisicao_RequisicaoIdiomaDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Requisicao_RequisicaoIdiomaDTO
Return

WSMETHOD CLONE WSCLIENT Requisicao_RequisicaoIdiomaDTO
	Local oClone := Requisicao_RequisicaoIdiomaDTO():NEW()
	oClone:csDsJustificativa    := ::csDsJustificativa
	oClone:csDsObservacao       := ::csDsObservacao
	oClone:csDsProdutoRequisicao := ::csDsProdutoRequisicao
Return oClone

WSMETHOD SOAPSEND WSCLIENT Requisicao_RequisicaoIdiomaDTO
	Local cSoap := ""
	cSoap += WSSoapValue("sDsJustificativa", ::csDsJustificativa, ::csDsJustificativa , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sDsObservacao", ::csDsObservacao, ::csDsObservacao , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sDsProdutoRequisicao", ::csDsProdutoRequisicao, ::csDsProdutoRequisicao , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Requisicao_RequisicaoIdiomaDTO
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::csDsJustificativa  :=  WSAdvValue( oResponse,"_SDSJUSTIFICATIVA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csDsObservacao     :=  WSAdvValue( oResponse,"_SDSOBSERVACAO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csDsProdutoRequisicao :=  WSAdvValue( oResponse,"_SDSPRODUTOREQUISICAO","string",NIL,NIL,NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure RequisicaoEntregaDTO

WSSTRUCT Requisicao_RequisicaoEntregaDTO
	WSDATA   cdtEntrega                AS dateTime OPTIONAL
	WSDATA   csCdItemRequisicaoEmpresa AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Requisicao_RequisicaoEntregaDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Requisicao_RequisicaoEntregaDTO
Return

WSMETHOD CLONE WSCLIENT Requisicao_RequisicaoEntregaDTO
	Local oClone := Requisicao_RequisicaoEntregaDTO():NEW()
	oClone:cdtEntrega           := ::cdtEntrega
	oClone:csCdItemRequisicaoEmpresa := ::csCdItemRequisicaoEmpresa
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Requisicao_RequisicaoEntregaDTO
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cdtEntrega         :=  WSAdvValue( oResponse,"_DTENTREGA","dateTime",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdItemRequisicaoEmpresa :=  WSAdvValue( oResponse,"_SCDITEMREQUISICAOEMPRESA","string",NIL,NIL,NIL,"S",NIL,NIL) 
Return


