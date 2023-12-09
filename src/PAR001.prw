#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "RESTFUL.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "FWMBROWSE.CH"

#DEFINE CRLF CHR(13)+CHR(10)



/*==================================================================================================================*\
|| ############################################################################################################## 	||
||																	 											  	||
|| # Programa: PAR001 																							# 	||
|| # Desc: Rotina de integraÁ„o de cadastro com o WebService da Paradigma.										#   ||
||																												  	||
|| # Tabelas Usadas: 		 																					# 	||
||																												  	||
|| # Data - 06/08/2018 																							# 	||
||																												  	||
|| ############################################################################################################## 	||
||																												    ||
|| # AlteraÁıes 								 																#   ||
|| COR001 - CorreÁ„o na leitura do objeto que contÈm os dados do fornecedor - Alexandre Caetano - 01/09/2022	    ||
|| COR002 - AlteraÁ„o da funÁ„o que insere o nome do fornecedor e adiÁ„o do retigraf- Alexandre Caetano - 01/09/2022||
|| COR003 - AdiÁ„o de funÁ„o para melhorar a retigraf - Alexandre Caetano - 01/09/2022							  	||
|| COR004 - FunÁ„o para verificar array em busca de tag	- Alexandre Caetano - 01/09/2022						  	||
|| 																												  	||
|| 																												  	||
|| 																												  	||
|| ############################################################################################################## 	||
\*==================================================================================================================*/
User Function PAR001(aParam)
	Local bProcess := {|oProcess| lExecuta(@oProcess)}
	Local aButtons := {} //rotinas adicionais
	Local cDescAux := "Integrando"
	Local cRotina  := "PAR001"
	Local cTitulo  := "Integraùùo Protheus x Paradigma"
	Local cDescri  := "Esta rotina efetua as integraùùes entre o sistema Protheus e o portal Paradigma"
	Local cPerg    := "PAR001"
	Private lIsBlind := IsBlind()

	Private lerro := .F.
	Private aMvPar := {}


	conout("ENTROU INICIO ")

	If IsInCallStack('U_PAR005')

		lIsBlind := .T.

	Else

		RpcSetEnv("11","02")
		lIsBlind := IsBlind()

	Endif


	If lIsBlind

		Eval(bProcess)

		//RpcClearEnv()
		Return

	EndIf

	conout("FIM ")
	//Pergunte(cPerg, .F.)

	tNewProcess():New(cRotina ,;
		cTitulo ,;
		bProcess,;
		cDescri ,;
		cPerg ,;
		aButtons,;
		.T. ,;
		5 ,;
		cDescAux,;
		.T.)

	If lIsBlind

		//RpcClearEnv()

	Endif


Return

/*/{Protheus.doc} lExecuta
//Execuùùo do processo de integraùùo
@author Administrator
@since 06/08/2018
@version 1.0
@Return lRetorno, Indica se o processamento ocorreu corretamente
@param oProcess, object, Objeto tNewProcess instanciado
@type function
/*/
Static Function lExecuta(oProcess)
	Local cInicio 	 := Time()
	Local aRegSB1 	 := {}
	Local nProc 	 := 0
	Local cLog 		 := ""
	Local oLog 		 := Nil
	Local aAreaSM0 	 := Nil
	Local oWsEmpresa := Nil
	Local aEmpresas  := {}
	Local cLockName := "Integracao_PAR001"
	Private aEmpFil := FWLoadSM0()
	Private lHomolog := ('https://srm-hml.paradigmabs.com.br/ferroport-hml' $ Lower(AllTrim(GetMv("MV_XPARURL"))))

	static lPosA2_XXML 		:= .t. //SA2->(FieldPos("A2_XXML")) > 0
	static lPosA2_XENVXML 	:= .t. //SA2->(FieldPos("A2_XENVXML")) > 0
	// INùCIO - SEMùFORO DE CONTROLE DE EXECUùùES SIMULTùNEAS DA INTEGRAùùO
	If !LockByName(cLockName,.T.,.T.)
		MsgInfo("Rotina jù estù sendo executada por outro usuùrio","Atenùùo"+Procname())
		Return .F.
	EndIf

	DbSelectArea("SA2")
	lPosA2_XXML 		:= SA2->(FieldPos("A2_XXML")) > 0
	lPosA2_XENVXML 		:= SA2->(FieldPos("A2_XENVXML")) > 0

	DbSelectArea("ZPL")
	SetRegua1(@oProcess, 20)
	IncRegua1(@oProcess, "Integrando Empresas")

	If GetMv("MV_ZINTEMP") == '2'
		oLog := FwParLog():New("PAR001", "RetornarEmpresaPorCnpj")
		oWsEmpresa := WSEmpresa():New()

		SetRegua2(@oProcess, 0)
		IncRegua2(@oProcess, "Verificando Empresa")
		// Verifica se a empresa esta cadastrada no sistema \\

		If oWsEmpresa:RetornarEmpresaPorCnpj(AllTrim(SM0->M0_CGC))

			// Se nùo estiver, ù chamada a funùùo para processar empresa \\
			If Empty(oWsEmpresa:oWsRetornarEmpresaPorCnpjResult:cScdEmpresa)
				fEmpresa(@oProcess, @nProc)
			EndIf
		Else
			fSoapFault(oLog)
		EndIf
	Else

		aAreaSM0 := SM0->(GetArea())
		SM0->(DbSetOrder(1))
		SM0->(DbSeek(cEmpAnt))

		// Percorre todas as filiais da empresa atual \\
		While !SM0->(EOF())
			If SM0->M0_CODIGO == cEmpAnt .And. !Empty(SM0->M0_CGC) .And. Empty(aScan(aEmpresas, {|x| x == SM0->M0_CGC }))
				aAdd(aEmpresas, SM0->M0_CGC)
				fEmpresa(@oProcess, @nProc)
			EndIf

			SM0->(DbSkip())
		EndDo

		RestArea(aAreaSM0)

		//Parùmetro Integra Empresa Paradigma setado como Nùo
		PutMv("MV_ZINTEMP", '2') // 1=Sim; 2=Nùo
	EndIf


	IncRegua1(@oProcess, "Integrando Moedas")
	//integraùùo da moeda
	If GetMv("MV_ZINTMOE") <> '2'
		nProc += nMoeda(@oProcess)
	EndIf

	IncRegua1(@oProcess, "Integrando usu·rios")
	//integraùùo da Usuario
	If GetMv("MV_ZINTUSU") <> '2'
		nProc += nUsuario(oProcess)
	EndIf

	IncRegua1(oProcess, "Integrando Bancos")
	//integraùùo de Banco
	If GetMv("MV_ZINTBAN") <> '2'
		nProc += nBanco(oProcess) //oBanco:cScdBanco
	EndIf

	IncRegua1(@oProcess, "Integrando Categorias")
	//integraùùo de categorias
	If GetMv("MV_ZINTCAT") <> '2'
		nProc += nCategoria(@oProcess)
	EndIf

	IncRegua1(@oProcess, "Integrando Unidades de Medidas")
	//integraùùo de unidades de medidas
	If GetMv("MV_ZINTUM") <> '2'
		nProc += nUnidMed(@oProcess)
	EndIf

	IncRegua1(@oProcess, "Integrando Projetos")
	If GetMv("MV_ZINTPRJ") <> '2'
		nProc += nProjeto(@oProcess)
	EndIf

	/*IncRegua1(@oProcess, "Integrando Grupos de Compras")
	If lMvPar("Grupo de Compra")
	nProc += nGrpCmp(@oProcess)
	EndIf*/

	IncRegua1(@oProcess, "Integrando condi?s de Pagamentos")
	//integraùùo de condiùùes de pagamentos
	If GetMv("MV_ZINTCON") <>'2'
		nProc += nCondPgto(@oProcess)
	EndIf

	IncRegua1(@oProcess, "Integrando Centros de Custos")
	//integraùùo de centros de custos
	If GetMv("MV_ZINTCC") <> '2'
		nProc += cCtroCusto(@oProcess)
	EndIf

	IncRegua1(@oProcess, "Integrando Conta contabil")
	//integraùùo de conta contabil
	If GetMv("MV_ZINTCBI") <> '2'
		nProc += nCtaContab(@oProcess)
	EndIf

	/*
	IncRegua1(@oProcess, "Integrando Natureza Despesa")
	If GetMv("MV_ZINTCBI") <> 2
		nProc += nNatDezp(@oProcess)
	EndIf */

	IncRegua1(@oProcess, "Integrando Produtos")
	//integraùùo de produtos
	If GetMv("MV_ZINTPRD") <> '2'
		aRegSB1 := aProdutos(@oProcess)
		nProc += Len(aRegSB1)
	EndIf

	IncRegua1(@oProcess, "Integrando Produto Unidade Medida")
	If ! Empty(aRegSB1)
		nProc += nPrcPrdUm(@oProcess, aRegSB1)
	EndIf

	IncRegua1(@oProcess, "Integrando Segunda Unidade Medida")
	//integraùùo da segunda unidade de medida
	If !Empty(aRegSB1)
		nProc += nSgUnidMed(@oProcess, aRegSB1)
	EndIf

	IncRegua1(@oProcess, "Integrando Fornecedores")
	//integraùùo dos fornecedores
	If GetMv("MV_ZINTFOR") <> '2'
		nProc += nRetFornec(@oProcess)
		nProc += nPrcFornec(@oProcess)
		nProc += fAlterForne(@oProcess)
	EndIf

	/*
	IncRegua1(@oProcess, "Integrando Fornecedor X Condiùùes de Pagamentos")
	//integraùùo de condiùùes de pagamentos
	If lMvPar("Condiùùo de pagamento")
	nProc += nCdPgtoFor(@oProcess)
	EndIf*/

	IncRegua1(@oProcess, "Integrando Categorias Empresa")
	If GetMv("MV_ZINTCTE") <> '2'
		nProc += nCategEmp(@oProcess)
	EndIf

	IncRegua1(@oProcess, "Integrando Solicita? de Compras")
	//integraùùo das solicitaùùes de compras
	If GetMv("MV_ZINTSOL") <> '2'
		nProc += nAlterComp(@oProcess)
		nProc += nRejeita(@oProcess)
		nProc += nCancelSC(@oProcess)
		nProc += nProcSC(@oProcess)
		//		nProc += nIntrCSc(oProcess)
	EndIf

	IncRegua1(@oProcess, "Integrando Pedidos de Compras")
	//integraùùo das pedidos de compras
	If GetMv("MV_ZINTPED") <> '2'
		nProc += U_WsActvsPed()
		U_RETPED()
	EndIf

	IncRegua1(oProcess, "Integrando cota? Moeda")
	If GetMv("MV_ZINTCOT") <> '2'
		nProc += nMoedaCota(oProcess)
	EndIf

	IncRegua1(@oProcess, "Integrando  - Processar empresa")

	ProcessarEmpresa(@oProcess)
	//nRetFornec(@oProcess)

	/*
	// Desmarcada a seleùùo para integrar itens cadastrados
	PutMv("MV_XPARCAD",2)
	*/
	// FIM - SEMùFORO DE CONTROLE DE EXECUùùES SIMULTùNEAS DA INTEGRAùùO
	UnLockByName(cLockName,.T.,.T.)

	If nProc > 0
		cLog := cValToChar(nProc) + " processo(s) executado(s). Tempo decorrido: " + ElapTime(cInicio, Time()) + Iif(lerro, ' Erros Ocorridos!', '')
	Else
		cLog := Iif(lerro, 'Erros Ocorridos!', "Nada processado")
	EndIf

	Conout(' \\\\ Fim Integra? Paradigma. ' + cLog + ' ////')
	Conout('')

	If !lIsBlind
		oProcess:SaveLog(cLog)
		MsgInfo(cLog, "Processo Finalizado")
	EndIf

Return .T.

Static Function fEmpresa(oProcess, nProc)
	Local oWsdl
	Local xRet
	Local lRet
	Local oLog       := FwParLog():New("PAR001", "ProcessarEmpresa")
	Local _cSoap := "" // XML de integraùùo
	Local aRet // Retorno da integraùùo
	Local aLogInt := {}
	Local cReplace := "_"
	Local cErros   := ""
	Local cAvisos  := ""

	// Cria o objeto da classe TWsdlManager
	oWsdl := TWsdlManager():New()
	oWsdl:AddHttpHeader("Authorization", "Bearer " + U_NewToken())
	oWsdl:lSSLInsecure := .T.
	oWsdl:nTimeout       := 120
	/*
    nSSLVersion  - Lista de opùùes que pode ser setadas:
    0 - O programa tenta descobrir a versùo do protocolo
    1 - Forùa a utilizaùùo do TLSv1
    2 - Forùa a utilizaùùo do SSLv2
    3 - Forùa a utilizaùùo do SSLv3
	*/
	oWsdl:nSSLVersion := 0

	xRet := oWsdl:ParseURL(Lower(AllTrim(GetMv("MV_XPARURL")))+"/services/Empresa.svc?wsdl" )

	If xRet == .F.
		ConOut("Erro ParseURL: " + oWsdl:cError)
		Return
	EndIf

	lRet := oWsdl:SetOperation("ProcessarEmpresa")
	If lRet == .F.
		ConOut("Erro SetOperation: " + oWsdl:cError)
		return
	EndIf

	SetRegua2(@oProcess, 0)
	IncRegua2(@oProcess, "Processando Empresa")

	If xRet == .F.
		ConOut( "Erro: " + oWsdl:cError )
	Else
		Begin Sequence
			IncRegua2(@oProcess, "Processando " + SM0->M0_CODIGO + SM0->M0_CODFIL)
			fIniLog("Empresa")

			_cSoap += XMLEmp()

			/*If SM0->M0_CGC == '33719485001441'
				1=1
			EndIf*/

			lRet := oWsdl:SendSoapMsg(_cSoap)
		End Sequence

		If lRet == .F.
			ConOut( "Erro SendSoapMsg: " + oWsdl:cError )
			ConOut( "Erro SendSoapMsg FaultCode: " + oWsdl:cFaultCode )
		Else
			aRet := XmlParser(oWsdl:GetSoapResponse(), cReplace, @cErros, @cAvisos)

			// Objeto de Log \\
			aAdd(aLogInt, {;
				aRet:_S_ENVELOPE:_S_BODY:_PROCESSAREMPRESARESPONSE:_PROCESSAREMPRESARESULT:_A_LSTWBTLOGDTO:_A_WBTLOGDTO:_A_SCDORIGEM:TEXT,;
				aRet:_S_ENVELOPE:_S_BODY:_PROCESSAREMPRESARESPONSE:_PROCESSAREMPRESARESULT:_A_LSTWBTLOGDTO:_A_WBTLOGDTO:_A_SDSLOG:TEXT,;
				aRet:_S_ENVELOPE:_S_BODY:_PROCESSAREMPRESARESPONSE:_PROCESSAREMPRESARESULT:_A_LSTWBTLOGDTO:_A_WBTLOGDTO:_A_SNRTOKEN:TEXT,;
				aRet:_S_ENVELOPE:_S_BODY:_PROCESSAREMPRESARESPONSE:_PROCESSAREMPRESARESULT:_A_LSTWBTLOGDTO:_A_WBTLOGDTO:_A_TDTLOG:TEXT,;
				aRet:_S_ENVELOPE:_S_BODY:_PROCESSAREMPRESARESPONSE:_PROCESSAREMPRESARESULT:_A_LSTWBTLOGDTO:_A_WBTLOGDTO:_A_NIDRETORNO:TEXT;
				})

			fWsLogRet(aLogInt, oLog,,,, .T.)
			nProc++
		EndIf
		fFimLog("Empresa - " + cValToChar(nProc) + ' processado - ' + Time() )
	EndIf
Return

/*/{Protheus.doc} nMoeda
//Efetua a integraùùo de moedas
@author Administrator
@since 06/08/2018
@version 1.0
@param oProcess, object, Objeto de processamento da tNewProcess
@type function
/*/
Static Function nMoeda(oProcess)
	Local oWsMoeda 	 := WSMoeda():New()
	Local oMoeda 	 := Nil
	Local cDescMoeda := ""
	Local cSigMoeda  := ""
	Local nProc 	 := 0
	Local nX 		 := 0
	Local oLog 		 := FwParLog():New("PAR001", "ProcessarMoeda")
	Local aReg 		 := {}
	Local aRetorno   := {}
	Local oError := ErrorBlock({|e| fErrorPar(e:Description, 'CTO', @oLog, @cDescMoeda)})
	Local bEmp

	Begin Sequence
		fIniLog("Moedas")

		SetRegua2(@oProcess, 0)
		IncRegua2(@oProcess, "Buscando as moedas")

		For nX := 1 To 30
			cDescMoeda := FMoeda("MV_MOEDA" + cValToChar(nX))// SuperGetMv("MV_MOEDA"+cValToChar(nX), .F., "")
			cSigMoeda := FMoeda("MV_SIMB" + cValToChar(nX))// SuperGetMv("MV_SIMB"+cValToChar(nX), .F., "")
			IncRegua2(@oProcess, "Registrando moeda " + cDescMoeda)

			If !Empty(cDescMoeda)
				oMoeda			 := Moeda_MoedaDTO():New()
				oMoeda:cScdMoeda := cValToChar(nX)
				oMoeda:cSdsMoeda := AllTrim(cDescMoeda)
				oMoeda:cSsgMoeda := AllTrim(cSigMoeda)

				aAdd(oWsMoeda:oWsLstMoeda:oWsMoedaDTO, oMoeda:Clone())
			EndIf

		Next nX

		If !Empty(oWsMoeda:oWsLstMoeda:oWsMoedaDTO)

			aRetorno:=oWsMoeda:ProcessarMoeda()
			//faz a chamada da funùùo do web service de moedas
			If aRetorno[1]
				//registra o retorno de processar moeda
				fWsLogRet(oWsMoeda:OWSPROCESSARMOEDARESULT:OWSLSTWBTLOGDTO:OWSWBTLOGDTO, oLog, "", aReg, @nProc,bEmp,aRetorno[2])
			Else
				fSoapFault(oLog)
			EndIf
			PutMv("MV_XPARMOE", 2) //2=Nùo
		EndIf

		fFimLog("Moedas - " + cValToChar(nProc) + ' processados - ' + Time())
	End Sequence
	ErrorBlock(oError)
Return nProc


/*/{Protheus.doc} nCategoria
//Efetua a integraùùo das categorias
@author Administrator
@since 06/08/2018
@version 1.0
@param oProcess, object, Objeto de processamento tNewProcess
@type function
/*/
Static Function nCategoria(oProcess)
	Local cAlias 	:= GetNextAlias()
	Local cAliasAux := GetNextAlias()
	Local cQuery 	:= ""
	Local cCod 		:= ''
	Local oWsCtg 	:= WSParCategoria():New()
	Local oCateg 	:= Nil
	Local nProc 	:= 0
	Local oLog 		:= FwParLog():New("PAR001", "ProcessarCategoriaProduto")
	Local aReg 		:= {}
	Local oError 	:= ErrorBlock({|e| fErrorPar(e:ErrorStack, 'SBM', @oLog, @cCod)})
	Local nEmp		:= NIL
	Local aRetorno  := {}

	Begin Sequence
		fIniLog("Categorias")

		// Adequaùùo de cadastros anteriores ù integraùùo com a Paradigma \\
		If GetMv("MV_XPARCAD") == 1
			SetRegua2(@oProcess, 0)
			IncRegua2(@oProcess, "Adicionando Categorias cadastradas a integraùùo")

			cQuery := " select R_E_C_N_O_ REG, BM_FILIAL, BM_GRUPO, BM_DESC "
			cQuery += " from " + RetSqlTab("SBM")
			cQuery += " where SBM.D_E_L_E_T_ <> '*' "
			cQuery += " and BM_XINTPA = '' "

			OpenSQL(cAliasAux, cQuery)

			SetRegua2(@oProcess, (cAliasAux)->(nLastRec(cAliasAux)))

			While (cAliasAux)->(! EoF())
				DbSelectArea("SBM")
				DbSetOrder(1)
				DbGoTo((cAliasAux)->REG)

				RecLock("SBM",.F.)
				SBM->BM_XINTPA := '2'
				MsUnLock()

				(cAliasAux)->(DbSkip())
			EndDo

			CloseSQL(cAliasAux)

			cQuery := ""
		EndIf

		// Integraùùo com a Paradigma \\
		SetRegua2(@oProcess, 0)
		IncRegua2(@oProcess, "Buscando Categorias")

		cQuery := " select R_E_C_N_O_ REG, BM_FILIAL, BM_GRUPO, BM_DESC "
		cQuery += " from " + RetSqlTab("SBM")
		cQuery += " where SBM.D_E_L_E_T_ <> '*' "
		cQuery += " and BM_XINTPA > '1' "

		OpenSQL(cAlias, cQuery)

		SetRegua2(@oProcess, (cAlias)->(nLastRec(cAlias)))

		While (cAlias)->(! EoF())

			/* aFiliais */
			cCod := (cAlias)->BM_FILIAL + (cAlias)->BM_GRUPO
			IncRegua2(@oProcess, "Processando " + cCod)

			oCateg:= Categoria_CategoriaDTO():New()
			oCateg:csCdClasse := (cAlias)->BM_GRUPO
			oCateg:csDsClasse := (cAlias)->BM_DESC
			oCateg:csCdEmpresa:= cGetCodEmp(cEmpAnt, (cAlias)->BM_FILIAL)

			If oWsCtg:oWSlstCategoria == Nil .Or. Empty(oWsCtg:oWSlstCategoria)
				oWsCtg:oWSlstCategoria := Categoria_ARRAYOFCATEGORIADTO():New()
			EndIf

			aAdd(aReg, (cAlias)->REG)
			aAdd(oWsCtg:oWSlstCategoria:oWSParCategoriaDTO, oCateg:Clone())

			(cAlias)->(DbSkip())

		EndDo

		CloseSQL(cAlias)

		If !Empty(oWsCtg:oWSlstCategoria:oWSParCategoriaDTO)
			//faz a chamada do metodo de integraùùo de bancos

			aRetorno :=  oWsCtg:ProcessarCategoriaProduto()

			If aRetorno[1]
				//registra o retorno de processar moeda
				fWsLogRet(oWsCtg:oWSProcessarCategoriaProdutoResult:oWSlstWbtLogDTO:oWSWbtLogDTO, oLog, "SBM", aReg, @nProc,nEmp,aRetorno[2])
			Else
				fSoapFault(oLog)
			EndIf
		EndIf

		fFimLog("Categorias - " + cValToChar(nProc) + ' processados - ' + Time())
	End Sequence
	ErrorBlock(oError)
Return nProc

/*/{Protheus.doc} nUsuario
//Efetua a integraùùo de Usuario
@author geovani.figueira
@since 06/08/2018
@version 1.0
@param oProcess, object, Objeto de processamento da tNewProcess
@type function
/*/
Static Function nUsuario(oProcess)
	Local oWsUsu := WSUsuario():New()
	Local oLog 	 := FwParLog():New("PAR001", "ProcessarUsuario")
	Local oUsuar := Nil
	Local oEmp 	 := Nil
	Local cAlias := GetNextAlias()
	Local cQuery := ''
	Local cCod 	 := ''
	Local nProc  := 0
	Local nX     := 0
	Local aReg 	 := {}
	Local oError := ErrorBlock({|e| fErrorPar(e:ErrorStack, 'ZUP', @oLog, @cCod)})
	Local aEmp := {}
	Local cRetReg  := ''
	Local aFilial2 := {}
	Local aGrupo2  := {}
	Local aAux     := {}
	Local aFilial3 := {}
	Local bEmp
	local aRetorno := {}
	//Local nPerfil
	Local _e , _y  := 0

	Begin Sequence
		fIniLog("Usuario")

		/* Processamento de Usuùrios */
		SetRegua2(@oProcess, 0)
		IncRegua2(@oProcess, "Buscando Usuùrios")

		//Parametro Integra Usuario Paradigma
		If GetMv("MV_XPARUSU") <> 2
			ExecUsu()
		EndIf

		If "MSSQL" $ AllTrim(TcGetDb())
			cQuery := " Select  R_E_C_N_O_ REG, ZUP_NOMRED, ZUP_CODUSU, ZUP_NOMCOM, ZUP_BLOQUE, ZUP_EMAIL, ZUP_RAMAL, ZUP_GRUPOS, ZUP_PERFIL, ZUP_EMPFIL"
		Else
			cQuery := " Select R_E_C_N_O_ REG, ZUP_NOMRED, ZUP_CODUSU, ZUP_NOMCOM, ZUP_BLOQUE, ZUP_EMAIL, ZUP_RAMAL, ZUP_GRUPOS, ZUP_PERFIL, ZUP_EMPFIL"
		EndIf

		cQuery += " from " + RetSqlTab("ZUP")
		cQuery += " where D_E_L_E_T_ = ' ' "
		cQuery += " and ZUP_XINTPA > '1' "

		If AllTrim(TcGetDb()) == "ORACLE"
			cQuery += " AND ROWNUM <= 100"
		EndIf

		OpenSQL(cAlias, cQuery)

		/*
		If (cAlias)->(!EoF())
			SetRegua2(@oProcess, (cAlias)->(nLastRec(cAlias)))

			/* Carregando Empresas para o cadastro de usuùrios
			cQuery := "SELECT M0_CODFIL FROM " + RetSqlName("SM0")
			cQuery += " WHERE M0_CODIGO = '01' AND D_E_L_E_T_ <> '*'"
			OpenSQL(cAliasEmp, cQuery)
			SetRegua2(@oProcess, (cAliasEmp)->(nLastRec(cAliasEmp)))

			While (cAliasEmp)->(!EoF())
				IncRegua2(@oProcess, "Carregando Empresas para o cadastro de Usuùrios")
				aAdd(aEmp, (cAliasEmp)->M0_CODFIL)
				(cAliasEmp)->(DbSkip())
			EndDo

			CloseSQL(cAliasEmp)
		EndIf */

		aAdd(aEmp, XFILIAL())

		While (cAlias)->(! EoF())

			cCod := AllTrim((cAlias)->ZUP_NOMRED)
			//aGrupos	:= Separa((cAlias)->ZUP_GRUPOS, ';', .F.)
			aGrupos	:= {}
			aPerfil := Separa((cAlias)->ZUP_PERFIL, ';', .F.)

			IncRegua2(@oProcess, "Registrando Usuùrio " + (cAlias)->ZUP_CODUSU)

			aFiliais := {}
			oUsuar := Usuario_UsuarioDTO():New()

			oUsuar:csCdUsuario 			:= AllTrim((cAlias)->ZUP_NOMRED)
			oUsuar:csNmUsuario 			:= AllTrim((cAlias)->ZUP_NOMCOM)
			oUsuar:nnCdSituacao 		:= IIf((cAlias)->ZUP_BLOQUE == 'F', 1, 2) //1 - Ativo 2 - Inativo
			//oUsuar:csCdDepartamento 	:= AllTrim((cAlias)->ZUP_DEPART)
			oUsuar:csDsEmailContato 	:= IIf(lHomolog, 'tstparadigma@gmail.com', AllTrim((cAlias)->ZUP_EMAIL)) //AllTrim((cAlias)->ZUP_EMAIL)
			//oUsuar:csDsEmailContato 	:='tstparadigma@gmail.com' //AllTrim((cAlias)->ZUP_EMAIL)
			If !Empty((cAlias)->ZUP_RAMAL)
				oUsuar:csNrTelefone 	:= AllTrim((cAlias)->ZUP_RAMAL)
			EndIf

			oUsuar:csCdEmpresa 			:= AllTrim(GetMv('MV_XMATCNP')) //CNPJ DA MATRIZ

			aGrupo2 := FWSFUsrGrps((cAlias)->ZUP_CODUSU)

			// Perfil do Usuùrio \\

			oUsuar:oWSlstIdPerfil := Usuario_ArrayOfint():New()


			aAdd(oUsuar:oWSlstIdPerfil:nint, 4)

			//AQUI COMEùA A RODAR OS GRUPOS - ELB
			//REGRAS DO GRUPO 0 = USUARIO NAO ENCONTADO | 1 = PRIORIZA REGRA DO GRUPO | 2  = USUùRIO DESCONSIDERA REGRA DO GRUPO | 3 = USUùRIO SOMA REGRAS DO GRUPO

			cRetReg := FWUsrGrpRule((cAlias)->ZUP_CODUSU)


			aFilial2:= {}
			aFiliais:= {}

			//GRUPO DE USUùRIOS
			//Grupo do Usuùrio \\
			/*
			If !Empty(aGrupo2)
				oUsuar:oWSlstGrupoUsuario	:= Usuario_ArrayOfGrupoUsuarioDTO():New()
				For nX := 1 To Len(aGrupo2)
					oGrupo 			 := Usuario_GrupoUsuarioDTO():New()
					oGrupo:nnCdGrupo := Val(aGrupo2[nX])
					aAdd(oUsuar:oWSlstGrupoUsuario:oWSGrupoUsuarioDTO, oGrupo:Clone())
				Next nX
			else
					oUsuar:oWSlstGrupoUsuario	:= Usuario_ArrayOfGrupoUsuarioDTO():New()
					oGrupo 			 := Usuario_GrupoUsuarioDTO():New()
					oGrupo:nnCdGrupo := 0
					aAdd(oUsuar:oWSlstGrupoUsuario:oWSGrupoUsuarioDTO, oGrupo:Clone())
			EndIf
			*/

			// Filiais do Usuùrio \\
			// FWUsrEmp

			If AllTrim((cAlias)->ZUP_EMPFIL) != '@@@@'
				aFilAux := Separa((cAlias)->ZUP_EMPFIL, ';', .F.)
				For nX := 1 To Len(aFilAux)
					aAdd(aFiliais, alltrim(aFilAux[nX]))
				Next nX
			Else
				For nX := 1 To Len(aEmp)
					aAdd(aFiliais, (aEmp[nX]))
				Next nX
			EndIf

			//REGRA DE FILIAL POR GRUPO

			For _e := 1 to len(aGrupo2)
				aAux:= FWGrpEmp(aGrupo2[_e])
				IF !Empty(aAux)
					If aAux[1] != '@@@@'
						//aFilAux := Separa(aAux, ';', .F.)
						For nX := 1 To Len(aAux)
							aAdd(aFilial2,  ALLTRIM(aAux[nX]))
						Next nX
					Else

						For nX := 1 To Len(aEmp)
							aAdd(aFilial2, ALLTRIM(aEmp[nX]))
						Next nX

					EndIf
				Endif

			next _e

			//REGRA QUE SOMA AS DUAS REGRAS


			IF cRetReg == '3'
				IF !Empty(aAux)
					If aAux[1] != '@@@@'
						For _y := 1 to len(aFiliais)

							IF aScan(aFilial2,aFiliais[_y]) == 0

								aAdd(aFilial2, alltrim(aFiliais[_y]))

							Endif

						Next _y
					Endif
				Endif
			Endif


			//IDENTIFICA QUAL A REGRA PARA COPIAR AS FILIAIS PARA UM NOVO ARRAY
			IF cRetReg == '2'

				aFilial3 := aFiliais

			Endif

			IF cRetReg == '1' .or. cRetReg == '3'

				aFilial3 := aFilial2

			Endif


			If !Empty(aFilial3) //.AND. !('@@@@' $ (cAlias)->ZUP_EMPFIL)
				oUsuar:oWSlstUsuarioEmpresa := Usuario_ArrayOfUsuarioEmpresaDTO():New()
				For nX := 1 To Len(aFilial3)
					oEmp 			 := Usuario_UsuarioEmpresaDTO():New()
					//oEmp:csCdEmpresa := cGetCodEmp(cEmpAnt, SubStr(aFiliais[nX], 3, 4))
					oEmp:csCdEmpresa :=AllTrim(GetMv('MV_XMATCNP'))  //TRAZ O CNPJ DA FILIAL
					aAdd(oUsuar:oWSlstUsuarioEmpresa:oWSUsuarioEmpresaDTO, oEmp:Clone())
				Next nX
			EndIf

			aAdd(aReg, (cAlias)->REG)
			aAdd(oWsUsu:oWSlstUsuario:oWSUsuarioDTO, oUsuar:Clone())


			If !Empty(oWsUsu:oWSlstUsuario:oWSUsuarioDTO)

				aRetorno:= oWsUsu:ProcessarUsuario()

				If aRetorno[1]
					//registra o retorno de processar usuario
					fWsLogRet(oWsUsu:oWSProcessarUsuarioResult:oWSlstWbtLogDTO:oWSWbtLogDTO, oLog, "ZUP", aReg, @nProc,bEmp,aRetorno[2]) //aRetorno[2]

					IF oWsUsu:oWSProcessarUsuarioResult:nNidRetorno == 1
						DbSelectArea("ZUP")
						DbSetOrder(1)
						DbGoTo((cAlias)->REG)

						RecLock("ZUP",.F.)
						ZUP->ZUP_XINTPA:= '1'
						MsUnLock()
					Else
						fSoapFault(oLog)
					Endif
				Else
					fSoapFault(oLog)
				EndIf
			EndIf

			(cAlias)->(DbSkip())

		EndDo

		CloseSQL(cAlias)



		fFimLog("Usuario - " + cValToChar(nProc) + ' processados - ' + Time())
	End Sequence
	ErrorBlock(oError)

Return nProc

/*/{Protheus.doc} nUnidMed
//Efetua a integraùùo das unidades de medidas
@author Administrator
@since 06/08/2018
@version 1.0
@param oProcess, object, Objeto de processamento tNewProcess
@type function
/*/
Static Function nUnidMed(oProcess)
	Local cAlias 	:= GetNextAlias()
	Local cAliasAux := GetNextAlias()
	Local cQuery 	:= ""
	Local cCod 		:= ''
	Local oWsUm 	:= WSUnidadeMedida():New()
	Local nProc 	:= 0
	Local oLog 		:= FwParLog():New("PAR001", "ProcessarUnidadeMedida")
	Local aReg 		:= {}
	Local oUM 		:= Nil
	Local oError 	:= ErrorBlock({|e| fErrorPar(e:ErrorStack, 'SAH', @oLog, @cCod)})
	Local aRetorno  := {}
	Local bEmp   	:= NIL


	Begin Sequence
		fIniLog("Unidades Medidas")

		// Adequaùùo de cadastros anteriores ù integraùùo com a Paradigma \\
		If GetMv("MV_XPARCAD") == 1
			SetRegua2(@oProcess, 0)
			IncRegua2(@oProcess, "Adicionando Categorias cadastradas a integraùùo")

			cQuery += " select R_E_C_N_O_ REG, AH_UNIMED, AH_DESCPO, AH_UMRES "
			cQuery += " from " + RetSqlTab("SAH")
			cQuery += " where D_E_L_E_T_ = ' ' "
			cQuery += " and AH_XINTPA = '' "
			cQuery += " order by AH_UNIMED "

			OpenSQL(cAliasAux, cQuery)

			SetRegua2(@oProcess, (cAliasAux)->(nLastRec(cAliasAux)))

			While (cAliasAux)->(! EoF())
				DbSelectArea("SAH")
				DbSetOrder(1)
				DbGoTo((cAliasAux)->REG)

				RecLock("SAH",.F.)
				SAH->AH_XINTPA := '2'
				MsUnLock()

				(cAliasAux)->(DbSkip())
			EndDo

			CloseSQL(cAliasAux)

			cQuery := ""
		EndIf

		// Integraùùo com a Paradigma \\
		SetRegua2(@oProcess, 0)
		IncRegua2(@oProcess, "Buscando Unidades de Medidas")

		cQuery += " select R_E_C_N_O_ REG, AH_UNIMED, AH_DESCPO, AH_UMRES "
		cQuery += " from " + RetSqlTab("SAH")
		cQuery += " where D_E_L_E_T_ = ' ' "
		cQuery += " and AH_XINTPA > '1' "
		cQuery += " order by AH_UNIMED "

		OpenSQL(cAlias, cQuery)

		SetRegua2(@oProcess, (cAlias)->(nLastRec(cAlias)))

		While (cAlias)->(! EoF())
			cCod := (cAlias)->AH_UNIMED
			IncRegua2(@oProcess, "Processando " + (cAlias)->AH_UNIMED)

			oUM := UnidadeMedida_UnidadeMedidaDTO():New()
			oUM:csCdUnidadeMedida := (cAlias)->AH_UNIMED
			oUM:csSgUnidadeMedida := (cAlias)->AH_UNIMED
			oUM:csDsUnidadeMedida := IIf(!Empty((cAlias)->AH_DESCPO), (cAlias)->AH_DESCPO, (cAlias)->AH_UMRES)

			aAdd(aReg, (cAlias)->REG)
			aAdd(oWsUm:oWSlstUnidadeMedida:oWSUnidadeMedidaDTO, oUM:Clone())

			(cAlias)->(DbSkip())

		EndDo

		CloseSQL(cAlias)



		If !Empty(oWsUm:oWSlstUnidadeMedida:oWSUnidadeMedidaDTO)
			//faz a chamada do metodo de integraùùo de bancos
			aRetorno := oWsUm:ProcessarUnidadeMedida()
			If aRetorno[1]
				//registra o retorno de processar moeda
				fWsLogRet(oWsUm:oWSProcessarUnidadeMedidaResult:oWSlstWbtLogDTO:oWSWbtLogDTO, oLog, "SAH", aReg, @nProc,bEmp, aRetorno[2])
			Else
				fSoapFault(oLog)
			EndIf
		EndIf

		fFimLog("Unidades Medidas - " + cValToChar(nProc) + ' processados - ' + Time())
	End Sequence
	ErrorBlock(oError)
Return nProc

/*/{Protheus.doc} nCondPgto
//Efetua a integraùùo das condiùùes de pagamento
@author Administrator
@since 06/08/2018
@version 1.0
@param oProcess, object, Objeto de processamento tNewProcess
@type function
/*/
Static Function nCondPgto(oProcess)
	Local cAlias 	:= GetNextAlias()
	Local cAliasAux := GetNextAlias()
	Local cQuery 	:= ""
	Local cCod 		:= ''
	Local oWsCpg 	:= WSCondicaoPagamento():New()
	Local oCndPg 	:= Nil
	Local nProc 	:= 0
	Local oLog 		:= FwParLog():New("PAR001", "ProcessarCondicaoPagamento")
	Local aReg 		:= {}
	Local oError 	:= ErrorBlock({|e| fErrorPar(e:ErrorStack, 'SE4', @oLog, @cCod)})
	Local aRetorno  := {}
	Local nEmp		:= NIL

	Begin Sequence
		fIniLog("Condiùùes de Pagamentos")

		// Adequaùùo de cadastros anteriores ù integraùùo com a Paradigma \\
		If GetMv("MV_XPARCAD") == 1
			SetRegua2(@oProcess, 0)
			IncRegua2(@oProcess, "Adicionando Categorias cadastradas a integraùùo")

			cQuery += " select R_E_C_N_O_ REG, E4_FILIAL, E4_CODIGO, E4_DESCRI "
			cQuery += " from " + RetSqlTab("SE4")
			cQuery += " where D_E_L_E_T_ = ' ' "
			cQuery += " and E4_MSBLQL <> '1' "
			cQuery += " and E4_XINTPA = '' "

			OpenSQL(cAliasAux, cQuery)

			SetRegua2(@oProcess, (cAliasAux)->(nLastRec(cAliasAux)))

			While (cAliasAux)->(! EoF())
				DbSelectArea("SE4")
				DbSetOrder(1)
				DbGoTo((cAliasAux)->REG)

				RecLock("SE4",.F.)
				SE4->E4_XINTPA := '2'
				MsUnLock()

				(cAliasAux)->(DbSkip())
			EndDo

			CloseSQL(cAliasAux)

			cQuery := ""
		EndIf

		// Integraùùo com a Paradigma \\
		SetRegua2(@oProcess, 0)
		IncRegua2(@oProcess, "Condiùùes de Pagamentos")

		cQuery += " select R_E_C_N_O_ REG, E4_FILIAL, E4_CODIGO, E4_DESCRI "
		cQuery += " from " + RetSqlTab("SE4")
		cQuery += " where D_E_L_E_T_ = ' ' "
		cQuery += " and E4_MSBLQL <> '1' "
		cQuery += " and E4_XINTPA > '1' "

		OpenSQL(cAlias, cQuery)

		SetRegua2(@oProcess, (cAlias)->(nLastRec(cAlias)))

		While (cAlias)->(! EoF())
			/* aFiliais */
			cCod := (cAlias)->E4_FILIAL + (cAlias)->E4_CODIGO
			IncRegua2(@oProcess, "Processando " + (cAlias)->E4_CODIGO)

			oCndPg:= CondicaoPagamento_CondicaoPagamentoDTO():New()
			oCndPg:csCdCondicaoPagamento := (cAlias)->E4_CODIGO
			//oCndPg:csDsCondicaoPagamento := (cAlias)->E4_DESCRI
			oCndPg:csDsCondicaoPagamento := AllTrim(SubStr((cAlias)->E4_DESCRI, 1, 250))
			oCndPg:csCdEmpresa := cGetCodEmp(cEmpAnt, (cAlias)->E4_FILIAL)

			aAdd(aReg, (cAlias)->REG)
			aAdd(oWsCpg:oWSlstCondicaoPagamento:oWSCondicaoPagamentoDTO, oCndPg:Clone())

			(cAlias)->(DbSkip())
		EndDo

		CloseSQL(cAlias)

		If !Empty(oWsCpg:oWSlstCondicaoPagamento:oWSCondicaoPagamentoDTO)
			//faz a chamada do metodo de integraùùo

			aRetorno := oWsCpg:ProcessarCondicaoPagamento()

			If aRetorno[1]
				//registra o retorno de processar
				fWsLogRet(oWsCpg:oWSProcessarCondicaoPagamentoResult:oWSlstWbtLogDTO:oWSWbtLogDTO, oLog, "SE4", aReg, @nProc,nEmp,aRetorno[2])
			Else
				fSoapFault(oLog)
			EndIf
		EndIf

		fFimLog("Condiùùes de Pagamentos - " + cValToChar(nProc) + ' processados - ' + Time())
	End Sequence
	ErrorBlock(oError)
Return nProc

/*/{Protheus.doc} cCtroCusto
//Efetua a integraùùo dos centros de custos
@author Administrator
@since 06/08/2018
@version 1.0
@param oProcess, object, Objeto de processamento tNewProcess
@type function
/*/
Static Function cCtroCusto(oProcess)
	Local cAlias 	:= GetNextAlias()
	Local cQuery 	:= ""
	Local cCod 		:= ''
	Local oWsCdC 	:= WSCentroCusto():New()
	Local nProc 	:= 0
	Local oCdC 		:= Nil
	Local oLog 		:= FwParLog():New("PAR001", "ProcessarCentroCusto")
	Local aReg 		:= {}
	Local oError 	:= ErrorBlock({|e| fErrorPar(e:ErrorStack, 'CTT', @oLog, @cCod)})
	Local aRetorno  := {}
	Local nEmp		:= NIL


	Begin Sequence

		/*
		fIniLog("Centros de Custos")

		// Adequaùùo de cadastros anteriores ù integraùùo com a Paradigma \\
		If GetMv("MV_XPARCAD") == 1
			SetRegua2(@oProcess, 0)
			IncRegua2(@oProcess, "Adicionando Categorias cadastradas a integraùùo")

			cQuery += " select R_E_C_N_O_ REG, CTT_FILIAL, CTT_CUSTO, CTT_DESC01, CTT_BLOQ, D_E_L_E_T_ DEL "
			cQuery += " from " + RetSqlTab("CTT")
			cQuery += " where D_E_L_E_T_ = ' ' "
			cQuery += " and CTT_CLASSE = '2' "
			cQuery += " and CTT_XPARAD = '1' "
			cQuery += " and CTT_XINTPA = '' "

			OpenSQL(cAliasAux, cQuery)

			SetRegua2(@oProcess, (cAliasAux)->(nLastRec(cAliasAux)))

			While (cAliasAux)->(! EoF())
				DbSelectArea("CTT")
				DbSetOrder(1)
				DbGoTo((cAliasAux)->REG)

				RecLock("CTT",.F.)
				CTT->CTT_XINTPA := '2'
				MsUnLock()

				(cAliasAux)->(DbSkip())
			EndDo

			CloseSQL(cAliasAux)

			cQuery := ""
		EndIf
		*/
		// Integraùùo com a Paradigma \\
		SetRegua2(@oProcess, 0)
		IncRegua2(@oProcess, "Centros de Custos")

		cQuery += " select  R_E_C_N_O_ REG, CTT_FILIAL, CTT_CUSTO, CTT_DESC01, CTT_BLOQ, D_E_L_E_T_ DEL "
		cQuery += " from " + RetSqlTab("CTT")
		cQuery += " where D_E_L_E_T_ = ' ' "
		cQuery += " and CTT_CLASSE = '2' "
		cQuery += " and CTT_XINTPA > '1' "
		//cQuery += " and CTT_XPARAD = '1' "

		OpenSQL(cAlias, cQuery)

		SetRegua2(@oProcess, (cAlias)->(nLastRec(cAlias)))

		While (cAlias)->(! EoF())
			/* aFiliais */

			cCod := (cAlias)->CTT_FILIAL + (cAlias)->CTT_CUSTO
			IncRegua2(@oProcess, "Processando " + (cAlias)->CTT_CUSTO)

			oCdC:= CentroCusto_CentroCustoDTO():New()
			oCdC:nbFlAtivo := IIf(((cAlias)->CTT_BLOQ == "1" .Or. !Empty((cAlias)->DEL)), 0, 1)
			oCdC:csCdEmpresa := cGetCodEmp(cEmpAnt, (cAlias)->CTT_FILIAL)
			// oCdC:csCdEmpresa := '09907683000103'
			oCdC:csCdCentroCusto := AllTrim((cAlias)->CTT_CUSTO)
			oCdC:csDsCentroCusto := AllTrim((cAlias)->CTT_DESC01)

			aAdd(aReg, (cAlias)->REG)
			aAdd(oWsCdC:oWSlstCentroCusto:oWSCentroCustoDTO, oCdC:Clone())


			If !Empty(oWsCdC:oWSlstCentroCusto:oWSCentroCustoDTO)
				//faz a chamada do metodo de integraùùo

				aRetorno := oWsCdC:ProcessarCentroCusto()

				If aRetorno[1]
					//registra o retorno de processar
					fWsLogRet(oWsCdC:oWSProcessarCentroCustoResult:oWSlstWbtLogDTO:oWSWbtLogDTO, oLog, "CTT", aReg, @nProc,nEmp, aRetorno[2])

					DbSelectArea("CTT")
					DbSetOrder(1)
					DbGoTo((cAlias)->REG)

				Else
					fSoapFault(oLog)
				EndIf
			EndIf

			nProc++
			(cAlias)->(DbSkip())

		EndDo

		CloseSQL(cAlias)


		fFimLog("Centros de Custos - " + cValToChar(nProc) + ' processados - ' + Time())
	End Sequence
	ErrorBlock(oError)
Return nProc


/*/{Protheus.doc} nCtaContab
//Efetua a integraùùo de Conta Contabil
@author geovani.figueira
@since 06/08/2018
@version 1.0
@param oProcess, object, Objeto de processamento tNewProcess
@type function
/*/
Static Function nCtaContab(oProcess)
	Local cAlias 	:= GetNextAlias()
	Local cAliasAux	:= GetNextAlias()
	Local cQuery 	:= ""
	Local cCod 		:= ''
	Local oWsConta 	:= WSContaContabil():New()
	Local nProc 	:= 0
	Local oConta 	:= Nil
	Local oLog 		:= FwParLog():New("PAR001", "ProcessarContaContabil")
	Local aReg 		:= {}
	Local aRetorno  := {}
	Local bEmp 		:= NIL
	//Local oError 	:= ErrorBlock({|e| fErrorPar(e:ErrorStack, 'CT1', @oLog, @cCod)})

	Begin Sequence
		fIniLog("Conta Contùbil")

		// Adequaùùo de cadastros anteriores ù integraùùo com a Paradigma \\
		If GetMv("MV_XPARCAD") == 1
			SetRegua2(@oProcess, 0)
			IncRegua2(@oProcess, "Adicionando Categorias cadastradas a integraùùo")

			cQuery += " select R_E_C_N_O_ REG, CT1_FILIAL, CT1_CONTA, CT1_DESC01, CT1_CTASUP, CT1_BLOQ, D_E_L_E_T_ DEL "
			cQuery += " from " + RetSqlTab("CT1")
			cQuery += " where D_E_L_E_T_ = ' ' "
			cQuery += " and CT1_XINTPA = '' "

			OpenSQL(cAliasAux, cQuery)

			SetRegua2(@oProcess, (cAliasAux)->(nLastRec(cAliasAux)))

			While (cAliasAux)->(! EoF())
				DbSelectArea("CT1")
				DbSetOrder(1)
				DbGoTo((cAliasAux)->REG)

				RecLock("CT1",.F.)
				CT1->CT1_XINTPA := '2'
				MsUnLock()

				(cAliasAux)->(DbSkip())
			EndDo

			CloseSQL(cAliasAux)

			cQuery := ""
		EndIf

		// Integraùùo com a Paradigma \\
		SetRegua2(@oProcess, 0)
		IncRegua2(@oProcess, "Conta Contùbil")

		cQuery += " select R_E_C_N_O_ REG, CT1_FILIAL, CT1_CONTA, CT1_DESC01, CT1_CTASUP, CT1_BLOQ, CT1_CLASSE, D_E_L_E_T_ DEL "
		cQuery += " from " + RetSqlTab("CT1")
		cQuery += " where D_E_L_E_T_ = ' ' "
		cQuery += " and CT1_XINTPA > '1' "
		cQuery += " and CT1_CLASSE = '2' "
		cQuery += " ORDER BY LEN(CT1_CONTA), CT1_CONTA "

		OpenSQL(cAlias, cQuery)

		SetRegua2(@oProcess, (cAlias)->(nLastRec(cAlias)))

		While (cAlias)->(!EoF())
			cCod := (cAlias)->CT1_FILIAL + (cAlias)->CT1_CONTA
			IncRegua2(@oProcess, "Processando " + (cAlias)->CT1_CONTA)

			oConta := ContaContabil_ContaContabilDTO():New()
			oConta:nbFlAtivo 	 := IIf(((cAlias)->CT1_BLOQ == "1" .Or. !Empty((cAlias)->DEL)), 0, 1)
			oConta:csCdContaContabil := AllTrim((cAlias)->CT1_CONTA)
			oConta:csDsContaContabil := oConta:csCdContaContabil + ' - ' + AllTrim((cAlias)->CT1_DESC01)

			/*If !Empty((cAlias)->CT1_CTASUP) .AND. (cAlias)->CT1_CLASSE <> "1"
				oConta:csCdContaContabilPai := AllTrim((cAlias)->CT1_CTASUP)
			EndIf*/

			oConta:csCdEmpresa 	 := cGetCodEmp(cEmpAnt, (cAlias)->CT1_FILIAL)

			aAdd(aReg, (cAlias)->REG)
			aAdd(oWsConta:oWSlstContaContabil:oWSContaContabilDTO, oConta:Clone())

			(cAlias)->(DbSkip())
		EndDo

		CloseSQL(cAlias)

		If !Empty(oWsConta:oWSlstContaContabil:oWSContaContabilDTO)
			//faz a chamada do mùtodo de integraùùo

			aRetorno := oWsConta:ProcessarContaContabil()

			If aRetorno[1]
				//registra o retorno de processar
				fWsLogRet(oWsConta:oWSProcessarContaContabilResult:oWSlstWbtLogDTO:oWSWbtLogDTO, oLog, "CT1", aReg, @nProc,bEmp, aRetorno[2])
			Else
				fSoapFault(oLog)
			EndIf
		EndIf

		fFimLog("Conta Contùbil - " + cValToChar(nProc) + ' processados - ' + Time())
	End Sequence
	//ErrorBlock(oError)
Return nProc

/*/{Protheus.doc} aProdutos
//Efetua a integraùùo produtos
@author Administrator
@since 06/08/2018
@version 1.0
@param oProcess, object, Objeto de processamento da tNewProcess
@Return aReg, lista de recnos processados (reuso na segunda unidade de medida)
@type function
/*/
Static Function aProdutos(oProcess)
	Local oWsProduto := WSParProduto():New()
	Local oProduto 	 := Nil
	Local cQuery 	 := ""
	Local cCod 		 := ""
	Local cAlias 	 := GetNextAlias()
	Local cAliasAux  := GetNextAlias()
	Local oLog		 := FwParLog():New("PAR001", "ProcessarProduto")
	Local aReg		 := {}
	Local nCM1		 := 0
	Local oError 	 := ErrorBlock({|e| fErrorPar(e:ErrorStack, 'SB1', @oLog, @cCod)})
	Local aRetorno   := {}
	Local bEmp 		 := NIL

	Begin Sequence
		fIniLog("Produtos")

		// Adequaùùo de cadastros anteriores ù integraùùo com a Paradigma \\
		If GetMv("MV_XPARCAD") == 1
			SetRegua2(@oProcess, 0)
			IncRegua2(@oProcess, "Adicionando Categorias cadastradas a integraùùo")

			If "MSSQL" $ AllTrim(TcGetDb())
				cQuery += " select Top(100) * "
			Else
				cQuery += " select R_E_C_N_O_ REG, *"
			EndIf

			cQuery += " from " + RetSqlTab("SB1")
			cQuery += " where D_E_L_E_T_ = ' ' "
			cQuery += " and B1_XINTPA = '' "

			If AllTrim(TcGetDb()) == "ORACLE"
				cQuery += " AND ROWNUM <= 100 "
			EndIf

			OpenSQL(cAliasAux, cQuery)

			SetRegua2(@oProcess, (cAliasAux)->(nLastRec(cAliasAux)))

			While (cAliasAux)->(! EoF())
				DbSelectArea("SB1")
				DbSetOrder(1)
				DbGoTo((cAliasAux)->REG)

				RecLock("SB1",.F.)
				SB1->B1_XINTPA := '2'
				MsUnLock()

				(cAliasAux)->(DbSkip())
			EndDo

			CloseSQL(cAliasAux)

			cQuery := ""
		EndIf

		// Integraùùo com a Paradigma \\
		SetRegua2(@oProcess, 0)
		IncRegua2(@oProcess, "Buscando Produtos")

		If "MSSQL" $ AllTrim(TcGetDb())
			//cQuery += " select Top(100) * "
			cQuery += " select * "
		Else
			cQuery += " select * "
		EndIf

		cQuery += " from " + RetSqlTab("SB1")
		cQuery += " where D_E_L_E_T_ = ' ' "
		cQuery += " and B1_XINTPA > '1' "

		If AllTrim(TcGetDb()) == "ORACLE"
			cQuery += " AND ROWNUM <= 100 "
		EndIf

		OpenSQL(cAlias, cQuery)

		SetRegua2(@oProcess, 500)

		/* aFiliais */
		IncRegua2(@oProcess, "Registrando produto " + (cAlias)->B1_COD)

		//nCM1 := POSICIONE('SB2', 1, xFilial('SB2')+(cAlias)->B1_COD+(cAlias)->B1_LOCPAD, 'B2_CM1')

		While (cAlias)->(! EoF())
			cCod := (cAlias)->B1_COD
			If EncodeUTF8(AllTrim((cAlias)->B1_DESC), "cp1252") == Nil
				conout(' Caracter invùlido na descriùùo do produto ' + AllTrim((cAlias)->B1_COD))
				Alert(' Caracter invùlido na descriùùo do produto ' + AllTrim((cAlias)->B1_COD))
				oLog:novoLog()
				oLog:Retorno := 0
				oLog:Origem := cCod
				oLog:MsgLog := 'Caracter invùlido na descriùùo do produto ' + AllTrim((cAlias)->B1_COD)
				oLog:SoapFault := 'Caracter invùlido na descriùùo do produto ' + AllTrim((cAlias)->B1_COD)
				oLog:Tstamp := FwTimeStamp(3)
				oLog:SalvaObj('SB1')
				oLog:novoLog()
				(cAlias)->(DbSkip())
				LOOP
			EndIf

			IncRegua2(@oProcess, "Registrando produto " + (cAlias)->B1_COD)

			nCM1 := 0

			SB2->(DbSetOrder(1))
			If SB2->(DbSeek(FwFilial("SB2") + (cAlias)->B1_COD + (cAlias)->B1_LOCPAD))
				nCM1 := SB2->B2_CM1
			EndIf

			oProduto := Produto_ProdutoDTO():New()
			//ALTERADO WALTER 29/03/2022
			//oProduto:nnSituacaoProduto := IIf((cAlias)->B1_XINTPA == '4', 0, 1)
			oProduto:nnSituacaoProduto := IIf((cAlias)->B1_MSBLQL == '1', 0, 1) //
			//FIM
			oProduto:ndQtConsumoMedio := nCM1
			oProduto:csCdUnidadeMedida := (cAlias)->B1_UM
			oProduto:csCdEmpresa := cGetCodEmp(cEmpAnt, (cAlias)->B1_FILIAL)
			oProduto:csCdProduto := AllTrim((cAlias)->B1_COD)
			oProduto:csDsProduto := AllTrim((cAlias)->B1_DESC)+'-'+AllTrim((cAlias)->B1_COD)
			oProduto:csDsDetalhe := AllTrim((cAlias)->B1_DESC)
			oProduto:csCdClasse := (cAlias)->B1_GRUPO
			oProduto:ndVlPeso := (cAlias)->B1_PESO

			//lstProdutoContaContabil
			//ProdutoContaContabilDTO:
			//B1_CONTA

			aAdd(aReg, (cAlias)->R_E_C_N_O_)

			aAdd(oWsProduto:oWSlstProduto:oWSParProdutoDTO, oProduto:Clone())

			If !Empty(oWsProduto:oWSlstProduto:oWSParProdutoDTO)
				//faz a chamada da funùùo do web service de moedas

				aRetorno := oWsProduto:ProcessarProduto()

				If  aRetorno[1]
					//registra o retorno de processar moeda
					fWsLogRet(oWsProduto:OWSProcessarProdutoRESULT:OWSLSTWBTLOGDTO:OWSWBTLOGDTO, oLog, "SB1", @aReg,bemp,.f.,aRetorno[2])


					DbSelectArea("SB1")
					DbSetOrder(1)
					DbGoTo((cAlias)->R_E_C_N_O_)

					RecLock("SB1",.F.)
					SB1->B1_XINTPA := '1'
					MsUnLock()

				Else
					fSoapFault(oLog)
					aReg := {}
				EndIf
			EndIf

			(cAlias)->(DbSkip())
		EndDo
		CloseSQL(cAlias)


		fFimLog("Produtos - " + cValToChar(Len(aReg)/2) + ' processados - ' + Time())
	End Sequence
	ErrorBlock(oError)
Return aReg


/*/{Protheus.doc} nSgUnidMed
//Efetua a integraùùo da segunda unidade de medida (Unidade Conversùo)
@author Administrator
@since 06/08/2018
@version 1.0
@param oProcess, object, Objeto de processamento tNewProcess
@param aReg, array, Lista de Recnos da SB1 ja processados
@type function
/*/
Static Function nSgUnidMed(oProcess, aReg)
	Local aAreas := SB1->(GetArea())
	Local cCod 	 := ""
	Local oWsSegUm := WSProdutoUnidadeConversao():New()
	Local oSegUm := Nil
	Local nProc  := 0
	Local oLog 	 := FwParLog():New("PAR001", "ProcessarProdutoUnidadeConversao")
	Local nX 	 := 0
	Local nQtd 	 := 0
	Local aProc  := {}
	Local oError := ErrorBlock({|e| fErrorPar(e:ErrorStack, 'SB1', @oLog, @cCod)})

	Default aReg := {}

	Begin Sequence
		fIniLog("Segunda Unidade Medida")

		// Integraùùo com a Paradigma \\
		SetRegua2(@oProcess, 0)
		IncRegua2(@oProcess, "Segunda Unidade Medida")
		SetRegua2(@oProcess, Len(aReg))

		for nX := 1 to Len(aReg)

			//posiciona na SB1 para os calculos da funùùo ConvUM
			SB1->(DbGoTo(aReg[nX]))
			cCod := SB1->B1_COD
			nQtd := ConvUm(SB1->B1_COD, 1, 0, 2)
			//caso nao tenha segunda unidade de medida, nao precisa integrar
			If Empty(SB1->B1_SEGUM) .Or. SB1->B1_SEGUM == SB1->B1_UM .Or. nQtd == 0
				Loop
			EndIf

			aAdd(aProc, aReg[nX])
			IncRegua2(@oProcess, "Processando " + SB1->B1_SEGUM)

			oSegUm := ProdutoUnidadeConversao_ProdutoUnidadeConversaoDTO():New()
			oSegUm:csCdProduto := AllTrim(SB1->B1_COD)
			oSegUm:ndQtConversao := nQtd
			oSegUm:csCdUnidadeMedidaOrigem := SB1->B1_UM
			oSegUm:csCdUnidadeMedidaDestino := SB1->B1_SEGUM

			aAdd(oWsSegUm:oWSlstProdutoUnidadeConversao:oWSProdutoUnidadeConversaoDTO, oSegUm:Clone())

		next nX

		SB1->(RestArea(aAreas))

		If !Empty(oWsSegUm:oWSlstProdutoUnidadeConversao:oWSProdutoUnidadeConversaoDTO)
			//faz a chamada do mùtodo de integraùùo
			If oWsSegUm:ProcessarProdutoUnidadeConversao()
				//registra o retorno de processar
				fWsLogRet(oWsSegUm:oWSProcessarProdutoUnidadeConversaoResult:oWSlstWbtLogDTO:oWSWbtLogDTO, oLog, "SB1", aProc, @nProc)
			Else
				fSoapFault(oLog)
			EndIf
		EndIf

		fFimLog("Segunda Unidade Medida - " + cValToChar(nProc) + ' processados - ' + Time())
	End Sequence
	ErrorBlock(oError)
Return nProc

Static Function nPrcPrdUm(oProcess, aReg)

	Local aAreas := SB1->(GetArea())
	Local cCod 	 := ""
	Local oWsPrdUm := WSProdutoUnidadeMedida():New()
	Local oPrdUm := Nil
	Local nProc  := 0
	Local oLog 	 := FwParLog():New("PAR001", "ProcessarProdutoUnidadeMedida")
	Local nX 	 := 0
	Local aProc  := {}
	Local oError := ErrorBlock({|e| fErrorPar(e:ErrorStack, 'SB1', @oLog, @cCod)})
	Local aRetorno := {}

	default aReg := {}

	Begin Sequence
		fIniLog("Produto Unidade Medida")

		// Integraùùo com a Paradigma \\
		SetRegua2(@oProcess, 0)
		IncRegua2(@oProcess, "Produto Unidade Medida")
		SetRegua2(@oProcess, Len(aReg))

		for nX := 1 to Len(aReg)

			//posiciona na SB1
			SB1->(DbGoTo(aReg[nX]))
			cCod := AllTrim(SB1->B1_COD) + SB1->B1_UM

			aAdd(aProc, aReg[nX])
			IncRegua2(@oProcess, "Processando " + cCod)

			oPrdUm := ProdutoUnidadeMedida_ProdutoUnidadeMedidaDTO():New()
			oPrdUm:csCdProduto := AllTrim(SB1->B1_COD)
			oPrdUm:csCdUnidadeMedida := SB1->B1_UM

			aAdd(oWsPrdUm:oWSlstProdutoUnidadeMedida:oWSProdutoUnidadeMedidaDTO, oPrdUm:Clone())

		next nX

		SB1->(RestArea(aAreas))

		If Len(aReg) > 0
			If !Empty(oWsPrdUm:oWSlstProdutoUnidadeMedida:oWSProdutoUnidadeMedidaDTO)
				aRetorno:=oWsPrdUm:ProcessarProdutoUnidadeMedida()
				//faz a chamada do mùtodo de integraùùo
				If aRetorno[1]
					//registra o retorno de processar
					fWsLogRet(oWsPrdUm:oWSProcessarProdutoUnidadeMedidaResult:oWSlstWbtLogDTO:oWSWbtLogDTO, oLog, "SB1", aProc, @nProc)
				Else
					fSoapFault(oLog)
				EndIf
			EndIf
		endif

		fFimLog("Produto Unidade Medida - "+ cValToChar(nProc) + ' processados - ' + Time())
	End Sequence
	ErrorBlock(oError)
Return nProc


/*/{Protheus.doc} nRetFornec
//Integra os Retorno de Fornecedor da paradigma
@author geovani.figueira
@since 06/08/2018
@version 1.0
@param oProcess, object, objeto tNewProcess
@type function
/*/
Static Function nRetFornec(oProcess)

	Local oLog 	 := FwParLog():New("PAR001", "RetornarEmpresaSemDePara")
	Local oWsEmp := WSEmpresa():New()
	Local nProc	 := 0
	Local cReg 	 := ''
	Local cCodMun := ''
	Local cQuery := ''
	Local cAlias := GetNextAlias()
	Local oError := ErrorBlock({|e| fErrorPar(e:ErrorStack, 'SA2', @oLog, @cReg)})
	Local cXmlErro as char
	Local oModel as object
	Local cCGC as char
	Local cFilSA2 := FWxFilial('SA2')
	Local  aEmpresaDTO  := array(57)
	Local aCrcHistoricoDTO
	Local aEmpresaBancoDTO
	Local aEmpresaClasseDTO
	Local aEmpresaContatoDTO
	Local aEmpXml:={}
	Local aForXml:={}
	Local nX := 0
	Local x1 := 0
	Local nY:=1
	Local oForNew

	Private lMsErroAuto := .F.
	Private oFornec

	Begin Sequence
		fIniLog("Retorno de Fornecedores")

		aRetEmp := oWsEmp:RetornarEmpresaSemDePara()
		cXmlEmp := aRetEmp[2]
		If aRetEmp[1]

			//oWsEmp:oWSRetornarEmpresaSemDePara Result:oWSEmpresaDTO, .T., oLog, @nProc
			//oFornec := oWsEmp:oWSRetornarEmpresaVencedoraSemDeParaResult:oWSEmpresaDTO
			oFornec := oWsEmp:oWSRetornarEmpresaSemDeParaResult:oWSEmpresaDTO

			For nX := 1 To Len(oFornec)

				cReg 				:= cValToChar(oFornec[nX]:nnCdEmpresaWbc)
				oForNew				:= oFornec[nX]
				aEmpXml				:= ClassDataArr(oForNew,.F.)
				For nY:=1 to Len(aEmpXml)
					aAdd(aForXml,UPPER(aEmpXml[nY][1]))
				Next nY
				lMsErroAuto 		:= .F.
				cXmlErro			:= ''
				aEmpresaBancoDTO 	:= {}
				aEmpresaContatoDTO	:= {}
				aEmpresaClasseDTO 	:= {}
				aCrcHistoricoDTO    := {}
				oModel				:= nil
				cCGC				:= PADR(oFornec[nX]:csNrCnpj,Len(SA2->A2_CGC))

				SA2->(DbSetOrder(3)) //A2_FILIAL+A2_CGC
				If SA2->(mSSeek(cFilSA2+cCGC)) //.And. cReg $ SA2->A2_XEMPWBC
					conout('Fornecedor ' + cReg + ' jù cadastrado.')
					LOOP
				EndIf

				nProc++

				aEmpresaDTO[1] := oFornec[nX]:NNCDEMPRESAWBC
				aEmpresaDTO[2] := oFornec[nX]:NnCdIdioma
				aEmpresaDTO[3] := oFornec[nX]:NnCdPorte
				aEmpresaDTO[4] := oFornec[nX]:NnCdSituacao
				aEmpresaDTO[5] := oFornec[nX]:NnCdTipo
				aEmpresaDTO[6] := oFornec[nX]:NnCdTipoCadastroMap
				aEmpresaDTO[7] := oFornec[nX]:NnIdPerfilTributario
				aEmpresaDTO[8] := oFornec[nX]:NnIdSuperSimples
				aEmpresaDTO[9] := oFornec[nX]:NnIdTipoPessoa
				//COR001
				aEmpresaDTO[10] := Iif(nFindCarc(aForXml,'NnIdTipoSocio')<1,0,oFornec[nX]:NnIdTipoSocio)//contType2(oFornec[nX]:NnIdTipoSocio)
				aEmpresaDTO[11] := oFornec[nX]:NnNrAutoAvaliacao
				aEmpresaDTO[12] := oFornec[nX]:CSCDATIVIDADEMAP
				aEmpresaDTO[13] := oFornec[nX]:CsCdCnae
				aEmpresaDTO[14] := oFornec[nX]:csNrCnpj //oFornec[nX]:csCdEmpresa
				aEmpresaDTO[15] := oFornec[nX]:csCdEmpresaCliente
				aEmpresaDTO[16] := oFornec[nX]:csCdEmpresaEnvio
				aEmpresaDTO[17] := Iif(nFindCarc(aForXml,'csCdModeloLoja') <1,'',oFornec[nX]:csCdModeloLoja)//contType1(oFornec[nX]:csCdModeloLoja)
				aEmpresaDTO[18] := oFornec[nX]:CSCDMOEDA
				aEmpresaDTO[19] := oFornec[nX]:CsCdNaturezaJuridica
				aEmpresaDTO[20] := Iif(nFindCarc(aForXml,'csCdPadraoArquitetura') <1,'',oFornec[nX]:csCdPadraoArquitetura)//contType1(oFornec[nX]:csCdPadraoArquitetura)
				aEmpresaDTO[21] := Iif(nFindCarc(aForXml,'CsCdTipoBeneficio') <1,'',oFornec[nX]:CsCdTipoBeneficio)//contType1(oFornec[nX]:CsCdTipoBeneficio)
				aEmpresaDTO[22] := Iif(nFindCarc(aForXml,'csCdTipoLoja') <1,'',oFornec[nX]:csCdTipoLoja)//contType1(oFornec[nX]:csCdTipoLoja)
				aEmpresaDTO[23] := Iif(nFindCarc(aForXml,'csCdUsarioHomologador') <1,'',oFornec[nX]:csCdUsarioHomologador)//contType1(oFornec[nX]:csCdUsarioHomologador)
				aEmpresaDTO[24] := Iif(nFindCarc(aForXml,'csDsCep') <1,'',oFornec[nX]:csDsCep)//contType1(oFornec[nX]:csDsCep)
				aEmpresaDTO[25] := Iif(nFindCarc(aForXml,'csDsEmailContato') <1,'',oFornec[nX]:csDsEmailContato)//contType1(oFornec[nX]:csDsEmailContato)
				aEmpresaDTO[26] := Iif(nFindCarc(aForXml,'csDsEndereco') <1,'',oFornec[nX]:csDsEndereco)//contType1(oFornec[nX]:csDsEndereco)
				aEmpresaDTO[27] := Iif(nFindCarc(aForXml,'csDsEnderecoComplemento') <1,'',oFornec[nX]:csDsEnderecoComplemento)//contType1(oFornec[nX]:csDsEnderecoComplemento)
				aEmpresaDTO[28] := Iif(nFindCarc(aForXml,'csDsUrl') <1,'',oFornec[nX]:csDsUrl)//contType1(oFornec[nX]:csDsUrl)
				aEmpresaDTO[29] := Iif(nFindCarc(aForXml,'csNmApelido') <1,'',oFornec[nX]:csNmApelido)//contType1(oFornec[nX]:csNmApelido)
				aEmpresaDTO[30] := Iif(nFindCarc(aForXml,'csNmBairro') <1,'',oFornec[nX]:csNmBairro)//contType1(oFornec[nX]:csNmBairro)
				aEmpresaDTO[31] := Iif(nFindCarc(aForXml,'csNmCidade') <1,'',oFornec[nX]:csNmCidade)//contType1(oFornec[nX]:csNmCidade)
				aEmpresaDTO[32] := Iif(nFindCarc(aForXml,'csNmContato') <1,'',oFornec[nX]:csNmContato)//contType1(oFornec[nX]:csNmContato)
				aEmpresaDTO[33] := Iif(nFindCarc(aForXml,'csNmEmpresa') <1,'',oFornec[nX]:csNmEmpresa)//contType1(oFornec[nX]:csNmEmpresa)
				aEmpresaDTO[34] := Iif(nFindCarc(aForXml,'csNmFantasia') <1,'',oFornec[nX]:csNmFantasia)//contType1(oFornec[nX]:csNmFantasia)
				aEmpresaDTO[35] := Iif(nFindCarc(aForXml,'csNrCelular') <1,'',oFornec[nX]:csNrCelular)//contType1(oFornec[nX]:csNrCelular)
				aEmpresaDTO[36] := Iif(nFindCarc(aForXml,'csNrCnpj') <1,'',oFornec[nX]:csNrCnpj)//contType1(oFornec[nX]:csNrCnpj)
				aEmpresaDTO[37] := Iif(nFindCarc(aForXml,'csNrCnpjMatriz') <1,'',oFornec[nX]:csNrCnpjMatriz)//contType1(oFornec[nX]:csNrCnpjMatriz)
				aEmpresaDTO[38] := Iif(nFindCarc(aForXml,'csNrEndereco') <1,'',oFornec[nX]:csNrEndereco)//contType1(oFornec[nX]:csNrEndereco)
				aEmpresaDTO[39] := Iif(nFindCarc(aForXml,'csNrFax') <1,'',oFornec[nX]:csNrFax)//contType1(oFornec[nX]:csNrFax)
				aEmpresaDTO[40] := Iif(nFindCarc(aForXml,'csNrInscricaoEstadual') <1,'',oFornec[nX]:csNrInscricaoEstadual)//contType1(oFornec[nX]:csNrInscricaoEstadual)
				aEmpresaDTO[41] := Iif(nFindCarc(aForXml,'csNrInscricaoMunicial') <1,'',oFornec[nX]:csNrInscricaoMunicial)//contType1(oFornec[nX]:csNrInscricaoMunicial)
				aEmpresaDTO[42] := Iif(nFindCarc(aForXml,'csNrInscricaoMunicipal') <1,'',oFornec[nX]:csNrInscricaoMunicipal)//contType1(oFornec[nX]:csNrInscricaoMunicipal)
				aEmpresaDTO[43] := Iif(nFindCarc(aForXml,'csNrTelefone') <1,'',oFornec[nX]:csNrTelefone)//contType1(oFornec[nX]:csNrTelefone)
				aEmpresaDTO[44] := Iif(nFindCarc(aForXml,'csSgEstado') <1,'',oFornec[nX]:csSgEstado)//contType1(oFornec[nX]:csSgEstado)
				aEmpresaDTO[45] := Iif(nFindCarc(aForXml,'csSgGrupoConta') <1,'',oFornec[nX]:csSgGrupoConta)//contType1(oFornec[nX]:csSgGrupoConta)
				aEmpresaDTO[46] := Iif(nFindCarc(aForXml,'csSgPais')<1,0,oFornec[nX]:csSgPais)//contType1(oFornec[nX]:csSgPais)
				aEmpresaDTO[47] := Iif(nFindCarc(aForXml,'ctDtCadastro') <1,'',oFornec[nX]:ctDtCadastro)//contType1(oFornec[nX]:ctDtCadastro)
				aEmpresaDTO[48] := Iif(nFindCarc(aForXml,'ctDtInicioAtividade') <1,'',oFornec[nX]:ctDtInicioAtividade)//contType1(oFornec[nX]:ctDtInicioAtividade)
				aEmpresaDTO[49] := Iif(nFindCarc(aForXml,'ctDtIntegralizacao') <1,'',oFornec[nX]:ctDtIntegralizacao)//contType1(oFornec[nX]:ctDtIntegralizacao)
				aEmpresaDTO[50] := Iif(nFindCarc(aForXml,'ctDtValidadeCadastro') <1,'',oFornec[nX]:ctDtValidadeCadastro)//contType1(oFornec[nX]:ctDtValidadeCadastro)
				aEmpresaDTO[51] := Iif(nFindCarc(aForXml,'NBFLAREAINFLUENCIA') <1,0,oFornec[nX]:NBFLAREAINFLUENCIA)//contType2(oFornec[nX]:NBFLAREAINFLUENCIA)
				aEmpresaDTO[52] := Iif(nFindCarc(aForXml,'NbFlAtividadeComercial') <1,0,oFornec[nX]:NbFlAtividadeComercial)//contType2(oFornec[nX]:NbFlAtividadeComercial)
				aEmpresaDTO[53] := Iif(nFindCarc(aForXml,'NbFlAtividadeIndustrial') <1,0,oFornec[nX]:NbFlAtividadeIndustrial)//contType2(oFornec[nX]:NbFlAtividadeIndustrial)
				aEmpresaDTO[54] := Iif(nFindCarc(aForXml,'NbFlAtividadeServico') <1,0,oFornec[nX]:NbFlAtividadeServico)//contType2(oFornec[nX]:NbFlAtividadeServico)
				aEmpresaDTO[55] := Iif(nFindCarc(aForXml,'NdVlCapitalIntegralizado') <1,0,oFornec[nX]:NdVlCapitalIntegralizado)//contType2(oFornec[nX]:NdVlCapitalIntegralizado)
				aEmpresaDTO[56] := Iif(nFindCarc(aForXml,'NdVlCapitalSocial') <1,0,oFornec[nX]:NdVlCapitalSocial)//contType2(oFornec[nX]:NdVlCapitalSocial)
				aEmpresaDTO[57] := Iif(nFindCarc(aForXml,'NdVlPatrimonioLiquido') <1,0,oFornec[nX]:NdVlPatrimonioLiquido)//contType2(oFornec[nX]:NdVlPatrimonioLiquido)


				If Len(oFornec[nX]:OWSLSTEMPRESAENDERECOCOBRANCA:OWSEMPRESAENDERECODTO) > 0

					For x1 := 1 To Len(oFornec[nX]:OWSLSTEMPRESAENDERECOCOBRANCA:OWSEMPRESAENDERECODTO)

					next
				Endif


				cCodMun := POSICIONE('CC2', 4, xFilial('CC2')+oFornec[nX]:csSgEstado+PADR(oFornec[nX]:csNmCidade,tamsx3("CC2_MUN")[1]), 'CC2_CODMUN')

				cQuery := " SELECT YA_CODGI, CCH_CODIGO "
				cQuery += " FROM " + RetSqlTab("SYA") + ", " + RetSqlTab("CCH")
				cQuery += " WHERE " + RetSqlCond("SYA")
				cQuery += " AND " + RetSqlCond("CCH")
				cQuery += " AND YA_PAISDUE = '" + oFornec[nX]:csSgPais + "' "
				cQuery += " AND YA_DESCR = CCH_PAIS "

				OpenSQL(cAlias, cQuery)

				oModel := FWLoadModel('MATA020')

				oModel:SetOperation(3)
				oModel:Activate()

				//Cabeùalho
				oModel:SetValue('SA2MASTER','A2_COD' ,SubStr(oFornec[nX]:csNrCnpj,1,TamSx3("A2_COD")[1]))
				//oModel:SetValue('SA2MASTER','A2_LOJA' ,cLoja)
				oModel:SetValue('SA2MASTER','A2_NOME' ,  SUBSTR(ALLTRIM(oFornec[nX]:csNmEmpresa),1,tamsx3('A2_NOME')[1]))
				oModel:SetValue('SA2MASTER','A2_NREDUZ' ,SUBSTR(ALLTRIM(oFornec[nX]:csNmFantasia),1,tamsx3('A2_NREDUZ')[1]))

				IF Empty(oFornec[nX]:csNrInscricaoEstadual)

					oModel:LoadValue('SA2MASTER','A2_INSCR' ,'ISENTO')

				Else

					oModel:LoadValue('SA2MASTER','A2_INSCR' ,oFornec[nX]:csNrInscricaoEstadual)

				Endif

				IF Empty(oFornec[nX]:csNrInscricaoMunicipal)

					oModel:SetValue('SA2MASTER','A2_INSCRM' ,'ISENTO')

				Else

					oModel:SetValue('SA2MASTER','A2_INSCRM', oFornec[nX]:csNrInscricaoMunicipal)

				Endif
				oModel:SetValue('SA2MASTER','A2_DTINIV' ,StoD(Left(StrTran(oFornec[nX]:ctDtInicioAtividade, "-", ""), 8)))
				oModel:SetValue('SA2MASTER','A2_DDD' ,SUBSTR(oFornec[nX]:csNrTelefone,1,2))
				oModel:SetValue('SA2MASTER','A2_TEL' ,SUBSTR(oFornec[nX]:csNrTelefone,3,9))
				oModel:SetValue('SA2MASTER','A2_XTEL' ,SUBSTR(oFornec[nX]:csNrTelefone,3,9))
				oModel:LoadValue('SA2MASTER','A2_END' ,SUBSTR(ALLTRIM(oFornec[nX]:csDsEndereco),1,tamsx3('A2_END')[1]))
				oModel:SetValue('SA2MASTER','A2_COMPLEM' ,SUBSTR(alltrim(oFornec[nX]:csDsEnderecoComplemento),1,tamsx3('A2_COMPLEM')[1]))
				oModel:SetValue('SA2MASTER','A2_EMAIL' ,oFornec[nX]:csDsEmailContato)
				oModel:SetValue('SA2MASTER','A2_BAIRRO' ,SUBSTR(oFornec[nX]:csNmBairro,1,tamsx3('A2_BAIRRO')[1]))
				oModel:SetValue('SA2MASTER','A2_EST' , oFornec[nX]:csSgEstado)
				oModel:SetValue('SA2MASTER','A2_CODPAIS' , "01058")
				//oModel:SetValue('SA2MASTER','A2_COD_MUN',cCodMun)
				oModel:LoadValue('SA2MASTER','A2_COD_MUN',ALLTRIM(cCodMun))
				oModel:SetValue('SA2MASTER','A2_MUN' ,oFornec[nX]:csNmCidade)
				oModel:SetValue('SA2MASTER','A2_TIPO' , IIf(oFornec[nX]:nnIdTipoPessoa == 1, "J", "F"))
				oModel:SetValue('SA2MASTER','A2_CGC' ,oFornec[nX]:csNrCnpj) //oFornec[nX]:csNrCnpj
				//oModel:SetValue('SA2MASTER','A2_MSBLQL' ,'1'  )

				oModel:SetValue('SA2MASTER','A2_CONTA',  "2001010010" )

				oModel:SetValue('SA2MASTER','A2_RECISS' ,"N")
				oModel:SetValue('SA2MASTER','A2_RECINSS' ,"N")
				oModel:SetValue('SA2MASTER','A2_RECPIS' ,"1")
				oModel:SetValue('SA2MASTER','A2_RECCOFI' ,"1")
				oModel:SetValue('SA2MASTER','A2_RECCSLL' ,"1")

				oModel:SetValue('SA2MASTER','A2_MSBLQL' ,iif(oFornec[nX]:NNCDSITUACAO != 1, '1', '2'))

				oModel:SetValue('SA2MASTER','A2_XMOTBLQ' ,padr('Fornecedor portal paradigma',GETSX3CACHE("A2_XMOTBLQ","X3_TAMANHO")))
				oModel:SetValue('SA2MASTER','A2_XMOTDBL' ,padr('Fornecedor portal paradigma',GETSX3CACHE("A2_XMOTDBL","X3_TAMANHO")))
				oModel:SetValue('SA2MASTER','A2_CEP' ,StrTran(oFornec[nX]:csDsCep, "-", ""))
				oModel:SetValue('SA2MASTER','A2_XINTPA' ,'2') // Depois de alterar o fonte para retornar todo o xml de empresa alterar para 2.
				//oModel:SetValue('SA2MASTER','A2_XTPPRST' ,'2')
				oModel:SetValue('SA2MASTER','A2_XEMPWBC' ,cValToChar(oFornec[nX]:nnCdEmpresaWbc))

				If Len(oFornec[nX]:oWSlstEmpresaBanco:oWSEmpresaBancoDTO) > 0

					oModel:SetValue('SA2MASTER','A2_BANCO' ,oFornec[nX]:oWSlstEmpresaBanco:oWSEmpresaBancoDTO[1]:csCdBanco)
					oModel:SetValue('SA2MASTER','A2_AGENCIA' ,oFornec[nX]:oWSlstEmpresaBanco:oWSEmpresaBancoDTO[1]:csCdAgencia)
					oModel:SetValue('SA2MASTER','A2_NUMCON' ,oFornec[nX]:oWSlstEmpresaBanco:oWSEmpresaBancoDTO[1]:csCdContaCorrente)
					oModel:SetValue('SA2MASTER','A2_DVCTA' ,oFornec[nX]:oWSlstEmpresaBanco:oWSEmpresaBancoDTO[1]:csCdContaDigito)

					For x1 := 1 to len(oFornec[nX]:oWSlstEmpresaBanco:oWSEmpresaBancoDTO)
						aadd(aEmpresaBancoDTO,{oFornec[nX]:oWSlstEmpresaBanco:oWSEmpresaBancoDTO[x1]:NBFLPRINCIPAL,;
							oFornec[nX]:oWSlstEmpresaBanco:oWSEmpresaBancoDTO[x1]:NNCDTIPOCONTA,;
							oFornec[nX]:oWSlstEmpresaBanco:oWSEmpresaBancoDTO[x1]:csCdAgencia,;
							oFornec[nX]:oWSlstEmpresaBanco:oWSEmpresaBancoDTO[x1]:CSCDAGENCIADIGITO,;
							oFornec[nX]:oWSlstEmpresaBanco:oWSEmpresaBancoDTO[x1]:csCdBanco,;
							oFornec[nX]:oWSlstEmpresaBanco:oWSEmpresaBancoDTO[x1]:csCdContaCorrente,;
							oFornec[nX]:oWSlstEmpresaBanco:oWSEmpresaBancoDTO[x1]:csCdContaDigito,;
							oFornec[nX]:oWSlstEmpresaBanco:oWSEmpresaBancoDTO[x1]:CSCDEMPRESA,;
							oFornec[nX]:oWSlstEmpresaBanco:oWSEmpresaBancoDTO[x1]:CSCDPAIS,;
							oFornec[nX]:oWSlstEmpresaBanco:oWSEmpresaBancoDTO[x1]:CSNMTITULAR})
					next x1
				EndIf


				If Len(oFornec[nX]:OWSLSTEMPRESACONTATO:OWSEMPRESACONTATODTO) > 0
					For x1 := 1 to len(oFornec[nX]:OWSLSTEMPRESACONTATO:OWSEMPRESACONTATODTO)
						aadd(aEmpresaContatoDTO,{oFornec[nX]:OWSLSTEMPRESACONTATO:OWSEMPRESACONTATODTO[x1]:NNCDCONTATO,;
							oFornec[nX]:OWSLSTEMPRESACONTATO:OWSEMPRESACONTATODTO[x1]:CSDSCARGO,;
							oFornec[nX]:OWSLSTEMPRESACONTATO:OWSEMPRESACONTATODTO[x1]:CSDSEMAIL,;
							oFornec[nX]:OWSLSTEMPRESACONTATO:OWSEMPRESACONTATODTO[x1]:CSNMCONTATO,;
							oFornec[nX]:OWSLSTEMPRESACONTATO:OWSEMPRESACONTATODTO[x1]:CSNRCELULAR,;
							oFornec[nX]:OWSLSTEMPRESACONTATO:OWSEMPRESACONTATODTO[x1]:CSNRRAMAL,;
							oFornec[nX]:OWSLSTEMPRESACONTATO:OWSEMPRESACONTATODTO[x1]:CSNRTELEFONE})
					next x1
				Endif


				If Len(oFornec[nX]:OWSLSTEMPRESACLASSE:OWSEMPRESACLASSEDTO) > 0
					For x1 := 1 to len(oFornec[nX]:OWSLSTEMPRESACLASSE:OWSEMPRESACLASSEDTO)
						aadd(aEmpresaClasseDTO,{oFornec[nX]:OWSLSTEMPRESACLASSE:OWSEMPRESACLASSEDTO[x1]:CSCDCLASSE,;
							oFornec[nX]:OWSLSTEMPRESACLASSE:OWSEMPRESACLASSEDTO[x1]:CSCDEMPRESA})
					next x1
				Endif


				If Len(oFornec[nX]:OWSLSTDOCUMENTO:OWSCRCHISTORICODTO) > 0
					For x1 := 1 to len(oFornec[nX]:OWSLSTDOCUMENTO:OWSCRCHISTORICODTO)
						aadd(aCrcHistoricoDTO,{oFornec[nX]:OWSLSTDOCUMENTO:OWSCRCHISTORICODTO[x1]:NNCDCRCHISTORICO,;
							oFornec[nX]:OWSLSTDOCUMENTO:OWSCRCHISTORICODTO[x1]:NNCDVERSAO,;
							oFornec[nX]:OWSLSTDOCUMENTO:OWSCRCHISTORICODTO[x1]:NNNRORDEM,;
							oFornec[nX]:OWSLSTDOCUMENTO:OWSCRCHISTORICODTO[x1]:CSDSLINK,;
							oFornec[nX]:OWSLSTDOCUMENTO:OWSCRCHISTORICODTO[x1]:CSNMDOCUMENTO,;
							oFornec[nX]:OWSLSTDOCUMENTO:OWSCRCHISTORICODTO[x1]:CSSGDOCUMENTO,;
							oFornec[nX]:OWSLSTDOCUMENTO:OWSCRCHISTORICODTO[x1]:CTDTHISTORICO})

					next x1
				Endif

				cXml := ToXMlProcessarEmpresa(aEmpresaDTO,aCrcHistoricoDTO,aEmpresaBancoDTO,aEmpresaClasseDTO,aEmpresaContatoDTO,nil,nil,)

				If ( lPosA2_XXML .or. lPosA2_XENVXML ) .and. !Empty(cXml)
					oModel:LoadValue('SA2MASTER','A2_XXML',cXml)
					oModel:SetValue('SA2MASTER','A2_XENVXML','N')
				Endif


				If oModel:VldData()
					oModel:CommitData()
					conout(" Fornecedor " + SA2->A2_COD + SA2->A2_LOJA + " inserido com sucesso!")
					oLog:novoLog()
					oLog:Retorno := 1
					oLog:Origem := cValToChar(oFornec[nX]:nnCdEmpresaWbc)
					oLog:MsgLog := "Fornecedor "+ALLTRIM(oFornec[nX]:csNrCnpj)+ " cÛdigo e loja: "+ SA2->A2_COD + SA2->A2_LOJA + " inserido com sucesso!"
					oLog:SoapFault := "Fornecedor "+ALLTRIM(oFornec[nX]:csNmEmpresa)+" codigo " + SA2->A2_COD + SA2->A2_LOJA + " inserido com sucesso!"
					oLog:Tstamp := FwTimeStamp(3)
					oLog:Token := 'MATA020'
					oLog:cXml  := cXmlEmp
					oLog:SalvaObj('SA2',,cXml)

					If lPosA2_XXML .or. lPosA2_XENVXML
						If !EnvProcEmpresa(cXml,@cXmlErro)
							oLog:novoLog()
							oLog:Retorno := 0
							oLog:Origem := "Portal :" + cValToChar(oFornec[nX]:nnCdEmpresaWbc) + " CNPJ/CPF : "+cCGC
							oLog:MsgLog := 'Falha na integraùùo ProcessaEmpresa. Motivdo do erro  ' + cXmlErro
							oLog:SoapFault := "Fornecedor " + SA2->A2_COD + SA2->A2_LOJA + "  Nao inserido!!"
							oLog:Tstamp := FwTimeStamp(3)
							oLog:Token := 'MATA020'
							oLog:SalvaObj('SA2',,cXml)
							loop
						Endif

						//Vou garantir que estù posicionando no fornecedor correto
						SA2->(DbSetOrder(3))
						If SA2->(MsSeek(cFilSA2+cCGC))
							RecLock('SA2',.F.)
							SA2->A2_XENVXML := 'S'
							SA2->(MsUnLock())
						Endif
					Endif
				Else

					conout(" Fornecedor " + SA2->A2_COD + SA2->A2_LOJA + " falha inclusùo do fornecedor!")
					oLog:novoLog()
					oLog:Retorno := 0
					oLog:Origem := "Portal :" + cValToChar(oFornec[nX]:nnCdEmpresaWbc) + " CNPJ/CPF : "+cCGC
					oLog:MsgLog := oModel:GetErrorMessage()[6]
					oLog:SoapFault := "Fornecedor "+ALLTRIM(oFornec[nX]:csNrCnpj)+ " cÛdigo e loja: "+ SA2->A2_COD + SA2->A2_LOJA + "  Nao inserido!! "+ALLTRIM(oFornec[nX]:csNmEmpresa)
					oLog:Tstamp := FwTimeStamp(3)
					oLog:Token := 'MATA020'
					oLog:cXml  := cXmlEmp
					oLog:SalvaObj('SA2',,cXml)
					VarInfo("Erro",oModel:GetErrorMessage()[6])
				Endif

				oLog:novoLog()
			Next nX
		Else
			fSoapFault(oLog)
			conout(PADR(" ERROR - " +PADR(ProcName(1),10) + " - Tempo " +FWTimeStamp(2) +" - ",60) + 'ERRO no metodo 	RetornarEmpresaSemDePara ')
		EndIf

		fFimLog("Retorno de Fornecedores - " + cValToChar(nProc) + ' processados - ' + Time())
	End Sequence
	ErrorBlock(oError)
Return nProc


/*/{Protheus.doc} nPrcFornec
//Integraùùo de fornecedores
@author Administrator
@since 01/05/2018
@version 2.0
@param oProcess, object, Objeto tNewProcess
@type function
/*/
Static Function nPrcFornec(oProcess)
	Local oWsdl
	Local xRet
	Local lRet
	Local cQuery
	Local aRet // Retorno da integraùùo
	Local aForn := {} // Array de Fornecedor
	Local cAliasAux := GetNextAlias()
	Local oLog := FwParLog():New("PAR001", "ProcessarFornecedor")
	Local nProc := 0
	Local _cSoap := "" // L de integraùùo
	Local cErros := ""
	Local cAvisos := ""
	Local aLogInt := {}
	Local cReplace := "_"
	Local nx := 0
	//Local oError 	:= ErrorBlock({|e| fErrorPar(e:ErrorStack, 'SA2', @oLog, @cCod)})

	/* Adequaùùo de cadastros anteriores ù integraùùo com a Paradigma */
	If GetMv("MV_XPARCAD") == 1
		SetRegua2(@oProcess, 0)
		IncRegua2(@oProcess, "Adicionando Fornecedores cadastrados a integraùùo")

		cQuery := ""

		If "MSSQL" $ AllTrim(TcGetDb())
			//	cQuery += " select Top(100) R_E_C_N_O_ REG "
			cQuery += " select R_E_C_N_O_ REG
		Else
			cQuery += " select R_E_C_N_O_ REG "
		EndIf

		cQuery += " from " + RetSqlTab("SA2")
		cQuery += " where D_E_L_E_T_ = ' ' "
		cQuery += " and A2_XINTPA = '' "
		//cQuery += " and A2_XTPPRST = '2' "

		If AllTrim(TcGetDb()) == "ORACLE"
			cQuery += " AND ROWNUM <= 100"
		EndIf

		OpenSQL(cAliasAux, cQuery)

		SetRegua2(@oProcess, (cAliasAux)->(nLastRec(cAliasAux)))

		While (cAliasAux)->(! EoF())
			DbSelectArea("SA2")
			DbSetOrder(1)
			DbGoTo((cAliasAux)->REG)

			RecLock("SA2",.F.)
			SA2->A2_XINTPA := "2"
			MsUnLock()

			(cAliasAux)->(DbSkip())
		EndDo

		CloseSQL(cAliasAux)

		cQuery := ""
	EndIf

	SetRegua2(@oProcess, 0)
	IncRegua2(@oProcess, "Processando Fornecedor")

	// Resgate de Informaùùes\\
	cQuery := ""

	If "MSSQL" $ AllTrim(TcGetDb())
		cQuery += " select Top(100) R_E_C_N_O_ REG, * "
		//cQuery += " select R_E_C_N_O_ REG, * "
	Else
		cQuery += " select R_E_C_N_O_ REG, * "
	EndIf

	cQuery += " from " + RetSqlTab("SA2")
	cQuery += " where D_E_L_E_T_ = ' ' "
	cQuery += " and A2_XINTPA > 1 "
	cQuery += " and A2_TIPO <> 'F' "
	//cQuery += " and A2_MSBLQL  = 2 " // WALTER 29/03/2022
	//cQuery += " and A2_XTPPRST = '2' "

	If AllTrim(TcGetDb()) == "ORACLE"
		cQuery += " AND ROWNUM <= 100"
	EndIf

	OpenSQL(cAliasAux, cQuery)

	// Integraùùo \\
	While (cAliasAux)->(!EoF())// .And. Len(oWsFor:oWSlstEmpresa:oWSEmpresaDTO) < 50
		If xRet == .F.
			ConOut( "Erro: " + oWsdl:cError )
		Else
			IncRegua2(@oProcess, "Processando " + (cAliasAux)->(A2_COD) + "/" + (cAliasAux)->(A2_LOJA))
			fIniLog("Fornecedor")

			// Array de valores de Fornecedor \\
			aForn := {}
			aAdd(aForn, AllTrim(Upper(NoAcento((cAliasAux)->(A2_CEP)))))
			aAdd(aForn, AllTrim(Upper(NoAcento((cAliasAux)->(A2_COMPLEM)))))
			aAdd(aForn, AllTrim(Upper(NoAcento((cAliasAux)->(A2_BAIRRO)))))
			aAdd(aForn, AllTrim(Upper(NoAcento((cAliasAux)->(A2_MUN)))))
			aAdd(aForn, AllTrim(Upper(NoAcento((cAliasAux)->(A2_EST)))))
			aAdd(aForn, IIf(!Empty(AllTrim((cAliasAux)->(A2_MUN))) .OR. !Empty(AllTrim((cAliasAux)->(A2_EST))), "1", "0"))
			aAdd(aForn, IIf((cAliasAux)->(A2_MSBLQL) <> "1", "1", "0"))
			aAdd(aForn, IIf((cAliasAux)->(A2_TIPO) == "F", "0", "1"))
			aAdd(aForn, IIf(Empty((cAliasAux)->(A2_CGC)), (cAliasAux)->(A2_COD) + (cAliasAux)->(A2_LOJA), (cAliasAux)->(A2_CGC)))
			aAdd(aForn, AllTrim(Upper(NoAcento((cAliasAux)->(A2_NOME)))))
			aAdd(aForn, AllTrim(Upper(NoAcento((cAliasAux)->(A2_NREDUZ)))))
			aAdd(aForn, AllTrim((cAliasAux)->(A2_FAX)))
			aAdd(aForn, AllTrim((cAliasAux)->(A2_INSCR)))
			aAdd(aForn, AllTrim((cAliasAux)->(A2_INSCRM)))
			aAdd(aForn, AllTrim((cAliasAux)->(A2_TEL)))
			aAdd(aForn, FwTimeStamp(3, Date()))
			aAdd(aForn, (cAliasAux)->(A2_COD)) //+ (cAliasAux)->(A2_LOJA))
			aAdd(aForn, AllTrim(Upper(NoAcento((cAliasAux)->(A2_MUN)))))
			aAdd(aForn, AllTrim(Upper(NoAcento((cAliasAux)->(A2_END)))))
			aAdd(aForn, AllTrim(Upper(NoAcento((cAliasAux)->(A2_DTINIV)))))
			aAdd(aForn, AllTrim(Upper(NoAcento((cAliasAux)->(A2_PRICOM)))))
			aAdd(aForn, AllTrim(Upper(NoAcento((cAliasAux)->(A2_COD_MUN)))))
			aAdd(aForn, AllTrim(Upper(NoAcento((cAliasAux)->(A2_XEMPWBC)))))
			aAdd(aForn, AllTrim(Upper(NoAcento((cAliasAux)->(A2_BANCO)))))
			aAdd(aForn, AllTrim(Upper(NoAcento((cAliasAux)->(A2_AGENCIA)))))
			aAdd(aForn, AllTrim(Upper(NoAcento((cAliasAux)->(A2_NUMCON)))))
			aAdd(aForn, AllTrim((cAliasAux)->(A2_EMAIL)))
			aAdd(aForn, AllTrim((cAliasAux)->(A2_DVCTA)))
			//aAdd(aForn, AllTrim(Upper(NoAcento((cAliasAux)->(A2_DIGCON)))))
			//aAdd(aForn, AllTrim(Upper(NoAcento((cAliasAux)->(A2_DIGAGE)))))



			/* Integraùùo */
			// Cria o objeto da classe TWsdlManager
			oWsdl := TWsdlManager():New()
			oWsdl:AddHttpHeader("Authorization", "Bearer " + U_NewToken())
			oWsdl:lSSLInsecure := .T.
			oWsdl:nTimeout       := 120
			/*
			nSSLVersion  - Lista de opùùes que pode ser setadas:
			0 - O programa tenta descobrir a versùo do protocolo
			1 - Forùa a utilizaùùo do TLSv1
			2 - Forùa a utilizaùùo do SSLv2
			3 - Forùa a utilizaùùo do SSLv3
			*/
			oWsdl:nSSLVersion := 0

			xRet := oWsdl:ParseURL(Lower(AllTrim(GetMv("MV_XPARURL")))+"/services/Empresa.svc?wsdl" )

			If xRet == .F.
				ConOut("Erro ParseURL: " + oWsdl:cError)
				Return nProc
			EndIf

			lRet := oWsdl:SetOperation("ProcessarEmpresa")
			If lRet == .F.
				ConOut("Erro SetOperation: " + oWsdl:cError)
				return nProc
			EndIf

			// Criaùùo do XML \\
			_cSoap := XMLFor(aForn)

			_cSoap := FwCutOff(_cSoap)

			_cSoap := ReTiGraf(_cSoap)

			lRet := oWsdl:SendSoapMsg(_cSoap)

			If lRet == .F.
				//ConOut( "Erro SendSoapMsg: " + oWsdl:cError )
				//ConOut( "Erro SendSoapMsg FaultCode: " + oWsdl:cFaultCode )
				//fSoapFault(oLog)
				aRet := XmlParser(oWsdl:GetSoapResponse(), cReplace, @cErros, @cAvisos)

				aAdd(aLogInt, {;
					'ProcesssarFornecedor',;
					'Erro na montagem do xml verifique caracteres especiais',;
					,;
					,;
					0;
					})

				fWsLogRet(aLogInt, oLog, "",,, .T.,_cSoap)

			Else
				aRet := XmlParser(oWsdl:GetSoapResponse(), cReplace, @cErros, @cAvisos)

				IF VALTYPE(aRet:_S_ENVELOPE:_S_BODY:_PROCESSAREMPRESARESPONSE:_PROCESSAREMPRESARESULT:_A_LSTWBTLOGDTO:_A_WBTLOGDTO) == 'O'

					aAdd(aLogInt, {;
						aRet:_S_ENVELOPE:_S_BODY:_PROCESSAREMPRESARESPONSE:_PROCESSAREMPRESARESULT:_A_LSTWBTLOGDTO:_A_WBTLOGDTO:_A_SCDORIGEM:TEXT,;
						aRet:_S_ENVELOPE:_S_BODY:_PROCESSAREMPRESARESPONSE:_PROCESSAREMPRESARESULT:_A_LSTWBTLOGDTO:_A_WBTLOGDTO:_A_SDSLOG:TEXT,;
						aRet:_S_ENVELOPE:_S_BODY:_PROCESSAREMPRESARESPONSE:_PROCESSAREMPRESARESULT:_A_LSTWBTLOGDTO:_A_WBTLOGDTO:_A_SNRTOKEN:TEXT,;
						aRet:_S_ENVELOPE:_S_BODY:_PROCESSAREMPRESARESPONSE:_PROCESSAREMPRESARESULT:_A_LSTWBTLOGDTO:_A_WBTLOGDTO:_A_TDTLOG:TEXT,;
						aRet:_S_ENVELOPE:_S_BODY:_PROCESSAREMPRESARESPONSE:_PROCESSAREMPRESARESULT:_A_LSTWBTLOGDTO:_A_WBTLOGDTO:_A_NIDRETORNO:TEXT;
						})

					fWsLogRet(aLogInt, oLog, "",,, .T.,_cSoap)

					If cValToChar(aRet:_S_ENVELOPE:_S_BODY:_PROCESSAREMPRESARESPONSE:_PROCESSAREMPRESARESULT:_A_LSTWBTLOGDTO:_A_WBTLOGDTO:_A_NIDRETORNO:TEXT) == "1"
						DbSelectArea("SA2")
						DbSetOrder(1)
						DbGoTo((cAliasAux)->REG)

						RecLock("SA2",.F.)
						SA2->A2_XINTPA := "1"
						MsUnLock()

					Else

						DbSelectArea("SA2")
						DbSetOrder(1)
						DbGoTo((cAliasAux)->REG)

						RecLock("SA2",.F.)
						SA2->A2_XINTPA := "0"
						MsUnLock()



					EndIf


				Else

					IF Len(aRet:_S_ENVELOPE:_S_BODY:_PROCESSAREMPRESARESPONSE:_PROCESSAREMPRESARESULT:_A_LSTWBTLOGDTO:_A_WBTLOGDTO) <=  1
						// Objeto de Log \\
						aAdd(aLogInt, {;
							aRet:_S_ENVELOPE:_S_BODY:_PROCESSAREMPRESARESPONSE:_PROCESSAREMPRESARESULT:_A_LSTWBTLOGDTO:_A_WBTLOGDTO:_A_SCDORIGEM:TEXT,;
							aRet:_S_ENVELOPE:_S_BODY:_PROCESSAREMPRESARESPONSE:_PROCESSAREMPRESARESULT:_A_LSTWBTLOGDTO:_A_WBTLOGDTO:_A_SDSLOG:TEXT,;
							aRet:_S_ENVELOPE:_S_BODY:_PROCESSAREMPRESARESPONSE:_PROCESSAREMPRESARESULT:_A_LSTWBTLOGDTO:_A_WBTLOGDTO:_A_SNRTOKEN:TEXT,;
							aRet:_S_ENVELOPE:_S_BODY:_PROCESSAREMPRESARESPONSE:_PROCESSAREMPRESARESULT:_A_LSTWBTLOGDTO:_A_WBTLOGDTO:_A_TDTLOG:TEXT,;
							aRet:_S_ENVELOPE:_S_BODY:_PROCESSAREMPRESARESPONSE:_PROCESSAREMPRESARESULT:_A_LSTWBTLOGDTO:_A_WBTLOGDTO:_A_NIDRETORNO:TEXT;
							})

						fWsLogRet(aLogInt, oLog, "",,, .T.)

						If cValToChar(aRet:_S_ENVELOPE:_S_BODY:_PROCESSAREMPRESARESPONSE:_PROCESSAREMPRESARESULT:_A_LSTWBTLOGDTO:_A_WBTLOGDTO:_A_NIDRETORNO:TEXT) == "1"
							DbSelectArea("SA2")
							DbSetOrder(1)
							DbGoTo((cAliasAux)->REG)

							RecLock("SA2",.F.)
							SA2->A2_XINTPA := "1"
							MsUnLock()

						Else

							DbSelectArea("SA2")
							DbSetOrder(1)
							DbGoTo((cAliasAux)->REG)

							RecLock("SA2",.F.)
							SA2->A2_XINTPA := "0"
							MsUnLock()

						EndIf


					Else

						for nx := 1 to Len(aRet:_S_ENVELOPE:_S_BODY:_PROCESSAREMPRESARESPONSE:_PROCESSAREMPRESARESULT:_A_LSTWBTLOGDTO:_A_WBTLOGDTO)

							aAdd(aLogInt, {;
								aRet:_S_ENVELOPE:_S_BODY:_PROCESSAREMPRESARESPONSE:_PROCESSAREMPRESARESULT:_A_LSTWBTLOGDTO:_A_WBTLOGDTO[nx]:_A_SCDORIGEM:TEXT,;
								aRet:_S_ENVELOPE:_S_BODY:_PROCESSAREMPRESARESPONSE:_PROCESSAREMPRESARESULT:_A_LSTWBTLOGDTO:_A_WBTLOGDTO[nx]:_A_SDSLOG:TEXT,;
								aRet:_S_ENVELOPE:_S_BODY:_PROCESSAREMPRESARESPONSE:_PROCESSAREMPRESARESULT:_A_LSTWBTLOGDTO:_A_WBTLOGDTO[nx]:_A_SNRTOKEN:TEXT,;
								aRet:_S_ENVELOPE:_S_BODY:_PROCESSAREMPRESARESPONSE:_PROCESSAREMPRESARESULT:_A_LSTWBTLOGDTO:_A_WBTLOGDTO[nx]:_A_TDTLOG:TEXT,;
								aRet:_S_ENVELOPE:_S_BODY:_PROCESSAREMPRESARESPONSE:_PROCESSAREMPRESARESULT:_A_LSTWBTLOGDTO:_A_WBTLOGDTO[nx]:_A_NIDRETORNO:TEXT;
								})

							fWsLogRet(aLogInt, oLog, "",,, .T.,_cSoap)

							If cValToChar(aRet:_S_ENVELOPE:_S_BODY:_PROCESSAREMPRESARESPONSE:_PROCESSAREMPRESARESULT:_A_LSTWBTLOGDTO:_A_WBTLOGDTO[nx]:_A_NIDRETORNO:TEXT) == "1"
								DbSelectArea("SA2")
								DbSetOrder(1)
								DbGoTo((cAliasAux)->REG)

								RecLock("SA2",.F.)
								SA2->A2_XINTPA := "1"
								MsUnLock()
							Else

								DbSelectArea("SA2")
								DbSetOrder(1)
								DbGoTo((cAliasAux)->REG)

								RecLock("SA2",.F.)
								SA2->A2_XINTPA := "0"
								MsUnLock()



							EndIf

						next nx

					Endif
				Endif
				/*fWsLogRet(aLogInt, oLog,,,, .T.)
				nProc++
				fFimLog("Fornecedor - " + cValToChar(nProc) + ' processado - ' + Time() )*/

				nProc := nProc + 1

				// Verificaùùo de integraùùo e ù setado o campo, se tudo OK\\

			EndIf
		EndIf

		(cAliasAux)->(DbSkip())
	EndDo

	fFimLog("Fornecedor - " + cValToChar(nProc) + ' processado - ' + Time() )
	//ErrorBlock(oError)
Return nProc

/*/{Protheus.doc} nProcSC
//Efetua a integraùùo de solicitaùùes de compras
@author Administrator
@since 10/04/2018
@version 1.0
@param oProcess, object, Objeto de processamento tNewProcess
@type function
/*/
static function nProcSC(oProcess, aReg)
	local cAlias  := GetNextAlias()
	local cQuery  := ""
	Local cNum    := ''
	Local cFilAux := cFilAnt
	local oWsSc   := WSRequisicao():New()
	local oSc     := Nil
	local oLog    := FwParLog():New("PAR001", "ProcessarRequisicao")
	local nProc   := 0
	local nX      := 0
	Local aRecs   := {}
	//	Local oError  := ErrorBlock({|e| fErrorPar(e:Description, 'SC1', @oLog, @cNum)})
	Local lExistBlock := ExistBlock("WBCZ03")
	Local aRetorno :={}
	Local bemp

	default aReg := {}

	Begin Sequence
		fIniLog("Solicitaùùo de Compras")

		SetRegua2(oProcess, 0)
		IncRegua2(oProcess, "Solicitaùùo de Compras")

		if Empty(aReg)

			cQuery += " select TOP(500) R_E_C_N_O_ REG  "
			cQuery += " from " + RetSqlTab("SC1")
			cQuery += " where "
			//ALTERADO 19/09/2019 - ROGERIO - GDC, Estava filtrando apenas 'B' e os 'R'eprovados estavam subindo para o Paradigma
			cQuery += "  C1_APROV  NOT IN ('B','R') " //liberados
			//	cQuery += "   and C1_APROV  <> 'B' " //liberados
			cQuery += " and C1_XINTPA > '1' "
			cQuery  += " AND  C1_RESIDUO = '' "
			cQuery  += " AND  C1_QUJE = 0 "
			cQuery  += " AND  D_E_L_E_T_ = ' '"

			OPENSQL(cAlias, cQuery)

			(cAlias)->( DbEval({|| AADD(aReg, REG) }) )

			//CLOSESQL(cAlias)

		endIf

		SetRegua2(oProcess,  Len(aReg) )

		for nX := 1 to Len(aReg)

			/*
 		SB1->( DbSetOrder(1) )1->( DbSeek( xFilial("SB1") + SC1->C1_PRODUTO ) )
 		If SB1->B1_XINTPA <> '1'
 			Loop
 		EndIf
			*/
			cFilAnt := SC1->C1_FILIAL
			cNum    := SC1->C1_NUM

			aADD(aRecs, aReg[nX])

			IncRegua2(oProcess, "Processando " + SC1->C1_NUM + "/" + SC1->C1_ITEM + ": " + SC1->C1_PRODUTO)

			If lExistBlock
				oSc:=U_WBCZ03(aReg[nx])
			Else
				/*
			oSc:= Requisicao_RequisicaoDTO():New()
			oSc:ndQtEntrega 					:= SC1->C1_QUANT //SC1->C1_QUJE
			oSc:ndVlReferencia 				    := SB1->B1_UPRC
			// oSc:oWSlstRequisicaoEmpresaDTO	:= AS Requisicao_ArrayOfRequisicaoEmpresaDTO OPTIONAL
			// oSc:oWSlstRequisicaoIdioma 		:= AS Requisicao_ArrayOfRequisicaoIdiomaDTO OPTIONAL
			oSc:nnCdAplicacao 					:= 2 // 1 -Uso interno, 2 -	Industrializaùùo, 3- Comercializaùùo
			// oSc:nnCdMarca 					:= AS long OPTIONAL
			oSc:nnCdMoeda 						:= 1
			// oSc:nnCdOrigem 					:= AS long OPTIONAL
			oSc:nnCdSituacao 					:= 1   // encaminhada
			// oSc:nnIdTipoOrigem 				:= AS long OPTIONAL
			oSc:nnIdTipoRequisicao 				:= 1
			// oSc:oWSoAplicacaoDetalhe 		:= AS Requisicao_AplicacaoDetalheDTO OPTIONAL
			// oSc:oWSoContaContabilDetalhe 	:= AS Requisicao_ContaContabilDetalheDTO OPTIONAL
			// oSc:oWSoCriterioDetalhe 			:= AS Requisicao_CriterioDetalheDTO OPTIONAL
			// oSc:oWSoMarcaDetalhe 			:= AS Requisicao_MarcaDetalheDTO OPTIONAL
			// oSc:oWSoNaturezaDespesaDetalhe 	:= AS Requisicao_NaturezaDespesaDetalheDTO OPTIONAL
			// oSc:oWSoUnidadeMedidaDetalhe 	:= AS Requisicao_UnidadeMedidaDetalheDTO OPTIONAL
			oSc:csCdCentroCusto 				:= AllTrim(SC1->C1_CC)
			//oSc:csCdClasse 						:= SB1->B1_XCATPAR
			// oSc:csCdCobrancaEndereco 		:= AS string OPTIONAL
			oSc:csCdContaContabil 				:= AllTrim(SC1->C1_CONTA)
			// oSc:csCdDepartamento 			:= AS string OPTIONAL
			oSc:csCdEmpresa 					:= cEmpAnt + SC1->C1_FILIAL
			oSc:csCdEmpresaCobrancaEndereco 	:= cEmpAnt + SC1->C1_FILIAL
			oSc:csCdEmpresaEntregaEndereco 		:= cEmpAnt + SC1->C1_FILIAL
			oSc:csCdEmpresaFaturamentoEndereco  := cEmpAnt + SC1->C1_FILIAL
			// oSc:csCdEntregaEndereco 			:= AS string OPTIONAL
			// oSc:csCdFaturamentoEndereco 		:= AS string OPTIONAL
			// oSc:csCdFonteRecurso 			:= AS string OPTIONAL
			/*If !Empty(SC1->C1_GRUPCOM)
				oSc:csCdGrupoCompra 			:= SC1->C1_GRUPCOM
			oSc:csCdItemEmpresa 				:= SC1->C1_ITEM
			// oSc:csCdNaturezaDespesa 			:= AS string OPTIONAL
			oSc:csCdProduto 					:= AllTrim(SC1->C1_PRODUTO)
			oSc:csCdRequisicaoEmpresa 			:= SC1->C1_NUM
			oSc:csCdUnidadeMedida 				:= SC1->C1_UM
			// oSc:csCdUnidadeNegocio 			:= AS string OPTIONAL
			// oSc:csCdUsuarioComprador 		:= AS string OPTIONAL
			oSc:csCdUsuarioResponsavel 			:= AllTrim(POSICIONE('ZUP', 1, SC1->C1_USER, 'ZUP_NOMRED'))
			// oSc:csDsAnexo 					:= AS string OPTIONAL
			// oSc:csDsDetalheCliente 			:= AS string OPTIONAL
			oSc:csDsJustificativa 				:= ''
			oSc:csDsObservacao 					:= AllTrim(SC1->C1_OBS)
			// oSc:csDsObservacaoInterna 		:= AS string OPTIONAL
			oSc:csDsProdutoRequisicao 			:= oSc:csCdProduto + ' - ' + AllTrim(SC1->C1_DESCRI)
			oSc:ctDtCriacao 					:= FwTimeStamp(3, SC1->C1_EMISSAO)
			oSc:ctDtEntrega 					:= FwTimeStamp(3, SC1->C1_DATPRF)
			// oSc:ctDtLiberacao 				:= AS dateTime OPTIONAL
			// oSc:ctDtMoedaCotacao 			:= AS dateTime OPTIONAL
			EndIf
				oSc:ctDtProcesso 					:= FwTimeStamp(3) */

				DbSelectArea('SC1')
				dbGoTo(aReg[nx])

				oSc:= Requisicao_RequisicaoDTO():New()
				oSc:csCdRequisicaoEmpresa 			:= SC1->C1_NUM
				oSc:csCdItemEmpresa 				:= SC1->C1_ITEM
				oSc:csCdEmpresa 					:= AllTrim(GetMv('  '))
				oSc:csCdProduto 					:= AllTrim(SC1->C1_PRODUTO)
				oSc:csCdClasse 						:= SB1->B1_GRUPO
				oSc:csDsProdutoRequisicao 			:= AllTrim(SC1->C1_DESCRI)
				oSc:csDsObservacao 					:= AllTrim(SC1->C1_OBS)
				oSc:csDsJustificativa 				:= SC1->C1_OBS
				oSc:csCdUnidadeMedida 				:= SC1->C1_UM
				oSc:csCdUsuarioResponsavel 			:= AllTrim(POSICIONE('ZUP', 1, SC1->C1_USER, 'ZUP_NOMRED'))
				oSc:csCdUsuarioComprador 		    := AllTrim(POSICIONE('ZUP', 1, SC1->C1_USER, 'ZUP_NOMRED'))
				oSc:nnCdAplicacao 					:= SC1->C1_XOPER //VAL(POSICIONE('PBN',1, SC1->C1_XOPER, 'PBN_XAPLIC'))
				oSc:nnCdSituacao 					:= 1
				oSc:ndVlReferencia 				    := SC1->C1_XVLESTI
				oSc:csCdCentroCusto 				:= AllTrim(SC1->C1_CC)
				oSc:csCdContaContabil 				:= AllTrim(SC1->C1_CONTA)
				oSc:ndQtEntrega 					:= SC1->C1_QUANT
				oSc:ctDtEntrega 					:= FwTimeStamp(3, SC1->C1_EMISSAO)//U_WBC_DTSC(SC1->C1_PRODUTO, SC1->C1_EMISSAO, SC1->C1_QUANT, SC1->C1_XVLESTI)
				oSc:nnCdMoeda 						:= 1
				oSc:ctDtCriacao 					:= SC1->C1_EMISSAO
				oSc:ctDtLiberacao 				    := SC1->C1_EMISSAO
				oSc:ctDtMoedaCotacao 			    := SC1->C1_EMISSAO
				oSc:csCdGrupoCompra 		    	:= SC1->C1_GRUPCOM
				oSc:csCdEmpresaEntregaEndereco 		:= AllTrim(GetMv('MV_XMATCNP'))
				oSc:csCdEmpresaFaturamentoEndereco  := AllTrim(GetMv('MV_XMATCNP'))
				oSc:csCdEmpresaCobrancaEndereco 	:= AllTrim(GetMv('MV_XMATCNP'))
				oSc:nnIdTipoRequisicao 				:= 1 //cXCOMDIR
				oSc:csCdProjeto 				    := SC1->C1_XPACOTE
				oSc:csDsAnexo 					    := SuperGetMv("MV_DIRDOC", .F., '') + ACB->ACB_OBJETO
			EndIf

			conout('__' + UsrRetName(SC1->C1_USER))

			AADD(oWsSc:oWSlstRequisicao:oWSRequisicaoDTO, oSc:Clone())

			if Empty(oWsSc:oWSlstRequisicao:oWSRequisicaoDTO)
				conout(" Nenhuma solicitaùùo de compras a integrar")
			Else
				//faz a chamada do mùtodo de integraùùo

				aRetorno := oWsSc:ProcessarRequisicao()
				If ValType(aRetorno)=="A" //verifica se È um array
					if aRetorno[1]
						//registra o retorno de processar
						fWsLogRet( oWsSc:oWSProcessarRequisicaoResult:oWSlstWbtLogDTO:oWSWbtLogDTO, oLog, "SC1", aRecs, @nProc,bEmp,aRetorno[2] )


						IF oWsSc:oWSProcessarRequisicaoResult:nNidRetorno == 1

							DbSelectArea('SC1')
							dbGoTo(aReg[nx])
							Begin Sequence
								SC1->(Reclock("SC1",.F.))
								SC1->C1_XINTPA := "1"

								SC1->(msUnlock())
							End sequence

							conout("SOLICITAùùO ALTERADA PARA 1 "+SC1->C1_NUM)
							(cAlias)->( DbSkip() )
						Endif
					else
						fSoapFault(oLog)

						//fWsLogRet( oWsSc:oWSProcessarRequisicaoResult:oWSlstWbtLogDTO:oWSWbtLogDTO, oLog, "SC1", aRecs, @nProc )
					endIf
				Else
					fSoapFault(oLog)
				EndIf
			EndIf






		next nX


		fFimLog("Solicitaùùo de Compras - " + cValToChar(nProc) + ' processados - ' + Time())
		cFilAnt := cFilAux
	End Sequence
	//ErrorBlock(oError)
return nProc
/*/{Protheus.doc} nCancelSC
//VerIfica cancelamentos de SC via o portal paradigma
@author Administrator
@since 02/05/2018
@version 1.0
@param oProcess, object, objeto tNewProccess
@type function
/*/
Static Function nCancelSC(oProcess)
	Local oLog  := FwParLog():New("PAR001", "RetornarRequisicaoCancelamento")
	Local nProc := 0
	Local oWsSc := WSRequisicao():New()

	fIniLog("Cancelamento de Solicitaùùo de Compras")

    If oWsSc:RetornarRequisicaoCancelamento()
        cancelSC(oWsSc:oWSRetornarRequisicaoCancelamentoResult:oWSRequisicaoAtualizarDTO, oLog, @nProc)
    Else
        fSoapFault(oLog)
    EndIf

	fFimLog("Cancelamento de Solicitaùùo de Compras - " + cValToChar(nProc) + ' processados - ' + Time())

Return nProc


/*/{Protheus.doc} nCancelSC
//VerIfica cancelamentos de SC via o portal paradigma
@author Administrator
@since 02/05/2018
@version 1.0
@param oProcess, object, objeto tNewProccess
@type function
/*/
Static Function nRejeita(oProcess)
	Local oLog  := FwParLog():New("PAR001", "RetornarRequisicaoRejeitada")
	Local nProc := 0
	Local oWsSc := WSRequisicao():New()
	Local oBjrej
	Local cReq  := ''
	Local cItem := ''
	Local nX := 0
	Local cFilaux:=cFilAnt

	Private cMotivoAux := ''
	fIniLog("Rejeita  SolicitaÁ„o de Compras")

	If oWsSc:RetornarRequisicaoRecusada()

		oBjrej:= oWsSc:oWSRetornarRequisicaoRecusadaResult:OWSREQUISICAORECUSADADTO

		For nX := 1 To Len(oBjrej)

			cReq	  := oBjrej[nx]:CSCDREQUISICAOEMPRESA
			cItem	  := oBjrej[nx]:CSCDITEMREQUISICAOEMPRESA
			cMotivoAux:= oBjrej[nx]:CSDSJUSTIFICATIVARECUSA
			cFilialCan := cFilGet(oBjrej[nX]:CSCDEMPRESA)

			cFilAnt:=cFilialCan

			DbSelectArea("SC1")
			DbSetOrder(1)
			If DbSeek(xFilial('SC1')+cReq+cItem)

				DevSC()

			Else
			
				RecLock("ZPL", .T.)
				ZPL->ZPL_DATA   :=date()
				ZPL->ZPL_HORA   := Time()
				ZPL->ZPL_TOKEN  := cReq
				ZPL->ZPL_FILIAL := xFilial('SC1') //xFilial(cTabela)
				ZPL->ZPL_USUARI := 'Schedule'
				ZPL->ZPL_ROTINA := 'Par001'
				ZPL->ZPL_FUNCAO := 'RetornarRequisicaoRejeitada'
				ZPL->ZPL_ORIGEM := ""
				ZPL->ZPL_MSGLOG := 'SolicitaÁ„o n„o encontrada numero' + cReq + 'Item ' + cItem
				ZPL->ZPL_MSGWSF := 'SolicitaÁ„o n„o encontrada numero' + cReq + 'Item ' + cItem
				ZPL->ZPL_TSTAMP := GetTimeStamp(DATE())
				ZPL->ZPL_RETORN := 0
				ZPL->ZPL_XML	:= cMotivoAux
				MsUnlock()
			Endif

			nProc++

		Next nx


	Else
		fSoapFault(oLog)
	EndIf

	cFilAnt:=cFilaux

	fFimLog("Cancelamento de Solicitaùùo de Compras - " + cValToChar(nProc) + ' processados - ' + Time())

Return nProc


/*/{Protheus.doc} nCancelSC
//VerIfica cancelamentos de SC via o portal paradigma
@author Administrator
@since 02/05/2018
@version 1.0
@param oProcess, object, objeto tNewProccess
@type function
/*/
Static Function nAlterComp(oProcess)
	//Dados da configuraùùo de Proxy no Configurador
	Local lProxy     := ( FWSFPolice("COMUNICATION", "USR_PROXY") == "T" )
	Local cPrxServer := Alltrim( FWSFPolice("COMUNICATION", "USR_PROXYIP") )
	Local nPrxPort   := Val( FWSFPolice("COMUNICATION", "USR_PROXYPORT") )
	Local cPrxUser   := Alltrim( FWSFPolice("COMUNICATION", "USR_PROXYLOGON") )
	Local oWsdl
	Local xRet
	Local cErro 	:= ""
	Local cAviso 	:= ""
	Local aOps 		:= {}
	Local Oobj
	Local nx 		:= 1
	Local cMensagem := "" //mensagem para a ZPL do que ocorreu
	Local nIntreg	:= 0 //diz se entregou(1) ou nùo(0)
	Local cUsrComp  := "" //cùdigo do usuùrio comprador da SY1
	//Local cURL 		:= cAccSRV + "/Services/Pedido.svc?wsdl"


	Local cURL 		:= AllTrim(GetMv("MV_XPARURL"))+'/services/Requisicao.svc?wsdl'
	Private nPed	:= ''

	// Cria o objeto da classe TWsdlManager
	oWsdl := TWsdlManager():New()
	oWsdl:AddHttpHeader("Authorization", "Bearer " + U_NewToken())

	//Define as propriedades para tratar os prefixos NS das tags do XML e para remover as tags vazias
	oWsdl:lUseNSPrefix := .T.
	oWsdl:lRemEmptyTags := .T.
	//define que irù remover os tipos complexos que foram definidos com 0 no mùtodo SetComplexOccurs
	oWsdl:lProcResp 	:= .F.

	If lProxy
		oWsdl:SetProxy(cPrxServer, nPrxPort)
		oWsdl:SetCredentials(cPrxUser, cPrxPass)
	EndIf

	//Verificaùùo SSL

	If "https:" $ cUrl
		oWsdl:cSSLCACertFile := "\certs\sslCaCert.cer"
		oWsdl:cSSLCertFile 	 := "\certs\sslCert.crt"
		oWsdl:cSSLKeyFile    := "\certs\sslKeyCert.key"
		oWsdl:lSSLInsecure   := .T.
	EndIf

	// Faz o parse de uma URL
	xRet := oWsdl:ParseURL( cURL )
	if xRet == .F.
		//Return "Erro: " + oWsdl:cError
	endif

	aOps := oWsdl:ListOperations()

	if Len( aOps ) == 0
		//Return "Nùo existem operaùùes"
	endif

	//varinfo( "", aOps )

	// Define a operaùùo
	xRet := oWsdl:SetOperation( "RetornarRequisicaoAlteracaoComprador" )
	if xRet == .F.
		//Return "Nùo foi possivel executar a operacao RetornarRequisicaoAlteracaoComprador"
	endif

	if(TYPE('cSOAPmgs') == 'C')
		cSOAPmgs := oWsdl:GetSoapMsg()
	EndIf

	// Envia a mensagem SOAP ao servidor
	xRet := oWsdl:SendSoapMsg()
	if !xRet
		MsgStop( oWsdl:cError , "SendSoapMsg() ERROR")
		//Return xRet := {oWsdl::cFaultCode, oWsdl:cError}
	endif

	// Pega a mensagem de resposta
	xRet := oWsdl:GetSoapResponse()
	if(TYPE('cSOAPret') == 'C')
		cSOAPret := xRet
	EndIf

	if(Empty(GetSimples( xRet, '<a:RequisicaoCompradorAlteradoDTO', '</a:RequisicaoCompradorAlteradoDTO>' )))

		RecLock("ZPL", .T.)
		ZPL->ZPL_DATA   :=date()
		ZPL->ZPL_HORA   := Time()
		ZPL->ZPL_TOKEN  := ''
		ZPL->ZPL_FILIAL := xFilial('ZPL') //xFilial(cTabela)
		ZPL->ZPL_USUARI := 'Schedule'
		ZPL->ZPL_ROTINA := 'Par001'
		ZPL->ZPL_FUNCAO := 'RetornarRequisicaoAlteracaoComprador'
		ZPL->ZPL_ORIGEM := ""
		ZPL->ZPL_MSGLOG := 'Nennhum comprador para alterar '
		ZPL->ZPL_MSGWSF := 'Nennhum comprador para alterar '
		ZPL->ZPL_TSTAMP := GetTimeStamp(DATE())
		ZPL->ZPL_RETORN := 1
		ZPL->ZPL_XML	:= Iif(ValType(xRet)=="C",xRet,cMensagem)
		MsUnlock()

	elseif(!Empty(oWsdl:cError) .OR. !Empty(GetSimples( xRet, '<faultcode', '</faultcode>' )))
		//xRet := {oWsdl:cFaultCode, oWsdl:cError, xRet}
		RecLock("ZPL", .T.)
		ZPL->ZPL_DATA   :=date()
		ZPL->ZPL_HORA   := Time()
		ZPL->ZPL_TOKEN  := ''
		ZPL->ZPL_FILIAL := xFilial('ZPL') //xFilial(cTabela)
		ZPL->ZPL_USUARI := 'Schedule'
		ZPL->ZPL_ROTINA := 'Par001'
		ZPL->ZPL_FUNCAO := 'RetornarRequisicaoAlteracaoComprador'
		ZPL->ZPL_ORIGEM := ""
		ZPL->ZPL_MSGLOG := 'Erro no Xml de retorno.'
		ZPL->ZPL_MSGWSF := 'Erro no Xml de retorno.'
		ZPL->ZPL_TSTAMP := GetTimeStamp(DATE())
		ZPL->ZPL_RETORN := 0
		ZPL->ZPL_XML	:= Iif(ValType(xRet)=="C",xRet,cMensagem)
		MsUnlock()
	Else
		oXmlDoc := XmlParser( xRet, "_", @cErro, @cAviso )

		Oobj := OXMLDOC:_S_ENVELOPE:_S_BODY:_RetornarRequisicaoAlteracaoCompradorResponse:_RetornarRequisicaoAlteracaoCompradorResult:_A_RequisicaoCompradorAlteradoDTO
		IF VALTYPE(Oobj) == 'A'
			For nx := 1  to len(Oobj)

				cCompra := Getuser(Oobj[nx]:_A_sCdUsuarioComprador:TEXT )
				cReq	:= Oobj[nx]:_A_sCdRequisicaoEmpresa:TEXT
				cItem	:= Oobj[nx]:_A_sCdItemRequisicaoEmpresa:TEXT

				DbSelectArea("SC1")
				DbSetOrder(1)
				If DbSeek(xFilial("SC1")+cReq+cItem)

					//verifica se a funùùo personalizada da Ferroport estù compilada
					If ExistBlock( "FRPA062" )

						DbSelectArea("SY1")
						DbSetOrder(3)
						//Procura se o usuùrio estù cadastrado como comprador
						If Dbseek(xFilial('SY1') +cCompra)==.T.
							U_FRPA062(cReq,cCompra)
							cMensagem := "Usuario comprador "+cCompra+" alterado na solicitacao " + cReq + " Item " + cItem
							nIntreg:=1
						Else

							DbSelectArea("SY1")
							DbSetOrder(1)
							//Caso nùo ache, verifica se o cùdigo do portal nùo ù o cùdigo da tabela de Comprador do protheus
							If Dbseek(xFilial('SY1') +cCompra)==.T.
								//se for, busca o cùdigo de usuùrio para pegar enviar na funùùo
								cUsrComp := SY1->Y1_USER
								U_FRPA062(cReq,cUsrComp)
								cMensagem := "Usuario comprador nao veio com o codigo de comprador "+cCompra+", mas foi localizado com "+cUsrComp+", alterado na solicitacao " + cReq + " Item " + cItem
								nIntreg:=1
							Else
								cMensagem := "Usuario comprador nao esta cadastrado como um comprador "+cCompra+" na solicitacao " + cReq + " Item " + cItem
								nIntreg:=0
							EndIf
						EndIf

					Else
						cMensagem := "Funcao de usuario FRPA062 nao esta compilada!"
						nIntreg:=0
					EndIf

					//U_FRPA062(cReq,cCompra)

					//SC1->(Reclock("SC1",.F.))
					//SC1->C1_USER   := cCompra
					//SC1->C1_XUSRCOM := cCompra
					//SC1->C1_XNOMCOM := AllTrim(POSICIONE('SY1', 3, xFilial('SY1') +cCompra, 'Y1_NOME'))
					//SC1->(msUnlock())

					RecLock("ZPL", .T.)
					ZPL->ZPL_DATA   :=date()
					ZPL->ZPL_HORA   := Time()
					ZPL->ZPL_TOKEN  := cReq
					ZPL->ZPL_FILIAL := xFilial('ZPL') //xFilial(cTabela)
					ZPL->ZPL_USUARI := 'Schedule'
					ZPL->ZPL_ROTINA := 'Par001'
					ZPL->ZPL_FUNCAO := 'RetornarRequisicaoAlteracaoComprador'
					ZPL->ZPL_ORIGEM := ""
					ZPL->ZPL_MSGLOG := cMensagem
					ZPL->ZPL_MSGWSF := cMensagem
					ZPL->ZPL_XML	:= Iif(ValType(xRet)=="C",xRet,cMensagem)
					ZPL->ZPL_TSTAMP := GetTimeStamp(DATE())
					ZPL->ZPL_RETORN := nIntreg
					MsUnlock()

				Else
					cMensagem := "Solicitacao nao encontrada, solicitacao " + cReq + " Item " + cItem
					nIntreg:=0

					RecLock("ZPL", .T.)
						ZPL->ZPL_DATA   :=date()
						ZPL->ZPL_HORA   := Time()
						ZPL->ZPL_TOKEN  := cReq
						ZPL->ZPL_FILIAL := xFilial('ZPL') //xFilial(cTabela)
						ZPL->ZPL_USUARI := 'Schedule'
						ZPL->ZPL_ROTINA := 'Par001'
						ZPL->ZPL_FUNCAO := 'RetornarRequisicaoAlteracaoComprador'
						ZPL->ZPL_ORIGEM := ""
						ZPL->ZPL_MSGLOG := cMensagem
						ZPL->ZPL_MSGWSF := cMensagem
						ZPL->ZPL_XML	:= Iif(ValType(xRet)=="C",xRet,cMensagem)
						ZPL->ZPL_TSTAMP := GetTimeStamp(DATE())
						ZPL->ZPL_RETORN := nIntreg
					MsUnlock()

				EndIF

			next nx
		ELSE

			cCompra := Getuser(Oobj:_A_sCdUsuarioComprador:TEXT )
			cReq	:= Oobj:_A_sCdRequisicaoEmpresa:TEXT
			cItem	:= Oobj:_A_sCdItemRequisicaoEmpresa:TEXT

			DbSelectArea("SC1")
			DbSetOrder(1)
			If DbSeek(xFilial("SC1")+cReq+cItem)

				//verifica se a funùùo personalizada da Ferroport estù compilada
				If ExistBlock( "FRPA062" )

					DbSelectArea("SY1")
					DbSetOrder(3)
					//Procura se o usuùrio estù cadastrado como comprador
					If Dbseek(xFilial('SY1') +cCompra)==.T.
						U_FRPA062(cReq,cCompra)
						cMensagem := "Usuario comprador "+cCompra+" alterado na solicitacao " + cReq + " Item " + cItem
						nIntreg:=1
					Else

						DbSelectArea("SY1")
						DbSetOrder(1)
						//Caso nùo ache, verifica se o cùdigo do portal nùo ù o cùdigo da tabela de Comprador do protheus
						If Dbseek(xFilial('SY1') +cCompra)==.T.
							//se for, busca o cùdigo de usuùrio para pegar enviar na funùùo
							cUsrComp := SY1->Y1_USER
							U_FRPA062(cReq,cUsrComp)
							cMensagem := "Usuario comprador nao veio com o codigo de comprador "+cCompra+", mas foi localizado com "+cUsrComp+", alterado na solicitacao " + cReq + " Item " + cItem
							nIntreg:=1
						Else
							cMensagem := "Usuario comprador nao esta cadastrado como um comprador "+cCompra+" na solicitacao " + cReq + " Item " + cItem
							nIntreg:=0
						EndIf
					EndIf

				Else
					cMensagem := "Funcao de usuario FRPA062 nao esta compilada!"
					nIntreg:=0
				EndIf

				//U_FRPA062(cReq,cCompra)
					
				//SC1->(Reclock("SC1",.F.))
				//SC1->C1_USER   := cCompra
				//SC1->C1_XUSRCOM := cCompra
				//SC1->C1_XNOMCOM := AllTrim(POSICIONE('SY1', 3, xFilial('SY1') +cCompra, 'Y1_NOME'))
				//SC1->(msUnlock())

				RecLock("ZPL", .T.)
				ZPL->ZPL_DATA   :=date()
				ZPL->ZPL_HORA   := Time()
				ZPL->ZPL_TOKEN  := cReq
				ZPL->ZPL_FILIAL := xFilial('ZPL') //xFilial(cTabela)
				ZPL->ZPL_USUARI := 'Schedule'
				ZPL->ZPL_ROTINA := 'Par001'
				ZPL->ZPL_FUNCAO := 'RetornarRequisicaoAlteracaoComprador'
				ZPL->ZPL_ORIGEM := ""
				ZPL->ZPL_MSGLOG := 'Comprador ' + cCompra + ' alterado na solicitacao ' + cReq + ' Item ' + cItem
				ZPL->ZPL_MSGWSF := 'Comprador ' + cCompra + ' alterado na solicitacao ' + cReq + ' Item ' + cItem
				ZPL->ZPL_XML	:= Iif(ValType(xRet)=="C",xRet,cMensagem)
				ZPL->ZPL_TSTAMP := GetTimeStamp(DATE())
				ZPL->ZPL_RETORN := nIntreg
				MsUnlock()
			
			Else

				cMensagem := "Solicitacao nao encontrada, solicitacao " + cReq + " Item " + cItem
				nIntreg:=0

				RecLock("ZPL", .T.)
					ZPL->ZPL_DATA   :=date()
					ZPL->ZPL_HORA   := Time()
					ZPL->ZPL_TOKEN  := cReq
					ZPL->ZPL_FILIAL := xFilial('ZPL') //xFilial(cTabela)
					ZPL->ZPL_USUARI := 'Schedule'
					ZPL->ZPL_ROTINA := 'Par001'
					ZPL->ZPL_FUNCAO := 'RetornarRequisicaoAlteracaoComprador'
					ZPL->ZPL_ORIGEM := ""
					ZPL->ZPL_MSGLOG := cMensagem
					ZPL->ZPL_MSGWSF := cMensagem
					ZPL->ZPL_XML	:= Iif(ValType(xRet)=="C",xRet,cMensagem)
					ZPL->ZPL_TSTAMP := GetTimeStamp(DATE())
					ZPL->ZPL_RETORN := nIntreg
				MsUnlock()

			EndIF
		Endif

	EndIf

Return nx

Static Function Getuser(cUser)


	Local cAlias := GetNextAlias()
	Local cQuery := ""
	Local cRet := ""

	cQuery += "SELECT ZUP_CODUSU FROM " + RetSqlName("ZUP") + " ZUP"
	cQuery += " WHERE ZUP_NOMRED ='" + cUser + "'"
	cQuery += " AND ZUP.D_E_L_E_T_ <> '*'"
	cQuery := ChangeQuery(cQuery)

	DbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),cAlias,.F.,.T.)
	(cAlias)->(DbGotop())

	While (cAlias)->(!EoF())
		cRet := (cAlias)->ZUP_CODUSU
		(cAlias)->(DbSkip())
	EndDo
Return  cRet

//Pega a filial do usu·rio apartir do cnpj

static function cFilGet(xcnpj)

	Local aList := FWLoadSM0()
	Local xFil := ''
	Local x

	For  x:=1 to len(aList)

		IF aList[x][18] == xcnpj

			xFil:= aList[x][2]
			Return xFil

		Endif

	next x

Return xFil


/*/{Protheus.doc} cancelSC
//Execuùùo da rotina automatica para cancelamento da SC
@author geovani.figueira
@since 05/2018
@version 2.0
@param oWSRequisicaoAtualizarDTO, object; nProc, numeric
@type function
/*/
Static Function cancelSC(oWSRequisicaoAtualizarDTO, oLog, nProc)
	Local nX 	  := 0
	Local cNum 	  := ''
	Local nCdOrigem, nCdSituacao:="", nIdTpOrigem:="", sCdEmpresa:="", sCdItEmpresa:="", sCdReqEmpresa:="", sNrProcOrigem:=""
	Local cxml := ""
	Local oError  := ErrorBlock({|e| fErrorPar(e:ErrorStack, 'SC1', @oLog, @cNum)})
	Private cSolCom := ''
	Private cItemso := ''
	Private lAuto   := .t.

	DbSelectArea("ZPL")
	DbSetOrder(1)
	For nX := 1 To Len(oWSRequisicaoAtualizarDTO)

		cSolCom := SUBSTR(oWSRequisicaoAtualizarDTO[nX]:CSCDREQUISICAOEMPRESA:TEXT,4)
		cItemso := SUBSTR(oWSRequisicaoAtualizarDTO[nX]:CSCDITEMEMPRESA:TEXT,4)
		cFilant := cFilGet(oWSRequisicaoAtualizarDTO[nX]:CSCDEMPRESA:TEXT)

		MATA235(lAuto)

		nCdOrigem      := oWSRequisicaoAtualizarDTO[nX]:NNCDORIGEM:TEXT
		nCdSituacao    := oWSRequisicaoAtualizarDTO[nX]:NNCDSITUACAO:TEXT
		nIdTpOrigem    := oWSRequisicaoAtualizarDTO[nX]:NNIDTIPOORIGEM:TEXT
		sCdEmpresa     := oWSRequisicaoAtualizarDTO[nX]:CSCDEMPRESA:TEXT
		sCdItEmpresa   := oWSRequisicaoAtualizarDTO[nX]:CSCDITEMEMPRESA:TEXT
		sCdReqEmpresa  := oWSRequisicaoAtualizarDTO[nX]:CSCDREQUISICAOEMPRESA:TEXT
		sNrProcOrigem  := oWSRequisicaoAtualizarDTO[nX]:CSNRPROCESSOORIGEM:TEXT

		cxml := '<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">'
		cxml += '  <s:Body>'
		cxml += '    <RetornarRequisicaoCancelamentoResponse xmlns="http://tempuri.org/">'
		cxml += '      <RetornarRequisicaoCancelamentoResult xmlns:a="http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO" xmlns:i="http://www.w3.org/2001/XMLSchema-instance">'
		cxml += '        <a:RequisicaoAtualizarDTO>'
		cxml += '          <a:nCdOrigem>'+nCdOrigem+'</a:nCdOrigem>'
		cxml += '          <a:nCdSituacao>'+nCdSituacao+'</a:nCdSituacao>'
		cxml += '          <a:nIdTipoOrigem>'+nIdTpOrigem+'</a:nIdTipoOrigem>'
		cxml += '          <a:sCdEmpresa>'+sCdEmpresa+'</a:sCdEmpresa>'
		cxml += '          <a:sCdItemEmpresa>'+sCdItEmpresa+'</a:sCdItemEmpresa>'
		cxml += '          <a:sCdRequisicaoEmpresa>'+sCdReqEmpresa+'</a:sCdRequisicaoEmpresa>'
		cxml += '          <a:sNrProcessoOrigem>'+sNrProcOrigem+'</a:sNrProcessoOrigem>'
		cxml += '        </a:RequisicaoAtualizarDTO>'
		cxml += '      </RetornarRequisicaoCancelamentoResult>'
		cxml += '    </RetornarRequisicaoCancelamentoResponse>'
		cxml += '  </s:Body>'
		cxml += '</s:Envelope>'

		RecLock("ZPL", .T.)
			ZPL->ZPL_DATA   :=date()
			ZPL->ZPL_HORA   := Time()
			ZPL->ZPL_TOKEN  := ''
			ZPL->ZPL_FILIAL := xFilial('ZPL') //xFilial(cTabela)
			ZPL->ZPL_USUARI := 'Schedule'
			ZPL->ZPL_ROTINA := 'Par001'
			ZPL->ZPL_FUNCAO := 'RetornarRequisicaoCancelamento'
			ZPL->ZPL_ORIGEM := ""
			ZPL->ZPL_MSGLOG := 'SolicitaÁ„o '+cSolCom+' item '+cItemso+' cancelado pela rotina MATA235' 
			ZPL->ZPL_MSGWSF := 'SolicitaÁ„o '+cSolCom+' item '+cItemso+' cancelado pela rotina MATA235' 
			ZPL->ZPL_TSTAMP := GetTimeStamp(DATE())
			ZPL->ZPL_RETORN := 1
            ZPL->ZPL_XML	:= cxml
        MsUnlock()

        dbselectArea("SC1")
		DbSetOrder(1)
        If DbSeek(cFilAnt+alltrim(cSolCom)+cItemso)
			If SC1->C1_RESIDUO = 'S'

                RecLock("ZPL", .T.)
                    ZPL->ZPL_DATA   :=date()
                    ZPL->ZPL_HORA   := Time()
                    ZPL->ZPL_TOKEN  := ''
                    ZPL->ZPL_FILIAL := xFilial('ZPL') //xFilial(cTabela)
                    ZPL->ZPL_USUARI := 'Schedule'
                    ZPL->ZPL_ROTINA := 'Par001'
                    ZPL->ZPL_FUNCAO := 'RetornarRequisicaoCancelamento'
                    ZPL->ZPL_ORIGEM := ""
                    ZPL->ZPL_MSGLOG := 'SolicitaÁ„o '+cSolCom+' item '+cItemso+' cancelado pela rotina MATA235' 
                    ZPL->ZPL_MSGWSF := 'SolicitaÁ„o '+cSolCom+' item '+cItemso+' cancelado pela rotina MATA235' 
                    ZPL->ZPL_TSTAMP := GetTimeStamp(DATE())
                    ZPL->ZPL_RETORN := 1
                    ZPL->ZPL_XML	:= cxml
                MsUnlock()

            Else

                RecLock("ZPL", .T.)
                    ZPL->ZPL_DATA   :=date()
                    ZPL->ZPL_HORA   := Time()
                    ZPL->ZPL_TOKEN  := ''
                    ZPL->ZPL_FILIAL := xFilial('ZPL') //xFilial(cTabela)
                    ZPL->ZPL_USUARI := 'Schedule'
                    ZPL->ZPL_ROTINA := 'Par001'
                    ZPL->ZPL_FUNCAO := 'RetornarRequisicaoCancelamento'
                    ZPL->ZPL_ORIGEM := ""
                    ZPL->ZPL_MSGLOG := 'SolicitaÁ„o n„o rejeitada, numero ' + cSolCom + ' Item ' + cItemso + ' Filial '+cFilAnt+' verificar a solicitaÁ„o.'
                    ZPL->ZPL_MSGWSF := 'SolicitaÁ„o n„o rejeitada, numero ' + cSolCom + ' Item ' + cItemso + ' Filial '+cFilAnt+' verificar a solicitaÁ„o.'
                    ZPL->ZPL_TSTAMP := GetTimeStamp(DATE())
                    ZPL->ZPL_RETORN := 0
                    ZPL->ZPL_XML := cxml
                MsUnlock()

            EndIf

		Else

			RecLock("ZPL", .T.)
				ZPL->ZPL_DATA   :=date()
                ZPL->ZPL_HORA   := Time()
                ZPL->ZPL_TOKEN  := ''
                ZPL->ZPL_FILIAL := xFilial('ZPL') //xFilial(cTabela)
                ZPL->ZPL_USUARI := 'Schedule'
                ZPL->ZPL_ROTINA := 'Par001'
                ZPL->ZPL_FUNCAO := 'RetornarRequisicaoCancelamento'
                ZPL->ZPL_ORIGEM := ""
				ZPL->ZPL_MSGLOG := 'SolicitaÁ„o n„o rejeitada, numero ' + cSolCom + ' Item ' + cItemso + ' Filial '+cFilAnt+' n„o encontrada'
				ZPL->ZPL_MSGWSF := 'SolicitaÁ„o n„o rejeitada, numero ' + cSolCom + ' Item ' + cItemso + ' Filial '+cFilAnt+' n„o encontrada'
				ZPL->ZPL_TSTAMP := GetTimeStamp(DATE())
				ZPL->ZPL_RETORN := 0
				ZPL->ZPL_XML := cxml
			MsUnlock()

		EndIf

	Next nX

	ErrorBlock(oError)
Return

/*/{Protheus.doc} nCancelPC
//Integra os cancelamentos da paradigma
@author Administrator
@since 02/05/2018
@version 1.0
@param oProcess, object, objeto tNewProcess
@type function
/*/
Static Function nCancelPC(oProcess)
	Local oLog := FwParLog():New("PAR001", "RetornarPedidoCancelamento")
	Local oWsPc := WSParPedido():New()
	Local nProc := 0

	fIniLog("Cancelamento de Pedido de Compras")

	If oWsPc:RetornarPedidoCancelamento()
		cancelPC(oWsPc:oWSRetornarPedidoCancelamentoResult:oWSParPedidoAtualizarDTO, oLog, @nProc)
	Else
		fSoapFault(oLog)
	EndIf

	fFimLog("Cancelamento de Pedido de Compras - " + cValToChar(nProc) + ' processados - ' + Time())

Return nProc

Static Function cancelPC(oWSParPedidoAtualizarDTO, oLog, nProc)
	Local aMt120Cb := {}
	Local aMt120It := {}
	Local aMata120 := {}
	Local nX := 0
	Local oCancel := Nil
	Local cFilAux := cFilAnt
	Local cNum := ''
	Local cUserAux := __cUserID
	Local oError := ErrorBlock({|e| fErrorPar(e:ErrorStack, 'SC7', @oLog, @cNum)})

	Private lMsErroAuto := .F.

	Begin Sequence
		For nX := 1 To Len(oWSParPedidoAtualizarDTO)
			lMsErroAuto := .F.
			aMt120Cb := {}
			aMt120It := {}
			aMata120 := {}
			nPos 	:= aScan(aEmpFil, {|x| x[18] == oWSParPedidoAtualizarDTO[nX]:csCdComprador})
			cFilAnt 	:= aEmpFil[nPos][2]
			aNum := Separa(oWSParPedidoAtualizarDTO[nX]:csCdPedidoErp, '.', .T.)
			cNum := IIf(Len(aNum) == 2 .And. !Empty(aNum[2]), aNum[2], aNum[1])

			DbSelectArea("SC7")
			DbSetOrder(1)
			If DbSeek(xFilial("SC7")+cNum)
				If SC7->(!EoF())
					__cUserID := SC7->C7_USER
					aAdd(aMt120Cb,{"C7_NUM" 		,SC7->C7_NUM})
					aAdd(aMt120Cb,{"C7_FILIAL" 		,SC7->C7_FILIAL})
					aAdd(aMt120Cb,{"C7_EMISSAO" 	,SC7->C7_EMISSAO})
					aAdd(aMt120Cb,{"C7_FORNECE" 	,SC7->C7_FORNECE})
					aAdd(aMt120Cb,{"C7_LOJA" 		,SC7->C7_LOJA})
					aAdd(aMt120Cb,{"C7_COND" 		,SC7->C7_COND})
					aAdd(aMt120Cb,{"C7_CONTATO" 	,SC7->C7_CONTATO})
					aAdd(aMt120Cb,{"C7_FILENT" 		,SC7->C7_FILENT})
				EndIf
				While SC7->(!EoF()) .And. SC7->C7_FILIAL = xFilial('SC7') .And. SC7->C7_NUM = cNum
					aMata120 := {}
					aAdd(aMata120,{"C7_ITEM"		,SC7->C7_ITEM	,Nil})
					aAdd(aMata120,{"C7_PRODUTO"		,SC7->C7_PRODUTO,Nil})
					aAdd(aMata120,{"C7_QUANT"		,SC7->C7_QUANT	,Nil})
					aAdd(aMata120,{"C7_PRECO"		,SC7->C7_PRECO	,Nil})
					aAdd(aMata120,{"C7_TOTAL"		,SC7->C7_TOTAL	,Nil})
					aAdd(aMt120It, aClone(aMata120))

					SC7->(DbSkip())
				EndDo

				nProc++
				If !Empty(NomeAutoLog())
					MemoWrite(NomeAutoLog(), ' ')
				EndIf

				MSExecAuto({|x,y,z| MATA120(1, x, y, z) }, aMt120Cb, aMt120It, 5)

				If !lMsErroAuto
					conout("Pedido " + oWSParPedidoAtualizarDTO[nX]:csCdPedidoErp + " Excluùdo Com Sucesso!")
					oLog:Retorno := 1
					oLog:Origem := oWSParPedidoAtualizarDTO[nX]:csCdPedidoErp
					oLog:MsgLog := "Pedido de compra " + oWSParPedidoAtualizarDTO[nX]:csCdPedidoErp + " Excluùdo com sucesso!"
					oLog:SoapFault := "Pedido de compra " + oWSParPedidoAtualizarDTO[nX]:csCdPedidoErp + " Excluùdo com sucesso!"
					oLog:Tstamp := FwTimeStamp(3)
					oLog:Token := 'MATA120'
					oLog:SalvaObj('SC7')
				Else
					lerro := .T.
					conout(PADR("ERROR - " +PADR(ProcName(1),10) + " - Tempo " +FWTimeStamp(2) +" - ",60) + 'Erro MATA120 ' + IIf(!Empty(NomeAutoLog()),MemoRead(NomeAutoLog()),''))
					oLog:Retorno := 0
					oLog:Origem := oWSParPedidoAtualizarDTO[nX]:csCdPedidoErp
					oLog:MsgLog := 'Erro MATA120 ' + IIf(!Empty(NomeAutoLog()),MemoRead(NomeAutoLog()),'')
					oLog:SoapFault := 'Erro MATA120 ' + IIf(!Empty(NomeAutoLog()),MemoRead(NomeAutoLog()),'')
					oLog:Tstamp := FwTimeStamp(3)
					oLog:Token := 'MATA120'
					oLog:SalvaObj('SC7')

					MemoWrite(NomeAutoLog(), ' ')

					oCancel := WSParPedido():New()
					/*oCa := Pedido_PedidoAtualizarDTO():New()
					oCa:nnCdSituacao := 4
					oCa:csCdComprador := cFilAnt
					oCa:csCdPedidoErp := oWSParPedidoAtualizarDTO[nX]:csCdPedidoErp*/

					aAdd(oCancel:oWSlstPedidoAtualizarDTO:oWSParPedidoAtualizarDTO, oWSParPedidoAtualizarDTO[nX]:Clone())

					oLog:novoLog()
					oLog:Funcao := 'HabilitarRetornarPedidoCancelamento'
					If !oCancel:HabilitarRetornarPedidoCancelamento()
						fSoapFault(oLog)
						conout(PADR("Thread - "+cValToChar(ThreadID()) +" - " +PADR(ProcName(1),10) + " - Tempo " +FWTimeStamp(2) +" - ",60) + 'Erro no HabilitarRetornarPedidoCancelamento()')
					EndIf
				EndIf
				oLog:novoLog()
			Else
				Conout(' RetornarPedidoCancelamento - Nùo encontrado o pedido ' + oWSParPedidoAtualizarDTO[nX]:csCdPedidoErp)
			EndIf
		Next nX
		__cUserID := cUserAux
		cFilAnt := cFilAux
	End Sequence
	ErrorBlock(oError)
Return


/*/{Protheus.doc} fPergunta
//Ajusta os parametros da rotina
@author Administrator
@since 06/08/2018
@version 1.0
@param cPerg, characters, Grupo de perguntas da SX1
@type function
/*/
// TRECHOS COMENTADO PARA SE ADAPTAR AO NOVO MODELO 12.1.27
Static Function fPergunta(cPerg)
	Local aPergs := {}
	Local nX := 0

	aAdd(aPergs, "Categoria")
	aAdd(aPergs, "Unidade de Medida")
	aAdd(aPergs, "Usu?os")
	//aAdd(aPergs, "Projeto")
	//aAdd(aPergs, "Grupo de Compra")
	aAdd(aPergs, "Condi? de Pagamento")
	aAdd(aPergs, "Centro de Custo")
	aAdd(aPergs, "Conta Cont?l")
	aAdd(aPergs, "Natureza Despesa")
	aAdd(aPergs, "Produto")
	aAdd(aPergs, "Fornecedor")
	aAdd(aPergs, "Categoria Empresa")
	aAdd(aPergs, "Solicita? de Compra")
	aAdd(aPergs, "Banco")
	//aAdd(aPergs, "Pedido de Compra/Contrato")
	aAdd(aPergs, "Cota? de Moeda")
	aAdd(aPergs, "Projeto")
	//aAdd(aPergs, "Banco")
	//DbSelectArea("SX1")
	//DbSetOrder(1)

	/*
		DbSeek(cGrpSx)
	While SX1->X1_GRUPO == cGrpSx
		RecLock("SX1", .F.)
		DbDelete()
		MsUnlock()
		DbSkip()
	EndDo
	//*/

	for nX := 1 to Len(aPergs)

		//cOrdSx := StrZero(nX, Len(SX1->X1_ORDEM))
		IF IsBlind()

			//aAdd(aMvPar, { aPergs[nX], &("{|| Mv_Par" + StrZero(nX, 2) + " == 1 }") })
			aAdd(aMvPar, { aPergs[nX], {||.t. }})





		else
			aAdd(aMvPar, { aPergs[nX], &("{|| Mv_Par" + StrZero(nX, 2) + " == 1 }") })
		Endif
		/*If ! DbSeek(cGrpSx + cOrdSx)

				RecLock("SX1", .T.)

				SX1->X1_GRUPO := cGrpSx
				SX1->X1_ORDEM := cOrdSx
				SX1->X1_PERGUNT:= aPergs[nX]
				SX1->X1_TIPO := "N" //Numùrico
				SX1->X1_TAMANHO:= 1
				SX1->X1_DECIMAL:= 0
				SX1->X1_PRESEL := 1
				SX1->X1_GSC := "C" //Combo
				SX1->X1_VARIAVL:= "Mv_Par" + StrZero(nX, 2)
				SX1->X1_DEF01 := "Sim"
				SX1->X1_DEF02 := "Nùo"

				MsUnlock()

		EndIf*/

	next nX

	//carrega as perguntas criadas
	Pergunte(.F.)

Return

/*/{Protheus.doc} fErrorPar
//Gera um log quando ocorre error log
@author geovani.figueira
@since 06/08/2018
@version 1.0
@param e:ErrorStack, oLog, cOrigem, nS, oWSParPedidoDTO
@type function
/*/
Static Function fErrorPar(cDescErro, cTabela, oLog, cOrigem, nS, oWSParCotacaoDTO, cChOri, cDifere, nT)
	Default nS := 0
	Default nT				 := 0
	Default oWSParCotacaoDTO := Nil
	Default cChOri := ''
	Default cDifere := ''

	If Empty(cDescErro)
		cDescErro = MostraErro()
	EndIf
	lerro := .T.

	conout(PADR("ERROR LOG - " +PADR(ProcName(1),10) + " - Tempo " +FWTimeStamp(2) +" - ",60) + cDescErro)
	oLog:novoLog()
	oLog:Retorno := 99
	oLog:Origem := IIf(Empty(cChOri), cOrigem, cChori)
	oLog:MsgLog := 'ERROR LOG: ' + cDescErro
	oLog:SoapFault := 'ERROR LOG: ' + cDescErro
	oLog:Tstamp := FwTimeStamp(3)
	oLog:Token := 'ERROR LOG'
	oLog:DIfere := cDifere
	oLog:SalvaObj(cTabela)
	oLog:novoLog()
Return

/*/{Protheus.doc} fSoapFault
//Gera um log quando ocorre erro da chamada do metodo de um web service
@author Administrator
@since 06/08/2018
@version 1.0
@param oLog, object, Objeto da classe FwParLog para geraùùo de logs
@type function
/*/
Static Function fSoapFault(oLog)
	Local cSvcError := GetWSCError() // Resumo do erro
	Local cSvcFCode := GetWSCError(2) // Soap Fault Code
	Local cSvcFDescr := GetWSCError(3) // Soap Fault Description

	lerro := .T.
	conout(" Erro na execuùùo da funùùo " + oLog:Funcao)
	conout(cSvcError)

	If ! Empty(cSvcFCode)
		conout("#" + AllTrim(cSvcFCode) + ": " + AllTrim(cSvcFDescr))
	EndIf

	oLog:SalvaSoapFault(cSvcError, cSvcFCode, cSvcFDescr)
	oLog:novoLog()

Return

/*/{Protheus.doc} fWsLogRet
//Gera log de retorna das chamadas dos mùtodos do web service
@author fabri
@since 06/08/2018
@version 1.0
@param aRegDto, array, Array de retorno genùrico
@param oLog, object, Objeto da classe FwParLog para geraùùo de logs
@param cTabela, characters, Tabela para ser marcada como integrada
@param aReg, array, Lista de recnos que devem ser atualizados na tabela integrada
@type function
/*/
Static Function fWsLogRet(aRegDto, oLog, cTabela, aReg, nProc, bEmp, cSoap)
	Local cRegSav := ""
	Local cPrefix := ""
	Local aRecno := {}

	//Variùveis para a nova forma de integraùùo
	// Integraùùes que utilizam essas variùveis: Empresas
	Local cOrig
	Local cLog
	Local cToken
	Local cTime
	Local cID
	Local nX

	Default cTabela := ""
	Default aReg := {}
	Default nProc := 0
	Default bEmp := .F.

	cPrefix := PrefixoCpo(cTabela)

	For nX := 1 To Len(aRegDto)

		//reinicia o objeto para gravaùùo de vùrios registros
		oLog:NovoLog()

		If bEmp
			cOrig  := cValToChar(aRegDto[nX][1])
			cLog   := cValToChar(aRegDto[nX][2])
			cToken := cValToChar(aRegDto[nX][3])
			cTime  := cValToChar(aRegDto[nX][4])
			cID    := cValToChar(aRegDto[nX][5])
		Else
			cOrig := cValToChar(aRegDto[nX]:cScdOrigem)
			cLog := cValToChar(aRegDto[nX]:cSdsLog)
			cToken := cValToChar(aRegDto[nX]:cSnrToken)
			cTime := cValToChar(aRegDto[nX]:cTdtLog)
			cID   := cValToChar(aRegDto[nX]:nNidRetorno)
		EndIf

		conout("Origem: " + cOrig)
		conout("Log: " + cLog)
		conout("Token: " + cToken)
		conout("Timestamp: " + cTime)
		conout("ID Retorno: " + cID)
		conout("") //Quebra Linha

		nProc++

		//caso tenha tido sucesso na integraùùo, guarda o recno para atualizar a tabela
		If cID == "1"
			If ! Empty(cTabela) .AND. cTabela <> "SA2"
				cRegSav += IIf(Empty(cRegSav), "", "/")
				cRegSav += cValToChar(aReg[nX])
				aAdd(aRecno, aReg[nX])
			EndIf
		Else
			lerro := .T.
		EndIf

		If cTabela == 'SC1'
			oLog:Difere := cValToChar(aReg[nX])
		EndIf

		//If ! Empty(cTabela) .AND. cTabela <> "SA2"
		oLog:SalvaWbtLog(aRegDto[nX], cTabela, IIF(Len(aReg) >= nX, cGetFilial(cTabela, aReg[nX]), ""), bEmp,@cSoap)
		//Else
		//oLog:SalvaWbtLog(aRegDto[nX], cTabela, IIF(Len(aRegDto) >= nX, cGetFilial(cTabela, aRegDto[nX]), ""), bEmp)
		//EndIf
	next nX

	aReg := aRecno

	If ! Empty(cRegSav)
		fUpdXIntPa(RetSqlName(cTabela), cPrefix, cRegSav)
	EndIf

Return


/*/{Protheus.doc} fLogRetWs
//Gera log de retorna das chamadas dos mùtodos do web service
@author geovani.figueira
@since 03/09/2018
@version 1.0
@param aRegDto, array, Array de retorno genùrico
@param oLog, object, Objeto da classe FwParLog para geraùùo de logs
@param cTabela, characters, Tabela para ser marcada como integrada
@param aPedidos, array, Lista de Pedidos que devem ser atualizados na tabela integrada
@type function
/*/
Static Function fLogRetWs(aRegDto, oLog, cTabela, cPedido, nProc)
	Local nX := 0
	Local cUpd := ""
	Local cPrefix := ""

	Default cTabela := ""
	Default cPedido := ""

	cPrefix := PrefixoCpo(cTabela)

	for nX := 1 to Len(aRegDto)

		//reinicia o objeto para gravaùùo de vùrios registros
		oLog:NovoLog()

		conout("Origem: " + aRegDto[nX]:cScdOrigem)
		conout("Log: " + aRegDto[nX]:cSdsLog)
		conout("Token: " + aRegDto[nX]:cSnrToken)
		conout("Timestamp: " + aRegDto[nX]:cTdtLog)
		conout("ID Retorno: " + cValToChar(aRegDto[nX]:nNidRetorno))
		conout("") //Quebra Linha

		nProc++

		//caso tenha tido sucesso na integraùùo, guarda o recno para atualizar a tabela
		If aRegDto[nX]:nNidRetorno == 1
			If ! Empty(cTabela)

				cUpd := " update " + RetSqlName(cTabela)
				cUpd += " set " + cPrefix + "_XINTPA = " + ValToSql('1')
				cUpd += " where D_E_L_E_T_ = ' ' "
				cUpd += " and " + cPrefix + "_FILIAL = " + ValToSql(xFilial(cTabela))
				cUpd += " and " + cPrefix + "_NUM = " + ValToSql(RIGHT(cPedido, 6))
				cUpd += " and " + cPrefix + "_XINTPA != '1' "

				//cUpd := ChangeQuery(cUpd)

				If TcSqlExec(cUpd) < 0
					conout("ERRO AO ATUALIZAR OS REGISTROS DA TABELA " +cTabela)
					conout(TcSqlError())
				Else
					TCSQLExec('COMMIT')
				EndIf
			EndIf
		Else
			lerro := .T.
		EndIf

		oLog:SalvaWbtLog(aRegDto[nX], cTabela)

	next nX

Return

/*/{Protheus.doc} OpenSQL
//Faz a abertura de um alias temporario
@author Administrator
@since 06/08/2018
@version 1.0
@param _cAlias, characters, Alias a ser aberto
@param _cQuery, characters, Consulta a ser utilizada
@type function
/*/
Static Function OpenSQL(_cAlias, _cQuery)

	CloseSQL(_cAlias)
	_cQuery := ChangeQuery(_cQuery)
	If 'SC7' $ _cQuery
		//alert(_cQuery)
	EndIf
	DbUseArea(.T.,'TOPCONN',TCGenQry(,,_cQuery),_cAlias,.T.,.F.)

Return

/*/{Protheus.doc} CloseSQL
//Efetua o fechamento do(s) Alias informados
@author Administrator
@since 06/08/2018
@version 1.0
@param uAlias, undefined, Alias ou Array com alias a serem fechados
@type function
/*/
Static Function CloseSQL(uAlias)
	Local aAlias := IIf(Valtype(uAlias) == "A", uAlias, {uAlias})
	Local nX := 0

	for nX := 1 to Len(aAlias)

		If Select(aAlias[nX]) <> 0
			DbSelectArea(aAlias[nX])
			DbCloseArea()
		EndIf

	next nX

Return

/*/{Protheus.doc} fIniLog
//Inicia o log da integraùùo
@author Administrator
@since 06/08/2018
@version 1.0
@param cIntegra, characters, descritivo do inicio da integraùùo
@type function
/*/
Static Function fIniLog(cIntegra)

	Local cMsg := "Iniciando Integraùùo de " + cIntegra

	conout("")
	conout(">>> " + cMsg)
	//conout("")

Return

/*/{Protheus.doc} fFimLog
//Finaliza o log
@author Administrator
@since 06/08/2018
@version 1.0
@param cIntegra, characters, Descritivo do fim da integraùùo
@type function
/*/
Static Function fFimLog(cIntegra)

	Local cMsg := "Fim " + cIntegra

	//conout("")
	conout("<<< " + cMsg)
	conout("")

Return

/*/{Protheus.doc} lMvPar
//VerIfica se a chave esta marcada para integraùùo
@author Administrator
@since 06/08/2018
@version 1.0
@Return lRet, Indica se a chave esta marcada nos parametros da rotina
@param cChave, characters, Codigo de busca
@type function
/*/
Static Function lMvPar(cChave)

	Local nPos := 0

	nPos := aScan(aMvPar, {|arr| cGeraChave(arr[1]) == cGeraChave(cChave) })

	If nPos > 0
		Return Eval(aMvPar[nPos][2])
	EndIf

Return .F.

/*/{Protheus.doc} cGeraChave
//Elimina caracteres para busca logica
@author Administrator
@since 06/08/2018
@version 1.0
@Return cChave, Retorna a chave configurada
@param cChave, characters, Codigo de busca
@type function
/*/
Static Function cGeraChave(cChave)

	//deixa a chave sem acentos, caixa baixa e sem espaùos
	cChave := StrTran(cChave, " ", "")
	cChave := NoAcento(cChave)
	cChave := Lower(cChave)

Return cChave

Static Function SetRegua1(oProcess, nLen)

	If ValType(oProcess) == "O"
		oProcess:SetRegua1(nLen)
		SysRefresh()
	EndIf

Return

Static Function SetRegua2(oProcess, nLen)

	If ValType(oProcess) == "O"
		oProcess:SetRegua2(nLen)
		SysRefresh()
	EndIf

Return

Static Function IncRegua2(oProcess, cMsg)

	If ValType(oProcess) == "O"
		oProcess:IncRegua2(cMsg)
		SysRefresh()
	EndIf

Return

Static Function IncRegua1(oProcess, cMsg)

	If ValType(oProcess) == "O"
		oProcess:IncRegua1(cMsg)
		SysRefresh()
	EndIf

Return


/*Static Function nGrpCmp(oProcess)

Local cAlias := GetNextAlias()
Local cQuery := ""
Local cCod := ''
Local oWsGC := WSGrupoCompra():New()
Local nProc := 0
Local oGC := Nil
Local oLog := FwParLog():New("PAR001", "ProcessarGrupoCompra")
Local aReg := {}
Local oError := ErrorBlock({|e| fErrorPar(e:ErrorStack, 'SAL', @oLog, @cCod)})

	Begin Sequence
fIniLog("Grupo de Compras")

SetRegua2(@oProcess, 0)
IncRegua2(@oProcess, "Grupo de Compras")

cQuery += " select R_E_C_N_O_ REG, AL_COD, AL_DESC "
cQuery += " from " + RetSqlTab("SAL")
cQuery += " where " + RetSqlCond("SAL")
cQuery += " and AL_XINTPA > '1' "

OpenSQL(cAlias, cQuery)

SetRegua2(@oProcess, (cAlias)->(nLastRec(cAlias)))

		While (cAlias)->(! EoF())
// aFiliais
cCod := (cAlias)->AL_COD
IncRegua2(@oProcess, "Processando " + (cAlias)->AL_COD)

oGC := GrupoCompra_GrupoCompraDTO():New()
oGC:csCdGrupoCompra	:= (cAlias)->AL_COD
oGC:csSgGrupoCompra	:= (cAlias)->AL_COD
oGC:csDsGrupoCompra	:= (cAlias)->AL_DESC

aAdd(aReg, (cAlias)->REG)
aAdd(oWsGC:oWSlstGrupoCompra:oWSGrupoCompraDTO, oGC:Clone())

(cAlias)->(DbSkip())

		EndDo

CloseSQL(cAlias)

		If !Empty(oWsGC:oWSlstGrupoCompra:oWSGrupoCompraDTO)
//faz a chamada do mùtodo de integraùùo
			If oWsGC:ProcessarGrupoCompra()
//registra o retorno de processar
fWsLogRet(oWsGC:oWSProcessarGrupoCompraResult:oWSlstWbtLogDTO:oWSWbtLogDTO, oLog, "SAL", aReg, @nProc)
			Else
fSoapFault(oLog)
			EndIf
		EndIf

fFimLog("Grupo de Compras - " + cValToChar(nProc) + ' processados - ' + Time())
	End Sequence
ErrorBlock(oError)

Return nProc
*/

/*/{Protheus.doc} nProjeto
//Efetia a integraùùo dos projetos na Paradigma
@author fabricioereche
@since 29/09/2019
@version 1.0
@Return nProc, Nùmero de registros processados
@param oProcess, object, Objeto de regua de processamento
@type function
/*/
Static Function nProjeto(oProcess)

	Local cTabela := ""
	Local cAlias := GetNextAlias()
	Local cQuery := ""
	Local nProc := 0
	Local aReg := {}
	Local cCod := ""
	Local cXmlRet	:= ''
	Local cErros 	:= ''
	Local cAvisos	:= ''
	Local cReplace  := ''
	Local lWBCZ01 := ExistBlock("WBCZ01")
	Local lWBCZ02 := ExistBlock("WBCZ02")
	Local cIDret,cToken,cCodLog,cOrigem,cDesLog,cTipoDoc,cData := ''
	Local oXML,OXML2


	oWsdl := TWsdlManager():New()
	oWsdl:lSSLInsecure := .T.
	oWsdl:nTimeout     := 120
	oWsdl:nSSLVersion  := 0
	oWsdl:AddHttpHeader("Authorization", "Bearer " + U_NewToken())
	xRet := oWsdl:ParseURL(Lower(AllTrim(GetMv("MV_XPARURL")))+"/services/Projeto.svc?wsdl" )

	If xRet == .F.
		ConOut("WsActvs - Erro ParseURL: " + oWsdl:cError)
		Return
	EndIf

	// Definiùùo da operaùùo \\
	lRet := oWsdl:SetOperation("ProcessarProjeto")
	If lRet == .F.
		ConOut("WsActvs - Erro SetOperation: " + oWsdl:cError)
		Return
	EndIf



	fIniLog("Integrando Projetos")

	SetRegua2(@oProcess, 0)
	IncRegua2(@oProcess, "Projeto")

	//Consulta tabela padrùo (AF8)
	cQuery += " select R_E_C_N_O_ REG, AF8_FILIAL FILIAL, AF8_ENCPRJ ENCERRADO, AF8_PROJET CODPROJ, AF8_DESCRI DESCRI"
	cQuery += " from " + RetSqlTab("AF8")
	cQuery += " where D_E_L_E_T_ <> '*' "
	cQuery += " and AF8_XINTPA > '1' "

	If (lWBCZ01)
		cQuery := ExecBlock("WBCZ01",.F.,.F.,{ cQuery })
	EndIf

	OpenSQL(cAlias, cQuery)

	SetRegua2(@oProcess, (cAlias)->(nLastRec(cAlias)))

	While (cAlias)->(! EoF())

		cCod := (cAlias)->FILIAL + (cAlias)->CODPROJ

		IncRegua2(@oProcess, "Processando " + cCod)

		cXml:= ''
		cXml+=' <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/" xmlns:par="http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO">'
		cXml+="   <soapenv:Header/>"
		cXml+="   <soapenv:Body>"
		cXml+="     <tem:ProcessarProjeto>"
		cXml+="       <tem:lstProjeto>"
		cXml+="         <par:ProjetoDTO>"
		cXml+="          	<par:bFlStatus>"+ (cAlias)->ATIVO +"</par:bFlStatus>"
		cXml+="   			<par:sCdProjeto>"+ (cAlias)->CODPROJ +"</par:sCdProjeto>"
		cXml+="   			<par:sDsProjeto>"+ (cAlias)->DESCRI +"</par:sDsProjeto>"
		cXml+="         </par:ProjetoDTO>"
		cXml+="       </tem:lstProjeto>"
		cXml+="     </tem:ProcessarProjeto>"
		cXml+="   </soapenv:Body>"
		cXml+=" </soapenv:Envelope>"

		aAdd(aReg, (cAlias)->REG)

		lRet := oWsdl:SendSoapMsg(cXml)
		cXMLRet := oWsdl:GetSoapResponse()
		oXML := XMLParser(cXMLRet, cReplace,  @cErros,  @cAvisos)

		IF !lRet
			RecLock("ZPL", .T.)
			ZPL->ZPL_DATA   :=date()
			ZPL->ZPL_HORA   := Time()
			ZPL->ZPL_TOKEN  := cToken
			ZPL->ZPL_FILIAL := xFilial('ZPL')
			ZPL->ZPL_USUARI := 'Schedule'
			ZPL->ZPL_ROTINA := 'PAR001'
			ZPL->ZPL_FUNCAO := 'ProcessarProjeto'
			ZPL->ZPL_ORIGEM :=cOrigem
			ZPL->ZPL_MSGLOG :=OXML:_S_ENVELOPE:_S_BODY:_s_fault:_faultstring:text
			ZPL->ZPL_MSGWSF := OXML:_S_ENVELOPE:_S_BODY:_s_fault:_faultstring:text
			ZPL->ZPL_TSTAMP := cData
			ZPL->ZPL_RETORN := 0
			ZPL->ZPL_XML    := cXml
			MsUnlock()


		ELSE
			oXml2:= OXML:_S_ENVELOPE:_S_BODY:_ProcessarProjetoRESPONSE:_ProcessarProjetoRESULT:_A_LSTWBTLOGDTO

			cIDret 	:=  OXML2:_A_WBTLOGDTO:_A_NIDRETORNO:TEXT
			cToken 	:=  OXML2:_A_WBTLOGDTO:_A_SNRTOKEN:TEXT
			cCodLog :=  ''
			cOrigem	:=  OXML2:_A_WBTLOGDTO:_A_SCDORIGEM:TEXT
			cDesLog	:=  OXML2:_A_WBTLOGDTO:_A_SDSLOG:TEXT
			cTipoDoc:=  Nil
			cData	:=  OXML2:_A_WBTLOGDTO:_A_TDTLOG:TEXT

			If lRet == .F.
				RecLock("ZPL", .T.)
				ZPL->ZPL_DATA   :=date()
				ZPL->ZPL_HORA   := Time()
				ZPL->ZPL_TOKEN  := cToken
				ZPL->ZPL_FILIAL := xFilial('ZPL')
				ZPL->ZPL_USUARI := 'Schedule'
				ZPL->ZPL_ROTINA := 'PAR001'
				ZPL->ZPL_FUNCAO := 'ProcessarProjeto'
				ZPL->ZPL_ORIGEM :=cOrigem
				ZPL->ZPL_MSGLOG :=cDesLog
				ZPL->ZPL_MSGWSF := cDesLog
				ZPL->ZPL_TSTAMP := cData
				ZPL->ZPL_RETORN := 0
				ZPL->ZPL_XML    := cXml
				MsUnlock()
			else
				if(lWBCZ02)
					cTabela := "PB1"
					ExecBlock("WBCZ02",.F.,.F., cAlias)
				else
					cTabela := "AF8"
				endif
				RecLock("ZPL", .T.)
				ZPL->ZPL_DATA   :=date()
				ZPL->ZPL_HORA   := Time()
				ZPL->ZPL_TOKEN  := cToken
				ZPL->ZPL_FILIAL := xFilial('ZPL')
				ZPL->ZPL_USUARI := 'Schedule'
				ZPL->ZPL_ROTINA := 'PAR001'
				ZPL->ZPL_FUNCAO := 'ProcessarProjeto'
				ZPL->ZPL_ORIGEM :=cOrigem
				ZPL->ZPL_MSGLOG :=cDesLog
				ZPL->ZPL_MSGWSF := cDesLog
				ZPL->ZPL_TSTAMP := cData
				ZPL->ZPL_RETORN := 1
				ZPL->ZPL_XML    := cXml
				MsUnlock()
			EndIf
		ENDIF
		nProc ++

		(cAlias)->(DbSkip())

	EndDo

	CloseSQL(cAlias)

	fFimLog("Projetos - " + cValToChar(nProc) + ' processados - ' + Time())

Return nProc


Static Function cGetFilial(cTabela, nRecno)

	Local nPosFld := 0
	Local cFilReg := FwFilial(cTabela)
	Local cPrefix := PrefixoCpo(cTabela)

	If Empty(cTabela)
		Return ""
	EndIf

	(cTabela)->(DbGoTo(nRecno))

	nPosFld := (cTabela)->(FieldPos(cPrefix + "_FILIAL"))

	If nPosFld > 0
		cFilReg := (cTabela)->(FieldGet(nPosFld))
	EndIf

Return cFilReg

Static Function nCategEmp(oProcess)
	Local cAlias := GetNextAlias()
	Local cAliasAux := GetNextAlias()
	Local cQuery := ""
	Local cCod := ''
	Local oWsGC := WSEmpresaClasse():New()
	Local nProc := 0
	Local oGC := Nil
	Local oLog := FwParLog():New("PAR001", "ProcessarEmpresaCategoria")
	Local aReg := {}
	Local cTabRg := "SAD"
	Local oError := ErrorBlock({|e| fErrorPar(e:ErrorStack, cTabRg, @oLog, @cCod)})

	Begin Sequence
		fIniLog("Empresa x Categoria")

		// Adequaùùo de cadastros anteriores ù integraùùo com a Paradigma \\
		If GetMv("MV_XPARCAD") == 1
			SetRegua2(@oProcess, 0)
			IncRegua2(@oProcess, "Adicionando Categorias cadastradas a integraùùo")

			If "MSSQL" $ AllTrim(TcGetDb())
				cQuery += " select Top(200) SAD.R_E_C_N_O_ REG, AD_GRUPO, AD_FORNECE, AD_LOJA "
			Else
				cQuery += " select SAD.R_E_C_N_O_ REG, AD_GRUPO, AD_FORNECE, AD_LOJA "
			EndIf

			cQuery += " from " + RetSqlTab("SAD")
			cQuery += " inner join " + RetSqlTab("SA2")
			cQuery += " on A2_FILIAL = " + ValToSql(FwFilial("SA2"))
			cQuery += " AND SA2.D_E_L_E_T_ <> '*' "
			cQuery += " and A2_COD = AD_FORNECE "
			cQuery += " and A2_LOJA = AD_LOJA "
			cQuery += " and A2_XINTPA = '1' " //fornecedor precisa estar integrado
			cQuery += " inner join " + RetSqlTab("SBM")
			//cQuery += " on SUBSTR(BM_FILIAL, 1, 4) = SUBSTR(AD_MSFIL,1,4) "
			cQuery += " on BM_FILIAL = " + ValToSql(FwFilial("SBM"))
			cQuery += " AND SBM.D_E_L_E_T_ <> '*' "
			cQuery += " and BM_GRUPO = AD_GRUPO "
			cQuery += " and BM_XINTPA = '1' " //grupo de produto precisa estar integrado
			cQuery += " where AD_FILIAL = " + ValToSql(FwFilial("SAD"))
			cQuery += " AND SAD.D_E_L_E_T_ <> '*' "
			cQuery += " and AD_XINTPA = '' "

			If AllTrim(TcGetDb()) == "ORACLE"
				cQuery += " AND ROWNUM <= 200"
			EndIf

			OpenSQL(cAliasAux, cQuery)

			SetRegua2(@oProcess, (cAliasAux)->(nLastRec(cAliasAux)))

			While (cAliasAux)->(! EoF())
				DbSelectArea("SAD")
				DbSetOrder(1)
				DbGoTo((cAliasAux)->REG)

				RecLock("SAD",.F.)
				SAD->AD_XINTPA := '2'
				MsUnLock()

				(cAliasAux)->(DbSkip())
			EndDo

			CloseSQL(cAliasAux)

			cQuery := ""
		EndIf

		// Integraùùo com a Paradigma \\
		SetRegua2(@oProcess, 0)
		IncRegua2(@oProcess, "Empresa x Categoria")

		If "MSSQL" $ AllTrim(TcGetDb())
			cQuery += " select Top(200) SAD.R_E_C_N_O_ REG, AD_GRUPO, AD_FORNECE, AD_LOJA "
		Else
			cQuery += " select SAD.R_E_C_N_O_ REG, AD_GRUPO, AD_FORNECE, AD_LOJA "
		EndIf

		cQuery += " from " + RetSqlTab("SAD")
		cQuery += " inner join " + RetSqlTab("SA2")
		cQuery += " on A2_FILIAL = " + ValToSql(FwFilial("SA2"))
		cQuery += " AND SA2.D_E_L_E_T_ <> '*' "
		cQuery += " and A2_COD = AD_FORNECE "
		cQuery += " and A2_LOJA = AD_LOJA "
		cQuery += " and A2_XINTPA = '1' " //fornecedor precisa estar integrado
		cQuery += " inner join " + RetSqlTab("SBM")
		//cQuery += " on SUBSTR(BM_FILIAL, 1, 4) = SUBSTR(AD_MSFIL,1,4) "
		cQuery += " on BM_FILIAL = " + ValToSql(FwFilial("SBM"))
		cQuery += " AND SBM.D_E_L_E_T_ <> '*' "
		cQuery += " and BM_GRUPO = AD_GRUPO "
		cQuery += " and BM_XINTPA = '1' " //grupo de produto precisa estar integrado
		cQuery += " where AD_FILIAL = " + ValToSql(FwFilial("SAD"))
		cQuery += " AND SAD.D_E_L_E_T_ <> '*' "
		cQuery += " and AD_XINTPA > '1' "

		If AllTrim(TcGetDb()) == "ORACLE"
			cQuery += " AND ROWNUM <= 200"
		EndIf

		OpenSQL(cAlias, cQuery)

		SetRegua2(@oProcess, (cAlias)->(nLastRec(cAlias)))
		DbSelectArea(cAlias)
		While (cAlias)->(! EoF())
			cCod := (cAlias)->AD_GRUPO

			IncRegua2(@oProcess, "Processando " + cCod)

			cCgc := AllTrim(POSICIONE('SA2', 1, xFilial('SA2') +(cAlias)->AD_FORNECE + (cAlias)->AD_LOJA, 'A2_CGC'))


			oGC := EmpresaClasse_EmpresaClasseDTO():New()
			oGC:csCdClasse	:= (cAlias)->AD_GRUPO
			//oGC:csCdEmpresa	:= (cAlias)->AD_FORNECE + (cAlias)->AD_LOJA
			oGC:csCdEmpresa	:= IIf(Empty(cCgc), (cAliasAux)->(A2_COD) + (cAliasAux)->(A2_LOJA), cCgc)


			aAdd(aReg, (cAlias)->REG)
			aAdd(oWsGC:oWSlstEmpresaClasse:oWSEmpresaClasseDTO, oGC:Clone())

			(cAlias)->(DbSkip())
		EndDo

		CloseSQL(cAlias)

		If !Empty(oWsGC:oWSlstEmpresaClasse:oWSEmpresaClasseDTO)
			//faz a chamada do mùtodo de integraùùo
			If oWsGC:ProcessarEmpresaCategoria()
				//registra o retorno de processar
				fWsLogRet(oWsGC:oWSProcessarEmpresaCategoriaResult:oWSlstWbtLogDTO:oWSWbtLogDTO, oLog, cTabRg, aReg, @nProc)
			Else
				fSoapFault(oLog)
			EndIf
		EndIf

		fFimLog("Empresa x Categoria - " + cValToChar(nProc) + ' processados - ' + Time())
	End Sequence
	ErrorBlock(oError)

Return nProc

Static Function cGetCodEmp(c_Empresa, c_Filial)
	Local cCodigo := ""
	Local aAreaSM0 := SM0->(GetArea())
	Local nRecnSM0 := SM0->(RecNo())
	Local cFilPad := AllTrim(GetMv("MV_XPARFLP"))

	default c_Empresa := cEmpAnt
	default c_Filial := cFilAnt

	If Empty(c_Filial)
		c_Filial := cFilPad
	EndIf

	if len(c_filial) > 4
		cCodigo := c_Empresa + SUBSTR(c_Filial,3,6)

	else
		cCodigo := c_Empresa + c_Filial
	endif

	SM0->(DbSetOrder(1))
	if len(c_filial) > 4
		If SM0->(DbSeek(c_Empresa + AllTrim(SUBSTR(c_Filial,3,6))))
			If ! Empty(SM0->M0_CGC)
				cCodigo := SM0->M0_CGC
			EndIf
		EndIf
	Else
		If SM0->(DbSeek(c_Empresa + AllTrim(c_Filial)))
			If ! Empty(SM0->M0_CGC)
				cCodigo := SM0->M0_CGC
			EndIf
		EndIf
	ENDIF

	If ! Empty(aAreaSM0)
		SM0->(RestArea(aAreaSM0))
	Else
		SM0->(DbGoTo(nRecnSM0))
	EndIf
Return cCodigo

Static Function fUpdXIntPa(cTabela, cPrefix, cRegSav)
	Local aUpd := StrTokArr(cRegSav, "/")
	Local cUpd := ""
	Local cReg := ""
	Local nCnt := 0
	Local nX := 0

	for nX := 1 to Len(aUpd)

		nCnt ++
		cReg += IIF(Empty(cReg), "", ",")
		cReg += aUpd[nX]

		//atualiza apenas 500 registros por vez
		If nX == Len(aUpd) .Or. nCnt >= 500

			cUpd := ""
			cUpd += " update " + cTabela
			cUpd += " set " + cPrefix + "_XINTPA = '1' "
			cUpd += " where "
			cUpd += " R_E_C_N_O_ in (" + cReg + ")"

			If TcSqlExec(cUpd) < 0
				MsgStop(TcSqlError(), "ERRO AO ATUALIZAR OS REGISTROS DA TABELA " +cTabela)
			else
				TCSQLExec('COMMIT')
			EndIf

			cReg := ""
			nCnt := 0

		EndIf

	next nX

Return

Static Function nLastRec(cAlias)

	Local nRecno := 0

	(cAlias)->(DbGoBottom())

	nRecno := (cAlias)->(RecNo())

	(cAlias)->(DbGoTop())

Return IIF(Empty(nRecno), 200, nRecno)

/*================================================================================================================*\
|| ############################################################################################################## ||
|| # Static Function: nNatDezp																					# ||
|| # Desc: Integraùùo da Natureza de Despesa																	# ||
|| ############################################################################################################## ||
\*================================================================================================================*/
Static Function nNatDezp(oProcess)

	Local cAlias := GetNextAlias()
	Local cAliasAux := GetNextAlias()
	Local cQuery := ""
	Local cCod := ''
	Local oWsNat := WSNaturezaDespesa():New()
	Local oNat := Nil
	Local nProc := 0
	Local oLog := FwParLog():New("PAR001", "ProcessarNaturezaDespesa")
	Local aReg := {}
	Local oError := ErrorBlock({|e| fErrorPar(e:ErrorStack, 'SED', @oLog, @cCod)})

	Begin Sequence
		fIniLog("Natureza Despesa")

		// Adequaùùo de cadastros anteriores ù integraùùo com a Paradigma \\
		If GetMv("MV_XPARCAD") == 1
			SetRegua2(@oProcess, 0)
			IncRegua2(@oProcess, "Adicionando Categorias cadastradas a integraùùo")

			cQuery += " select SED.R_E_C_N_O_ REG, ED_CODIGO, ED_PAI, ED_DESCRIC, ED_DTINCLU, ED_DTFCCZ, ED_MSBLQL "
			cQuery += " from " + RetSqlTab("SED")
			cQuery += " where " + RetSqlCond("SED")
			cQuery += " and ED_XINTPA = '' "

			OpenSQL(cAliasAux, cQuery)

			SetRegua2(@oProcess, (cAliasAux)->(nLastRec(cAliasAux)))

			While (cAliasAux)->(! EoF())
				DbSelectArea("SED")
				DbSetOrder(1)
				DbGoTo((cAliasAux)->REG)

				RecLock("SED",.F.)
				SED->ED_XINTPA := '2'
				MsUnLock()

				(cAliasAux)->(DbSkip())
			EndDo

			CloseSQL(cAliasAux)

			cQuery := ""
		EndIf

		// Integraùùo com a Paradigma \\
		SetRegua2(@oProcess, 0)
		IncRegua2(@oProcess, "Natureza Despesa")

		cQuery += " select SED.R_E_C_N_O_ REG, ED_CODIGO, ED_PAI, ED_DESCRIC, ED_DTINCLU, ED_DTFCCZ, ED_MSBLQL "
		cQuery += " from " + RetSqlTab("SED")
		cQuery += " where " + RetSqlCond("SED")
		cQuery += " and ED_XINTPA > '1' "

		OpenSQL(cAlias, cQuery)

		SetRegua2(@oProcess, (cAlias)->(nLastRec(cAlias)))

		While (cAlias)->(! EoF())
			// aFiliais
			cCod := (cAlias)->ED_CODIGO
			IncRegua2(@oProcess, "Processando " + cCod)

			oNat:= NaturezaDespesa_NaturezaDespesaDTO():New()
			oNat:nbFlAtivo := IIF((cAlias)->ED_MSBLQL == "1", 0, 1)
			oNat:csCdCodigo := (cAlias)->ED_CODIGO
			oNat:csCdNaturezaDespesa := (cAlias)->ED_CODIGO
			oNat:csDsNaturezaDespesa := (cAlias)->ED_DESCRIC

			If ! Empty((cAlias)->ED_PAI)
				oNat:csCdNaturezaDespesaPai := (cAlias)->ED_PAI
			EndIf

			If ! Empty((cAlias)->ED_DTFCCZ)
				oNat:ctDtFimVigencia := FwTimeStamp(3, sToD((cAlias)->ED_DTFCCZ))
			EndIf

			If ! Empty((cAlias)->ED_DTINCLU)
				oNat:ctDtInicioVigencia := FwTimeStamp(3, sToD((cAlias)->ED_DTINCLU))
			EndIf

			aAdd(aReg, (cAlias)->REG)
			aAdd(oWsNat:oWSlstNaturezaDespesa:oWSNaturezaDespesaDTO, oNat:Clone())

			(cAlias)->(DbSkip())

		EndDo

		CloseSQL(cAlias)

		If !Empty(oWsNat:oWSlstNaturezaDespesa:oWSNaturezaDespesaDTO)
			//faz a chamada do mùtodo de integraùùo
			If oWsNat:ProcessarNaturezaDespesa()
				//registra o retorno de processar
				fWsLogRet(oWsNat:oWSProcessarNaturezaDespesaResult:oWSlstWbtLogDTO:oWSWbtLogDTO, oLog, "SED", aReg, @nProc)
			Else
				fSoapFault(oLog)
			EndIf
		EndIf

		fFimLog("Natureza Despesa - " + cValToChar(nProc) + ' processados - ' + Time())
	End Sequence
	ErrorBlock(oError)

Return nProc

/*/{Protheus.doc} nMoedaCota
//Efetua a integraùùo de cotaùùo de moedas
@author Sensus
@since 03/2020
@version 1.0
@param oProcess, object, Objeto de processamento da tNewProcess
@type function
/*/
Static Function nMoedaCota(oProcess)
	Local oWsMoedaCota := WSMoedaCotacao():New()
	Local cAlias       := GetNextAlias()
	Local oMoeda 	   := Nil
	Local cQuery 	   := ""
	Local cDescMoeda   := ""
	Local cCampo       := ""
	Local nProc 	   := 0
	Local nX           := 0
	Local oLog 		   := FwParLog():New("PAR001", "ProcessarMoedaCotacao")
	Local aReg 		   := {}
	Local oError       := ErrorBlock({|e| fErrorPar(e:ErrorStack, 'SM2', @oLog, @cDescMoeda)})
	Local aRetorno     := {}
	Local bEmp         := NIL

	Begin Sequence
		fIniLog("Cotaùùo Moeda")

		SetRegua2(oProcess, 0)
		IncRegua2(oProcess, "Buscando as moedas")
		cQuery := " select R_E_C_N_O_ REG, M2_DATA, M2_MOEDA1, M2_MOEDA2, M2_MOEDA3, M2_MOEDA4, M2_MOEDA5 "
		cQuery += " from  " + RETSQLNAME("SM2")
		cQuery += " where D_E_L_E_T_ = ' ' "
		cQuery += "   and M2_XINTPA  > '1' "

		OPENSQL(cAlias, cQuery)
		DbSelectArea(cAlias)
		while (cAlias)->( ! EoF() )

			IncRegua2(oProcess, "Registrando moeda " + cDescMoeda)

			For nX := 2 To 5
				cDescMoeda       := GetMv("MV_MOEDA"+cValToChar(nX))
				cCampo           := 'M2_MOEDA' + cValToChar(nX)
				oMoeda			 := MoedaCotacao_MoedaCotacaoDTO():New()
				oMoeda:ndVlMoedaCotacao := 1 / (cAlias)->&(cCampo)
				oMoeda:csCdMoedaDestino := cValToChar(nX)
				oMoeda:csCdMoedaOrigem  := '1'
				oMoeda:ctDtMoedaCotacao := FwTimeStamp(3, SToD((cAlias)->M2_DATA), Time() )

				AADD(oWsMoedaCota:oWSlstMoedaCotacao:oWSMoedaCotacaoDTO, oMoeda:Clone())

				AADD(aReg, (cAlias)->REG)
			Next nX

			(cAlias)->( DbSkip() )
		EndDo

		If !Empty(oWsMoedaCota:oWSlstMoedaCotacao:oWSMoedaCotacaoDTO)
			//faz a chamada da funùùo do web service de moedas

			aRetorno := oWsMoedaCota:ProcessarMoedaCotacao()

			If aRetorno[1]
				//registra o retorno de processar moeda
				fWsLogRet( oWsMoedaCota:oWSProcessarMoedaCotacaoResult:oWSlstWbtLogDTO:oWSWbtLogDTO, oLog, "SM2", aReg, @nProc,bEmp, aRetorno[2] )

				(cAlias)->( DbGoTop() )
				DbSelectArea(cAlias)
				While (cAlias)->( ! EoF() )
					dbGoTo((cAlias)->REG)
					Begin Sequence
						SM2->(Reclock("SM2",.F.))
						SM2->M2_XINTPA := "1"
						SM2->M2_ZDTEXP := dToC(date()) + Space(1) + Time()
						SM2->(msUnlock())
					End sequence
					(cAlias)->( DbSkip() )
				EndDo
			Else
				fSoapFault(oLog)
			EndIf
		EndIf

		fFimLog("Cotaùùo Moeda - " + cValToChar(nProc) + ' processados - ' + Time() )
	End Sequence
	ErrorBlock(oError)
Return nProc

/*================================================================================================================*\
|| ############################################################################################################## ||
|| # Static Function: FMoeda																					# ||
|| # Desc: Retorna o parùmetro da Moeda																			# ||
|| ############################################################################################################## ||
\*================================================================================================================*/
Static Function FMoeda(cPar)
Return SuperGetMv(cPar, .F., "")

/*================================================================================================================*\
|| ############################################################################################################## ||
|| # Static Function: XMLEmp																					# ||
|| # Desc: Retorna o XML de empresas																			# ||
|| ############################################################################################################## ||
\*================================================================================================================*/
Static Function XMLEmp()
	Local _XML
	Local aEndCob
	Local aEndEnt
	Local cEmail
	Local cCod

	// INFORMAùùES \\
	cCod := SM0->M0_CODIGO + SM0->M0_CODFIL
	cEmail := GetMv("MV_XPAREMA")

	aEndCob := {}
	aEndCob := Separa(SM0->M0_ENDCOB, ",", .F.)
	aSize(aEndCob, 2)

	aEndEnt := {}
	aEndEnt := Separa(SM0->M0_ENDENT, ",", .F.)
	aSize(aEndEnt, 2)

	// MONTAGEM DO XML \\
	_XML := ""
	_XML += '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:par="http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO" xmlns:tem="http://tempuri.org/">'
	_XML += '   <soapenv:Header />'
	_XML += '   <soapenv:Body>'
	_XML += '      <tem:ProcessarEmpresa>'
	_XML += '         <tem:lstEmpresa>'
	_XML += '            <par:EmpresaDTO>'

	If !Empty(AllTrim(SM0->M0_CIDCOB)) .OR. !Empty(AllTrim(SM0->M0_ESTCOB))
		_XML += '               <par:lstEmpresaEnderecoCobranca>'
		_XML += '                  <par:EmpresaEnderecoDTO>'
		_XML += '                     <par:sCdCep>' + AllTrim(Upper(NoAcento(SM0->M0_CEPCOB))) + '</par:sCdCep>'
		_XML += '                     <par:sDsComplemento>' + AllTrim(Upper(NoAcento(SM0->M0_COMPCOB))) + '</par:sDsComplemento>'
		_XML += '                     <par:sDsEndereco>' + AllTrim(Upper(NoAcento(SM0->M0_ENDCOB))) + '</par:sDsEndereco>'
		_XML += '                     <par:sNmBairro>' + AllTrim(Upper(NoAcento(SM0->M0_BAIRCOB))) + '</par:sNmBairro>'
		_XML += '                     <par:sNmCidade>' + AllTrim(Upper(NoAcento(SM0->M0_CIDCOB))) + '</par:sNmCidade>'
		_XML += '                     <par:sNrEndereco></par:sNrEndereco>'
		_XML += '                     <par:sSgEstado>' + AllTrim(Upper(NoAcento(SM0->M0_ESTCOB))) + '</par:sSgEstado>'
		_XML += '                     <par:sSgPais>BR</par:sSgPais>'
		_XML += '                     <par:bFlPrincipal>' + IIf(!Empty(AllTrim(SM0->M0_CIDCOB)) .OR. !Empty(AllTrim(SM0->M0_ESTCOB)), "1", "0") + '</par:bFlPrincipal>'
		_XML += '                  </par:EmpresaEnderecoDTO>'
		_XML += '               </par:lstEmpresaEnderecoCobranca>'
	EndIf

	If !Empty(AllTrim(SM0->M0_CIDENT)) .OR. !Empty(AllTrim(SM0->M0_ESTENT))
		_XML += '               <par:lstEmpresaEnderecoEntrega>'
		_XML += '                  <par:EmpresaEnderecoDTO>'
		_XML += '                     <par:sCdCep>' + AllTrim(Upper(NoAcento(SM0->M0_CEPENT))) + '</par:sCdCep>'
		_XML += '                     <par:sDsComplemento>' + AllTrim(Upper(NoAcento(SM0->M0_COMPENT))) + '</par:sDsComplemento>'
		_XML += '                     <par:sDsEndereco>' + AllTrim(Upper(NoAcento(SM0->M0_ENDENT))) + '</par:sDsEndereco>'
		_XML += '                     <par:sNmBairro>' + AllTrim(Upper(NoAcento(SM0->M0_BAIRENT))) + '</par:sNmBairro>'
		_XML += '                     <par:sNmCidade>' + AllTrim(Upper(NoAcento(SM0->M0_CIDENT))) + '</par:sNmCidade>'
		_XML += '                     <par:sNrEndereco></par:sNrEndereco>'
		_XML += '                     <par:sSgEstado>' + AllTrim(Upper(NoAcento(SM0->M0_ESTENT))) + '</par:sSgEstado>'
		_XML += '                     <par:sSgPais>BR</par:sSgPais>'
		_XML += '                     <par:bFlPrincipal>' + IIf(!Empty(AllTrim(SM0->M0_CIDENT)) .OR. !Empty(AllTrim(SM0->M0_ESTENT)), "1", "0") + '</par:bFlPrincipal>'
		_XML += '                  </par:EmpresaEnderecoDTO>'
		_XML += '               </par:lstEmpresaEnderecoEntrega>'
		_XML += '               <par:lstEmpresaEnderecoFaturamento>'
		_XML += '                  <par:EmpresaEnderecoDTO>'
		_XML += '                     <par:sCdCep>' + AllTrim(Upper(NoAcento(SM0->M0_CEPENT))) + '</par:sCdCep>'
		_XML += '                     <par:sDsComplemento>' + AllTrim(Upper(NoAcento(SM0->M0_COMPENT))) + '</par:sDsComplemento>'
		_XML += '                     <par:sDsEndereco>' + AllTrim(Upper(NoAcento(SM0->M0_ENDENT))) + '</par:sDsEndereco>'
		_XML += '                     <par:sNmBairro>' + AllTrim(Upper(NoAcento(SM0->M0_BAIRENT))) + '</par:sNmBairro>'
		_XML += '                     <par:sNmCidade>' + AllTrim(Upper(NoAcento(SM0->M0_CIDENT))) + '</par:sNmCidade>'
		_XML += '                     <par:sNrEndereco></par:sNrEndereco>'
		_XML += '                     <par:sSgEstado>' + AllTrim(Upper(NoAcento(SM0->M0_ESTENT))) + '</par:sSgEstado>'
		_XML += '                     <par:sSgPais>BR</par:sSgPais>'
		_XML += '                     <par:bFlPrincipal>' + IIf(!Empty(AllTrim(SM0->M0_CIDENT)) .OR. !Empty(AllTrim(SM0->M0_ESTENT)), "1", "0") + '</par:bFlPrincipal>'
		_XML += '                  </par:EmpresaEnderecoDTO>'
		_XML += '               </par:lstEmpresaEnderecoFaturamento>'
		_XML += '               <par:lstEmpresaEnderecoInstitucional>'
		_XML += '                  <par:EmpresaEnderecoDTO>'
		_XML += '                     <par:sCdCep>' + AllTrim(Upper(NoAcento(SM0->M0_CEPENT))) + '</par:sCdCep>'
		_XML += '                     <par:sDsComplemento>' + AllTrim(Upper(NoAcento(SM0->M0_COMPENT))) + '</par:sDsComplemento>'
		_XML += '                     <par:sDsEndereco>' + AllTrim(Upper(NoAcento(SM0->M0_ENDENT))) + '</par:sDsEndereco>'
		_XML += '                     <par:sNmBairro>' + AllTrim(Upper(NoAcento(SM0->M0_BAIRENT))) + '</par:sNmBairro>'
		_XML += '                     <par:sNmCidade>' + AllTrim(Upper(NoAcento(SM0->M0_CIDENT))) + '</par:sNmCidade>'
		_XML += '                     <par:sNrEndereco></par:sNrEndereco>'
		_XML += '                     <par:sSgEstado>' + AllTrim(Upper(NoAcento(SM0->M0_ESTENT))) + '</par:sSgEstado>'
		_XML += '                     <par:sSgPais>BR</par:sSgPais>'
		_XML += '                     <par:bFlPrincipal>' + IIf(!Empty(AllTrim(SM0->M0_CIDENT)) .OR. !Empty(AllTrim(SM0->M0_ESTENT)), "1", "0") + '</par:bFlPrincipal>'
		_XML += '                  </par:EmpresaEnderecoDTO>'
		_XML += '               </par:lstEmpresaEnderecoInstitucional>'
	EndIf

	_XML += '               <par:nCdIdioma>1</par:nCdIdioma>'
	_XML += '               <par:nCdSituacao>1</par:nCdSituacao>'
	_XML += '               <par:nCdTipo>2</par:nCdTipo>'
	_XML += '               <par:nIdTipoPessoa>2</par:nIdTipoPessoa>'
	_XML += '               <par:sCdEmpresa>' + SM0->M0_CGC + '</par:sCdEmpresa>'
	_XML += '               <par:sCdMoeda>1</par:sCdMoeda>
	_XML += '               <par:sDsEmailContato>' + IIf((Empty(AllTrim(cEmail)) .Or. lHomolog), 'teste@paradigma.com.br', cEmail) + '</par:sDsEmailContato>'
	_XML += '               <par:sNmEmpresa>' + AllTrim(Upper(NoAcento(SM0->M0_NOMECOM)))  + '</par:sNmEmpresa>'
	_XML += '               <par:sNmFantasia>' + AllTrim(Upper(NoAcento(SM0->M0_NOME))) + '</par:sNmFantasia>'
	_XML += '               <par:sNrCnpj>' + AllTrim(SM0->M0_CGC) + '</par:sNrCnpj>'
	_XML += '               <par:sNrCnpjMatriz>' + cGetCodEmp(cEmpAnt, AllTrim(GetMv('MV_XPARFLP'))) + '</par:sNrCnpjMatriz>'
	_XML += '               <par:sNrFax>' + AllTrim(SM0->M0_FAX) + '</par:sNrFax>'
	_XML += '               <par:sNrInscricaoEstadual>' + AllTrim(SM0->M0_INSC) + '</par:sNrInscricaoEstadual>'
	_XML += '               <par:sNrInscricaoMunicial>' + AllTrim(SM0->M0_INSCM) + '</par:sNrInscricaoMunicial>'
	_XML += '               <par:sNrTelefone>' + AllTrim(SM0->M0_TEL) + '</par:sNrTelefone>'
	_XML += '      		    <par:sSgPais>BR</par:sSgPais>'
	_XML += '               <par:tDtCadastro>' + FwTimeStamp(3, IIf(Empty(SM0->M0_DTRE), cToD('01/01/2020'), SM0->M0_DTRE)) + '</par:tDtCadastro>'
	_XML += '            </par:EmpresaDTO>'
	_XML += '         </tem:lstEmpresa>'
	_XML += '      </tem:ProcessarEmpresa>'
	_XML += '   </soapenv:Body>'
	_XML += '</soapenv:Envelope>'
Return _XML

/*================================================================================================================*\
|| ############################################################################################################## ||
|| # Static Function: XMLFor																					# ||
|| # Desc: Retorna o XML de fornecedor																			# ||
|| ############################################################################################################## ||
\*================================================================================================================*/
Static Function XMLFor(aForn)
	Local _XML
	Local aEnd
	Local cCod
	Local cMun
	Local dDtIni
	Local cEmail

	// INFORMAùùES \\
	cCod := aForn[17]

	aEnd := {}
	aEnd := Separa(aForn[19], ",", .F.)
	aSize(aEnd, 2)

	dDtIni := IIf(Empty(aForn[20]), CToD('01/01/2018'), aForn[20])

	cMun := AllTrim(POSICIONE('CC2', 1, xFilial('CC2') + aForn[5] + aForn[22], 'CC2_MUN'))

	cEmail := GetMv("MV_XPAREMA")

	// MONTAGEM DO XML \\
	_XML := ""
	_XML += '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:par="http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO" xmlns:tem="http://tempuri.org/">'
	_XML += '   <soapenv:Header />'
	_XML += '   <soapenv:Body>'
	_XML += '      <tem:ProcessarEmpresa>'
	_XML += '         <tem:lstEmpresa>'
	_XML += '            <par:EmpresaDTO>'

	IF !Empty(aForn[25]) .and. !Empty(aForn[24]) .and. !Empty(aForn[26])

		_XML+= '           <par:lstEmpresaBanco>											'
		_XML+= '              <par:EmpresaBancoDTO>                                         '
		_XML+= '                 <par:bFlPrincipal>1</par:bFlPrincipal>                     '
		_XML+= '                 <par:nCdTipoConta>1</par:nCdTipoConta>                     '
		_XML+= '                 <par:sCdAgencia>' + aForn[25] + '</par:sCdAgencia>                      '
		_XML+= '                 <par:sCdAgenciaDigito></par:sCdAgenciaDigito>                     '
		_XML+= '                 <par:sCdBanco>' + aForn[24] + '</par:sCdBanco>                             '
		_XML+= '                 <par:sCdContaCorrente>' + aForn[26] + '</par:sCdContaCorrente>    '
		_XML+= '                 <par:sCdContaDigito>' + aForn[28] + '</par:sCdContaDigito>                '

		IF  aForn[5] <> 'EX'

			_XML+= '                 <par:sCdPais>BR</par:sCdPais>                              '
		ELSE

			_XML+= '                 <par:sCdPais>EX</par:sCdPais>

		ENDIF
		_XML+= '                 <par:sNmTitular>' + aForn[10] + '</par:sNmTitular>                              '
		_XML+= '              </par:EmpresaBancoDTO>                                        '



		_XML+= '           </par:lstEmpresaBanco>                                           '

	ENDIF

	_XML+=  '            <par:lstEmpresaContato>                                         '
	_XML+=  '               <par:EmpresaContatoDTO>                                      '
	_XML+=  '                  <par:nCdContato>11</par:nCdContato>                       '
	_XML+=  '                  <par:sDsEmail>'+AFORN[27]+'</par:sDsEmail>'
	_XML+=  '                  <par:sNmContato>Contato</par:sNmContato>                  '
	_XML+=  '                  <par:sNrTelefone>'+AFORN[15]+'</par:sNrTelefone>             '
	_XML+=  '               </par:EmpresaContatoDTO>                                     '
	_XML+=  '            </par:lstEmpresaContato>                                        '
	IF !EMPTY(AFORN[23])
		_XML += '               <par:nCdEmpresaWbc>' + AFORN[23]+ '</par:nCdEmpresaWbc>'
	Endif
	_XML += '               <par:nCdIdioma>1</par:nCdIdioma>'
	_XML += '               <par:nCdSituacao>' + aForn[7] + '</par:nCdSituacao>'
	_XML += '               <par:nCdTipo>3</par:nCdTipo>'
	_XML += '               <par:nIdTipoPessoa>' + aForn[8] + '</par:nIdTipoPessoa>'

	IF  aForn[5] <> 'EX'
		_XML += '               <par:sCdEmpresa>' + aForn[9] + '</par:sCdEmpresa>'
	ELSE
		_XML += '               <par:sCdEmpresa>' + cCod + '</par:sCdEmpresa>'
	ENDIF

	_XML += '               <par:sDsCep>' + aForn[1] + '</par:sDsCep> '
	//_XML += '               <par:sDsEmailContato>cadastrodesatualizado@cassi.com.br</par:sDsEmailContato>'
	_XML += '               <par:sDsEmailContato>' + IIf((Empty(AllTrim(aForn[27]))), 'teste@teste.com', aForn[27]) + '</par:sDsEmailContato>'
	_XML += '               <par:sDsEndereco>' + aForn[19] + '</par:sDsEndereco>'
	_XML += '               <par:sNmBairro>' + aForn[3] + '</par:sNmBairro> '
	_XML += '               <par:sNmCidade>' + aForn[4] + '</par:sNmCidade> '
	_XML += '               <par:sNmEmpresa>' + aForn[10]  + '</par:sNmEmpresa>'
	_XML += '               <par:sNmFantasia>' + aForn[11] + '</par:sNmFantasia>'

	IF  aForn[5] <> 'EX'

		_XML += '               <par:sNrCnpj>' + aForn[9] + '</par:sNrCnpj>'
		_XML += '               <par:sNrCnpjMatriz>' + aForn[9] + '</par:sNrCnpjMatriz>'

	ELSE

		_XML += '               <par:sNrCnpj>' + cCod + '</par:sNrCnpj>'
		_XML += '               <par:sNrCnpjMatriz>' + cCod+ '</par:sNrCnpjMatriz>'


	ENDIF

	IF !EMPTY(alltrim(AFORN[12]))
		_XML += '               <par:sNrFax>' + aForn[12] + '</par:sNrFax>'
	EndIF
	_XML += '               <par:sNrInscricaoEstadual>' + aForn[13] + '</par:sNrInscricaoEstadual>'
	_XML += '               <par:sNrInscricaoMunicial>' + aForn[14] + '</par:sNrInscricaoMunicial>'
	_XML += '               <par:sNrTelefone>' + aForn[15] + '</par:sNrTelefone>'
	_XML += '               <par:sSgEstado>' + aForn[5] + '</par:sSgEstado>

	IF  aForn[5] <> 'EX'
		_XML += '               <par:sSgPais>BR</par:sSgPais>'
	ELSE
		_XML += '               <par:sSgPais>EX</par:sSgPais>'
	ENDIF
	_XML += '               <par:tDtCadastro>' + aForn[16] + '</par:tDtCadastro>'
	_XML += '               <par:tDtInicioAtividade>' + aForn[16] + '</par:tDtInicioAtividade>'
	_XML += '            </par:EmpresaDTO>'
	_XML += '         </tem:lstEmpresa>'
	_XML += '      </tem:ProcessarEmpresa>'
	_XML += '   </soapenv:Body>'
	_XML += '</soapenv:Envelope>'



Return _XML

/*================================================================================================================*\
|| ############################################################################################################## ||
|| # Static Function: ExecUsu																					# ||
|| # Desc: Atualizaùùo da tabela ZUP																			# ||
|| ############################################################################################################## ||
\*================================================================================================================*/
Static Function ExecUsu()
	Local nX, nY   := 0
	Local aUsers   := {}
	Local aGrupos  := {}
	Local aFiliais := {}
	Local cGrupos  := ""
	Local cFiliais := ""
	Local cPerfil  := ""
	Local lOk      := .F.
	Local cEmfima	:= ""
	Local lBloque 	:= ""
	Local cRamal  	:= ""
	Local _aRetUser := {}

	Default lPar003 := .F.

	aUsers := FWSFALLUSERS()

	If lPar003
		ProcRegua(Len(aUsers))
	EndIf

	For nX := 1 To Len(aUsers)
		cGrupos  := ''
		cFiliais := ''
		lOk      := .F.

		If lPar003
			IncProc('Processando usuùrio ' + aUsers[nX][2])
		EndIf

		//Filiais
		If Len(aFiliais := FWUsrEmp(aUsers[nX][2]) ) > 1
			For nY := 1 To Len(aFiliais)
				cFiliais += Iif(Empty(cFiliais), aFiliais[nY], ';' + aFiliais[nY] )
			Next nY
		Else
			If Len(aFiliais) = 0
				cFiliais := ""
			Else
				cFiliais	:= aFiliais[1]
			EndIf
		EndIf

		IIf(FWIsAdmin(aUsers[nX][2] ), cPerfil := '1', cPerfil := '')

		dbSelectArea("SY1") // Compradores
		dbSetOrder(3)	// Y1_FILIAL+Y1_USER	Cod. Usuario
		If dbSeek(xFilial('SY1')+aUsers[nX][2])
			cPerfil += Iif(Empty(cPerfil), '2', ';2')
		EndIf
		If Empty(cPerfil)
			cPerfil := '4'
		EndIf

		// Dados do Usu·rios \\
		PswOrder(1)
		If PswSeek(aUsers[nX][2], .T. )    
			_aRetUser := PswRet(1)
			cEmfima	:= _aRetUser[1][22]//PswRet()[1][22]
			lBloque := _aRetUser[1][17]//PswRet()[1][17]
			cRamal  := _aRetUser[1][20]//PswRet()[1][20]
			aGrupos := _aRetUser[1][10]//PswRet()[1][10]
		Else
			PswSeek(aUsers[nX][2],.T.)
			cEmfima	:= PswRet()[1][22]
			lBloque := .F.
			cRamal  := PswRet()[1][20]
			aGrupos := PswRet()[1][10]
		EndIf

		For nY := 1 To Len(aGrupos)
			cGrupos += Iif(Empty(cGrupos), aGrupos[nY], ';' + aGrupos[nY])
		Next nY

		dbSelectArea("ZUP")
		dbSetOrder(1)

		If !dbSeek(aUsers[nX][2]) .And. !lBloque
			Begin Transaction
				RecLock("ZUP", .T.)
				ZUP_CODUSU := aUsers[nX][2] // CODIGO -> aUsers[nX][2]
				ZUP_NOMRED := aUsers[nX][3] // NOME REDUZIDO-> aUsers[nX][3]
				ZUP_NOMCOM := aUsers[nX][4] // NOME COMPLETO -> aUsers[nX][4]
				ZUP_BLOQUE := lBloque // USUARIO BLOQUEADO -> lBloque
				ZUP_DEPART := aUsers[nX][6] // DEPARTAMENTO -> aUsers[nX][6]
				ZUP_EMAIL  := aUsers[nX][5] // E-MAIL -> aUsers[nX][5]
				ZUP_RAMAL  := cRamal // RAMAL -> cRamal
				ZUP_EMFIMA := cEmfima // MATRICULA -> cEmfima
				ZUP_GRUPOS := cGrupos // GRUPO -> cGrupos
				ZUP_EMPFIL := cFiliais // FILIAL -> cFiliais
				ZUP_PERFIL := cPerfil // PERFIL -> 1- Administrador, 3- Vendedor, 6- Comprador, 11- Requisitante (cPerfil)
				ZUP_XINTPA := '2' // AùùO -> 2- Incluir, 3 - Alterar, 4 - Excluir
				MsUnLock()
			End Transaction
		EndIf
	Next nX

	PutMv("MV_XPARUSU", 2) //2=Sim
Return .T.


Static function ReTiGraf(_sOrig)
	local _sRet := _sOrig
	_sRet := strtran (_sRet, "·", "a")
	_sRet := strtran (_sRet, "È", "e")
	_sRet := strtran (_sRet, "Ì", "i")
	_sRet := strtran (_sRet, "Û", "o")
	_sRet := strtran (_sRet, "˙", "u")
	_SRET := STRTRAN (_SRET, "›", "A")
	_SRET := STRTRAN (_SRET, "…", "E")
	_SRET := STRTRAN (_SRET, "›", "I")
	_SRET := STRTRAN (_SRET, "”", "O")
	_SRET := STRTRAN (_SRET, "⁄", "U")
	_sRet := strtran (_sRet, "„", "a")
	_sRet := strtran (_sRet, "ı", "o")
	_SRET := STRTRAN (_SRET, "√", "A")
	_SRET := STRTRAN (_SRET, "’", "O")
	_sRet := strtran (_sRet, "‚", "a")
	_sRet := strtran (_sRet, "Í", "e")
	_sRet := strtran (_sRet, "Ó", "i")
	_sRet := strtran (_sRet, "Ù", "o")
	_sRet := strtran (_sRet, "˚", "u")
	_SRET := STRTRAN (_SRET, "¬", "A")
	_SRET := STRTRAN (_SRET, " ", "E")
	_SRET := STRTRAN (_SRET, "Œ", "I")
	_SRET := STRTRAN (_SRET, "‘", "O")
	_SRET := STRTRAN (_SRET, "€", "U")
	_sRet := strtran (_sRet, "Á", "c")
	_sRet := strtran (_sRet, "«", "C")
	_sRet := strtran (_sRet, "‡", "a")
	_sRet := strtran (_sRet, "¿", "A")
	_sRet := strtran (_sRet, "∫", ".")
	_sRet := strtran (_sRet, "™", ".")
	_sRet := strtran (_sRet, "&", "e")
	_sRet := strtran (_sRet, "∞", ".")
	_sRet := strtran (_sRet, "∫", ".")
	_sRet := strtran (_sRet, "¥", ".")
	_sRet := strtran (_sRet, chr (9), " ") // TAB
	_sRet := FwNoAccent( _sRet )
	_sRet := LimpaMemo(_sRet)
return _sRet

// Funcao criada para retirar um caractere estranho quando e 
// utilizado o campo Memo 
Static Function LimpaMemo( cTexto )
	Local nX     := 0                
	Local nAsc   := 0   
	Local cChar  := ''             
	Local cREt   := ''                 
	For nX := 1 To Len( cTexto )
		cChar := Subs( cTexto, nX, 1 )
		nAsc  := Asc( cChar )
		If nAsc > 31 .and. nAsc < 127
		cRet += cChar
		Else
			cRet += ''
		EndIf	   
	Next
Return cRet
//COR003

/*/{Protheus.doc} fAlterForne
	Faz alteraùù odo fornecedor no PROTHEUS
	@type  Static Function
	@author Rubem Cerqueira
	@since 01/03/2021
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
/*/
Static Function fAlterForne(oProcess)

	Local oLog 	 := FwParLog():New("PAR001", "RetornarEmpresaAtivadaInativada")
	Local nProc	 := 0
	Local cCodMun := ''
	Local aFornec
	Local oModel
	Local cErro := ""
	Local aErro
	Local aLogInt  :={}
	Local oWsdl
	Local cAviso := ""
	Local cSQL

	Local cNome
	Local cNomeReduz
	Local cCep
	Local cEst
	Local cCidade
	Local cEndereco
	Local cNumero
	Local cTel
	Local cEmail
	Local cContato
	Local cIE
	Local cIEmun
	Local cBairro
	Local cFilCC2 := FWxFilial('CC2')
	Local cHomePAge

	Local cBanco
	Local cAgencia
	Local cDivAg
	Local cContaBanc
	Local cDivConta
	Local cTpConta
	Local lExitBanco as logical
	Local nX := 0
	Private oRet

	fIniLog("?")

	// Cria o objeto da classe TWsdlManager
	oWsdl := TWsdlManager():New()
	oWsdl:lSSLInsecure 	 := .T.
	oWsdl:nTimeout       := 120
	oWsdl:nSSLVersion := 0
	oWsdl:AddHttpHeader("Authorization", "Bearer " + U_NewToken())

	xRet := oWsdl:ParseURL(Lower(AllTrim(GetMv("MV_XPARURL")))+"/services/Empresa.svc?wsdl" )

	If xRet == .F.
		ConOut("Erro ParseURL: " + oWsdl:cError)
		Return nProc
	EndIf

	lRet := oWsdl:SetOperation("RetornarEmpresaAtivadaInativada")
	If lRet == .F.
		ConOut("Erro SetOperation: " + oWsdl:cError)
		return nProc
	EndIf


	lRet:= oWsdl:SendSoapMsg()
	if lRet== .F.
		conOut("   enviando mensagem para o servidor... erro: " + oWsdl:cError )
		Return nProc
	endif

	cXMLRet := oWsdl:GetSoapResponse()

	oRet := XmlParser(cXMLRet,"_",@cErro,@cAviso)     // Abre arquivo e retorna objeto com os dados do XML

	If !Empty(cAviso)
		Conout("Nùo foi possùvel ler o retorno ->"+cAviso,"Atenùùo - "+ProcName())
		Return nProc
	EndIf

	If !Empty(cErro)
		Conout("Nùo foi possùvel ler o retorno -> "+cErro,"Atenùùo - "+ProcName())
		Return nProc
	EndIf

	If Type('oRet:_S_ENVELOPE:_S_BODY:_RETORNAREMPRESAATIVADAINATIVADARESPONSE:_RETORNAREMPRESAATIVADAINATIVADARESULT:_A_LSTOBJETORETORNO:_A_EMPRESADTO') == 'U'
		return nProc
	Endif

	If Type('oRet:_S_ENVELOPE:_S_BODY:_RETORNAREMPRESAATIVADAINATIVADARESPONSE:_RETORNAREMPRESAATIVADAINATIVADARESULT:_A_LSTOBJETORETORNO:_A_EMPRESADTO') == 'O'
		If !XmlNode2Arr(oRet:_S_ENVELOPE:_S_BODY:_RETORNAREMPRESAATIVADAINATIVADARESPONSE:_RETORNAREMPRESAATIVADAINATIVADARESULT:_A_LSTOBJETORETORNO:_A_EMPRESADTO, "_A_EMPRESADTO" )
			Return nProc
		Endif
	Endif

	SetRegua2(@oProcess, 0)
	IncRegua2(@oProcess, "Processando alteraùùo Fornecedor")

	aFornec := len(oRet:_S_ENVELOPE:_S_BODY:_RETORNAREMPRESAATIVADAINATIVADARESPONSE:_RETORNAREMPRESAATIVADAINATIVADARESULT:_A_LSTOBJETORETORNO:_A_EMPRESADTO)

	For nX := 1 To  aFornec

		lExitBanco	:= .f.
		nProc ++
		cGC       := oRet:_S_ENVELOPE:_S_BODY:_RETORNAREMPRESAATIVADAINATIVADARESPONSE:_RETORNAREMPRESAATIVADAINATIVADARESULT:_A_LSTOBJETORETORNO:_A_EMPRESADTO[nX]:_A_SNRCNPJ:text
		cNome  	  := oRet:_S_ENVELOPE:_S_BODY:_RETORNAREMPRESAATIVADAINATIVADARESPONSE:_RETORNAREMPRESAATIVADAINATIVADARESULT:_A_LSTOBJETORETORNO:_A_EMPRESADTO[nX]:_A_SNMEMPRESA:text
		cNomeReduz := oRet:_S_ENVELOPE:_S_BODY:_RETORNAREMPRESAATIVADAINATIVADARESPONSE:_RETORNAREMPRESAATIVADAINATIVADARESULT:_A_LSTOBJETORETORNO:_A_EMPRESADTO[nX]:_A_SNMFANTASIA:text
		cHomePAge  := oRet:_S_ENVELOPE:_S_BODY:_RETORNAREMPRESAATIVADAINATIVADARESPONSE:_RETORNAREMPRESAATIVADAINATIVADARESULT:_A_LSTOBJETORETORNO:_A_EMPRESADTO[nX]:_A_SDSURL:text
		cCep  	  := StrTran(oRet:_S_ENVELOPE:_S_BODY:_RETORNAREMPRESAATIVADAINATIVADARESPONSE:_RETORNAREMPRESAATIVADAINATIVADARESULT:_A_LSTOBJETORETORNO:_A_EMPRESADTO[nX]:_A_SDSCEP:text,"-", "")
		cEst  	  :=  oRet:_S_ENVELOPE:_S_BODY:_RETORNAREMPRESAATIVADAINATIVADARESPONSE:_RETORNAREMPRESAATIVADAINATIVADARESULT:_A_LSTOBJETORETORNO:_A_EMPRESADTO[nX]:_A_SSGESTADO:text
		cBairro   :=  oRet:_S_ENVELOPE:_S_BODY:_RETORNAREMPRESAATIVADAINATIVADARESPONSE:_RETORNAREMPRESAATIVADAINATIVADARESULT:_A_LSTOBJETORETORNO:_A_EMPRESADTO[nX]:_A_SNMBAIRRO:text
		cEndereco := oRet:_S_ENVELOPE:_S_BODY:_RETORNAREMPRESAATIVADAINATIVADARESPONSE:_RETORNAREMPRESAATIVADAINATIVADARESULT:_A_LSTOBJETORETORNO:_A_EMPRESADTO[nX]:_A_SDSENDERECO:text
		cNumero   := oRet:_S_ENVELOPE:_S_BODY:_RETORNAREMPRESAATIVADAINATIVADARESPONSE:_RETORNAREMPRESAATIVADAINATIVADARESULT:_A_LSTOBJETORETORNO:_A_EMPRESADTO[nX]:_A_SNRENDERECO:text
		cCidade   :=  oRet:_S_ENVELOPE:_S_BODY:_RETORNAREMPRESAATIVADAINATIVADARESPONSE:_RETORNAREMPRESAATIVADAINATIVADARESULT:_A_LSTOBJETORETORNO:_A_EMPRESADTO[nX]:_A_SNMCIDADE:text
		cCOMPLEM  := oRet:_S_ENVELOPE:_S_BODY:_RETORNAREMPRESAATIVADAINATIVADARESPONSE:_RETORNAREMPRESAATIVADAINATIVADARESULT:_A_LSTOBJETORETORNO:_A_EMPRESADTO[nX]:_A_SDSENDERECOCOMPLEMENTO:text
		cCodMun	  := ''
		cBanco	  := ''

		cTel 	  := StrTran(oRet:_S_ENVELOPE:_S_BODY:_RETORNAREMPRESAATIVADAINATIVADARESPONSE:_RETORNAREMPRESAATIVADAINATIVADARESULT:_A_LSTOBJETORETORNO:_A_EMPRESADTO[nX]:_A_SNRTELEFONE:text,"-", "")
		cTel 	  := StrTran(oRet:_S_ENVELOPE:_S_BODY:_RETORNAREMPRESAATIVADAINATIVADARESPONSE:_RETORNAREMPRESAATIVADAINATIVADARESULT:_A_LSTOBJETORETORNO:_A_EMPRESADTO[nX]:_A_SNRTELEFONE:text,"(", "")
		cTel 	  := StrTran(oRet:_S_ENVELOPE:_S_BODY:_RETORNAREMPRESAATIVADAINATIVADARESPONSE:_RETORNAREMPRESAATIVADAINATIVADARESULT:_A_LSTOBJETORETORNO:_A_EMPRESADTO[nX]:_A_SNRTELEFONE:text,")", "")
		cTel 	  := StrTran(oRet:_S_ENVELOPE:_S_BODY:_RETORNAREMPRESAATIVADAINATIVADARESPONSE:_RETORNAREMPRESAATIVADAINATIVADARESULT:_A_LSTOBJETORETORNO:_A_EMPRESADTO[nX]:_A_SNRTELEFONE:text,".", "")

		cContato :=  oRet:_S_ENVELOPE:_S_BODY:_RETORNAREMPRESAATIVADAINATIVADARESPONSE:_RETORNAREMPRESAATIVADAINATIVADARESULT:_A_LSTOBJETORETORNO:_A_EMPRESADTO[nX]:_A_SNMCONTATO:text
		cEMail   :=  oRet:_S_ENVELOPE:_S_BODY:_RETORNAREMPRESAATIVADAINATIVADARESPONSE:_RETORNAREMPRESAATIVADAINATIVADARESULT:_A_LSTOBJETORETORNO:_A_EMPRESADTO[nX]:_A_SDSEMAILCONTATO:text
		cIE		:=  oRet:_S_ENVELOPE:_S_BODY:_RETORNAREMPRESAATIVADAINATIVADARESPONSE:_RETORNAREMPRESAATIVADAINATIVADARESULT:_A_LSTOBJETORETORNO:_A_EMPRESADTO[nX]:_A_SNRINSCRICAOESTADUAL:text
		cIEmun   :=  oRet:_S_ENVELOPE:_S_BODY:_RETORNAREMPRESAATIVADAINATIVADARESPONSE:_RETORNAREMPRESAATIVADAINATIVADARESULT:_A_LSTOBJETORETORNO:_A_EMPRESADTO[nX]:_A_SNRINSCRICAOMUNICIPAL:text

		cOrigem    :=  oRet:_S_ENVELOPE:_S_BODY:_RETORNAREMPRESAATIVADAINATIVADARESPONSE:_RETORNAREMPRESAATIVADAINATIVADARESULT:_A_LSTOBJETORETORNO:_A_EMPRESADTO[nX]:_A_NCDEMPRESAWBC:text
		cBloq	   := oRet:_S_ENVELOPE:_S_BODY:_RETORNAREMPRESAATIVADAINATIVADARESPONSE:_RETORNAREMPRESAATIVADAINATIVADARESULT:_A_LSTOBJETORETORNO:_A_EMPRESADTO[nX]:_A_NCDSITUACAO:text
		IncRegua2(@oProcess, "Processando " + cGC + "/" + cNome)

		If Type('oRet:_S_ENVELOPE:_S_BODY:_RETORNAREMPRESAATIVADAINATIVADARESPONSE:_RETORNAREMPRESAATIVADAINATIVADARESULT:_A_LSTOBJETORETORNO:_A_EMPRESADTO[nX]:_A_LSTEMPRESABANCO:_A_EMPRESABANCODTO') <> 'U'
			lExitBanco	:= .t.
			/*if len(oRet:_S_ENVELOPE:_S_BODY:_RETORNAREMPRESAATIVADAINATIVADARESPONSE:_RETORNAREMPRESAATIVADAINATIVADARESULT:_A_LSTOBJETORETORNO:_A_EMPRESADTO[nX]:_A_LSTEMPRESABANCO:_A_EMPRESABANCODTO) > 1
			    cBanco	   := oRet:_S_ENVELOPE:_S_BODY:_RETORNAREMPRESAATIVADAINATIVADARESPONSE:_RETORNAREMPRESAATIVADAINATIVADARESULT:_A_LSTOBJETORETORNO:_A_EMPRESADTO[nX]:_A_LSTEMPRESABANCO:_A_EMPRESABANCODTO[1]:_A_SCDBANCO:TEXT
				cAgencia   :=  oRet:_S_ENVELOPE:_S_BODY:_RETORNAREMPRESAATIVADAINATIVADARESPONSE:_RETORNAREMPRESAATIVADAINATIVADARESULT:_A_LSTOBJETORETORNO:_A_EMPRESADTO[nX]:_A_LSTEMPRESABANCO:_A_EMPRESABANCODTO[1]:_A_SCDAGENCIA:TEXT
				cDivAg	   :=  oRet:_S_ENVELOPE:_S_BODY:_RETORNAREMPRESAATIVADAINATIVADARESPONSE:_RETORNAREMPRESAATIVADAINATIVADARESULT:_A_LSTOBJETORETORNO:_A_EMPRESADTO[nX]:_A_LSTEMPRESABANCO:_A_EMPRESABANCODTO[1]:_A_SCDAGENCIADIGITO:TEXT
				cContaBanc :=  oRet:_S_ENVELOPE:_S_BODY:_RETORNAREMPRESAATIVADAINATIVADARESPONSE:_RETORNAREMPRESAATIVADAINATIVADARESULT:_A_LSTOBJETORETORNO:_A_EMPRESADTO[nX]:_A_LSTEMPRESABANCO:_A_EMPRESABANCODTO[1]:_A_SCDCONTACORRENTE:TEXT
				cDivConta  :=  oRet:_S_ENVELOPE:_S_BODY:_RETORNAREMPRESAATIVADAINATIVADARESPONSE:_RETORNAREMPRESAATIVADAINATIVADARESULT:_A_LSTOBJETORETORNO:_A_EMPRESADTO[nX]:_A_LSTEMPRESABANCO:_A_EMPRESABANCODTO[1]:_A_SCDCONTADIGITO:TEXT
				cTpConta  :=  oRet:_S_ENVELOPE:_S_BODY:_RETORNAREMPRESAATIVADAINATIVADARESPONSE:_RETORNAREMPRESAATIVADAINATIVADARESULT:_A_LSTOBJETORETORNO:_A_EMPRESADTO[nX]:_A_LSTEMPRESABANCO:_A_EMPRESABANCODTO[1]:_A_NCDTIPOCONTA:TEXT
			else*/
			cBanco	   := oRet:_S_ENVELOPE:_S_BODY:_RETORNAREMPRESAATIVADAINATIVADARESPONSE:_RETORNAREMPRESAATIVADAINATIVADARESULT:_A_LSTOBJETORETORNO:_A_EMPRESADTO[nX]:_A_LSTEMPRESABANCO:_A_EMPRESABANCODTO:_A_SCDBANCO:TEXT
			cAgencia   :=  oRet:_S_ENVELOPE:_S_BODY:_RETORNAREMPRESAATIVADAINATIVADARESPONSE:_RETORNAREMPRESAATIVADAINATIVADARESULT:_A_LSTOBJETORETORNO:_A_EMPRESADTO[nX]:_A_LSTEMPRESABANCO:_A_EMPRESABANCODTO:_A_SCDAGENCIA:TEXT
			cDivAg	   :=  oRet:_S_ENVELOPE:_S_BODY:_RETORNAREMPRESAATIVADAINATIVADARESPONSE:_RETORNAREMPRESAATIVADAINATIVADARESULT:_A_LSTOBJETORETORNO:_A_EMPRESADTO[nX]:_A_LSTEMPRESABANCO:_A_EMPRESABANCODTO:_A_SCDAGENCIADIGITO:TEXT
			cContaBanc :=  oRet:_S_ENVELOPE:_S_BODY:_RETORNAREMPRESAATIVADAINATIVADARESPONSE:_RETORNAREMPRESAATIVADAINATIVADARESULT:_A_LSTOBJETORETORNO:_A_EMPRESADTO[nX]:_A_LSTEMPRESABANCO:_A_EMPRESABANCODTO:_A_SCDCONTACORRENTE:TEXT
			cDivConta  :=  oRet:_S_ENVELOPE:_S_BODY:_RETORNAREMPRESAATIVADAINATIVADARESPONSE:_RETORNAREMPRESAATIVADAINATIVADARESULT:_A_LSTOBJETORETORNO:_A_EMPRESADTO[nX]:_A_LSTEMPRESABANCO:_A_EMPRESABANCODTO:_A_SCDCONTADIGITO:TEXT
			cTpConta  :=  oRet:_S_ENVELOPE:_S_BODY:_RETORNAREMPRESAATIVADAINATIVADARESPONSE:_RETORNAREMPRESAATIVADAINATIVADARESULT:_A_LSTOBJETORETORNO:_A_EMPRESADTO[nX]:_A_LSTEMPRESABANCO:_A_EMPRESABANCODTO:_A_NCDTIPOCONTA:TEXT
			//endif
		Endif

		SA2->(DbSetOrder(3))
		If !SA2->(MsSeek(FWxFilial('SA2') + cGC))
			cErro := "Fornecedor nùo localizado -  "  + cGC
			aAdd(aLogInt, {;
				'RetornarEmpresaAtivadaInativada',;
				cErro,;
				,;
				,;
				0;
				})

			fWsLogRet(aLogInt, oLog, "",,, .T.)
			LogMsg("PAR001", 0, 6, 1, '', '', "PAR001 -  FFornecedor nùo localizado  -  Empresa:"+FWGrpCompany()  + "- RetornarEmpresaAtivadaInativada" )
			loop
		Endif

		oModel 		:= nil
		aErro		:= nil
		aLogInt  	:= {}

		oModel := FWLoadModel('MATA020')

		oModel:SetOperation(4)
		oModel:Activate()


		//If Upper(NoAcento(Alltrim(SA2->A2_NOME ))) <>  Upper(NoAcento(Alltrim(cNome)))
		oModel:SetValue('SA2MASTER','A2_NOME',  Padr(Retigraf(cNome), tamsx3('A2_NOME')[1]) )
		//Endif
		//COR002
		//If Upper(NoAcento(Alltrim(SA2->A2_NREDUZ ))) <>  Upper(NoAcento(Alltrim(cNomeReduz)))
		oModel:SetValue('SA2MASTER','A2_NREDUZ',  Padr(cNomeReduz, tamsx3('A2_NREDUZ')[1]) )
		//Endif

		If Upper(NoAcento(Alltrim(SA2->A2_HPAGE))) <>  Upper(NoAcento(Alltrim(cHomePAge)))
			oModel:SetValue('SA2MASTER','A2_HPAGE',  Padr(cHomePAge, tamsx3('A2_HPAGE')[1]) )
		Endif

		If Upper(NoAcento(Alltrim(SA2->A2_CONTATO))) <>  Upper(NoAcento(Alltrim(cContato)))
			oModel:SetValue('SA2MASTER','A2_CONTATO',  Padr(cContato, tamsx3('A2_CONTATO')[1]) )
		Endif
		oModel:SetValue('SA2MASTER','A2_CONTA',  "2001010010" )

		oModel:SetValue('SA2MASTER','A2_INSCR' ,IIf(Empty(cIE) , 'ISENTO', cIE))
		oModel:SetValue('SA2MASTER','A2_INSCRM' ,IIf(Empty(cIEmun), 'ISENTO', cIEmun))
		oModel:SetValue('SA2MASTER','A2_XINTPA' ,'1')

		oModel:SetValue('SA2MASTER','A2_RECISS' ,"N")
		oModel:SetValue('SA2MASTER','A2_RECINSS' ,"N")
		oModel:SetValue('SA2MASTER','A2_RECPIS' ,"1")
		oModel:SetValue('SA2MASTER','A2_RECCOFI' ,"1")
		oModel:SetValue('SA2MASTER','A2_RECCSLL' ,"1")



		If Alltrim(SA2->(A2_DDD+A2_TEL)) <>  Alltrim(cTel)
			If Len(cTel) > 8
				oModel:SetValue('SA2MASTER','A2_DDD' ,SUBSTR(cTel,1,2))
				oModel:SetValue('SA2MASTER','A2_TEL' ,SUBSTR(cTel,3,9))
				oModel:SetValue('SA2MASTER','A2_XTEL' ,SUBSTR(cTel,3,9))
			else
				oModel:SetValue('SA2MASTER','A2_DDD' ,'00')
				oModel:SetValue('SA2MASTER','A2_TEL' ,cTel)
				oModel:SetValue('SA2MASTER','A2_XTEL' ,cTel)
			endif
		Endif

		oModel:SetValue('SA2MASTER','A2_MSBLQL' ,iif(cBloq != '1', padr('1',GETSX3CACHE("A2_MSBLQL","X3_TAMANHO")), padr('2',GETSX3CACHE("A2_MSBLQL","X3_TAMANHO"))))
		oModel:SetValue('SA2MASTER','A2_XMOTBLQ' ,padr('Fornecedor portal paradigma',GETSX3CACHE("A2_XMOTBLQ","X3_TAMANHO")))
		oModel:SetValue('SA2MASTER','A2_XMOTDBL' ,padr('Fornecedor portal paradigma',GETSX3CACHE("A2_XMOTDBL","X3_TAMANHO")))

		If Upper(NoAcento(Alltrim(SA2->A2_EMAIL ))) <>  Upper(NoAcento(Alltrim(cEMail)))
			oModel:SetValue('SA2MASTER','A2_EMAIL',  Padr(cEMail, tamsx3('A2_EMAIL')[1]) )
		Else
			oModel:SetValue('SA2MASTER','A2_EMAIL',  Padr(cEMail, tamsx3('A2_EMAIL')[1]) )
		Endif

		//Consulta CEP
		cAliasCid := GetNextAlias()
		cSQL := " SELECT CC2_CODMUN ,CC2_MUN,CC2_EST"+CRLF
		cSQL += " FROM " + RetSqlName("CC2") + " CC2 "+CRLF
		cSQL += " WHERE CC2_FILIAL = '" + cFilCC2+ "' "+CRLF
		cSQL += " AND CC2_EST = '" + UPPER(cEst) + "' "
		cSQL += " AND LTRIM(RTRIM(CC2_MUN)) = " + valtosql(NOACENTO(UPPER(cCidade))) + " "+CRLF
		cSQL += " AND D_E_L_E_T_ = ' ' "+CRLF

		MpSysOpenQuery(cSQL,cAliasCid)

		If (cAliasCid)->(!Eof())
			cCodMun := (cAliasCid)->CC2_CODMUN
			cNomMun := (cAliasCid)->CC2_MUN
		Endif

		(cAliasCid)->(DbCloseArea())

		If Empty(cCodMun )

			aAdd(aLogInt, {;
				'RetornarEmpresaAtivadaInativada',;
				'Nùo foi localizado cùdigo do municipio na CC2',;
				,;
				,;
				0;
				})

			fWsLogRet(aLogInt, oLog, "",,, .T.)
			oModel:DeActivate()
			oModel:Destroy()
			loop
		Endif

		//Tratando endereùo
		If  Alltrim(SA2->A2_CEP ) <>  Alltrim(cCep)
			oModel:SetValue('SA2MASTER','A2_CEP',  Padr(cCep, tamsx3('A2_CEP')[1]) )
		Endif

		cEndereco  :=  Iif(!Empty(cNumero),Padr(cEndereco+','+cNumero, tamsx3('A2_END')[1]), Padr(cEndereco, tamsx3('A2_END')[1]))

		oModel:SetValue('SA2MASTER','A2_END' ,cEndereco)
		oModel:SetValue('SA2MASTER','A2_COMPLEM', Padr(cCOMPLEM, tamsx3('A2_COMPLEM')[1]) )
		oModel:SetValue('SA2MASTER','A2_BAIRRO' , Padr(cBairro, tamsx3('A2_BAIRRO')[1])  )
		oModel:LoadValue('SA2MASTER','A2_COD_MUN',ALLTRIM(cCodMun))
		oModel:SetValue('SA2MASTER','A2_MUN' , Padr(cCidade, tamsx3('A2_MUN')[1]) )

		If lExitBanco
			oModel:LoadValue('SA2MASTER','A2_BANCO', Padr(cBanco, tamsx3('A2_BANCO')[1]) )
			oModel:LoadValue('SA2MASTER','A2_AGENCIA' , Padr(cAgencia, tamsx3('A2_AGENCIA')[1])  )
			oModel:LoadValue('SA2MASTER','A2_DVAGE',Padr(cDivAg, tamsx3('A2_DVAGE')[1]))
			oModel:LoadValue('SA2MASTER','A2_NUMCON' , Padr(cContaBanc, tamsx3('A2_NUMCON')[1]) )
			oModel:LoadValue('SA2MASTER','A2_DVCTA' , Padr(cDivConta, tamsx3('A2_DVCTA')[1]) )
			oModel:LoadValue('SA2MASTER','A2_TIPCTA', Padr(cTpConta, tamsx3('A2_TIPCTA')[1]) )
		Endif

		If oModel:VldData()
			oModel:CommitData()
			LogMsg("PAR001", 0, 6, 1, '', '', " Fornecedor " + SA2->A2_COD + SA2->A2_LOJA + " alterado com sucesso! - RetornarEmpresaAtivadaInativada" )
			oLog:NovoLog()
			oLog:Retorno := 1
			oLog:Origem := cValToChar(cOrigem)
			oLog:MsgLog := "Fornecedor " + SA2->A2_COD + SA2->A2_LOJA + " alterado com sucesso!"
			oLog:SoapFault := "Fornecedor " + SA2->A2_COD + SA2->A2_LOJA + " alterado com sucesso!"
			oLog:Tstamp := FwTimeStamp(3)
			oLog:Token := 'MATA020'
			oLog:SalvaObj('SA2')
		Else
			aErro := oModel:GetErrorMessage()
			cErro := "Falha na alteraùùo do fornecedor : "  + cGC
			cErro += ( "Id do formulùrio de origem:" + ' [' + AllToChar( aErro[1] ) + ']' )
			cErro += ( "Id do campo de origem: " + ' [' + AllToChar( aErro[2] ) + ']' )
			cErro += ( "Id do formulùrio de erro: " + ' [' + AllToChar( aErro[3] ) + ']' )
			cErro += ( "Id do campo de erro: " + ' [' + AllToChar( aErro[4] ) + ']' )
			cErro += ( "Id do erro: " + ' [' + AllToChar( aErro[5] ) + ']' )
			cErro += ( "Mensagem do erro: " + ' [' + AllToChar( aErro[6] ) + ']' )
			cErro += ( "Mensagem da soluùùo: " + ' [' + AllToChar( aErro[7] ) + ']' )
			cErro += ( "Valor atribuùdo: " + ' [' + AllToChar( aErro[8] ) + ']' )
			cErro += ( "Valor anterior: " + ' [' + AllToChar( aErro[9] ) + ']' )


			VarInfo("Erro na alteraùùo do fornecedor",aErro)


			aAdd(aLogInt, {;
				'RetornarEmpresaAtivadaInativada',;
				cErro,;
				,;
				,;
				0;
				})

			fWsLogRet(aLogInt, oLog, "",,, .T.)
		Endif

		oModel:DeActivate()
		oModel:Destroy()
	Next Nx
	FreeObj(oLog)
	FreeObj(oWsdl)
Return nProc


/*/{Protheus.doc} ToXMlProcessarEmpresa
    Montar xml para envio do serviùo ProcessaEmpresa
	@type  Static Function
	@author Rubem Cerqueira
	@since 22/03/2021
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
/*/
static function ToXMlProcessarEmpresa(aEmpDto,aCrcHistoricoDTO,aEmpresaBancoDTO,aEmpresaClasseDTO,aEmpresaContatoDTO,alstDocumentoContato,aTipoContatoDTO,;
		aLstEmpresaEnderecoCobranca, aLstEmpresaEnderecoEntrega,aLstEmpresaEnderecoFaturamento,aLstEmpresaEnderecoInstitucional)

	Local cXML as char
	Local x1,x2

	Default aCrcHistoricoDTO	:= {}
	Default aEmpresaBancoDTO	:= {}
	Default aEmpresaClasseDTO		:= {}
	Default aEmpresaContatoDTO		:= {}
	Default alstDocumentoContato	:= {}
	Default DefaultaTipoContatoDTO		:= {}
	Default aLstEmpresaEnderecoCobranca	:= {}
	Default aLstEmpresaEnderecoEntrega	:= {}
	Default aLstEmpresaEnderecoFaturamento := {}
	Default aLstEmpresaEnderecoInstituciona := {}
	Default aTipoContatoDTO := {}

	cXML :=	'<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/" xmlns:par="http://schemas.datacontract.org/2004/07/Paradigma.Wbc.Servico.DTO">'
	cXML += ' <soapenv:Header/>'
	cXML +=   '<soapenv:Body>'
	cXML +=       '<tem:ProcessarEmpresa>'
	cXML +=  ' <tem:lstEmpresa>'
	cXML +=    		 '<par:EmpresaDTO>'


	If !EMPTY(aEmpDto[1])
		cXML +='<par:nCdEmpresaWbc>'+ ConvType(aEmpDto[1])+'</par:nCdEmpresaWbc>'
	Endif

	If !EMPTY(aEmpDto[2])
		cXML +='<par:nCdIdioma>'+ConvType(aEmpDto[2])+'</par:nCdIdioma>'
	Endif

	If !EMPTY(aEmpDto[3])
		cXML +='<par:nCdPorte>'+ConvType(aEmpDto[3])+'</par:nCdPorte>'
	endif

	If !EMPTY(aEmpDto[4])
		cXML +='<par:nCdSituacao>'+ConvType(aEmpDto[4])+'</par:nCdSituacao>'
	endif

	If !EMPTY(aEmpDto[5])
		cXML +='<par:nCdTipo>'+ConvType(aEmpDto[5])+'</par:nCdTipo>'
	else
		cXML +='<par:nCdTipo>3</par:nCdTipo>'
	endif

	If !EMPTY(aEmpDto[6])
		cXML +='<par:nCdTipoCadastroMap>'+ConvType(aEmpDto[6])+'</par:nCdTipoCadastroMap>'
	endif

	If !EMPTY(aEmpDto[7])
		cXML +='<par:nIdPerfilTributario>'+ConvType(aEmpDto[7])+'</par:nIdPerfilTributario>'
	endif

	If !EMPTY(aEmpDto[8])
		cXML +='<par:nIdSuperSimples>'+ConvType(aEmpDto[8])+'</par:nIdSuperSimples>'
	endif

	If !EMPTY(aEmpDto[9])
		cXML +='<par:nIdTipoPessoa>'+ConvType(aEmpDto[9])+'</par:nIdTipoPessoa>'
	endif

	If !EMPTY(aEmpDto[10])
		cXML +='<par:nIdTipoSocio>'+ConvType(aEmpDto[10])+'</par:nIdTipoSocio>'
	endif

	If !EMPTY(aEmpDto[11])
		cXML +='<par:nNrAutoAvaliacao>'+ConvType(aEmpDto[11])+'</par:nNrAutoAvaliacao>'
	endif

	If !EMPTY(aEmpDto[12])
		cXML +='<par:sCdAtividadeMap>'+ConvType(aEmpDto[1])+'</par:sCdAtividadeMap>'
	endif

	If !EMPTY(aEmpDto[13])
		cXML +='<par:sCdCnae>'+ConvType(aEmpDto[13])+'</par:sCdCnae>'
	endif

	If !Empty(aEmpDto[14])
		cXML +='<par:sCdEmpresa>'+ConvType(aEmpDto[14])+'</par:sCdEmpresa>'
	endif

	If !EMPTY(aEmpDto[15])
		cXML +='<par:sCdEmpresaCliente>'+ConvType(aEmpDto[15])+'</par:sCdEmpresaCliente>'
	endif

	If !EMPTY(aEmpDto[16])
		cXML +='<par:sCdEmpresaEnvio>'+ConvType(aEmpDto[16])+'</par:sCdEmpresaEnvio>'
	Endif

	If !EMPTY(aEmpDto[17])
		cXML +='<par:sCdModeloLoja>'+ConvType(aEmpDto[17])+'</par:sCdModeloLoja>'
	endif

	If !EMPTY(aEmpDto[18])
		cXML +='<par:sCdMoeda>'+ConvType(aEmpDto[18])+'</par:sCdMoeda>'
	Else
		cXML +='<par:sCdMoeda>1</par:sCdMoeda>'
	Endif

	If !EMPTY(aEmpDto[19])
		cXML +='<par:sCdNaturezaJuridica>'+ConvType(aEmpDto[19])+'</par:sCdNaturezaJuridica>'
	endif

	If !EMPTY(aEmpDto[20])
		cXML +='<par:sCdPadraoArquitetura>'+ConvType(aEmpDto[20])+'</par:sCdPadraoArquitetura>'
	endif

	If !EMPTY(aEmpDto[21])
		cXML +='<par:sCdTipoBeneficio>'+ConvType(aEmpDto[21])+'</par:sCdTipoBeneficio>'
	endif

	If !EMPTY(aEmpDto[22])
		cXML +='<par:sCdTipoLoja>'+ConvType(aEmpDto[22])+'</par:sCdTipoLoja>'
	endif


	If !EMPTY(aEmpDto[23])
		cXML +='<par:sCdUsarioHomologador>'+ConvType(aEmpDto[23])+'</par:sCdUsarioHomologador>'
	endif

	If !EMPTY(aEmpDto[24])
		cXML +='<par:sDsCep>'+ConvType( StrTran(aEmpDto[24],'-',""))+'</par:sDsCep>'
	endif

	If !EMPTY(aEmpDto[25])
		cXML +='<par:sDsEmailContato>'+ConvType(aEmpDto[25])+'</par:sDsEmailContato>'
	endif

	If !EMPTY(aEmpDto[26])
		cXML +='<par:sDsEndereco>'+ConvType(aEmpDto[26])+'</par:sDsEndereco>'
	endif

	If !EMPTY(aEmpDto[27])
		cXML +='<par:sDsEnderecoComplemento>'+ConvType(aEmpDto[27])+'</par:sDsEnderecoComplemento>'
	endif

	If !EMPTY(aEmpDto[28])
		cXML +='<par:sDsUrl>'+ConvType(aEmpDto[28])+'</par:sDsUrl>'
	endif

	If !EMPTY(aEmpDto[29])
		cXML +='<par:sNmApelido>'+ConvType(aEmpDto[29])+'</par:sNmApelido>'
	endif

	If !EMPTY(aEmpDto[30])
		cXML +='<par:sNmBairro>'+ConvType(aEmpDto[30])+'</par:sNmBairro>'
	endif

	If !EMPTY(aEmpDto[31])
		cXML +='<par:sNmCidade>'+ConvType(aEmpDto[31])+'</par:sNmCidade>'
	endif

	If !EMPTY(aEmpDto[32])
		cXML +='<par:sNmContato>'+ConvType(aEmpDto[32])+'</par:sNmContato>'
	endif

	If !EMPTY(aEmpDto[33])
		cXML +='<par:sNmEmpresa>'+ConvType(aEmpDto[33])+'</par:sNmEmpresa>'
	endif

	If !EMPTY(aEmpDto[34])
		cXML +='<par:sNmFantasia>'+ConvType(aEmpDto[34])+'</par:sNmFantasia>'
	endif

	If !EMPTY(aEmpDto[35])
		cXML +='<par:sNrCelular>'+ConvType(aEmpDto[35])+'</par:sNrCelular>'
	endif

	If !EMPTY(aEmpDto[36])
		cXML +='<par:sNrCnpj>'+ConvType(aEmpDto[36])+'</par:sNrCnpj>'
	EndIF

	If !EMPTY(aEmpDto[37])
		cXML +='<par:sNrCnpjMatriz>'+ConvType(aEmpDto[37])+'</par:sNrCnpjMatriz>'
	endif

	If !EMPTY(aEmpDto[38])
		cXML +='<par:sNrEndereco>'+ConvType(aEmpDto[38])+'</par:sNrEndereco>'
	endif

	If !EMPTY(aEmpDto[39])
		cXML +='<par:sNrFax>'+ConvType(aEmpDto[39])+'</par:sNrFax>'
	endif

	If !EMPTY(aEmpDto[40])
		cXML +='<par:sNrInscricaoEstadual>'+ConvType(aEmpDto[40])+'</par:sNrInscricaoEstadual>'
	endif

	If !EMPTY(aEmpDto[41])
		cXML +='<par:sNrInscricaoMunicial>'+ConvType(aEmpDto[41])+'</par:sNrInscricaoMunicial>'
	endif

	If !EMPTY(aEmpDto[42])
		cXML +='<par:sNrInscricaoMunicipal>'+ConvType(aEmpDto[42])+'</par:sNrInscricaoMunicipal>'
	endif

	If !EMPTY(aEmpDto[43])
		cXML +='<par:sNrTelefone>'+ConvType(aEmpDto[43])+'</par:sNrTelefone>'
	endif

	If !EMPTY(aEmpDto[44])
		cXML +='<par:sSgEstado>'+ConvType(aEmpDto[44])+'</par:sSgEstado>'
	endif

	If !EMPTY(aEmpDto[45])
		cXML +='<par:sSgGrupoConta>'+ConvType(aEmpDto[45])+'</par:sSgGrupoConta>'
	endif

	If !EMPTY(aEmpDto[46])
		cXML +='<par:sSgPais>'+ConvType(aEmpDto[46])+'</par:sSgPais>'
	endif

	If !EMPTY(aEmpDto[47])
		cXML +='<par:tDtCadastro>'+ConvType(aEmpDto[47])+'</par:tDtCadastro>'
	endif

	If !EMPTY(aEmpDto[48])
		cXML +='<par:tDtInicioAtividade>'+ConvType(aEmpDto[48])+'</par:tDtInicioAtividade>'
	Endif

	If !EMPTY(aEmpDto[49])
		cXML +='<par:tDtIntegralizacao>'+ConvType(aEmpDto[49])+'</par:tDtIntegralizacao>'
	Endif
	If !EMPTY(aEmpDto[50])
		cXML +='<par:tDtValidadeCadastro>'+ConvType(aEmpDto[50])+'</par:tDtValidadeCadastro>'
	Endif

	If !Empty(aEmpDto[51])
		cXML +='<par:bFlAreaInfluencia>'+ConvType(aEmpDto[51])+'</par:bFlAreaInfluencia>'
	Endif

	If !Empty(aEmpDto[52])
		cXML += '<par:bFlAtividadeComercial>'+ConvType(aEmpDto[52])+'</par:bFlAtividadeComercial>'
	endif

	If !Empty(aEmpDto[53])
		cXML += '<par:bFlAtividadeIndustrial>'+ConvType(aEmpDto[53])+'</par:bFlAtividadeIndustrial>'
	endif

	If !Empty(aEmpDto[56])
		cXML += '<par:bFlAtividadeServico>'+ConvType(aEmpDto[54])+'</par:bFlAtividadeServico>'
	endif

	If !Empty(aEmpDto[55])
		cXML += '<par:dVlCapitalIntegralizado>'+ConvType(aEmpDto[55])+'</par:dVlCapitalIntegralizado>'
	endif

	If !Empty(aEmpDto[56])
		cXML +='<par:dVlCapitalSocial>'+ConvType(aEmpDto[56])+'</par:dVlCapitalSocial>'
	endif

	If !Empty(aEmpDto[57])
		cXML +=' <par:dVlPatrimonioLiquido>'+ConvType(aEmpDto[57])+'</par:dVlPatrimonioLiquido>'
	endif
	x1 := 0
	If Len(aCrcHistoricoDTO) > 0
		cXML +=' <par:lstDocumento>'
		For x1 := 1 To Len(aCrcHistoricoDTO)
			cXML +=' <par:CrcHistoricoDTO>'

			If !EMPTY(aCrcHistoricoDTO[x1][1])
				cXML += '<par:nCdCrcHistorico>' + ConvType(aCrcHistoricoDTO[x1][1])+'</par:nCdCrcHistorico>'
			endif
			If !EMPTY(aCrcHistoricoDTO[x1][2])
				cXML += '<par:nCdVersao>' + ConvType(aCrcHistoricoDTO[x1][2])+'</par:nCdVersao>'
			endif

			If !EMPTY(aCrcHistoricoDTO[x1][3])
				cXML += '<par:nNrOrdem>' + ConvType(aCrcHistoricoDTO[x1][3])+'</par:nNrOrdem>'
			endif

			If !EMPTY(aCrcHistoricoDTO[x1][4])
				cXML += '<par:sDsLink>' + ConvType(aCrcHistoricoDTO[x1][4])+'</par:sDsLink>'
			endif

			If !EMPTY(aCrcHistoricoDTO[x1][5])
				cXML += '<par:sNmDocumento>' + ConvType(aCrcHistoricoDTO[x1][5])+'</par:sNmDocumento>'
			endif

			If !EMPTY(aCrcHistoricoDTO[x1][6])
				cXML += '<par:sSgDocumento>' + ConvType(aCrcHistoricoDTO[x1][6])+'</par:sSgDocumento>'
			endif

			If !EMPTY(aCrcHistoricoDTO[x1][7])
				cXML += '<par:tDtHistorico>' + ConvType(aCrcHistoricoDTO[x1][7])+'</par:tDtHistorico>'
			endif
			cXML +=' </par:CrcHistoricoDTO>'
		Next
		cXML +=' </par:lstDocumento>'
	Endif
	x1 := 0
	If Len(aEmpresaBancoDTO) > 0
		cXML += '<par:lstEmpresaBanco>'
		For x1 := 1 to len(aEmpresaBancoDTO)
			cXML += '<par:EmpresaBancoDTO>'

			If !EMPTY(aEmpresaBancoDTO[x1][1])
				cXML += '<par:bFlPrincipal>' + ConvType(aEmpresaBancoDTO[x1][1])+'</par:bFlPrincipal>'
			endif

			If !EMPTY(aEmpresaBancoDTO[x1][2])
				cXML += '<par:nCdTipoConta>' + ConvType(aEmpresaBancoDTO[x1][2])+'</par:nCdTipoConta>'
			endif

			If !EMPTY(aEmpresaBancoDTO[x1][3])
				cXML += '<par:sCdAgencia>' + ConvType(aEmpresaBancoDTO[x1][3])+'</par:sCdAgencia>'
			endif

			If !EMPTY(aEmpresaBancoDTO[x1][4])
				cXML += '<par:sCdAgenciaDigito>' + ConvType(aEmpresaBancoDTO[x1][4])+'</par:sCdAgenciaDigito>'
			endif

			If !EMPTY(aEmpresaBancoDTO[x1][5])
				cXML += '<par:sCdBanco>' + ConvType(aEmpresaBancoDTO[x1][5])+'</par:sCdBanco>'
			endif

			If !EMPTY(aEmpresaBancoDTO[x1][6])
				cXML += '<par:sCdContaCorrente>' + ConvType(aEmpresaBancoDTO[x1][6])+'</par:sCdContaCorrente>'
			endif

			If !EMPTY(aEmpresaBancoDTO[x1][7])
				cXML += '<par:sCdContaDigito>' + ConvType(aEmpresaBancoDTO[x1][7])+'</par:sCdContaDigito>'
			endif

			If !EMPTY(aEmpresaBancoDTO[x1][8])
				cXML += '<par:sCdEmpresa>' + ConvType(aEmpresaBancoDTO[x1][8])+'</par:sCdEmpresa>'
			endif

			If !EMPTY(aEmpresaBancoDTO[x1][9])
				cXML += '<par:sCdPais>' + ConvType(aEmpresaBancoDTO[x1][9])+'</par:sCdPais>'
			endif

			If !EMPTY(aEmpresaBancoDTO[x1][10])
				cXML += '<par:sNmTitular>' + ConvType(aEmpresaBancoDTO[x1][10])+'</par:sNmTitular>'
			endif
			cXML +=' </par:EmpresaBancoDTO>'
		next
		cXML += '</par:lstEmpresaBanco>'
	Endif
	x1 := 0
	If Len(aEmpresaClasseDTO) > 0
		cXML += '<par:lstEmpresaClasse>'
		For x1 := 1 to len(aEmpresaClasseDTO)
			cXML += '<par:EmpresaClasseDTO>'

			If !EMPTY(aEmpresaClasseDTO[x1][1])
				cXML += '<par:sCdClasse>' + ConvType(aEmpresaClasseDTO[x1][1])+'</par:sCdClasse>'
			endif

			If !EMPTY(aEmpresaClasseDTO[x1][2])
				cXML += '<par:sCdEmpresa>'+ ConvType(aEmpresaClasseDTO[x1][2])+'</par:sCdEmpresa>'
			endif
			cXML += '</par:EmpresaClasseDTO>'
		next
		cXML += '</par:lstEmpresaClasse>'
	Endif
	x1 := 0
	If Len(aEmpresaContatoDTO) > 0
		cXML += '<par:lstEmpresaContato>'
		for x1 := 1 to len(aEmpresaContatoDTO)
			cXML += '<par:EmpresaContatoDTO>'

			If Len(alstDocumentoContato) > 0
				cXML +=	'<par:lstDocumentoContato>'
				for x2 := 1 to Len(alstDocumentoContato)
					cXML +=	'<par:DocumentoDTO>'
					If !EMPTY(alstDocumentoContato[x2][1])
						cXML +='<par:bFlAtivo>' + ConvType(alstDocumentoContato[x2][1])+'</par:bFlAtivo>'
					endif

					If !EMPTY(alstDocumentoContato[x2][2])
						cXML +=	'<par:bFlIsento>' + ConvType(alstDocumentoContato[x2][2])+'</par:bFlIsento>'
					endif

					If !EMPTY(alstDocumentoContato[x2][3])
						cXML +=	'<par:sCdDocumentoWBC>' + ConvType(alstDocumentoContato[x2][3])+'</par:sCdDocumentoWBC>'
					endif

					If !EMPTY(alstDocumentoContato[x2][4])
						cXML +=	'<par:tDtVencimento>' +ConvType(alstDocumentoContato[x2][4])+'</par:tDtVencimento>'
					endif

					If !EMPTY(alstDocumentoContato[x2][5])
						cXML +=	'<par:tDtVencimentoFatorExterno>' + ConvType(alstDocumentoContato[x2][5])+'</par:tDtVencimentoFatorExterno>'
					endif
					cXML +=' </par:DocumentoDTO>'
				next x2
				cXML +='</par:lstDocumentoContato>'
			Endif

			If Len(aTipoContatoDTO) > 0
				cXML +='<par:lstTipoContato>'
				For x2 := 1 to Len(aTipoContatoDTO)

					cXML +='<par:TipoContatoDTO>'
					cXML +=	'<par:sCdTipoContato>' + ConvType(aTipoContatoDTO[x2][1])+'</par:sCdTipoContato>'
					cXML +=	'<par:sDsTipoContato>' + ConvType(aTipoContatoDTO[x2][2])+'</par:sDsTipoContato>'
					cXML +=	'</par:TipoContatoDTO>'

				next x2
				cXML +='	</par:lstTipoContato>'
			Endif

			If !EMPTY(aEmpresaContatoDTO[x1][1])
				cXML +=	'<par:nCdContato>' + ConvType(aEmpresaContatoDTO[x1][1])+'</par:nCdContato>'
			endif


			If !EMPTY(aEmpresaContatoDTO[x1][2])
				cXML +=	'<par:sDsCargo>' + ConvType(aEmpresaContatoDTO[x1][2])+'</par:sDsCargo>'
			endif


			If !EMPTY(aEmpresaContatoDTO[x1][3])
				cXML +=	'<par:sDsEmail>' + ConvType(aEmpresaContatoDTO[x1][3])+'</par:sDsEmail>'
			endif


			If !EMPTY(aEmpresaContatoDTO[x1][4])
				cXML +=	'<par:sNmContato>' +ConvType(aEmpresaContatoDTO[x1][4])+'</par:sNmContato>'
			endif


			If !EMPTY(aEmpresaContatoDTO[x1][5])
				cXML +=	'<par:sNrCelular>' + ConvType(aEmpresaContatoDTO[x1][5])+'</par:sNrCelular>'
			endif


			If !EMPTY(aEmpresaContatoDTO[x1][6])
				cXML +=	'<par:sNrRamal>' + ConvType(aEmpresaContatoDTO[x1][6])+'</par:sNrRamal>'
			endif


			If !EMPTY(aEmpresaContatoDTO[x1][7])
				cXML +=	'<par:sNrTelefone>' + ConvType(aEmpresaContatoDTO[x1][7])+'</par:sNrTelefone>'
			endif
			cXML += '</par:EmpresaContatoDTO>'
		next x1

		cXML += '</par:lstEmpresaContato>'
	Endif

	If Len(aLstEmpresaEnderecoCobranca) > 0
		cXML +=	'<par:lstEmpresaEnderecoCobranca>'
		For x1 := 1 to len(aLstEmpresaEnderecoCobranca)
			cXML +=	'<par:EmpresaEnderecoDTO>'
			cXML +=	'<par:sCdCep>' + ConvType(aLstEmpresaEnderecoCobranca[x1][1])+'</par:sCdCep>'
			cXML +=	'<par:sDsComplemento>' +ConvType(aLstEmpresaEnderecoCobranca[x1][2])+'</par:sDsComplemento>'
			cXML +='<par:sDsEndereco>' + ConvType(aLstEmpresaEnderecoCobranca[x1][3])+'</par:sDsEndereco>'
			cXML +='<par:sNmBairro>' + ConvType(aLstEmpresaEnderecoCobranca[x1][4])+'</par:sNmBairro>'
			cXML +='<par:sNmCidade>' + ConvType(aLstEmpresaEnderecoCobranca[x1][5])+'</par:sNmCidade>'
			cXML +='<par:sNrEndereco>' + ConvType(aLstEmpresaEnderecoCobranca[x1][6])+'</par:sNrEndereco>'
			cXML +='<par:sSgEstado' + ConvType(aLstEmpresaEnderecoCobranca[x1][7])+'</par:sSgEstado>'
			cXML +='<par:sSgPais>' + ConvType(aLstEmpresaEnderecoCobranca[x1][8])+'</par:sSgPais>'
			cXML +='<par:bFlPrincipal>' + ConvType(aLstEmpresaEnderecoCobranca[x1][9])+'</par:bFlPrincipal>'
			cXML +='<par:nCdEmpresaEndereco>' + ConvType(aLstEmpresaEnderecoCobranca[x1][10])+'</par:nCdEmpresaEndereco>'
			cXML +=	'<par:nCdEndereco>' + ConvType(aLstEmpresaEnderecoCobranca[x1][11])+'</par:nCdEndereco>'
			cXML +='<par:sCdEndereco>' + ConvType(aLstEmpresaEnderecoCobranca[x1][12])+'</par:sCdEndereco>'
			cXML +='<par:sCdEstado>' + ConvType(aLstEmpresaEnderecoCobranca[x1][13])+'</par:sCdEstado>'
			cXML +='<par:sCdPais>' + ConvType(aLstEmpresaEnderecoCobranca[x1][14])+'</par:sCdPais>'
			cXML +='</par:EmpresaEnderecoDTO>'
		Next x1
		cXML +='</par:lstEmpresaEnderecoCobranca>'
	Endif

	If Len(aLstEmpresaEnderecoEntrega) > 0
		cXML +='<par:lstEmpresaEnderecoEntrega>'
		for x1 := 1 to Len(aLstEmpresaEnderecoEntrega)
			cXML +='<par:EmpresaEnderecoDTO>'
			cXML +='<par:sCdCep>' + ConvType(aLstEmpresaEnderecoEntrega[x1][1])+'</par:sCdCep>'
			cXML +='<par:sDsComplemento>' +ConvType(aLstEmpresaEnderecoEntrega[x1][2])+'</par:sDsComplemento>'
			cXML +='<par:sDsEndereco>' + ConvType(aLstEmpresaEnderecoEntrega[x1][3])+'</par:sDsEndereco>'
			cXML +='<par:sNmBairro>' + ConvType(aLstEmpresaEnderecoEntrega[x1][4])+'</par:sNmBairro>'
			cXML +='<par:sNmCidade>' + ConvType(aLstEmpresaEnderecoEntrega[x1][5])+'</par:sNmCidade>'
			cXML +='<par:sNrEndereco>' + ConvType(aLstEmpresaEnderecoEntrega[x1][6])+'</par:sNrEndereco>'
			cXML +='<par:sSgEstado>' + ConvType(aLstEmpresaEnderecoEntrega[x1][7])+'</par:sSgEstado>'
			cXML +='<par:sSgPais>' + ConvType(aLstEmpresaEnderecoEntrega[x1][8])+'</par:sSgPais>'
			cXML +='<par:bFlPrincipal>' +ConvType( aLstEmpresaEnderecoEntrega[x1][9])+'</par:bFlPrincipal>'
			cXML +='<par:nCdEmpresaEndereco>'+ ConvType(aLstEmpresaEnderecoEntrega[x1][10])+'</par:nCdEmpresaEndereco>'
			cXML +='<par:nCdEndereco>' + ConvType(aLstEmpresaEnderecoEntrega[x1][11])+'</par:nCdEndereco>'
			cXML +='<par:sCdEndereco>' + ConvType(aLstEmpresaEnderecoEntrega[x1][12])+'</par:sCdEndereco>'
			cXML +='<par:sCdEstado>' + ConvType(aLstEmpresaEnderecoEntrega[x1][13])+'</par:sCdEstado>'
			cXML +='<par:sCdPais>' + ConvType(aLstEmpresaEnderecoEntrega[x1][14])+'</par:sCdPais>'
			cXML +='</par:EmpresaEnderecoDTO>'
		next x1
		cXML +='</par:lstEmpresaEnderecoEntrega>'
	endif

	If Len(aLstEmpresaEnderecoFaturamento) > 0
		cXML +='<par:lstEmpresaEnderecoFaturamento>'
		For x1 := 1 to Len(aLstEmpresaEnderecoFaturamento)
			cXML +='<par:EmpresaEnderecoDTO>'
			cXML +='<par:sCdCep>' + ConvType(aLstEmpresaEnderecoFaturamento[x1][1])+'</par:sCdCep>'
			cXML +='<par:sDsComplemento>' + ConvType(aLstEmpresaEnderecoFaturamento[x1][2])+'</par:sDsComplemento>'
			cXML +='<par:sDsEndereco>' + ConvType(aLstEmpresaEnderecoFaturamento[x1][3])+'</par:sDsEndereco>'
			cXML +='<par:sNmBairro>' + ConvType(aLstEmpresaEnderecoFaturamento[x1][4])+'</par:sNmBairro>'
			cXML +='<par:sNmCidade>' + ConvType(aLstEmpresaEnderecoFaturamento[x1][5])+'</par:sNmCidade>'
			cXML +='<par:sNrEndereco>' +ConvType( aLstEmpresaEnderecoFaturamento[x1][6])+'</par:sNrEndereco>'
			cXML +='<par:sSgEstado>' + ConvType(aLstEmpresaEnderecoFaturamento[x1][7])+'</par:sSgEstado>'
			cXML +='<par:sSgPais>' + ConvType(aLstEmpresaEnderecoFaturamento[x1][8])+'</par:sSgPais>'
			cXML +='<par:bFlPrincipal>' + ConvType(aLstEmpresaEnderecoFaturamento[x1][9])+'</par:bFlPrincipal>'
			cXML +='<par:nCdEmpresaEndereco>' +ConvType( aLstEmpresaEnderecoFaturamento[x1][10])+'</par:nCdEmpresaEndereco>'
			cXML +='<par:nCdEndereco>' + ConvType(aLstEmpresaEnderecoFaturamento[x1][11])+'</par:nCdEndereco>'
			cXML +='<par:sCdEndereco>' + ConvType(aLstEmpresaEnderecoFaturamento[x1][12])+'</par:sCdEndereco>'
			cXML +='<par:sCdEstado>' + ConvType(aLstEmpresaEnderecoFaturamento[x1][13])+'</par:sCdEstado>'
			cXML +='<par:sCdPais>' + ConvType(aLstEmpresaEnderecoFaturamento[x1][14])+'</par:sCdPais>'
			cXML +='</par:EmpresaEnderecoDTO>'
		next
		cXML +='</par:lstEmpresaEnderecoFaturamento>'
	Endif

	If Len(aLstEmpresaEnderecoInstitucional) > 0
		cXML +='<par:lstEmpresaEnderecoInstitucional>'
		for x1 := 1 to len(aLstEmpresaEnderecoInstitucional)
			cXML +='<par:EmpresaEnderecoDTO>'
			cXML +='<par:sCdCep>' + ConvType(aLstEmpresaEnderecoInstitucional[x1][1])+'</par:sCdCep>'
			cXML +='<par:sDsComplemento>' + ConvType(aLstEmpresaEnderecoInstitucional[x1][2])+'</par:sDsComplemento>'
			cXML +='<par:sDsEndereco>' + ConvType(aLstEmpresaEnderecoInstitucional[x1][3])+'</par:sDsEndereco>'
			cXML +='<par:sNmBairro>' + ConvType(aLstEmpresaEnderecoInstitucional[x1][4])+'</par:sNmBairro>'
			cXML +='<par:sNmCidade>' + ConvType(aLstEmpresaEnderecoInstitucional[x1][5])+'</par:sNmCidade>'
			cXML +='<par:sNrEndereco>' + ConvType(aLstEmpresaEnderecoInstitucional[x1][6])+'</par:sNrEndereco>'
			cXML +='<par:sSgEstado>' + ConvType(aLstEmpresaEnderecoInstitucional[x1][7])+'</par:sSgEstado>'
			cXML +='<par:sSgPais>' + ConvType(aLstEmpresaEnderecoInstitucional[x1][8])+'</par:sSgPais>'
			cXML +='<par:bFlPrincipal>' + ConvType(aLstEmpresaEnderecoInstitucional[x1][9])+'</par:bFlPrincipal>'
			cXML +='<par:nCdEmpresaEndereco>' + ConvType(aLstEmpresaEnderecoInstitucional[x1][10])+'</par:nCdEmpresaEndereco>'
			cXML +='<par:nCdEndereco>' + ConvType(aLstEmpresaEnderecoInstitucional[x1][11])+'</par:nCdEndereco>'
			cXML +='<par:sCdEndereco>' + ConvType(aLstEmpresaEnderecoInstitucional[x1][12])+'</par:sCdEndereco>'
			cXML +='<par:sCdEstado>' + ConvType(aLstEmpresaEnderecoInstitucional[x1][13])+'</par:sCdEstado>'
			cXML +='<par:sCdPais>' + ConvType(aLstEmpresaEnderecoInstitucional[x1][14])+'</par:sCdPais>'
			cXML +='</par:EmpresaEnderecoDTO>'
		next
		cXML +='</par:lstEmpresaEnderecoInstitucional>'
	Endif
	cXML +='</par:EmpresaDTO>'
	cXML +='</tem:lstEmpresa>'
	cXML +='</tem:ProcessarEmpresa>'
	cXML +='</soapenv:Body>'
	cXML +='</soapenv:Envelope>'

Return cXML




/*/{Protheus.doc} ConvType
   	Faz conversùo para string
	@type  Static Function
	@author Rubem Cerqueira
	@since 22/03/2021
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
/*/
Static Function ConvType(xValor,nTam,nDec)

	Local cNovo := ""
	DEFAULT nDec := 0
	Do Case
		Case ValType(xValor)=="N"
			If xValor <> 0
				cNovo := AllTrim(Str(xValor,nTam,nDec))
			Else
				cNovo := "0"
			EndIf
		Case ValType(xValor)=="D"
			cNovo := FsDateConv(xValor,"YYYYMMDD")
			cNovo := SubStr(cNovo,1,4)+"-"+SubStr(cNovo,5,2)+"-"+SubStr(cNovo,7)
		Case ValType(xValor)=="C"
			If nTam==Nil
				xValor := AllTrim(xValor)
			EndIf

			cNovo := AllTrim(xValor)
	EndCase
Return(cNovo)


/*/{Protheus.doc} EnvProcEmpresa
    Faz envio para WS Processa Empresa
	@type  Static Function
	@author Rubem Cerqueira
	@since 22/03/2021
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
/*/
Static function  EnvProcEmpresa(cXml,cXmlErro)

	Local lSucesso := .f.
	LOcal oWsdl
	//Local cErro := ""
	Local cAviso := ""
	Local oRetXml
	Local cErro as char
	Local cXmlRet as char
	//Local lProc  as char
	Default cXmlErro := ''

	cErro := ""
	oWsdl := TWsdlManager():New()
	oWsdl:lSSLInsecure := .T.
	oWsdl:nTimeout       := 120
	/*
			nSSLVersion  - Lista de opùùes que pode ser setadas:
			0 - O programa tenta descobrir a versùo do protocolo
			1 - Forùa a utilizaùùo do TLSv1
			2 - Forùa a utilizaùùo do SSLv2
			3 - Forùa a utilizaùùo do SSLv3
	*/
	oWsdl:nSSLVersion := 0

	lSucesso := oWsdl:ParseURL(Lower(AllTrim(GetMv("MV_XPARURL")))+"/services/Empresa.svc?wsdl" )
	If lSucesso == .F.
		ConOut("Erro ParseURL: " + oWsdl:cError)
		Return .F.
	EndIf

	lSucesso := oWsdl:SetOperation("ProcessarEmpresa")
	If lSucesso == .F.
		ConOut("Erro SetOperation: " + oWsdl:cError)
		return .F.
	EndIf

	cXml := FwCutOff(cXml)
	cXml := ReTiGraf(cXml)
	lSucesso := oWsdl:SendSoapMsg(cXml)

	If !lSucesso
		cXmlErro := "Falha no envio SendSoapMsg"
		Return .F.
	Endif
	//Recuperar a mensagem
	cXmlRet := oWsdl:GetSoapResponse()

	oRetXml := XmlParser(cXmlRet,"_",@cErro,@cAviso)     // Abre arquivo e retorna objeto com os dados do XML

	If !Empty(cAviso)
		Conout("Nùo foi possùvel ler o retorno ->"+cAviso,"Atenùùo - "+ProcName())
		Return .F.
	EndIf

	If !Empty(cErro)
		Conout("Nùo foi possùvel ler o retorno -> "+cErro,"Atenùùo - "+ProcName())
		Return .F.
	EndIf

	cErro := oRetXml:_S_ENVELOPE:_S_BODY:_PROCESSAREMPRESARESPONSE:_PROCESSAREMPRESARESULT:_A_LSTWBTLOGDTO:_A_WBTLOGDTO:_A_SDSLOG:TEXT
	cProc := oRetXml:_S_ENVELOPE:_S_BODY:_PROCESSAREMPRESARESPONSE:_PROCESSAREMPRESARESULT:_A_LSTWBTLOGDTO:_A_WBTLOGDTO:_A_NIDRETORNO:TEXT

	If cProc == '1'
		Return .t.
	else
		cXmlErro :=cErro
		Return .f.
	endif

	FreeObj(oWsdl)

Return .f.


/*/{Protheus.doc} nBanco
//Efetua a integraùùo dos bancos
@author fabri
@since 06/08/2018
@version 1.0
@param oProcess, object, Objeto de processamento da tNewProcess
@type function
/*/
Static Function nBanco(oProcess)
	Local oWsBanco := Nil
	Local oBanco   := Nil
	Local cQuery   := ""
	Local cCod     := ''
	Local cAlias   := GetNextAlias()
	Local nProc    := 0
	Local oLog     := FwParLog():New("PAR001", "ProcessarBanco")
	Local aReg     := {}
	Local oError   := ErrorBlock({|e| fErrorPar(e:ErrorStack, 'SA6', @oLog, @cCod)})
	Local aRetorno := {}
	Local nEmp     := NIL
	Begin Sequence
		fIniLog("Bancos")

		SetRegua2(oProcess, 0)
		IncRegua2(oProcess, "Buscando os bancos")

		//cQuery += " select max(R_E_C_N_O_) REG, A6_COD, A6_NOME "
		cQuery += " select R_E_C_N_O_ REG, A6_COD, A6_NOME "
		cQuery += " from " + RetSqlTab("SA6")
		cQuery += " where D_E_L_E_T_ = ' ' "
		cQuery += "   and A6_XINTPA > '1' "
		//cQuery += "   GROUP BY A6_COD, A6_NOME  "
		//cQuery += " order by A6_COD, A6_NOME "

		OPENSQL(cAlias, cQuery)

		SetRegua2(oProcess,  (cAlias)->( LastRec() ) )

		oWsBanco := WSParBanco():New()

		while (cAlias)->( ! EoF() )
			cCod := AllTrim((cAlias)->A6_COD)
			IncRegua2(oProcess, "Processando " + (cAlias)->A6_COD)
			oBanco   := Banco_BancoDTO():New()
			oBanco:cScdBanco := AllTrim((cAlias)->A6_COD)
			oBanco:cSnmBanco := AllTrim((cAlias)->A6_NOME)
			oBanco:csCdPais  := 'BR'

			oBanco:oWSlstAgenciaDTO := Banco_ArrayOfAgenciaBancoDTO():NEW()

			aAdd(aReg, (cAlias)->REG)

			aAdd(oWsBanco:oWSlstBanco:oWSBancoDTO, oBanco:Clone())

			//oLog := FwParLog():New("PAR001", "ProcessarBanco")
			(cAlias)->( DbSkip() )
		EndDo
		CLOSESQL(cAlias)

		If !Empty(oWsBanco:oWSlstBanco:oWSBancoDTO)
			//faz a chamada do metodo de integraùùo de bancos

			aRetorno := oWsBanco:ProcessarBanco()

			If aRetorno[1]
				//registra o retorno de processar
				fWsLogRet( oWsBanco:oWSProcessarBancoResult:oWSlstWbtLogDTO:oWSWbtLogDTO, oLog, "SA6", @aReg, @nProc,nEmp,aRetorno[2] )
			Else
				fSoapFault(oLog)
			EndIf
		EndIf

		fFimLog("Bancos - " + cValToChar(nProc) + ' processados - ' + Time() )
	End Sequence
	ErrorBlock(oError)

Return nProc





/*/{Protheus.doc} ProcessarEmpresa
   	Funùùo ser usado em job para envio em lote
	@type  Static Function
	@author Rubem Cerqueira
	@since 22/03/2021
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
/*/
Static function ProcessarEmpresa(oProcess)

	Local cALiaSA2 := GetNextAlias()
	Local cErro  as char
	Local cXMl as char
	Local oLog 	 := FwParLog():New("PAR001", "ProcessarEmpresa")
	Local xFilSa2 := FWxFilial('SA2')

	If !lPosA2_XXML .or. !lPosA2_XENVXML
		return
	Endif

	BeginSql Alias cALiaSA2
		SELECT
			SA2.A2_CGC,
			SA2.A2_XEMPWBC,
			SA2.A2_COD,
			SA2.A2_LOJA,
			SA2.A2_CGC,
			SA2.R_E_C_N_O_ AS RECSA2,
			ISNULL(
				CONVERT(
					VARCHAR(8000),
					CONVERT(VARBINARY(8000), SA2.A2_XXML)
				),
				''
			) AS XML_ENV
		FROM
			%table:SA2% SA2
		WHERE
			SA2.A2_FILIAL = %xFilial:SA2%
			AND SA2.D_E_L_E_T_ = '' //and SB1.B1_COD = '1022'
			AND SA2.A2_XXML <> ''
			AND SA2.A2_XENVXML = 'N'
	EndSQL

	Do While (cALiaSA2)->(!Eof())

		cErro := ''
		cXMl := Alltrim((cALiaSA2)->XML_ENV)

		If !EnvProcEmpresa(cXMl,@cErro) //Em caso de sucesso.
			oLog:Retorno := 0
			oLog:Origem := "Portal :" + (cALiaSA2)->A2_XEMPWBC + " CNPJ/CPF : "+(cALiaSA2)->A2_CGC
			oLog:MsgLog := 'Falha na integraùùo ProcessaEmpresa. Motivo do erro  ' + cErro
			oLog:SoapFault := "Fornecedor " + (cALiaSA2)->A2_COD + (cALiaSA2)->A2_LOJA + "  Nao inserido!!"
			oLog:Tstamp := FwTimeStamp(3)
			oLog:Token := 'MATA020'
			oLog:SalvaObj('SA2')
			oLog:novoLog()
			(cALiaSA2)->(DbSkip())
			loop
		Endif

		SA2->(DbSetOrder(3))
		If !SA2->(MsSeek(xFilSa2 + (cALiaSA2)->A2_CGC))
			(cALiaSA2)->(DbSkip())
			loop
		Endif

		RecLock('SA2',.F.)
		SA2->A2_XENVXML := 'S'
		SA2->(MsUnLock())

		oLog:Retorno := 0
		oLog:Origem := (cALiaSA2)->A2_XEMPWBC
		oLog:MsgLog := ' Integraùùo ProcessaEmpresa feito com sucesso. ' + cErro
		oLog:SoapFault := "Fornecedor " + (cALiaSA2)->A2_COD + (cALiaSA2)->A2_LOJA + "  inserido no seviùo ProcessaEmpresa!!"
		oLog:Tstamp := FwTimeStamp(3)
		oLog:Token := 'MATA020'
		oLog:SalvaObj('SA2')
		oLog:novoLog()
		(cALiaSA2)->(DbSkip())
	EndDo

	(cALiaSA2)->(DbCloseArea())

	FreeObj(oLog)
Return

/*/{Protheus.doc} nIntrCSc
//Verifica cancelamentos de SC via o portal paradigma
@author fr
@since 02/05/2018
@version 1.0
@param oProcess, object, objeto tNewProccess
@type function
/*/
Static Function nIntrCSc(oProcess)
	local oLog   := FwParLog():New("PAR001", "RetornarRequisicaoCancelamento")
	local nProc  := 0
	local oWsSc  := WSRequisicao():New()

	fIniLog("Cancelamento de Solicitaùùo de Compras")

	if oWsSc:RetornarRequisicaoCancelamento()
		cancelSC(oWsSc:oWSRetornarRequisicaoCancelamentoResult:oWSRequisicaoAtualizarDTO, oLog, @nProc)
	else
		fSoapFault(oLog)
	endIf

	fFimLog("Cancelamento de Solicitaùùo de Compras - " + cValToChar(nProc) + ' processados - ' + Time())

Return nProc


/*/{Protheus.doc} nIntrSc
//Efetua a integraùùo de solicitaùùes de compras
@author fr
@since 10/04/2018
@version 1.0
@param oProcess, object, Objeto de processamento tNewProcess
@type function
/*/
static function nIntrSc(oProcess, aReg)
	local cAlias  := GetNextAlias()
	local cQuery  := ""
	Local cNum    := ''
	Local cFilAux := cFilAnt
	local oWsSc   := WSRequisicao():New()
	local oSc     := Nil
	local oLog    := FwParLog():New("PAR001", "ProcessarRequisicao")
	local nProc   := 0
	local nX      := 0
	Local aRecs   := {}
	Local oError  := ErrorBlock({|e| fErrorPar(e:Description, 'SC1', @oLog, @cNum)})

	default aReg := {}

	Begin Sequence
		fIniLog("Solicitaùùo de Compras")

		SetRegua2(oProcess, 0)
		IncRegua2(oProcess, "Solicitaùùo de Compras")

		if Empty(aReg)

			cQuery += " select TOP(500) R_E_C_N_O_ REG "
			cQuery += " from " + RetSqlTab("SC1")
			cQuery += " where "
			//ALTERADO 19/09/2019 - ROGERIO - GDC, Estava filtrando apenas 'B' e os 'R'eprovados estavam subindo para o Paradigma
			//cQuery += "   and C1_APROV  NOT IN ('B','R') " //liberados
			//	cQuery += "   and C1_APROV  <> 'B' " //liberados
			cQuery += "   and C1_XINTPA > '1' " //Alexandre, C1_XINTPAR -> C1_XINTPA
			//cQuery += "   and C1_XDTPAR  = '' "

			OPENSQL(cAlias, cQuery)

			(cAlias)->( DbEval({|| AADD(aReg, REG) }) )

			CLOSESQL(cAlias)

		endIf

		SetRegua2(oProcess,  Len(aReg) )

		for nX := 1 to Len(aReg)

			SC1->( DbGoTo( aReg[nX] ) )
			If !SC1->C1_FILIAL $ '05,20,02'
				SC1->(RecLock('SC1',.F.))
				SC1->C1_XINTPA := '' //alteracao de C1_XINTPAR para C1_XINTPA
				SC1->(MsUnLock())
				Loop
			EndIf

			SB1->( DbSetOrder(1) )
			SB1->( DbSeek( xFilial("SB1") + SC1->C1_PRODUTO ) )
			If SB1->B1_XINTPA <> '1' //B1_XINTPAR -> B1_XINTPA
				Loop
			EndIf

			cFilAnt := SC1->C1_FILIAL
			cNum    := SC1->C1_NUM

			aADD(aRecs, aReg[nX])

			IncRegua2(oProcess, "Processando " + SC1->C1_NUM + "/" + SC1->C1_ITEM + ": " + SC1->C1_PRODUTO)

			If lExistBlock("WBCZ03")
				WBCZ03()
			Else
				oSc:= Requisicao_RequisicaoDTO():New()
				oSc:ndQtEntrega 					:= SC1->C1_QUANT //SC1->C1_QUJE
				oSc:ndVlReferencia 				    := SB1->B1_UPRC
				// oSc:oWSlstRequisicaoEmpresaDTO	:= AS Requisicao_ArrayOfRequisicaoEmpresaDTO OPTIONAL
				// oSc:oWSlstRequisicaoIdioma 		:= AS Requisicao_ArrayOfRequisicaoIdiomaDTO OPTIONAL
				oSc:nnCdAplicacao 					:= 2 // 1 -Uso interno, 2 -	Industrializaùùo, 3- Comercializaùùo
				// oSc:nnCdMarca 					:= AS long OPTIONAL
				oSc:nnCdMoeda 						:= 1
				// oSc:nnCdOrigem 					:= AS long OPTIONAL
				oSc:nnCdSituacao 					:= 1   // encaminhada
				// oSc:nnIdTipoOrigem 				:= AS long OPTIONAL
				oSc:nnIdTipoRequisicao 				:= 1
				// oSc:oWSoAplicacaoDetalhe 		:= AS Requisicao_AplicacaoDetalheDTO OPTIONAL
				// oSc:oWSoContaContabilDetalhe 	:= AS Requisicao_ContaContabilDetalheDTO OPTIONAL
				// oSc:oWSoCriterioDetalhe 			:= AS Requisicao_CriterioDetalheDTO OPTIONAL
				// oSc:oWSoMarcaDetalhe 			:= AS Requisicao_MarcaDetalheDTO OPTIONAL
				// oSc:oWSoNaturezaDespesaDetalhe 	:= AS Requisicao_NaturezaDespesaDetalheDTO OPTIONAL
				// oSc:oWSoUnidadeMedidaDetalhe 	:= AS Requisicao_UnidadeMedidaDetalheDTO OPTIONAL
				oSc:csCdCentroCusto 				:= AllTrim(SC1->C1_CC)
				oSc:csCdClasse 						:= SB1->B1_XCATPAR
				// oSc:csCdCobrancaEndereco 		:= AS string OPTIONAL
				oSc:csCdContaContabil 				:= AllTrim(SC1->C1_CONTA)
				// oSc:csCdDepartamento 			:= AS string OPTIONAL
				oSc:csCdEmpresa 					:= cEmpAnt + SC1->C1_FILIAL
				oSc:csCdEmpresaCobrancaEndereco 	:= cEmpAnt + SC1->C1_FILIAL
				oSc:csCdEmpresaEntregaEndereco 		:= cEmpAnt + SC1->C1_FILIAL
				oSc:csCdEmpresaFaturamentoEndereco  := cEmpAnt + SC1->C1_FILIAL
				// oSc:csCdEntregaEndereco 			:= AS string OPTIONAL
				// oSc:csCdFaturamentoEndereco 		:= AS string OPTIONAL
				// oSc:csCdFonteRecurso 			:= AS string OPTIONAL
				/*If !Empty(SC1->C1_GRUPCOM)
				oSc:csCdGrupoCompra 			:= SC1->C1_GRUPCOM
				EndIf*/
				oSc:csCdItemEmpresa 				:= SC1->C1_ITEM
				// oSc:csCdNaturezaDespesa 			:= AS string OPTIONAL
				oSc:csCdProduto 					:= AllTrim(SC1->C1_PRODUTO)
				oSc:csCdRequisicaoEmpresa 			:= SC1->C1_NUM
				oSc:csCdUnidadeMedida 				:= SC1->C1_UM
				// oSc:csCdUnidadeNegocio 			:= AS string OPTIONAL
				// oSc:csCdUsuarioComprador 		:= AS string OPTIONAL
				oSc:csCdUsuarioResponsavel 			:= AllTrim(POSICIONE('ZUP', 1, SC1->C1_USER, 'ZUP_NOMRED'))
				// oSc:csDsAnexo 					:= AS string OPTIONAL
				// oSc:csDsDetalheCliente 			:= AS string OPTIONAL
				oSc:csDsJustificativa 				:= ''
				oSc:csDsObservacao 					:= AllTrim(SC1->C1_OBS)
				// oSc:csDsObservacaoInterna 		:= AS string OPTIONAL
				oSc:csDsProdutoRequisicao 			:= oSc:csCdProduto + ' - ' + AllTrim(SC1->C1_DESCRI)
				oSc:ctDtCriacao 					:= FwTimeStamp(3, SC1->C1_EMISSAO)
				oSc:ctDtEntrega 					:= FwTimeStamp(3, SC1->C1_DATPRF)
				// oSc:ctDtLiberacao 				:= AS dateTime OPTIONAL
				// oSc:ctDtMoedaCotacao 			:= AS dateTime OPTIONAL
				oSc:ctDtProcesso 					:= FwTimeStamp(3)
			EndIf

			conout('__' + UsrRetName(SC1->C1_USER))

			AADD(oWsSc:oWSlstRequisicao:oWSRequisicaoDTO, oSc:Clone())

		next nX

		if Empty(oWsSc:oWSlstRequisicao:oWSRequisicaoDTO)
			conout(" Nenhuma solicitaùùo de compras a integrar")
		Else
			//faz a chamada do mùtodo de integraùùo
			if oWsSc:ProcessarRequisicao()
				//registra o retorno de processar
				fWsLogRet( oWsSc:oWSProcessarRequisicaoResult:oWSlstWbtLogDTO:oWSWbtLogDTO, oLog, "SC1", aRecs, @nProc )

				(cAlias)->( DbGoTop() )
				DbSelectArea(cAlias)
				While (cAlias)->( ! EoF() )
					dbGoTo((cAlias)->REG)
					Begin Sequence
						SC1->(Reclock("SC1",.F.))
						SC1->C1_ZINTWBC := "1"
						SC1->C1_ZDTEXP := dToC(date()) + Space(1) + Time()
						SC1->(msUnlock())
					End sequence
					(cAlias)->( DbSkip() )
				EndDo

			else
				fSoapFault(oLog)
			endIf
		EndIf

		fFimLog("Solicitaùùo de Compras - " + cValToChar(nProc) + ' processados - ' + Time())
		cFilAnt := cFilAux
	End Sequence
	ErrorBlock(oError)
return nProc

/*
ùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùù
ùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùù
ùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùù?ùù
ùùùPrograma  ùDevSC 	ùAutor  ùEDUARDO BRUST       ù Data ù  28/10/08   ùùù
ùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùù?ùù
ùùùDesc.     ù Devolve Sc para Elaboracao							 	  ùùù
ùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùù?ùù
ùùùUso       ù MT110ROT - PE NA ROTINA MATA110 - SOLICITACAO DE COMPRAS   ùùù
ùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùù?ùù
ùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùù
ùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùù
*/
static Function DevSC()
	Local aArea 	  	:= GetArea()

	// RDMF0363 - Retirar essa verificaùùo porque jù estù sendo realizado pelo parùmetro MV_USRDVSC na exibiùùo do memu
	/*
Local cCodUser := RetCodUsr() //Retorna o Codigo do Usuario
Local cNamUser := UsrRetName( cCodUser )//Retorna o nome do

//RDMF0354 - 09/01/2017 - Leonardo Paiva - Controle de acesso a rotina
If cNamUser $ SuperGetMV("MV_XDEVSC", .F., "jose.araujo")
	Processa({|| Precessa() },"Devolvendo SC ...")
Else
	MsgAlert("Usuùrio sem acesso a devolver SC")
EndIf
	*/

	Processa({|| Precessa() },"Devolvendo SC ...")

	RestArea(aArea)
Return

Static Function Precessa()
	Local aArea 	  	:= GetArea()
	Local cFilSC 	  	:= Space(TamSx3("C1_FILIAL")[1])
	Local cNumSc 	  	:= Space(TamSx3("C1_NUM")[1])
	Local cItmSC 	  	:= ""
	Local lComprador  	:= .f.
	Local l_Rejeitada 	:= .f.
	Local cCodComprador

	//RDMF012
	Private cMotivo		:= ""
	Private cFilMot		:= SC1->C1_FILIAL
	Private cNumMot		:= SC1->C1_NUM

	//Alterado por Roberto Wanderley Mendes - 24.01.09
	//Verifica se a solicitaùùo foi esta rejeitada
	DbSelectArea("SCR")
	DbSetOrder(1)
	DbSeek(xFilial("SCR")+"SC"+SC1->C1_NUM)

	While CR_FILIAL+CR_TIPO+CR_NUM = xFilial("SCR")+"SC"+SC1->C1_NUM .and. .not. Eof()
		if SCR->CR_STATUS="04"
			l_Rejeitada := .T.
		EndIf
		SCR->(DbSkip())
	EndDo

	//Verifica se o usuùrio ù usuùrio comprador
	//Alterado Roberto W. Mendes - 24.01.09
	//Verifica se usuùrio ù o comprador para o qual a SC foi reservada.
	DbSelectArea("SY1")
	DbSetOrder(3)//cod usuario
	If DbSeek(xFilial("SY1") + __cUserId)
		cCodComprador := SY1->Y1_USER
		lComprador := .t.
	Endif
	/*
if cCodComprador = ALLTRIM(SC1->C1_XUSRCOM)
lComprador := .T.
EndIf
	*/
	//Comentado Roberto W. Mendes - 24.01.09
	//Quando a solicitaùùo ù rejeitada pelo aprovador, o campo C1_APROV nùo ù atualizado
	//If lComprador .or. (!lComprador .and. ALLTRIM(USRRETNAME(__cUserID)) = ALLTRIM(SC1->C1_SOLICIT) .AND. SC1->C1_APROV = 'R')

	lComprador := .t.

	If lComprador .or. (!lComprador .and. ALLTRIM(USRRETNAME(__cUserID)) = ALLTRIM(SC1->C1_SOLICIT) .AND. l_Rejeitada)

		IF 	SC1->C1_QUJE==0 .And. SC1->C1_COTACAO == Space(Len(SC1->C1_COTACAO))//  .And. SC1->C1_APROV $ " ,L" //COMENTADO POR RICARDO FERREIRA EM 05/11/2008 POIS O COMPRADOR PODERA DEVOLVER SC A QQ MOMENTO

			// RDMF0212
			// Exibe a tela para informar o motivo da Devoluùùo
			cMotivo := cMotivoAux

			If Empty(cMotivo)

				RestArea(aArea)
				Return
			EndIf

			DbSelectArea("SC1")
			DbSetOrder(1)
			if DbSeek(SC1->C1_FILIAL+SC1->C1_NUM+SC1->C1_ITEM)
				cFilSC := SC1->C1_FILIAL
				cNumSC := SC1->C1_NUM
				cItmSC := SC1->C1_ITEM
				/*While !SC1->(Eof()) .and. cFilSC + cNumSC = SC1->C1_FILIAL+SC1->C1_NUM
				If Empty(SC1->C1_PEDIDO)*/ // RDMF0826 - Luis Feipe - 15/09/2020 - Aceitar a devoluùùo apenas dos itens nùo atendidos
					RecLock("SC1",.F.)
					SC1->C1_XSTATUS := "E"
					SC1->C1_APROV   := "R"
					SC1->C1_XUSRCOM := ""
					SC1->C1_XNOMCOM := ""
					If !Empty(SC1->C1_XDTDEV)      // Michael Becker - 24/02/2015 - RDMF0067
						SC1->C1_XDTUDV  := dDatabase //Data de ultima devoluùùo da SC
						SC1->C1_XNOMUDV := Substr( USRRETNAME(__cUserID), 1, TamSx3("C1_XNOMDEV")[1] )

					Else
						SC1->C1_XDTDEV  := dDatabase //Data de devoluùùo da SC
						SC1->C1_XNOMDEV := Substr( USRRETNAME(__cUserID), 1, TamSx3("C1_XNOMDEV")[1] )
					EndIf
					SC1->C1_XCODAPR := ""
					SC1->C1_XNOMAPR := ""
					/*SC1->(MsUnLock())
				EndIf
				RecLock("SC1",.F.)*/
				SC1->C1_XINTPA  := '2'
				SC1->(MsUnLock())
				//SC1->(DbSkip())

				// RDMF0212
				// Grava o motivo da devoluùùo
				fGrvHistDev(cFilMot, cNumMot)
				GeraWF()

				SC1->(DbCloseArea())

				RestARea(aArea)
				//INCLUIR ROTINA PARA DESFAZER PROCESSO DE WORKFLOW CASO EXISTA
				//Aviso("Sucesso!","Solicitaùùo: " + cNumSC + " Devolvida para Elaboraùùo.",{"Ok"})
				RecLock("ZPL", .T.)
					ZPL->ZPL_DATA   :=date()
					ZPL->ZPL_HORA   := Time()
					ZPL->ZPL_TOKEN  := cNumSC
					ZPL->ZPL_FILIAL := xFilial('SC1') //xFilial(cTabela)
					ZPL->ZPL_USUARI := 'Schedule'
					ZPL->ZPL_ROTINA := 'Par001'
					ZPL->ZPL_FUNCAO := 'RetornarRequisicaoRejeitada'
					ZPL->ZPL_ORIGEM := ""
					ZPL->ZPL_MSGLOG := 'SolicitaÁ„o: ' + cNumSC + ' Devolvida para ElaboraÁ„o.'
					ZPL->ZPL_MSGWSF := 'SolicitaÁ„o: ' + cNumSC + ' Devolvida para ElaboraÁ„o.'
					ZPL->ZPL_TSTAMP := GetTimeStamp(DATE())
					ZPL->ZPL_RETORN := 1
					ZPL->ZPL_XML	:= cMotivoAux
				MsUnlock()

				//*'------------------------------------------------------------------------------------------'*
				//*'Viviane Flaeschen - 10/11/2008                                                            '*
				//*'Esta funcao e chamada para garantir que caso ja tenha sido montada a grade anteriormente e'*
				//*'o usuario nao tenha clicado no "Alterar" seja deletado o SCR  e montado novamente.        '*
				//*'------------------------------------------------------------------------------------------'*

				//U_SCRDEL(SC1->C1_NUM)
				U_SCRDEL(cNumSC)
				If ExistBlock("ASCDEL")
					ExecBlock("ASCDEL",.F.,.F.,{cFilSC,cNumSC,cItmSC})
				EndIf
				//*'------------------------------------------------------------------------------------------'*
			//Enddo
			Else
				DBSelectArea("ZPL")
				DbSetOrder(1)
				RecLock("ZPL", .T.)
					ZPL->ZPL_DATA   :=date()
					ZPL->ZPL_HORA   := Time()
					ZPL->ZPL_TOKEN  := SC1->C1_NUM
					ZPL->ZPL_FILIAL := SC1->C1_FILIAL //xFilial(cTabela)
					ZPL->ZPL_USUARI := 'Schedule'
					ZPL->ZPL_ROTINA := 'WsCancel2'
					ZPL->ZPL_FUNCAO := 'RetornarRequisicaoRecusada'
					ZPL->ZPL_ORIGEM := ""
					ZPL->ZPL_MSGLOG := 'SolicitaÁ„o n„o encontarada na Filial '+SC1->C1_FILIAL+' Num Solic '+ SC1->C1_NUM + ' Item ' + SC1->C1_ITEM
					ZPL->ZPL_MSGWSF := 'SolicitaÁ„o n„o encontarada na Filial '+SC1->C1_FILIAL+' Num Solic '+ SC1->C1_NUM + ' Item ' + SC1->C1_ITEM
					ZPL->ZPL_TSTAMP := GetTimeStamp(DATE())
					ZPL->ZPL_RETORN := 0
					ZPL->ZPL_XML	:= cMotivoAux
				MsUnlock()
			EndIf
		Else // RDMF0826 - Luis Felipe - 15/09/2020
			DBSelectArea("ZPL")
			DbSetOrder(1)
			RecLock("ZPL", .T.)
				ZPL->ZPL_DATA   :=date()
				ZPL->ZPL_HORA   := Time()
				ZPL->ZPL_TOKEN  := SC1->C1_NUM
				ZPL->ZPL_FILIAL := SC1->C1_FILIAL //xFilial(cTabela)
				ZPL->ZPL_USUARI := 'Schedule'
				ZPL->ZPL_ROTINA := 'WsCancel2'
				ZPL->ZPL_FUNCAO := 'RetornarRequisicaoRecusada'
				ZPL->ZPL_ORIGEM := ""
				ZPL->ZPL_MSGLOG := 'AtenÁ„o! Item atendido, n„o pode ser devolvido! SolicitaÁ„o: '+ SC1->C1_NUM + ' Item ' + SC1->C1_ITEM
				ZPL->ZPL_MSGWSF := 'AtenÁ„o! Item atendido, n„o pode ser devolvido! SolicitaÁ„o: '+ SC1->C1_NUM + ' Item ' + SC1->C1_ITEM
				ZPL->ZPL_TSTAMP := GetTimeStamp(DATE())
				ZPL->ZPL_RETORN := 0
				ZPL->ZPL_XML	:= cMotivoAux
			MsUnlock()
			//Aviso("Atencao!","Item atendido, nao pode ser devolvido!",{"Retornar"})
		Endif
	ELSE
		DBSelectArea("ZPL")
		DbSetOrder(1)
		RecLock("ZPL", .T.)
			ZPL->ZPL_DATA   :=date()
			ZPL->ZPL_HORA   := Time()
			ZPL->ZPL_TOKEN  := SC1->C1_NUM
			ZPL->ZPL_FILIAL := SC1->C1_FILIAL //xFilial(cTabela)
			ZPL->ZPL_USUARI := 'Schedule'
			ZPL->ZPL_ROTINA := 'WsCancel2'
			ZPL->ZPL_FUNCAO := 'RetornarRequisicaoRecusada'
			ZPL->ZPL_ORIGEM := ""
			ZPL->ZPL_MSGLOG := 'AtenÁ„o! Item atendido, n„o pode ser devolvido! SolicitaÁ„o: '+ SC1->C1_NUM + ' Item ' + SC1->C1_ITEM
			ZPL->ZPL_MSGWSF := "AtenÁ„o! N„o foi possÌvel fazer a devoluÁ„o da SC." + SC1->C1_SOLICIT + "A solicitaÁ„o somente poder· ser devolvida caso o usu·rio seja comprador"+ SC1->C1_SOLICIT + "ou caso a solicitaÁ„o esteja rejeitada e o usu·rio logado seja o prÛprio solicitante"
			ZPL->ZPL_TSTAMP := GetTimeStamp(DATE())
			ZPL->ZPL_RETORN := 0
			ZPL->ZPL_XML	:= cMotivoAux
		MsUnlock()
		//Aviso("Atencao!","Nao foi possivel fazer a devolucao da SC." + SC1->C1_SOLICIT + "A solicitacao somente podera ser devolvida caso o usuario seja comprador "+ SC1->C1_SOLICIT + " ou caso a solicitacao esteja rejeitada e o usuario logado seja o proprio solicitante",{"Ok"})
	ENDIF

	RestARea(aArea)
return



/*/f/
ùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùù
<RDMF>  	 : RDMF0212 - Inclusùo de campo justificativa para devoluùùo de solicitaùùes de compras
<Funùùo>  	 : fGrvHistDev(cFil, cNumSC)
<descriùùo>  : Grava na tabela Z03 as informaùùe do histùrico da devoluùùo
<Autor> 	 : Leonardo Paiva
<Data> 		 : 15/04/2016
ùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùù
*/
Static Function fGrvHistDev(cFil, cNumSC)
	Local aArea 	:= GetArea()
	Local cRet		:= ""
	Local nSeq		:= fBuscaSeq(cFil, cNumSC)

	DbSelectArea("Z03")
	RecLock("Z03",.T.)
	Z03->Z03_FILIAL := cFil
	Z03->Z03_NUMSC 	:= cNumSC
	Z03->Z03_SEQ 	:= nSeq
	Z03->Z03_DATA 	:= dDataBase
	Z03->Z03_USUA 	:= __cUserId
	Z03->Z03_MOTIVO := cMotivo
	Z03->(MsUnLock())

	Z03->(dbCloseArea())
	RestArea(aArea)

Return cRet

/*/f/
ùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùù
<RDMF>       : RDMF0212 - Inclusùo de campo justificativa para devoluùùo de solicitaùùes de compras
<Funùùo>     : fBuscaSeq(cFil, cNumSC)
<descriùùo>  : Busca a prùxima o sequùncia do histùrico da devoluùùo
<Autor>      : Leonardo Paiva
<Data>       : 15/04/2016
ùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùù
*/
Static Function fBuscaSeq(cFil, cNumSC)
	Local aArea     := GetArea()
	Local nRet      := 0

	DbSelectArea("Z03")
	DbSetOrder(1)
	If DbSeek(cFil+cNumSC)
		While !Z03->(Eof()) .and. cFil + cNumSC = Z03->Z03_FILIAL+Z03->Z03_NUMSC
			nRet := Z03->Z03_SEQ
			DbSkip()
		Enddo

	EndIf

	nRet := nRet + 1

	Z03->(dbCloseArea())
	RestArea(aArea)

Return nRet


*--------------------------------------------*
Static Function GeraWF()
	*--------------------------------------------*

	Local a_Area2 	:= GetArea()
	Local cEmail	:= ""

	DbSelectArea("SC1")
	DbSetOrder(1)
	DbSeek(cFilMot + cNumMot)

	cSubject := "Notificaùùo - Devoluùùo da Solicitaùùo de Compras : " + Alltrim(SC1->C1_NUM)
	cTitHtm := "Notificaùùo - Devoluùùo da Solicitaùùo de Compras "

	Op:=Twfprocess():New("PEDCOM","Notificaùùo - Devoluùùo da Solicitaùùo de Compras ")

	Op:NewTask("PEDCOM","\HTML\SCDEVOLUCAO.HTM")

	// RDMF0429 - Leonardo Paiva - 27/10/2017
	// Workflow de devoluùùo de SC nùo sendo enviado ao solicitante porque
	// a rotina estava usando o campo C1_SOLICIT para buscar o e-mailesse campo na versùo 12
	// passou a trazer o nome e nùo o login do usuùrio, elterei para o C1_USER
	// onde grava o cùdigo do usuùrio

	If !Empty(SC1->C1_USER)
		cEmail	:= UsrRetMail(SC1->C1_USER)

		If !Empty(cEmail)
			lAchouSol := .T.
			oP:cTo 	:= cEmail
		Else
			Conout("MT110ROT->GeraWF-> Nùo encontrou o email do usuùrio " + SC1->C1_USER)
		EndIf
	Else
		Conout("MT110ROT->GeraWF-> Nùo encontrou o usuùrio C1_USER")
	EndIf
	/*
Usr := AllUsers()
For i:= 1 To Len(Usr)
	If AllTrim(SC1->C1_SOLICIT) $ Usr[i][1][2]
		If !Empty(Usr[i][1][14])
			oP:cTo      := allTrim(Usr[i][1][14])
		Else
			oP:cTo      := ""
			Alert("Nùo foi possùvel enviar e-mail para o solicitante - E-mail do usuùrio " + alltrim(Usr[i][1][2]) + " nùo cadastrado!")
			RestArea(a_Area2)
			Return

		EndIf
		Exit
	Endif

Next i
	*/
	Montmail()

	oP:bReturn  := ""  // Funcao que ira ser disparada no retorno do e-mail

	oP:Start()

	RestArea(a_Area2)
Return

//**********************************************************************************
//**********************************************************************************
// Monta o corpo do html.
Static Function Montmail()
	//**********************************************************************************
	//**********************************************************************************
	Local a_Area3     := GetArea()
	Private c_Log     := SC1->C1_SOLICIT
	Private c_Fornece := ""
	Private c_Loja    := ""

	dbSelectArea("SM0")
	C_EMP    := SM0->M0_CODIGO
	C_NOME   := SM0->M0_NOME
	C_FILIAL := SM0->M0_FILIAL

	Op:oHtml:Valbyname("LOGO"     	 , GetMv("MV_XEMLOGO",.F.,"http://www.ferroport.com.br/wp-content/uploads/2015/07/logoFerroport.jpg"))
	Op:oHtml:Valbyname("M0_NOME"     , ALLTRIM(C_NOME) + "/" + ALLTRIM(C_FILIAL))

	//Op:oHtml:Valbyname("XCOMPRADOR"   , SC1->C1_SOLICIT )

	Op:oHtml:Valbyname("C1_NUM"      , SC1->C1_NUM)
	Op:oHtml:Valbyname("C1_USER"     , UsrFullName(SC1->C1_USER))

	Op:oHtml:Valbyname("C1_EMISSAO"  , DTOC(SC1->C1_EMISSAO))

	nTotSC := U_f_TotalSC(SC1->C1_NUM)

	Op:oHtml:Valbyname("C1_TOTAL"  ,Transform(nTotSC,PesqPict("SC1","C1_XVLESTI")) )
	Op:oHtml:Valbyname("C1_FILENT" , SC1->C1_FILENT + "/" + C_FILIAL)

	DbSelectArea("SC1")
	c_Sol      := SC1->C1_NUM

	While SC1->C1_NUM = c_Sol .and. !SC1->(EOF())


		c_Oper      := SC1->C1_XOPER
		c_Pacote    := SC1->C1_XPACOTE
		c_CC        := SC1->C1_CC


		AAdd( Op:oHtml:ValByName( "t.1" )   , SC1->C1_ITEM)
		AAdd( Op:oHtml:ValByName( "t.2" )   , SC1->C1_PRODUTO)
		AAdd( Op:oHtml:ValByName( "t.11" )   , c_Oper)
		AAdd( Op:oHtml:ValByName( "t.12" )   , c_Pacote)
		// RDMF0729 - Luis Felipe - 27/03/20 - inicio
		//	AAdd( op:oHtml:ValByName( "t.3" )   , SC1->C1_DESCRI)
		//	AAdd( op:oHtml:ValByName( "t.8")   , SC1->C1_OBS) //
		AAdd( op:oHtml:ValByName( "t.3" )   , If(!Empty(SC1->C1_OBS),Alltrim(SC1->C1_OBS),SC1->C1_DESCRI))
		// RDMF0729 - Luis Felipe - 27/03/20 - Fim
		AAdd( op:oHtml:ValByName( "t.4" )   , SC1->C1_UM)
		AAdd( op:oHtml:ValByName( "t.5" )   , Transform(SC1->C1_QUANT   , PESQPICT("SC1","C1_QUANT")))
		AAdd( op:oHtml:ValByName( "t.6" )   , Transform(SC1->C1_XVLESTI , PESQPICT("SC1","C1_XVLESTI")))
		AAdd( op:oHtml:ValByName( "t.7")   , DTOC(SC1->C1_DATPRF))

		c_DescCC := space(01)
		dbSelectArea("CTT") //Busca a Descricao do Centro de Custo indicado na solicitaùùo de compras
		a_CTTArea := CTT->(GetArea())
		dbSetOrder(1)
		If dbSeek(xFilial("CTT") + c_CC)
			c_DescCC := ALLTRIM(CTT->CTT_DESC01)
		EndIf
		RestArea(a_CTTArea)

		AAdd( op:oHtml:ValByName( "t.10" )   , c_CC + IIF(!Empty(c_DescCC), "- " +c_DescCC, ""))

		dbSelectArea("SC1")
		SC1->(DbSkip())
	EndDo
	//
	Op:oHtml:Valbyname("DATA_DEV" , Dtoc(dDataBase))
	Op:oHtml:Valbyname("USUA_DEV" , alltrim(UsrFullName(__cUserId)))
	Op:oHtml:Valbyname("MOTIVO_DEV" , AllTrim(cMotivo))

	oP:cSubject := csubject
	oP:bTimeOut := {}

	RestArea(a_Area3)
Return

Static Function contType1(funcao)

	private resultado1

	If !Empty(funcao)

		resultado1 := funcao

		if valType(resultado1) == 'U'
			resultado1 := ""
		EndIf

	else

		resultado1 := ""

	EndIf

Return resultado1

Static Function contType2(funcao)

	private resultado2

	If !Empty(funcao)

		resultado2 := funcao

		if valType(resultado2) == 'U'
			resultado2 := 0
		EndIf

	else

		resultado2 := 0

	EndIf

Return resultado2

/*/{Protheus.doc} nFindCarc
//Procura em um array simples por uma palavra, retorna um inteiro sendo 0 n„o encontrado ou o n˙mero do array onde foi encontrado
@author alexandrec.caetano
@since 25/08/2022
@version 1.0
@param aArray, array, vetor onde vem a lista em que ser· feito a pesquisa, tem que estar tudo maiusculo
@param cPalav, characters, palavra que ser· pesquisada, tem que estar maiusculo.
@type function
/*/
Static Function nFindCarc(aArray, cPalav)
	local nret:=0
	nRet := aScan( aArray, { |x| AllTrim( x ) ==  UPPER(AllTrim(cPalav)) } )
Return nRet
//COR004
