object frmConfig: TfrmConfig
  Left = 0
  Top = 0
  Caption = 'Configura'#231#227'o'
  ClientHeight = 710
  ClientWidth = 770
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel2: TPanel
    Left = 0
    Top = 669
    Width = 770
    Height = 41
    Align = alBottom
    TabOrder = 0
    ExplicitTop = 502
    ExplicitWidth = 1121
    object btnOk: TBitBtn
      Left = 65
      Top = 4
      Width = 75
      Height = 25
      Caption = 'Ok'
      Glyph.Data = {
        DE010000424DDE01000000000000760000002800000024000000120000000100
        0400000000006801000000000000000000001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        3333333333333333333333330000333333333333333333333333F33333333333
        00003333344333333333333333388F3333333333000033334224333333333333
        338338F3333333330000333422224333333333333833338F3333333300003342
        222224333333333383333338F3333333000034222A22224333333338F338F333
        8F33333300003222A3A2224333333338F3838F338F33333300003A2A333A2224
        33333338F83338F338F33333000033A33333A222433333338333338F338F3333
        0000333333333A222433333333333338F338F33300003333333333A222433333
        333333338F338F33000033333333333A222433333333333338F338F300003333
        33333333A222433333333333338F338F00003333333333333A22433333333333
        3338F38F000033333333333333A223333333333333338F830000333333333333
        333A333333333333333338330000333333333333333333333333333333333333
        0000}
      NumGlyphs = 2
      TabOrder = 0
      OnClick = btnOkClick
    end
    object btnCancel: TBitBtn
      Left = 169
      Top = 6
      Width = 75
      Height = 25
      Caption = 'Cancela'
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000130B0000130B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        3333333333FFFFF3333333333999993333333333F77777FFF333333999999999
        3333333777333777FF3333993333339993333377FF3333377FF3399993333339
        993337777FF3333377F3393999333333993337F777FF333337FF993399933333
        399377F3777FF333377F993339993333399377F33777FF33377F993333999333
        399377F333777FF3377F993333399933399377F3333777FF377F993333339993
        399377FF3333777FF7733993333339993933373FF3333777F7F3399933333399
        99333773FF3333777733339993333339933333773FFFFFF77333333999999999
        3333333777333777333333333999993333333333377777333333}
      NumGlyphs = 2
      TabOrder = 1
      OnClick = btnCancelClick
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 770
    Height = 465
    Align = alTop
    TabOrder = 1
    inline frmArqIn: TfrmArqCFG
      Left = 1
      Top = 1
      Width = 768
      Height = 234
      Align = alTop
      TabOrder = 0
      ExplicitWidth = 1121
      inherited GroupBox1: TGroupBox
        Width = 768
        ExplicitTop = 0
        ExplicitWidth = 1121
        ExplicitHeight = 234
      end
    end
    inline frmArqOut: TfrmArqCFG
      Left = 1
      Top = 230
      Width = 768
      Height = 234
      Align = alBottom
      TabOrder = 1
      ExplicitTop = 268
      ExplicitWidth = 1121
      inherited GroupBox1: TGroupBox
        Width = 768
        ExplicitTop = 0
        ExplicitWidth = 1121
        ExplicitHeight = 234
      end
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 465
    Width = 770
    Height = 204
    Align = alClient
    TabOrder = 2
    ExplicitTop = 464
    object strngrd: TStringGrid
      Left = 204
      Top = 8
      Width = 389
      Height = 186
      FixedCols = 0
      RowCount = 2
      FixedRows = 0
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing, goAlwaysShowEditor]
      ScrollBars = ssVertical
      TabOrder = 0
      ColWidths = (
        39
        64
        64
        64
        64)
    end
  end
end
