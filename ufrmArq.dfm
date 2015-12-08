object frmArqCFG: TfrmArqCFG
  Left = 0
  Top = 0
  Width = 717
  Height = 234
  TabOrder = 0
  object GroupBox1: TGroupBox
    Left = 0
    Top = 0
    Width = 717
    Height = 234
    Align = alClient
    Caption = ' Arquivo '
    TabOrder = 0
    object btnArq: TSpeedButton
      Left = 467
      Top = 12
      Width = 23
      Height = 22
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000120B0000120B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        333333FFFFFFFFFFFFF33000077777770033377777777777773F000007888888
        00037F3337F3FF37F37F00000780088800037F3337F77F37F37F000007800888
        00037F3337F77FF7F37F00000788888800037F3337777777337F000000000000
        00037F3FFFFFFFFFFF7F00000000000000037F77777777777F7F000FFFFFFFFF
        00037F7F333333337F7F000FFFFFFFFF00037F7F333333337F7F000FFFFFFFFF
        00037F7F333333337F7F000FFFFFFFFF00037F7F333333337F7F000FFFFFFFFF
        00037F7F333333337F7F000FFFFFFFFF07037F7F33333333777F000FFFFFFFFF
        0003737FFFFFFFFF7F7330099999999900333777777777777733}
      NumGlyphs = 2
      OnClick = btnArqClick
    end
    object Label1: TLabel
      Left = 68
      Top = 42
      Width = 69
      Height = 13
      Caption = 'Tamanho linha'
    end
    object Label2: TLabel
      Left = 68
      Top = 68
      Width = 53
      Height = 13
      Caption = 'Delimitador'
    end
    object Label3: TLabel
      Left = 68
      Top = 92
      Width = 21
      Height = 13
      Caption = 'SOR'
    end
    object Label4: TLabel
      Left = 70
      Top = 117
      Width = 21
      Height = 13
      Caption = 'EOR'
    end
    object lblArq: TLabel
      Left = 68
      Top = 17
      Width = 37
      Height = 13
      Caption = 'Arquivo'
    end
    object edtArq: TEdit
      Left = 150
      Top = 13
      Width = 295
      Height = 21
      TabOrder = 0
    end
    object strngrd: TStringGrid
      Left = 305
      Top = 37
      Width = 389
      Height = 186
      FixedCols = 0
      RowCount = 2
      FixedRows = 0
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing, goAlwaysShowEditor]
      ScrollBars = ssVertical
      TabOrder = 2
      OnDragDrop = strngrdDragDrop
      OnDragOver = strngrdDragOver
      OnKeyPress = strngrdKeyPress
      OnMouseDown = strngrdMouseDown
      OnSelectCell = strngrdSelectCell
      OnSetEditText = strngrdSetEditText
      ColWidths = (
        39
        64
        64
        64
        64)
    end
    object edtTamLinha: TEdit
      Left = 150
      Top = 38
      Width = 121
      Height = 21
      TabOrder = 1
    end
    object edtSOR: TEdit
      Left = 150
      Top = 88
      Width = 121
      Height = 21
      Hint = 'SOR - Start Of Register'#13#10'Inicio do registro/linha'
      TabOrder = 4
    end
    object edtEOR: TEdit
      Left = 150
      Top = 113
      Width = 121
      Height = 21
      Hint = 'EOR - End Of Register'#13#10'Fim do registro/linha'
      TabOrder = 5
    end
    object chkQuebraLinha: TCheckBox
      Left = 150
      Top = 138
      Width = 97
      Height = 17
      Caption = 'Quebra linha'
      TabOrder = 6
    end
    object chkFixo: TCheckBox
      Left = 150
      Top = 159
      Width = 97
      Height = 17
      Caption = 'Fixo'
      TabOrder = 7
    end
    object chkOrdenado: TCheckBox
      Left = 150
      Top = 179
      Width = 97
      Height = 17
      Caption = 'Ordenado'
      TabOrder = 8
    end
    object chkCabecalho: TCheckBox
      Left = 150
      Top = 201
      Width = 97
      Height = 17
      Caption = 'Cabecalho'
      TabOrder = 9
    end
    object edtDelimitador: TEdit
      Left = 150
      Top = 64
      Width = 121
      Height = 21
      TabOrder = 3
    end
  end
  object dlgOpen: TOpenDialog
    Left = 495
    Top = 11
  end
end
