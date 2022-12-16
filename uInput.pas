unit uInput;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Edit, FMX.Controls.Presentation, FMX.Objects, FMX.Layouts,
  System.ImageList, FMX.ImgList, FMX.Memo.Types, FMX.ListView.Types,
  FMX.ListView.Appearances, FMX.ListView.Adapters.Base, FMX.ListView,
  FMX.ScrollBox, FMX.Memo, FMX.DateTimeCtrls, UniProvider, MySQLUniProvider,
  Data.DB, MemDS, DBAccess, Uni, System.Rtti, System.Bindings.Outputs,
  Fmx.Bind.Editors, Data.Bind.EngExt, Fmx.Bind.DBEngExt, Data.Bind.Components,
  Data.Bind.DBScope;

type
  TfInput = class(TForm)
    ImageList1: TImageList;
    Rectangle1: TRectangle;
    Rectangle2: TRectangle;
    Layout1: TLayout;
    Circle1: TCircle;
    Image8: TImage;
    Label1: TLabel;
    ebID: TEdit;
    ebKelompok: TEdit;
    Label2: TLabel;
    ebNama: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    StyleBook1: TStyleBook;
    Label5: TLabel;
    ebAyah: TEdit;
    Label6: TLabel;
    ebIbu: TEdit;
    Label7: TLabel;
    ebAkta: TEdit;
    Label8: TLabel;
    ebSementara: TEdit;
    Label9: TLabel;
    bCari: TCornerButton;
    ebDate: TDateEdit;
    mKet: TMemo;
    Rectangle3: TRectangle;
    ListView1: TListView;
    bSimpan: TCornerButton;
    uniQ1: TUniQuery;
    MySQLUniProvider1: TMySQLUniProvider;
    Circle2: TCircle;
    Image1: TImage;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    LinkFillControlToField1: TLinkFillControlToField;
    uniQ: TUniQuery;
    ebBerkas: TEdit;
    Label10: TLabel;
    bView: TCornerButton;
    bBrowse: TCornerButton;
    CornerButton3: TCornerButton;
    OpenDialog1: TOpenDialog;
    procedure Circle1Click(Sender: TObject);
    procedure bCariClick(Sender: TObject);
    procedure Circle2Click(Sender: TObject);
    procedure bSimpanClick(Sender: TObject);
    procedure bBrowseClick(Sender: TObject);
    procedure bViewClick(Sender: TObject);
    procedure CornerButton3Click(Sender: TObject);
    procedure ListView1ItemClick(const Sender: TObject;
      const AItem: TListViewItem);
    procedure cariData;
    procedure ambilData;
  private
    { Private declarations }
  public
    { Public declarations }
    var id,idA: string;
  end;

var
  fInput: TfInput;
  stat,idn: integer;

implementation

{$R *.fmx}

Uses uHome,Loading,ToastMessage,uKelompok,uBrowse,uBrowse2;

procedure TfInput.ambilData;
begin
  if ebKelompok.Text<>'' then
  begin
    uniQ1.SQL.Clear;
    uniQ1.SQL.Text:='SELECT id_input,judul,nama_anak,tgl_lahir,concat(nama_ayah,'' -- '',nama_ibu) "ortu" '+
    'FROM akta where judul='+quotedstr(ebKelompok.Text);
    uniQ1.Open;

    ebID.Text:='AK-'+formatdatetime('hms',now)+'-'+id+'-'+inttostr(uniQ1.RecordCount+1);
  end
  else
  begin
    ebID.Text:='';

    uniQ1.SQL.Clear;
    uniQ1.SQL.Text:='SELECT id_input,judul,nama_anak,tgl_lahir,concat(nama_ayah,'' -- '',nama_ibu) "ortu" FROM akta';
    uniQ1.Open;
  end;
end;

procedure TfInput.bBrowseClick(Sender: TObject);
begin
  if opendialog1.Execute then
  begin
    ebBerkas.Text:=opendialog1.FileName;
  end;
end;

procedure TfInput.bCariClick(Sender: TObject);
begin
  TLoading.Show(fInput, '');

  TThread.CreateAnonymousThread(procedure
  begin
    sleep(200);

    TThread.Synchronize(nil, procedure
    begin
      TLoading.Hide;

      Application.CreateForm(TfKelompok, fKelompok);
      fKelompok.stat:=1;
      fKelompok.Show;
    end);

  end).Start;
end;

procedure TfInput.bSimpanClick(Sender: TObject);
begin
  if (ebNama.Text<>'') and (idn=0) then
  begin
    MessageDlg('Simpan Data?', System.UITypes.TMsgDlgType.mtWarning,
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

              //simpan
              uniQ.SQL.Clear;
              uniQ.SQL.Text:='insert into akta(id_input,judul,nama_anak,tgl_lahir, '+
              'nama_ayah,nama_ibu,no_akta,no_sementara,ket,berkas) '+
              'values(:vID,:vJudul,:vNama,:vTgl,:vAyah,:vIbu,:vAkta,:vNoSMNTR,:vKet,:vBerkas) ';
              uniQ.ParamByName('vID').AsString:=ebID.Text;
              uniQ.ParamByName('vJudul').AsString:=ebKelompok.Text;
              uniQ.ParamByName('vNama').AsString:=ebNama.Text;
              uniQ.ParamByName('vTgl').AsDate:=ebDate.Date;
              uniQ.ParamByName('vAyah').AsString:=ebAyah.Text;
              uniQ.ParamByName('vIbu').AsString:=ebIbu.Text;
              uniQ.ParamByName('vAkta').AsString:=ebAkta.Text;
              uniQ.ParamByName('vNoSMNTR').AsString:=ebSementara.Text;
              uniQ.ParamByName('vKet').AsString:=mKet.Text;
              uniQ.ParamByName('vBerkas').AsString:=ebBerkas.Text;
              uniQ.ExecSQL;

              //refresh
              //ebID.Text:='';
              //ebKelompok.Text:='';
              ebNama.Text:='';
              ebDate.Date:=now();
              ebAyah.Text:='';
              ebIbu.Text:='';
              ebAkta.Text:='';
              ebSementara.Text:='';
              mKet.Text:='';
              ebBerkas.Text:='';
              idn:=0;

              ambilData;
            end);

          end).Start;
        end;
      mrNo:
      exit;
      end;
    end);
  end
  else if (ebNama.Text<>'') and (idn=1) then
  begin
    MessageDlg('Simpan Data?', System.UITypes.TMsgDlgType.mtWarning,
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

              //simpan
              uniQ.SQL.Clear;
              uniQ.SQL.Text:='UPDATE akta SET nama_anak=:vNama,tgl_lahir=:vTgl, '+
              'nama_ayah=:vAyah,nama_ibu=:vIbu,no_akta=:vAkta,no_sementara=:vNoSMNTR, '+
              'ket=:vKet,berkas=:vBerkas WHERE id_input=:vID ';
              uniQ.ParamByName('vID').AsString:=ebID.Text;
              //uniQ.ParamByName('vJudul').AsString:=ebKelompok.Text;
              uniQ.ParamByName('vNama').AsString:=ebNama.Text;
              uniQ.ParamByName('vTgl').AsDate:=ebDate.Date;
              uniQ.ParamByName('vAyah').AsString:=ebAyah.Text;
              uniQ.ParamByName('vIbu').AsString:=ebIbu.Text;
              uniQ.ParamByName('vAkta').AsString:=ebAkta.Text;
              uniQ.ParamByName('vNoSMNTR').AsString:=ebSementara.Text;
              uniQ.ParamByName('vKet').AsString:=mKet.Text;
              uniQ.ParamByName('vBerkas').AsString:=ebBerkas.Text;
              uniQ.ExecSQL;

              //refresh
              //ebID.Text:='';
              //ebKelompok.Text:='';
              ebNama.Text:='';
              ebDate.Date:=now();
              ebAyah.Text:='';
              ebIbu.Text:='';
              ebAkta.Text:='';
              ebSementara.Text:='';
              mKet.Text:='';
              ebBerkas.Text:='';
              idn:=0;

              ambilData;
            end);

          end).Start;
        end;
      mrNo:
      exit;
      end;
    end);
  end;
end;

procedure TfInput.bViewClick(Sender: TObject);
begin
  TLoading.Show(fInput, '');

  TThread.CreateAnonymousThread(procedure
  begin
    sleep(200);

    TThread.Synchronize(nil, procedure
    begin
      TLoading.Hide;

      Application.CreateForm(TfBrowse2, fBrowse2);
      fBrowse2.berkas:=ebBerkas.Text;
      fBrowse2.Show;
    end);

  end).Start;
end;

procedure TfInput.cariData;
begin
  TLoading.Show(fInput, '');

  TThread.CreateAnonymousThread(procedure
  begin
    sleep(500);

    TThread.Synchronize(nil, procedure
    begin
      TLoading.Hide;

      try
        uniQ.SQL.Clear;
        uniQ.SQL.Text:='select * from akta where id_input='+quotedstr(idA);
        uniQ.Open;
        //showmessage(uniQ.SQL.Text);
      finally
        ebKelompok.Text:=uniQ.FieldByName('judul').AsString;
        ebNama.Text:=uniQ.FieldByName('nama_anak').AsString;
        ebDate.Text:=uniQ.FieldByName('tgl_lahir').AsString;
        ebAyah.Text:=uniQ.FieldByName('nama_ayah').AsString;
        ebIbu.Text:=uniQ.FieldByName('nama_ibu').AsString;
        ebAkta.Text:=uniQ.FieldByName('no_akta').AsString;
        ebSementara.Text:=uniQ.FieldByName('no_sementara').AsString;
        mKet.Text:=uniQ.FieldByName('ket').AsString;
        ebBerkas.Text:=uniQ.FieldByName('berkas').AsString;
        idn:=1;

        uniQ1.SQL.Clear;
        uniQ1.SQL.Text:='SELECT id_input,judul,nama_anak,tgl_lahir,concat(nama_ayah,'' -- '',nama_ibu) "ortu" '+
        'FROM akta where judul='+quotedstr(ebKelompok.Text);
        uniQ1.Open;

        //WindowState := TWindowState.wsMaximized;
      end;
    end);

  end).Start;
end;

procedure TfInput.Circle1Click(Sender: TObject);
begin
  close;
end;

procedure TfInput.Circle2Click(Sender: TObject);
begin
  ebID.Text:='';
  ebKelompok.Text:='';
  ebNama.Text:='';
  ebDate.Date:=now();
  ebAyah.Text:='';
  ebIbu.Text:='';
  ebAkta.Text:='';
  ebSementara.Text:='';
  mKet.Text:='';
  ebBerkas.Text:='';

  uniQ1.SQL.Clear;
  uniQ1.SQL.Text:='SELECT id_input,judul,nama_anak,tgl_lahir,concat(nama_ayah,'' -- '',nama_ibu) "ortu" FROM akta';
  uniQ1.Open;
end;

procedure TfInput.CornerButton3Click(Sender: TObject);
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
                uniQ.SQL.Text:='delete from akta where id_input=:vID ';
                uniQ.ParamByName('vID').AsString:=ebID.Text;
                uniQ.ExecSQL;

                //refresh
                //ebID.Text:='';
                //ebKelompok.Text:='';
                ebNama.Text:='';
                ebDate.Date:=now();
                ebAyah.Text:='';
                ebIbu.Text:='';
                ebAkta.Text:='';
                ebSementara.Text:='';
                mKet.Text:='';
                ebBerkas.Text:='';
                idn:=0;

                ambilData;
              end);

            end).Start;
          end;
        mrNo:
        exit;
        end;
      end);
  end;
end;

procedure TfInput.ListView1ItemClick(const Sender: TObject;
  const AItem: TListViewItem);
begin
  ebID.Text:=aitem.Data['id'].AsString;
  idA:=aitem.Data['id'].AsString;

  cariData;
end;

end.
