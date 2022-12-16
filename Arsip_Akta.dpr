program Arsip_Akta;

uses
  System.StartUpCopy,
  FMX.Forms,
  uHome in 'uHome.pas' {fHome},
  Loading in 'Loading.pas',
  ToastMessage in 'ToastMessage.pas',
  uSetting in 'uSetting.pas' {fSetting},
  uInput in 'uInput.pas' {fInput},
  uKelompok in 'uKelompok.pas' {fKelompok},
  uBrowse in 'uBrowse.pas' {fBrowse},
  uBrowse2 in 'uBrowse2.pas' {fBrowse2},
  uCari in 'uCari.pas' {fCari},
  uCetak in 'uCetak.pas' {fCetak};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfHome, fHome);
  //Application.CreateForm(TfCetak, fCetak);
  //Application.CreateForm(TfCari, fCari);
  //Application.CreateForm(TfBrowse2, fBrowse2);
  //Application.CreateForm(TfBrowse, fBrowse);
  //Application.CreateForm(TfKelompok, fKelompok);
  //Application.CreateForm(TfSetting, fSetting);
  //Application.CreateForm(TfInput, fInput);
  Application.Run;
end.
