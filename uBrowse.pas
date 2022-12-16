unit uBrowse;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Memo.Types,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.ListView, FMX.ScrollBox, FMX.Memo, FMX.DateTimeCtrls, FMX.StdCtrls,
  FMX.Edit, FMX.Controls.Presentation, FMX.Objects, FMX.Layouts, FMX.WebBrowser;

type
  TfBrowse = class(TForm)
    Rectangle1: TRectangle;
    Rectangle2: TRectangle;
    Layout1: TLayout;
    Circle1: TCircle;
    Image8: TImage;
    WebBrowser1: TWebBrowser;
    Edit1: TEdit;
    Button1: TButton;
    Button2: TButton;
    procedure Circle1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    var berkas: string;
  end;

var
  fBrowse: TfBrowse;

implementation

{$R *.fmx}

Uses uHome,Loading,ToastMessage;

procedure TfBrowse.Button1Click(Sender: TObject);
begin
  webbrowser1.Navigate('file://'+edit1.Text);
end;

procedure TfBrowse.Button2Click(Sender: TObject);
begin
  webbrowser1.Navigate('www.google.com');
end;

procedure TfBrowse.Circle1Click(Sender: TObject);
begin
  close;
end;

procedure TfBrowse.FormShow(Sender: TObject);
begin
  //webbrowser1.URL:=berkas;
  edit1.Text:=berkas;
end;

end.
