unit uHome;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, System.DateUtils,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.FMXUI.Wait, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, DBAccess, Uni, UniProvider, MySQLUniProvider,
  FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs,
  FireDAC.Phys.SQLiteWrapper.Stat, FMX.Ani;

type
  TfHome = class(TForm)
    imBack: TImage;
    Image2: TImage;
    Image5: TImage;
    lInput: TLayout;
    Label1: TLabel;
    lCari: TLayout;
    Image3: TImage;
    Image4: TImage;
    Label2: TLabel;
    lCetak: TLayout;
    Image6: TImage;
    Image7: TImage;
    Label3: TLabel;
    imLogo: TImage;
    Circle1: TCircle;
    Circle2: TCircle;
    Image1: TImage;
    Image8: TImage;
    Label4: TLabel;
    Line1: TLine;
    Layout1: TLayout;
    Label5: TLabel;
    Timer1: TTimer;
    UniConnection1: TUniConnection;
    FDConnection1: TFDConnection;
    fdQ: TFDQuery;
    MySQLUniProvider1: TMySQLUniProvider;
    Rectangle1: TRectangle;
    lbLoc: TLabel;
    lbWarning: TLabel;
    Layout2: TLayout;
    Circle3: TCircle;
    Image9: TImage;
    Circle4: TCircle;
    Image10: TImage;
    anStart: TFloatAnimation;
    procedure Circle1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FDConnection1BeforeConnect(Sender: TObject);
    procedure Circle2Click(Sender: TObject);
    procedure lInputClick(Sender: TObject);
    procedure lCariClick(Sender: TObject);
    procedure Circle3Click(Sender: TObject);
    procedure Circle4Click(Sender: TObject);
    procedure FormTouch(Sender: TObject; const Touches: TTouches;
      const Action: TTouchAction);
    procedure FormCreate(Sender: TObject);
    procedure lCetakClick(Sender: TObject);
  private
    { Private declarations }
    WasMaximised: Boolean;
  public
    { Public declarations }
    var provider,server,port,username,password,database: string;

    procedure konek;
  end;

var
  fHome: TfHome;
  stat: integer;

implementation

{$R *.fmx}

Uses Loading,ToastMessage,uSetting,uInput,uCari,uCetak;

procedure TfHome.Circle1Click(Sender: TObject);
begin
  MessageDlg('Keluar Aplikasi?', System.UITypes.TMsgDlgType.mtWarning,
  [
    System.UITypes.TMsgDlgBtn.mbYes,
    System.UITypes.TMsgDlgBtn.mbNo
  ], 0,
  procedure(const AResult: System.UITypes.TModalResult)
    begin
      case AResult of
      mrYES:
      begin
        TLoading.Show(fHome, '');

        TThread.CreateAnonymousThread(procedure
        begin
          sleep(200);

          TThread.Synchronize(nil, procedure
          begin
            TLoading.Hide;

            timer1.Enabled:=false;
            Application.Terminate;
          end);

        end).Start;
      end;
      mrNo:
      exit;
    end;
  end);
end;

procedure TfHome.Circle2Click(Sender: TObject);
begin
  TLoading.Show(fHome, '');

  TThread.CreateAnonymousThread(procedure
  begin
    sleep(200);

    TThread.Synchronize(nil, procedure
    begin
      TLoading.Hide;

      Application.CreateForm(TfSetting, fSetting);
      fSetting.Show;
    end);

  end).Start;
end;

procedure TfHome.Circle3Click(Sender: TObject);
begin
  TLoading.Show(fHome, '');

  TThread.CreateAnonymousThread(procedure
  begin
    sleep(500);

    TThread.Synchronize(nil, procedure
    begin
      TLoading.Hide;

      //timer1.Enabled:=true;
      konek;
    end);

  end).Start;
end;

procedure TfHome.Circle4Click(Sender: TObject);
begin
  WindowState := TWindowState.wsMinimized;
end;

procedure TfHome.FDConnection1BeforeConnect(Sender: TObject);
begin
  {$IF DEFINED(iOS) or DEFINED(ANDROID)}
  FDConnection1.Params.Values['Database'] :=
  TPath.Combine(TPath.GetDocumentsPath, 'koneksi.s3db');
  {$ENDIF}
end;

procedure TfHome.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  {MessageDlg('Keluar Aplikasi?', System.UITypes.TMsgDlgType.mtWarning,
  [
    System.UITypes.TMsgDlgBtn.mbYes,
    System.UITypes.TMsgDlgBtn.mbNo
  ], 0,
  procedure(const AResult: System.UITypes.TModalResult)
    begin
      case AResult of
      mrYES:
      begin
        TLoading.Show(fHome, '');

        TThread.CreateAnonymousThread(procedure
        begin
          sleep(200);

          TThread.Synchronize(nil, procedure
          begin
            TLoading.Hide;

            timer1.Enabled:=false;
            Application.Terminate;
          end);

        end).Start;
      end;
      mrNo:
      exit;
    end;
  end);}
end;

procedure TfHome.FormCreate(Sender: TObject);
begin
  //circle1.Visible:=false;
  circle4.Visible:=false;
end;

procedure TfHome.FormShow(Sender: TObject);
begin
  TLoading.Show(fHome, '');

  TThread.CreateAnonymousThread(procedure
  begin
    sleep(500);

    TThread.Synchronize(nil, procedure
    begin
      TLoading.Hide;

      anStart.Start;
      timer1.Enabled:=true;
      konek;
    end);

  end).Start;
end;

procedure TfHome.FormTouch(Sender: TObject; const Touches: TTouches;
  const Action: TTouchAction);
begin
  //WindowState := TWindowState.wsMaximized;
end;

procedure TfHome.konek;
begin
  try
    fdconnection1.Connected:=true;
  finally
    fdQ.SQL.Clear;
    fdQ.SQL.Text:='select * from cek';
    fdQ.Open;

    provider:=fdQ.FieldByName('provider').AsString;
    server:=fdQ.FieldByName('server').AsString;
    port:=fdQ.FieldByName('port').AsString;
    username:=fdQ.FieldByName('username').AsString;
    password:=fdQ.FieldByName('password').AsString;
    database:=fdQ.FieldByName('database').AsString;

    if (fdQ.FieldByName('loc').AsString='') then
    lbLoc.Text:='---'
    else lbLoc.Text:=fdQ.FieldByName('loc').AsString;

    uniconnection1.ProviderName:=provider;
    uniconnection1.Server:=server;
    uniconnection1.Port:=strtoint(port);
    uniconnection1.Username:=username;
    uniconnection1.Password:=password;
    uniconnection1.Database:=database;

    try
      uniconnection1.Connected:=true;
      stat:=1;
      lbWarning.Visible:=false;
    except
      //TToastMessage.show('Tidak dapat terhubung ke data, periksa pengaturan koneksi.');
      lbWarning.Visible:=true;
      stat:=0;
      uniconnection1.Connected:=false;
    end;
  end;
end;

procedure TfHome.lCariClick(Sender: TObject);
begin
  TLoading.Show(fHome, '');

  TThread.CreateAnonymousThread(procedure
  begin
    sleep(200);

    TThread.Synchronize(nil, procedure
    begin
      TLoading.Hide;

      if stat=1 then
      begin
        Application.CreateForm(TfCari, fCari);
        fCari.Show;
      end
      else TToastMessage.show('Tidak dapat terhubung ke data.');
    end);

  end).Start;
end;

procedure TfHome.lCetakClick(Sender: TObject);
begin
  TLoading.Show(fHome, '');

  TThread.CreateAnonymousThread(procedure
  begin
    sleep(200);

    TThread.Synchronize(nil, procedure
    begin
      TLoading.Hide;

      if stat=1 then
      begin
        Application.CreateForm(TfCetak, fCetak);
        fCetak.Show;
      end
      else TToastMessage.show('Tidak dapat terhubung ke data.');
    end);

  end).Start;
end;

procedure TfHome.lInputClick(Sender: TObject);
begin
  TLoading.Show(fHome, '');

  TThread.CreateAnonymousThread(procedure
  begin
    sleep(200);

    TThread.Synchronize(nil, procedure
    begin
      TLoading.Hide;

      if stat=1 then
      begin
        Application.CreateForm(TfInput, fInput);
        fInput.Show;
      end
      else TToastMessage.show('Tidak dapat terhubung ke data.');
    end);

  end).Start;
end;

procedure TfHome.Timer1Timer(Sender: TObject);
begin
  label5.Text:=formatdatetime('hh:nn', now)+' | '+datetostr(now);
end;

end.
