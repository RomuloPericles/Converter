unit ufrmArq;

interface

  uses
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
    Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids, Vcl.StdCtrls, Vcl.Buttons, Vcl.Menus;

  type
    TfrmArqCFG = class(TFrame)
      GroupBox1: TGroupBox;
      btnArq: TSpeedButton;
      edtArq: TEdit;
      strngrd: TStringGrid;
      dlgOpen: TOpenDialog;
      Label1: TLabel;
      Label2: TLabel;
      Label3: TLabel;
      Label4: TLabel;
      edtTamLinha: TEdit;
      edtSOR: TEdit;
      edtEOR: TEdit;
      chkQuebraLinha: TCheckBox;
      chkFixo: TCheckBox;
      chkOrdenado: TCheckBox;
      chkCabecalho: TCheckBox;
      lblArq: TLabel;
      edtDelimitador: TEdit;
      procedure btnArqClick(Sender: TObject);
      procedure strngrdKeyPress(Sender: TObject; var Key: Char);
      procedure strngrdMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
      procedure strngrdDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
      procedure strngrdDragDrop(Sender, Source: TObject; X, Y: Integer);
      procedure strngrdSelectCell(Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
      procedure strngrdSetEditText(Sender: TObject; ACol, ARow: Integer; const Value: string);
      procedure Adiciona1Click(Sender: TObject);
      private
        { Private declarations }
        EditingCol, EditingRow: Longint;

        OldValue: string;

      public
        { Public declarations }
        constructor Create(AOwner: TComponent); override;
        // constructor Reset;
        procedure Reset;

    end;

implementation

  {$R *.dfm}

  uses uCFG;

  var
    /// ###
    SourceCol, SourceRow: Integer;

  procedure TfrmArqCFG.Adiciona1Click(Sender: TObject);
    var
      xCol, xRow: Integer;
    begin
      // strngrd.MouseToCell(Mouse.X,Mouse.Y,xCol, xRow);
      ShowMessage(IntToStr(strngrd.Row));
    end;

  procedure TfrmArqCFG.btnArqClick(Sender: TObject);
    begin
      with dlgOpen do
        if Execute() then
          edtArq.Text := FileName;
    end;

  procedure TfrmArqCFG.Reset;
    var
      i, j: Integer;
    begin
      with strngrd do
        begin
          RowCount := cMaxCampos + 1;
          for i := 0 to RowCount - 2 do
            for j := 0 to 6 do
              Cells[j, i] := '';
          ColCount := 5;
          RowCount := 1;
          ColWidths[0] := 80;
          ColWidths[1] := 35;
          ColWidths[2] := 35;
          ColWidths[3] := 35;
          ColWidths[4] := 35;
          ColWidths[5] := 35;
          ColWidths[6] := 35;
          Cells[0, 0] := 'Campo';
          Cells[1, 0] := 'Tipo';
          Cells[2, 0] := 'Delim.';
          Cells[3, 0] := 'Pos';
          Cells[4, 0] := 'Tam';
          Cells[5, 0] := 'SF';
          Cells[6, 0] := 'EF';
        end;
    end;

  constructor TfrmArqCFG.Create(AOwner: TComponent);

    begin
      inherited;
      Reset;
    end;

  procedure TfrmArqCFG.strngrdDragDrop(Sender, Source: TObject; X, Y: Integer);
    var
      DestCol, DestRow: Integer;
    begin
      // strngrd.MouseToCell(X, Y, DestCol, DestRow); // convert mouse coord.
      // { Move contents from source to destination }
      // strngrd.Cells[DestCol, DestRow] := strngrd.Cells[SourceCol, SourceRow];
      // if (SourceCol <> DestCol) or (SourceRow <> DestRow) then
      // strngrd.Cells[SourceCol, SourceRow] := '';
    end;

  procedure TfrmArqCFG.strngrdDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
    var
      CurrentCol, CurrentRow: Integer;
    begin
      // strngrd.MouseToCell(X, Y, CurrentCol, CurrentRow); // convert mouse coord.
      // { Accept dragged stuff only if it came from StringGrid
      // and the mouse is now over an acceptable region }
      // // Accept := (Sender = Source) and (CurrentCol > 0) and (CurrentRow > 0);
      // Accept := (Sender = Source) and (CurrentRow > 0);
    end;

  procedure TfrmArqCFG.strngrdKeyPress(Sender: TObject; var Key: Char);
    var
      i, j: Integer;
    begin
      with strngrd do
        try
          if (Row = 0) then
            Exit;

          if Key = '+' then // sinal de mais "+"
            begin
              if (RowCount <= cMaxCampos) then
                begin
                  RowCount := RowCount + 1;
                  for i := RowCount - 1 downto Row + 1 do
                    for j := 0 to 6 do
                      Cells[j, i] := Cells[j, i - 1];

                  Cells[0, Row] := 'CAMPO' + IntToStr(RowCount); // Nome Campo
                  Cells[1, Row] := 'T';                          // Tipo
                  Cells[2, Row] := '"';                          // Delimitador campo/coluna
                  Cells[3, Row] := '0';                          // posição
                  Cells[4, Row] := '0';                          // tamanho
                  Cells[5, Row] := '';                           // SF
                  Cells[6, Row] := '';                           // EF
                end;
            end;

          if Key = '-' then // sinal de menos "-"
            begin
              if RowCount = 2 then
                ShowMessage('É necessário ao menos um campo no registro!');
              if RowCount > 2 then
                begin
                  for i := Row to RowCount - 2 do
                    for j := 0 to 6 do
                      Cells[j, i] := Cells[j, i + 1];
                  RowCount := RowCount - 1;
                  // if RowCount - 2 <= Row then
                  // Row := Row - 1;
                end;

            end;

        finally
          if (Key in ['+', '-']) or (Row = 0) then
            Key := #0;
        end;

      // if not(Key in ['1' .. '9']) and not(Key in ['A' .. 'Z']) and not(Key in ['a' .. 'z']) then
      // ShowMessage(') ' + IntToStr(Integer(Key)) + ' (');
    end;

  procedure TfrmArqCFG.strngrdMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    begin
      // { Convert mouse coordinates X, Y to
      // to StringGrid related col and row numbers }
      // strngrd.MouseToCell(X, Y, SourceCol, SourceRow);
      // { Allow dragging only if an acceptable cell was clicked
      // (cell beyond the fixed column and row) }
      // // if (SourceCol > 0) and (SourceRow > 0) then
      // if (SourceRow > 0) then
      // { Begin dragging after mouse has moved 4 pixels }
      // strngrd.BeginDrag(False, 4);
    end;

  procedure TfrmArqCFG.strngrdSelectCell(Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
    begin
      with TStringGrid(Sender) do
        begin
          // This will make Row 0 NONE editable.
          if ARow = 0 then
            Options := Options - [goEditing]
          else
            begin
              Options := Options + [goEditing];
              OldValue := Cells[ACol, ARow];
            end;
        end;
    end;

  procedure TfrmArqCFG.strngrdSetEditText(Sender: TObject; ACol, ARow: Integer; const Value: string);
    var
      X: Integer;
    begin
      if (ACol <> EditingCol) and (ARow <> EditingRow) then
        begin
          // TestCell(Sender, EditingCol, EditingRow, Value);
          // DoYourAfterEditingStuff(EditingCol, EditingRow);
          try
            X := StrToInt(Value);
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

end.
