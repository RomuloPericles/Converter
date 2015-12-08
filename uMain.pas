unit uMain;

interface

  uses
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, Buttons, IniFiles, StdCtrls, // Vcl.Menus, //uFuncoes,
    uCFG, Vcl.Menus,                      // Vcl.Menus,
    HTTPApp;

  type
    TfrmMain = class(TForm)
      btnConverter: TSpeedButton;
      Memo1: TMemo;
      ListBox1: TListBox;
      btn2: TSpeedButton;
      SpeedButton1: TSpeedButton;
      SpeedButton2: TSpeedButton;
      Edit1: TEdit;
      Memo2: TMemo;
      edtArqIn: TEdit;
      edtArqOut: TEdit;
      MainMenu1: TMainMenu;
      mniArquivo: TMenuItem;
      Sair1: TMenuItem;
      mniConfiguracao: TMenuItem;
      mniAjuda: TMenuItem;
      mniSobre: TMenuItem;
      btnReverter: TSpeedButton;
      procedure LoadCFG;
      procedure btnConverterClick(Sender: TObject);
      procedure FormShow(Sender: TObject);
      procedure FormCreate(Sender: TObject);
      procedure FormDestroy(Sender: TObject);
      procedure btn2Click(Sender: TObject);
      procedure SpeedButton1Click(Sender: TObject);
      procedure SpeedButton2Click(Sender: TObject);
      procedure mniConfiguracaoClick(Sender: TObject);
      procedure Sair1Click(Sender: TObject);
      private
        { Private declarations }
      public
        { Public declarations }
    end;

  var
    frmMain: TfrmMain;
    // gConfig: tConfig;

implementation

  // Create a object - parameterless version
  uses uConfig, tools;

  {$R *.dfm}

  procedure TfrmMain.btnConverterClick(Sender: TObject);
    var
      FileIn, FileOut: TextFile;
      axReg, axStr:    string;
      axChar:          Char;
      j, i:            integer;
      axTStr:          TStringList;
      axCampos:        TStringList;

      function LeRegIn(_Arq: tArquivo): string;
        var
          i:     integer;
          xChar: array of byte;
        begin
          Result := '';
          with _Arq do
            begin
              if QuebraLinha = 'S' then
                Readln(FileIn, Result)
              else
                for i := 1 to TamLinha do
                  begin
                    Read(FileIn, axChar);
                    Result := Result + axChar;
                  end;
            end;
        end;

      procedure CarregaCamposIn(_Str: string; _Lista: TStrings; _Arq: tArquivo);
        var
          i: integer;
        begin
          _Lista.Clear;
          if _Arq.Fixo <> 'S' then
            begin
              ConverteTextoLista(_Str, _Lista, True, _Arq.Delimitador);
              for i := 0 to _Lista.Count - 1 do
                _Lista.Strings[i] := StringReplace(_Lista.Strings[i].Trim, _Arq.Campo[i].Delimitador, '', [rfReplaceAll]);
              // _Lista.Strings[i] := _Arq.Campo[i].Delimitador + _Lista.Strings[i].Trim + _Arq.Campo[i].Delimitador;
            end
          else
            for i := 0 to cMaxCampos - 1 do
              begin
                if _Arq.Campo[i].Tam <= 0 then
                  Break;
                _Lista.Add(InvRTrim(Copy(_Str, _Arq.Campo[i].Pos, _Arq.Campo[i].Tam), _Arq.Campo[i].Tam));
              end;
        end;

      function MontaRegOut(_Lista: TStrings; _Arq: tArquivo): string;
        var
          i:    integer;
          xStr: string;
        begin
          with _Lista do
            begin
              // 1o Campo = [0]
              // if (_Arq.Fixo = 'S') then
              // xStr := InvRTrim(Strings[0], _Arq.Campo[0].Tam)
              // else
              // xStr := Strings[0];
              // Result := _Arq.Campo[0].Delimitador + xStr + _Arq.Campo[0].Delimitador;
              Result := '';

              for i := 0 to cMaxCampos - 1 do
                begin
                  if _Arq.Campo[i].Tam <= 0 then
                    Break;
                  if i > 0 then
                    Result := Result + _Arq.Delimitador;

                  Result := Result + _Arq.Campo[i].Delimitador;

                  if _Arq.Campo[i].Tipo = '' then
                    xStr := Strings[i]
                  else
                    case Ord(_Arq.Campo[i].Tipo[1]) of
                      Ord('N'):
                        xStr := DeixaNumero(Strings[i]);
                      Ord('n'):
                        if EhNumero(Strings[i]) then
                          xStr := Strings[i]
                        else
                          xStr := '0';
                      else
                        xStr := Strings[i];
                    end;

                  if (_Arq.Fixo = 'S') then
                    if _Arq.Campo[i].Tipo.ToUpper = 'N' then
                      xStr := FormataStr(taDireita, xStr, _Arq.Campo[i].Tam, '0')
                    else
                      xStr := FormataStr(taEsquerda, xStr, _Arq.Campo[i].Tam, ' ');

                  Result := Result + xStr;
                  Result := Result + _Arq.Campo[i].Delimitador;
                end; // for
            end;
        end;

    begin
      axTStr := TStringList.Create;
      axCampos := TStringList.Create;
      try
        axTStr.Clear;
        i := 0;
        axReg := '';
        // Try to open the Test.txt file for writing to
        AssignFile(FileIn, gConfig.ArqIn.Nome);
        AssignFile(FileOut, gConfig.ArqOut.Nome);
        try
          Reset(FileIn);
          Rewrite(FileOut);
          try
            while not Eof(FileIn) do
              // begin
              with gConfig do
                begin
                  try
                    axReg := LeRegIn(ArqIn); // Lê 1(um) registro do arquivo de entrada  - Read ou Readln
                  except
                    on E: Exception do
                      raise Exception.Create('Erro LeRegIn(): ' + E.Message);
                  end;

                  try
                    CarregaCamposIn(axReg, axCampos, ArqIn); // Carrega os campos registro lido
                  except
                    on E: Exception do
                      raise Exception.Create('Erro CarregaCamposIn(): ' + E.Message);
                  end;

                  try
                    axStr := MontaRegOut(axCampos, ArqOut);
                  except
                    on E: Exception do
                      // raise Exception.Create('Erro MontaRegOut(): ' + E.Message);
                      axStr := 'Erro MontaRegOut(' + IntToStr(axTStr.Count + 1) + '): ' + E.Message;
                  end;
                  axTStr.Add(axStr);
                end; // with
            // end;     // while

            with gConfig.ArqOut do
              begin
                if Ordenado = 'S' then
                  axTStr.Sort; // Ordernar
                if Cabecalho = 'S' then
                  try
                    // Escreve o Cabeçalho de campos
                    axStr := SOR;
                    for i := 0 to cMaxCampos - 1 do
                      begin
                        if Campo[i].Tam <= 0 then
                          Break;
                        if i > 0 then
                          axStr := axStr + Delimitador;
                        axStr := axStr + Campo[i].Delimitador;
                        if Fixo = 'S' then
                          axStr := axStr + InvRTrim(Campo[i].Nome, Campo[i].Tam)
                        else
                          axStr := axStr + Campo[i].Nome;
                        axStr := axStr + Campo[i].Delimitador;
                      end;
                    axStr := axStr + EOR;

                    if QuebraLinha = 'S' then
                      Writeln(FileOut, axStr)
                    else
                      Write(FileOut, axStr);

                  except
                    on E: Exception do
                      raise Exception.Create('Erro Escreve Cabeçalho: ' + E.Message);
                  end;

                try
                  // Escrever os registros
                  while axTStr.Count > 0 do
                    begin
                      axStr := SOR + axTStr.Strings[0] + EOR;
                      if QuebraLinha = 'S' then
                        Writeln(FileOut, axStr)
                      else
                        Write(FileOut, axStr);
                      axTStr.Delete(0);
                    end;
                except
                  on E: Exception do
                    raise Exception.Create('Erro escreve Registros(): ' + E.Message);
                end;

              end; // with

            // Close the file for the last time
          finally
            // FreeAndNil(axTStr);
            // FreeAndNil(axCampos);

            LiberaStringList(axTStr, True);
            LiberaStringList(axCampos, True);

            CloseFile(FileIn);
            CloseFile(FileOut);
            i := 0;
          end;
        except
          on E: Exception do
            MsgErro('Erro: ' + E.Message);
        end;
        MsgInforma('Conversão concluida!');
      finally
        FreeAndNil(axTStr);
        FreeAndNil(axCampos);
      end;
    end;

  procedure TfrmMain.FormShow(Sender: TObject);
    begin
      LoadCFG;
      Memo1.Lines.LoadFromFile(gConfig.ArqConfig); // Apenas para depuração

      // ShowMessage(ParamStr(1));
      // btn1Click(Sender);
      // Close;
    end;

  procedure TfrmMain.LoadCFG;
    begin
      // gConfig.Load;
      with gConfig do
        begin
          edtArqIn.Text := ArqIn.Nome;
          edtArqOut.Text := ArqOut.Nome;
        end;
    end;

  procedure TfrmMain.Sair1Click(Sender: TObject);
    begin
      Close;
    end;

  procedure TfrmMain.SpeedButton1Click(Sender: TObject);
    begin
      gConfig.Save;
      gConfig.Load;

      Memo1.Lines.LoadFromFile(gConfig.ArqConfig); // Apenas para depuração
    end;

  procedure TfrmMain.SpeedButton2Click(Sender: TObject);
    var
      xStr: string;

      pw:  PWideChar;
      pa:  PAnsiChar;
      sa:  AnsiString;
      sw:  WideString;
      len: Cardinal;
    begin

      with Memo2.Lines do
        begin
          Clear;
          Add(Edit1.Text);
          // add('URIDecodeQueryString:'+URIDecodeQueryString(Edit1.Text));
          Add('HTTPEncode:' + HTTPEncode(Edit1.Text));
          Add('fnstUrlEncodeUTF8:' + fnstUrlEncodeUTF8(Edit1.Text));
          Add('HTTPDecode:' + HTTPDecode(Edit1.Text));
          Add('HTTPEncode:' + HTTPEncode(Edit1.Text));

          xStr := xStr;
        end;
    end;

  procedure TfrmMain.btn2Click(Sender: TObject);
    var
      xStr: string;

    begin
      gConfig.Load;
      FormShow(Sender); // ### debug
    end;

  procedure TfrmMain.mniConfiguracaoClick(Sender: TObject);
    begin
      if frmConfig.ShowModal = mrOk then
        begin
          // ShowMessage('gConfig.Save');
          gConfig.Save;
        end;
      gConfig.Load;
      FormShow(Sender); // ### debug
    end;

  procedure TfrmMain.FormCreate(Sender: TObject);
    begin
      gConfig := tConfig.Create;
      gConfig.ArqConfig := ChangeFileExt(Application.ExeName, '.INI');
      gConfig.Load;
    end;

  procedure TfrmMain.FormDestroy(Sender: TObject);
    begin
      FreeAndNil(gConfig);
    end;

end.
