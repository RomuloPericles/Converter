unit uConfig;

interface

  uses
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
    Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Grids,
    uMain, Vcl.Buttons, Vcl.Menus, Vcl.ExtCtrls, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
    FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet,
    FireDAC.Comp.Client, Vcl.DBGrids, UCFG, ufrmArq;

  const
    cCampo: array [0 .. 2] of string = ('Nome', 'Pos', 'Tam');

  type
    TfrmConfig = class(TForm)
      Panel2: TPanel;
      btnOk: TBitBtn;
      btnCancel: TBitBtn;
      Panel1: TPanel;
    frmArqIn: TfrmArqCFG;
    frmArqOut: TfrmArqCFG;
    Panel3: TPanel;
    strngrd: TStringGrid;
      procedure FormShow(Sender: TObject);
      // procedure BitBtn1Click(Sender: TObject);
      // procedure BitBtn2Click(Sender: TObject);
      procedure AdicionaCampos1Click(Sender: TObject);
      procedure btnOkClick(Sender: TObject);
      procedure btnCancelClick(Sender: TObject);
      procedure strngrdInEnter(Sender: TObject);
      procedure strngrdInSetEditText(Sender: TObject; ACol, ARow: Integer; const Value: string);
      procedure strngrdInExit(Sender: TObject);
      procedure strngrdInFixedCellClick(Sender: TObject; ACol, ARow: Integer);
      procedure strngrdInSelectCell(Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
      // procedure strngrdInKeyPress(Sender: TObject; var Key: Char);
      procedure btnOutClick(Sender: TObject);
      procedure frmArqInbtnArqClick(Sender: TObject);
      procedure FormClose(Sender: TObject; var Action: TCloseAction);
      private
        EditingCol, EditingRow: Longint;
        OldValue:               string;
        procedure TestCell(Sender: TObject; ACol, ARow: Integer; const Value: string); { Private declarations }
      public
        { Public declarations }
    end;

  var
    frmConfig: TfrmConfig;

implementation

  {$R *.dfm}

  uses tools;

  procedure TfrmConfig.AdicionaCampos1Click(Sender: TObject);
    begin
      // if TPopupMenu(TMenuItem(Sender).GetParentMenu).PopupComponent is TStringGrid then
      // ShowMessage(TPopupMenu(TMenuItem(Sender).GetParentMenu).PopupComponent.Name);
      with TStringGrid(TPopupMenu(TMenuItem(Sender).GetParentMenu).PopupComponent) do
        RowCount := RowCount + 1;

      // showmessage(ppGrid.GetParentComponent.p);
    end;

  procedure TfrmConfig.btnCancelClick(Sender: TObject);
    begin
      ModalResult := mrCancel;
    end;

  procedure TfrmConfig.btnOkClick(Sender: TObject);
    // var
    // i, j: Integer;

    // procedure Arq_FrmToCFG(_cfgArq: tArquivo; _frm: TfrmArqCFG);
    // var
    // i, j: Integer;
    // begin
    //
    // with _cfgArq, _frm do
    // begin
    // Nome := edtArq.Text;
    //
    // for i := 0 to cMaxCampos - 1 do
    // Campo[i].Reset;
    // with strngrd do
    // begin
    // for i := 1 to RowCount - 1 do
    // begin
    // Campo[i - 1].Nome        := Cells[0, i];
    // Campo[i - 1].Tipo        := Cells[1, i];
    // Campo[i - 1].Delimitador := Cells[2, i];
    // Campo[i - 1].Pos         := StrToInt(Cells[3, i]);
    // Campo[i - 1].Tam         := StrToInt(Cells[4, i]);
    // end;
    // end;
    // end; // with
    //
    // end;

    begin
      // Arq_FrmToCFG(gConfig.ArqIn, frmArqIn);
      //
      // Arq_FrmToCFG(gConfig.ArqOut, frmArqOut);

      ModalResult := mrOk;
    end;

  procedure TfrmConfig.btnOutClick(Sender: TObject);
    begin
      with frmArqOut.dlgOpen do
        if Execute() then
          begin
            gConfig.ArqOut.Nome   := FileName;
            frmArqOut.edtArq.Text := FileName;
          end;
    end;

  procedure TfrmConfig.FormClose(Sender: TObject; var Action: TCloseAction);

      procedure Arq_FrametoCFG(_cfgArq: tArquivo; _frm: TfrmArqCFG);

          procedure Arq_StrngrdToCFG(_cfgArq: tArquivo; _frm: TfrmArqCFG);
            var
              i, j: Integer;
            begin
              with _cfgArq, _frm do
                begin
                  for i := 0 to cMaxCampos - 1 do
                    Campo[i].Reset;
                  with strngrd do
                    begin
                      for i := 1 to RowCount - 1 do
                        begin
                          Campo[i - 1].Nome        := Cells[0, i];
                          Campo[i - 1].Tipo        := Cells[1, i];
                          Campo[i - 1].Delimitador := Cells[2, i];
                          Campo[i - 1].Pos         := StrToInt(Cells[3, i]);
                          Campo[i - 1].Tam         := StrToInt(Cells[4, i]);
                        end;
                    end;
                end; // with
            end;

          function VF(_bool: Boolean): string;
            begin
              if _bool then
                result := 'S'
              else
                result := 'N';
            end;

        var
          xStr: string;
        begin

          with _frm, _cfgArq do
            begin
              Nome := edtArq.Text;

              TamLinha    := StrToInt(edtTamLinha.Text);
              Delimitador := edtDelimitador.Text;
              SOR         := edtSOR.Text;
              EOR         := edtEOR.Text;
              QuebraLinha := VF(chkQuebraLinha.Checked);
              Fixo        := VF(chkFixo.Checked);
              Ordenado    := VF(chkOrdenado.Checked);
              Cabecalho   := VF(chkCabecalho.Checked);
            end;

          // Buscar string grid
          Arq_StrngrdToCFG(_cfgArq, _frm);

        end;

    begin
      if ModalResult = mrOk then
        begin
          // Arq_FrmToCFG(gConfig.ArqIn, frmArqIn);

          Arq_FrametoCFG(gConfig.ArqIn, frmArqIn);

          // Arq_FrmToCFG(gConfig.ArqOut, frmArqOut);

          Arq_FrametoCFG(gConfig.ArqOut, frmArqOut);

        end;
    end;

  procedure TfrmConfig.FormShow(Sender: TObject);
    var
      i: Integer;

      procedure Arq_CFGtoStrngrd(_cfgArq: tArquivo; _StnG: TStringGrid);
        var
          i: Integer;
        begin
          with _cfgArq, _StnG do
            begin
              for i := 0 to cMaxCampos - 1 do
                begin
                  if Campo[i].Tam <= 0 then
                    break;
                  Cells[0, RowCount] := Campo[i].Nome;
                  Cells[1, RowCount] := Campo[i].Tipo;
                  Cells[2, RowCount] := Campo[i].Delimitador;
                  Cells[3, RowCount] := IntToStr(Campo[i].Pos);
                  Cells[4, RowCount] := IntToStr(Campo[i].Tam);
                  RowCount           := RowCount + 1;
                end;
            end;
        end;

      procedure Arq_CFGtoFrame(_cfgArq: tArquivo; _frm: TfrmArqCFG);
        var
          xStr: string;
        begin

          with _frm, _cfgArq do
            begin
              Reset;

              edtArq.Text := _cfgArq.Nome;

              edtTamLinha.Text       := IntToStr(TamLinha);
              edtDelimitador.Text    := Delimitador;
              edtSOR.Text            := SOR;
              edtEOR.Text            := EOR;
              chkQuebraLinha.Checked := (QuebraLinha = 'S');
              chkFixo.Checked        := (Fixo = 'S');
              chkOrdenado.Checked    := (Ordenado = 'S');
              chkCabecalho.Checked   := (Cabecalho = 'S');
            end;

          // Popular string grid
          Arq_CFGtoStrngrd(_cfgArq, _frm.strngrd);

        end;

    begin
      frmArqIn.GroupBox1.Caption := ' Arqivo de entrada ';
      Arq_CFGtoFrame(gConfig.ArqIn, frmArqIn);

      frmArqOut.GroupBox1.Caption := ' Arqivo de Saida ';
      Arq_CFGtoFrame(gConfig.ArqOut, frmArqOut);

    end;

  procedure TfrmConfig.frmArqInbtnArqClick(Sender: TObject);
    begin
      frmArqIn.btnArqClick(Sender);

    end;

  procedure TfrmConfig.strngrdInEnter(Sender: TObject);
    begin
      // ShowMessage(
      // TStringGrid(TPopupMenu(TMenuItem(Sender).GetParentMenu).PopupComponent).Name  );
      // 9TDrawGrid.ClassName
      OldValue   := '';
      EditingCol := -1;
      EditingRow := -1;

    end;

  procedure TfrmConfig.strngrdInExit(Sender: TObject);
    begin
      try
        TestCell(Sender, EditingCol, EditingRow, OldValue);

      except
        on E: Exception do
          Exit;
      end;
      // Not really necessary because of the OnEnter handler, but keeps the code
      // nicely symmetric with the OnSetEditText handler (so you can easily
      // refactor it out if the desire strikes you)
      OldValue   := '';
      EditingCol := -1;
      EditingRow := -1;
    end;

  procedure TfrmConfig.strngrdInFixedCellClick(Sender: TObject; ACol, ARow: Integer);
    begin;
    end;

  // procedure TfrmConfig.strngrdInKeyPress(Sender: TObject; var Key: Char);
  // begin
  // if not(Key in ['+', '-']) then
  // Exit;
  //
  // with TStringGrid(Sender) do
  // begin
  // if Key = '+' then
  // begin
  // if RowCount < cMaxCampos then
  // begin
  // RowCount           := RowCount + 1;
  // Cells[0, RowCount] := 'Campo';
  // Cells[1, RowCount] := 'T';
  // Cells[2, RowCount] := '"';
  // Cells[3, RowCount] := '0';
  // Cells[4, RowCount] := '0';
  // end;
  // end;
  // if Key = '-' then
  // begin
  // if RowCount > 1 then
  // begin
  // RowCount := RowCount - 1;
  // end;
  // end;
  // Key := #0;
  // end;
  //
  // end;

  procedure TfrmConfig.strngrdInSelectCell(Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
    begin
      with TStringGrid(Sender) do
        begin
          // This will make Row 0 NONE editable.
          if ARow = 0 then
            Options := Options - [goEditing]
          else
            begin
              Options  := Options + [goEditing];
              OldValue := Cells[ACol, ARow];
            end;
        end;
    end;

  procedure TfrmConfig.strngrdInSetEditText(Sender: TObject; ACol, ARow: Integer; const Value: string);
    var
      x: Integer;
    begin
      if (ACol <> EditingCol) and (ARow <> EditingRow) then
        begin
          // TestCell(Sender, EditingCol, EditingRow, Value);
          // DoYourAfterEditingStuff(EditingCol, EditingRow);
          try
            x        := StrToInt(Value);
            OldValue := Value;
          except
            on E: Exception do
              begin
                OldValue := '';
                Exit;
              end;

          end;
          EditingCol := ACol;
          EditingRow := ARow;
        end;
    end;

  procedure TfrmConfig.TestCell(Sender: TObject; ACol, ARow: Integer; const Value: string);
    var
      x: Integer;
    begin
      if ACol > 0 then
        begin
          x := StrToInt(Value);
        end;

    end;

end.
