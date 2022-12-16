unit uCetak;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, Data.DB, MemDS,
  DBAccess, Uni, System.ImageList, FMX.ImgList, System.Rtti, FMX.Grid.Style,
  FMX.ScrollBox, FMX.Grid, FMX.Objects, FMX.StdCtrls, FMX.Edit,
  FMX.Controls.Presentation, FMX.Layouts, Data.Bind.EngExt, Fmx.Bind.DBEngExt,
  Fmx.Bind.Grid, System.Bindings.Outputs, Fmx.Bind.Editors,
  Data.Bind.Components, Data.Bind.Grid, Data.Bind.DBScope, FMX.frxClass,
  FMX.frxDBSet, FMX.frxExportXML, FMX.frxExportCSV, FMX.frxExportPDF,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TfCetak = class(TForm)
    StyleBook1: TStyleBook;
    ImageList1: TImageList;
    uniQ1: TUniQuery;
    uniQ: TUniQuery;
    Rectangle1: TRectangle;
    Rectangle2: TRectangle;
    layout1: TLayout;
    Label2: TLabel;
    ebSearch: TEdit;
    bCari: TCornerButton;
    Circle1: TCircle;
    Image8: TImage;
    Circle2: TCircle;
    Image1: TImage;
    GridBindSourceDB1: TGrid;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    LinkGridToDataSourceBindSourceDB1: TLinkGridToDataSource;
    CornerButton2: TCornerButton;
    CornerButton3: TCornerButton;
    frxReport1: TfrxReport;
    frxDBDataset1: TfrxDBDataset;
    frxPDFExport1: TfrxPDFExport;
    frxCSVExport1: TfrxCSVExport;
    frxXMLExport1: TfrxXMLExport;
    fdQ1: TFDQuery;
    frxDBDataset2: TfrxDBDataset;
    procedure bCariClick(Sender: TObject);
    procedure ambilData;
    procedure ebSearchChange(Sender: TObject);
    procedure CornerButton2Click(Sender: TObject);
    procedure Circle1Click(Sender: TObject);
    procedure Circle2Click(Sender: TObject);
    procedure CornerButton3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fCetak: TfCetak;

implementation

{$R *.fmx}

Uses uHome,Loading,ToastMessage,uKelompok;

procedure TfCetak.ambilData;
begin
  //refresh data
  uniQ1.SQL.Clear;
  uniQ1.SQL.Text:='select * from akta where judul='+quotedstr(ebSearch.Text);
  uniQ1.Open;
end;

procedure TfCetak.bCariClick(Sender: TObject);
begin
  TLoading.Show(fCetak, '');

  TThread.CreateAnonymousThread(procedure
  begin
    sleep(200);

    TThread.Synchronize(nil, procedure
    begin
      TLoading.Hide;

      Application.CreateForm(TfKelompok, fKelompok);
      fKelompok.stat:=2;
      fKelompok.Show;
    end);

  end).Start;
end;

procedure TfCetak.Circle1Click(Sender: TObject);
begin
  close;
end;

procedure TfCetak.Circle2Click(Sender: TObject);
begin
  if ebSearch.Text<>'' then
  begin
    ambilData;
  end;
end;

procedure TfCetak.CornerButton2Click(Sender: TObject);
begin
  ebSearch.Text:='';
  uniQ1.Close;
  uniQ.Close;
end;

procedure TfCetak.CornerButton3Click(Sender: TObject);
begin
  if ebSearch.Text='' then TToastMessage.show('Tidak ada kelompok data yang dipilih.')
  else
  begin
    try
      Cursor:=crHourGlass;
      //refresh data
      uniQ.SQL.Clear;
      uniQ.SQL.Text:='select * from akta where judul='+quotedstr(ebSearch.Text);
      uniQ.Open;
    finally
      frxreport1.ShowReport();
      cursor:=crDefault;
    end;
  end;
end;

procedure TfCetak.ebSearchChange(Sender: TObject);
begin
  if ebSearch.Text<>'' then
  begin
    ambilData;
  end;
end;

end.
