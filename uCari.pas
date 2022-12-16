unit uCari;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Layouts, System.ImageList, FMX.ImgList, FMX.StdCtrls, FMX.Edit,
  FMX.Controls.Presentation, UniProvider, MySQLUniProvider, Data.DB, MemDS,
  DBAccess, Uni, System.Rtti, FMX.Grid.Style, Fmx.Bind.Grid,
  System.Bindings.Outputs, Fmx.Bind.Editors, Data.Bind.EngExt,
  Fmx.Bind.DBEngExt, FMX.DateTimeCtrls, Data.Bind.Components, Data.Bind.Grid,
  FMX.ScrollBox, FMX.Grid, Data.Bind.DBScope;

type
  TfCari = class(TForm)
    Rectangle1: TRectangle;
    Rectangle2: TRectangle;
    ImageList1: TImageList;
    layout1: TLayout;
    Label2: TLabel;
    ebSearch: TEdit;
    bCari: TCornerButton;
    Label1: TLabel;
    Circle1: TCircle;
    Image8: TImage;
    Circle2: TCircle;
    Image1: TImage;
    Rectangle3: TRectangle;
    StyleBook1: TStyleBook;
    Layout3: TLayout;
    uniQ: TUniQuery;
    MySQLUniProvider1: TMySQLUniProvider;
    uniQ1: TUniQuery;
    BindSourceDB1: TBindSourceDB;
    GridBindSourceDB1: TGrid;
    BindingsList1: TBindingsList;
    ebNama: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    ebOrtu: TEdit;
    Label5: TLabel;
    Label6: TLabel;
    ebAkta: TEdit;
    Label7: TLabel;
    ebSementara: TEdit;
    CornerButton1: TCornerButton;
    CornerButton2: TCornerButton;
    CornerButton3: TCornerButton;
    ebTgl2: TEdit;
    LinkGridToDataSourceBindSourceDB1: TLinkGridToDataSource;
    procedure Circle1Click(Sender: TObject);
    procedure bCariClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure cariData;
    procedure GridBindSourceDB1CellClick(const Column: TColumn;
      const Row: Integer);
    procedure CornerButton2Click(Sender: TObject);
    procedure CornerButton3Click(Sender: TObject);
    procedure CornerButton1Click(Sender: TObject);
    procedure Circle2Click(Sender: TObject);
    procedure ebSearchKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
  private
    procedure tampilData(id, kelompok, nama, ortu, tgl, akta, smntr: string);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fCari: TfCari;
  idA: string;

implementation

{$R *.fmx}

Uses uHome,Loading,ToastMessage,uInput;

procedure TfCari.bCariClick(Sender: TObject);
begin
  cariData;
end;

procedure TfCari.cariData;
begin
  TLoading.Show(fCari, '');

  TThread.CreateAnonymousThread(procedure
  begin
    sleep(200);

    TThread.Synchronize(nil, procedure
    begin
      TLoading.Hide;

      uniQ1.SQL.Clear;
      uniQ1.SQL.Text:='SELECT id_input,judul,nama_anak,concat(nama_ayah,'' -- '',nama_ibu) "ortu", '+
      'tgl_lahir,no_akta,no_sementara FROM akta where 1=1 ';
      if ebSearch.Text<>'' then uniQ1.SQL.Text:=uniQ1.SQL.Text + ' and (judul like''%'+ebSearch.Text+'%'' '+
      'or nama_anak like''%'+ebSearch.Text+'%'' or nama_ayah like''%'+ebSearch.Text+'%'' '+
      'or nama_ibu like''%'+ebSearch.Text+'%'' or no_akta like''%'+ebSearch.Text+'%'' '+
      'or no_sementara like''%'+ebSearch.Text+'%'' ) ';
      //if ebSearch.Text<>'' then uniQ1.ParamByName('vS').AsString:=ebSearch.Text;
      uniQ1.Open;
      //showmessage(uniQ1.SQL.Text);
    end);

  end).Start;
end;

procedure TfCari.Circle1Click(Sender: TObject);
begin
  close;
end;

procedure TfCari.Circle2Click(Sender: TObject);
begin
  cariData;
end;

procedure TfCari.CornerButton1Click(Sender: TObject);
begin
  TLoading.Show(fCari, '');

  TThread.CreateAnonymousThread(procedure
  begin
    sleep(200);

    TThread.Synchronize(nil, procedure
    begin
      TLoading.Hide;

      Application.CreateForm(TfInput, fInput);
      fInput.idA:=idA;
      fInput.ebID.Text:=idA;
      fInput.cariData;
      //fInput.WindowState:=TWindowstate.wsMaximized;
      fInput.Show;
      //close;
    end);

  end).Start;
end;

procedure TfCari.CornerButton2Click(Sender: TObject);
begin
  ebNama.Text:='';
  ebOrtu.Text:='';
  ebTgl2.Text:='';
  ebAkta.Text:='';
  ebSementara.Text:='';
  idA:='';
end;

procedure TfCari.CornerButton3Click(Sender: TObject);
begin
  if (ebNama.Text<>'') and (idA<>'') then
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
          TLoading.Show(fCari, '');

          TThread.CreateAnonymousThread(procedure
          begin
            sleep(200);

            TThread.Synchronize(nil, procedure
            begin
              TLoading.Hide;

              //hapus
              uniQ.SQL.Clear;
              uniQ.SQL.Text:='delete from akta where id_input=:vID ';
              uniQ.ParamByName('vID').AsString:=idA;
              uniQ.ExecSQL;

              //refresh
              ebNama.Text:='';
              ebOrtu.Text:='';
              ebTgl2.Text:='';
              ebAkta.Text:='';
              ebSementara.Text:='';
              idA:='';

              cariData;
            end);

          end).Start;
        end;
      mrNo:
      exit;
      end;
    end);
  end;
end;

procedure TfCari.ebSearchKeyDown(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  if (key=vkReturn) or (key=vkTab) then
  begin
    cariData;
  end;
end;

procedure TfCari.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  uniQ.Active:=false;
  uniQ1.Active:=false;
end;

procedure TfCari.FormShow(Sender: TObject);
begin
  cariData;
end;

procedure TfCari.GridBindSourceDB1CellClick(const Column: TColumn;
  const Row: Integer);
begin
  idA:=uniQ1['id_input'];

  try
    uniQ.SQL.Clear;
    uniQ.SQL.Text:='select id_input,judul,nama_anak,concat(nama_ayah,'' -- '',nama_ibu) "ortu", '+
      'tgl_lahir,no_akta,no_sementara from akta where id_input='+quotedstr(idA);
    uniQ.Open;
  finally
    ebNama.Text:=uniQ.FieldByName('nama_anak').AsString;
    ebOrtu.Text:=uniQ.FieldByName('ortu').AsString;
    ebTgl2.Text:=uniQ.FieldByName('tgl_lahir').AsString;
    ebAkta.Text:=uniQ.FieldByName('no_akta').AsString;
    ebSementara.Text:=uniQ.FieldByName('no_sementara').AsString;
  end;

  {ebNama.Text:=uniQ1['nama_anak'];
  ebOrtu.Text:=uniQ1['ortu'];
  ebTgl.Date:=strtodate(uniQ1['tgl_lahir']);
  ebAkta.Text:=uniQ1['no_akta'];
  ebSementara.Text:=uniQ1['no_sementara'];  }
end;

procedure TfCari.tampilData(id, kelompok, nama, ortu, tgl, akta, smntr: string);
begin

end;

end.
