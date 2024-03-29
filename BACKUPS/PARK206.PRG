/*                  SIMA - SISTEMA PARA INTRANET E INTERNET

MODULO      : CONSULTAS
SUBMODULO...: PERSONAS

**************************************************************************
* TITULO..: CONSULTAR LAS PERSONAS                                       *
**************************************************************************

AUTOR: Nelson Fern�ndez G�mez       FECHA DE CREACION: JUL 28/2005 VIE A
       Colombia, Bucaramanga        INICIO: 06:00 PM   JUL 28/2005 VIE

OBJETIVOS:

1- Mantenimiento del Archivo Personas

2- Return Nil

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Pak_206(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
		 cNomEmp,cNomSec,cCodEmp,nFilInf,nColInf,;
		 nFilPal,cNomUsr,cAnoUsr,cPatDat,cPatSys,;
		 cPatSis,cMaeAlu,cMaeAct,cJorTxt)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci�n
       cNomSis                              // Nombre del Sistema
       cEmpPal                              // Nombre de la Empresa principal
       cNitEmp                              // Nit de la Empresa
       cNomEmp                              // Nombre de la Empresa
       cNomSec                              // Nombre de la Empresa Secundario
       cCodEmp			            // C�digo de la Empresa
       nFilInf                              // Fila Inferior del SubMen�
       nColInf                              // Columna Inferior del SubMen�
       nFilPal                              // Fila Inferior Men� principal
       cNomUsr                              // Nombre del Usuario
       cAnoUsr                              // A�o del usuario
       cPatDat                              // Path datos del Sistema
       cPatSys                              // Path del Sistema
       cPatSis                              // Path del sistema
       cMaeAlu                              // Maestros habilitados
       cMaeAct                              // Maestro Activo
       cJorTxt                              // Jornada escogida */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "CAMPOS\ARC-PARK.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A�o del sistema
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cIntUno := ''                  // Path de Integraci�n Uno
       LOCAL cIntDos := ''                  // Path de integraci�n dos
       LOCAL cIntTre := ''                  // Path de integraci�n tres
       LOCAL cIntCua := ''                  // Path de integraci�n cuatro

       LOCAL cTitSup := ''                  // T�tulo Superior del Browse
       LOCAL aCampos := NIL                 // Definici�n de Campos
       LOCAL cTitInf := ''                  // T�tulo Inferior del Browse
       LOCAL oBrowse := NIL                 // Browse de Alumnos

       LOCAL aArchvo := {}                  // Archivos para Uso
       LOCAL aArcNtx := {}                  // Archivo de Indices
       LOCAL cNalias := ''                  // Alias del Archivo
       LOCAL lPrnArc := .F.                 // .T. Imprimir a Archivo
       LOCAL cOpcPrn := ''                  // Opciones de Impresi�n.
       LOCAL nCodPrn := 0                   // C�digo de Impresi�n
       LOCAL lModReg := .F.                 // .T. Modificar el Registro
       LOCAL lDelReg := .F.                 // .T. Borrar Registros
       LOCAL lInsReg := .F.                 // .T. Insertar Registro
       LOCAL lHaySql := .F.                 // .T. Exportar a Sql

       MEMVA xClrSys			    // Color del Sistema
       LOCAL GetList := {}                  // Variable del Sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,PathSis+'\'+fSimPak,'PAR',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared,nModCry})
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbfs(aUseDbf)
	  cError('ABRIENDO EL ARCHIVO FIADORES')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE PAR->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION GENERAL')

       CASE PRN->(RECCOUNT()) == 0
	    cError('NO EXISTEN IMPRESIORAS GRABADAS')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>LOCALIZACION DE LA IMPRESORA
       IF !lLocCodigo('nCodigoPrn','PRN',PAR->nCodigoPrn)
	  cError('NO EXISTE LA IMPRESORA QUE ESTA HABILITADA')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
       lPrnArc := PAR->lPrnArcPak
       nCodPrn := PAR->nCodigoPrn
       cOpcPrn := PAR->cOpcPrnPak
*>>>>FIN LOCALIZACION DE LA IMPRESORA

*>>>>AREAS DE TRABAJO
       AADD(aArcNtx,Ntx1Per)
       aArchvo := {}
*>>>>FIN AREAS DE TRABAJO

*>>>>MANTENIMIENTO DEL ARCHIVO
       lModReg := .F.
       lDelReg := .F.
       lInsReg := .T.
       lHaySql := .F.

       MantenPer(lShared,nModCry,cNomSis,cCodEmp,cNitEmp,cEmpPal,;
		 cNomEmp,cNomSec,cNomUsr,cAnoUsr,;
		 PathSis(cPatDat+'\'+cPatSys,PathSis),;
		 FilePer,aArcNtx,lPrnArc,cOpcPrn,;
		 lModReg,lDelReg,lInsReg,lHaySql)
       CloseAll()
       RETURN NIL
*>>>>FIN MANTENIMIENTO DEL ARCHIVO