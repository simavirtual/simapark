/*************************************************************************
* TITULO..: IMPRESION CAMPOS DEL MANTENIMIENTO                           *
**************************************************************************

AUTOR: Nelson Fern�ndez G�mez       FECHA DE CREACION: jun 11/2009 DIA A
       Colombia, Bucaramanga        INICIO:  11:03 AM  jun 11/2009 DIA

OBJETIVOS:

1- Determina los detalles del informe.

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION PAK_77100(aP1,aP2,aP3,;
		   aArchvo,cOpcPrn,nCodPrn,lModReg,;
		   lDelReg,lInsReg,lHaySql,oBrowse)

*>>>>DESCRIPCION DE PARAMETROS
/*     aP1                                  // Parametros Generales
       aP2                                  // Parametros Generales
       aP3                                  // Parametros Generales
       aArchvo                              // Archivos en Uso
       cOpcPrn                              // Opciones de Impresi�n
       nCodPrn                              // C�digo de Impresi�n
       lModReg                              // .T. Modificar el Registro
       lDelReg                              // .T. Borrar Registros
       lInsReg                              // .T. Insertar Registro
       lHaySql                              // .T. Exportar a Sql
       oBrowse                              // Browse del Archivo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION PARAMETROS
       LOCAL lShared := xPrm(aP1,'lShared') // .T. Sistema Compartido
       LOCAL nModCry := xPrm(aP1,'nModCry') // Modo de Protecci�n
       LOCAL cCodSui := xPrm(aP1,'cCodSui') // C�digo del Sistema
       LOCAL cNomSis := xPrm(aP1,'cNomSis') // Nombre del Sistema
     *�Detalles del Sistema

       LOCAL cEmpPal := xPrm(aP1,'cEmpPal') // Nombre de la Empresa principal
       LOCAL cNitEmp := xPrm(aP1,'cNitEmp') // Nit de la Empresa
       LOCAL cNomEmp := xPrm(aP1,'cNomEmp') // Nombre de la Empresa
       LOCAL cNomSec := xPrm(aP1,'cNomSec') // Nombre de la Empresa Secundario
       LOCAL cCodEmp := xPrm(aP1,'cCodEmp') // C�digo de la Empresa
     *�Detalles de la Empresa

       LOCAL cNomUsr := xPrm(aP1,'cNomUsr') // Nombre del Usuario
       LOCAL cAnoUsr := xPrm(aP1,'cAnoUsr') // A�o del usuario
       LOCAL cAnoSis := xPrm(aP1,'cAnoSis') // A�o del sistema
       LOCAL cPatSis := xPrm(aP1,'cPatSis') // Path del sistema
     *�Detalles del Usuario

       LOCAL PathW01 := xPrm(aP1,'PathW01') // Sitio del Sistema No.01
       LOCAL PathW02 := xPrm(aP1,'PathW02') // Sitio del Sistema No.02
       LOCAL PathW03 := xPrm(aP1,'PathW03') // Sitio del Sistema No.03
       LOCAL PathW04 := xPrm(aP1,'PathW04') // Sitio del Sistema No.04
       LOCAL PathW05 := xPrm(aP1,'PathW05') // Sitio del Sistema No.05
       LOCAL PathW06 := xPrm(aP1,'PathW06') // Sitio del Sistema No.06
       LOCAL PathW07 := xPrm(aP1,'PathW07') // Sitio del Sistema No.07
       LOCAL PathW08 := xPrm(aP1,'PathW08') // Sitio del Sistema No.08
       LOCAL PathW09 := xPrm(aP1,'PathW09') // Sitio del Sistema No.09
       LOCAL PathW10 := xPrm(aP1,'PathW10') // Sitio del Sistema No.10
     *�Sitios del Sistema

       LOCAL PathUno := xPrm(aP1,'PathUno') // Path de Integraci�n Uno
       LOCAL PathDos := xPrm(aP1,'PathDos') // Path de Integraci�n Dos
       LOCAL PathTre := xPrm(aP1,'PathTre') // Path de Integraci�n Tres
       LOCAL PathCua := xPrm(aP1,'PathCua') // Path de Integraci�n Cuatro
     *�Path de Integraci�n

       LOCAL nFilPal := xPrm(aP1,'nFilPal') // Fila Inferior Men� principal
       LOCAL nFilInf := xPrm(aP1,'nFilInf') // Fila Inferior del SubMen�
       LOCAL nColInf := xPrm(aP1,'nColInf') // Columna Inferior del SubMen�
     *�Detalles Tecnicos

       LOCAL cMaeAlu := xPrm(aP1,'cMaeAlu') // Maestros habilitados
       LOCAL cMaeAct := xPrm(aP1,'cMaeAct') // Maestro Activo
       LOCAL cJorTxt := xPrm(aP1,'cJorTxt') // Jornada escogida
     *�Detalles Acad�micos
*>>>>FIN DECLARACION PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
     *�Variables generales

       LOCAL     i,j := 0                   // Contadores
       LOCAL cUsrIso := ''                  // Usuario de la Iso
       LOCAL nNroInf := 0                   // N�mero del informe
       LOCAL cOpcSys := ''                  // Opci�n del Sistema
       LOCAL cCodInf := ''                  // C�digo del Informe
       LOCAL aMarInf := {}                  // L�neas de Espaciado
       LOCAL nNroDoc := 0                   // N�mero del Documento variable
       LOCAL fDocPrn := ''                  // Archivo a imprimir
       LOCAL nCabIso := 0                   // Encabezado del Informe
       LOCAL cCodIso := ''                  // C�digo Iso del Informe
       LOCAL cFecIso := ''                  // Fecha del Iso
       LOCAL cVerIso := ''                  // Versi�n del Iso
       LOCAL aTitIso := {}                  // T�tulo Iso del Informe
       LOCAL cPiePag := ''                  // Pie de P�gina por defecto
       LOCAL aPieIso := {}		    // Textos del pie de p�gina
       LOCAL nTotPie := 0                   // Total de Pie de p�ginas
       LOCAL aObsIso := {}                  // Observaciones del informe
       LOCAL aMezIso := {}                  // Campos a Mesclar
       LOCAL bInsIso := NIL                 // Block de Gestion Documental
     *�Gestion Documental

       LOCAL FilePrn := ''                  // Archivo de impresion
       LOCAL nRegPrn := 0                   // Registro de Impresi�n
       LOCAL nHanXml := 0                   // Manejador del Archivo
       LOCAL cFecPrn := ''                  // @Fecha de Impresi�n
       LOCAL cHorPrn := ''                  // @Hora de Impresi�n
       LOCAL cDiaPrn := ''                  // @D�a de Impresi�n
       LOCAL nNroPag := 1                   // N�mero de p�gina
       LOCAL lTamAnc := .F.                 // .T. Tama�o Ancho
       LOCAL nLinTot := 0                   // L�neas totales de control
       LOCAL nTotReg := 0                   // Total de registros
       LOCAL aCabPrn := {}                  // Encabezado del informe General
       LOCAL aCabeza := {}                  // Encabezado del informe
       LOCAL cCodIni := ''                  // C�digos de impresi�n iniciales
       LOCAL cCodFin := ''                  // C�digos de impresi�n finales
       LOCAL aNroCol := {}                  // Columnas de impresi�n
       LOCAL aTitPrn := {}                  // T�tulos para impresi�n
       LOCAL aRegPrn := {}                  // Registros para impresi�n
       LOCAL cCabCol := ''                  // Encabezado de Columna
       LOCAL aCabSec := {}                  // Encabezado Secundario
       LOCAL nLenPrn := 0                   // Longitud l�nea de impresi�n
       LOCAL lCentra := .F.                 // .T. Centrar el informe
       LOCAL nColCab := 0                   // Columna del encabezado
       LOCAL bPagina := NIL                 // Block de P�gina
       LOCAL bCabeza := NIL                 // Block de Encabezado
       LOCAL bDerAut := NIL                 // Block Derechos de Autor
       LOCAL nLinReg := 1                   // L�neas del registro
       LOCAL cTxtPrn := ''                  // Texto de impresi�n
       LOCAL nOpcPrn := 0                   // Opci�n de Impresi�n
       LOCAL aPrnWww := {}		    // Detalles informes para www
       LOCAL lPrnCab := .T.                 // .T. Imprimir el Encabezado
       LOCAL aDetInf := {}                  // Detalles del Informe
     *�Variables de informe

       LOCAL lHayPrn := .F.                 // .T. Hay Archivo de Impresi�n
       LOCAL aUseDbf := {}                  // Archivos en Uso
       LOCAL fArchvo := ''                  // Nombre del Archivo
       LOCAL fNtxArc := ''                  // Archivo Indice
       LOCAL cNalias := ''                  // Alias del Archivo

       LOCAL Getlist := {}                  // Variable del sistema
     *�Variables espec�ficas
*>>>>FIN DECLARACION DE VARIABLES

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       FOR i := 1 TO LEN(aArchvo)
           fArchvo := aArchvo[i,1]
           fNtxArc := aArchvo[i,2]
           cNalias := aArchvo[i,3]
           AADD(aUseDbf,{.T.,fArchvo,cNalias,fNtxArc,lShared,nModCry})
           IF cNalias == 'PRN'
              lHayPrn := .T.
           ENDIF
       ENDFOR
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF LEN(aArchvo) # 0
	  IF !lUseDbfs(aUseDbf)
	     cError('ABRIENDO EL ARCHIVO')
	     CloseAll()
	     RETURN NIL
	  ENDIF
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>LOCALIZACION DE LA IMPRESORA
       IF lHayPrn
          IF !lLocCodigo('nCodigoPrn','PRN',nCodPrn)
             cError('NO EXISTE LA IMPRESORA QUE ESTA HABILITADA')
             CloseAll()
             RETURN NIL
          ENDIF
       ENDIF
*>>>>FIN LOCALIZACION DE LA IMPRESORA

*>>>>GESTION DOCUMENTAL DEL INFORME
       nLenPrn := PCL('n17Stan')

       nNroInf := 771
     *�N�mero de identificaci�n del informe

       cOpcSys := '[UTILIDADES][MANTENIMIENTOS][DESCUENTOS]'
     *�Opci�n del sistema del informe

       cCodInf := 'PAK77100'
       AADD(aDetInf,{'cCodInf',cCodInf})
     *�C�digo del Informe

       AADD(aMarInf,{0,0}) // MS:ID
       AADD(aMarInf,{0,0}) // MI:ID
       AADD(aMarInf,{0,0}) // M1:ID
       AADD(aMarInf,{0,0}) // M2:ID
       AADD(aDetInf,{'aMarInf',aMarInf})
     *�M�rgenes del informe

       nNroDoc := 0
     *�Informe por defecto

       aMezIso := {}
       AADD(aMezIso,{'<cAnoUsr>',cAnoUsr})
       AADD(aMezIso,{'<cJorTxt>',cJorTxt})
     *�Campos a sustituir

       aTitIso := {}
       AADD(aTitIso,'DESCUENTOS PARQUEADERO')        // T�tulo Uno
       AADD(aTitIso,'A�O: <cAnoUsr> JORNADA: <cJorTxt>')  // T�tulo Dos
       AADD(aTitIso,'')                                   // T�tulo Tres
       AADD(aDetInf,{'aTitIso',aTitIso})
     *�T�tulos del Informe por defecto

       cPiePag := xPrm(aP3,'cPieTre')
       IF !EMPTY(cPiePag)
	  cPiePag := SPACE((nLenPrn-LEN(cPiePag))/2)+cPiePag
       ENDIF

       aPieIso := {}
       AADD(aPieIso,'')                 // Pie de p�gina Uno
       AADD(aPieIso,'')                 // Pie de p�gina Dos
       AADD(aPieIso,IF(EMPTY(cPiePag),'',cPiePag))  // Pie de p�gina Tres
       AADD(aDetInf,{'aPieIso',aPieIso})
     *�Pie de p�ginas por defecto

       aObsIso := {}
       AADD(aObsIso,'')
       AADD(aObsIso,'')
       AADD(aObsIso,'')

       cUsrIso := xPrm(aP3,'cUsrIso')
     *�Usuario Iso

       bInsIso := {||lModRegIso(lShared,cNomUsr,oBrowse,;
				nNroInf,aTitIso[1],cOpcSys,;
				cUsrIso,;
				cCodInf,aMarInf,nNroDoc,aObsIso)}
     *�Inclusi�n o modificaci�n de la gesti�n docuemental
*>>>>FIN GESTION DOCUMENTAL DEL INFORME

*>>>>ACTIVACION DE LA IMPRESORA
       IF nNroInf == 0
	  FilePrn := cCodInf
	  nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,cOpcPrn,.T.,.T.)
       ELSE
	  FilePrn := cCodInf
	  nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,cOpcPrn,.T.,2,bInsIso)
       ENDIF
       IF EMPTY(nOpcPrn)
	  RETURN NIL
       ENDIF
       AADD(aDetInf,{'nOpcPrn',nOpcPrn})
       AADD(aDetInf,{'FilePrn',FilePrn})
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>SUSTITUCION DE TEXTO
       fDocPrn := ''
       IF !lValDetIso(nNroInf,@cCodIso,@aTitIso,@aPieIso,;
		      @cCodInf,@aMarInf,@nNroDoc,@aObsIso,;
		      @fDocPrn)
	  RETURN NIL
       ENDIF
       ReplTitIso(@aTitIso,aMezIso)
*>>>>FIN SUSTITUCION DE TEXTO

*>>>>DEFINICION DEL ENCABEZADO
       nNroPag := 0
       lTamAnc := .F.
       AADD(aDetInf,{'lTamAnc',lTamAnc})

       nTotReg := 0

       aCabPrn := {cNomEmp,cNomSis,;
		   aTitIso[1],;
		   aTitIso[2],;
		   aTitIso[3]}
       AADD(aDetInf,{'aCabPrn',aCabPrn})

       AADD(aDetInf,{'nNroPag',nNroPag})
       AADD(aDetInf,{'cTotPag',cTotPagina(nTotReg)})

       cCodIni := PCL({'DraftOn','Elite','CondenOn'})
       cCodFin := PCL({'NegraOf','DobGolOf'})

       AADD(aDetInf,{'cCodIni',cCodIni})
       AADD(aDetInf,{'cCodFin',cCodFin})
*>>>>FIN DEFINICION DEL ENCABEZADO

*>>>>CONTROL DE DOCUMENTOS
       nCabIso := ISO->nCabPrnIso
       AADD(aDetInf,{'nCabIso',nCabIso})

       IF nNroInf # 0
	  cCodIso := ALLTRIM(ISO->cCodigoIso)
	  cFecIso := ALLTRIM(ISO->cFecAprIso)
	  cVerIso := ALLTRIM(ISO->cNroVerIso)
       ENDIF
       AADD(aDetInf,{'cCodIso',cCodIso})
       AADD(aDetInf,{'cFecIso',cFecIso})
       AADD(aDetInf,{'cVerIso',cVerIso})
*>>>>FIN CONTROL DE DOCUMENTOS

*>>>>IMPRESION DEL INFORME
       DO CASE
       CASE UPPER(cCodInf) == 'PAK77100'

	    PAK_771_00(aP1,aP2,aP3,;
		       aDetInf,oBrowse)
	  *�Informe por defecto.

       OTHERWISE
	    cError('NO SE HA DEFINIDO EL INFORMES '+cCodInf)
       ENDCASE

       IF LEN(aArchvo) # 0
	  CloseAll()
       ENDIF
       RETURN NIL
*>>>>FIN IMPRESION DEL INFORME

/*************************************************************************
* TITULO..: DESCUENTOS PARQUEADERO. VERSION No.00                   *
**************************************************************************

AUTOR: Nelson Fern�ndez G�mez       FECHA DE CREACION: jun 11/2009 DIA A
       Colombia, Bucaramanga        INICIO:  11:03 AM  jun 11/2009 DIA

OBJETIVOS:

1- Imprime los campos del informe

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION PAK_771_00(aP1,aP2,aP3,aDetInf,oBrowse)

*>>>>DESCRIPCION DE PARAMETROS
/*     aP1                                  // Parametros Generales
       aP2                                  // Parametros Generales
       aP3                                  // Parametros Generales
       aDetInf                              // Detalles del Informe
       oBrowse                              // Browse del Archivo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION PARAMETROS GENERALES
       LOCAL lShared := xPrm(aP1,'lShared') // .T. Sistema Compartido
       LOCAL nModCry := xPrm(aP1,'nModCry') // Modo de Protecci�n
       LOCAL cCodSui := xPrm(aP1,'cCodSui') // C�digo del Sistema
       LOCAL cNomSis := xPrm(aP1,'cNomSis') // Nombre del Sistema
     *�Detalles del Sistema

       LOCAL cEmpPal := xPrm(aP1,'cEmpPal') // Nombre de la Empresa principal
       LOCAL cNitEmp := xPrm(aP1,'cNitEmp') // Nit de la Empresa
       LOCAL cNomEmp := xPrm(aP1,'cNomEmp') // Nombre de la Empresa
       LOCAL cNomSec := xPrm(aP1,'cNomSec') // Nombre de la Empresa Secundario
       LOCAL cCodEmp := xPrm(aP1,'cCodEmp') // C�digo de la Empresa
     *�Detalles de la Empresa

       LOCAL cNomUsr := xPrm(aP1,'cNomUsr') // Nombre del Usuario
       LOCAL cAnoUsr := xPrm(aP1,'cAnoUsr') // A�o del usuario
       LOCAL cAnoSis := xPrm(aP1,'cAnoSis') // A�o del sistema
       LOCAL cPatSis := xPrm(aP1,'cPatSis') // Path del sistema
     *�Detalles del Usuario

       LOCAL PathW01 := xPrm(aP1,'PathW01') // Sitio del Sistema No.01
       LOCAL PathW02 := xPrm(aP1,'PathW02') // Sitio del Sistema No.02
       LOCAL PathW03 := xPrm(aP1,'PathW03') // Sitio del Sistema No.03
       LOCAL PathW04 := xPrm(aP1,'PathW04') // Sitio del Sistema No.04
       LOCAL PathW05 := xPrm(aP1,'PathW05') // Sitio del Sistema No.05
       LOCAL PathW06 := xPrm(aP1,'PathW06') // Sitio del Sistema No.06
       LOCAL PathW07 := xPrm(aP1,'PathW07') // Sitio del Sistema No.07
       LOCAL PathW08 := xPrm(aP1,'PathW08') // Sitio del Sistema No.08
       LOCAL PathW09 := xPrm(aP1,'PathW09') // Sitio del Sistema No.09
       LOCAL PathW10 := xPrm(aP1,'PathW10') // Sitio del Sistema No.10
     *�Sitios del Sistema

       LOCAL PathUno := xPrm(aP1,'PathUno') // Path de Integraci�n Uno
       LOCAL PathDos := xPrm(aP1,'PathDos') // Path de Integraci�n Dos
       LOCAL PathTre := xPrm(aP1,'PathTre') // Path de Integraci�n Tres
       LOCAL PathCua := xPrm(aP1,'PathCua') // Path de Integraci�n Cuatro
     *�Path de Integraci�n

       LOCAL nFilPal := xPrm(aP1,'nFilPal') // Fila Inferior Men� principal
       LOCAL nFilInf := xPrm(aP1,'nFilInf') // Fila Inferior del SubMen�
       LOCAL nColInf := xPrm(aP1,'nColInf') // Columna Inferior del SubMen�
     *�Detalles Tecnicos

       LOCAL cMaeAlu := xPrm(aP1,'cMaeAlu') // Maestros habilitados
       LOCAL cMaeAct := xPrm(aP1,'cMaeAct') // Maestro Activo
       LOCAL cJorTxt := xPrm(aP1,'cJorTxt') // Jornada escogida
     *�Detalles Acad�micos
*>>>>FIN DECLARACION PARAMETROS GENERALES

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                      // Salvar Pantalla
     *�Variables generales

       LOCAL     i,j := 0                       // Contadores
       LOCAL cUsrIso := ''                      // Usuario de la Iso
       LOCAL nNroInf := 0                       // N�mero del informe
       LOCAL cOpcSys := ''                      // Opci�n del Sistema
       LOCAL cCodInf := xPrm(aDetInf,'cCodInf') // C�digo del Informe
       LOCAL aMarInf := {}                      // L�neas de Espaciado
       LOCAL nNroDoc := 0                       // N�mero del Documento variable
       LOCAL fDocPrn := ''                      // Archivo a imprimir
       LOCAL nCabIso := xPrm(aDetInf,'nCabIso')	// Encabezado del Informe
       LOCAL cCodIso := xPrm(aDetInf,'cCodIso')	// C�digo Iso del Informe
       LOCAL cFecIso := xPrm(aDetInf,'cFecIso')	// Fecha del Iso
       LOCAL cVerIso := xPrm(aDetInf,'cVerIso')	// Versi�n del Iso
       LOCAL aTitIso := ''                      // T�tulo Iso del Informe
       LOCAL cPiePag := ''                      // Pie de P�gina por defecto
       LOCAL aPieIso := xPrm(aDetInf,'aPieIso')	// Textos del pie de p�gina
       LOCAL nTotPie := 0                       // Total de Pie de p�ginas
       LOCAL aObsIso := {}                      // Observaciones del informe
       LOCAL aMezIso := {}                      // Campos a Mesclar
       LOCAL bInsIso := NIL                     // Block de Gestion Documental
     *�Gestion Documental

       LOCAL FilePrn := xPrm(aDetInf,'FilePrn')	// Archivo de impresion
       LOCAL nRegPrn := 0                       // Registro de Impresi�n
       LOCAL nHanXml := 0                       // Manejador del Archivo
       LOCAL cFecPrn := ''                      // @Fecha de Impresi�n
       LOCAL cHorPrn := ''                      // @Hora de Impresi�n
       LOCAL cDiaPrn := ''                      // @D�a de Impresi�n
       LOCAL nNroPag := 1                       // N�mero de p�gina
       LOCAL lTamAnc := .F.                     // .T. Tama�o Ancho
       LOCAL nLinTot := 0                       // L�neas totales de control
       LOCAL nTotReg := 0                       // Total de registros
       LOCAL aCabPrn := xPrm(aDetInf,'aCabPrn')	// Encabezado del informe General
       LOCAL aCabeza := {}                      // Encabezado del informe
       LOCAL cCodIni := ''                      // C�digos de impresi�n iniciales
       LOCAL cCodFin := ''                      // C�digos de impresi�n finales
       LOCAL aNroCol := {}                      // Columnas de impresi�n
       LOCAL aTitPrn := {}                      // T�tulos para impresi�n
       LOCAL aRegPrn := {}                      // Registros para impresi�n
       LOCAL cCabCol := ''                      // Encabezado de Columna
       LOCAL aCabSec := {}                      // Encabezado Secundario
       LOCAL nLenPrn := 0                       // Longitud l�nea de impresi�n
       LOCAL lCentra := .F.                     // .T. Centrar el informe
       LOCAL nColCab := 0                       // Columna del encabezado
       LOCAL bPagina := NIL                     // Block de P�gina
       LOCAL bCabeza := NIL                     // Block de Encabezado
       LOCAL bDerAut := NIL                     // Block Derechos de Autor
       LOCAL nLinReg := 1                       // L�neas del registro
       LOCAL cTxtPrn := ''                      // Texto de impresi�n
       LOCAL nOpcPrn := xPrm(aDetInf,'nOpcPrn')	// Opci�n de Impresi�n
       LOCAL aPrnWww := {}		        // Detalles informes para www
       LOCAL lPrnCab := .T.                 // .T. Imprimir el Encabezado
     *�Variables de informe

       LOCAL Getlist := {}                  // Variable del sistema
     *�Variables espec�ficas
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ENCABEZADOS DE COLUMNA
       aNroCol := {}
       aTitPrn := {}

       AADD(aNroCol,8)
       AADD(aTitPrn,'VEHICULO')
       AADD(aNroCol,4)
       AADD(aTitPrn,'HORA')
       AADD(aNroCol,9)
       AADD(aTitPrn,'DESCONTAR')

       cCabCol := cRegPrint(aTitPrn,aNroCol)
       AADD(aDetInf,{'xCabCol',cCabCol})
*>>>>FIN ENCABEZADOS DE COLUMNA

*>>>>DETALLES DEL INFORME
       lCentra := .F.
       nColCab := 0
       IF lCentra
          nColCab := (nLenPrn-LEN(cCabCol))/2
       ENDIF
       AADD(aDetInf,{'nColPrn',nColCab})

       aCabSec := NIL
       AADD(aDetInf,{'aCabSec',aCabSec})

       bPagina := {||lPagina(nLinReg)}
       bCabeza := {||CabPrnIso(aP1,aP2,aP3,;
			       aDetInf,@cFecPrn,@cHorPrn,@cDiaPrn)}
       bDerAut := {||PiePagIso(aPieIso,nLenPrn)}
*>>>>FIN DETALLES DEL INFORME

*>>>>DETALLES DEL ENCABEZADO
       AADD(aCabPrn,cFecPrn)
       AADD(aCabPrn,cHorPrn)
       AADD(aCabPrn,cDiaPrn)

       aPrnWww := {}
       AADD(aPrnWww,{'nCodXsl',nCabIso})
       AADD(aPrnWww,{'cCodInf',cCodInf})
       AADD(aPrnWww,{'cCodIso',cCodIso})
       AADD(aPrnWww,{'cFecIso',cFecIso})
       AADD(aPrnWww,{'cVerIso',cVerIso})
       AADD(aPrnWww,{'cPieUno',aPieIso[1]})
       AADD(aPrnWww,{'cPieDos',aPieIso[2]})
       AADD(aPrnWww,{'cPieTre',aPieIso[2]})

       nHanXml := CreaFrmPrn(lShared,FilePrn,aNroCol,;
			     nOpcPrn,aCabPrn,aTitPrn,aPrnWww)
*>>>>FIN DETALLES DEL ENCABEZADO

*>>>>RECORRIDO DE LOS REGISTROS
       cSavPan := SAVESCREEN(0,0,24,79)

       SELECT DES
       DES->(DBGOTOP())
       DO WHILE .NOT. DES->(EOF())

**********IMPRESION DE LA LINEA DE ESTADO
	    SET DEVICE TO SCREEN
	    LineaEstados('�No. '+DES->(STR(RECNO(),4))+'/'+;
			  DES->(STR(RECCOUNT(),4)),cNomSis)
	    SET DEVICE TO PRINT
**********FIN IMPRESION DE LA LINEA DE ESTADO

**********IMPRESION DEL ENCABEZADO
	    IF lPrnCab

	       SET DEVICE TO PRINT

	       SendCodes(PCL('Reset'))

	       EVAL(bCabeza)
	      *Impresi�n del Encabezado

	       lPrnCab := .F.

	       SET DEVICE TO SCREEN
	    ENDIF
**********FIN IMPRESION DEL ENCABEZADO

**********IMPRESION DEL REGISTRO
	    aRegPrn := {}

	    AADD(aRegPrn,DES->cTipVehCat)
	    AADD(aRegPrn,STR(DES->nNroHorDes,02,0))
	    AADD(aRegPrn,IF(DES->lDesMinDes,'SI','NO'))

	    lPrnRegFrm(lShared,nOpcPrn,FilePrn,nHanXml,01,nColCab,;
		       aTitPrn,aRegPrn,aNroCol,bPagina,bDerAut,bCabeza)
**********FIN IMPRESION DEL REGISTRO

**********AVANCE DEL SIGUIENTE REGISTRO
	    SELECT DES
	    DES->(DBSKIP())
**********FIN AVANCE DEL SIGUIENTE REGISTRO

       ENDDO
       RESTSCREEN(0,0,24,79,cSavPan)
*>>>>FIN RECORRIDO DE LOS REGISTROS

*>>>>IMPRESION DERECHOS
       EVAL(bDerAut)
      *Derechos de Autor

       VerPrn(nOpcPrn,FilePrn,nHanXml)
       SET DEVICE TO SCREEN
       oBrowse:GOTOP()
       oBrowse:FORCESTABLE()
       RETURN NIL
*>>>>FIN IMPRESION DERECHOS