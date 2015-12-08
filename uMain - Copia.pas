unit uMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons,IniFiles, StdCtrls, uFuncoes
  //,IdURI
  , HTTPApp//, UURIEncode
;

type
  TForm1 = class(TForm)
    btn1: TSpeedButton;
    Memo1: TMemo;
    ListBox1: TListBox;
    btn2: TSpeedButton;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    Edit1: TEdit;
    Memo2: TMemo;
    procedure btn1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btn2Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  tCampo = class (TObject)
    NomeCampo: string;
    PosCampo: integer;
    TamCampo: integer;
  end;

  tArquivo = class (TObject)
    Nome: string;
    Delimitador: string;
    TamLinha:integer;
    EOL: string;
    Campo: array[1 .. 16] of tCampo;
//    NomeCampo: array[1 .. 16] of string;
//    PosCampo: array[1 .. 16] of integer;
//    TamCampo: array[1 .. 16] of integer;
  end;

  TConfig = class (TObject)
    ArqConfig: string;
    ArqIn: tArquivo;
    ArqOut: tArquivo;
    //FNameOut: string;
    Comm : integer;
//    TamLinha:integer;
//    PosCampo: array[1 .. 16] of integer;
//    TamCampo: array[1 .. 16] of integer;
    Mask: string;
  private
    procedure LoadArq(_Arq: tArquivo;_InOut: String; _Ini: TIniFile);
  public
    procedure Load;
    constructor Create; overload;   // This constructor uses defaults
    destructor Destroy; overload;
  end;

var
  Form1: TForm1;
  gConfig: tConfig;

implementation

// Create a fruit object - parameterless version
constructor TConfig.Create;
begin
  // Execute the parent (TObject) constructor first
  inherited;  // Call the parent Create method
  self.ArqIn := tArquivo.Create;
  self.ArqOut := tArquivo.Create;
end;

destructor TConfig.Destroy;
begin
  inherited;
  FreeAndNil(self.ArqIn);
  FreeAndNil(self.ArqOut);
end;

procedure TConfig.Load;
  var
    x: Integer;
    xStr: String;
    Ini : TIniFile;
    i: Integer;
begin
  gConfig.ArqConfig :=  ChangeFileExt( Application.ExeName, '.INI' );
  Form1.Memo1.Lines.LoadFromFile(gConfig.ArqConfig);

  Ini := TIniFile.Create(gConfig.ArqConfig);

  Ini.ReadSection('Exporta',Form1.ListBox1.Items);

  with self do
  begin
    LoadArq(ArqIn, 'IN',Ini);
    LoadArq(ArqOut ,'OUT',Ini);
    Comm := Ini.ReadInteger('Exporta','Comm',1);
    Mask := Ini.ReadString('Exporta','Mascara','');
  end;

end;



{$R *.dfm}

procedure TForm1.btn1Click(Sender: TObject);
  var
    FileIn: TextFile;
    axStr,  axStr2 : string;
    axChar : Char;
    j, i:integer;
    axTStr : TStringList;
begin
  axTStr := TStringList.Create;
  try

    axTStr.Clear;

    i := 0;
    axStr := '';
    // Try to open the Test.txt file for writing to
    AssignFile(FileIn, gConfig.ArqIn.Nome);
    try
      Reset(FileIn);
      try
        while not Eof(FileIn) do
        begin
          Read(Filein,axChar);
          Inc(i);
          axStr := axStr + axChar;

          with gConfig do
          begin
            if (i = ArqIn.TamLinha) then
            begin

              axStr2 := Copy(axStr,ArqOut.PosCampo[1],ArqOut.TamCampo[1]);
              for j := 2 to 16 do
              begin
                if ArqOut.TamCampo[j] > 0 then
                  axStr2 := axStr2 + ArqOut.Delimitador + Copy(axStr,ArqOut.PosCampo[j],ArqOut.TamCampo[j]);
              end;
              axTStr.Add(axStr2);
              i := 0;
              axStr := '';
            end;
          end;
        end;
  //      axTStr.Add(axStr);
        axTStr.Sort;
        axTStr.SaveToFile(gConfig.ArqOut.Nome);
      // Close the file for the last time
      finally
        FreeAndNil(axTStr);
        CloseFile(Filein);
      end;
    except
       on E: Exception do
         ShowMessage(E.Message);
    end;
  finally
    FreeAndNil(axTStr);
  end;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
//ShowMessage(ParamStr(1));
//btn1Click(Sender);
//Close;
end;

procedure TForm1.SpeedButton1Click(Sender: TObject);
begin
  Memo1.Lines.SaveToFile(gConfig.ArqConfig);
  gConfig.Load;
end;

procedure TForm1.SpeedButton2Click(Sender: TObject);
var xStr: string;

   pw: PWideChar;
   pa: PAnsiChar;
   sa: AnsiString;
   sw: WideString;
   len: Cardinal;
begin



  with Memo2.Lines do
  begin
    Clear;
    Add(Edit1.Text);
//    add('URIDecodeQueryString:'+URIDecodeQueryString(Edit1.Text));
    Add('HTTPEncode:'+HTTPEncode(Edit1.Text));
    Add('fnstUrlEncodeUTF8:'+fnstUrlEncodeUTF8(Edit1.Text));
    Add('HTTPDecode:'+HTTPDecode(Edit1.Text));
    Add('HTTPEncode:'+HTTPEncode(Edit1.Text));

    xStr := xStr;
  end;
end;

procedure TForm1.btn2Click(Sender: TObject);
begin
  gConfig.Load;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  gConfig := TConfig.Create;
  gConfig.Load;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  //vConfig.Destroy;
  FreeAndNil(gConfig);
end;

{ tArquivo }

procedure TConfig.LoadArq(_Arq: tArquivo;_InOut: String; _Ini: TIniFile);
var
  i: integer;
  xStr: string;
begin

  try
    _InOut := UpperCase(_InOut);

    with _Arq, _Ini do
    begin
      Nome        := ReadString(_InOut,'Arquivo',_InOut + '.TXT');
      Delimitador := ReadString(_InOut,'Delimitador',';');
      EOL         := HTTPDecode(ReadString(_InOut,'EOL','%0D%0A')); // Como HTML
      TamLinha    := ReadInteger(_InOut,'TamLinha',20);

      for i := 1 to 16 do
      begin
        xStr := ReadString(_InOut,'Campo'+IntToStr(i),'Campo'+IntToStr(i)+': 0, 0');
        NomeCampo[i] := Copy(xStr, 1, Pos(':',xStr) - 1);
        PosCampo[i] := StrToInt(Copy(xStr, Pos(':',xStr) + 1,Pos(',',xStr) - Pos(':',xStr) - 1));
        TamCampo[i] := StrToInt(Copy(xStr, Pos(',',xStr) + 1,Length(xStr) - Pos(',',xStr)));
        if PosCampo[i] > 0 then
          WriteString(_InOut,'Campo'+IntToStr(i),xStr);
      end;

      WriteString(_InOut,'Arquivo',Nome);
      WriteString(_InOut,'Delimitador',Delimitador);
      WriteString(_InOut,'EOL',HTTPEncode(EOL));
      WriteInteger(_InOut,'TamLinha',TamLinha);
    end;
  finally
    //FreeAndNil(xArq);
    ;
  end;
end;
end.
