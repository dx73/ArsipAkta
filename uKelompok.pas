unit uKelompok;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Edit, FMX.Controls.Presentation, FMX.Objects, FMX.Layouts, UniProvider,
  MySQLUniProvider, Data.DB, MemDS, DBAccess, Uni, System.Rtti, FMX.Grid.Style,
  FMX.ScrollBox, FMX.Grid, System.ImageList, FMX.ImgList, Data.Bind.EngExt,
  Fmx.Bind.DBEngExt, Fmx.Bind.Grid, System.Bindings.Outputs, Fmx.Bind.Editors,
  Data.Bind.Components, Data.Bind.Grid, Data.Bind.DBScope, System.DateUtils,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.ListView;

type
  TfKelompok = class(TForm)
    Rectangle1: TRectangle;
    Rectangle2: TRectangle;
    Layout1: TLayout;
    Circle1: TCircle;
    Image8: TImage;
    Label1: TLabel;
    ebID: TEdit;
    ebNama: TEdit;
    Label2: TLabel;
    bSimpan: TCornerButton;
    StyleBook1: TStyleBook;
    uniQ1: TUniQuery;
    MySQLUniProvider1: TMySQLUniProvider;
    ImageList1: TImageList;
    bOK: TCornerButton;
    uniQ: TUniQuery;
    Circle2: TCircle;
    Image1: TImage;
    Rectangle3: TRectangle;
    ListView1: TListView;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    LinkFillControlToField1: TLinkFillControlToField;
    bHapus: TCornerButton;
    procedure FormShow(Sender: TObject);
    procedure bSimpanClick(Sender: TObject);
    procedure Circle2Click(Sender: TObject);
    procedure bUbahClick(Sender: TObject);
    procedure Circle1Click(Sender: TObject);
    procedure ListView1ItemClick(const Sender: TObject;
      const AItem: TListViewItem);
    procedure bOKClick(Sender: TObject);
    procedure bHapusClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
    var stat: integer;
  end;

var
  fKelompok: TfKelompok;
  idn: integer;

implementation

{$R *.fmx}

Uses uHome,Loading,ToastMessage,uInput,uCetak;

procedure TfKelompok.bHapusClick(Sender: TObject);
begin
  if (ebNama.Text<>'') and (ebID.Text<>'') then
  begin
    MessageDlg('Hapus Data?', System.UITypes.TMsgDlgType.mtWarning,
    [
      System.UITypes.TMsgDlgBtn.mbYes,
      System.UITypes.TMsgDlgBtn.mbNo
    ], 0,
    procedure(const AResult: System.UITypes.TModalResult)
    begin
      case AResult of
      mrYES:
        begin
          TLoading.Show(fInput, '');

          TThread.CreateAnonymousThread(procedure
          begin
            sleep(200);

            TThread.Synchronize(nil, procedure
            begin
              TLoading.Hide;

              //hapus
              uniQ.SQL.Clear;
              uniQ.SQL.Text:='delete from judul where id=:vID ';
              uniQ.ParamByName('vID').AsString:=ebID.Text;
              uniQ.ExecSQL;

              //refresh
              uniQ1.SQL.Clear;
              uniQ1.SQL.Text:='select * from judul';
              uniQ1.Open;

              ebID.Text:='JD-'+inttostr(uniQ1.RecordCount+1)+'-'+formatdatetime('yyyy',now);
              ebNama.Text:='';
            end);

          end).Start;
        end;
      mrNo:
      exit;
      end;
    end);
  end;
end;

procedure TfKelompok.bOKClick(Sender: TObject);
begin
  if stat=1 then
  begin
    if ebNama.Text<>'' then
    begin
      fInput.ebKelompok.Text:=ebNama.Text;
      fInput.id:=ebID.Text;
      fInput.ambilData;
      close;
    end
    else close;
  end
  else if stat=2 then
  begin
    fCetak.ebSearch.Text:=ebNama.Text;
    fCetak.ambilData;
    close;
  end;
end;

procedure TfKelompok.bSimpanClick(Sender: TObject);
begin
  if ebNama.Text<>'' then
  begin
    if idn=0 then
    begin
      uniQ.SQL.Clear;
      uniQ.SQL.Text:='insert into judul(id,judul) values(:vID,:vJudul) ';
      uniQ.ParamByName('vID').AsString:=ebID.Text;
      uniQ.ParamByName('vJudul').AsString:=ebNama.Text;
      uniQ.ExecSQL;

      TToastMessage.show('Data tersimpan');

      uniQ1.SQL.Clear;
      uniQ1.SQL.Text:='select * from judul';
      uniQ1.Open;

      ebID.Text:='JD-'+inttostr(uniQ1.RecordCount+1)+'-'+formatdatetime('yyyy',now);
      ebNama.Text:='';
    end
    else if idn=1 then
    begin
      uniQ.SQL.Clear;
      uniQ.SQL.Text:='update judul set judul=:vJudul where id=:vID ';
      uniQ.ParamByName('vID').AsString:=ebID.Text;
      uniQ.ParamByName('vJudul').AsString:=ebNama.Text;
      uniQ.ExecSQL;

      TToastMessage.show('Data tersimpan');

      uniQ1.SQL.Clear;
      uniQ1.SQL.Text:='select * from judul';
      uniQ1.Open;

      ebID.Text:='JD-'+inttostr(uniQ1.RecordCount+1)+'-'+formatdatetime('yyyy',now);
      ebNama.Text:='';
    end;
  end;
end;

procedure TfKelompok.bUbahClick(Sender: TObject);
begin
  {if idn=1 then
  begin
    uniQ.SQL.Clear;
    uniQ.SQL.Text:='update judul set judul=:vJudul where id=:vID ';
    uniQ.ParamByName('vID').AsString:=ebID.Text;
    uniQ.ParamByName('vJudul').AsString:=ebNama.Text;
    uniQ.ExecSQL;

    TToastMessage.show('Data tersimpan');

    uniQ1.SQL.Clear;
    uniQ1.SQL.Text:='select * from judul';
    uniQ1.Open;

    ebID.Text:='JD-'+inttostr(uniQ1.RecordCount+1)+'-'+formatdatetime('yyyy',now);
    ebNama.Text:='';

    bUbah.Enabled:=false;
  end; }
end;

procedure TfKelompok.Circle1Click(Sender: TObject);
begin
  close;
end;

procedure TfKelompok.Circle2Click(Sender: TObject);
begin
  uniQ1.SQL.Clear;
  uniQ1.SQL.Text:='select * from judul';
  uniQ1.Open;

  ebID.Text:='JD-'+inttostr(uniQ1.RecordCount+1)+'-'+formatdatetime('yyyy',now);
  ebNama.Text:='';

  idn:=0;
end;

procedure TfKelompok.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  stat:=0;
end;

procedure TfKelompok.FormShow(Sender: TObject);
begin
  uniQ1.SQL.Clear;
  uniQ1.SQL.Text:='select * from judul';
  uniQ1.Open;

  ebID.Text:='JD-'+inttostr(uniQ1.RecordCount+1)+'-'+formatdatetime('yyyy',now);
  ebNama.Text:='';

  idn:=0;
end;

procedure TfKelompok.ListView1ItemClick(const Sender: TObject;
  const AItem: TListViewItem);
begin
  ebID.Text:=aitem.Data['id'].AsString;
  ebNama.Text:=aitem.Data['nama'].AsString;
  idn:=1;
end;

end.
