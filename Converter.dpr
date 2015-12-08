program Converter;

uses
  Forms,
  uMain in 'uMain.pas' {frmMain},
  uConfig in 'uConfig.pas' {frmConfig},
  ufrmArq in 'ufrmArq.pas' {frmArqCFG: TFrame},
  tools in '..\tools\tools.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TfrmConfig, frmConfig);
  Application.Run;

end.
