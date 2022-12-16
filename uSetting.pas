unit uSetting;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, FMX.Layouts, System.ImageList, FMX.ImgList, FMX.StdCtrls,
  FMX.Edit, FMX.Controls.Presentation, FMX.TabControl;

type
  TfSetting = class(TForm)
    Rectangle1: TRectangle;
    Rectangle2: TRectangle;
    Circle1: TCircle;
    Image8: TImage;
    Layout1: TLayout;
    fdQ: TFDQuery;
    Label1: TLabel;
    ebServer: TEdit;
    ebPort: TEdit;
    Label2: TLabel;
    ebUsername: TEdit;
    Label3: TLabel;
    ebPassword: TEdit;
    Label4: TLabel;
    CornerButton1: TCornerButton;
    ImageList1: TImageList;
    StyleBook1: TStyleBook;
    ebDB: TEdit;
    Label5: TLabel;
    ebLoc: TEdit;
    Label6: TLabel;
    TabControl1: TTabControl;
    TabItem1: TTabItem;
    TabItem2: TTabItem;
    bKoneksi: TCornerButton;
    bNama: TCornerButton;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    ebPangkat: TEdit;
    ebNIP: TEdit;
    ebNama: TEdit;
    ebJabatan: TEdit;
    CornerButton2: TCornerButton;
    fdQ1: TFDQuery;
    procedure Circle1Click(Sender: TObject);
    procedure CornerButton1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure CornerButton2Click(Sender: TObject);
    procedure CornerButton3Click(Sender: TObject);
    procedure bKoneksiClick(Sender: TObject);
    procedure bNamaClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fSetting: TfSetting;
  idK,idN: integer;

implementation

{$R *.fmx}

Uses uHome,Loading,ToastMessage;

procedure TfSetting.bKoneksiClick(Sender: TObject);
begin
  tabcontrol1.ActiveTab:=TabItem1;

  bKoneksi.StyleLookup:='CornerButton3Style1';
  bNama.StyleLookup:='CornerButton2Style1';
end;

procedure TfSetting.bNamaClick(Sender: TObject);
begin
  tabcontrol1.ActiveTab:=TabItem2;

  bKoneksi.StyleLookup:='CornerButton2Style1';
  bNama.StyleLookup:='CornerButton3Style1';
end;

procedure TfSetting.Circle1Click(Sender: TObject);
begin
  close;
end;

procedure TfSetting.CornerButton1Click(Sender: TObject);
begin
  TLoading.Show(fSetting, '');

  TThread.CreateAnonymousThread(procedure
  begin
    sleep(100);

    TThread.Synchronize(nil, procedure
    begin
      TLoading.Hide;

      fdQ.Open;
      fdQ.Edit;
      fdQ['server']:=ebServer.Text;
      fdQ['port']:=ebPort.Text;
      fdQ['username']:=ebUsername.Text;
      fdQ['password']:=ebPassword.Text;
      fdQ['database']:=ebDB.Text;
      fdQ['loc']:=ebLoc.Text;
      fdQ.Post;

      {fdQ.SQL.Clear;
      fdQ.SQL.Text:='UPDATE cek server = :vServer,port = :vPort, '+
      'username = :vUser,password = :vPass,database = :vDB,loc = :vLoc WHERE id = :vID ';
      fdQ.ParamByName('vServer').AsString:=ebServer.Text;
      fdQ.ParamByName('vPort').AsString:=ebPort.Text;
      fdQ.ParamByName('vUser').AsString:=ebUsername.Text;
      fdQ.ParamByName('vPass').AsString:=ebPassword.Text;
      fdQ.ParamByName('vDB').AsString:=ebDB.Text;
      fdQ.ParamByName('vLoc').AsString:=ebLoc.Text;
      fdQ.ParamByName('vID').AsInteger:=idK;
      fdQ.ExecSQL;}

      TToastMessage.show('Data Tersimpan');
      fHome.konek;
    end);

  end).Start;
end;

procedure TfSetting.CornerButton2Click(Sender: TObject);
begin
  TLoading.Show(fSetting, '');

  TThread.CreateAnonymousThread(procedure
  begin
    sleep(100);

    TThread.Synchronize(nil, procedure
    begin
      TLoading.Hide;

      fdQ1.Open;
      fdQ1.Edit;
      fdQ1['nama']:=ebNama.Text;
      fdQ1['jabatan']:=ebJabatan.Text;
      fdQ1['nip']:=ebNIP.Text;
      fdQ1['pangkat']:=ebPangkat.Text;
      fdQ1.Post;

      {fdQ.SQL.Clear;
      fdQ.SQL.Text:='UPDATE cek nama = :vNama,jabatan = :vJabatan, '+
      'nip = :vNIP,pangkat = :vPangkat WHERE id = :vID ';
      fdQ.ParamByName('vNama').AsString:=ebNama.Text;
      fdQ.ParamByName('vJabatan').AsString:=ebJabatan.Text;
      fdQ.ParamByName('vNIP').AsString:=ebNIP.Text;
      fdQ.ParamByName('vPangkat').AsString:=ebPangkat.Text;
      fdQ.ParamByName('vID').AsInteger:=idN;
      fdQ.ExecSQL; }

      TToastMessage.show('Data Tersimpan');
      //fHome.konek;
    end);

  end).Start;
end;

procedure TfSetting.CornerButton3Click(Sender: TObject);
begin
  tabcontrol1.ActiveTab:=TabItem2;
end;

procedure TfSetting.FormShow(Sender: TObject);
begin
  TLoading.Show(fSetting, '');

  TThread.CreateAnonymousThread(procedure
  begin
    sleep(200);

    TThread.Synchronize(nil, procedure
    begin
      TLoading.Hide;

      tabcontrol1.ActiveTab:=TabItem1;
      bKoneksi.StyleLookup:='CornerButton3Style1';
      bNama.StyleLookup:='CornerButton2Style1';

      fdQ.SQL.Clear;
      fdQ.SQL.Text:='select * from cek';
      fdQ.Open;

      //idK:=fdQ.FieldByName('id').AsInteger;
      ebServer.Text:=fdQ.FieldByName('server').AsString;
      ebPort.Text:=fdQ.FieldByName('port').AsString;
      ebUsername.Text:=fdQ.FieldByName('username').AsString;
      ebPassword.Text:=fdQ.FieldByName('password').AsString;
      ebDB.Text:=fdQ.FieldByName('database').AsString;
      ebLoc.Text:=fdQ.FieldByName('loc').AsString;

      fdQ1.SQL.Clear;
      fdQ1.SQL.Text:='select * from ttd';
      fdQ1.Open;

      //idN:=fdQ1.FieldByName('id').AsInteger;
      ebNama.Text:=fdQ1.FieldByName('nama').AsString;
      ebJabatan.Text:=fdQ1.FieldByName('jabatan').AsString;
      ebNIP.Text:=fdQ1.FieldByName('nip').AsString;
      ebPangkat.Text:=fdQ1.FieldByName('pangkat').AsString;
    end);

  end).Start;
end;

end.
