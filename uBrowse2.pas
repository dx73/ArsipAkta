unit uBrowse2;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.WebBrowser;

type
  TfBrowse2 = class(TForm)
    WebBrowser1: TWebBrowser;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    var berkas: string;
  end;

var
  fBrowse2: TfBrowse2;

implementation

{$R *.fmx}

procedure TfBrowse2.FormShow(Sender: TObject);
begin
  //showmessage(berkas);
  webbrowser1.Navigate(berkas);
end;

end.
