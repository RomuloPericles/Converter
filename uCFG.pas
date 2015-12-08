unit uCFG;

interface

  uses tools, Windows, SysUtils, IniFiles, Classes, HTTPApp;

  const
    cMaxCampos = 32;

  type

    tCampo = class(TObject)
      Nome: string;
      Tipo: string;
      Delimitador: string;
      Pos: integer;
      Tam: integer;
      SF: string; // Start of Field
      EF: string; // End of Field

      public
        procedure Reset;
    end;

    tArquivo = class(TObject)
      Nome: string;
      Delimitador: string;
      Cabecalho: string;
      QuebraLinha: string;
      Fixo: string;
      TamLinha: integer;
      Ordenado: string;
      SOR: string; // Start Of Register
      EOR: string; // End OF Register
      Campo: array [0 .. cMaxCampos - 1] of tCampo;
      // NomeCampo: array[0 .. MaxCampos - 1] of string;
      // PosCampo: array[0 .. MaxCampos - 1] of integer;
      // TamCampo: array[0 .. MaxCampos - 1] of integer;
      public
        constructor Create; overload;
        destructor Destroy; overload;
    end;

    tConfig = class(TObject)
      ArqConfig: string;
      ArqIn: tArquivo;
      ArqOut: tArquivo;
      Comm: integer;
      Mask: string;
      DePara: array [0 .. cMaxCampos - 1] of string;
      private
        procedure LoadArq(_Arq: tArquivo; _InOut: String; _Ini: TIniFile);
        procedure SaveArq(_Arq: tArquivo; _InOut: String; _Ini: TIniFile);
        procedure LoadDePara(_CFG: tConfig; _Ini: TIniFile);

      public
        constructor Create; overload;
        destructor Destroy; overload;
        procedure Load;
        procedure Save;
    end;

  var
    gConfig: tConfig;

implementation

  { tArquivo }

  constructor tArquivo.Create;
    var
      i: integer;
    begin
      for i := 0 to cMaxCampos - 1 do
        begin
          Campo[i] := tCampo.Create;
        end;
    end;

  destructor tArquivo.Destroy;
    var
      i: integer;
    begin
      for i := 1 to cMaxCampos - 1 do
        begin
          FreeAndNil(Campo[i]);
        end;
    end;

  constructor tConfig.Create;
    begin
      // Execute the parent (TObject) constructor first
      inherited; // Call the parent Create method
      self.ArqIn := tArquivo.Create;
      self.ArqOut := tArquivo.Create;
    end;

  destructor tConfig.Destroy;
    begin
      inherited;
      FreeAndNil(self.ArqIn);
      FreeAndNil(self.ArqOut);
    end;

  procedure tConfig.Load;
    var
      Ini: TIniFile;
      procedure CriaIni;
        var
          vFile: TextFile;
        begin
          AssignFile(vFile, gConfig.ArqConfig);
          try
            Rewrite(vFile);
          finally
            CloseFile(vFile);
          end;
        end;

    begin
      /// ffff      gConfig.ArqConfig := ChangeFileExt(Application.ExeName, '.INI');
      if not FileExists(gConfig.ArqConfig) then
        begin
          CriaIni;
          Load; // Recursividade pra ler padrão
          Save; // e Salvar no INI
        end;

      Ini := TIniFile.Create(gConfig.ArqConfig);
      // Ini.ReadSection('Exporta', Form1.ListBox1.Items);
      with self do
        begin
          LoadArq(ArqIn, 'IN', Ini);
          LoadArq(ArqOut, 'OUT', Ini);

          LoadDePara(self, Ini);
          Comm := Ini.ReadInteger('Exporta', 'Comm', 1);
          Mask := Ini.ReadString('Exporta', 'Mascara', '');
        end;

    end;

  procedure tConfig.Save;
    var
      Ini: TIniFile;
    begin
      Ini := TIniFile.Create(gConfig.ArqConfig);

      SaveArq(ArqIn, 'IN', Ini);
      SaveArq(ArqOut, 'OUT', Ini);

      Ini.WriteInteger('Exporta', 'Comm', Comm);
      Ini.WriteString('Exporta', 'Mascara', Mask);
    end;

  procedure tConfig.LoadArq(_Arq: tArquivo; _InOut: String; _Ini: TIniFile);
    var
      i:      integer;
      xStr:   string;
      axTStr: TStringList;
      xCampo: string;
    begin
      _InOut := UpperCase(_InOut);

      axTStr := TStringList.Create;
      try
        with _Arq, _Ini do
          begin
            Nome := ReadString(_InOut, 'Arquivo', _InOut + '.TXT');
            Delimitador := Copy(ReadString(_InOut, 'Delimitador', ';'), 1, 1);
            // Delimitador := Copy(Delimitador, 1, 1);
            Cabecalho := Copy(ReadString(_InOut, 'Cabecalho', 'S').ToUpper, 1, 1);
            // Cabecalho   := Copy(Cabecalho, 1, 1);
            QuebraLinha := ReadString(_InOut, 'QuebraLinha', 'S').ToUpper;
            Fixo := Copy(ReadString(_InOut, 'Fixo', 'S').ToUpper, 1, 1);
            Ordenado := Copy(ReadString(_InOut, 'Ordenado', 'S').ToUpper, 1, 1);
            SOR := HTTPDecode(ReadString(_InOut, 'SOR', '!'));      // Como HTML
            EOR := HTTPDecode(ReadString(_InOut, 'EOR', '%0D%0A')); // Como HTML
            TamLinha := ReadInteger(_InOut, 'TamLinha', 20);

            for i := 0 to cMaxCampos - 1 do
              begin
                xCampo := 'Campo' + IntToStr(i + 1);
                Campo[i].Nome := xCampo;
                Campo[i].Tipo := 'T';
                Campo[i].Delimitador := '';
                Campo[i].Pos := 0;
                Campo[i].Tam := 0;
                Campo[i].SF := '';
                Campo[i].EF := '';

                // Campo: Nome, Tipo, Posição, Tamanho
                // Ex: Campo1: Cod, N, 1, 6
                xStr := ReadString(_InOut, xCampo, xCampo + ', T, ", 0, 0, , ');
                if not(ContaStr(xStr, ',') = 6) then
                  raise Exception.Create(xCampo + ' Falha na definição de parâmetros!' + #13 + 'Encontrado: ' + xStr);
                ConverteTextoLista(xStr, axTStr, True, ','); // ',' separador de dados do campo
                Campo[i].Nome := axTStr.Strings[0];
                Campo[i].Tipo := axTStr.Strings[1];
                Campo[i].Delimitador := axTStr.Strings[2];
                try
                  Campo[i].Pos := StrToInt(axTStr.Strings[3]);
                except
                  on E: Exception do
                    MsgErro(xCampo + '(Nome): ' + Campo[i].Nome + ': definida Posição inválida.');
                end;
                try
                  Campo[i].Tam := StrToInt(axTStr.Strings[4]);
                except
                  on E: Exception do
                    MsgErro(xCampo + '(Nome): ' + Campo[i].Nome + ': definido Tamanho inválido.');
                end;
                Campo[i].SF := axTStr.Strings[5];
                Campo[i].EF := axTStr.Strings[6];

              end;
          end;
      finally
        FreeAndNil(axTStr);
      end;
    end;

  procedure tConfig.SaveArq(_Arq: tArquivo; _InOut: String; _Ini: TIniFile);
    var
      i:    integer;
      xStr: string;
    begin
      _InOut := UpperCase(_InOut);
      with _Arq, _Ini do
        begin
          WriteString(_InOut, 'Arquivo', Nome);
          WriteString(_InOut, 'Delimitador', Delimitador);
          WriteString(_InOut, 'QuebraLinha', QuebraLinha);
          WriteString(_InOut, 'Cabecalho', Cabecalho);
          WriteString(_InOut, 'Fixo', Fixo);
          WriteString(_InOut, 'Ordenado', Ordenado);
          WriteString(_InOut, 'SOR', HTTPEncode(SOR));
          WriteString(_InOut, 'EOR', HTTPEncode(EOR));
          WriteInteger(_InOut, 'TamLinha', TamLinha);

          // Limpar campos
          for i := 0 to cMaxCampos - 1 do
            with _Arq.Campo[i] do
              DeleteKey(_InOut, 'Campo' + IntToStr(i + 1));

          // Campo: Nome, Tipo, Posição, Tamanho
          // Ex: Campo1: Cod, N, 1, 6
          // Garatir gravar 1 campo modelo
          WriteString(_InOut, 'Campo1', 'CAMPO1, T, ", 1, 1, , ');

          // ConverteListaTexto(_Arq.Campo[i],xStr,'',',');
          for i := 0 to cMaxCampos - 1 do
            with _Arq.Campo[i] do
              begin
                if Campo[i].Tam <= 0 then
                  Break;
                xStr := Nome;
                xStr := xStr + ', ' + Tipo;
                xStr := xStr + ', ' + Delimitador;
                xStr := xStr + ', ' + IntToStr(Pos);
                xStr := xStr + ', ' + IntToStr(Tam);
                xStr := xStr + ', ' + SF;
                xStr := xStr + ', ' + EF;
                WriteString(_InOut, 'Campo' + IntToStr(i + 1), xStr);

              end;
        end;
    end;

  procedure tConfig.LoadDePara(_CFG: tConfig; _Ini: TIniFile);
    var
      i:      integer;
      xStr:   string;
      xCampo: string;
    begin
      for i := 0 to cMaxCampos - 1 do
        with _CFG, _Ini do
          begin
            xCampo := 'Campo' + IntToStr(i + 1);
            xStr := ReadString('DePara', xCampo, xCampo);
            DePara[i] := xStr;
          end;
    end;

  { tCampo }

  procedure tCampo.Reset;
    begin
      with self do
        begin
          Nome := '';
          Tipo := '';
          Delimitador := '';
          Pos := 0;
          Tam := 0;
        end;
    end;

end.
