object frmMain: TfrmMain
  Left = 192
  Top = 125
  Caption = 'frmMain'
  ClientHeight = 524
  ClientWidth = 963
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  Menu = MainMenu1
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object btnConverter: TSpeedButton
    Left = 53
    Top = 151
    Width = 81
    Height = 25
    Caption = '&Converter'
    OnClick = btnConverterClick
  end
  object btn2: TSpeedButton
    Left = 320
    Top = 20
    Width = 81
    Height = 22
    Caption = '&Load'
    OnClick = btn2Click
  end
  object SpeedButton1: TSpeedButton
    Left = 407
    Top = 20
    Width = 97
    Height = 22
    Caption = '&Save'
    OnClick = SpeedButton1Click
  end
  object SpeedButton2: TSpeedButton
    Left = 91
    Top = 440
    Width = 23
    Height = 22
    OnClick = SpeedButton2Click
  end
  object btnReverter: TSpeedButton
    Left = 150
    Top = 151
    Width = 81
    Height = 25
    Caption = '&Reverter'
  end
  object Memo1: TMemo
    Left = 528
    Top = 24
    Width = 353
    Height = 465
    ScrollBars = ssBoth
    TabOrder = 0
  end
  object ListBox1: TListBox
    Left = 368
    Top = 48
    Width = 121
    Height = 97
    ItemHeight = 13
    TabOrder = 1
  end
  object Edit1: TEdit
    Left = 51
    Top = 400
    Width = 121
    Height = 21
    TabOrder = 2
    Text = '&13;&10;'
  end
  object Memo2: TMemo
    Left = 178
    Top = 328
    Width = 344
    Height = 137
    ScrollBars = ssBoth
    TabOrder = 3
  end
  object edtArqIn: TEdit
    Left = 51
    Top = 48
    Width = 246
    Height = 21
    TabOrder = 4
    Text = 'edtArqIn'
  end
  object edtArqOut: TEdit
    Left = 51
    Top = 75
    Width = 246
    Height = 21
    TabOrder = 5
    Text = 'edtArqOut'
  end
  object MainMenu1: TMainMenu
    Left = 8
    Top = 8
    object mniArquivo: TMenuItem
      Caption = '&Arquivo'
      object Sair1: TMenuItem
        Caption = 'Sai&r'
        OnClick = Sair1Click
      end
    end
    object mniConfiguracao: TMenuItem
      Caption = '&Configura'#231#227'o'
      OnClick = mniConfiguracaoClick
    end
    object mniAjuda: TMenuItem
      Caption = 'Aj&uda'
      object mniSobre: TMenuItem
        Caption = '&Sobre'
      end
    end
  end
end
