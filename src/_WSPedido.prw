#INCLUDE "protheus.ch"
#INCLUDE "apwebsrv.ch"

/*=================================================================================================================*\
|| ############################################################################################################### ||
||																	                                               ||
|| # WSDL Service Pedido																						 # ||
|| # WSDL Location: https://srm-hml.paradigmabs.com.br/cassi-hml/services/Pedido.svc?wsdl						 # ||
||																	                                               ||
|| # Data - 26/09/2019 																							 # ||
||																	                                               ||
|| # Desc: WebService de cadastro de Pedido.																	 # ||
||																	                                               ||
|| # Obs: Alterações neste arquivo podem causar funcionamento incorreto.										 # ||
||																	                                               ||
|| ############################################################################################################### ||
\*=================================================================================================================*/
User Function _NPUXMGB ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSParPedido
------------------------------------------------------------------------------- */

WSCLIENT WSParPedido

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD ProcessarPedido
	WSMETHOD ProcessarPedidoAtualizacao
	WSMETHOD RetornarPedidoCotacaoItem
	WSMETHOD RetornarPedidoLeilaoItem
	WSMETHOD RetornarPedidoItem
	WSMETHOD RetornarPedidoCotacao
	WSMETHOD RetornarPedidoRequisicaoContrato
	WSMETHOD RetornarPedidoLeilao
	WSMETHOD RetornarPedido
	WSMETHOD RetornarPedidoCatalogo
	WSMETHOD ProcessarPedidoCancelamento
	WSMETHOD RetornarPedidoAceite
	WSMETHOD RetornarPedidoCancelamento
	WSMETHOD RetornarPedidoConfirmado
	WSMETHOD RetornarTodosConfirmados
	WSMETHOD HabilitarRetornarPedidoCancelamento
	WSMETHOD HabilitarRetornarPedidoConfirmado
	WSMETHOD ProcessarPedidoVersao
	WSMETHOD RetornarPedidoItemEntregaSolicitacaoAlteracao
	WSMETHOD HabilitarPedidoItemEntregaSolicitacaoAlteracao
	WSMETHOD ProcessarPedidoItemEntregaSolicitacaoAlteracao
	WSMETHOD ProcessarPedidoDetalhe
	WSMETHOD ProcessarPedidoItemEntregaLogistica
	WSMETHOD ProcessarPedidoDadosCapa
	WSMETHOD RetornarCodigoPedidoSequencia
	WSMETHOD HabilitarPedidoRequisicaoContrato
	WSMETHOD HabilitarRetornoPedidoCatalogo
	WSMETHOD RetornarPedidoCotacaoPorEmpresa
	WSMETHOD RetornarTodosPedidosEmProcessoDeIntegracao
	WSMETHOD AtualizarNumeroPedidoPortal
	WSMETHOD RetornarCodigoSituacaoDefault

	WSDATA   _URL                      AS String
	WSDATA   _CERT                     AS String
	WSDATA   _PRIVKEY                  AS String
	WSDATA   _PASSPHRASE               AS String
	WSDATA   _HEADOUT                  AS Array of String
	WSDATA   _COOKIES                  AS Array of String
	WSDATA   oWSlstPedido              AS Pedido_ArrayOfPedidoDTO
	WSDATA   lbFlNaoUtilizarDePara     AS boolean
	WSDATA   oWSProcessarPedidoResult  AS Pedido_RetornoDTO
	WSDATA   oWSProcessarPedidoAtualizacaoResult AS Pedido_RetornoDTO
	WSDATA   oWSRetornarPedidoCotacaoItemResult AS Pedido_ArrayOfPedidoDTO
	WSDATA   oWSRetornarPedidoLeilaoItemResult AS Pedido_ArrayOfPedidoDTO
	WSDATA   oWSRetornarPedidoItemResult AS Pedido_ArrayOfPedidoDTO
	WSDATA   oWSRetornarPedidoCotacaoResult AS Pedido_ArrayOfPedidoDTO
	WSDATA   oWSRetornarPedidoRequisicaoContratoResult AS Pedido_ArrayOfPedidoDTO
	WSDATA   oWSRetornarPedidoLeilaoResult AS Pedido_ArrayOfPedidoDTO
	WSDATA   oWSRetornarPedidoResult   AS Pedido_ArrayOfPedidoDTO
	WSDATA   oWSRetornarPedidoCatalogoResult AS Pedido_ArrayOfPedidoDTO
	WSDATA   oWSlstPedidoAtualizarDTO  AS Pedido_ArrayOfPedidoAtualizarDTO
	WSDATA   oWSProcessarPedidoCancelamentoResult AS Pedido_RetornoDTO
	WSDATA   oWSRetornarPedidoAceiteResult AS Pedido_ArrayOfPedidoAtualizarDTO
	WSDATA   oWSRetornarPedidoCancelamentoResult AS Pedido_ArrayOfPedidoAtualizarDTO
	WSDATA   oWSRetornarPedidoConfirmadoResult AS Pedido_ArrayOfPedidoAtualizarDTO
	WSDATA   oWSRetornarTodosConfirmadosResult AS Pedido_ArrayOfPedidoDTO
	WSDATA   oWSHabilitarRetornarPedidoCancelamentoResult AS Pedido_RetornoDTO
	WSDATA   oWSHabilitarRetornarPedidoConfirmadoResult AS Pedido_RetornoDTO
	WSDATA   oWSlstPedidoVersaoDTO     AS Pedido_ArrayOfPedidoVersaoDTO
	WSDATA   oWSProcessarPedidoVersaoResult AS Pedido_RetornoDTO
	WSDATA   oWSRetornarPedidoItemEntregaSolicitacaoAlteracaoResult AS Pedido_ArrayOfPedidoItemLogisticaDTO
	WSDATA   oWSlstPedidoItemLogisticaDTO AS Pedido_ArrayOfPedidoItemLogisticaHabilitarDTO
	WSDATA   oWSHabilitarPedidoItemEntregaSolicitacaoAlteracaoResult AS Pedido_RetornoDTO
	WSDATA   oWSProcessarPedidoItemEntregaSolicitacaoAlteracaoResult AS Pedido_RetornoDTO
	WSDATA   oWSlstPedidoDetalhe       AS Pedido_ArrayOfPedidoDetalheDTO
	WSDATA   oWSProcessarPedidoDetalheResult AS Pedido_RetornoDTO
	WSDATA   oWSlstPedidoItemEntregaLogisticaDTO AS Pedido_ArrayOfPedidoItemEntregaLogisticaDTO
	WSDATA   oWSProcessarPedidoItemEntregaLogisticaResult AS Pedido_RetornoDTO
	WSDATA   oWSProcessarPedidoDadosCapaResult AS Pedido_RetornoDTO
	WSDATA   cRetornarCodigoPedidoSequenciaResult AS string
	WSDATA   csCdRequisicaoEmpresa     AS string
	WSDATA   csCdItemRequisicaoEmpresa AS string
	WSDATA   oWSHabilitarPedidoRequisicaoContratoResult AS Pedido_RetornoDTO
	WSDATA   oWSlstPrePedidoAtualizarDTO AS Pedido_ArrayOfPrePedidoAtualizarDTO
	WSDATA   oWSHabilitarRetornoPedidoCatalogoResult AS Pedido_RetornoDTO
	WSDATA   oWSlstPedidoEmpresaDTO    AS Pedido_ArrayOfPedidoEmpresaDTO
	WSDATA   oWSRetornarPedidoCotacaoPorEmpresaResult AS Pedido_ArrayOfPedidoDTO
	WSDATA   oWSRetornarTodosPedidosEmProcessoDeIntegracaoResult AS Pedido_ArrayOfPedidoDTO
	WSDATA   oWSlstPedidoNumeroDTO     AS Pedido_ArrayOfPedidoNumeroDTO
	WSDATA   oWSAtualizarNumeroPedidoPortalResult AS Pedido_RetornoDTO
	WSDATA   nRetornarCodigoSituacaoDefaultResult AS long

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSParPedido
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.131227A-20190114 NG] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSParPedido
	::oWSlstPedido       := Pedido_ARRAYOFPEDIDODTO():New()
	::oWSProcessarPedidoResult := Pedido_RETORNODTO():New()
	::oWSProcessarPedidoAtualizacaoResult := Pedido_RETORNODTO():New()
	::oWSRetornarPedidoCotacaoItemResult := Pedido_ARRAYOFPEDIDODTO():New()
	::oWSRetornarPedidoLeilaoItemResult := Pedido_ARRAYOFPEDIDODTO():New()
	::oWSRetornarPedidoItemResult := Pedido_ARRAYOFPEDIDODTO():New()
	::oWSRetornarPedidoCotacaoResult := Pedido_ARRAYOFPEDIDODTO():New()
	::oWSRetornarPedidoRequisicaoContratoResult := Pedido_ARRAYOFPEDIDODTO():New()
	::oWSRetornarPedidoLeilaoResult := Pedido_ARRAYOFPEDIDODTO():New()
	::oWSRetornarPedidoResult := Pedido_ARRAYOFPEDIDODTO():New()
	::oWSRetornarPedidoCatalogoResult := Pedido_ARRAYOFPEDIDODTO():New()
	::oWSlstPedidoAtualizarDTO := Pedido_ARRAYOFPEDIDOATUALIZARDTO():New()
	::oWSProcessarPedidoCancelamentoResult := Pedido_RETORNODTO():New()
	::oWSRetornarPedidoAceiteResult := Pedido_ARRAYOFPEDIDOATUALIZARDTO():New()
	::oWSRetornarPedidoCancelamentoResult := Pedido_ARRAYOFPEDIDOATUALIZARDTO():New()
	::oWSRetornarPedidoConfirmadoResult := Pedido_ARRAYOFPEDIDOATUALIZARDTO():New()
	::oWSRetornarTodosConfirmadosResult := Pedido_ARRAYOFPEDIDODTO():New()
	::oWSHabilitarRetornarPedidoCancelamentoResult := Pedido_RETORNODTO():New()
	::oWSHabilitarRetornarPedidoConfirmadoResult := Pedido_RETORNODTO():New()
	::oWSlstPedidoVersaoDTO := Pedido_ARRAYOFPEDIDOVERSAODTO():New()
	::oWSProcessarPedidoVersaoResult := Pedido_RETORNODTO():New()
	::oWSRetornarPedidoItemEntregaSolicitacaoAlteracaoResult := Pedido_ARRAYOFPEDIDOITEMLOGISTICADTO():New()
	::oWSlstPedidoItemLogisticaDTO := Pedido_ARRAYOFPEDIDOITEMLOGISTICAHABILITARDTO():New()
	::oWSHabilitarPedidoItemEntregaSolicitacaoAlteracaoResult := Pedido_RETORNODTO():New()
	::oWSProcessarPedidoItemEntregaSolicitacaoAlteracaoResult := Pedido_RETORNODTO():New()
	::oWSlstPedidoDetalhe := Pedido_ARRAYOFPEDIDODETALHEDTO():New()
	::oWSProcessarPedidoDetalheResult := Pedido_RETORNODTO():New()
	::oWSlstPedidoItemEntregaLogisticaDTO := Pedido_ARRAYOFPEDIDOITEMENTREGALOGISTICADTO():New()
	::oWSProcessarPedidoItemEntregaLogisticaResult := Pedido_RETORNODTO():New()
	::oWSProcessarPedidoDadosCapaResult := Pedido_RETORNODTO():New()
	::oWSHabilitarPedidoRequisicaoContratoResult := Pedido_RETORNODTO():New()
	::oWSlstPrePedidoAtualizarDTO := Pedido_ARRAYOFPREPEDIDOATUALIZARDTO():New()
	::oWSHabilitarRetornoPedidoCatalogoResult := Pedido_RETORNODTO():New()
	::oWSlstPedidoEmpresaDTO := Pedido_ARRAYOFPEDIDOEMPRESADTO():New()
	::oWSRetornarPedidoCotacaoPorEmpresaResult := Pedido_ARRAYOFPEDIDODTO():New()
	::oWSRetornarTodosPedidosEmProcessoDeIntegracaoResult := Pedido_ARRAYOFPEDIDODTO():New()
	::oWSlstPedidoNumeroDTO := Pedido_ARRAYOFPEDIDONUMERODTO():New()
	::oWSAtualizarNumeroPedidoPortalResult := Pedido_RETORNODTO():New()
Return

WSMETHOD RESET WSCLIENT WSParPedido
	::oWSlstPedido       := NIL 
	::lbFlNaoUtilizarDePara := NIL 
	::oWSProcessarPedidoResult := NIL 
	::oWSProcessarPedidoAtualizacaoResult := NIL 
	::oWSRetornarPedidoCotacaoItemResult := NIL 
	::oWSRetornarPedidoLeilaoItemResult := NIL 
	::oWSRetornarPedidoItemResult := NIL 
	::oWSRetornarPedidoCotacaoResult := NIL 
	::oWSRetornarPedidoRequisicaoContratoResult := NIL 
	::oWSRetornarPedidoLeilaoResult := NIL 
	::oWSRetornarPedidoResult := NIL 
	::oWSRetornarPedidoCatalogoResult := NIL 
	::oWSlstPedidoAtualizarDTO := NIL 
	::oWSProcessarPedidoCancelamentoResult := NIL 
	::oWSRetornarPedidoAceiteResult := NIL 
	::oWSRetornarPedidoCancelamentoResult := NIL 
	::oWSRetornarPedidoConfirmadoResult := NIL 
	::oWSRetornarTodosConfirmadosResult := NIL 
	::oWSHabilitarRetornarPedidoCancelamentoResult := NIL 
	::oWSHabilitarRetornarPedidoConfirmadoResult := NIL 
	::oWSlstPedidoVersaoDTO := NIL 
	::oWSProcessarPedidoVersaoResult := NIL 
	::oWSRetornarPedidoItemEntregaSolicitacaoAlteracaoResult := NIL 
	::oWSlstPedidoItemLogisticaDTO := NIL 
	::oWSHabilitarPedidoItemEntregaSolicitacaoAlteracaoResult := NIL 
	::oWSProcessarPedidoItemEntregaSolicitacaoAlteracaoResult := NIL 
	::oWSlstPedidoDetalhe := NIL 
	::oWSProcessarPedidoDetalheResult := NIL 
	::oWSlstPedidoItemEntregaLogisticaDTO := NIL 
	::oWSProcessarPedidoItemEntregaLogisticaResult := NIL 
	::oWSProcessarPedidoDadosCapaResult := NIL 
	::cRetornarCodigoPedidoSequenciaResult := NIL 
	::csCdRequisicaoEmpresa := NIL 
	::csCdItemRequisicaoEmpresa := NIL 
	::oWSHabilitarPedidoRequisicaoContratoResult := NIL 
	::oWSlstPrePedidoAtualizarDTO := NIL 
	::oWSHabilitarRetornoPedidoCatalogoResult := NIL 
	::oWSlstPedidoEmpresaDTO := NIL 
	::oWSRetornarPedidoCotacaoPorEmpresaResult := NIL 
	::oWSRetornarTodosPedidosEmProcessoDeIntegracaoResult := NIL 
	::oWSlstPedidoNumeroDTO := NIL 
	::oWSAtualizarNumeroPedidoPortalResult := NIL 
	::nRetornarCodigoSituacaoDefaultResult := NIL 
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSParPedido
Local oClone := WSParPedido():New()
	oClone:_URL          := ::_URL 
	oClone:_CERT         := ::_CERT 
	oClone:_PRIVKEY      := ::_PRIVKEY 
	oClone:_PASSPHRASE   := ::_PASSPHRASE 
	oClone:oWSlstPedido  :=  IIF(::oWSlstPedido = NIL , NIL ,::oWSlstPedido:Clone() )
	oClone:lbFlNaoUtilizarDePara := ::lbFlNaoUtilizarDePara
	oClone:oWSProcessarPedidoResult :=  IIF(::oWSProcessarPedidoResult = NIL , NIL ,::oWSProcessarPedidoResult:Clone() )
	oClone:oWSProcessarPedidoAtualizacaoResult :=  IIF(::oWSProcessarPedidoAtualizacaoResult = NIL , NIL ,::oWSProcessarPedidoAtualizacaoResult:Clone() )
	oClone:oWSRetornarPedidoCotacaoItemResult :=  IIF(::oWSRetornarPedidoCotacaoItemResult = NIL , NIL ,::oWSRetornarPedidoCotacaoItemResult:Clone() )
	oClone:oWSRetornarPedidoLeilaoItemResult :=  IIF(::oWSRetornarPedidoLeilaoItemResult = NIL , NIL ,::oWSRetornarPedidoLeilaoItemResult:Clone() )
	oClone:oWSRetornarPedidoItemResult :=  IIF(::oWSRetornarPedidoItemResult = NIL , NIL ,::oWSRetornarPedidoItemResult:Clone() )
	oClone:oWSRetornarPedidoCotacaoResult :=  IIF(::oWSRetornarPedidoCotacaoResult = NIL , NIL ,::oWSRetornarPedidoCotacaoResult:Clone() )
	oClone:oWSRetornarPedidoRequisicaoContratoResult :=  IIF(::oWSRetornarPedidoRequisicaoContratoResult = NIL , NIL ,::oWSRetornarPedidoRequisicaoContratoResult:Clone() )
	oClone:oWSRetornarPedidoLeilaoResult :=  IIF(::oWSRetornarPedidoLeilaoResult = NIL , NIL ,::oWSRetornarPedidoLeilaoResult:Clone() )
	oClone:oWSRetornarPedidoResult :=  IIF(::oWSRetornarPedidoResult = NIL , NIL ,::oWSRetornarPedidoResult:Clone() )
	oClone:oWSRetornarPedidoCatalogoResult :=  IIF(::oWSRetornarPedidoCatalogoResult = NIL , NIL ,::oWSRetornarPedidoCatalogoResult:Clone() )
	oClone:oWSlstPedidoAtualizarDTO :=  IIF(::oWSlstPedidoAtualizarDTO = NIL , NIL ,::oWSlstPedidoAtualizarDTO:Clone() )
	oClone:oWSProcessarPedidoCancelamentoResult :=  IIF(::oWSProcessarPedidoCancelamentoResult = NIL , NIL ,::oWSProcessarPedidoCancelamentoResult:Clone() )
	oClone:oWSRetornarPedidoAceiteResult :=  IIF(::oWSRetornarPedidoAceiteResult = NIL , NIL ,::oWSRetornarPedidoAceiteResult:Clone() )
	oClone:oWSRetornarPedidoCancelamentoResult :=  IIF(::oWSRetornarPedidoCancelamentoResult = NIL , NIL ,::oWSRetornarPedidoCancelamentoResult:Clone() )
	oClone:oWSRetornarPedidoConfirmadoResult :=  IIF(::oWSRetornarPedidoConfirmadoResult = NIL , NIL ,::oWSRetornarPedidoConfirmadoResult:Clone() )
	oClone:oWSRetornarTodosConfirmadosResult :=  IIF(::oWSRetornarTodosConfirmadosResult = NIL , NIL ,::oWSRetornarTodosConfirmadosResult:Clone() )
	oClone:oWSHabilitarRetornarPedidoCancelamentoResult :=  IIF(::oWSHabilitarRetornarPedidoCancelamentoResult = NIL , NIL ,::oWSHabilitarRetornarPedidoCancelamentoResult:Clone() )
	oClone:oWSHabilitarRetornarPedidoConfirmadoResult :=  IIF(::oWSHabilitarRetornarPedidoConfirmadoResult = NIL , NIL ,::oWSHabilitarRetornarPedidoConfirmadoResult:Clone() )
	oClone:oWSlstPedidoVersaoDTO :=  IIF(::oWSlstPedidoVersaoDTO = NIL , NIL ,::oWSlstPedidoVersaoDTO:Clone() )
	oClone:oWSProcessarPedidoVersaoResult :=  IIF(::oWSProcessarPedidoVersaoResult = NIL , NIL ,::oWSProcessarPedidoVersaoResult:Clone() )
	oClone:oWSRetornarPedidoItemEntregaSolicitacaoAlteracaoResult :=  IIF(::oWSRetornarPedidoItemEntregaSolicitacaoAlteracaoResult = NIL , NIL ,::oWSRetornarPedidoItemEntregaSolicitacaoAlteracaoResult:Clone() )
	oClone:oWSlstPedidoItemLogisticaDTO :=  IIF(::oWSlstPedidoItemLogisticaDTO = NIL , NIL ,::oWSlstPedidoItemLogisticaDTO:Clone() )
	oClone:oWSHabilitarPedidoItemEntregaSolicitacaoAlteracaoResult :=  IIF(::oWSHabilitarPedidoItemEntregaSolicitacaoAlteracaoResult = NIL , NIL ,::oWSHabilitarPedidoItemEntregaSolicitacaoAlteracaoResult:Clone() )
	oClone:oWSProcessarPedidoItemEntregaSolicitacaoAlteracaoResult :=  IIF(::oWSProcessarPedidoItemEntregaSolicitacaoAlteracaoResult = NIL , NIL ,::oWSProcessarPedidoItemEntregaSolicitacaoAlteracaoResult:Clone() )
	oClone:oWSlstPedidoDetalhe :=  IIF(::oWSlstPedidoDetalhe = NIL , NIL ,::oWSlstPedidoDetalhe:Clone() )
	oClone:oWSProcessarPedidoDetalheResult :=  IIF(::oWSProcessarPedidoDetalheResult = NIL , NIL ,::oWSProcessarPedidoDetalheResult:Clone() )
	oClone:oWSlstPedidoItemEntregaLogisticaDTO :=  IIF(::oWSlstPedidoItemEntregaLogisticaDTO = NIL , NIL ,::oWSlstPedidoItemEntregaLogisticaDTO:Clone() )
	oClone:oWSProcessarPedidoItemEntregaLogisticaResult :=  IIF(::oWSProcessarPedidoItemEntregaLogisticaResult = NIL , NIL ,::oWSProcessarPedidoItemEntregaLogisticaResult:Clone() )
	oClone:oWSProcessarPedidoDadosCapaResult :=  IIF(::oWSProcessarPedidoDadosCapaResult = NIL , NIL ,::oWSProcessarPedidoDadosCapaResult:Clone() )
	oClone:cRetornarCodigoPedidoSequenciaResult := ::cRetornarCodigoPedidoSequenciaResult
	oClone:csCdRequisicaoEmpresa := ::csCdRequisicaoEmpresa
	oClone:csCdItemRequisicaoEmpresa := ::csCdItemRequisicaoEmpresa
	oClone:oWSHabilitarPedidoRequisicaoContratoResult :=  IIF(::oWSHabilitarPedidoRequisicaoContratoResult = NIL , NIL ,::oWSHabilitarPedidoRequisicaoContratoResult:Clone() )
	oClone:oWSlstPrePedidoAtualizarDTO :=  IIF(::oWSlstPrePedidoAtualizarDTO = NIL , NIL ,::oWSlstPrePedidoAtualizarDTO:Clone() )
	oClone:oWSHabilitarRetornoPedidoCatalogoResult :=  IIF(::oWSHabilitarRetornoPedidoCatalogoResult = NIL , NIL ,::oWSHabilitarRetornoPedidoCatalogoResult:Clone() )
	oClone:oWSlstPedidoEmpresaDTO :=  IIF(::oWSlstPedidoEmpresaDTO = NIL , NIL ,::oWSlstPedidoEmpresaDTO:Clone() )
	oClone:oWSRetornarPedidoCotacaoPorEmpresaResult :=  IIF(::oWSRetornarPedidoCotacaoPorEmpresaResult = NIL , NIL ,::oWSRetornarPedidoCotacaoPorEmpresaResult:Clone() )
	oClone:oWSRetornarTodosPedidosEmProcessoDeIntegracaoResult :=  IIF(::oWSRetornarTodosPedidosEmProcessoDeIntegracaoResult = NIL , NIL ,::oWSRetornarTodosPedidosEmProcessoDeIntegracaoResult:Clone() )
	oClone:oWSlstPedidoNumeroDTO :=  IIF(::oWSlstPedidoNumeroDTO = NIL , NIL ,::oWSlstPedidoNumeroDTO:Clone() )
	oClone:oWSAtualizarNumeroPedidoPortalResult :=  IIF(::oWSAtualizarNumeroPedidoPortalResult = NIL , NIL ,::oWSAtualizarNumeroPedidoPortalResult:Clone() )
	oClone:nRetornarCodigoSituacaoDefaultResult := ::nRetornarCodigoSituacaoDefaultResult
Return oClone

// WSDL Method ProcessarPedido of Service WSParPedido

WSMETHOD ProcessarPedido WSSEND oWSlstPedido,lbFlNaoUtilizarDePara WSRECEIVE oWSProcessarPedidoResult WSCLIENT WSParPedido
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ProcessarPedido xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("lstPedido", ::oWSlstPedido, oWSlstPedido , "ArrayOfPedidoDTO", .F. , .F., 0 , "http://tempuri.org/", .F.,.F.) 
cSoap += WSSoapValue("bFlNaoUtilizarDePara", ::lbFlNaoUtilizarDePara, lbFlNaoUtilizarDePara , "boolean", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</ProcessarPedido>"

Self:_HEADOUT := { "Authorization: Bearer " + U_NewToken() }
oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tempuri.org/IPedido/ProcessarPedido",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	Lower(AllTrim(GetMv("MV_XPARURL"))) + "/services/Pedido.svc")

::Init()
::oWSProcessarPedidoResult:SoapRecv( WSAdvValue( oXmlRet,"_PROCESSARPEDIDORESPONSE:_PROCESSARPEDIDORESULT","RetornoDTO",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method ProcessarPedidoAtualizacao of Service WSParPedido

WSMETHOD ProcessarPedidoAtualizacao WSSEND oWSlstPedido WSRECEIVE oWSProcessarPedidoAtualizacaoResult WSCLIENT WSParPedido
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ProcessarPedidoAtualizacao xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("lstPedido", ::oWSlstPedido, oWSlstPedido , "ArrayOfPedidoDTO", .F. , .F., 0 , "http://tempuri.org/", .F.,.F.) 
cSoap += "</ProcessarPedidoAtualizacao>"

Self:_HEADOUT := { "Authorization: Bearer " + U_NewToken() }
oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tempuri.org/IPedido/ProcessarPedidoAtualizacao",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	Lower(AllTrim(GetMv("MV_XPARURL"))) + "/services/Pedido.svc")

::Init()
::oWSProcessarPedidoAtualizacaoResult:SoapRecv( WSAdvValue( oXmlRet,"_PROCESSARPEDIDOATUALIZACAORESPONSE:_PROCESSARPEDIDOATUALIZACAORESULT","RetornoDTO",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method RetornarPedidoCotacaoItem of Service WSParPedido

WSMETHOD RetornarPedidoCotacaoItem WSSEND lbFlNaoUtilizarDePara WSRECEIVE oWSRetornarPedidoCotacaoItemResult WSCLIENT WSParPedido
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<RetornarPedidoCotacaoItem xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("bFlNaoUtilizarDePara", ::lbFlNaoUtilizarDePara, lbFlNaoUtilizarDePara , "boolean", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</RetornarPedidoCotacaoItem>"

Self:_HEADOUT := { "Authorization: Bearer " + U_NewToken() }
oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tempuri.org/IPedido/RetornarPedidoCotacaoItem",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	Lower(AllTrim(GetMv("MV_XPARURL"))) + "/services/Pedido.svc")

::Init()
::oWSRetornarPedidoCotacaoItemResult:SoapRecv( WSAdvValue( oXmlRet,"_RETORNARPEDIDOCOTACAOITEMRESPONSE:_RETORNARPEDIDOCOTACAOITEMRESULT","ArrayOfPedidoDTO",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method RetornarPedidoLeilaoItem of Service WSParPedido

WSMETHOD RetornarPedidoLeilaoItem WSSEND NULLPARAM WSRECEIVE oWSRetornarPedidoLeilaoItemResult WSCLIENT WSParPedido
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<RetornarPedidoLeilaoItem xmlns="http://tempuri.org/">'
cSoap += "</RetornarPedidoLeilaoItem>"

Self:_HEADOUT := { "Authorization: Bearer " + U_NewToken() }
oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tempuri.org/IPedido/RetornarPedidoLeilaoItem",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	Lower(AllTrim(GetMv("MV_XPARURL"))) + "/services/Pedido.svc")

::Init()
::oWSRetornarPedidoLeilaoItemResult:SoapRecv( WSAdvValue( oXmlRet,"_RETORNARPEDIDOLEILAOITEMRESPONSE:_RETORNARPEDIDOLEILAOITEMRESULT","ArrayOfPedidoDTO",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method RetornarPedidoItem of Service WSParPedido

WSMETHOD RetornarPedidoItem WSSEND NULLPARAM WSRECEIVE oWSRetornarPedidoItemResult WSCLIENT WSParPedido
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<RetornarPedidoItem xmlns="http://tempuri.org/">'
cSoap += "</RetornarPedidoItem>"

Self:_HEADOUT := { "Authorization: Bearer " + U_NewToken() }
oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tempuri.org/IPedido/RetornarPedidoItem",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	Lower(AllTrim(GetMv("MV_XPARURL"))) + "/services/Pedido.svc")

::Init()
::oWSRetornarPedidoItemResult:SoapRecv( WSAdvValue( oXmlRet,"_RETORNARPEDIDOITEMRESPONSE:_RETORNARPEDIDOITEMRESULT","ArrayOfPedidoDTO",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method RetornarPedidoCotacao of Service WSParPedido

WSMETHOD RetornarPedidoCotacao WSSEND lbFlNaoUtilizarDePara WSRECEIVE oWSRetornarPedidoCotacaoResult WSCLIENT WSParPedido
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<RetornarPedidoCotacao xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("bFlNaoUtilizarDePara", ::lbFlNaoUtilizarDePara, lbFlNaoUtilizarDePara , "boolean", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</RetornarPedidoCotacao>"

Self:_HEADOUT := { "Authorization: Bearer " + U_NewToken() }
oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tempuri.org/IPedido/RetornarPedidoCotacao",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	Lower(AllTrim(GetMv("MV_XPARURL"))) + "/services/Pedido.svc")

::Init()
::oWSRetornarPedidoCotacaoResult:SoapRecv( WSAdvValue( oXmlRet,"_RETORNARPEDIDOCOTACAORESPONSE:_RETORNARPEDIDOCOTACAORESULT","ArrayOfPedidoDTO",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method RetornarPedidoRequisicaoContrato of Service WSParPedido

WSMETHOD RetornarPedidoRequisicaoContrato WSSEND NULLPARAM WSRECEIVE oWSRetornarPedidoRequisicaoContratoResult WSCLIENT WSParPedido
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<RetornarPedidoRequisicaoContrato xmlns="http://tempuri.org/">'
cSoap += "</RetornarPedidoRequisicaoContrato>"

Self:_HEADOUT := { "Authorization: Bearer " + U_NewToken() }
oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tempuri.org/IPedido/RetornarPedidoRequisicaoContrato",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	Lower(AllTrim(GetMv("MV_XPARURL"))) + "/services/Pedido.svc")

::Init()
::oWSRetornarPedidoRequisicaoContratoResult:SoapRecv( WSAdvValue( oXmlRet,"_RETORNARPEDIDOREQUISICAOCONTRATORESPONSE:_RETORNARPEDIDOREQUISICAOCONTRATORESULT","ArrayOfPedidoDTO",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method RetornarPedidoLeilao of Service WSParPedido

WSMETHOD RetornarPedidoLeilao WSSEND lbFlNaoUtilizarDePara WSRECEIVE oWSRetornarPedidoLeilaoResult WSCLIENT WSParPedido
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<RetornarPedidoLeilao xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("bFlNaoUtilizarDePara", ::lbFlNaoUtilizarDePara, lbFlNaoUtilizarDePara , "boolean", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</RetornarPedidoLeilao>"

Self:_HEADOUT := { "Authorization: Bearer " + U_NewToken() }
oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tempuri.org/IPedido/RetornarPedidoLeilao",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	Lower(AllTrim(GetMv("MV_XPARURL"))) + "/services/Pedido.svc")

::Init()
::oWSRetornarPedidoLeilaoResult:SoapRecv( WSAdvValue( oXmlRet,"_RETORNARPEDIDOLEILAORESPONSE:_RETORNARPEDIDOLEILAORESULT","ArrayOfPedidoDTO",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method RetornarPedido of Service WSParPedido

WSMETHOD RetornarPedido WSSEND NULLPARAM WSRECEIVE oWSRetornarPedidoResult WSCLIENT WSParPedido
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<RetornarPedido xmlns="http://tempuri.org/">'
cSoap += "</RetornarPedido>"

Self:_HEADOUT := { "Authorization: Bearer " + U_NewToken() }
oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tempuri.org/IPedido/RetornarPedido",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	Lower(AllTrim(GetMv("MV_XPARURL"))) + "/services/Pedido.svc")

::Init()
::oWSRetornarPedidoResult:SoapRecv( WSAdvValue( oXmlRet,"_RETORNARPEDIDORESPONSE:_RETORNARPEDIDORESULT","ArrayOfPedidoDTO",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method RetornarPedidoCatalogo of Service WSParPedido

WSMETHOD RetornarPedidoCatalogo WSSEND lbFlNaoUtilizarDePara WSRECEIVE oWSRetornarPedidoCatalogoResult WSCLIENT WSParPedido
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<RetornarPedidoCatalogo xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("bFlNaoUtilizarDePara", ::lbFlNaoUtilizarDePara, lbFlNaoUtilizarDePara , "boolean", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</RetornarPedidoCatalogo>"

Self:_HEADOUT := { "Authorization: Bearer " + U_NewToken() }
oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tempuri.org/IPedido/RetornarPedidoCatalogo",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	Lower(AllTrim(GetMv("MV_XPARURL"))) + "/services/Pedido.svc")

::Init()
::oWSRetornarPedidoCatalogoResult:SoapRecv( WSAdvValue( oXmlRet,"_RETORNARPEDIDOCATALOGORESPONSE:_RETORNARPEDIDOCATALOGORESULT","ArrayOfPedidoDTO",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method ProcessarPedidoCancelamento of Service WSParPedido

WSMETHOD ProcessarPedidoCancelamento WSSEND oWSlstPedidoAtualizarDTO WSRECEIVE oWSProcessarPedidoCancelamentoResult WSCLIENT WSParPedido
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ProcessarPedidoCancelamento xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("lstPedidoAtualizarDTO", ::oWSlstPedidoAtualizarDTO, oWSlstPedidoAtualizarDTO , "ArrayOfPedidoAtualizarDTO", .F. , .F., 0 , "http://tempuri.org/", .F.,.F.) 
cSoap += "</ProcessarPedidoCancelamento>"

Self:_HEADOUT := { "Authorization: Bearer " + U_NewToken() }
oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tempuri.org/IPedido/ProcessarPedidoCancelamento",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	Lower(AllTrim(GetMv("MV_XPARURL"))) + "/services/Pedido.svc")

::Init()
::oWSProcessarPedidoCancelamentoResult:SoapRecv( WSAdvValue( oXmlRet,"_PROCESSARPEDIDOCANCELAMENTORESPONSE:_PROCESSARPEDIDOCANCELAMENTORESULT","RetornoDTO",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method RetornarPedidoAceite of Service WSParPedido

WSMETHOD RetornarPedidoAceite WSSEND NULLPARAM WSRECEIVE oWSRetornarPedidoAceiteResult WSCLIENT WSParPedido
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<RetornarPedidoAceite xmlns="http://tempuri.org/">'
cSoap += "</RetornarPedidoAceite>"

Self:_HEADOUT := { "Authorization: Bearer " + U_NewToken() }
oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tempuri.org/IPedido/RetornarPedidoAceite",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	Lower(AllTrim(GetMv("MV_XPARURL"))) + "/services/Pedido.svc")

::Init()
::oWSRetornarPedidoAceiteResult:SoapRecv( WSAdvValue( oXmlRet,"_RETORNARPEDIDOACEITERESPONSE:_RETORNARPEDIDOACEITERESULT","ArrayOfPedidoAtualizarDTO",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method RetornarPedidoCancelamento of Service WSParPedido

WSMETHOD RetornarPedidoCancelamento WSSEND NULLPARAM WSRECEIVE oWSRetornarPedidoCancelamentoResult WSCLIENT WSParPedido
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<RetornarPedidoCancelamento xmlns="http://tempuri.org/">'
cSoap += "</RetornarPedidoCancelamento>"

Self:_HEADOUT := { "Authorization: Bearer " + U_NewToken() }
oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tempuri.org/IPedido/RetornarPedidoCancelamento",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	Lower(AllTrim(GetMv("MV_XPARURL"))) + "/services/Pedido.svc")

::Init()
::oWSRetornarPedidoCancelamentoResult:SoapRecv( WSAdvValue( oXmlRet,"_RETORNARPEDIDOCANCELAMENTORESPONSE:_RETORNARPEDIDOCANCELAMENTORESULT","ArrayOfPedidoAtualizarDTO",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method RetornarPedidoConfirmado of Service WSParPedido

WSMETHOD RetornarPedidoConfirmado WSSEND NULLPARAM WSRECEIVE oWSRetornarPedidoConfirmadoResult WSCLIENT WSParPedido
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<RetornarPedidoConfirmado xmlns="http://tempuri.org/">'
cSoap += "</RetornarPedidoConfirmado>"

Self:_HEADOUT := { "Authorization: Bearer " + U_NewToken() }
oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tempuri.org/IPedido/RetornarPedidoConfirmado",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	Lower(AllTrim(GetMv("MV_XPARURL"))) + "/services/Pedido.svc")

::Init()
::oWSRetornarPedidoConfirmadoResult:SoapRecv( WSAdvValue( oXmlRet,"_RETORNARPEDIDOCONFIRMADORESPONSE:_RETORNARPEDIDOCONFIRMADORESULT","ArrayOfPedidoAtualizarDTO",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method RetornarTodosConfirmados of Service WSParPedido

WSMETHOD RetornarTodosConfirmados WSSEND NULLPARAM WSRECEIVE oWSRetornarTodosConfirmadosResult WSCLIENT WSParPedido
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<RetornarTodosConfirmados xmlns="http://tempuri.org/">'
cSoap += "</RetornarTodosConfirmados>"

Self:_HEADOUT := { "Authorization: Bearer " + U_NewToken() }
oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tempuri.org/IPedido/RetornarTodosConfirmados",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	Lower(AllTrim(GetMv("MV_XPARURL"))) + "/services/Pedido.svc")

::Init()
::oWSRetornarTodosConfirmadosResult:SoapRecv( WSAdvValue( oXmlRet,"_RETORNARTODOSCONFIRMADOSRESPONSE:_RETORNARTODOSCONFIRMADOSRESULT","ArrayOfPedidoDTO",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method HabilitarRetornarPedidoCancelamento of Service WSParPedido

WSMETHOD HabilitarRetornarPedidoCancelamento WSSEND oWSlstPedidoAtualizarDTO WSRECEIVE oWSHabilitarRetornarPedidoCancelamentoResult WSCLIENT WSParPedido
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<HabilitarRetornarPedidoCancelamento xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("lstPedidoAtualizarDTO", ::oWSlstPedidoAtualizarDTO, oWSlstPedidoAtualizarDTO , "ArrayOfPedidoAtualizarDTO", .F. , .F., 0 , "http://tempuri.org/", .F.,.F.) 
cSoap += "</HabilitarRetornarPedidoCancelamento>"

Self:_HEADOUT := { "Authorization: Bearer " + U_NewToken() }
oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tempuri.org/IPedido/HabilitarRetornarPedidoCancelamento",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	Lower(AllTrim(GetMv("MV_XPARURL"))) + "/services/Pedido.svc")

::Init()
::oWSHabilitarRetornarPedidoCancelamentoResult:SoapRecv( WSAdvValue( oXmlRet,"_HABILITARRETORNARPEDIDOCANCELAMENTORESPONSE:_HABILITARRETORNARPEDIDOCANCELAMENTORESULT","RetornoDTO",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method HabilitarRetornarPedidoConfirmado of Service WSParPedido

WSMETHOD HabilitarRetornarPedidoConfirmado WSSEND oWSlstPedidoAtualizarDTO WSRECEIVE oWSHabilitarRetornarPedidoConfirmadoResult WSCLIENT WSParPedido
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<HabilitarRetornarPedidoConfirmado xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("lstPedidoAtualizarDTO", ::oWSlstPedidoAtualizarDTO, oWSlstPedidoAtualizarDTO , "ArrayOfPedidoAtualizarDTO", .F. , .F., 0 , "http://tempuri.org/", .F.,.F.) 
cSoap += "</HabilitarRetornarPedidoConfirmado>"

Self:_HEADOUT := { "Authorization: Bearer " + U_NewToken() }
oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tempuri.org/IPedido/HabilitarRetornarPedidoConfirmado",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	Lower(AllTrim(GetMv("MV_XPARURL"))) + "/services/Pedido.svc")

::Init()
::oWSHabilitarRetornarPedidoConfirmadoResult:SoapRecv( WSAdvValue( oXmlRet,"_HABILITARRETORNARPEDIDOCONFIRMADORESPONSE:_HABILITARRETORNARPEDIDOCONFIRMADORESULT","RetornoDTO",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method ProcessarPedidoVersao of Service WSParPedido

WSMETHOD ProcessarPedidoVersao WSSEND oWSlstPedidoVersaoDTO WSRECEIVE oWSProcessarPedidoVersaoResult WSCLIENT WSParPedido
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ProcessarPedidoVersao xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("lstPedidoVersaoDTO", ::oWSlstPedidoVersaoDTO, oWSlstPedidoVersaoDTO , "ArrayOfPedidoVersaoDTO", .F. , .F., 0 , "http://tempuri.org/", .F.,.F.) 
cSoap += "</ProcessarPedidoVersao>"

Self:_HEADOUT := { "Authorization: Bearer " + U_NewToken() }
oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tempuri.org/IPedido/ProcessarPedidoVersao",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	Lower(AllTrim(GetMv("MV_XPARURL"))) + "/services/Pedido.svc")

::Init()
::oWSProcessarPedidoVersaoResult:SoapRecv( WSAdvValue( oXmlRet,"_PROCESSARPEDIDOVERSAORESPONSE:_PROCESSARPEDIDOVERSAORESULT","RetornoDTO",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method RetornarPedidoItemEntregaSolicitacaoAlteracao of Service WSParPedido

WSMETHOD RetornarPedidoItemEntregaSolicitacaoAlteracao WSSEND NULLPARAM WSRECEIVE oWSRetornarPedidoItemEntregaSolicitacaoAlteracaoResult WSCLIENT WSParPedido
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<RetornarPedidoItemEntregaSolicitacaoAlteracao xmlns="http://tempuri.org/">'
cSoap += "</RetornarPedidoItemEntregaSolicitacaoAlteracao>"

Self:_HEADOUT := { "Authorization: Bearer " + U_NewToken() }
oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tempuri.org/IPedido/RetornarPedidoItemEntregaSolicitacaoAlteracao",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	Lower(AllTrim(GetMv("MV_XPARURL"))) + "/services/Pedido.svc")

::Init()
::oWSRetornarPedidoItemEntregaSolicitacaoAlteracaoResult:SoapRecv( WSAdvValue( oXmlRet,"_RETORNARPEDIDOITEMENTREGASOLICITACAOALTERACAORESPONSE:_RETORNARPEDIDOITEMENTREGASOLICITACAOALTERACAORESULT","ArrayOfPedidoItemLogisticaDTO",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method HabilitarPedidoItemEntregaSolicitacaoAlteracao of Service WSParPedido

WSMETHOD HabilitarPedidoItemEntregaSolicitacaoAlteracao WSSEND oWSlstPedidoItemLogisticaDTO WSRECEIVE oWSHabilitarPedidoItemEntregaSolicitacaoAlteracaoResult WSCLIENT WSParPedido
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<HabilitarPedidoItemEntregaSolicitacaoAlteracao xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("lstPedidoItemLogisticaDTO", ::oWSlstPedidoItemLogisticaDTO, oWSlstPedidoItemLogisticaDTO , "ArrayOfPedidoItemLogisticaHabilitarDTO", .F. , .F., 0 , "http://tempuri.org/", .F.,.F.) 
cSoap += "</HabilitarPedidoItemEntregaSolicitacaoAlteracao>"

Self:_HEADOUT := { "Authorization: Bearer " + U_NewToken() }
oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tempuri.org/IPedido/HabilitarPedidoItemEntregaSolicitacaoAlteracao",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	Lower(AllTrim(GetMv("MV_XPARURL"))) + "/services/Pedido.svc")

::Init()
::oWSHabilitarPedidoItemEntregaSolicitacaoAlteracaoResult:SoapRecv( WSAdvValue( oXmlRet,"_HABILITARPEDIDOITEMENTREGASOLICITACAOALTERACAORESPONSE:_HABILITARPEDIDOITEMENTREGASOLICITACAOALTERACAORESULT","RetornoDTO",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method ProcessarPedidoItemEntregaSolicitacaoAlteracao of Service WSParPedido

WSMETHOD ProcessarPedidoItemEntregaSolicitacaoAlteracao WSSEND oWSlstPedidoItemLogisticaDTO WSRECEIVE oWSProcessarPedidoItemEntregaSolicitacaoAlteracaoResult WSCLIENT WSParPedido
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ProcessarPedidoItemEntregaSolicitacaoAlteracao xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("lstPedidoItemLogisticaDTO", ::oWSlstPedidoItemLogisticaDTO, oWSlstPedidoItemLogisticaDTO , "ArrayOfPedidoItemLogisticaDTO", .F. , .F., 0 , "http://tempuri.org/", .F.,.F.) 
cSoap += "</ProcessarPedidoItemEntregaSolicitacaoAlteracao>"

Self:_HEADOUT := { "Authorization: Bearer " + U_NewToken() }
oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tempuri.org/IPedido/ProcessarPedidoItemEntregaSolicitacaoAlteracao",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	Lower(AllTrim(GetMv("MV_XPARURL"))) + "/services/Pedido.svc")

::Init()
::oWSProcessarPedidoItemEntregaSolicitacaoAlteracaoResult:SoapRecv( WSAdvValue( oXmlRet,"_PROCESSARPEDIDOITEMENTREGASOLICITACAOALTERACAORESPONSE:_PROCESSARPEDIDOITEMENTREGASOLICITACAOALTERACAORESULT","RetornoDTO",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method ProcessarPedidoDetalhe of Service WSParPedido

WSMETHOD ProcessarPedidoDetalhe WSSEND oWSlstPedidoDetalhe WSRECEIVE oWSProcessarPedidoDetalheResult WSCLIENT WSParPedido
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ProcessarPedidoDetalhe xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("lstPedidoDetalhe", ::oWSlstPedidoDetalhe, oWSlstPedidoDetalhe , "ArrayOfPedidoDetalheDTO", .F. , .F., 0 , "http://tempuri.org/", .F.,.F.) 
cSoap += "</ProcessarPedidoDetalhe>"

Self:_HEADOUT := { "Authorization: Bearer " + U_NewToken() }
oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tempuri.org/IPedido/ProcessarPedidoDetalhe",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	Lower(AllTrim(GetMv("MV_XPARURL"))) + "/services/Pedido.svc")

::Init()
::oWSProcessarPedidoDetalheResult:SoapRecv( WSAdvValue( oXmlRet,"_PROCESSARPEDIDODETALHERESPONSE:_PROCESSARPEDIDODETALHERESULT","RetornoDTO",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method ProcessarPedidoItemEntregaLogistica of Service WSParPedido

WSMETHOD ProcessarPedidoItemEntregaLogistica WSSEND oWSlstPedidoItemEntregaLogisticaDTO WSRECEIVE oWSProcessarPedidoItemEntregaLogisticaResult WSCLIENT WSParPedido
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ProcessarPedidoItemEntregaLogistica xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("lstPedidoItemEntregaLogisticaDTO", ::oWSlstPedidoItemEntregaLogisticaDTO, oWSlstPedidoItemEntregaLogisticaDTO , "ArrayOfPedidoItemEntregaLogisticaDTO", .F. , .F., 0 , "http://tempuri.org/", .F.,.F.) 
cSoap += "</ProcessarPedidoItemEntregaLogistica>"

Self:_HEADOUT := { "Authorization: Bearer " + U_NewToken() }
oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tempuri.org/IPedido/ProcessarPedidoItemEntregaLogistica",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	Lower(AllTrim(GetMv("MV_XPARURL"))) + "/services/Pedido.svc")

::Init()
::oWSProcessarPedidoItemEntregaLogisticaResult:SoapRecv( WSAdvValue( oXmlRet,"_PROCESSARPEDIDOITEMENTREGALOGISTICARESPONSE:_PROCESSARPEDIDOITEMENTREGALOGISTICARESULT","RetornoDTO",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method ProcessarPedidoDadosCapa of Service WSParPedido

WSMETHOD ProcessarPedidoDadosCapa WSSEND oWSlstPedidoDetalhe WSRECEIVE oWSProcessarPedidoDadosCapaResult WSCLIENT WSParPedido
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ProcessarPedidoDadosCapa xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("lstPedidoDetalhe", ::oWSlstPedidoDetalhe, oWSlstPedidoDetalhe , "ArrayOfPedidoDetalheDTO", .F. , .F., 0 , "http://tempuri.org/", .F.,.F.) 
cSoap += "</ProcessarPedidoDadosCapa>"

Self:_HEADOUT := { "Authorization: Bearer " + U_NewToken() }
oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tempuri.org/IPedido/ProcessarPedidoDadosCapa",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	Lower(AllTrim(GetMv("MV_XPARURL"))) + "/services/Pedido.svc")

::Init()
::oWSProcessarPedidoDadosCapaResult:SoapRecv( WSAdvValue( oXmlRet,"_PROCESSARPEDIDODADOSCAPARESPONSE:_PROCESSARPEDIDODADOSCAPARESULT","RetornoDTO",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method RetornarCodigoPedidoSequencia of Service WSParPedido

WSMETHOD RetornarCodigoPedidoSequencia WSSEND NULLPARAM WSRECEIVE cRetornarCodigoPedidoSequenciaResult WSCLIENT WSParPedido
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<RetornarCodigoPedidoSequencia xmlns="http://tempuri.org/">'
cSoap += "</RetornarCodigoPedidoSequencia>"

Self:_HEADOUT := { "Authorization: Bearer " + U_NewToken() }
oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tempuri.org/IPedido/RetornarCodigoPedidoSequencia",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	Lower(AllTrim(GetMv("MV_XPARURL"))) + "/services/Pedido.svc")

::Init()
::cRetornarCodigoPedidoSequenciaResult :=  WSAdvValue( oXmlRet,"_RETORNARCODIGOPEDIDOSEQUENCIARESPONSE:_RETORNARCODIGOPEDIDOSEQUENCIARESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method HabilitarPedidoRequisicaoContrato of Service WSParPedido

WSMETHOD HabilitarPedidoRequisicaoContrato WSSEND csCdRequisicaoEmpresa,csCdItemRequisicaoEmpresa WSRECEIVE oWSHabilitarPedidoRequisicaoContratoResult WSCLIENT WSParPedido
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<HabilitarPedidoRequisicaoContrato xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("sCdRequisicaoEmpresa", ::csCdRequisicaoEmpresa, csCdRequisicaoEmpresa , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("sCdItemRequisicaoEmpresa", ::csCdItemRequisicaoEmpresa, csCdItemRequisicaoEmpresa , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</HabilitarPedidoRequisicaoContrato>"

Self:_HEADOUT := { "Authorization: Bearer " + U_NewToken() }
oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tempuri.org/IPedido/HabilitarPedidoRequisicaoContrato",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	Lower(AllTrim(GetMv("MV_XPARURL"))) + "/services/Pedido.svc")

::Init()
::oWSHabilitarPedidoRequisicaoContratoResult:SoapRecv( WSAdvValue( oXmlRet,"_HABILITARPEDIDOREQUISICAOCONTRATORESPONSE:_HABILITARPEDIDOREQUISICAOCONTRATORESULT","RetornoDTO",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method HabilitarRetornoPedidoCatalogo of Service WSParPedido

WSMETHOD HabilitarRetornoPedidoCatalogo WSSEND oWSlstPrePedidoAtualizarDTO WSRECEIVE oWSHabilitarRetornoPedidoCatalogoResult WSCLIENT WSParPedido
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<HabilitarRetornoPedidoCatalogo xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("lstPrePedidoAtualizarDTO", ::oWSlstPrePedidoAtualizarDTO, oWSlstPrePedidoAtualizarDTO , "ArrayOfPrePedidoAtualizarDTO", .F. , .F., 0 , "http://tempuri.org/", .F.,.F.) 
cSoap += "</HabilitarRetornoPedidoCatalogo>"

Self:_HEADOUT := { "Authorization: Bearer " + U_NewToken() }
oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tempuri.org/IPedido/HabilitarRetornoPedidoCatalogo",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	Lower(AllTrim(GetMv("MV_XPARURL"))) + "/services/Pedido.svc")

::Init()
::oWSHabilitarRetornoPedidoCatalogoResult:SoapRecv( WSAdvValue( oXmlRet,"_HABILITARRETORNOPEDIDOCATALOGORESPONSE:_HABILITARRETORNOPEDIDOCATALOGORESULT","RetornoDTO",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method RetornarPedidoCotacaoPorEmpresa of Service WSParPedido

WSMETHOD RetornarPedidoCotacaoPorEmpresa WSSEND oWSlstPedidoEmpresaDTO WSRECEIVE oWSRetornarPedidoCotacaoPorEmpresaResult WSCLIENT WSParPedido
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<RetornarPedidoCotacaoPorEmpresa xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("lstPedidoEmpresaDTO", ::oWSlstPedidoEmpresaDTO, oWSlstPedidoEmpresaDTO , "ArrayOfPedidoEmpresaDTO", .F. , .F., 0 , "http://tempuri.org/", .F.,.F.) 
cSoap += "</RetornarPedidoCotacaoPorEmpresa>"

Self:_HEADOUT := { "Authorization: Bearer " + U_NewToken() }
oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tempuri.org/IPedido/RetornarPedidoCotacaoPorEmpresa",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	Lower(AllTrim(GetMv("MV_XPARURL"))) + "/services/Pedido.svc")

::Init()
::oWSRetornarPedidoCotacaoPorEmpresaResult:SoapRecv( WSAdvValue( oXmlRet,"_RETORNARPEDIDOCOTACAOPOREMPRESARESPONSE:_RETORNARPEDIDOCOTACAOPOREMPRESARESULT","ArrayOfPedidoDTO",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method RetornarTodosPedidosEmProcessoDeIntegracao of Service WSParPedido

WSMETHOD RetornarTodosPedidosEmProcessoDeIntegracao WSSEND NULLPARAM WSRECEIVE oWSRetornarTodosPedidosEmProcessoDeIntegracaoResult WSCLIENT WSParPedido
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<RetornarTodosPedidosEmProcessoDeIntegracao xmlns="http://tempuri.org/">'
cSoap += "</RetornarTodosPedidosEmProcessoDeIntegracao>"

Self:_HEADOUT := { "Authorization: Bearer " + U_NewToken() }
oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tempuri.org/IPedido/RetornarTodosPedidosEmProcessoDeIntegracao",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	Lower(AllTrim(GetMv("MV_XPARURL"))) + "/services/Pedido.svc")

::Init()
::oWSRetornarTodosPedidosEmProcessoDeIntegracaoResult:SoapRecv( WSAdvValue( oXmlRet,"_RETORNARTODOSPEDIDOSEMPROCESSODEINTEGRACAORESPONSE:_RETORNARTODOSPEDIDOSEMPROCESSODEINTEGRACAORESULT","ArrayOfPedidoDTO",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method AtualizarNumeroPedidoPortal of Service WSParPedido

WSMETHOD AtualizarNumeroPedidoPortal WSSEND oWSlstPedidoNumeroDTO WSRECEIVE oWSAtualizarNumeroPedidoPortalResult WSCLIENT WSParPedido
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<AtualizarNumeroPedidoPortal xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("lstPedidoNumeroDTO", ::oWSlstPedidoNumeroDTO, oWSlstPedidoNumeroDTO , "ArrayOfPedidoNumeroDTO", .F. , .F., 0 , "http://tempuri.org/", .F.,.F.) 
cSoap += "</AtualizarNumeroPedidoPortal>"

Self:_HEADOUT := { "Authorization: Bearer " + U_NewToken() }
oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tempuri.org/IPedido/AtualizarNumeroPedidoPortal",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	Lower(AllTrim(GetMv("MV_XPARURL"))) + "/services/Pedido.svc")

::Init()
::oWSAtualizarNumeroPedidoPortalResult:SoapRecv( WSAdvValue( oXmlRet,"_ATUALIZARNUMEROPEDIDOPORTALRESPONSE:_ATUALIZARNUMEROPEDIDOPORTALRESULT","RetornoDTO",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method RetornarCodigoSituacaoDefault of Service WSParPedido

WSMETHOD RetornarCodigoSituacaoDefault WSSEND NULLPARAM WSRECEIVE nRetornarCodigoSituacaoDefaultResult WSCLIENT WSParPedido
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<RetornarCodigoSituacaoDefault xmlns="http://tempuri.org/">'
cSoap += "</RetornarCodigoSituacaoDefault>"

Self:_HEADOUT := { "Authorization: Bearer " + U_NewToken() }
oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tempuri.org/IPedido/RetornarCodigoSituacaoDefault",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	Lower(AllTrim(GetMv("MV_XPARURL"))) + "/services/Pedido.svc")

::Init()
::nRetornarCodigoSituacaoDefaultResult :=  WSAdvValue( oXmlRet,"_RETORNARCODIGOSITUACAODEFAULTRESPONSE:_RETORNARCODIGOSITUACAODEFAULTRESULT:TEXT","long",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.


// WSDL Data Structure ArrayOfPedidoDTO

WSSTRUCT Pedido_ArrayOfPedidoDTO
	WSDATA   oWSParPedidoDTO              AS Pedido_PedidoDTO OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Pedido_ArrayOfPedidoDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Pedido_ArrayOfPedidoDTO
	::oWSParPedidoDTO         := {} // Array Of  Pedido_PEDIDODTO():New()
Return

WSMETHOD CLONE WSCLIENT Pedido_ArrayOfPedidoDTO
	Local oClone := Pedido_ArrayOfPedidoDTO():NEW()
	oClone:oWSParPedidoDTO := NIL
	If ::oWSParPedidoDTO <> NIL 
		oClone:oWSParPedidoDTO := {}
		aEval( ::oWSParPedidoDTO , { |x| aadd( oClone:oWSParPedidoDTO , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT Pedido_ArrayOfPedidoDTO
	Local cSoap := ""
	aEval( ::oWSParPedidoDTO , {|x| cSoap := cSoap  +  WSSoapValue("PedidoDTO", x , x , "PedidoDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.)  } ) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Pedido_ArrayOfPedidoDTO
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_PEDIDODTO","PedidoDTO",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSParPedidoDTO , Pedido_PedidoDTO():New() )
			::oWSParPedidoDTO[len(::oWSParPedidoDTO)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure RetornoDTO

WSSTRUCT Pedido_RetornoDTO
	WSDATA   oWSlstWbtLogDTO           AS Pedido_ArrayOfWbtLogDTO OPTIONAL
	WSDATA   nnIdRetorno               AS long OPTIONAL
	WSDATA   csNrToken                 AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Pedido_RetornoDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Pedido_RetornoDTO
Return

WSMETHOD CLONE WSCLIENT Pedido_RetornoDTO
	Local oClone := Pedido_RetornoDTO():NEW()
	oClone:oWSlstWbtLogDTO      := IIF(::oWSlstWbtLogDTO = NIL , NIL , ::oWSlstWbtLogDTO:Clone() )
	oClone:nnIdRetorno          := ::nnIdRetorno
	oClone:csNrToken            := ::csNrToken
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Pedido_RetornoDTO
	Local oNode1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_LSTWBTLOGDTO","ArrayOfWbtLogDTO",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode1 != NIL
		::oWSlstWbtLogDTO := Pedido_ArrayOfWbtLogDTO():New()
		::oWSlstWbtLogDTO:SoapRecv(oNode1)
	EndIf
	::nnIdRetorno        :=  WSAdvValue( oResponse,"_NIDRETORNO","long",NIL,NIL,NIL,"N",NIL,NIL) 
	::csNrToken          :=  WSAdvValue( oResponse,"_SNRTOKEN","string",NIL,NIL,NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure ArrayOfPedidoAtualizarDTO

WSSTRUCT Pedido_ArrayOfPedidoAtualizarDTO
	WSDATA   oWSParPedidoAtualizarDTO     AS Pedido_PedidoAtualizarDTO OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Pedido_ArrayOfPedidoAtualizarDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Pedido_ArrayOfPedidoAtualizarDTO
	::oWSParPedidoAtualizarDTO := {} // Array Of  Pedido_PEDIDOATUALIZARDTO():New()
Return

WSMETHOD CLONE WSCLIENT Pedido_ArrayOfPedidoAtualizarDTO
	Local oClone := Pedido_ArrayOfPedidoAtualizarDTO():NEW()
	oClone:oWSParPedidoAtualizarDTO := NIL
	If ::oWSParPedidoAtualizarDTO <> NIL 
		oClone:oWSParPedidoAtualizarDTO := {}
		aEval( ::oWSParPedidoAtualizarDTO , { |x| aadd( oClone:oWSParPedidoAtualizarDTO , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT Pedido_ArrayOfPedidoAtualizarDTO
	Local cSoap := ""
	aEval( ::oWSParPedidoAtualizarDTO , {|x| cSoap := cSoap  +  WSSoapValue("PedidoAtualizarDTO", x , x , "PedidoAtualizarDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.)  } ) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Pedido_ArrayOfPedidoAtualizarDTO
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_PEDIDOATUALIZARDTO","PedidoAtualizarDTO",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSParPedidoAtualizarDTO , Pedido_PedidoAtualizarDTO():New() )
			::oWSParPedidoAtualizarDTO[len(::oWSParPedidoAtualizarDTO)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure ArrayOfPedidoVersaoDTO

WSSTRUCT Pedido_ArrayOfPedidoVersaoDTO
	WSDATA   oWSParPedidoVersaoDTO        AS Pedido_PedidoVersaoDTO OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Pedido_ArrayOfPedidoVersaoDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Pedido_ArrayOfPedidoVersaoDTO
	::oWSParPedidoVersaoDTO   := {} // Array Of  Pedido_PEDIDOVERSAODTO():New()
Return

WSMETHOD CLONE WSCLIENT Pedido_ArrayOfPedidoVersaoDTO
	Local oClone := Pedido_ArrayOfPedidoVersaoDTO():NEW()
	oClone:oWSParPedidoVersaoDTO := NIL
	If ::oWSParPedidoVersaoDTO <> NIL 
		oClone:oWSParPedidoVersaoDTO := {}
		aEval( ::oWSParPedidoVersaoDTO , { |x| aadd( oClone:oWSParPedidoVersaoDTO , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT Pedido_ArrayOfPedidoVersaoDTO
	Local cSoap := ""
	aEval( ::oWSParPedidoVersaoDTO , {|x| cSoap := cSoap  +  WSSoapValue("PedidoVersaoDTO", x , x , "PedidoVersaoDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.)  } ) 
Return cSoap

// WSDL Data Structure ArrayOfPedidoItemLogisticaDTO

WSSTRUCT Pedido_ArrayOfPedidoItemLogisticaDTO
	WSDATA   oWSParPedidoItemLogisticaDTO AS Pedido_PedidoItemLogisticaDTO OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Pedido_ArrayOfPedidoItemLogisticaDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Pedido_ArrayOfPedidoItemLogisticaDTO
	::oWSParPedidoItemLogisticaDTO := {} // Array Of  Pedido_PEDIDOITEMLOGISTICADTO():New()
Return

WSMETHOD CLONE WSCLIENT Pedido_ArrayOfPedidoItemLogisticaDTO
	Local oClone := Pedido_ArrayOfPedidoItemLogisticaDTO():NEW()
	oClone:oWSParPedidoItemLogisticaDTO := NIL
	If ::oWSParPedidoItemLogisticaDTO <> NIL 
		oClone:oWSParPedidoItemLogisticaDTO := {}
		aEval( ::oWSParPedidoItemLogisticaDTO , { |x| aadd( oClone:oWSParPedidoItemLogisticaDTO , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT Pedido_ArrayOfPedidoItemLogisticaDTO
	Local cSoap := ""
	aEval( ::oWSParPedidoItemLogisticaDTO , {|x| cSoap := cSoap  +  WSSoapValue("PedidoItemLogisticaDTO", x , x , "PedidoItemLogisticaDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.)  } ) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Pedido_ArrayOfPedidoItemLogisticaDTO
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_PEDIDOITEMLOGISTICADTO","PedidoItemLogisticaDTO",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSParPedidoItemLogisticaDTO , Pedido_PedidoItemLogisticaDTO():New() )
			::oWSParPedidoItemLogisticaDTO[len(::oWSParPedidoItemLogisticaDTO)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure ArrayOfPedidoItemLogisticaHabilitarDTO

WSSTRUCT Pedido_ArrayOfPedidoItemLogisticaHabilitarDTO
	WSDATA   oWSParPedidoItemLogisticaHabilitarDTO AS Pedido_PedidoItemLogisticaHabilitarDTO OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Pedido_ArrayOfPedidoItemLogisticaHabilitarDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Pedido_ArrayOfPedidoItemLogisticaHabilitarDTO
	::oWSParPedidoItemLogisticaHabilitarDTO := {} // Array Of  Pedido_PEDIDOITEMLOGISTICAHABILITARDTO():New()
Return

WSMETHOD CLONE WSCLIENT Pedido_ArrayOfPedidoItemLogisticaHabilitarDTO
	Local oClone := Pedido_ArrayOfPedidoItemLogisticaHabilitarDTO():NEW()
	oClone:oWSParPedidoItemLogisticaHabilitarDTO := NIL
	If ::oWSParPedidoItemLogisticaHabilitarDTO <> NIL 
		oClone:oWSParPedidoItemLogisticaHabilitarDTO := {}
		aEval( ::oWSParPedidoItemLogisticaHabilitarDTO , { |x| aadd( oClone:oWSParPedidoItemLogisticaHabilitarDTO , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT Pedido_ArrayOfPedidoItemLogisticaHabilitarDTO
	Local cSoap := ""
	aEval( ::oWSParPedidoItemLogisticaHabilitarDTO , {|x| cSoap := cSoap  +  WSSoapValue("PedidoItemLogisticaHabilitarDTO", x , x , "PedidoItemLogisticaHabilitarDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.)  } ) 
Return cSoap

// WSDL Data Structure ArrayOfPedidoDetalheDTO

WSSTRUCT Pedido_ArrayOfPedidoDetalheDTO
	WSDATA   oWSParPedidoDetalheDTO       AS Pedido_PedidoDetalheDTO OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Pedido_ArrayOfPedidoDetalheDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Pedido_ArrayOfPedidoDetalheDTO
	::oWSParPedidoDetalheDTO  := {} // Array Of  Pedido_PEDIDODETALHEDTO():New()
Return

WSMETHOD CLONE WSCLIENT Pedido_ArrayOfPedidoDetalheDTO
	Local oClone := Pedido_ArrayOfPedidoDetalheDTO():NEW()
	oClone:oWSParPedidoDetalheDTO := NIL
	If ::oWSParPedidoDetalheDTO <> NIL 
		oClone:oWSParPedidoDetalheDTO := {}
		aEval( ::oWSParPedidoDetalheDTO , { |x| aadd( oClone:oWSParPedidoDetalheDTO , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT Pedido_ArrayOfPedidoDetalheDTO
	Local cSoap := ""
	aEval( ::oWSParPedidoDetalheDTO , {|x| cSoap := cSoap  +  WSSoapValue("PedidoDetalheDTO", x , x , "PedidoDetalheDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.)  } ) 
Return cSoap

// WSDL Data Structure ArrayOfPedidoItemEntregaLogisticaDTO

WSSTRUCT Pedido_ArrayOfPedidoItemEntregaLogisticaDTO
	WSDATA   oWSParPedidoItemEntregaLogisticaDTO AS Pedido_PedidoItemEntregaLogisticaDTO OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Pedido_ArrayOfPedidoItemEntregaLogisticaDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Pedido_ArrayOfPedidoItemEntregaLogisticaDTO
	::oWSParPedidoItemEntregaLogisticaDTO := {} // Array Of  Pedido_PEDIDOITEMENTREGALOGISTICADTO():New()
Return

WSMETHOD CLONE WSCLIENT Pedido_ArrayOfPedidoItemEntregaLogisticaDTO
	Local oClone := Pedido_ArrayOfPedidoItemEntregaLogisticaDTO():NEW()
	oClone:oWSParPedidoItemEntregaLogisticaDTO := NIL
	If ::oWSParPedidoItemEntregaLogisticaDTO <> NIL 
		oClone:oWSParPedidoItemEntregaLogisticaDTO := {}
		aEval( ::oWSParPedidoItemEntregaLogisticaDTO , { |x| aadd( oClone:oWSParPedidoItemEntregaLogisticaDTO , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT Pedido_ArrayOfPedidoItemEntregaLogisticaDTO
	Local cSoap := ""
	aEval( ::oWSParPedidoItemEntregaLogisticaDTO , {|x| cSoap := cSoap  +  WSSoapValue("PedidoItemEntregaLogisticaDTO", x , x , "PedidoItemEntregaLogisticaDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.)  } ) 
Return cSoap

// WSDL Data Structure ArrayOfPrePedidoAtualizarDTO

WSSTRUCT Pedido_ArrayOfPrePedidoAtualizarDTO
	WSDATA   oWSPrePedidoAtualizarDTO  AS Pedido_PrePedidoAtualizarDTO OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Pedido_ArrayOfPrePedidoAtualizarDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Pedido_ArrayOfPrePedidoAtualizarDTO
	::oWSPrePedidoAtualizarDTO := {} // Array Of  Pedido_PREPEDIDOATUALIZARDTO():New()
Return

WSMETHOD CLONE WSCLIENT Pedido_ArrayOfPrePedidoAtualizarDTO
	Local oClone := Pedido_ArrayOfPrePedidoAtualizarDTO():NEW()
	oClone:oWSPrePedidoAtualizarDTO := NIL
	If ::oWSPrePedidoAtualizarDTO <> NIL 
		oClone:oWSPrePedidoAtualizarDTO := {}
		aEval( ::oWSPrePedidoAtualizarDTO , { |x| aadd( oClone:oWSPrePedidoAtualizarDTO , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT Pedido_ArrayOfPrePedidoAtualizarDTO
	Local cSoap := ""
	aEval( ::oWSPrePedidoAtualizarDTO , {|x| cSoap := cSoap  +  WSSoapValue("PrePedidoAtualizarDTO", x , x , "PrePedidoAtualizarDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.)  } ) 
Return cSoap

// WSDL Data Structure ArrayOfPedidoEmpresaDTO

WSSTRUCT Pedido_ArrayOfPedidoEmpresaDTO
	WSDATA   oWSParPedidoEmpresaDTO       AS Pedido_PedidoEmpresaDTO OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Pedido_ArrayOfPedidoEmpresaDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Pedido_ArrayOfPedidoEmpresaDTO
	::oWSParPedidoEmpresaDTO  := {} // Array Of  Pedido_PEDIDOEMPRESADTO():New()
Return

WSMETHOD CLONE WSCLIENT Pedido_ArrayOfPedidoEmpresaDTO
	Local oClone := Pedido_ArrayOfPedidoEmpresaDTO():NEW()
	oClone:oWSParPedidoEmpresaDTO := NIL
	If ::oWSParPedidoEmpresaDTO <> NIL 
		oClone:oWSParPedidoEmpresaDTO := {}
		aEval( ::oWSParPedidoEmpresaDTO , { |x| aadd( oClone:oWSParPedidoEmpresaDTO , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT Pedido_ArrayOfPedidoEmpresaDTO
	Local cSoap := ""
	aEval( ::oWSParPedidoEmpresaDTO , {|x| cSoap := cSoap  +  WSSoapValue("PedidoEmpresaDTO", x , x , "PedidoEmpresaDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.)  } ) 
Return cSoap

// WSDL Data Structure ArrayOfPedidoNumeroDTO

WSSTRUCT Pedido_ArrayOfPedidoNumeroDTO
	WSDATA   oWSParPedidoNumeroDTO        AS Pedido_PedidoNumeroDTO OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Pedido_ArrayOfPedidoNumeroDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Pedido_ArrayOfPedidoNumeroDTO
	::oWSParPedidoNumeroDTO   := {} // Array Of  Pedido_PEDIDONUMERODTO():New()
Return

WSMETHOD CLONE WSCLIENT Pedido_ArrayOfPedidoNumeroDTO
	Local oClone := Pedido_ArrayOfPedidoNumeroDTO():NEW()
	oClone:oWSParPedidoNumeroDTO := NIL
	If ::oWSParPedidoNumeroDTO <> NIL 
		oClone:oWSParPedidoNumeroDTO := {}
		aEval( ::oWSParPedidoNumeroDTO , { |x| aadd( oClone:oWSParPedidoNumeroDTO , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT Pedido_ArrayOfPedidoNumeroDTO
	Local cSoap := ""
	aEval( ::oWSParPedidoNumeroDTO , {|x| cSoap := cSoap  +  WSSoapValue("PedidoNumeroDTO", x , x , "PedidoNumeroDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.)  } ) 
Return cSoap

// WSDL Data Structure PedidoDTO

WSSTRUCT Pedido_PedidoDTO
	WSDATA   ndVlFrete                 AS decimal OPTIONAL
	WSDATA   ndVlTotal                 AS decimal OPTIONAL
	WSDATA   oWSlstAnexo               AS Pedido_ArrayOfAnexoDTO OPTIONAL
	WSDATA   oWSlstPedidoItem          AS Pedido_ArrayOfPedidoItemDTO OPTIONAL
	WSDATA   nnCdPedido                AS long OPTIONAL
	WSDATA   nnCdSituacao              AS long OPTIONAL
	WSDATA   nnCdTipo                  AS long OPTIONAL
	WSDATA   nnIdTipoOrigem            AS int OPTIONAL
	WSDATA   nnNrVersao                AS int OPTIONAL
	WSDATA   csCdCentroCusto           AS string OPTIONAL
	WSDATA   csCdComprador             AS string OPTIONAL
	WSDATA   csCdCondicaoPagamento     AS string OPTIONAL
	WSDATA   csCdEstrategiaAprovacao   AS string OPTIONAL
	WSDATA   csCdFonteRecurso          AS string OPTIONAL
	WSDATA   csCdFornecedor            AS string OPTIONAL
	WSDATA   csCdFrete                 AS string OPTIONAL
	WSDATA   csCdGrupoCompra           AS string OPTIONAL
	WSDATA   csCdMoeda                 AS string OPTIONAL
	WSDATA   csCdPedidoERP             AS string OPTIONAL
	WSDATA   csCdPedidoWBC             AS string OPTIONAL
	WSDATA   csCdProjeto               AS string OPTIONAL
	WSDATA   csCdTransportadora        AS string OPTIONAL
	WSDATA   csCdUsuario               AS string OPTIONAL
	WSDATA   csCdUsuarioProgramador    AS string OPTIONAL
	WSDATA   csDsObservacoes           AS string OPTIONAL
	WSDATA   csDsPedidoAuditoria       AS string OPTIONAL
	WSDATA   csDsPedidoJustificativa   AS string OPTIONAL
	WSDATA   csNrProjeto               AS string OPTIONAL
	WSDATA   csNrRgPesquisador         AS string OPTIONAL
	WSDATA   ctDtCadastro              AS dateTime OPTIONAL
	WSDATA   ctDtEmissao               AS dateTime OPTIONAL
	WSDATA   ctDtFaturamento           AS dateTime OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Pedido_PedidoDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Pedido_PedidoDTO
Return

WSMETHOD CLONE WSCLIENT Pedido_PedidoDTO
	Local oClone := Pedido_PedidoDTO():NEW()
	oClone:ndVlFrete            := ::ndVlFrete
	oClone:ndVlTotal            := ::ndVlTotal
	oClone:oWSlstAnexo          := IIF(::oWSlstAnexo = NIL , NIL , ::oWSlstAnexo:Clone() )
	oClone:oWSlstPedidoItem     := IIF(::oWSlstPedidoItem = NIL , NIL , ::oWSlstPedidoItem:Clone() )
	oClone:nnCdPedido           := ::nnCdPedido
	oClone:nnCdSituacao         := ::nnCdSituacao
	oClone:nnCdTipo             := ::nnCdTipo
	oClone:nnIdTipoOrigem       := ::nnIdTipoOrigem
	oClone:nnNrVersao           := ::nnNrVersao
	oClone:csCdCentroCusto      := ::csCdCentroCusto
	oClone:csCdComprador        := ::csCdComprador
	oClone:csCdCondicaoPagamento := ::csCdCondicaoPagamento
	oClone:csCdEstrategiaAprovacao := ::csCdEstrategiaAprovacao
	oClone:csCdFonteRecurso     := ::csCdFonteRecurso
	oClone:csCdFornecedor       := ::csCdFornecedor
	oClone:csCdFrete            := ::csCdFrete
	oClone:csCdGrupoCompra      := ::csCdGrupoCompra
	oClone:csCdMoeda            := ::csCdMoeda
	oClone:csCdPedidoERP        := ::csCdPedidoERP
	oClone:csCdPedidoWBC        := ::csCdPedidoWBC
	oClone:csCdProjeto          := ::csCdProjeto
	oClone:csCdTransportadora   := ::csCdTransportadora
	oClone:csCdUsuario          := ::csCdUsuario
	oClone:csCdUsuarioProgramador := ::csCdUsuarioProgramador
	oClone:csDsObservacoes      := ::csDsObservacoes
	oClone:csDsPedidoAuditoria  := ::csDsPedidoAuditoria
	oClone:csDsPedidoJustificativa := ::csDsPedidoJustificativa
	oClone:csNrProjeto          := ::csNrProjeto
	oClone:csNrRgPesquisador    := ::csNrRgPesquisador
	oClone:ctDtCadastro         := ::ctDtCadastro
	oClone:ctDtEmissao          := ::ctDtEmissao
	oClone:ctDtFaturamento      := ::ctDtFaturamento
Return oClone

WSMETHOD SOAPSEND WSCLIENT Pedido_PedidoDTO
	Local cSoap := ""
	cSoap += WSSoapValue("dVlFrete", ::ndVlFrete, ::ndVlFrete , "decimal", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("dVlTotal", ::ndVlTotal, ::ndVlTotal , "decimal", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("lstAnexo", ::oWSlstAnexo, ::oWSlstAnexo , "ArrayOfAnexoDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("lstPedidoItem", ::oWSlstPedidoItem, ::oWSlstPedidoItem , "ArrayOfPedidoItemDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("nCdPedido", ::nnCdPedido, ::nnCdPedido , "long", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("nCdSituacao", ::nnCdSituacao, ::nnCdSituacao , "long", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("nCdTipo", ::nnCdTipo, ::nnCdTipo , "long", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("nIdTipoOrigem", ::nnIdTipoOrigem, ::nnIdTipoOrigem , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("nNrVersao", ::nnNrVersao, ::nnNrVersao , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdCentroCusto", ::csCdCentroCusto, ::csCdCentroCusto , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdComprador", ::csCdComprador, ::csCdComprador , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdCondicaoPagamento", ::csCdCondicaoPagamento, ::csCdCondicaoPagamento , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdEstrategiaAprovacao", ::csCdEstrategiaAprovacao, ::csCdEstrategiaAprovacao , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdFonteRecurso", ::csCdFonteRecurso, ::csCdFonteRecurso , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdFornecedor", ::csCdFornecedor, ::csCdFornecedor , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdFrete", ::csCdFrete, ::csCdFrete , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdGrupoCompra", ::csCdGrupoCompra, ::csCdGrupoCompra , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdMoeda", ::csCdMoeda, ::csCdMoeda , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdPedidoERP", ::csCdPedidoERP, ::csCdPedidoERP , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdPedidoWBC", ::csCdPedidoWBC, ::csCdPedidoWBC , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdProjeto", ::csCdProjeto, ::csCdProjeto , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdTransportadora", ::csCdTransportadora, ::csCdTransportadora , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdUsuario", ::csCdUsuario, ::csCdUsuario , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdUsuarioProgramador", ::csCdUsuarioProgramador, ::csCdUsuarioProgramador , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sDsObservacoes", ::csDsObservacoes, ::csDsObservacoes , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sDsPedidoAuditoria", ::csDsPedidoAuditoria, ::csDsPedidoAuditoria , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sDsPedidoJustificativa", ::csDsPedidoJustificativa, ::csDsPedidoJustificativa , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sNrProjeto", ::csNrProjeto, ::csNrProjeto , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sNrRgPesquisador", ::csNrRgPesquisador, ::csNrRgPesquisador , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("tDtCadastro", ::ctDtCadastro, ::ctDtCadastro , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("tDtEmissao", ::ctDtEmissao, ::ctDtEmissao , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("tDtFaturamento", ::ctDtFaturamento, ::ctDtFaturamento , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Pedido_PedidoDTO
	Local oNode3
	Local oNode4
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::ndVlFrete          :=  WSAdvValue( oResponse,"_DVLFRETE","decimal",NIL,NIL,NIL,"N",NIL,NIL) 
	::ndVlTotal          :=  WSAdvValue( oResponse,"_DVLTOTAL","decimal",NIL,NIL,NIL,"N",NIL,NIL) 
	oNode3 :=  WSAdvValue( oResponse,"_LSTANEXO","ArrayOfAnexoDTO",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode3 != NIL
		::oWSlstAnexo := Pedido_ArrayOfAnexoDTO():New()
		::oWSlstAnexo:SoapRecv(oNode3)
	EndIf
	oNode4 :=  WSAdvValue( oResponse,"_LSTPEDIDOITEM","ArrayOfPedidoItemDTO",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode4 != NIL
		::oWSlstPedidoItem := Pedido_ArrayOfPedidoItemDTO():New()
		::oWSlstPedidoItem:SoapRecv(oNode4)
	EndIf
	::nnCdPedido         :=  WSAdvValue( oResponse,"_NCDPEDIDO","long",NIL,NIL,NIL,"N",NIL,NIL) 
	::nnCdSituacao       :=  WSAdvValue( oResponse,"_NCDSITUACAO","long",NIL,NIL,NIL,"N",NIL,NIL) 
	::nnCdTipo           :=  WSAdvValue( oResponse,"_NCDTIPO","long",NIL,NIL,NIL,"N",NIL,NIL) 
	::nnIdTipoOrigem     :=  WSAdvValue( oResponse,"_NIDTIPOORIGEM","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::nnNrVersao         :=  WSAdvValue( oResponse,"_NNRVERSAO","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::csCdCentroCusto    :=  WSAdvValue( oResponse,"_SCDCENTROCUSTO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdComprador      :=  WSAdvValue( oResponse,"_SCDCOMPRADOR","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdCondicaoPagamento :=  WSAdvValue( oResponse,"_SCDCONDICAOPAGAMENTO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdEstrategiaAprovacao :=  WSAdvValue( oResponse,"_SCDESTRATEGIAAPROVACAO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdFonteRecurso   :=  WSAdvValue( oResponse,"_SCDFONTERECURSO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdFornecedor     :=  WSAdvValue( oResponse,"_SCDFORNECEDOR","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdFrete          :=  WSAdvValue( oResponse,"_SCDFRETE","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdGrupoCompra    :=  WSAdvValue( oResponse,"_SCDGRUPOCOMPRA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdMoeda          :=  WSAdvValue( oResponse,"_SCDMOEDA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdPedidoERP      :=  WSAdvValue( oResponse,"_SCDPEDIDOERP","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdPedidoWBC      :=  WSAdvValue( oResponse,"_SCDPEDIDOWBC","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdProjeto        :=  WSAdvValue( oResponse,"_SCDPROJETO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdTransportadora :=  WSAdvValue( oResponse,"_SCDTRANSPORTADORA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdUsuario        :=  WSAdvValue( oResponse,"_SCDUSUARIO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdUsuarioProgramador :=  WSAdvValue( oResponse,"_SCDUSUARIOPROGRAMADOR","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csDsObservacoes    :=  WSAdvValue( oResponse,"_SDSOBSERVACOES","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csDsPedidoAuditoria :=  WSAdvValue( oResponse,"_SDSPEDIDOAUDITORIA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csDsPedidoJustificativa :=  WSAdvValue( oResponse,"_SDSPEDIDOJUSTIFICATIVA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csNrProjeto        :=  WSAdvValue( oResponse,"_SNRPROJETO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csNrRgPesquisador  :=  WSAdvValue( oResponse,"_SNRRGPESQUISADOR","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::ctDtCadastro       :=  WSAdvValue( oResponse,"_TDTCADASTRO","dateTime",NIL,NIL,NIL,"S",NIL,NIL) 
	::ctDtEmissao        :=  WSAdvValue( oResponse,"_TDTEMISSAO","dateTime",NIL,NIL,NIL,"S",NIL,NIL) 
	::ctDtFaturamento    :=  WSAdvValue( oResponse,"_TDTFATURAMENTO","dateTime",NIL,NIL,NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure ArrayOfWbtLogDTO

WSSTRUCT Pedido_ArrayOfWbtLogDTO
	WSDATA   oWSWbtLogDTO              AS Pedido_WbtLogDTO OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Pedido_ArrayOfWbtLogDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Pedido_ArrayOfWbtLogDTO
	::oWSWbtLogDTO         := {} // Array Of  Pedido_WBTLOGDTO():New()
Return

WSMETHOD CLONE WSCLIENT Pedido_ArrayOfWbtLogDTO
	Local oClone := Pedido_ArrayOfWbtLogDTO():NEW()
	oClone:oWSWbtLogDTO := NIL
	If ::oWSWbtLogDTO <> NIL 
		oClone:oWSWbtLogDTO := {}
		aEval( ::oWSWbtLogDTO , { |x| aadd( oClone:oWSWbtLogDTO , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Pedido_ArrayOfWbtLogDTO
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_WBTLOGDTO","WbtLogDTO",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSWbtLogDTO , Pedido_WbtLogDTO():New() )
			::oWSWbtLogDTO[len(::oWSWbtLogDTO)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure PedidoAtualizarDTO

WSSTRUCT Pedido_PedidoAtualizarDTO
	WSDATA   nnCdSituacao              AS long OPTIONAL
	WSDATA   csCdComprador             AS string OPTIONAL
	WSDATA   csCdPedidoErp             AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Pedido_PedidoAtualizarDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Pedido_PedidoAtualizarDTO
Return

WSMETHOD CLONE WSCLIENT Pedido_PedidoAtualizarDTO
	Local oClone := Pedido_PedidoAtualizarDTO():NEW()
	oClone:nnCdSituacao         := ::nnCdSituacao
	oClone:csCdComprador        := ::csCdComprador
	oClone:csCdPedidoErp        := ::csCdPedidoErp
Return oClone

WSMETHOD SOAPSEND WSCLIENT Pedido_PedidoAtualizarDTO
	Local cSoap := ""
	cSoap += WSSoapValue("nCdSituacao", ::nnCdSituacao, ::nnCdSituacao , "long", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdComprador", ::csCdComprador, ::csCdComprador , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdPedidoErp", ::csCdPedidoErp, ::csCdPedidoErp , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Pedido_PedidoAtualizarDTO
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::nnCdSituacao       :=  WSAdvValue( oResponse,"_NCDSITUACAO","long",NIL,NIL,NIL,"N",NIL,NIL) 
	::csCdComprador      :=  WSAdvValue( oResponse,"_SCDCOMPRADOR","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdPedidoErp      :=  WSAdvValue( oResponse,"_SCDPEDIDOERP","string",NIL,NIL,NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure PedidoVersaoDTO

WSSTRUCT Pedido_PedidoVersaoDTO
	WSDATA   nnNrVersao                AS int OPTIONAL
	WSDATA   csCdComprador             AS string OPTIONAL
	WSDATA   csCdPedidoErp             AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Pedido_PedidoVersaoDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Pedido_PedidoVersaoDTO
Return

WSMETHOD CLONE WSCLIENT Pedido_PedidoVersaoDTO
	Local oClone := Pedido_PedidoVersaoDTO():NEW()
	oClone:nnNrVersao           := ::nnNrVersao
	oClone:csCdComprador        := ::csCdComprador
	oClone:csCdPedidoErp        := ::csCdPedidoErp
Return oClone

WSMETHOD SOAPSEND WSCLIENT Pedido_PedidoVersaoDTO
	Local cSoap := ""
	cSoap += WSSoapValue("nNrVersao", ::nnNrVersao, ::nnNrVersao , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdComprador", ::csCdComprador, ::csCdComprador , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdPedidoErp", ::csCdPedidoErp, ::csCdPedidoErp , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
Return cSoap

// WSDL Data Structure PedidoItemLogisticaDTO

WSSTRUCT Pedido_PedidoItemLogisticaDTO
	WSDATA   ndQtItemRealizado         AS decimal OPTIONAL
	WSDATA   nnCdPedidoItem            AS long OPTIONAL
	WSDATA   nnCdTipoSituacaoMapEntrega AS int OPTIONAL
	WSDATA   nnSqItemEndereco          AS int OPTIONAL
	WSDATA   csCdAlmoxarifado          AS string OPTIONAL
	WSDATA   csCdAlmoxarifadoDoca      AS string OPTIONAL
	WSDATA   ctDtAgendado              AS dateTime OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Pedido_PedidoItemLogisticaDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Pedido_PedidoItemLogisticaDTO
Return

WSMETHOD CLONE WSCLIENT Pedido_PedidoItemLogisticaDTO
	Local oClone := Pedido_PedidoItemLogisticaDTO():NEW()
	oClone:ndQtItemRealizado    := ::ndQtItemRealizado
	oClone:nnCdPedidoItem       := ::nnCdPedidoItem
	oClone:nnCdTipoSituacaoMapEntrega := ::nnCdTipoSituacaoMapEntrega
	oClone:nnSqItemEndereco     := ::nnSqItemEndereco
	oClone:csCdAlmoxarifado     := ::csCdAlmoxarifado
	oClone:csCdAlmoxarifadoDoca := ::csCdAlmoxarifadoDoca
	oClone:ctDtAgendado         := ::ctDtAgendado
Return oClone

WSMETHOD SOAPSEND WSCLIENT Pedido_PedidoItemLogisticaDTO
	Local cSoap := ""
	cSoap += WSSoapValue("dQtItemRealizado", ::ndQtItemRealizado, ::ndQtItemRealizado , "decimal", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("nCdPedidoItem", ::nnCdPedidoItem, ::nnCdPedidoItem , "long", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("nCdTipoSituacaoMapEntrega", ::nnCdTipoSituacaoMapEntrega, ::nnCdTipoSituacaoMapEntrega , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("nSqItemEndereco", ::nnSqItemEndereco, ::nnSqItemEndereco , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdAlmoxarifado", ::csCdAlmoxarifado, ::csCdAlmoxarifado , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdAlmoxarifadoDoca", ::csCdAlmoxarifadoDoca, ::csCdAlmoxarifadoDoca , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("tDtAgendado", ::ctDtAgendado, ::ctDtAgendado , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Pedido_PedidoItemLogisticaDTO
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::ndQtItemRealizado  :=  WSAdvValue( oResponse,"_DQTITEMREALIZADO","decimal",NIL,NIL,NIL,"N",NIL,NIL) 
	::nnCdPedidoItem     :=  WSAdvValue( oResponse,"_NCDPEDIDOITEM","long",NIL,NIL,NIL,"N",NIL,NIL) 
	::nnCdTipoSituacaoMapEntrega :=  WSAdvValue( oResponse,"_NCDTIPOSITUACAOMAPENTREGA","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::nnSqItemEndereco   :=  WSAdvValue( oResponse,"_NSQITEMENDERECO","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::csCdAlmoxarifado   :=  WSAdvValue( oResponse,"_SCDALMOXARIFADO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdAlmoxarifadoDoca :=  WSAdvValue( oResponse,"_SCDALMOXARIFADODOCA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::ctDtAgendado       :=  WSAdvValue( oResponse,"_TDTAGENDADO","dateTime",NIL,NIL,NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure PedidoItemLogisticaHabilitarDTO

WSSTRUCT Pedido_PedidoItemLogisticaHabilitarDTO
	WSDATA   nnCdPedidoItem            AS long OPTIONAL
	WSDATA   nnSqItemEndereco          AS int OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Pedido_PedidoItemLogisticaHabilitarDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Pedido_PedidoItemLogisticaHabilitarDTO
Return

WSMETHOD CLONE WSCLIENT Pedido_PedidoItemLogisticaHabilitarDTO
	Local oClone := Pedido_PedidoItemLogisticaHabilitarDTO():NEW()
	oClone:nnCdPedidoItem       := ::nnCdPedidoItem
	oClone:nnSqItemEndereco     := ::nnSqItemEndereco
Return oClone

WSMETHOD SOAPSEND WSCLIENT Pedido_PedidoItemLogisticaHabilitarDTO
	Local cSoap := ""
	cSoap += WSSoapValue("nCdPedidoItem", ::nnCdPedidoItem, ::nnCdPedidoItem , "long", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("nSqItemEndereco", ::nnSqItemEndereco, ::nnSqItemEndereco , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
Return cSoap

// WSDL Data Structure PedidoDetalheDTO

WSSTRUCT Pedido_PedidoDetalheDTO
	WSDATA   ndVlTotal                 AS decimal OPTIONAL
	WSDATA   oWSlstPedidoItem          AS Pedido_ArrayOfPedidoItemDTO OPTIONAL
	WSDATA   nnCdSituacao              AS long OPTIONAL
	WSDATA   nnCdTipo                  AS long OPTIONAL
	WSDATA   nnIdTipoOrigem            AS int OPTIONAL
	WSDATA   nnNrVersao                AS int OPTIONAL
	WSDATA   csCdCentroCusto           AS string OPTIONAL
	WSDATA   csCdComprador             AS string OPTIONAL
	WSDATA   csCdCondicaoPagamento     AS string OPTIONAL
	WSDATA   csCdFornecedor            AS string OPTIONAL
	WSDATA   csCdFrete                 AS string OPTIONAL
	WSDATA   csCdMoeda                 AS string OPTIONAL
	WSDATA   csCdPedidoERP             AS string OPTIONAL
	WSDATA   csCdPedidoWBC             AS string OPTIONAL
	WSDATA   csCdTransportadora        AS string OPTIONAL
	WSDATA   csCdUsuario               AS string OPTIONAL
	WSDATA   csDsObservacoes           AS string OPTIONAL
	WSDATA   csDsPedidoJustificativa   AS string OPTIONAL
	WSDATA   csNrProcesso              AS string OPTIONAL
	WSDATA   ctDtBase                  AS dateTime OPTIONAL
	WSDATA   ctDtCadastro              AS dateTime OPTIONAL
	WSDATA   ctDtEmissao               AS dateTime OPTIONAL
	WSDATA   ctDtFaturamento           AS dateTime OPTIONAL
	WSDATA   ctDtLiberacao             AS dateTime OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Pedido_PedidoDetalheDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Pedido_PedidoDetalheDTO
Return

WSMETHOD CLONE WSCLIENT Pedido_PedidoDetalheDTO
	Local oClone := Pedido_PedidoDetalheDTO():NEW()
	oClone:ndVlTotal            := ::ndVlTotal
	oClone:oWSlstPedidoItem     := IIF(::oWSlstPedidoItem = NIL , NIL , ::oWSlstPedidoItem:Clone() )
	oClone:nnCdSituacao         := ::nnCdSituacao
	oClone:nnCdTipo             := ::nnCdTipo
	oClone:nnIdTipoOrigem       := ::nnIdTipoOrigem
	oClone:nnNrVersao           := ::nnNrVersao
	oClone:csCdCentroCusto      := ::csCdCentroCusto
	oClone:csCdComprador        := ::csCdComprador
	oClone:csCdCondicaoPagamento := ::csCdCondicaoPagamento
	oClone:csCdFornecedor       := ::csCdFornecedor
	oClone:csCdFrete            := ::csCdFrete
	oClone:csCdMoeda            := ::csCdMoeda
	oClone:csCdPedidoERP        := ::csCdPedidoERP
	oClone:csCdPedidoWBC        := ::csCdPedidoWBC
	oClone:csCdTransportadora   := ::csCdTransportadora
	oClone:csCdUsuario          := ::csCdUsuario
	oClone:csDsObservacoes      := ::csDsObservacoes
	oClone:csDsPedidoJustificativa := ::csDsPedidoJustificativa
	oClone:csNrProcesso         := ::csNrProcesso
	oClone:ctDtBase             := ::ctDtBase
	oClone:ctDtCadastro         := ::ctDtCadastro
	oClone:ctDtEmissao          := ::ctDtEmissao
	oClone:ctDtFaturamento      := ::ctDtFaturamento
	oClone:ctDtLiberacao        := ::ctDtLiberacao
Return oClone

WSMETHOD SOAPSEND WSCLIENT Pedido_PedidoDetalheDTO
	Local cSoap := ""
	cSoap += WSSoapValue("dVlTotal", ::ndVlTotal, ::ndVlTotal , "decimal", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("lstPedidoItem", ::oWSlstPedidoItem, ::oWSlstPedidoItem , "ArrayOfPedidoItemDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("nCdSituacao", ::nnCdSituacao, ::nnCdSituacao , "long", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("nCdTipo", ::nnCdTipo, ::nnCdTipo , "long", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("nIdTipoOrigem", ::nnIdTipoOrigem, ::nnIdTipoOrigem , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("nNrVersao", ::nnNrVersao, ::nnNrVersao , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdCentroCusto", ::csCdCentroCusto, ::csCdCentroCusto , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdComprador", ::csCdComprador, ::csCdComprador , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdCondicaoPagamento", ::csCdCondicaoPagamento, ::csCdCondicaoPagamento , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdFornecedor", ::csCdFornecedor, ::csCdFornecedor , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdFrete", ::csCdFrete, ::csCdFrete , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdMoeda", ::csCdMoeda, ::csCdMoeda , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdPedidoERP", ::csCdPedidoERP, ::csCdPedidoERP , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdPedidoWBC", ::csCdPedidoWBC, ::csCdPedidoWBC , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdTransportadora", ::csCdTransportadora, ::csCdTransportadora , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdUsuario", ::csCdUsuario, ::csCdUsuario , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sDsObservacoes", ::csDsObservacoes, ::csDsObservacoes , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sDsPedidoJustificativa", ::csDsPedidoJustificativa, ::csDsPedidoJustificativa , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sNrProcesso", ::csNrProcesso, ::csNrProcesso , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("tDtBase", ::ctDtBase, ::ctDtBase , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("tDtCadastro", ::ctDtCadastro, ::ctDtCadastro , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("tDtEmissao", ::ctDtEmissao, ::ctDtEmissao , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("tDtFaturamento", ::ctDtFaturamento, ::ctDtFaturamento , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("tDtLiberacao", ::ctDtLiberacao, ::ctDtLiberacao , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
Return cSoap

// WSDL Data Structure PedidoItemEntregaLogisticaDTO

WSSTRUCT Pedido_PedidoItemEntregaLogisticaDTO
	WSDATA   oWSParPedidoEmbarqueDTO      AS Pedido_PedidoEmbarqueDTO OPTIONAL
	WSDATA   ndQtItemRealizado         AS decimal OPTIONAL
	WSDATA   nnCdTipoSituacaoMapEntrega AS int OPTIONAL
	WSDATA   csCdComprador             AS string OPTIONAL
	WSDATA   csCdFornecedor            AS string OPTIONAL
	WSDATA   csCdItemEmpresa           AS string OPTIONAL
	WSDATA   csCdItemEntregaEmpresa    AS string OPTIONAL
	WSDATA   csCdItemRequisicaoEmpresa AS string OPTIONAL
	WSDATA   csCdPedidoERP             AS string OPTIONAL
	WSDATA   csCdRequisicaoEmpresa     AS string OPTIONAL
	WSDATA   csDsMotivo                AS string OPTIONAL
	WSDATA   ctDtItemRealizado         AS dateTime OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Pedido_PedidoItemEntregaLogisticaDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Pedido_PedidoItemEntregaLogisticaDTO
Return

WSMETHOD CLONE WSCLIENT Pedido_PedidoItemEntregaLogisticaDTO
	Local oClone := Pedido_PedidoItemEntregaLogisticaDTO():NEW()
	oClone:oWSParPedidoEmbarqueDTO := IIF(::oWSParPedidoEmbarqueDTO = NIL , NIL , ::oWSParPedidoEmbarqueDTO:Clone() )
	oClone:ndQtItemRealizado    := ::ndQtItemRealizado
	oClone:nnCdTipoSituacaoMapEntrega := ::nnCdTipoSituacaoMapEntrega
	oClone:csCdComprador        := ::csCdComprador
	oClone:csCdFornecedor       := ::csCdFornecedor
	oClone:csCdItemEmpresa      := ::csCdItemEmpresa
	oClone:csCdItemEntregaEmpresa := ::csCdItemEntregaEmpresa
	oClone:csCdItemRequisicaoEmpresa := ::csCdItemRequisicaoEmpresa
	oClone:csCdPedidoERP        := ::csCdPedidoERP
	oClone:csCdRequisicaoEmpresa := ::csCdRequisicaoEmpresa
	oClone:csDsMotivo           := ::csDsMotivo
	oClone:ctDtItemRealizado    := ::ctDtItemRealizado
Return oClone

WSMETHOD SOAPSEND WSCLIENT Pedido_PedidoItemEntregaLogisticaDTO
	Local cSoap := ""
	cSoap += WSSoapValue("PedidoEmbarqueDTO", ::oWSParPedidoEmbarqueDTO, ::oWSParPedidoEmbarqueDTO , "PedidoEmbarqueDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("dQtItemRealizado", ::ndQtItemRealizado, ::ndQtItemRealizado , "decimal", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("nCdTipoSituacaoMapEntrega", ::nnCdTipoSituacaoMapEntrega, ::nnCdTipoSituacaoMapEntrega , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdComprador", ::csCdComprador, ::csCdComprador , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdFornecedor", ::csCdFornecedor, ::csCdFornecedor , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdItemEmpresa", ::csCdItemEmpresa, ::csCdItemEmpresa , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdItemEntregaEmpresa", ::csCdItemEntregaEmpresa, ::csCdItemEntregaEmpresa , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdItemRequisicaoEmpresa", ::csCdItemRequisicaoEmpresa, ::csCdItemRequisicaoEmpresa , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdPedidoERP", ::csCdPedidoERP, ::csCdPedidoERP , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdRequisicaoEmpresa", ::csCdRequisicaoEmpresa, ::csCdRequisicaoEmpresa , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sDsMotivo", ::csDsMotivo, ::csDsMotivo , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("tDtItemRealizado", ::ctDtItemRealizado, ::ctDtItemRealizado , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
Return cSoap

// WSDL Data Structure PrePedidoAtualizarDTO

WSSTRUCT Pedido_PrePedidoAtualizarDTO
	WSDATA   csCdPedidoErp             AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Pedido_PrePedidoAtualizarDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Pedido_PrePedidoAtualizarDTO
Return

WSMETHOD CLONE WSCLIENT Pedido_PrePedidoAtualizarDTO
	Local oClone := Pedido_PrePedidoAtualizarDTO():NEW()
	oClone:csCdPedidoErp        := ::csCdPedidoErp
Return oClone

WSMETHOD SOAPSEND WSCLIENT Pedido_PrePedidoAtualizarDTO
	Local cSoap := ""
	cSoap += WSSoapValue("sCdPedidoErp", ::csCdPedidoErp, ::csCdPedidoErp , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
Return cSoap

// WSDL Data Structure PedidoEmpresaDTO

WSSTRUCT Pedido_PedidoEmpresaDTO
	WSDATA   csCdEmpresa               AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Pedido_PedidoEmpresaDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Pedido_PedidoEmpresaDTO
Return

WSMETHOD CLONE WSCLIENT Pedido_PedidoEmpresaDTO
	Local oClone := Pedido_PedidoEmpresaDTO():NEW()
	oClone:csCdEmpresa          := ::csCdEmpresa
Return oClone

WSMETHOD SOAPSEND WSCLIENT Pedido_PedidoEmpresaDTO
	Local cSoap := ""
	cSoap += WSSoapValue("sCdEmpresa", ::csCdEmpresa, ::csCdEmpresa , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
Return cSoap

// WSDL Data Structure PedidoNumeroDTO

WSSTRUCT Pedido_PedidoNumeroDTO
	WSDATA   nnCdPedido                AS long OPTIONAL
	WSDATA   csCdPedidoERP             AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Pedido_PedidoNumeroDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Pedido_PedidoNumeroDTO
Return

WSMETHOD CLONE WSCLIENT Pedido_PedidoNumeroDTO
	Local oClone := Pedido_PedidoNumeroDTO():NEW()
	oClone:nnCdPedido           := ::nnCdPedido
	oClone:csCdPedidoERP        := ::csCdPedidoERP
Return oClone

WSMETHOD SOAPSEND WSCLIENT Pedido_PedidoNumeroDTO
	Local cSoap := ""
	cSoap += WSSoapValue("nCdPedido", ::nnCdPedido, ::nnCdPedido , "long", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdPedidoERP", ::csCdPedidoERP, ::csCdPedidoERP , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
Return cSoap

// WSDL Data Structure ArrayOfAnexoDTO

WSSTRUCT Pedido_ArrayOfAnexoDTO
	WSDATA   oWSAnexoDTO               AS Pedido_AnexoDTO OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Pedido_ArrayOfAnexoDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Pedido_ArrayOfAnexoDTO
	::oWSAnexoDTO          := {} // Array Of  Pedido_ANEXODTO():New()
Return

WSMETHOD CLONE WSCLIENT Pedido_ArrayOfAnexoDTO
	Local oClone := Pedido_ArrayOfAnexoDTO():NEW()
	oClone:oWSAnexoDTO := NIL
	If ::oWSAnexoDTO <> NIL 
		oClone:oWSAnexoDTO := {}
		aEval( ::oWSAnexoDTO , { |x| aadd( oClone:oWSAnexoDTO , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT Pedido_ArrayOfAnexoDTO
	Local cSoap := ""
	aEval( ::oWSAnexoDTO , {|x| cSoap := cSoap  +  WSSoapValue("AnexoDTO", x , x , "AnexoDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.)  } ) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Pedido_ArrayOfAnexoDTO
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_ANEXODTO","AnexoDTO",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSAnexoDTO , Pedido_AnexoDTO():New() )
			::oWSAnexoDTO[len(::oWSAnexoDTO)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure ArrayOfPedidoItemDTO

WSSTRUCT Pedido_ArrayOfPedidoItemDTO
	WSDATA   oWSParPedidoItemDTO          AS Pedido_PedidoItemDTO OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Pedido_ArrayOfPedidoItemDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Pedido_ArrayOfPedidoItemDTO
	::oWSParPedidoItemDTO     := {} // Array Of  Pedido_PEDIDOITEMDTO():New()
Return

WSMETHOD CLONE WSCLIENT Pedido_ArrayOfPedidoItemDTO
	Local oClone := Pedido_ArrayOfPedidoItemDTO():NEW()
	oClone:oWSParPedidoItemDTO := NIL
	If ::oWSParPedidoItemDTO <> NIL 
		oClone:oWSParPedidoItemDTO := {}
		aEval( ::oWSParPedidoItemDTO , { |x| aadd( oClone:oWSParPedidoItemDTO , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT Pedido_ArrayOfPedidoItemDTO
	Local cSoap := ""
	aEval( ::oWSParPedidoItemDTO , {|x| cSoap := cSoap  +  WSSoapValue("PedidoItemDTO", x , x , "PedidoItemDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.)  } ) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Pedido_ArrayOfPedidoItemDTO
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_PEDIDOITEMDTO","PedidoItemDTO",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSParPedidoItemDTO , Pedido_PedidoItemDTO():New() )
			::oWSParPedidoItemDTO[len(::oWSParPedidoItemDTO)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure WbtLogDTO

WSSTRUCT Pedido_WbtLogDTO
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

WSMETHOD NEW WSCLIENT Pedido_WbtLogDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Pedido_WbtLogDTO
Return

WSMETHOD CLONE WSCLIENT Pedido_WbtLogDTO
	Local oClone := Pedido_WbtLogDTO():NEW()
	oClone:nnCdLog              := ::nnCdLog
	oClone:nnIdRetorno          := ::nnIdRetorno
	oClone:csCdOrigem           := ::csCdOrigem
	oClone:csDsLog              := ::csDsLog
	oClone:csDsTipoDocumento    := ::csDsTipoDocumento
	oClone:csNrToken            := ::csNrToken
	oClone:ctDtLog              := ::ctDtLog
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Pedido_WbtLogDTO
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

// WSDL Data Structure PedidoEmbarqueDTO

WSSTRUCT Pedido_PedidoEmbarqueDTO
	WSDATA   csDsObservacaoEmbraque    AS string OPTIONAL
	WSDATA   csNmTransportadora        AS string OPTIONAL
	WSDATA   csNrNotaFiscal            AS string OPTIONAL
	WSDATA   csNrNotaFiscalSerie       AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Pedido_PedidoEmbarqueDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Pedido_PedidoEmbarqueDTO
Return

WSMETHOD CLONE WSCLIENT Pedido_PedidoEmbarqueDTO
	Local oClone := Pedido_PedidoEmbarqueDTO():NEW()
	oClone:csDsObservacaoEmbraque := ::csDsObservacaoEmbraque
	oClone:csNmTransportadora   := ::csNmTransportadora
	oClone:csNrNotaFiscal       := ::csNrNotaFiscal
	oClone:csNrNotaFiscalSerie  := ::csNrNotaFiscalSerie
Return oClone

WSMETHOD SOAPSEND WSCLIENT Pedido_PedidoEmbarqueDTO
	Local cSoap := ""
	cSoap += WSSoapValue("sDsObservacaoEmbraque", ::csDsObservacaoEmbraque, ::csDsObservacaoEmbraque , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sNmTransportadora", ::csNmTransportadora, ::csNmTransportadora , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sNrNotaFiscal", ::csNrNotaFiscal, ::csNrNotaFiscal , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sNrNotaFiscalSerie", ::csNrNotaFiscalSerie, ::csNrNotaFiscalSerie , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
Return cSoap

// WSDL Data Structure AnexoDTO

WSSTRUCT Pedido_AnexoDTO
	WSDATA   csDsAnexo                 AS string OPTIONAL
	WSDATA   csNmArquivo               AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Pedido_AnexoDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Pedido_AnexoDTO
Return

WSMETHOD CLONE WSCLIENT Pedido_AnexoDTO
	Local oClone := Pedido_AnexoDTO():NEW()
	oClone:csDsAnexo            := ::csDsAnexo
	oClone:csNmArquivo          := ::csNmArquivo
Return oClone

WSMETHOD SOAPSEND WSCLIENT Pedido_AnexoDTO
	Local cSoap := ""
	cSoap += WSSoapValue("sDsAnexo", ::csDsAnexo, ::csDsAnexo , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sNmArquivo", ::csNmArquivo, ::csNmArquivo , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Pedido_AnexoDTO
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::csDsAnexo          :=  WSAdvValue( oResponse,"_SDSANEXO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csNmArquivo        :=  WSAdvValue( oResponse,"_SNMARQUIVO","string",NIL,NIL,NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure PedidoItemDTO

WSSTRUCT Pedido_PedidoItemDTO
	WSDATA   ndPcDesconto              AS decimal OPTIONAL
	WSDATA   ndQtItem                  AS decimal OPTIONAL
	WSDATA   ndVlItem                  AS decimal OPTIONAL
	WSDATA   oWSlstAnexo               AS Pedido_ArrayOfAnexoDTO OPTIONAL
	WSDATA   oWSlstPedidoItemEntrega   AS Pedido_ArrayOfPedidoItemEntregaDTO OPTIONAL
	WSDATA   oWSlstPedidoItemTaxa      AS Pedido_ArrayOfPedidoItemTaxaDTO OPTIONAL
	WSDATA   nnCdSituacao              AS long OPTIONAL
	WSDATA   csCdClasse                AS string OPTIONAL
	WSDATA   csCdEmpresa               AS string OPTIONAL
	WSDATA   csCdItemEmpresa           AS string OPTIONAL
	WSDATA   csCdItemOrigemEmpresa     AS string OPTIONAL
	WSDATA   csCdItemWbc               AS string OPTIONAL
	WSDATA   csCdIva                   AS string OPTIONAL
	WSDATA   csCdNbm                   AS string OPTIONAL
	WSDATA   csCdOrigemEmpresa         AS string OPTIONAL
	WSDATA   csCdProduto               AS string OPTIONAL
	WSDATA   csCdProdutoFornecedor     AS string OPTIONAL
	WSDATA   csCdProjeto               AS string OPTIONAL
	WSDATA   csCdUnidadeMedida         AS string OPTIONAL
	WSDATA   csCdUsuarioResponsavel    AS string OPTIONAL
	WSDATA   csDsItem                  AS string OPTIONAL
	WSDATA   csDsJustificativa         AS string OPTIONAL
	WSDATA   csDsObservacao            AS string OPTIONAL
	WSDATA   csNrRecap                 AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Pedido_PedidoItemDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Pedido_PedidoItemDTO
Return

WSMETHOD CLONE WSCLIENT Pedido_PedidoItemDTO
	Local oClone := Pedido_PedidoItemDTO():NEW()
	oClone:ndPcDesconto         := ::ndPcDesconto
	oClone:ndQtItem             := ::ndQtItem
	oClone:ndVlItem             := ::ndVlItem
	oClone:oWSlstAnexo          := IIF(::oWSlstAnexo = NIL , NIL , ::oWSlstAnexo:Clone() )
	oClone:oWSlstPedidoItemEntrega := IIF(::oWSlstPedidoItemEntrega = NIL , NIL , ::oWSlstPedidoItemEntrega:Clone() )
	oClone:oWSlstPedidoItemTaxa := IIF(::oWSlstPedidoItemTaxa = NIL , NIL , ::oWSlstPedidoItemTaxa:Clone() )
	oClone:nnCdSituacao         := ::nnCdSituacao
	oClone:csCdClasse           := ::csCdClasse
	oClone:csCdEmpresa          := ::csCdEmpresa
	oClone:csCdItemEmpresa      := ::csCdItemEmpresa
	oClone:csCdItemOrigemEmpresa := ::csCdItemOrigemEmpresa
	oClone:csCdItemWbc          := ::csCdItemWbc
	oClone:csCdIva              := ::csCdIva
	oClone:csCdNbm              := ::csCdNbm
	oClone:csCdOrigemEmpresa    := ::csCdOrigemEmpresa
	oClone:csCdProduto          := ::csCdProduto
	oClone:csCdProdutoFornecedor := ::csCdProdutoFornecedor
	oClone:csCdProjeto          := ::csCdProjeto
	oClone:csCdUnidadeMedida    := ::csCdUnidadeMedida
	oClone:csCdUsuarioResponsavel := ::csCdUsuarioResponsavel
	oClone:csDsItem             := ::csDsItem
	oClone:csDsJustificativa    := ::csDsJustificativa
	oClone:csDsObservacao       := ::csDsObservacao
	oClone:csNrRecap            := ::csNrRecap
Return oClone

WSMETHOD SOAPSEND WSCLIENT Pedido_PedidoItemDTO
	Local cSoap := ""
	cSoap += WSSoapValue("dPcDesconto", ::ndPcDesconto, ::ndPcDesconto , "decimal", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("dQtItem", ::ndQtItem, ::ndQtItem , "decimal", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("dVlItem", ::ndVlItem, ::ndVlItem , "decimal", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("lstAnexo", ::oWSlstAnexo, ::oWSlstAnexo , "ArrayOfAnexoDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("lstPedidoItemEntrega", ::oWSlstPedidoItemEntrega, ::oWSlstPedidoItemEntrega , "ArrayOfPedidoItemEntregaDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("lstPedidoItemTaxa", ::oWSlstPedidoItemTaxa, ::oWSlstPedidoItemTaxa , "ArrayOfPedidoItemTaxaDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("nCdSituacao", ::nnCdSituacao, ::nnCdSituacao , "long", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdClasse", ::csCdClasse, ::csCdClasse , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdEmpresa", ::csCdEmpresa, ::csCdEmpresa , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdItemEmpresa", ::csCdItemEmpresa, ::csCdItemEmpresa , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdItemOrigemEmpresa", ::csCdItemOrigemEmpresa, ::csCdItemOrigemEmpresa , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdItemWbc", ::csCdItemWbc, ::csCdItemWbc , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdIva", ::csCdIva, ::csCdIva , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdNbm", ::csCdNbm, ::csCdNbm , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdOrigemEmpresa", ::csCdOrigemEmpresa, ::csCdOrigemEmpresa , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdProduto", ::csCdProduto, ::csCdProduto , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdProdutoFornecedor", ::csCdProdutoFornecedor, ::csCdProdutoFornecedor , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdProjeto", ::csCdProjeto, ::csCdProjeto , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdUnidadeMedida", ::csCdUnidadeMedida, ::csCdUnidadeMedida , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdUsuarioResponsavel", ::csCdUsuarioResponsavel, ::csCdUsuarioResponsavel , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sDsItem", ::csDsItem, ::csDsItem , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sDsJustificativa", ::csDsJustificativa, ::csDsJustificativa , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sDsObservacao", ::csDsObservacao, ::csDsObservacao , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sNrRecap", ::csNrRecap, ::csNrRecap , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Pedido_PedidoItemDTO
	Local oNode4
	Local oNode5
	Local oNode6
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::ndPcDesconto       :=  WSAdvValue( oResponse,"_DPCDESCONTO","decimal",NIL,NIL,NIL,"N",NIL,NIL) 
	::ndQtItem           :=  WSAdvValue( oResponse,"_DQTITEM","decimal",NIL,NIL,NIL,"N",NIL,NIL) 
	::ndVlItem           :=  WSAdvValue( oResponse,"_DVLITEM","decimal",NIL,NIL,NIL,"N",NIL,NIL) 
	oNode4 :=  WSAdvValue( oResponse,"_LSTANEXO","ArrayOfAnexoDTO",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode4 != NIL
		::oWSlstAnexo := Pedido_ArrayOfAnexoDTO():New()
		::oWSlstAnexo:SoapRecv(oNode4)
	EndIf
	oNode5 :=  WSAdvValue( oResponse,"_LSTPEDIDOITEMENTREGA","ArrayOfPedidoItemEntregaDTO",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode5 != NIL
		::oWSlstPedidoItemEntrega := Pedido_ArrayOfPedidoItemEntregaDTO():New()
		::oWSlstPedidoItemEntrega:SoapRecv(oNode5)
	EndIf
	oNode6 :=  WSAdvValue( oResponse,"_LSTPEDIDOITEMTAXA","ArrayOfPedidoItemTaxaDTO",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode6 != NIL
		::oWSlstPedidoItemTaxa := Pedido_ArrayOfPedidoItemTaxaDTO():New()
		::oWSlstPedidoItemTaxa:SoapRecv(oNode6)
	EndIf
	::nnCdSituacao       :=  WSAdvValue( oResponse,"_NCDSITUACAO","long",NIL,NIL,NIL,"N",NIL,NIL) 
	::csCdClasse         :=  WSAdvValue( oResponse,"_SCDCLASSE","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdEmpresa        :=  WSAdvValue( oResponse,"_SCDEMPRESA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdItemEmpresa    :=  WSAdvValue( oResponse,"_SCDITEMEMPRESA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdItemOrigemEmpresa :=  WSAdvValue( oResponse,"_SCDITEMORIGEMEMPRESA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdItemWbc        :=  WSAdvValue( oResponse,"_SCDITEMWBC","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdIva            :=  WSAdvValue( oResponse,"_SCDIVA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdNbm            :=  WSAdvValue( oResponse,"_SCDNBM","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdOrigemEmpresa  :=  WSAdvValue( oResponse,"_SCDORIGEMEMPRESA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdProduto        :=  WSAdvValue( oResponse,"_SCDPRODUTO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdProdutoFornecedor :=  WSAdvValue( oResponse,"_SCDPRODUTOFORNECEDOR","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdProjeto        :=  WSAdvValue( oResponse,"_SCDPROJETO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdUnidadeMedida  :=  WSAdvValue( oResponse,"_SCDUNIDADEMEDIDA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdUsuarioResponsavel :=  WSAdvValue( oResponse,"_SCDUSUARIORESPONSAVEL","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csDsItem           :=  WSAdvValue( oResponse,"_SDSITEM","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csDsJustificativa  :=  WSAdvValue( oResponse,"_SDSJUSTIFICATIVA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csDsObservacao     :=  WSAdvValue( oResponse,"_SDSOBSERVACAO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csNrRecap          :=  WSAdvValue( oResponse,"_SNRRECAP","string",NIL,NIL,NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure ArrayOfPedidoItemEntregaDTO

WSSTRUCT Pedido_ArrayOfPedidoItemEntregaDTO
	WSDATA   oWSParPedidoItemEntregaDTO   AS Pedido_PedidoItemEntregaDTO OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Pedido_ArrayOfPedidoItemEntregaDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Pedido_ArrayOfPedidoItemEntregaDTO
	::oWSParPedidoItemEntregaDTO := {} // Array Of  Pedido_PEDIDOITEMENTREGADTO():New()
Return

WSMETHOD CLONE WSCLIENT Pedido_ArrayOfPedidoItemEntregaDTO
	Local oClone := Pedido_ArrayOfPedidoItemEntregaDTO():NEW()
	oClone:oWSParPedidoItemEntregaDTO := NIL
	If ::oWSParPedidoItemEntregaDTO <> NIL 
		oClone:oWSParPedidoItemEntregaDTO := {}
		aEval( ::oWSParPedidoItemEntregaDTO , { |x| aadd( oClone:oWSParPedidoItemEntregaDTO , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT Pedido_ArrayOfPedidoItemEntregaDTO
	Local cSoap := ""
	aEval( ::oWSParPedidoItemEntregaDTO , {|x| cSoap := cSoap  +  WSSoapValue("PedidoItemEntregaDTO", x , x , "PedidoItemEntregaDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.)  } ) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Pedido_ArrayOfPedidoItemEntregaDTO
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_PEDIDOITEMENTREGADTO","PedidoItemEntregaDTO",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSParPedidoItemEntregaDTO , Pedido_PedidoItemEntregaDTO():New() )
			::oWSParPedidoItemEntregaDTO[len(::oWSParPedidoItemEntregaDTO)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure ArrayOfPedidoItemTaxaDTO

WSSTRUCT Pedido_ArrayOfPedidoItemTaxaDTO
	WSDATA   oWSParPedidoItemTaxaDTO      AS Pedido_PedidoItemTaxaDTO OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Pedido_ArrayOfPedidoItemTaxaDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Pedido_ArrayOfPedidoItemTaxaDTO
	::oWSParPedidoItemTaxaDTO := {} // Array Of  Pedido_PEDIDOITEMTAXADTO():New()
Return

WSMETHOD CLONE WSCLIENT Pedido_ArrayOfPedidoItemTaxaDTO
	Local oClone := Pedido_ArrayOfPedidoItemTaxaDTO():NEW()
	oClone:oWSParPedidoItemTaxaDTO := NIL
	If ::oWSParPedidoItemTaxaDTO <> NIL 
		oClone:oWSParPedidoItemTaxaDTO := {}
		aEval( ::oWSParPedidoItemTaxaDTO , { |x| aadd( oClone:oWSParPedidoItemTaxaDTO , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT Pedido_ArrayOfPedidoItemTaxaDTO
	Local cSoap := ""
	aEval( ::oWSParPedidoItemTaxaDTO , {|x| cSoap := cSoap  +  WSSoapValue("PedidoItemTaxaDTO", x , x , "PedidoItemTaxaDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.)  } ) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Pedido_ArrayOfPedidoItemTaxaDTO
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_PEDIDOITEMTAXADTO","PedidoItemTaxaDTO",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSParPedidoItemTaxaDTO , Pedido_PedidoItemTaxaDTO():New() )
			::oWSParPedidoItemTaxaDTO[len(::oWSParPedidoItemTaxaDTO)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure PedidoItemEntregaDTO

WSSTRUCT Pedido_PedidoItemEntregaDTO
	WSDATA   ndQtEntrega               AS decimal OPTIONAL
	WSDATA   ndQtItemConfirmada        AS decimal OPTIONAL
	WSDATA   ndQtItemRealizado         AS decimal OPTIONAL
	WSDATA   ndQtPorUnidade            AS decimal OPTIONAL
	WSDATA   ndQtSolicitacaoEntrega    AS decimal OPTIONAL
	WSDATA   ndQtUnidade               AS decimal OPTIONAL
	WSDATA   nnCdPedidoSituacao        AS long OPTIONAL
	WSDATA   nnCdPedidoSituacaoEntrega AS long OPTIONAL
	WSDATA   nnQtDiasEntrega           AS decimal OPTIONAL
	WSDATA   nnSqItemEndereco          AS int OPTIONAL
	WSDATA   nnSqItemEnderecoPai       AS int OPTIONAL
	WSDATA   oWSoCobrancaEndereco      AS Pedido_EnderecoDTO OPTIONAL
	WSDATA   oWSoEntregaEndereco       AS Pedido_EnderecoDTO OPTIONAL
	WSDATA   oWSoFaturamentoEndereco   AS Pedido_EnderecoDTO OPTIONAL
	WSDATA   csCdAlmoxarifado          AS string OPTIONAL
	WSDATA   csCdAlmoxarifadoDoca      AS string OPTIONAL
	WSDATA   csCdCentroCustoRequisicao AS string OPTIONAL
	WSDATA   csCdCobrancaEndereco      AS string OPTIONAL
	WSDATA   csCdEmpresaCobrancaEndereco AS string OPTIONAL
	WSDATA   csCdEmpresaEntregaEndereco AS string OPTIONAL
	WSDATA   csCdEmpresaFaturamentoEndereco AS string OPTIONAL
	WSDATA   csCdEntregaEndereco       AS string OPTIONAL
	WSDATA   csCdFaturamentoEndereco   AS string OPTIONAL
	WSDATA   csCdItemEntregaEmpresa    AS string OPTIONAL
	WSDATA   csCdItemRequisicaoEmpresa AS string OPTIONAL
	WSDATA   csCdRequisicaoEmpresa     AS string OPTIONAL
	WSDATA   csCdUnidadeFornecimento   AS string OPTIONAL
	WSDATA   csCdUsuarioAlteracao      AS string OPTIONAL
	WSDATA   csCdUsuarioAprovador      AS string OPTIONAL
	WSDATA   csDsAprovacao             AS string OPTIONAL
	WSDATA   csDsCancelamento          AS string OPTIONAL
	WSDATA   csDsReprovacao            AS string OPTIONAL
	WSDATA   csDsSolicitacaoAlteracao  AS string OPTIONAL
	WSDATA   csNrNota                  AS string OPTIONAL
	WSDATA   csNrRecebimento           AS string OPTIONAL
	WSDATA   csNrSerie                 AS string OPTIONAL
	WSDATA   ctDtColeta                AS dateTime OPTIONAL
	WSDATA   ctDtEntrega               AS dateTime OPTIONAL
	WSDATA   ctDtEntregaConfirmada     AS dateTime OPTIONAL
	WSDATA   ctDtFornecimento          AS dateTime OPTIONAL
	WSDATA   ctDtSolicitacaoEntrega    AS dateTime OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Pedido_PedidoItemEntregaDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Pedido_PedidoItemEntregaDTO
Return

WSMETHOD CLONE WSCLIENT Pedido_PedidoItemEntregaDTO
	Local oClone := Pedido_PedidoItemEntregaDTO():NEW()
	oClone:ndQtEntrega          := ::ndQtEntrega
	oClone:ndQtItemConfirmada   := ::ndQtItemConfirmada
	oClone:ndQtItemRealizado    := ::ndQtItemRealizado
	oClone:ndQtPorUnidade       := ::ndQtPorUnidade
	oClone:ndQtSolicitacaoEntrega := ::ndQtSolicitacaoEntrega
	oClone:ndQtUnidade          := ::ndQtUnidade
	oClone:nnCdPedidoSituacao   := ::nnCdPedidoSituacao
	oClone:nnCdPedidoSituacaoEntrega := ::nnCdPedidoSituacaoEntrega
	oClone:nnQtDiasEntrega      := ::nnQtDiasEntrega
	oClone:nnSqItemEndereco     := ::nnSqItemEndereco
	oClone:nnSqItemEnderecoPai  := ::nnSqItemEnderecoPai
	oClone:oWSoCobrancaEndereco := IIF(::oWSoCobrancaEndereco = NIL , NIL , ::oWSoCobrancaEndereco:Clone() )
	oClone:oWSoEntregaEndereco  := IIF(::oWSoEntregaEndereco = NIL , NIL , ::oWSoEntregaEndereco:Clone() )
	oClone:oWSoFaturamentoEndereco := IIF(::oWSoFaturamentoEndereco = NIL , NIL , ::oWSoFaturamentoEndereco:Clone() )
	oClone:csCdAlmoxarifado     := ::csCdAlmoxarifado
	oClone:csCdAlmoxarifadoDoca := ::csCdAlmoxarifadoDoca
	oClone:csCdCentroCustoRequisicao := ::csCdCentroCustoRequisicao
	oClone:csCdCobrancaEndereco := ::csCdCobrancaEndereco
	oClone:csCdEmpresaCobrancaEndereco := ::csCdEmpresaCobrancaEndereco
	oClone:csCdEmpresaEntregaEndereco := ::csCdEmpresaEntregaEndereco
	oClone:csCdEmpresaFaturamentoEndereco := ::csCdEmpresaFaturamentoEndereco
	oClone:csCdEntregaEndereco  := ::csCdEntregaEndereco
	oClone:csCdFaturamentoEndereco := ::csCdFaturamentoEndereco
	oClone:csCdItemEntregaEmpresa := ::csCdItemEntregaEmpresa
	oClone:csCdItemRequisicaoEmpresa := ::csCdItemRequisicaoEmpresa
	oClone:csCdRequisicaoEmpresa := ::csCdRequisicaoEmpresa
	oClone:csCdUnidadeFornecimento := ::csCdUnidadeFornecimento
	oClone:csCdUsuarioAlteracao := ::csCdUsuarioAlteracao
	oClone:csCdUsuarioAprovador := ::csCdUsuarioAprovador
	oClone:csDsAprovacao        := ::csDsAprovacao
	oClone:csDsCancelamento     := ::csDsCancelamento
	oClone:csDsReprovacao       := ::csDsReprovacao
	oClone:csDsSolicitacaoAlteracao := ::csDsSolicitacaoAlteracao
	oClone:csNrNota             := ::csNrNota
	oClone:csNrRecebimento      := ::csNrRecebimento
	oClone:csNrSerie            := ::csNrSerie
	oClone:ctDtColeta           := ::ctDtColeta
	oClone:ctDtEntrega          := ::ctDtEntrega
	oClone:ctDtEntregaConfirmada := ::ctDtEntregaConfirmada
	oClone:ctDtFornecimento     := ::ctDtFornecimento
	oClone:ctDtSolicitacaoEntrega := ::ctDtSolicitacaoEntrega
Return oClone

WSMETHOD SOAPSEND WSCLIENT Pedido_PedidoItemEntregaDTO
	Local cSoap := ""
	cSoap += WSSoapValue("dQtEntrega", ::ndQtEntrega, ::ndQtEntrega , "decimal", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("dQtItemConfirmada", ::ndQtItemConfirmada, ::ndQtItemConfirmada , "decimal", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("dQtItemRealizado", ::ndQtItemRealizado, ::ndQtItemRealizado , "decimal", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("dQtPorUnidade", ::ndQtPorUnidade, ::ndQtPorUnidade , "decimal", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("dQtSolicitacaoEntrega", ::ndQtSolicitacaoEntrega, ::ndQtSolicitacaoEntrega , "decimal", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("dQtUnidade", ::ndQtUnidade, ::ndQtUnidade , "decimal", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("nCdPedidoSituacao", ::nnCdPedidoSituacao, ::nnCdPedidoSituacao , "long", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("nCdPedidoSituacaoEntrega", ::nnCdPedidoSituacaoEntrega, ::nnCdPedidoSituacaoEntrega , "long", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("nQtDiasEntrega", ::nnQtDiasEntrega, ::nnQtDiasEntrega , "decimal", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("nSqItemEndereco", ::nnSqItemEndereco, ::nnSqItemEndereco , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("nSqItemEnderecoPai", ::nnSqItemEnderecoPai, ::nnSqItemEnderecoPai , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("oCobrancaEndereco", ::oWSoCobrancaEndereco, ::oWSoCobrancaEndereco , "EnderecoDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("oEntregaEndereco", ::oWSoEntregaEndereco, ::oWSoEntregaEndereco , "EnderecoDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("oFaturamentoEndereco", ::oWSoFaturamentoEndereco, ::oWSoFaturamentoEndereco , "EnderecoDTO", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdAlmoxarifado", ::csCdAlmoxarifado, ::csCdAlmoxarifado , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdAlmoxarifadoDoca", ::csCdAlmoxarifadoDoca, ::csCdAlmoxarifadoDoca , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdCentroCustoRequisicao", ::csCdCentroCustoRequisicao, ::csCdCentroCustoRequisicao , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdCobrancaEndereco", ::csCdCobrancaEndereco, ::csCdCobrancaEndereco , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdEmpresaCobrancaEndereco", ::csCdEmpresaCobrancaEndereco, ::csCdEmpresaCobrancaEndereco , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdEmpresaEntregaEndereco", ::csCdEmpresaEntregaEndereco, ::csCdEmpresaEntregaEndereco , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdEmpresaFaturamentoEndereco", ::csCdEmpresaFaturamentoEndereco, ::csCdEmpresaFaturamentoEndereco , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdEntregaEndereco", ::csCdEntregaEndereco, ::csCdEntregaEndereco , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdFaturamentoEndereco", ::csCdFaturamentoEndereco, ::csCdFaturamentoEndereco , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdItemEntregaEmpresa", ::csCdItemEntregaEmpresa, ::csCdItemEntregaEmpresa , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdItemRequisicaoEmpresa", ::csCdItemRequisicaoEmpresa, ::csCdItemRequisicaoEmpresa , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdRequisicaoEmpresa", ::csCdRequisicaoEmpresa, ::csCdRequisicaoEmpresa , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdUnidadeFornecimento", ::csCdUnidadeFornecimento, ::csCdUnidadeFornecimento , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdUsuarioAlteracao", ::csCdUsuarioAlteracao, ::csCdUsuarioAlteracao , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sCdUsuarioAprovador", ::csCdUsuarioAprovador, ::csCdUsuarioAprovador , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sDsAprovacao", ::csDsAprovacao, ::csDsAprovacao , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sDsCancelamento", ::csDsCancelamento, ::csDsCancelamento , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sDsReprovacao", ::csDsReprovacao, ::csDsReprovacao , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sDsSolicitacaoAlteracao", ::csDsSolicitacaoAlteracao, ::csDsSolicitacaoAlteracao , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sNrNota", ::csNrNota, ::csNrNota , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sNrRecebimento", ::csNrRecebimento, ::csNrRecebimento , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sNrSerie", ::csNrSerie, ::csNrSerie , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("tDtColeta", ::ctDtColeta, ::ctDtColeta , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("tDtEntrega", ::ctDtEntrega, ::ctDtEntrega , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("tDtEntregaConfirmada", ::ctDtEntregaConfirmada, ::ctDtEntregaConfirmada , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("tDtFornecimento", ::ctDtFornecimento, ::ctDtFornecimento , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("tDtSolicitacaoEntrega", ::ctDtSolicitacaoEntrega, ::ctDtSolicitacaoEntrega , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Pedido_PedidoItemEntregaDTO
	Local oNode12
	Local oNode13
	Local oNode14
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::ndQtEntrega        :=  WSAdvValue( oResponse,"_DQTENTREGA","decimal",NIL,NIL,NIL,"N",NIL,NIL) 
	::ndQtItemConfirmada :=  WSAdvValue( oResponse,"_DQTITEMCONFIRMADA","decimal",NIL,NIL,NIL,"N",NIL,NIL) 
	::ndQtItemRealizado  :=  WSAdvValue( oResponse,"_DQTITEMREALIZADO","decimal",NIL,NIL,NIL,"N",NIL,NIL) 
	::ndQtPorUnidade     :=  WSAdvValue( oResponse,"_DQTPORUNIDADE","decimal",NIL,NIL,NIL,"N",NIL,NIL) 
	::ndQtSolicitacaoEntrega :=  WSAdvValue( oResponse,"_DQTSOLICITACAOENTREGA","decimal",NIL,NIL,NIL,"N",NIL,NIL) 
	::ndQtUnidade        :=  WSAdvValue( oResponse,"_DQTUNIDADE","decimal",NIL,NIL,NIL,"N",NIL,NIL) 
	::nnCdPedidoSituacao :=  WSAdvValue( oResponse,"_NCDPEDIDOSITUACAO","long",NIL,NIL,NIL,"N",NIL,NIL) 
	::nnCdPedidoSituacaoEntrega :=  WSAdvValue( oResponse,"_NCDPEDIDOSITUACAOENTREGA","long",NIL,NIL,NIL,"N",NIL,NIL) 
	::nnQtDiasEntrega    :=  WSAdvValue( oResponse,"_NQTDIASENTREGA","decimal",NIL,NIL,NIL,"N",NIL,NIL) 
	::nnSqItemEndereco   :=  WSAdvValue( oResponse,"_NSQITEMENDERECO","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::nnSqItemEnderecoPai :=  WSAdvValue( oResponse,"_NSQITEMENDERECOPAI","int",NIL,NIL,NIL,"N",NIL,NIL) 
	oNode12 :=  WSAdvValue( oResponse,"_OCOBRANCAENDERECO","EnderecoDTO",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode12 != NIL
		::oWSoCobrancaEndereco := Pedido_EnderecoDTO():New()
		::oWSoCobrancaEndereco:SoapRecv(oNode12)
	EndIf
	oNode13 :=  WSAdvValue( oResponse,"_OENTREGAENDERECO","EnderecoDTO",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode13 != NIL
		::oWSoEntregaEndereco := Pedido_EnderecoDTO():New()
		::oWSoEntregaEndereco:SoapRecv(oNode13)
	EndIf
	oNode14 :=  WSAdvValue( oResponse,"_OFATURAMENTOENDERECO","EnderecoDTO",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode14 != NIL
		::oWSoFaturamentoEndereco := Pedido_EnderecoDTO():New()
		::oWSoFaturamentoEndereco:SoapRecv(oNode14)
	EndIf
	::csCdAlmoxarifado   :=  WSAdvValue( oResponse,"_SCDALMOXARIFADO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdAlmoxarifadoDoca :=  WSAdvValue( oResponse,"_SCDALMOXARIFADODOCA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdCentroCustoRequisicao :=  WSAdvValue( oResponse,"_SCDCENTROCUSTOREQUISICAO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdCobrancaEndereco :=  WSAdvValue( oResponse,"_SCDCOBRANCAENDERECO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdEmpresaCobrancaEndereco :=  WSAdvValue( oResponse,"_SCDEMPRESACOBRANCAENDERECO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdEmpresaEntregaEndereco :=  WSAdvValue( oResponse,"_SCDEMPRESAENTREGAENDERECO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdEmpresaFaturamentoEndereco :=  WSAdvValue( oResponse,"_SCDEMPRESAFATURAMENTOENDERECO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdEntregaEndereco :=  WSAdvValue( oResponse,"_SCDENTREGAENDERECO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdFaturamentoEndereco :=  WSAdvValue( oResponse,"_SCDFATURAMENTOENDERECO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdItemEntregaEmpresa :=  WSAdvValue( oResponse,"_SCDITEMENTREGAEMPRESA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdItemRequisicaoEmpresa :=  WSAdvValue( oResponse,"_SCDITEMREQUISICAOEMPRESA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdRequisicaoEmpresa :=  WSAdvValue( oResponse,"_SCDREQUISICAOEMPRESA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdUnidadeFornecimento :=  WSAdvValue( oResponse,"_SCDUNIDADEFORNECIMENTO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdUsuarioAlteracao :=  WSAdvValue( oResponse,"_SCDUSUARIOALTERACAO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csCdUsuarioAprovador :=  WSAdvValue( oResponse,"_SCDUSUARIOAPROVADOR","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csDsAprovacao      :=  WSAdvValue( oResponse,"_SDSAPROVACAO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csDsCancelamento   :=  WSAdvValue( oResponse,"_SDSCANCELAMENTO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csDsReprovacao     :=  WSAdvValue( oResponse,"_SDSREPROVACAO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csDsSolicitacaoAlteracao :=  WSAdvValue( oResponse,"_SDSSOLICITACAOALTERACAO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csNrNota           :=  WSAdvValue( oResponse,"_SNRNOTA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csNrRecebimento    :=  WSAdvValue( oResponse,"_SNRRECEBIMENTO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csNrSerie          :=  WSAdvValue( oResponse,"_SNRSERIE","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::ctDtColeta         :=  WSAdvValue( oResponse,"_TDTCOLETA","dateTime",NIL,NIL,NIL,"S",NIL,NIL) 
	::ctDtEntrega        :=  WSAdvValue( oResponse,"_TDTENTREGA","dateTime",NIL,NIL,NIL,"S",NIL,NIL) 
	::ctDtEntregaConfirmada :=  WSAdvValue( oResponse,"_TDTENTREGACONFIRMADA","dateTime",NIL,NIL,NIL,"S",NIL,NIL) 
	::ctDtFornecimento   :=  WSAdvValue( oResponse,"_TDTFORNECIMENTO","dateTime",NIL,NIL,NIL,"S",NIL,NIL) 
	::ctDtSolicitacaoEntrega :=  WSAdvValue( oResponse,"_TDTSOLICITACAOENTREGA","dateTime",NIL,NIL,NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure PedidoItemTaxaDTO

WSSTRUCT Pedido_PedidoItemTaxaDTO
	WSDATA   nbFlIncluso               AS int OPTIONAL
	WSDATA   ndPcTaxa                  AS decimal OPTIONAL
	WSDATA   nnCdTaxa                  AS long OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Pedido_PedidoItemTaxaDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Pedido_PedidoItemTaxaDTO
Return

WSMETHOD CLONE WSCLIENT Pedido_PedidoItemTaxaDTO
	Local oClone := Pedido_PedidoItemTaxaDTO():NEW()
	oClone:nbFlIncluso          := ::nbFlIncluso
	oClone:ndPcTaxa             := ::ndPcTaxa
	oClone:nnCdTaxa             := ::nnCdTaxa
Return oClone

WSMETHOD SOAPSEND WSCLIENT Pedido_PedidoItemTaxaDTO
	Local cSoap := ""
	cSoap += WSSoapValue("bFlIncluso", ::nbFlIncluso, ::nbFlIncluso , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("dPcTaxa", ::ndPcTaxa, ::ndPcTaxa , "decimal", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("nCdTaxa", ::nnCdTaxa, ::nnCdTaxa , "long", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Pedido_PedidoItemTaxaDTO
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::nbFlIncluso        :=  WSAdvValue( oResponse,"_BFLINCLUSO","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::ndPcTaxa           :=  WSAdvValue( oResponse,"_DPCTAXA","decimal",NIL,NIL,NIL,"N",NIL,NIL) 
	::nnCdTaxa           :=  WSAdvValue( oResponse,"_NCDTAXA","long",NIL,NIL,NIL,"N",NIL,NIL) 
Return

// WSDL Data Structure EnderecoDTO

WSSTRUCT Pedido_EnderecoDTO
	WSDATA   csCdCep                   AS string OPTIONAL
	WSDATA   csDsComplemento           AS string OPTIONAL
	WSDATA   csDsEndereco              AS string OPTIONAL
	WSDATA   csNmBairro                AS string OPTIONAL
	WSDATA   csNmCidade                AS string OPTIONAL
	WSDATA   csNrEndereco              AS string OPTIONAL
	WSDATA   csSgEstado                AS string OPTIONAL
	WSDATA   csSgPais                  AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Pedido_EnderecoDTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Pedido_EnderecoDTO
Return

WSMETHOD CLONE WSCLIENT Pedido_EnderecoDTO
	Local oClone := Pedido_EnderecoDTO():NEW()
	oClone:csCdCep              := ::csCdCep
	oClone:csDsComplemento      := ::csDsComplemento
	oClone:csDsEndereco         := ::csDsEndereco
	oClone:csNmBairro           := ::csNmBairro
	oClone:csNmCidade           := ::csNmCidade
	oClone:csNrEndereco         := ::csNrEndereco
	oClone:csSgEstado           := ::csSgEstado
	oClone:csSgPais             := ::csSgPais
Return oClone

WSMETHOD SOAPSEND WSCLIENT Pedido_EnderecoDTO
	Local cSoap := ""
	cSoap += WSSoapValue("sCdCep", ::csCdCep, ::csCdCep , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sDsComplemento", ::csDsComplemento, ::csDsComplemento , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sDsEndereco", ::csDsEndereco, ::csDsEndereco , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sNmBairro", ::csNmBairro, ::csNmBairro , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sNmCidade", ::csNmCidade, ::csNmCidade , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sNrEndereco", ::csNrEndereco, ::csNrEndereco , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sSgEstado", ::csSgEstado, ::csSgEstado , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
	cSoap += WSSoapValue("sSgPais", ::csSgPais, ::csSgPais , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO", .F.,.F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Pedido_EnderecoDTO
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::csCdCep            :=  WSAdvValue( oResponse,"_SCDCEP","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csDsComplemento    :=  WSAdvValue( oResponse,"_SDSCOMPLEMENTO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csDsEndereco       :=  WSAdvValue( oResponse,"_SDSENDERECO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csNmBairro         :=  WSAdvValue( oResponse,"_SNMBAIRRO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csNmCidade         :=  WSAdvValue( oResponse,"_SNMCIDADE","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csNrEndereco       :=  WSAdvValue( oResponse,"_SNRENDERECO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csSgEstado         :=  WSAdvValue( oResponse,"_SSGESTADO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csSgPais           :=  WSAdvValue( oResponse,"_SSGPAIS","string",NIL,NIL,NIL,"S",NIL,NIL) 
Return


