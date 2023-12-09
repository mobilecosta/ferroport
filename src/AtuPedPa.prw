#INCLUDE "protheus.ch"

#DEFINE ENTREGA_TOTAL '13'
#DEFINE ENTREGA_PARCIAL '14'


/*================================================================================================================*\
|| ############################################################################################################## ||
|| # Static Function: GraPedPa                                                                                  # ||
|| # Desc: Retorno pedido portal paradigma.                                                                     # ||
|| ############################################################################################################## ||
\*================================================================================================================*/
User Function AtuPedPa(cNumPed, cItemPed, cFilOpe, cOperacao)
	Local cQuery    := ""
	Local oPedido:= nil
	Local oStatement:= nil
	Local nNrItem	:= 0
	Local cNumAnt	:= ''
	Local cAliasSQL := Nil
	Local cFilAtu	:= cFilAnt
	Local cEncerr	:= 'E'
	Local noX := 0
	Local _x := 0
	Local cCnpjInt := ''
	Local xRet 		:= .f.
	Local nTotalSC7 := 0
	Local cDoc      := ''
	Local cRecb     :=''
	Local nIcmsST	:= 0
	Local cReplace 	:= "_"
    Local cErros   	:= ""
	Local cAvisos  	:= ""
	Private cIntegrado:= 'N'
	
	Private cSOAPret := ''
	
	public  cSOAPmgs := ''
	
	
	cQuery := "SELECT SC7.R_E_C_N_O_ RECNOC7, SB1.R_E_C_N_O_ RECNOB1, SB1.B1_COD, SB1.B1_DESC, SB1.B1_GRUPO, SB1.B1_UM " + CRLF
	cQuery += "FROM " + RETSQLTAB("SC7,SB1") + CRLF
	cQuery += "WHERE " + RETSQLDEL("SC7,SB1") + CRLF
	//cQuery += "		AND (C7_XINTPA = '2' OR C7_XINTPA = '3' OR C7_XINTPA = '4' OR C7_XINTPA = '5') " + CRLF
	If cOperacao == '1'
	   cQuery += "		AND C7_XINTPA = '2' " + CRLF //entra quando é inclusão 
	Else  
	   cQuery += "		AND (C7_XINTPA = '3' OR C7_XINTPA = '4' OR C7_XINTPA = '5') " + CRLF // entra quando é baixa 	
	ENDIF
	cQuery += "		AND C7_PRODUTO = B1_COD " + CRLF
	cQuery += "		AND C7_ORIGEM  = 'WBS' " + CRLF
	cQuery += "		AND C7_MEDICAO = '' " + CRLF
	If(ValType(cNumPed) == 'C' .AND. !empty(cNumPed))
        cQuery += "		AND C7_NUM = '" + cNumPed + "' " + CRLF
	EndIF
	/*If(ValType(cItemPed) == 'C' .AND. !empty(cItemPed))
		cQuery += "		AND C7_ITEM = '" + cItemPed + "' " + CRLF
	EndIf*/
	cQuery += "		AND C7_FILIAL IN (" + cFilOpe + ") " + CRLF
	cQuery += "		AND B1_FILIAL IN (" + cFilOpe + ") " + CRLF
	//cQuery += "		AND B1_FILIAL = '02' " + CRLF
	cQuery += "	ORDER BY  C7_FILIAL, C7_NUM, C7_ITEM" + CRLF
	
	// Trata SQL para proteger de SQL injection.
	oStatement := FWPreparedStatement():New()
	oStatement:SetQuery(cQuery)
	cQuery := oStatement:GetFixQuery()
	oStatement:Destroy()
	oStatement := nil

	cAliasSQL := MPSysOpenQuery(cQuery)
		
	DbSelectArea("SC7")
	DbSelectArea("SB1")
	Do While (cAliasSQL)->(!eof())
		SC7->(dbGoTo((cAliasSQL)->RECNOC7))
		SB1->(dbGoTo((cAliasSQL)->RECNOB1))
		cIntegrado:= 'N'
		if(cEmpAnt <> '99')
			cFilAnt := SC7->C7_FILIAL
		EndIf

		nTotalSC7 := 0
		cNumAnt := SC7->C7_NUM
		nNrItem := 0
		oPedido := JsonObject():New()
		oPedido['itens'] 	:= {}		
		//oPedido['recno'] 	:= {}
		oPedido['total']	:= 0
		oPedido['dvlfrete'] := 0
		cEncerr	:= 'E'
		
		Do While (cAliasSQL)->(!eof()) .AND. SC7->C7_NUM == cNumAnt .AND. cFilAnt == SC7->C7_FILIAL
			nNrItem++
			SC7->(dbGoTo((cAliasSQL)->RECNOC7))
			SB1->(dbGoTo((cAliasSQL)->RECNOB1))
		    nTotalSC7 += SC7->C7_TOTAL

			//aAdd(oPedido['recno'], (cAliasSQL)->RECNOC7)
            If nNrItem = 1
				oPedido['sCdPedidoERP']	:= AllTrim(SC7->C7_NUM)
				IF SC7->C7_CONAPRO == 'B'  
					oPedido['nCdSituacao']	:= '20'
				Else 
					oPedido['nCdSituacao']	:= '5'	
				Endif

				oPedido['sCdPedidoWBC']	:= SC7->C7_XNPEDWB
				oPedido['nCdPedido']	:= SC7->C7_XPEDWBC
				//oPedido['nIdComunicaFornecedor']:= ALLTRIM(SC7->C7_XIDCOMF)

				afilial := FWArrFilAtu( '01' , SC7->C7_FILIAL ) 

				IF SC7->C7_MOEDA == 1 
				
					//CnpjInt := AllTrim(POSICIONE('SA2',1, xFilial('SA2') + SC7->C7_FORNECE+SC7->C7_LOJA, 'A2_CGC'))
					dbselectArea("SA2")
					DbSetOrder(1) //A2_FILIAL+A2_COD+A2_LOJA
					If DbSeek(xFilial('SA2')+SC7->C7_FORNECE+SC7->C7_LOJA) 
						IF SA2->A2_EST == 'EX'

							cCnpjInt := SC7->C7_FORNECE
						ELSE 

							cCnpjInt := SA2->A2_CGC
						ENDIF 
					
					Endif
				
				Else

					dbselectArea("SA2")
					DbSetOrder(1) //A2_FILIAL+A2_COD+A2_LOJA
					If DbSeek(xFilial('SA2')+SC7->C7_FORNECE+SC7->C7_LOJA) 
						IF SA2->A2_EST == 'EX'

							cCnpjInt := SC7->C7_FORNECE
						ELSE 

							cCnpjInt := SA2->A2_CGC
						ENDIF 
					
					Endif
			
				Endif 

				oPedido['sCdFornecedor']			:= cCnpjInt
				oPedido['sCdComprador']				:= AllTrim(GetMv('MV_XMATCNP'))
				oPedido['sCdFrete']					:= SC7->C7_TPFRETE
				oPedido['sCdCondicaoPagamento']		:= AllTrim(SC7->C7_COND)
				/*
				if !empty(AllTrim(SC7->C7_XCOTACA))
				    oPedido['sCdGrupoCompra']		    := '1'//AllTrim(SC7->C7_XCOTACA)
				endif	 */

				DbSelectArea("ZUP")
				ZUP->(DbSetOrder(1))
				ZUP->(DbGoTop())
				ZUP->(DbSeek(SC7->C7_USER))
				
				cUsuaPar := AllTrim(ZUP->ZUP_NOMRED)

				oPedido['sCdUsuario']	    := cUsuaPar
				
				oPedido['tDtCadastro']		:= ajustaDT(SC7->C7_EMISSAO)
				oPedido['tDtEmissao']		:= ajustaDT(SC7->C7_EMISSAO) 
				//oPedido['nCdTipo']			:= STR(SC7->C7_XTPORIG)
				oPedido['nCdTipo']			:= SC7->C7_XCOTACA
					
				
				if(!empty(AllTrim(SC7->C7_CC)))
					oPedido['sCdCentroCusto']		:= AllTrim(SC7->C7_CC)
				EndIf
				oPedido['sCdMoeda']			:= alltrim(str(SC7->C7_MOEDA))		
				oPedido['nIdTipoOrigem']	:= '2'//alltrim(SC7->C7_ORIGEM)
			Endif	

			If Iif(ValType(SC7->C7_VALFRE)=="N",SC7->C7_VALFRE,Val(SC7->C7_VALFRE)) > 0
				oPedido['dvlfrete']				+= Iif(ValType(SC7->C7_VALFRE)=="N",SC7->C7_VALFRE,Val(SC7->C7_VALFRE))
			EndIf
			
			oPedido['total']			+= SC7->C7_TOTAL
			oItem := JsonObject():New()
			
			//Item do Pedido
			oItem['sCdItemWbc']			:= alltrim(SC7->C7_XITWBC)
			oItem['nCdPedidoItem']	    := alltrim(SC7->C7_XITPEWB)  //Criar campo para armazenar nCdPedidoItem no pedido de compra
			//oItem['sCdMarca']			:= alltrim(SC7->C7_XMARCA)   // /Criar campo para armazenar nCdPedidoItem no pedido de compra - ELB
            afilial := FWArrFilAtu( '01' , SC7->C7_FILIAL )
			oItem['sCdProduto']			:= AllTrim(SC7->C7_PRODUTO)
			oItem['sCdEmpresa']			:= AllTrim(GetMv('MV_XMATCNP'))
			//oItem['sDsItem']			:= AllTrim(SC7->C7_DESCRI)
			oItem['sDsItem']			:= EncodeUTF8(ReTiGraf(AllTrim(SC7->C7_DESCRI)), "cp1252")
			//oItem['sDsItem']			:= AllTrim(ReTiGraf(SC7->C7_OBS))
			oItem['sCdClasse']			:= AllTrim(SB1->B1_GRUPO)
			oItem['sCdUnidadeMedida']	:= AllTrim(SB1->B1_UM)
			oItem['dQtItem']			:= AllTrim(STR(SC7->C7_QUANT))
			oItem['dVlItem']			:= AllTrim(STR(SC7->C7_PRECO))
			oItem['dQtEntrega']			:= AllTrim(STR(SC7->C7_QUANT))
			If(!empty(AllTrim(SC7->C7_OBSM)))
				oItem['sDsObservacao']	:= EncodeUTF8(AllTrim(ReTiGraf(SC7->C7_OBSM)), "cp1252")
			EndIf
			oItem['sCdItemEmpresa']		:= AllTrim(SC7->C7_ITEM) //vERIFICAR DEPOIS
			/*if(!empty((cAliasSQL)->B1_EX_NBM))
				oItem['sCdNbm']			:= AllTrim(SB1->B1_EX_NBM)
			EndIf*/
			
			//oItem['nCdSituacao']		:= '5'
			IF SC7->C7_CONAPRO == 'B' 
				oItem['nCdSituacao']	:= '20'
			Else 
				oItem['nCdSituacao']	:= '5'	
			Endif
		
			If ajustaDT(SC7->C7_DATPRF) <> ajustaDT(SC7->C7_XDTAENT)
				oItem['tDtEntrega']			:= ajustaDT(SC7->C7_DATPRF)
			else
				oItem['tDtEntrega']			:= ajustaDT(SC7->C7_XDTAENT)
			endif
			oItem['nSqItemEndereco']			:= '1'
			//oItem['tDtFornecimento']	:= ajustaDT(C7_DATPRF) //BUSCAR NA SF1 
			//oItem['recSC7']				:= (cAliasSQL)->RECNOC7
			/*
			 * Entrega
			 */
			//If SC7->C7_XINTPA >= '2'
			IF  cOperacao > '2' 
				if(SC7->C7_QUJE <> 0 .And. SC7->C7_QUJE < SC7->C7_QUANT .AND. SC7->C7_RESIDUO <> 'S')
					//Entrega parcial
					DbSelectArea("SD1")
					SD1->(DbSetOrder(22))
					SD1->(DbGoTop())
					IF SD1->(DbSeek(cFilOpe+SC7->C7_NUM+SC7->C7_ITEM))
						cDoc :=  SD1->D1_DOC
					ENDIF
					//cFilOpe+SC7->C7_NUM+SC7->C7_FORNECE+SC7->C7_LOJA		


					DbSelectArea("SF1")
					SF1->(DbSetOrder(2))
					SF1->(DbGoTop())
					IF SF1->(DbSeek(cFilOpe+SC7->C7_FORNECE+SC7->C7_LOJA+cDoc))
						cRecb:= SF1->F1_RECBMTO
					Endif

					oItem['nCdPedidoSituacaoEntrega']	:= ENTREGA_PARCIAL
					oItem['nCdSituacao']				:= ENTREGA_PARCIAL
					oItem['nCdPedidoSituacao']			:= ENTREGA_PARCIAL
					oItem['dQtItemRealizado']			:= AllTrim(STR(SC7->C7_QUJE))
					oItem['dQtFornecimento']			:= AllTrim(STR(SC7->C7_QUJE))
					//oItem['nQtDiasEntrega']				:= '7'
					oItem['nSqItemEndereco']			:= '1' //ALLTRIM(STR(nNrItem))
					oItem['tDtFornecimento']	:= ajustaDT(cRecb) //BUSCAR NA SF1 
					oPedido['tDtFaturamento']			:= ajustaDT(SC7->C7_DATPRF)
					
				ElseIf(SC7->C7_QUJE >= SC7->C7_QUANT .OR. SC7->C7_RESIDUO == 'S')
					
					
					DbSelectArea("SD1")
					SD1->(DbSetOrder(22))
					SD1->(DbGoTop())
					IF SD1->(DbSeek(cFilOpe+SC7->C7_NUM+SC7->C7_ITEM))
						cDoc :=  SD1->D1_DOC
					ENDIF
					//cFilOpe+SC7->C7_NUM+SC7->C7_FORNECE+SC7->C7_LOJA		



					DbSelectArea("SF1")
					SF1->(DbSetOrder(2))
					SF1->(DbGoTop())
					IF SF1->(DbSeek(cFilOpe+SC7->C7_FORNECE+SC7->C7_LOJA+cDoc))
						cRecb:= SF1->F1_RECBMTO
					Endif

					//Entrega Total ou Residuo Eliminado 
			
					oItem['nCdPedidoSituacaoEntrega']	:= ENTREGA_TOTAL
					oItem['nCdSituacao']				:= ENTREGA_TOTAL
				
					oItem['dQtItemRealizado']			:= AllTrim(STR(SC7->C7_QUJE))
					oItem['dQtFornecimento']			:= AllTrim(STR(SC7->C7_QUJE))
					//oItem['nQtDiasEntrega']				:= '7'
					oItem['nSqItemEndereco']			:= '1'
					oItem['tDtFornecimento']	:= ajustaDT(cRecb) //BUSCAR NA SF1 
					oPedido['tDtFaturamento']			:= ajustaDT(SC7->C7_DATPRF)
				EndIf
				
				If(SC7->C7_ENCER <> 'E')
					cEncerr	:= ' '
				EndIf
				
				//Verifica se é integração para informar o atendimento/entrega
				If(oItem['nCdSituacao'] == ENTREGA_TOTAL .OR. oItem['nCdSituacao'] == ENTREGA_PARCIAL)
					//Verifica se o pedido tem mais itens que não foram entregues
					lEntTotal := verifItens(SC7->C7_FILIAL, SC7->C7_NUM)	
					If(cEncerr == 'E' .AND. lEntTotal)
						oPedido['nCdSituacao']		:= ENTREGA_TOTAL
					Else
						oPedido['nCdSituacao']		:= ENTREGA_PARCIAL
					EndIf
					SC7->(dbGoTo((cAliasSQL)->RECNOC7))
				EndIf
			Endif	
			oItem['sCdEmpresaCobrancaEndereco'] 	:= AllTrim(GetMv('MV_XMATCNP'))
			oItem['sCdEmpresaEntregaEndereco'] 	    := AllTrim(GetMv('MV_XMATCNP'))
			oItem['sCdEmpresaFaturamentoEndereco'] 	:= AllTrim(GetMv('MV_XMATCNP'))
			oItem['sCdRequisicaoEmpresa'] 			:= SC7->C7_NUMSC  //ADICIONAR CAMPO ELB FEITO
			oItem['sCdItemRequisicaoEmpresa'] 		:= SC7->C7_ITEMSC //ADICIONAR CAMPO ELB  FEITO

			// Taxas do Item
			oItem['taxas'] = {}
			If alltrim(SC7->C7_XWBSXML)<>''
				oXML := XMLParser(SC7->C7_XWBSXML, cReplace, @cErros, @cAvisos)

				If ValType(oXML:_S_ENVELOPE:_S_BODY:_RetornarTodosPedidosEmProcessoDeIntegracaoResponse:_RetornarTodosPedidosEmProcessoDeIntegracaoResult:_A_PedidoDTO) == "A"
					oAux2 := oXML:_S_ENVELOPE:_S_BODY:_RetornarTodosPedidosEmProcessoDeIntegracaoResponse:_RetornarTodosPedidosEmProcessoDeIntegracaoResult:_A_PedidoDTO
					nLoop := len(oAux2)
					For noX := 1 to nLoop
						If alltrim(oAux2[noX]:_A_NCDPEDIDO:TEXT) == alltrim(Alltrim(SC7->C7_XPEDWBC))
							oAux1 :=  oAux2[noX]
						EndIf  
					Next
					oXML := oAux1
				Else	
					oXML := oXML:_S_ENVELOPE:_S_BODY:_RetornarTodosPedidosEmProcessoDeIntegracaoResponse:_RetornarTodosPedidosEmProcessoDeIntegracaoResult:_A_PedidoDTO
				Endif
				
				//Impostos
				If valtype(oXML:_A_LSTPEDIDOITEM:_A_PEDIDOITEMDTO) = 'A'
					oXmlItem := oXML:_A_LSTPEDIDOITEM:_A_PEDIDOITEMDTO[nNrItem]
				else
					oXmlItem := oXML:_A_LSTPEDIDOITEM:_A_PEDIDOITEMDTO
				EndIf
				
				If alltrim(oXmlItem:_A_dVlUnitarioBruto:TEXT)<>''
					oItem['dVlUnitarioBruto'] := oXmlItem:_A_dVlUnitarioBruto:TEXT
				EndIf	

				If ValType(oXmlItem:_A_LSTPEDIDOITEMENTREGA:_A_PEDIDOITEMENTREGADTO) == 'A'
					oItem['nSqItemEndereco'] := oXmlItem:_A_LSTPEDIDOITEMENTREGA:_A_PEDIDOITEMENTREGADTO[1]:_A_nSqItemEndereco:TEXT
				Else
					oItem['nSqItemEndereco'] := oXmlItem:_A_LSTPEDIDOITEMENTREGA:_A_PEDIDOITEMENTREGADTO:_A_nSqItemEndereco:TEXT
				EndIf	
				
				FOR _x:=1 to len(oXmlItem:_A_LSTPEDIDOITEMTAXA:_A_PEDIDOITEMTAXADTO)
					oTaxa := JsonObject():New()
					oTaxa['bFlIncluso']		:= oXmlItem:_A_LSTPEDIDOITEMTAXA:_A_PEDIDOITEMTAXADTO[_x]:_A_bFlIncluso:TEXT
					oTaxa['dPcTaxa']		:= oXmlItem:_A_LSTPEDIDOITEMTAXA:_A_PEDIDOITEMTAXADTO[_x]:_A_DPCTAXA:TEXT
					oTaxa['nCdTaxa']		:= oXmlItem:_A_LSTPEDIDOITEMTAXA:_A_PEDIDOITEMTAXADTO[_x]:_A_NCDTAXA:TEXT
					aAdd(oItem['taxas'], oTaxa)
				Next _x
			Else
				//ICMS
				oTaxa := JsonObject():New()
				
				if(SC7->C7_PICM > 0)
					oTaxa['bFlIncluso']		:= '1'
					oTaxa['dPcTaxa']		:= AllTrim(STR(SC7->C7_PICM))
					oTaxa['nCdTaxa']		:= '1'
				Else
					oTaxa['bFlIncluso']		:= '1'
					oTaxa['dPcTaxa']		:= '0'
					oTaxa['nCdTaxa']		:= '1'
				EndIf
				aAdd(oItem['taxas'], oTaxa)
				
				
				//IPI
				oTaxa := JsonObject():New()
				if(SC7->C7_IPI > 0)
					oTaxa['bFlIncluso']		:= '0'
					oTaxa['dPcTaxa']		:= AllTrim(STR(SC7->C7_IPI))
					oTaxa['nCdTaxa']		:= '2'
				Else
					oTaxa['bFlIncluso']		:= '0'
					oTaxa['dPcTaxa']		:= '0'
					oTaxa['nCdTaxa']		:= '2'
				EndIf
				
				aAdd(oItem['taxas'], oTaxa)
				
				oTaxa := JsonObject():New()
				if(SC7->C7_ICMSRET > 0)
					
					nIcmsST := SC7->C7_ICMSRET/nTotalSC7 * 100
					
					oTaxa['bFlIncluso']		:= '0'
					oTaxa['dPcTaxa']		:= AllTrim(STR(nIcmsST))
					oTaxa['nCdTaxa']		:= '3'
				Else
					oTaxa['bFlIncluso']		:= '0'
					oTaxa['dPcTaxa']		:= '0'
					oTaxa['nCdTaxa']		:= '3'
				EndIf
				aAdd(oItem['taxas'], oTaxa)


				oTaxa := JsonObject():New()
				if(SC7->C7_ALIQISS > 0)
					oTaxa['bFlIncluso']		:= '1'
					oTaxa['dPcTaxa']		:= AllTrim(STR(SC7->C7_ALIQISS))
					oTaxa['nCdTaxa']		:= '4'
				Else
					oTaxa['bFlIncluso']		:= '1'
					oTaxa['dPcTaxa']		:= '0'
					oTaxa['nCdTaxa']		:= '4'
				EndIf
				aAdd(oItem['taxas'], oTaxa)
			endif	
			
			aAdd(oPedido['itens'], oItem)
			
			(cAliasSQL)->(dbSkip())
			If(cAliasSQL)->(!eof())
				SC7->(dbGoTo((cAliasSQL)->RECNOC7))
				SB1->(dbGoTo((cAliasSQL)->RECNOB1))
			EndIf

			//oPedido['dVlTotal']	:= AllTrim(STR(nTotalSC7))
		EndDo
		lRet :=.F.
		if(nNrItem > 0)
			xRet := integPed(oPedido)
		Else
		    xRet := 'Pedido de compra não encontrado'	
		EndIf
		
	EndDo
	//U_WsAtuDatEn()//Alexandre, inclui a alteração da data de entrega apartir do RetornarPedidoAtualizadoNoPortal

	cFilAnt := cFilAtu
	(cAliasSQL)->(dbCloseArea())
	SC7->(dbCloseArea())
	SB1->(dbCloseArea())
Return xRet


/*
 * Realiza a Integração do pedido
 */
Static Function integPed(oPedido)
	Local xRet 		:= Nil
	Local cMetodo 	:= ''
	//Local nI

	/*if(oPedido['nCdSituacao'] == ENTREGA_TOTAL .OR. oPedido['nCdSituacao'] == ENTREGA_PARCIAL)
		cMetodo 	:= 'ProcessarPedidoAlteracao'
		xret := GraPedPa(oPedido, cMetodo)
	Else
		If(cIntegrado == 'N')
			cMetodo 	:= 'ProcessarPedido'
			xret := GraPedPa(oPedido, cMetodo)
		Else
			xRet := "Pedido já integrado anteriormente. "
			For nI := 1 to Len(oPedido['itens'])
				DbSelectArea("SC7")
				SC7->(dbGoTo(oPedido['itens'][nI]['recSC7']))
				RecLock("SC7",.F.)
					SC7->C7_MSEXP := DTOS(Date())
				SC7->(MsUnlock())
			Next nI
		EndIf
	EndIf*/
	cMetodo := 'ProcessarPedidoAlteracao'
	xret    := GraPedPa(oPedido, cMetodo)
Return xret

/*================================================================================================================*\
|| ############################################################################################################## ||
|| # Static Function: GraPedPa                                                                                  # ||
|| # Desc: Retorno pedido portal paradigma.                                                                     # ||
|| ############################################################################################################## ||
\*================================================================================================================*/
static Function GraPedPa(oPedido, cMetodo)
  	//Dados da configuração de Proxy no Configurador
	Local lProxy     := ( FWSFPolice("COMUNICATION", "USR_PROXY") == "T" )
	Local cPrxServer := Alltrim( FWSFPolice("COMUNICATION", "USR_PROXYIP") )
	Local nPrxPort   := Val( FWSFPolice("COMUNICATION", "USR_PROXYPORT") )
	Local cPrxUser   := Alltrim( FWSFPolice("COMUNICATION", "USR_PROXYLOGON") )
	
	Local cDTO := ''
	Local nI := 0
	Local nE := 0
		
	Local oWsdl
	Local xRet
	//Local cErro 	:= ""
	//Local cAviso 	:= ""
	Local aOps := {}, aComplex := {}, aSimple := {}
	Local cURL := GetMv("MV_XPARURL")

	//varinfo('', oPedido)
	
	/*if(valType(cMetodo) <> 'C' .OR. empty(allTrim(cMetodo)))
		cMetodo := 'ProcessarPedido'
	EndIf
	
	if(cMetodo == 'ProcessarPedido')
		cDTO := 'lstPedido'
	Else
		cDTO := 'lstPedidoDetalhe'
	EndIf*/

	cDTO := 'lstPedidoDetalhe'

	// Cria o objeto da classe TWsdlManager
	oWsdl := TWsdlManager():New()
	oWsdl:AddHttpHeader("Authorization", "Bearer " + U_NewToken())
			
 	//Define as propriedades para tratar os prefixos NS das tags do XML e para remover as tags vazias
	oWsdl:lUseNSPrefix := .T.
	oWsdl:lRemEmptyTags := .T.
	//define que irá remover os tipos complexos que foram definidos com 0 no método SetComplexOccurs
	oWsdl:lProcResp 	:= .F.
			
	If lProxy
		oWsdl:SetProxy(cPrxServer, nPrxPort)
		oWsdl:SetCredentials(cPrxUser, cPrxPass)
	EndIf
			
	//Verificação SSL
	
    If "https:" $ cUrl
    	oWsdl:cSSLCACertFile := "\certs\sslCaCert.cer"
    	oWsdl:cSSLCertFile 	 := "\certs\sslCert.crt"
    	oWsdl:cSSLKeyFile    := "\certs\sslKeyCert.key"
    	oWsdl:lSSLInsecure   := .T.
    EndIf
		
  // Faz o parse de uma URL
  xRet := oWsdl:ParseURL(AllTrim(GetMv("MV_XPARURL"))+'/services/Pedido.svc?wsdl')	
  if xRet == .F.
    Return "Erro: " + oWsdl:cError
  endif
			
  aOps := oWsdl:ListOperations()
			
  if Len( aOps ) == 0
    Return "Não existem operações"
  endif
			
  // Define a operação
  xRet := oWsdl:SetOperation( cMetodo )
  if xRet == .F.
     Return "Não foi possivel executar a operacao " + cMetodo
  endif
     		
  	aComplex := oWsdl:NextComplex()
	While ValType( aComplex ) == "A"
		//varinfo( "", aComplex )
		nOccurs := 0
     		
		If (aComplex[2] == "lstPedido" .OR. aComplex[2] == "lstPedidoDetalhe")
			nOccurs := 1
		EndIf

		If (aComplex[2] == "PedidoDTO")
			nOccurs := 1
		EndIf

		If (aComplex[2] == "lstAnexo")
//			nOccurs := 1
		EndIf

		If (aComplex[2] == "AnexoDTO")
//			nOccurs := 1
		EndIf

		If (aComplex[2] == "lstPedidoItem")
			nOccurs := 1
		EndIf

		If (aComplex[2] == "PedidoItemDTO")
			nOccurs := Len (oPedido['itens'])
		EndIf

		If (aComplex[2] == "lstAnexo")
//			nOccurs := 1
		EndIf

		If (aComplex[2] == "AnexoDTO")
//			nOccurs := 1
		EndIf

		If (aComplex[2] == "lstPedidoItemEntrega")
			nOccurs := 1
		EndIf

		If (aComplex[2] == "PedidoItemEntregaDTO")
			nOccurs := 1
		EndIf

		/*If (aComplex[2] == "oCobrancaEndereco")
			nOccurs := 1
		EndIf

		If (aComplex[2] == "oEntregaEndereco")
			nOccurs := 1
		EndIf

		If (aComplex[2] == "oFaturamentoEndereco")
			nOccurs := 1
		EndIf*/

		If (aComplex[2] == "lstPedidoItemTaxa")
			nOccurs := 1
		EndIf

		If (aComplex[2] == "PedidoItemTaxaDTO")
			nOccurs := 4
		EndIf

		/*
        If (aComplex[2] == "lstPedidoItemRateio")
			nOccurs := 1
		EndIf
	
		If (aComplex[2] == "PedidoItemRateioDTO")
			nOccurs := 1
		EndIf
		*/

		xRet := oWsdl:SetComplexOccurs( aComplex[1], nOccurs )
		if xRet == .F.
			xRet := I18N("Erro ao definir elemento #1, ID #2, com #3 ocorrencias",{aComplex[2],cValToChar( aComplex[1] ),cValToChar( nOccurs )})
			Return xRet
		endif
	   
		aComplex := oWsdl:NextComplex()
	EndDo
		
	aSimple := oWsdl:SimpleInput()
	//varinfo( "", aSimple )
		
  //------------------------------------------------------------------------------
	xRet := .T.
	nPos := aScan( aSimple, {|x| x[2] == "dVlFrete" .AND. x[5] == cMetodo + "#1." + cDTO + "#1.PedidoDTO#1"} )
	if nPos > 0 .AND. ValType(oPedido['dvlfrete']) <> "U"
		xRet := oWsdl:SetValue( aSimple[nPos][1], AllTrim(STR(oPedido['dvlfrete'])))
	endif
	if xRet == .F.
		xRet := oWsdl:cError
		Return "Erro ao Setar o campo dVlFrete"
	endif

	xRet := .T.
	nPos := aScan( aSimple, {|x| x[2] == "dVlTotal" .AND. x[5] == cMetodo + "#1." + cDTO + "#1.PedidoDTO#1"} )
	if nPos > 0 .AND. ValType(oPedido['total']) <> "U"
		xRet := oWsdl:SetValue( aSimple[nPos][1], AllTrim(STR(oPedido['total'])))
	endif
	if xRet == .F.
		xRet := oWsdl:cError
		Return "Erro ao Setar o campo dVlTotal"
	endif

	xRet := .T.
	nPos := aScan( aSimple, {|x| x[2] == "sDsAnexo" .AND. x[5] == cMetodo + "#1." + cDTO + "#1.PedidoDTO#1.lstAnexo#1.AnexoDTO#1"} )
	if nPos > 0 .AND. ValType(oPedido['sDsAnexo']) <> "U"
		xRet := oWsdl:SetValue( aSimple[nPos][1], oPedido['sDsAnexo'])
	endif
	if xRet == .F.
		xRet := oWsdl:cError
		Return "Erro ao Setar o campo sDsAnexo"
	endif

	xRet := .T.
	nPos := aScan( aSimple, {|x| x[2] == "sNmArquivo" .AND. x[5] == cMetodo + "#1." + cDTO + "#1.PedidoDTO#1.lstAnexo#1.AnexoDTO#1"} )
	if nPos > 0 .AND. ValType(oPedido['sNmArquivo']) <> "U"
		xRet := oWsdl:SetValue( aSimple[nPos][1], oPedido['sNmArquivo'])
	endif
	if xRet == .F.
		xRet := oWsdl:cError
		Return "Erro ao Setar o campo sNmArquivo"
	endif

	xRet := .T.
	nPos := aScan( aSimple, {|x| x[2] == "nIdComunicaFornecedor" .AND. x[5] == cMetodo + "#1." + cDTO + "#1.PedidoDTO#1"} )
	if nPos > 0 .AND. ValType(oPedido['nIdComunicaFornecedor']) <> "U"
		xRet := oWsdl:SetValue( aSimple[nPos][1], oPedido['nIdComunicaFornecedor'])
	endif
	if xRet == .F.
		xRet := oWsdl:cError
		Return "Erro ao Setar o campo nIdComunicaFornecedor"
	endif
 
	//Processa itens
	For nI := 1 to Len (oPedido['itens'])
		cI := AllTrim(STR(nI))
		oItem := oPedido['itens'][nI]
	
		xRet := .T.
		nPos := aScan( aSimple, {|x| x[2] == "dPcDesconto" .AND. x[5] == cMetodo + "#1." + cDTO + "#1.PedidoDTO#1.lstPedidoItem#1.PedidoItemDTO#" + cI} )
		if nPos > 0 .AND. ValType(oItem['dPcDesconto']) <> "U"
			xRet := oWsdl:SetValue( aSimple[nPos][1], oItem['dPcDesconto'])
		endif
		if xRet == .F.
			xRet := oWsdl:cError
			Return "Erro ao Setar o campo dPcDesconto"
		endif
		
		xRet := .T.
		nPos := aScan( aSimple, {|x| x[2] == "dQtItem" .AND. x[5] == cMetodo + "#1." + cDTO + "#1.PedidoDTO#1.lstPedidoItem#1.PedidoItemDTO#" + cI} )
		if nPos > 0 .AND. ValType(oItem['dQtItem']) <> "U"
			xRet := oWsdl:SetValue( aSimple[nPos][1], oItem['dQtItem'])
		endif
		if xRet == .F.
			xRet := oWsdl:cError
			Return "Erro ao Setar o campo dQtItem"
		endif
	
		xRet := .T.
		nPos := aScan( aSimple, {|x| x[2] == "dVlItem" .AND. x[5] == cMetodo + "#1." + cDTO + "#1.PedidoDTO#1.lstPedidoItem#1.PedidoItemDTO#" + cI} )
		if nPos > 0 .AND. ValType(oItem['dVlItem']) <> "U"
			xRet := oWsdl:SetValue( aSimple[nPos][1], oItem['dVlItem'])
		endif
		if xRet == .F.
			xRet := oWsdl:cError
			Return "Erro ao Setar o campo dVlItem"
		endif
					
// Entrega Item -----------------------------------------------------------------------------------------
		xRet := .T.
		nPos := aScan( aSimple, {|x| x[2] == "dQtEntrega" .AND. x[5] == cMetodo + "#1." + cDTO + "#1.PedidoDTO#1.lstPedidoItem#1.PedidoItemDTO#" + cI +".lstPedidoItemEntrega#1.PedidoItemEntregaDTO#1"} )
		if nPos > 0 .AND. ValType(oItem['dQtEntrega']) <> "U"
			xRet := oWsdl:SetValue( aSimple[nPos][1], oItem['dQtEntrega'])
		endif
		if xRet == .F.
			xRet := oWsdl:cError
			Return "Erro ao Setar o campo dQtEntrega"
		endif

		xRet := .T.
		nPos := aScan( aSimple, {|x| x[2] == "dQtItemConfirmada" .AND. x[5] == cMetodo + "#1." + cDTO + "#1.PedidoDTO#1.lstPedidoItem#1.PedidoItemDTO#" + cI +".lstPedidoItemEntrega#1.PedidoItemEntregaDTO#1"} )
		if nPos > 0 .AND. ValType(oItem['dQtItemConfirmada']) <> "U"
			xRet := oWsdl:SetValue( aSimple[nPos][1], oItem['dQtItemConfirmada'])
		endif
		if xRet == .F.
			xRet := oWsdl:cError
			Return "Erro ao Setar o campo dQtItemConfirmada"
		endif

		xRet := .T.
		nPos := aScan( aSimple, {|x| x[2] == "dQtFornecimento" .AND. x[5] == cMetodo + "#1." + cDTO + "#1.PedidoDTO#1.lstPedidoItem#1.PedidoItemDTO#" + cI +".lstPedidoItemEntrega#1.PedidoItemEntregaDTO#1"} )
		if nPos > 0 .AND. ValType(oItem['dQtFornecimento']) <> "U"
			xRet := oWsdl:SetValue( aSimple[nPos][1], oItem['dQtFornecimento'])
		endif
		if xRet == .F.
			xRet := oWsdl:cError
			Return "Erro ao Setar o campo dQtFornecimento"
		endif

		xRet := .T.
		nPos := aScan( aSimple, {|x| x[2] == "dQtItemRealizado" .AND. x[5] == cMetodo + "#1." + cDTO + "#1.PedidoDTO#1.lstPedidoItem#1.PedidoItemDTO#" + cI +".lstPedidoItemEntrega#1.PedidoItemEntregaDTO#1"} )
		if nPos > 0 .AND. ValType(oItem['dQtItemRealizado']) <> "U"
			xRet := oWsdl:SetValue( aSimple[nPos][1], oItem['dQtItemRealizado'])
		endif
		if xRet == .F.
			xRet := oWsdl:cError
			Return "Erro ao Setar o campo dQtItemRealizado"
		endif

		xRet := .T.
		nPos := aScan( aSimple, {|x| x[2] == "dQtPorUnidade" .AND. x[5] == cMetodo + "#1." + cDTO + "#1.PedidoDTO#1.lstPedidoItem#1.PedidoItemDTO#" + cI +".lstPedidoItemEntrega#1.PedidoItemEntregaDTO#1"} )
		if nPos > 0 .AND. ValType(oItem['dQtPorUnidade']) <> "U"
			xRet := oWsdl:SetValue( aSimple[nPos][1], oItem['dQtPorUnidade'])
		endif
		if xRet == .F.
			xRet := oWsdl:cError
			Return "Erro ao Setar o campo dQtPorUnidade"
		endif

		xRet := .T.
		nPos := aScan( aSimple, {|x| x[2] == "dQtSolicitacaoEntrega" .AND. x[5] == cMetodo + "#1." + cDTO + "#1.PedidoDTO#1.lstPedidoItem#1.PedidoItemDTO#" + cI +".lstPedidoItemEntrega#1.PedidoItemEntregaDTO#1"} )
		if nPos > 0 .AND. ValType(oItem['dQtSolicitacaoEntrega']) <> "U"
			xRet := oWsdl:SetValue( aSimple[nPos][1], oItem['dQtSolicitacaoEntrega'])
		endif
		if xRet == .F.
			xRet := oWsdl:cError
			Return "Erro ao Setar o campo dQtSolicitacaoEntrega"
		endif

		xRet := .T.
		nPos := aScan( aSimple, {|x| x[2] == "dQtUnidade" .AND. x[5] == cMetodo + "#1." + cDTO + "#1.PedidoDTO#1.lstPedidoItem#1.PedidoItemDTO#" + cI +".lstPedidoItemEntrega#1.PedidoItemEntregaDTO#1"} )
		if nPos > 0 .AND. ValType(oItem['dQtUnidade']) <> "U"
			xRet := oWsdl:SetValue( aSimple[nPos][1], oItem['dQtUnidade'])
		endif
		if xRet == .F.
			xRet := oWsdl:cError
			Return "Erro ao Setar o campo dQtUnidade"
		endif

		xRet := .T.
		nPos := aScan( aSimple, {|x| x[2] == "nCdPedidoSituacao" .AND. x[5] == cMetodo + "#1." + cDTO + "#1.PedidoDTO#1.lstPedidoItem#1.PedidoItemDTO#" + cI +".lstPedidoItemEntrega#1.PedidoItemEntregaDTO#1"} )
		if nPos > 0 .AND. ValType(oItem['nCdPedidoSituacao']) <> "U"
			xRet := oWsdl:SetValue( aSimple[nPos][1], oItem['nCdPedidoSituacao'])
		endif
		if xRet == .F.
			xRet := oWsdl:cError
			Return "Erro ao Setar o campo nCdPedidoSituacao"
		endif

		xRet := .T.
		nPos := aScan( aSimple, {|x| x[2] == "nCdPedidoSituacaoEntrega" .AND. x[5] == cMetodo + "#1." + cDTO + "#1.PedidoDTO#1.lstPedidoItem#1.PedidoItemDTO#" + cI +".lstPedidoItemEntrega#1.PedidoItemEntregaDTO#1"} )
		if nPos > 0 .AND. ValType(oItem['nCdPedidoSituacaoEntrega']) <> "U"
			xRet := oWsdl:SetValue( aSimple[nPos][1], oItem['nCdPedidoSituacaoEntrega'])
		endif
		if xRet == .F.
			xRet := oWsdl:cError
			Return "Erro ao Setar o campo nCdPedidoSituacaoEntrega"
		endif

		xRet := .T.
		nPos := aScan( aSimple, {|x| x[2] == "nQtDiasEntrega" .AND. x[5] == cMetodo + "#1." + cDTO + "#1.PedidoDTO#1.lstPedidoItem#1.PedidoItemDTO#" + cI +".lstPedidoItemEntrega#1.PedidoItemEntregaDTO#1"} )
		if nPos > 0 .AND. ValType(oItem['nQtDiasEntrega']) <> "U"
			xRet := oWsdl:SetValue( aSimple[nPos][1], oItem['nQtDiasEntrega'])
		endif
		if xRet == .F.
			xRet := oWsdl:cError
			Return "Erro ao Setar o campo nQtDiasEntrega"
		endif

		xRet := .T.
		nPos := aScan( aSimple, {|x| x[2] == "nSqItemEndereco" .AND. x[5] == cMetodo + "#1." + cDTO + "#1.PedidoDTO#1.lstPedidoItem#1.PedidoItemDTO#" + cI +".lstPedidoItemEntrega#1.PedidoItemEntregaDTO#1"} )
		if nPos > 0 .AND. ValType(oItem['nSqItemEndereco']) <> "U"
			xRet := oWsdl:SetValue( aSimple[nPos][1], oItem['nSqItemEndereco'])
		endif
		if xRet == .F.
			xRet := oWsdl:cError
			Return "Erro ao Setar o campo nSqItemEndereco"
		endif

		xRet := .T.
		nPos := aScan( aSimple, {|x| x[2] == "nSqItemEnderecoPai" .AND. x[5] == cMetodo + "#1." + cDTO + "#1.PedidoDTO#1.lstPedidoItem#1.PedidoItemDTO#" + cI +".lstPedidoItemEntrega#1.PedidoItemEntregaDTO#1"} )
		if nPos > 0 .AND. ValType(oItem['nSqItemEnderecoPai']) <> "U"
			xRet := oWsdl:SetValue( aSimple[nPos][1], oItem['nSqItemEnderecoPai'])
		endif
		if xRet == .F.
			xRet := oWsdl:cError
			Return "Erro ao Setar o campo nSqItemEnderecoPai"
		endif

//Endereço de Cobrança -------------------------------------------------------------------------------------------------
		/*xRet := .T.
		nPos := aScan( aSimple, {|x| x[2] == "sCdCep" .AND. x[5] == cMetodo + "#1." + cDTO + "#1.PedidoDTO#1.lstPedidoItem#1.PedidoItemDTO#" + cI +".lstPedidoItemEntrega#1.PedidoItemEntregaDTO#1.oCobrancaEndereco#1"} )
		if nPos > 0 .AND. ValType(oPedido['endereco']['cobranca']['cep']) <> "U"
			xRet := oWsdl:SetValue( aSimple[nPos][1], oPedido['endereco']['cobranca']['cep'])
		endif
		if xRet == .F.
			xRet := oWsdl:cError
			Return "Erro ao Setar o campo sCdCep"
		endif

		xRet := .T.
		nPos := aScan( aSimple, {|x| x[2] == "sDsComplemento" .AND. x[5] == cMetodo + "#1." + cDTO + "#1.PedidoDTO#1.lstPedidoItem#1.PedidoItemDTO#" + cI +".lstPedidoItemEntrega#1.PedidoItemEntregaDTO#1.oCobrancaEndereco#1"} )
		if nPos > 0 .AND. ValType(oPedido['endereco']['cobranca']['complemento']) <> "U"
			xRet := oWsdl:SetValue( aSimple[nPos][1], oPedido['endereco']['cobranca']['complemento'])
		endif
		if xRet == .F.
			xRet := oWsdl:cError
			Return "Erro ao Setar o campo sDsComplemento"
		endif

		xRet := .T.
		nPos := aScan( aSimple, {|x| x[2] == "sDsEndereco" .AND. x[5] == cMetodo + "#1." + cDTO + "#1.PedidoDTO#1.lstPedidoItem#1.PedidoItemDTO#" + cI +".lstPedidoItemEntrega#1.PedidoItemEntregaDTO#1.oCobrancaEndereco#1"} )
		if nPos > 0 .AND. ValType(oPedido['endereco']['cobranca']['endereco']) <> "U"
			xRet := oWsdl:SetValue( aSimple[nPos][1], oPedido['endereco']['cobranca']['endereco'])
		endif
		if xRet == .F.
			xRet := oWsdl:cError
			Return "Erro ao Setar o campo sDsEndereco"
		endif

		xRet := .T.
		nPos := aScan( aSimple, {|x| x[2] == "sNmBairro" .AND. x[5] == cMetodo + "#1." + cDTO + "#1.PedidoDTO#1.lstPedidoItem#1.PedidoItemDTO#" + cI +".lstPedidoItemEntrega#1.PedidoItemEntregaDTO#1.oCobrancaEndereco#1"} )
		if nPos > 0 .AND. ValType(oPedido['endereco']['cobranca']['bairro']) <> "U"
			xRet := oWsdl:SetValue( aSimple[nPos][1], oPedido['endereco']['cobranca']['bairro'])
		endif
		if xRet == .F.
			xRet := oWsdl:cError
			Return "Erro ao Setar o campo sNmBairro"
		endif

		xRet := .T.
		nPos := aScan( aSimple, {|x| x[2] == "sNmCidade" .AND. x[5] == cMetodo + "#1." + cDTO + "#1.PedidoDTO#1.lstPedidoItem#1.PedidoItemDTO#" + cI +".lstPedidoItemEntrega#1.PedidoItemEntregaDTO#1.oCobrancaEndereco#1"} )
		if nPos > 0 .AND. ValType(oPedido['endereco']['cobranca']['cidade']) <> "U"
			xRet := oWsdl:SetValue( aSimple[nPos][1], oPedido['endereco']['cobranca']['cidade'])
		endif
		if xRet == .F.
			xRet := oWsdl:cError
			Return "Erro ao Setar o campo sNmCidade"
		endif

		xRet := .T.
		nPos := aScan( aSimple, {|x| x[2] == "sNrEndereco" .AND. x[5] == cMetodo + "#1." + cDTO + "#1.PedidoDTO#1.lstPedidoItem#1.PedidoItemDTO#" + cI +".lstPedidoItemEntrega#1.PedidoItemEntregaDTO#1.oCobrancaEndereco#1"} )
		if nPos > 0 .AND. ValType(oPedido['endereco']['cobranca']['numero']) <> "U"
			xRet := oWsdl:SetValue( aSimple[nPos][1], oPedido['endereco']['cobranca']['numero'])
		endif
		if xRet == .F.
			xRet := oWsdl:cError
			Return "Erro ao Setar o campo sNrEndereco"
		endif

		xRet := .T.
		nPos := aScan( aSimple, {|x| x[2] == "sSgEstado" .AND. x[5] == cMetodo + "#1." + cDTO + "#1.PedidoDTO#1.lstPedidoItem#1.PedidoItemDTO#" + cI +".lstPedidoItemEntrega#1.PedidoItemEntregaDTO#1.oCobrancaEndereco#1"} )
		if nPos > 0 .AND. ValType(oPedido['endereco']['cobranca']['uf']) <> "U"
			xRet := oWsdl:SetValue( aSimple[nPos][1], oPedido['endereco']['cobranca']['uf'])
		endif
		if xRet == .F.
			xRet := oWsdl:cError
			Return "Erro ao Setar o campo sSgEstado"
		endif

		xRet := .T.
		nPos := aScan( aSimple, {|x| x[2] == "sSgPais" .AND. x[5] == cMetodo + "#1." + cDTO + "#1.PedidoDTO#1.lstPedidoItem#1.PedidoItemDTO#" + cI +".lstPedidoItemEntrega#1.PedidoItemEntregaDTO#1.oCobrancaEndereco#1"} )
		if nPos > 0 .AND. ValType(oPedido['endereco']['cobranca']['pais']) <> "U"
			xRet := oWsdl:SetValue( aSimple[nPos][1], oPedido['endereco']['cobranca']['pais'])
		endif
		if xRet == .F.
			xRet := oWsdl:cError
			Return "Erro ao Setar o campo sSgPais"
		endif*/

//Endereço de Entrega -------------------------------------------------------------------------------------------------
		/*xRet := .T.
		nPos := aScan( aSimple, {|x| x[2] == "sCdCep" .AND. x[5] == cMetodo + "#1." + cDTO + "#1.PedidoDTO#1.lstPedidoItem#1.PedidoItemDTO#" + cI +".lstPedidoItemEntrega#1.PedidoItemEntregaDTO#1.oEntregaEndereco#1"} )
		if nPos > 0 .AND. ValType(oPedido['endereco']['entrega']['cep']) <> "U"
			xRet := oWsdl:SetValue( aSimple[nPos][1], oPedido['endereco']['entrega']['cep'])
		endif
		if xRet == .F.
			xRet := oWsdl:cError
			Return "Erro ao Setar o campo sCdCep"
		endif

		xRet := .T.
		nPos := aScan( aSimple, {|x| x[2] == "sDsComplemento" .AND. x[5] == cMetodo + "#1." + cDTO + "#1.PedidoDTO#1.lstPedidoItem#1.PedidoItemDTO#" + cI +".lstPedidoItemEntrega#1.PedidoItemEntregaDTO#1.oEntregaEndereco#1"} )
		if nPos > 0 .AND. ValType(oPedido['endereco']['entrega']['complemento']) <> "U"
			xRet := oWsdl:SetValue( aSimple[nPos][1], oPedido['endereco']['entrega']['complemento'])
		endif
		if xRet == .F.
			xRet := oWsdl:cError
			Return "Erro ao Setar o campo sDsComplemento"
		endif

		xRet := .T.
		nPos := aScan( aSimple, {|x| x[2] == "sDsEndereco" .AND. x[5] == cMetodo + "#1." + cDTO + "#1.PedidoDTO#1.lstPedidoItem#1.PedidoItemDTO#" + cI +".lstPedidoItemEntrega#1.PedidoItemEntregaDTO#1.oEntregaEndereco#1"} )
		if nPos > 0 .AND. ValType(oPedido['endereco']['entrega']['endereco']) <> "U"
			xRet := oWsdl:SetValue( aSimple[nPos][1], oPedido['endereco']['entrega']['endereco'])
		endif
		if xRet == .F.
			xRet := oWsdl:cError
			Return "Erro ao Setar o campo sDsEndereco"
		endif

		xRet := .T.
		nPos := aScan( aSimple, {|x| x[2] == "sNmBairro" .AND. x[5] == cMetodo + "#1." + cDTO + "#1.PedidoDTO#1.lstPedidoItem#1.PedidoItemDTO#" + cI +".lstPedidoItemEntrega#1.PedidoItemEntregaDTO#1.oEntregaEndereco#1"} )
		if nPos > 0 .AND. ValType(oPedido['endereco']['entrega']['bairro']) <> "U"
			xRet := oWsdl:SetValue( aSimple[nPos][1], oPedido['endereco']['entrega']['bairro'])
		endif
		if xRet == .F.
			xRet := oWsdl:cError
			Return "Erro ao Setar o campo sNmBairro"
		endif

		xRet := .T.
		nPos := aScan( aSimple, {|x| x[2] == "sNmCidade" .AND. x[5] == cMetodo + "#1." + cDTO + "#1.PedidoDTO#1.lstPedidoItem#1.PedidoItemDTO#" + cI +".lstPedidoItemEntrega#1.PedidoItemEntregaDTO#1.oEntregaEndereco#1"} )
		if nPos > 0 .AND. ValType(oPedido['endereco']['entrega']['cidade']) <> "U"
			xRet := oWsdl:SetValue( aSimple[nPos][1], oPedido['endereco']['entrega']['cidade'])
		endif
		if xRet == .F.
			xRet := oWsdl:cError
			Return "Erro ao Setar o campo sNmCidade"
		endif

		xRet := .T.
		nPos := aScan( aSimple, {|x| x[2] == "sNrEndereco" .AND. x[5] == cMetodo + "#1." + cDTO + "#1.PedidoDTO#1.lstPedidoItem#1.PedidoItemDTO#" + cI +".lstPedidoItemEntrega#1.PedidoItemEntregaDTO#1.oEntregaEndereco#1"} )
		if nPos > 0 .AND. ValType(oPedido['endereco']['entrega']['numero']) <> "U"
			xRet := oWsdl:SetValue( aSimple[nPos][1], oPedido['endereco']['entrega']['numero'])
		endif
		if xRet == .F.
			xRet := oWsdl:cError
			Return "Erro ao Setar o campo sNrEndereco"
		endif

		xRet := .T.
		nPos := aScan( aSimple, {|x| x[2] == "sSgEstado" .AND. x[5] == cMetodo + "#1." + cDTO + "#1.PedidoDTO#1.lstPedidoItem#1.PedidoItemDTO#" + cI +".lstPedidoItemEntrega#1.PedidoItemEntregaDTO#1.oEntregaEndereco#1"} )
		if nPos > 0 .AND. ValType(oPedido['endereco']['entrega']['uf']) <> "U"
			xRet := oWsdl:SetValue( aSimple[nPos][1], oPedido['endereco']['entrega']['uf'])
		endif
		if xRet == .F.
			xRet := oWsdl:cError
			Return "Erro ao Setar o campo sSgEstado"
		endif

		xRet := .T.
		nPos := aScan( aSimple, {|x| x[2] == "sSgPais" .AND. x[5] == cMetodo + "#1." + cDTO + "#1.PedidoDTO#1.lstPedidoItem#1.PedidoItemDTO#" + cI +".lstPedidoItemEntrega#1.PedidoItemEntregaDTO#1.oEntregaEndereco#1"} )
		if nPos > 0 .AND. ValType(oPedido['endereco']['entrega']['pais']) <> "U"
			xRet := oWsdl:SetValue( aSimple[nPos][1], oPedido['endereco']['entrega']['pais'])
		endif
		if xRet == .F.
			xRet := oWsdl:cError
			Return "Erro ao Setar o campo sSgPais"
		endif*/

//Endereço de Faturamento ----------------------------------------------------------------------------------------------
		/*xRet := .T.
		nPos := aScan( aSimple, {|x| x[2] == "sCdCep" .AND. x[5] == cMetodo + "#1." + cDTO + "#1.PedidoDTO#1.lstPedidoItem#1.PedidoItemDTO#" + cI +".lstPedidoItemEntrega#1.PedidoItemEntregaDTO#1.oFaturamentoEndereco#1"} )
		if nPos > 0 .AND. ValType(oPedido['endereco']['faturamento']['cep']) <> "U"
			xRet := oWsdl:SetValue( aSimple[nPos][1], oPedido['endereco']['faturamento']['cep'])
		endif
		if xRet == .F.
			xRet := oWsdl:cError
			Return "Erro ao Setar o campo sCdCep"
		endif

		xRet := .T.
		nPos := aScan( aSimple, {|x| x[2] == "sDsComplemento" .AND. x[5] == cMetodo + "#1." + cDTO + "#1.PedidoDTO#1.lstPedidoItem#1.PedidoItemDTO#" + cI +".lstPedidoItemEntrega#1.PedidoItemEntregaDTO#1.oFaturamentoEndereco#1"} )
		if nPos > 0 .AND. ValType(oPedido['endereco']['faturamento']['complemento']) <> "U"
			xRet := oWsdl:SetValue( aSimple[nPos][1], oPedido['endereco']['faturamento']['complemento'])
		endif
		if xRet == .F.
			xRet := oWsdl:cError
			Return "Erro ao Setar o campo sDsComplemento"
		endif

		xRet := .T.
		nPos := aScan( aSimple, {|x| x[2] == "sDsEndereco" .AND. x[5] == cMetodo + "#1." + cDTO + "#1.PedidoDTO#1.lstPedidoItem#1.PedidoItemDTO#" + cI +".lstPedidoItemEntrega#1.PedidoItemEntregaDTO#1.oFaturamentoEndereco#1"} )
		if nPos > 0 .AND. ValType(oPedido['endereco']['faturamento']['endereco']) <> "U"
			xRet := oWsdl:SetValue( aSimple[nPos][1], oPedido['endereco']['faturamento']['endereco'])
		endif
		if xRet == .F.
			xRet := oWsdl:cError
			Return "Erro ao Setar o campo sDsEndereco"
		endif

		xRet := .T.
		nPos := aScan( aSimple, {|x| x[2] == "sNmBairro" .AND. x[5] == cMetodo + "#1." + cDTO + "#1.PedidoDTO#1.lstPedidoItem#1.PedidoItemDTO#" + cI +".lstPedidoItemEntrega#1.PedidoItemEntregaDTO#1.oFaturamentoEndereco#1"} )
		if nPos > 0 .AND. ValType(oPedido['endereco']['faturamento']['bairro']) <> "U"
			xRet := oWsdl:SetValue( aSimple[nPos][1], oPedido['endereco']['faturamento']['bairro'])
		endif
		if xRet == .F.
			xRet := oWsdl:cError
			Return "Erro ao Setar o campo sNmBairro"
		endif

		xRet := .T.
		nPos := aScan( aSimple, {|x| x[2] == "sNmCidade" .AND. x[5] == cMetodo + "#1." + cDTO + "#1.PedidoDTO#1.lstPedidoItem#1.PedidoItemDTO#" + cI +".lstPedidoItemEntrega#1.PedidoItemEntregaDTO#1.oFaturamentoEndereco#1"} )
		if nPos > 0 .AND. ValType(oPedido['endereco']['faturamento']['cidade']) <> "U"
			xRet := oWsdl:SetValue( aSimple[nPos][1], oPedido['endereco']['faturamento']['cidade'])
		endif
		if xRet == .F.
			xRet := oWsdl:cError
			Return "Erro ao Setar o campo sNmCidade"
		endif

		xRet := .T.
		nPos := aScan( aSimple, {|x| x[2] == "sNrEndereco" .AND. x[5] == cMetodo + "#1." + cDTO + "#1.PedidoDTO#1.lstPedidoItem#1.PedidoItemDTO#" + cI +".lstPedidoItemEntrega#1.PedidoItemEntregaDTO#1.oFaturamentoEndereco#1"} )
		if nPos > 0 .AND. ValType(oPedido['endereco']['faturamento']['numero']) <> "U"
			xRet := oWsdl:SetValue( aSimple[nPos][1], oPedido['endereco']['faturamento']['numero'])
		endif
		if xRet == .F.
			xRet := oWsdl:cError
			Return "Erro ao Setar o campo sNrEndereco"
		endif

		xRet := .T.
		nPos := aScan( aSimple, {|x| x[2] == "sSgEstado" .AND. x[5] == cMetodo + "#1." + cDTO + "#1.PedidoDTO#1.lstPedidoItem#1.PedidoItemDTO#" + cI +".lstPedidoItemEntrega#1.PedidoItemEntregaDTO#1.oFaturamentoEndereco#1"} )
		if nPos > 0 .AND. ValType(oPedido['endereco']['faturamento']['uf']) <> "U"
			xRet := oWsdl:SetValue( aSimple[nPos][1], oPedido['endereco']['faturamento']['uf'])
		endif
		if xRet == .F.
			xRet := oWsdl:cError
			Return "Erro ao Setar o campo sSgEstado"
		endif

		xRet := .T.
		nPos := aScan( aSimple, {|x| x[2] == "sSgPais" .AND. x[5] == cMetodo + "#1." + cDTO + "#1.PedidoDTO#1.lstPedidoItem#1.PedidoItemDTO#" + cI +".lstPedidoItemEntrega#1.PedidoItemEntregaDTO#1.oFaturamentoEndereco#1"} )
		if nPos > 0 .AND. ValType(oPedido['endereco']['faturamento']['pais']) <> "U"
			xRet := oWsdl:SetValue( aSimple[nPos][1], oPedido['endereco']['faturamento']['pais'])
		endif
		if xRet == .F.
			xRet := oWsdl:cError
			Return "Erro ao Setar o campo sSgPais"
		endif

		xRet := .T.
		nPos := aScan( aSimple, {|x| x[2] == "sCdAlmoxarifado" .AND. x[5] == cMetodo + "#1." + cDTO + "#1.PedidoDTO#1.lstPedidoItem#1.PedidoItemDTO#" + cI +".lstPedidoItemEntrega#1.PedidoItemEntregaDTO#1"} )
		if nPos > 0 .AND. ValType(oItem['sCdAlmoxarifado']) <> "U"
			xRet := oWsdl:SetValue( aSimple[nPos][1], oItem['sCdAlmoxarifado'])
		endif
		if xRet == .F.
			xRet := oWsdl:cError
			Return "Erro ao Setar o campo sCdAlmoxarifado"
		endif

		xRet := .T.
		nPos := aScan( aSimple, {|x| x[2] == "sCdAlmoxarifadoDoca" .AND. x[5] == cMetodo + "#1." + cDTO + "#1.PedidoDTO#1.lstPedidoItem#1.PedidoItemDTO#" + cI +".lstPedidoItemEntrega#1.PedidoItemEntregaDTO#1"} )
		if nPos > 0 .AND. ValType(oItem['sCdAlmoxarifadoDoca']) <> "U"
			xRet := oWsdl:SetValue( aSimple[nPos][1], oItem['sCdAlmoxarifadoDoca'])
		endif
		if xRet == .F.
			xRet := oWsdl:cError
			Return "Erro ao Setar o campo sCdAlmoxarifadoDoca"
		endif

		xRet := .T.
		nPos := aScan( aSimple, {|x| x[2] == "sCdCentroCustoRequisicao" .AND. x[5] == cMetodo + "#1." + cDTO + "#1.PedidoDTO#1.lstPedidoItem#1.PedidoItemDTO#" + cI +".lstPedidoItemEntrega#1.PedidoItemEntregaDTO#1"} )
		if nPos > 0 .AND. ValType(oItem['sCdCentroCustoRequisicao']) <> "U"
			xRet := oWsdl:SetValue( aSimple[nPos][1], oItem['sCdCentroCustoRequisicao'])
		endif
		if xRet == .F.
			xRet := oWsdl:cError
			Return "Erro ao Setar o campo sCdCentroCustoRequisicao"
		endif

		xRet := .T.
		nPos := aScan( aSimple, {|x| x[2] == "sCdCobrancaEndereco" .AND. x[5] == cMetodo + "#1." + cDTO + "#1.PedidoDTO#1.lstPedidoItem#1.PedidoItemDTO#" + cI +".lstPedidoItemEntrega#1.PedidoItemEntregaDTO#1"} )
		if nPos > 0 .AND. ValType(oItem['sCdCobrancaEndereco']) <> "U"
			xRet := oWsdl:SetValue( aSimple[nPos][1], oItem['sCdCobrancaEndereco'])
		endif
		if xRet == .F.
			xRet := oWsdl:cError
			Return "Erro ao Setar o campo sCdCobrancaEndereco"
		endif
*/
// Codigo de cliente para os endereços de cobrança/entrega/faturamento
		xRet := .T.
		nPos := aScan( aSimple, {|x| x[2] == "sCdEmpresaCobrancaEndereco" .AND. x[5] == cMetodo + "#1." + cDTO + "#1.PedidoDTO#1.lstPedidoItem#1.PedidoItemDTO#" + cI +".lstPedidoItemEntrega#1.PedidoItemEntregaDTO#1"} )
		if nPos > 0 .AND. ValType(oItem['sCdEmpresaCobrancaEndereco']) <> "U"
			xRet := oWsdl:SetValue( aSimple[nPos][1], oItem['sCdEmpresaCobrancaEndereco'])
		endif
		if xRet == .F.
			xRet := oWsdl:cError
			Return "Erro ao Setar o campo sCdEmpresaCobrancaEndereco"
		endif

		xRet := .T.
		nPos := aScan( aSimple, {|x| x[2] == "sCdEmpresaEntregaEndereco" .AND. x[5] == cMetodo + "#1." + cDTO + "#1.PedidoDTO#1.lstPedidoItem#1.PedidoItemDTO#" + cI +".lstPedidoItemEntrega#1.PedidoItemEntregaDTO#1"} )
		if nPos > 0 .AND. ValType(oItem['sCdEmpresaEntregaEndereco']) <> "U"
			xRet := oWsdl:SetValue( aSimple[nPos][1], oItem['sCdEmpresaEntregaEndereco'])
		endif
		if xRet == .F.
			xRet := oWsdl:cError
			Return "Erro ao Setar o campo sCdEmpresaEntregaEndereco"
		endif

		xRet := .T.
		nPos := aScan( aSimple, {|x| x[2] == "sCdEmpresaFaturamentoEndereco" .AND. x[5] == cMetodo + "#1." + cDTO + "#1.PedidoDTO#1.lstPedidoItem#1.PedidoItemDTO#" + cI +".lstPedidoItemEntrega#1.PedidoItemEntregaDTO#1"} )
		if nPos > 0 .AND. ValType(oItem['sCdEmpresaFaturamentoEndereco']) <> "U"
			xRet := oWsdl:SetValue( aSimple[nPos][1], oItem['sCdEmpresaFaturamentoEndereco'])
		endif
		if xRet == .F.
			xRet := oWsdl:cError
			Return "Erro ao Setar o campo sCdEmpresaFaturamentoEndereco"
		endif

		/*xRet := .T.
		nPos := aScan( aSimple, {|x| x[2] == "sCdEntregaEndereco" .AND. x[5] == cMetodo + "#1." + cDTO + "#1.PedidoDTO#1.lstPedidoItem#1.PedidoItemDTO#" + cI +".lstPedidoItemEntrega#1.PedidoItemEntregaDTO#1"} )
		if nPos > 0 .AND. ValType(oItem['sCdEntregaEndereco']) <> "U"
			xRet := oWsdl:SetValue( aSimple[nPos][1], oItem['sCdEntregaEndereco'])
		endif
		if xRet == .F.
			xRet := oWsdl:cError
			Return "Erro ao Setar o campo sCdEntregaEndereco"
		endif

		xRet := .T.
		nPos := aScan( aSimple, {|x| x[2] == "sCdFaturamentoEndereco" .AND. x[5] == cMetodo + "#1." + cDTO + "#1.PedidoDTO#1.lstPedidoItem#1.PedidoItemDTO#" + cI +".lstPedidoItemEntrega#1.PedidoItemEntregaDTO#1"} )
		if nPos > 0 .AND. ValType(oItem['sCdFaturamentoEndereco']) <> "U"
			xRet := oWsdl:SetValue( aSimple[nPos][1], oItem['sCdFaturamentoEndereco'])
		endif
		if xRet == .F.
			xRet := oWsdl:cError
			Return "Erro ao Setar o campo sCdFaturamentoEndereco"
		endif

		xRet := .T.
		nPos := aScan( aSimple, {|x| x[2] == "sCdItemEntregaEmpresa" .AND. x[5] == cMetodo + "#1." + cDTO + "#1.PedidoDTO#1.lstPedidoItem#1.PedidoItemDTO#" + cI +".lstPedidoItemEntrega#1.PedidoItemEntregaDTO#1"} )
		if nPos > 0 .AND. ValType(oItem['sCdItemEntregaEmpresa']) <> "U"
			xRet := oWsdl:SetValue( aSimple[nPos][1], oItem['sCdItemEntregaEmpresa'])
		endif
		if xRet == .F.
			xRet := oWsdl:cError
			Return "Erro ao Setar o campo sCdItemEntregaEmpresa"
		endif
*/
		xRet := .T.
		nPos := aScan( aSimple, {|x| x[2] == "sCdItemRequisicaoEmpresa" .AND. x[5] == cMetodo + "#1." + cDTO + "#1.PedidoDTO#1.lstPedidoItem#1.PedidoItemDTO#" + cI +".lstPedidoItemEntrega#1.PedidoItemEntregaDTO#1"} )
		if nPos > 0 .AND. ValType(oItem['sCdItemRequisicaoEmpresa']) <> "U"
			xRet := oWsdl:SetValue( aSimple[nPos][1], oItem['sCdItemRequisicaoEmpresa'])
		endif
		if xRet == .F.
			xRet := oWsdl:cError
			Return "Erro ao Setar o campo sCdItemRequisicaoEmpresa"
		endif

		xRet := .T.
		nPos := aScan( aSimple, {|x| x[2] == "sCdRequisicaoEmpresa" .AND. x[5] == cMetodo + "#1." + cDTO + "#1.PedidoDTO#1.lstPedidoItem#1.PedidoItemDTO#" + cI +".lstPedidoItemEntrega#1.PedidoItemEntregaDTO#1"} )
		if nPos > 0 .AND. ValType(oItem['sCdRequisicaoEmpresa']) <> "U"
			//xRet := oWsdl:SetValue( aSimple[nPos][1], ALLTRIM(oItem['sCdRequisicaoEmpresa']))
			IF eMPTY(oItem['sCdRequisicaoEmpresa'])
				xRet := oWsdl:SetValue( aSimple[nPos][1], oItem['sCdRequisicaoEmpresa'])
			ELSE
				xRet := oWsdl:SetValue( aSimple[nPos][1], ALLTRIM(oItem['sCdRequisicaoEmpresa']))
			ENDIF
		endif
		if xRet == .F.
			xRet := oWsdl:cError
			Return "Erro ao Setar o campo sCdRequisicaoEmpresa"
		endif
//Fim Endereços -------------------------------------------------------------------------------------------------------
		xRet := .T.
		nPos := aScan( aSimple, {|x| x[2] == "sCdUnidadeFornecimento" .AND. x[5] == cMetodo + "#1." + cDTO + "#1.PedidoDTO#1.lstPedidoItem#1.PedidoItemDTO#" + cI +".lstPedidoItemEntrega#1.PedidoItemEntregaDTO#1"} )
		if nPos > 0 .AND. ValType(oItem['sCdUnidadeFornecimento']) <> "U"
			xRet := oWsdl:SetValue( aSimple[nPos][1], oItem['sCdUnidadeFornecimento'])
		endif
		if xRet == .F.
			xRet := oWsdl:cError
			Return "Erro ao Setar o campo sCdUnidadeFornecimento"
		endif

		xRet := .T.
		nPos := aScan( aSimple, {|x| x[2] == "sCdUsuarioAlteracao" .AND. x[5] == cMetodo + "#1." + cDTO + "#1.PedidoDTO#1.lstPedidoItem#1.PedidoItemDTO#" + cI +".lstPedidoItemEntrega#1.PedidoItemEntregaDTO#1"} )
		if nPos > 0 .AND. ValType(oItem['sCdUsuarioAlteracao']) <> "U"
			xRet := oWsdl:SetValue( aSimple[nPos][1], oItem['sCdUsuarioAlteracao'])
		endif
		if xRet == .F.
			xRet := oWsdl:cError
			Return "Erro ao Setar o campo sCdUsuarioAlteracao"
		endif

		xRet := .T.
		nPos := aScan( aSimple, {|x| x[2] == "sCdUsuarioAprovador" .AND. x[5] == cMetodo + "#1." + cDTO + "#1.PedidoDTO#1.lstPedidoItem#1.PedidoItemDTO#" + cI +".lstPedidoItemEntrega#1.PedidoItemEntregaDTO#1"} )
		if nPos > 0 .AND. ValType(oItem['sCdUsuarioAprovador']) <> "U"
			xRet := oWsdl:SetValue( aSimple[nPos][1], oItem['sCdUsuarioAprovador'])
		endif
		if xRet == .F.
			xRet := oWsdl:cError
			Return "Erro ao Setar o campo sCdUsuarioAprovador"
		endif

		xRet := .T.
		nPos := aScan( aSimple, {|x| x[2] == "sDsAprovacao" .AND. x[5] == cMetodo + "#1." + cDTO + "#1.PedidoDTO#1.lstPedidoItem#1.PedidoItemDTO#" + cI +".lstPedidoItemEntrega#1.PedidoItemEntregaDTO#1"} )
		if nPos > 0 .AND. ValType(oItem['sDsAprovacao']) <> "U"
			xRet := oWsdl:SetValue( aSimple[nPos][1], oItem['sDsAprovacao'])
		endif
		if xRet == .F.
			xRet := oWsdl:cError
			Return "Erro ao Setar o campo sDsAprovacao"
		endif

		xRet := .T.
		nPos := aScan( aSimple, {|x| x[2] == "sDsCancelamento" .AND. x[5] == cMetodo + "#1." + cDTO + "#1.PedidoDTO#1.lstPedidoItem#1.PedidoItemDTO#" + cI +".lstPedidoItemEntrega#1.PedidoItemEntregaDTO#1"} )
		if nPos > 0 .AND. ValType(oItem['sDsCancelamento']) <> "U"
			xRet := oWsdl:SetValue( aSimple[nPos][1], oItem['sDsCancelamento'])
		endif
		if xRet == .F.
			xRet := oWsdl:cError
			Return "Erro ao Setar o campo sDsCancelamento"
		endif

		xRet := .T.
		nPos := aScan( aSimple, {|x| x[2] == "sDsReprovacao" .AND. x[5] == cMetodo + "#1." + cDTO + "#1.PedidoDTO#1.lstPedidoItem#1.PedidoItemDTO#" + cI +".lstPedidoItemEntrega#1.PedidoItemEntregaDTO#1"} )
		if nPos > 0 .AND. ValType(oItem['sDsReprovacao']) <> "U"
			xRet := oWsdl:SetValue( aSimple[nPos][1], oItem['sDsReprovacao'])
		endif
		if xRet == .F.
			xRet := oWsdl:cError
			Return "Erro ao Setar o campo sDsReprovacao"
		endif

		xRet := .T.
		nPos := aScan( aSimple, {|x| x[2] == "sDsSolicitacaoAlteracao" .AND. x[5] == cMetodo + "#1." + cDTO + "#1.PedidoDTO#1.lstPedidoItem#1.PedidoItemDTO#" + cI +".lstPedidoItemEntrega#1.PedidoItemEntregaDTO#1"} )
		if nPos > 0 .AND. ValType(oItem['sDsSolicitacaoAlteracao']) <> "U"
			xRet := oWsdl:SetValue( aSimple[nPos][1], oItem['sDsSolicitacaoAlteracao'])
		endif
		if xRet == .F.
			xRet := oWsdl:cError
			Return "Erro ao Setar o campo sDsSolicitacaoAlteracao"
		endif

		xRet := .T.
		nPos := aScan( aSimple, {|x| x[2] == "sNrNota" .AND. x[5] == cMetodo + "#1." + cDTO + "#1.PedidoDTO#1.lstPedidoItem#1.PedidoItemDTO#" + cI +".lstPedidoItemEntrega#1.PedidoItemEntregaDTO#1"} )
		if nPos > 0 .AND. ValType(oItem['sNrNota']) <> "U"
			xRet := oWsdl:SetValue( aSimple[nPos][1], oItem['sNrNota'])
		endif
		if xRet == .F.
			xRet := oWsdl:cError
			Return "Erro ao Setar o campo sNrNota"
		endif

		xRet := .T.
		nPos := aScan( aSimple, {|x| x[2] == "sNrRecebimento" .AND. x[5] == cMetodo + "#1." + cDTO + "#1.PedidoDTO#1.lstPedidoItem#1.PedidoItemDTO#" + cI +".lstPedidoItemEntrega#1.PedidoItemEntregaDTO#1"} )
		if nPos > 0 .AND. ValType(oItem['sNrRecebimento']) <> "U"
			xRet := oWsdl:SetValue( aSimple[nPos][1], oItem['sNrRecebimento'])
		endif
		if xRet == .F.
			xRet := oWsdl:cError
			Return "Erro ao Setar o campo sNrRecebimento"
		endif

		xRet := .T.
		nPos := aScan( aSimple, {|x| x[2] == "sNrSerie" .AND. x[5] == cMetodo + "#1." + cDTO + "#1.PedidoDTO#1.lstPedidoItem#1.PedidoItemDTO#" + cI +".lstPedidoItemEntrega#1.PedidoItemEntregaDTO#1"} )
		if nPos > 0 .AND. ValType(oItem['sNrSerie']) <> "U"
			xRet := oWsdl:SetValue( aSimple[nPos][1], oItem['sNrSerie'])
		endif
		if xRet == .F.
			xRet := oWsdl:cError
			Return "Erro ao Setar o campo sNrSerie"
		endif

		xRet := .T.
		nPos := aScan( aSimple, {|x| x[2] == "tDtColeta" .AND. x[5] == cMetodo + "#1." + cDTO + "#1.PedidoDTO#1.lstPedidoItem#1.PedidoItemDTO#" + cI +".lstPedidoItemEntrega#1.PedidoItemEntregaDTO#1"} )
		if nPos > 0 .AND. ValType(oItem['tDtColeta']) <> "U"
			xRet := oWsdl:SetValue( aSimple[nPos][1], oItem['tDtColeta'])
		endif
		if xRet == .F.
			xRet := oWsdl:cError
			Return "Erro ao Setar o campo tDtColeta"
		endif

		xRet := .T.
		nPos := aScan( aSimple, {|x| x[2] == "tDtEntrega" .AND. x[5] == cMetodo + "#1." + cDTO + "#1.PedidoDTO#1.lstPedidoItem#1.PedidoItemDTO#" + cI +".lstPedidoItemEntrega#1.PedidoItemEntregaDTO#1"} )
		if nPos > 0 .AND. ValType(oItem['tDtEntrega']) <> "U"
			xRet := oWsdl:SetValue( aSimple[nPos][1], oItem['tDtEntrega'])
		endif
		if xRet == .F.
			xRet := oWsdl:cError
			Return "Erro ao Setar o campo tDtEntrega"
		endif
/*
		xRet := .T.
		nPos := aScan( aSimple, {|x| x[2] == "tDtEntregaConfirmada" .AND. x[5] == cMetodo + "#1." + cDTO + "#1.PedidoDTO#1.lstPedidoItem#1.PedidoItemDTO#" + cI +".lstPedidoItemEntrega#1.PedidoItemEntregaDTO#1"} )
		if nPos > 0 .AND. ValType(oItem['tDtEntregaConfirmada']) <> "U"
			xRet := oWsdl:SetValue( aSimple[nPos][1], oItem['tDtEntregaConfirmada'])
		endif
		if xRet == .F.
			xRet := oWsdl:cError
			Return "Erro ao Setar o campo tDtEntregaConfirmada"
		endif

/*/		xRet := .T.
		nPos := aScan( aSimple, {|x| x[2] == "tDtFornecimento" .AND. x[5] == cMetodo + "#1." + cDTO + "#1.PedidoDTO#1.lstPedidoItem#1.PedidoItemDTO#" + cI +".lstPedidoItemEntrega#1.PedidoItemEntregaDTO#1"} )
		if nPos > 0 .AND. ValType(oItem['tDtFornecimento']) <> "U"
			xRet := oWsdl:SetValue( aSimple[nPos][1], oItem['tDtFornecimento'])
		endif
		if xRet == .F.
			xRet := oWsdl:cError
			Return "Erro ao Setar o campo tDtFornecimento"
		endif

		xRet := .T.
		nPos := aScan( aSimple, {|x| x[2] == "tDtSolicitacaoEntrega" .AND. x[5] == cMetodo + "#1." + cDTO + "#1.PedidoDTO#1.lstPedidoItem#1.PedidoItemDTO#" + cI +".lstPedidoItemEntrega#1.PedidoItemEntregaDTO#1"} )
		if nPos > 0 .AND. ValType(oItem['tDtSolicitacaoEntrega']) <> "U"
			xRet := oWsdl:SetValue( aSimple[nPos][1], oItem['tDtSolicitacaoEntrega'])
		endif
		if xRet == .F.
			xRet := oWsdl:cError
			Return "Erro ao Setar o campo tDtSolicitacaoEntrega"
		endif
		
        
//Item Rateio -------------------------------------------------------------------------------------------------------------
	/*
		oRateio := oItem['Rateio']
		For nE := 1 to Len(oRateio)
			xRet := .T.
			nPos := aScan( aSimple, {|x| x[2] == "dPcRateio" .AND. x[5] == cMetodo + "#1." + cDTO + "#1.PedidoDTO#1.lstPedidoItem#1.PedidoItemDTO#" + cI +".lstPedidoItemRateio#1.PedidoItemRateioDTO#1"} )
			if nPos > 0 .AND. ValType(oRateio[nE]['dPcRateio']) <> "U"
				xRet := oWsdl:SetValue( aSimple[nPos][1], oRateio[nE]['dPcRateio'])
			endif
			if xRet == .F.
				xRet := oWsdl:cError
				Return "Erro ao Setar o campo bFlIncluso"
			endif
	
			xRet := .T.
			nPos := aScan( aSimple, {|x| x[2] == "sCdCentroCusto" .AND. x[5] == cMetodo + "#1." + cDTO + "#1.PedidoDTO#1.lstPedidoItem#1.PedidoItemDTO#" + cI +".lstPedidoItemRateio#1.PedidoItemRateioDTO#1"} )
			if nPos > 0 .AND. ValType(oRateio[nE]['sCdCentroCusto']) <> "U"
				xRet := oWsdl:SetValue( aSimple[nPos][1], oRateio[nE]['sCdCentroCusto'])
			endif
			if xRet == .F.
				xRet := oWsdl:cError
				Return "Erro ao Setar o campo dPcTaxa"
			endif
		Next nE  */
//Fim Rateio -------------------------------------------------------------------------------------------------------------			
//Item Taxa -------------------------------------------------------------------------------------------------------------
		oTaxas := oItem['taxas']

		
		For nE := 1 to Len(oTaxas)
			cE := AllTrim(STR(nE))
			xRet := .T.
			nPos := aScan( aSimple, {|x| x[2] == "bFlIncluso" .AND. x[5] == cMetodo + "#1." + cDTO + "#1.PedidoDTO#1.lstPedidoItem#1.PedidoItemDTO#" + cI +".lstPedidoItemTaxa#1.PedidoItemTaxaDTO#" + cE} )
			if nPos > 0 .AND. ValType(oTaxas[nE]['bFlIncluso']) <> "U"
				xRet := oWsdl:SetValue( aSimple[nPos][1], oTaxas[nE]['bFlIncluso'])
			endif
			if xRet == .F.
				xRet := oWsdl:cError
				Return "Erro ao Setar o campo bFlIncluso"
			endif
	
			xRet := .T.
			nPos := aScan( aSimple, {|x| x[2] == "dPcTaxa" .AND. x[5] == cMetodo + "#1." + cDTO + "#1.PedidoDTO#1.lstPedidoItem#1.PedidoItemDTO#" + cI +".lstPedidoItemTaxa#1.PedidoItemTaxaDTO#" + cE} )
			if nPos > 0 .AND. ValType(oTaxas[nE]['dPcTaxa']) <> "U"
				xRet := oWsdl:SetValue( aSimple[nPos][1], oTaxas[nE]['dPcTaxa'])
			endif
			if xRet == .F.
				xRet := oWsdl:cError
				Return "Erro ao Setar o campo dPcTaxa"
			endif
	
			xRet := .T.
			nPos := aScan( aSimple, {|x| x[2] == "nCdTaxa" .AND. x[5] == cMetodo + "#1." + cDTO + "#1.PedidoDTO#1.lstPedidoItem#1.PedidoItemDTO#" + cI +".lstPedidoItemTaxa#1.PedidoItemTaxaDTO#" + cE} )
			if nPos > 0 .AND. ValType(oTaxas[nE]['nCdTaxa']) <> "U"
				xRet := oWsdl:SetValue( aSimple[nPos][1], oTaxas[nE]['nCdTaxa'])
			endif
			if xRet == .F.
				xRet := oWsdl:cError
				Return "Erro ao Setar o campo nCdTaxa"
			endif
		Next nE 
//Fim Ta8xa -------------------------------------------------------------------------------------------------------------		
		
		xRet := .T.
		nPos := aScan( aSimple, {|x| x[2] == "nCdPedidoItem" .AND. x[5] == cMetodo + "#1." + cDTO + "#1.PedidoDTO#1.lstPedidoItem#1.PedidoItemDTO#" + cI} )
		if nPos > 0 .AND. ValType(oItem['nCdPedidoItem']) <> "U"
			xRet := oWsdl:SetValue( aSimple[nPos][1], oItem['nCdPedidoItem'])
		endif
		if xRet == .F.
			xRet := oWsdl:cError
			Return "Erro ao Setar o campo nCdPedidoItem"
		endif
			
			
		xRet := .T.
		nPos := aScan( aSimple, {|x| x[2] == "nCdSituacao" .AND. x[5] == cMetodo + "#1." + cDTO + "#1.PedidoDTO#1.lstPedidoItem#1.PedidoItemDTO#" + cI} )
		if nPos > 0 .AND. ValType(oItem['nCdSituacao']) <> "U"
			xRet := oWsdl:SetValue( aSimple[nPos][1], oItem['nCdSituacao'])
		endif
		if xRet == .F.
			xRet := oWsdl:cError
			Return "Erro ao Setar o campo nCdSituacao"
		endif

		xRet := .T.
		nPos := aScan( aSimple, {|x| x[2] == "sCdClasse" .AND. x[5] == cMetodo + "#1." + cDTO + "#1.PedidoDTO#1.lstPedidoItem#1.PedidoItemDTO#" + cI} )
		if nPos > 0 .AND. ValType(oItem['sCdClasse']) <> "U"
			xRet := oWsdl:SetValue( aSimple[nPos][1], oItem['sCdClasse'])
		endif
		if xRet == .F.
			xRet := oWsdl:cError
			Return "Erro ao Setar o campo sCdClasse"
		endif

		xRet := .T.
		nPos := aScan( aSimple, {|x| x[2] == "sCdEmpresa" .AND. x[5] == cMetodo + "#1." + cDTO + "#1.PedidoDTO#1.lstPedidoItem#1.PedidoItemDTO#" + cI} )
		if nPos > 0 .AND. ValType(oItem['sCdEmpresa']) <> "U"
			xRet := oWsdl:SetValue( aSimple[nPos][1], oItem['sCdEmpresa'])
		endif
		if xRet == .F.
			xRet := oWsdl:cError
			Return "Erro ao Setar o campo sCdEmpresa"
		endif

		xRet := .T.
		nPos := aScan( aSimple, {|x| x[2] == "sCdItemEmpresa" .AND. x[5] == cMetodo + "#1." + cDTO + "#1.PedidoDTO#1.lstPedidoItem#1.PedidoItemDTO#" + cI} )
		if nPos > 0 .AND. ValType(oItem['sCdItemEmpresa']) <> "U"
			xRet := oWsdl:SetValue( aSimple[nPos][1], oItem['sCdItemEmpresa'])
		endif
		if xRet == .F.
			xRet := oWsdl:cError
			Return "Erro ao Setar o campo sCdItemEmpresa"
		endif

		xRet := .T.
		nPos := aScan( aSimple, {|x| x[2] == "sCdItemOrigemEmpresa" .AND. x[5] == cMetodo + "#1." + cDTO + "#1.PedidoDTO#1.lstPedidoItem#1.PedidoItemDTO#" + cI} )
		if nPos > 0 .AND. ValType(oItem['sCdItemOrigemEmpresa']) <> "U"
			xRet := oWsdl:SetValue( aSimple[nPos][1], oItem['sCdItemOrigemEmpresa'])
		endif
		if xRet == .F.
			xRet := oWsdl:cError
			Return "Erro ao Setar o campo sCdItemOrigemEmpresa"
		endif

		xRet := .T.
		nPos := aScan( aSimple, {|x| x[2] == "sCdItemWbc" .AND. x[5] == cMetodo + "#1." + cDTO + "#1.PedidoDTO#1.lstPedidoItem#1.PedidoItemDTO#" + cI} )
		if nPos > 0 .AND. ValType(oItem['sCdItemWbc']) <> "U"
			xRet := oWsdl:SetValue( aSimple[nPos][1], oItem['sCdItemWbc'])
		endif
		if xRet == .F.
			xRet := oWsdl:cError
			Return "Erro ao Setar o campo sCdItemWbc"
		endif

		xRet := .T.
		nPos := aScan( aSimple, {|x| x[2] == "sCdIva" .AND. x[5] == cMetodo + "#1." + cDTO + "#1.PedidoDTO#1.lstPedidoItem#1.PedidoItemDTO#" + cI} )
		if nPos > 0 .AND. ValType(oItem['sCdIva']) <> "U"
			xRet := oWsdl:SetValue( aSimple[nPos][1], oItem['sCdIva'])
		endif
		if xRet == .F.
			xRet := oWsdl:cError
			Return "Erro ao Setar o campo sCdIva"
		endif

		xRet := .T.
		nPos := aScan( aSimple, {|x| x[2] == "sCdMarca" .AND. x[5] == cMetodo + "#1." + cDTO + "#1.PedidoDTO#1.lstPedidoItem#1.PedidoItemDTO#" + cI} )
		if nPos > 0 .AND. ValType(oItem['sCdMarca']) <> "U"
			
			IF !Empty(oItem['sCdMarca'])
				xRet := oWsdl:SetValue( aSimple[nPos][1], oItem['sCdMarca'])
			endif

		endif
		if xRet == .F.
			xRet := oWsdl:cError
			Return "Erro ao Setar o campo sCdMarca. " + xRet
		endif

		xRet := .T.
		nPos := aScan( aSimple, {|x| x[2] == "sCdNbm" .AND. x[5] == cMetodo + "#1." + cDTO + "#1.PedidoDTO#1.lstPedidoItem#1.PedidoItemDTO#" + cI} )
		if nPos > 0 .AND. ValType(oItem['sCdNbm']) <> "U"
			xRet := oWsdl:SetValue( aSimple[nPos][1], oItem['sCdNbm'])
		endif
		if xRet == .F.
			xRet := oWsdl:cError
			Return "Erro ao Setar o campo sCdNbm"
		endif

		xRet := .T.
		nPos := aScan( aSimple, {|x| x[2] == "sCdOrigemEmpresa" .AND. x[5] == cMetodo + "#1." + cDTO + "#1.PedidoDTO#1.lstPedidoItem#1.PedidoItemDTO#" + cI} )
		if nPos > 0 .AND. ValType(oItem['sCdOrigemEmpresa']) <> "U"
			xRet := oWsdl:SetValue( aSimple[nPos][1], oItem['sCdOrigemEmpresa'])
		endif
		if xRet == .F.
			xRet := oWsdl:cError
			Return "Erro ao Setar o campo sCdOrigemEmpresa"
		endif

		xRet := .T.
		nPos := aScan( aSimple, {|x| x[2] == "sCdProduto" .AND. x[5] == cMetodo + "#1." + cDTO + "#1.PedidoDTO#1.lstPedidoItem#1.PedidoItemDTO#" + cI} )
		if nPos > 0 .AND. ValType(oItem['sCdProduto']) <> "U"
			xRet := oWsdl:SetValue( aSimple[nPos][1], oItem['sCdProduto'])
		endif
		if xRet == .F.
			xRet := oWsdl:cError
			Return "Erro ao Setar o campo sCdProduto"
		endif

		xRet := .T.
		nPos := aScan( aSimple, {|x| x[2] == "sCdProdutoFornecedor" .AND. x[5] == cMetodo + "#1." + cDTO + "#1.PedidoDTO#1.lstPedidoItem#1.PedidoItemDTO#" + cI} )
		if nPos > 0 .AND. ValType(oItem['sCdProdutoFornecedor']) <> "U"
			xRet := oWsdl:SetValue( aSimple[nPos][1], oItem['sCdProdutoFornecedor'])
		endif
		if xRet == .F.
			xRet := oWsdl:cError
			Return "Erro ao Setar o campo sCdProdutoFornecedor"
		endif

		xRet := .T.
		nPos := aScan( aSimple, {|x| x[2] == "sCdProjeto" .AND. x[5] == cMetodo + "#1." + cDTO + "#1.PedidoDTO#1.lstPedidoItem#1.PedidoItemDTO#" + cI} )
		if nPos > 0 .AND. ValType(oItem['sCdProjeto']) <> "U"
			xRet := oWsdl:SetValue( aSimple[nPos][1], oItem['sCdProjeto'])
		endif
		if xRet == .F.
			xRet := oWsdl:cError
			Return "Erro ao Setar o campo sCdProjeto"
		endif

		xRet := .T.
		nPos := aScan( aSimple, {|x| x[2] == "sCdUnidadeMedida" .AND. x[5] == cMetodo + "#1." + cDTO + "#1.PedidoDTO#1.lstPedidoItem#1.PedidoItemDTO#" + cI} )
		if nPos > 0 .AND. ValType(oItem['sCdUnidadeMedida']) <> "U"
			xRet := oWsdl:SetValue( aSimple[nPos][1], oItem['sCdUnidadeMedida'])
		endif
		if xRet == .F.
			xRet := oWsdl:cError
			Return "Erro ao Setar o campo sCdUnidadeMedida"
		endif

		xRet := .T.
		nPos := aScan( aSimple, {|x| x[2] == "sCdUsuarioResponsavel" .AND. x[5] == cMetodo + "#1." + cDTO + "#1.PedidoDTO#1.lstPedidoItem#1.PedidoItemDTO#" + cI} )
		if nPos > 0 .AND. ValType(oItem['sCdUsuarioResponsavel']) <> "U"
			xRet := oWsdl:SetValue( aSimple[nPos][1], oItem['sCdUsuarioResponsavel'])
		endif
		if xRet == .F.
			xRet := oWsdl:cError
			Return "Erro ao Setar o campo sCdUsuarioResponsavel"
		endif

		xRet := .T.
		nPos := aScan( aSimple, {|x| x[2] == "sDsItem" .AND. x[5] == cMetodo + "#1." + cDTO + "#1.PedidoDTO#1.lstPedidoItem#1.PedidoItemDTO#" + cI} )
		if nPos > 0 .AND. ValType(oItem['sDsItem']) <> "U"
			xRet := oWsdl:SetValue( aSimple[nPos][1], oItem['sDsItem'])
		endif
		if xRet == .F.
			xRet := oWsdl:cError
			Return "Erro ao Setar o campo sDsItem"
		endif

		xRet := .T.
		nPos := aScan( aSimple, {|x| x[2] == "sDsJustificativa" .AND. x[5] == cMetodo + "#1." + cDTO + "#1.PedidoDTO#1.lstPedidoItem#1.PedidoItemDTO#" + cI} )
		if nPos > 0 .AND. ValType(oItem['sDsJustificativa']) <> "U"
			xRet := oWsdl:SetValue( aSimple[nPos][1], oItem['sDsJustificativa'])
		endif
		if xRet == .F.
			xRet := oWsdl:cError
			Return "Erro ao Setar o campo sDsJustificativa"
		endif

		xRet := .T.
		nPos := aScan( aSimple, {|x| x[2] == "sDsObservacao" .AND. x[5] == cMetodo + "#1." + cDTO + "#1.PedidoDTO#1.lstPedidoItem#1.PedidoItemDTO#" + cI} )
		if nPos > 0 .AND. ValType(oItem['sDsObservacao']) <> "U"
			xRet := oWsdl:SetValue( aSimple[nPos][1], oItem['sDsObservacao'])
		endif
		if xRet == .F.
			xRet := oWsdl:cError
			Return "Erro ao Setar o campo sDsObservacao"
		endif

		xRet := .T.
		nPos := aScan( aSimple, {|x| x[2] == "sNrRecap" .AND. x[5] == cMetodo + "#1." + cDTO + "#1.PedidoDTO#1.lstPedidoItem#1.PedidoItemDTO#" + cI} )
		if nPos > 0 .AND. ValType(oItem['sNrRecap']) <> "U"
			xRet := oWsdl:SetValue( aSimple[nPos][1], oItem['sNrRecap'])
		endif
		if xRet == .F.
			xRet := oWsdl:cError
			Return "Erro ao Setar o campo sNrRecap"
		endif
	Next nI
	
	xRet := .T.
	nPos := aScan( aSimple, {|x| x[2] == "nCdPedido" .AND. x[5] == cMetodo + "#1." + cDTO + "#1.PedidoDTO#1"} )
	if nPos > 0 .AND. ValType(oPedido['nCdPedido']) <> "U"
		xRet := oWsdl:SetValue( aSimple[nPos][1], oPedido['nCdPedido'])
	endif
	if xRet == .F.
		xRet := oWsdl:cError
		Return "Erro ao Setar o campo nCdPedido"
	endif

	xRet := .T.
	nPos := aScan( aSimple, {|x| x[2] == "nCdSituacao" .AND. x[5] == cMetodo + "#1." + cDTO + "#1.PedidoDTO#1"} )
	if nPos > 0 .AND. ValType(oPedido['nCdSituacao']) <> "U"
		xRet := oWsdl:SetValue( aSimple[nPos][1], oPedido['nCdSituacao'])
	endif
	if xRet == .F.
		xRet := oWsdl:cError
		Return "Erro ao Setar o campo nCdSituacao"
	endif

	xRet := .T.
	nPos := aScan( aSimple, {|x| x[2] == "nCdTipo" .AND. x[5] == cMetodo + "#1." + cDTO + "#1.PedidoDTO#1"} )
	if nPos > 0 .AND. ValType(oPedido['nCdTipo']) <> "U"
		xRet := oWsdl:SetValue( aSimple[nPos][1], oPedido['nCdTipo'])
	endif
	if xRet == .F.
		xRet := oWsdl:cError
		Return "Erro ao Setar o campo nCdTipo"
	endif

	xRet := .T.
	nPos := aScan( aSimple, {|x| x[2] == "nIdTipoOrigem" .AND. x[5] == cMetodo + "#1." + cDTO + "#1.PedidoDTO#1"} )
	if nPos > 0 .AND. ValType(oPedido['nIdTipoOrigem']) <> "U"
		xRet := oWsdl:SetValue( aSimple[nPos][1], oPedido['nIdTipoOrigem'])
	endif
	if xRet == .F.
		xRet := oWsdl:cError
		Return "Erro ao Setar o campo nIdTipoOrigem"
	endif

	xRet := .T.
	nPos := aScan( aSimple, {|x| x[2] == "nNrVersao" .AND. x[5] == cMetodo + "#1." + cDTO + "#1.PedidoDTO#1"} )
	if nPos > 0 .AND. ValType(oPedido['nNrVersao']) <> "U"
		xRet := oWsdl:SetValue( aSimple[nPos][1], oPedido['nNrVersao'])
	endif
	if xRet == .F.
		xRet := oWsdl:cError
		Return "Erro ao Setar o campo nNrVersao"
	endif

	xRet := .T.
	nPos := aScan( aSimple, {|x| x[2] == "sCdCentroCusto" .AND. x[5] == cMetodo + "#1." + cDTO + "#1.PedidoDTO#1"} )
	if nPos > 0 .AND. ValType(oPedido['sCdCentroCusto']) <> "U"
		xRet := oWsdl:SetValue( aSimple[nPos][1], oPedido['sCdCentroCusto'])
	endif
	if xRet == .F.
		xRet := oWsdl:cError
		Return "Erro ao Setar o campo sCdCentroCusto"
	endif

	xRet := .T.
	nPos := aScan( aSimple, {|x| x[2] == "sCdComprador" .AND. x[5] == cMetodo + "#1." + cDTO + "#1.PedidoDTO#1"} )
	if nPos > 0 .AND. ValType(oPedido['sCdComprador']) <> "U"
		xRet := oWsdl:SetValue( aSimple[nPos][1], oPedido['sCdComprador'])
	endif
	if xRet == .F.
		xRet := oWsdl:cError
		Return "Erro ao Setar o campo sCdComprador"
	endif

	xRet := .T.
	nPos := aScan( aSimple, {|x| x[2] == "sCdCondicaoPagamento" .AND. x[5] == cMetodo + "#1." + cDTO + "#1.PedidoDTO#1"} )
	if nPos > 0 .AND. ValType(oPedido['sCdCondicaoPagamento']) <> "U"
		xRet := oWsdl:SetValue( aSimple[nPos][1], oPedido['sCdCondicaoPagamento'])
	endif
	if xRet == .F.
		xRet := oWsdl:cError
		Return "Erro ao Setar o campo sCdCondicaoPagamento"
	endif

	xRet := .T.
	nPos := aScan( aSimple, {|x| x[2] == "sCdEstrategiaAprovacao" .AND. x[5] == cMetodo + "#1." + cDTO + "#1.PedidoDTO#1"} )
	if nPos > 0 .AND. ValType(oPedido['sCdEstrategiaAprovacao']) <> "U"
		xRet := oWsdl:SetValue( aSimple[nPos][1], oPedido['sCdEstrategiaAprovacao'])
	endif
	if xRet == .F.
		xRet := oWsdl:cError
		Return "Erro ao Setar o campo sCdEstrategiaAprovacao"
	endif

	xRet := .T.
	nPos := aScan( aSimple, {|x| x[2] == "sCdFonteRecurso" .AND. x[5] == cMetodo + "#1." + cDTO + "#1.PedidoDTO#1"} )
	if nPos > 0 .AND. ValType(oPedido['sCdFonteRecurso']) <> "U"
		xRet := oWsdl:SetValue( aSimple[nPos][1], oPedido['sCdFonteRecurso'])
	endif
	if xRet == .F.
		xRet := oWsdl:cError
		Return "Erro ao Setar o campo sCdFonteRecurso"
	endif

	xRet := .T.
	nPos := aScan( aSimple, {|x| x[2] == "sCdFornecedor" .AND. x[5] == cMetodo + "#1." + cDTO + "#1.PedidoDTO#1"} )
	if nPos > 0 .AND. ValType(oPedido['sCdFornecedor']) <> "U"
		xRet := oWsdl:SetValue( aSimple[nPos][1], oPedido['sCdFornecedor'])
	endif
	if xRet == .F.
		xRet := oWsdl:cError
		Return "Erro ao Setar o campo sCdFornecedor"
	endif

	xRet := .T.
	nPos := aScan( aSimple, {|x| x[2] == "sCdFrete" .AND. x[5] == cMetodo + "#1." + cDTO + "#1.PedidoDTO#1"} )
	if nPos > 0 .AND. ValType(oPedido['sCdFrete']) <> "U"
		xRet := oWsdl:SetValue( aSimple[nPos][1], oPedido['sCdFrete'])
	endif
	if xRet == .F.
		xRet := oWsdl:cError
		Return "Erro ao Setar o campo sCdFrete"
	endif

	xRet := .T.
	nPos := aScan( aSimple, {|x| x[2] == "sCdGrupoCompra" .AND. x[5] == cMetodo + "#1." + cDTO + "#1.PedidoDTO#1"} )
	if nPos > 0 .AND. ValType(oPedido['sCdGrupoCompra']) <> "U"
		xRet := oWsdl:SetValue( aSimple[nPos][1], oPedido['sCdGrupoCompra'])
	endif
	if xRet == .F.
		xRet := oWsdl:cError
		Return "Erro ao Setar o campo sCdGrupoCompra"
	endif

	xRet := .T.
	nPos := aScan( aSimple, {|x| x[2] == "sCdMoeda" .AND. x[5] == cMetodo + "#1." + cDTO + "#1.PedidoDTO#1"} )
	if nPos > 0 .AND. ValType(oPedido['sCdMoeda']) <> "U"
		xRet := oWsdl:SetValue( aSimple[nPos][1], oPedido['sCdMoeda'])
	endif
	if xRet == .F.
		xRet := oWsdl:cError
		Return "Erro ao Setar o campo sCdMoeda"
	endif

	xRet := .T.
	nPos := aScan( aSimple, {|x| x[2] == "sCdPedidoERP" .AND. x[5] == cMetodo + "#1." + cDTO + "#1.PedidoDTO#1"} )
	if nPos > 0 .AND. ValType(oPedido['sCdPedidoERP']) <> "U"
		xRet := oWsdl:SetValue( aSimple[nPos][1], oPedido['sCdPedidoERP'])
	endif
	if xRet == .F.
		xRet := oWsdl:cError
		Return "Erro ao Setar o campo sCdPedidoERP"
	endif

	xRet := .T.
	nPos := aScan( aSimple, {|x| x[2] == "sCdPedidoWBC" .AND. x[5] == cMetodo + "#1." + cDTO + "#1.PedidoDTO#1"} )
	if nPos > 0 .AND. ValType(oPedido['sCdPedidoWBC']) <> "U"
		xRet := oWsdl:SetValue( aSimple[nPos][1], oPedido['sCdPedidoWBC'])
	endif
	if xRet == .F.
		xRet := oWsdl:cError
		Return "Erro ao Setar o campo sCdPedidoWBC"
	endif

	xRet := .T.
	nPos := aScan( aSimple, {|x| x[2] == "sCdProjeto" .AND. x[5] == cMetodo + "#1." + cDTO + "#1.PedidoDTO#1"} )
	if nPos > 0 .AND. ValType(oPedido['sCdProjeto']) <> "U"
		xRet := oWsdl:SetValue( aSimple[nPos][1], oPedido['sCdProjeto'])
	endif
	if xRet == .F.
		xRet := oWsdl:cError
		Return "Erro ao Setar o campo sCdProjeto"
	endif

	xRet := .T.
	nPos := aScan( aSimple, {|x| x[2] == "sCdTransportadora" .AND. x[5] == cMetodo + "#1." + cDTO + "#1.PedidoDTO#1"} )
	if nPos > 0 .AND. ValType(oPedido['sCdTransportadora']) <> "U"
		xRet := oWsdl:SetValue( aSimple[nPos][1], oPedido['sCdTransportadora'])
	endif
	if xRet == .F.
		xRet := oWsdl:cError
		Return "Erro ao Setar o campo sCdTransportadora"
	endif

	xRet := .T.
	nPos := aScan( aSimple, {|x| x[2] == "sCdUsuario" .AND. x[5] == cMetodo + "#1." + cDTO + "#1.PedidoDTO#1"} )
	if nPos > 0 .AND. ValType(oPedido['sCdUsuario']) <> "U"
		xRet := oWsdl:SetValue( aSimple[nPos][1], oPedido['sCdUsuario'])
	endif
	if xRet == .F.
		xRet := oWsdl:cError
		Return "Erro ao Setar o campo sCdUsuario"
	endif

	xRet := .T.
	nPos := aScan( aSimple, {|x| x[2] == "sCdUsuarioProgramador" .AND. x[5] == cMetodo + "#1." + cDTO + "#1.PedidoDTO#1"} )
	if nPos > 0 .AND. ValType(oPedido['sCdUsuarioProgramador']) <> "U"
		xRet := oWsdl:SetValue( aSimple[nPos][1], oPedido['sCdUsuarioProgramador'])
	endif
	if xRet == .F.
		xRet := oWsdl:cError
		Return "Erro ao Setar o campo sCdUsuarioProgramador"
	endif

	xRet := .T.
	nPos := aScan( aSimple, {|x| x[2] == "sDsObservacoes" .AND. x[5] == cMetodo + "#1." + cDTO + "#1.PedidoDTO#1"} )
	if nPos > 0 .AND. ValType(oPedido['sDsObservacoes']) <> "U"
		xRet := oWsdl:SetValue( aSimple[nPos][1], oPedido['sDsObservacoes'])
	endif
	if xRet == .F.
		xRet := oWsdl:cError
		Return "Erro ao Setar o campo sDsObservacoes"
	endif

	xRet := .T.
	nPos := aScan( aSimple, {|x| x[2] == "sDsPedidoAuditoria" .AND. x[5] == cMetodo + "#1." + cDTO + "#1.PedidoDTO#1"} )
	if nPos > 0 .AND. ValType(oPedido['sDsPedidoAuditoria']) <> "U"
		xRet := oWsdl:SetValue( aSimple[nPos][1], oPedido['sDsPedidoAuditoria'])
	endif
	if xRet == .F.
		xRet := oWsdl:cError
		Return "Erro ao Setar o campo sDsPedidoAuditoria"
	endif

	xRet := .T.
	nPos := aScan( aSimple, {|x| x[2] == "sDsPedidoJustificativa" .AND. x[5] == cMetodo + "#1." + cDTO + "#1.PedidoDTO#1"} )
	if nPos > 0 .AND. ValType(oPedido['sDsPedidoJustificativa']) <> "U"
		xRet := oWsdl:SetValue( aSimple[nPos][1], oPedido['sDsPedidoJustificativa'])
	endif
	if xRet == .F.
		xRet := oWsdl:cError
		Return "Erro ao Setar o campo sDsPedidoJustificativa"
	endif

	xRet := .T.
	nPos := aScan( aSimple, {|x| x[2] == "sNrProjeto" .AND. x[5] == cMetodo + "#1." + cDTO + "#1.PedidoDTO#1"} )
	if nPos > 0 .AND. ValType(oPedido['sNrProjeto']) <> "U"
		xRet := oWsdl:SetValue( aSimple[nPos][1], oPedido['sNrProjeto'])
	endif
	if xRet == .F.
		xRet := oWsdl:cError
		Return "Erro ao Setar o campo sNrProjeto"
	endif

	xRet := .T.
	nPos := aScan( aSimple, {|x| x[2] == "sNrRgPesquisador" .AND. x[5] == cMetodo + "#1." + cDTO + "#1.PedidoDTO#1"} )
	if nPos > 0 .AND. ValType(oPedido['sNrRgPesquisador']) <> "U"
		xRet := oWsdl:SetValue( aSimple[nPos][1], oPedido['sNrRgPesquisador'])
	endif
	if xRet == .F.
		xRet := oWsdl:cError
		Return "Erro ao Setar o campo sNrRgPesquisador"
	endif

	xRet := .T.
	nPos := aScan( aSimple, {|x| x[2] == "tDtCadastro" .AND. x[5] == cMetodo + "#1." + cDTO + "#1.PedidoDTO#1"} )
	if nPos > 0 .AND. ValType(oPedido['tDtCadastro']) <> "U"
		xRet := oWsdl:SetValue( aSimple[nPos][1], oPedido['tDtCadastro'])
	endif
	if xRet == .F.
		xRet := oWsdl:cError
		Return "Erro ao Setar o campo tDtCadastro"
	endif

	xRet := .T.
	nPos := aScan( aSimple, {|x| x[2] == "tDtEmissao" .AND. x[5] == cMetodo + "#1." + cDTO + "#1.PedidoDTO#1"} )
	if nPos > 0 .AND. ValType(oPedido['tDtEmissao']) <> "U"
		xRet := oWsdl:SetValue( aSimple[nPos][1], oPedido['tDtEmissao'])
	endif
	if xRet == .F.
		xRet := oWsdl:cError
		Return "Erro ao Setar o campo tDtEmissao"
	endif

	xRet := .T.
	nPos := aScan( aSimple, {|x| x[2] == "tDtFaturamento" .AND. x[5] == cMetodo + "#1." + cDTO + "#1.PedidoDTO#1"} )
	if nPos > 0 .AND. ValType(oPedido['tDtFaturamento']) <> "U"
		xRet := oWsdl:SetValue( aSimple[nPos][1], oPedido['tDtFaturamento'])
	endif
	if xRet == .F.
		xRet := oWsdl:cError
		Return "Erro ao Setar o campo tDtFaturamento"
	endif

	xRet := .T.
	nPos := aScan( aSimple, {|x| x[2] == "bFlNaoUtilizarDePara" .AND. x[5] == cMetodo + "#1"} )
	if nPos > 0 .AND. ValType(oPedido['bFlNaoUtilizarDePara']) <> "U"
		xRet := oWsdl:SetValue( aSimple[nPos][1], oPedido['bFlNaoUtilizarDePara'])
	endif
	if xRet == .F.
		xRet := oWsdl:cError
		Return "Erro ao Setar o campo bFlNaoUtilizarDePara"
	endif

	if(TYPE('cSOAPmgs') == 'C')
		cSOAPmgs := oWsdl:GetSoapMsg()
	EndIf
		
	// Envia a mensagem SOAP ao servidor
	xRet := oWsdl:SendSoapMsg()
	if !xRet
		Return xRet := oWsdl:cFaultCode+" "+oWsdl:cError
	endif
		
	// Pega a mensagem de resposta
	xRet := oWsdl:GetSoapResponse()
	if(TYPE('cSOAPret') == 'C')
		cSOAPret := xRet
	EndIf

	If !Empty(oWsdl:cError) .OR. !Empty(GetSimples( xRet, '<faultcode', '</faultcode>' ))
		xRet := {oWsdl:cFaultCode, oWsdl:cError, xRet}
	//Else
		//oXmlDoc := XmlParser( xRet, "_", @cErro, @cAviso )
		//If oXmlDoc <> Nil
			//xRet := oXmlDoc
		//Else
			//Retorna falha no parser do XML
			//xRet := "ProcessarPedido: Falha ao interpretar xml de retorno"
		//EndIf
	EndIf

Return xRet
			

Static Function ajustaDT(dDt)
	Local cTemp := DTOS(dDt)
	Local cRet 	:= ''
	If(empty(AllTrim(cTemp)))
		cTemp := DTOS(Date())
	EndIf
	cRet 	:= SubStr(cTemp,1,4) + '-' + SubStr(cTemp,5,2) + '-' + SubStr(cTemp,7,2)// + 'T09:16:22.197'
	
Return cRet

Static Function verifItens(cFilSC7, cNumSC7)
	Local aArea 	:= GetArea()
	Local cQuery    := ""
	Local oStatement:= nil
	Local nSQLParam := 0
	Local lRet		:= .T.
	Local cAliasSQL

	cQuery := "SELECT R_E_C_N_O_ RECNO " + CRLF
	cQuery += "FROM " + RETSQLTAB("SC7") + CRLF
	cQuery += "WHERE C7_FILIAL = ? " + " AND D_E_L_E_T_ = ' ' " + CRLF
	cQuery += "		AND C7_NUM = ? " + CRLF

	// Trata SQL para proteger de SQL injection.
	oStatement := FWPreparedStatement():New()
	oStatement:SetQuery(cQuery)
			
	nSQLParam++
	oStatement:SetString(nSQLParam, cFilSC7)
	nSQLParam++
	oStatement:SetString(nSQLParam, cNumSC7)
			
	cQuery := oStatement:GetFixQuery()
	oStatement:Destroy()
	oStatement := nil

	cAliasSQL := MPSysOpenQuery(cQuery)
		
	DbSelectArea("SC7")
	Do While (cAliasSQL)->(!eof()) .AND. lRet
		SC7->(dbGoTo((cAliasSQL)->RECNO))

		If(SC7->C7_QUJE < SC7->C7_QUANT .AND. SC7->C7_RESIDUO <> 'S' .AND. SC7->C7_ENCER <> 'E')
			lRet := .F.
		EndIf
		
		(cAliasSQL)->(dbSkip())
	EndDo
	(cAliasSQL)->(dbCloseArea())
	RestArea(aArea)
Return lRet


Static function ReTiGraf(_sOrig)
   local _sRet := _sOrig
   _sRet := strtran (_sRet, "á", "a")
   _sRet := strtran (_sRet, "é", "e")
   _sRet := strtran (_sRet, "í", "i")
   _sRet := strtran (_sRet, "ó", "o")
   _sRet := strtran (_sRet, "ú", "u")
   _SRET := STRTRAN (_SRET, "Ý", "A")
   _SRET := STRTRAN (_SRET, "É", "E")
   _SRET := STRTRAN (_SRET, "Ý", "I")
   _SRET := STRTRAN (_SRET, "Ó", "O")
   _SRET := STRTRAN (_SRET, "Ú", "U")
   _sRet := strtran (_sRet, "ã", "a")
   _sRet := strtran (_sRet, "õ", "o")
   _SRET := STRTRAN (_SRET, "Ã", "A")
   _SRET := STRTRAN (_SRET, "Õ", "O")
   _sRet := strtran (_sRet, "â", "a")
   _sRet := strtran (_sRet, "ê", "e")
   _sRet := strtran (_sRet, "î", "i")
   _sRet := strtran (_sRet, "ô", "o")
   _sRet := strtran (_sRet, "û", "u")
   _SRET := STRTRAN (_SRET, "Â", "A")
   _SRET := STRTRAN (_SRET, "Ê", "E")
   _SRET := STRTRAN (_SRET, "Î", "I")
   _SRET := STRTRAN (_SRET, "Ô", "O")
   _SRET := STRTRAN (_SRET, "Û", "U")
   _sRet := strtran (_sRet, "ç", "c")
   _sRet := strtran (_sRet, "Ç", "C")
   _sRet := strtran (_sRet, "à", "a")
   _sRet := strtran (_sRet, "À", "A")
   _sRet := strtran (_sRet, "º", ".")
   _sRet := strtran (_sRet, "ª", ".")
   _sRet := strtran (_sRet, "&", "e")
   _sRet := strtran (_sRet, "°", ".")
   _sRet := strtran (_sRet, "´", ".")
   _sRet := strtran (_sRet, chr (9), " ") // TAB
   _sRet := FwNoAccent( _sRet )
return _sRet
