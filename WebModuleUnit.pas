unit WebModuleUnit;

interface

uses
  System.SysUtils, System.Classes, System.JSON, System.NetEncoding,
  Web.HTTPApp, FireDAC.Comp.Client, FireDAC.Stan.Def, FireDAC.Stan.Async,
  FireDAC.Phys.MSSQL, FireDAC.Phys.MSSQLDef;

type
  TWebModule1 = class(TWebModule)
    procedure WebModule1DefaultHandlerAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
  private
    function GetConnection: TFDConnection;
    function ToursJson: string;
    function HtmlPage(const Body: string): string;
  public
  end;

var
  WebModuleClass: TComponentClass = TWebModule1;

implementation

{$R *.dfm}

function TWebModule1.GetConnection: TFDConnection;
begin
  Result := TFDConnection.Create(nil);
  Result.DriverName := 'MSSQL';
  Result.Params.Values['Server'] := 'localhost';
  Result.Params.Values['Database'] := 'TourismWeb';
  Result.Params.Values['User_Name'] := 'sa';
  Result.Params.Values['Password'] := 'YourStrongPassword';
  Result.Params.Values['OSAuthent'] := 'No';
  Result.LoginPrompt := False;
  Result.Connected := True;
end;

function TWebModule1.ToursJson: string;
var
  Conn: TFDConnection;
  Q: TFDQuery;
  Arr: TJSONArray;
  Obj: TJSONObject;
begin
  Conn := GetConnection;
  Q := TFDQuery.Create(nil);
  Arr := TJSONArray.Create;
  try
    Q.Connection := Conn;
    Q.SQL.Text :=
      'SELECT TourId, Name, Destination, StartDate, EndDate, Price ' +
      'FROM dbo.Tours ORDER BY StartDate';
    Q.Open;

    while not Q.Eof do
    begin
      Obj := TJSONObject.Create;
      Obj.AddPair('id', TJSONNumber.Create(Q.FieldByName('TourId').AsInteger));
      Obj.AddPair('name', Q.FieldByName('Name').AsString);
      Obj.AddPair('destination', Q.FieldByName('Destination').AsString);
      Obj.AddPair('startDate', Q.FieldByName('StartDate').AsString);
      Obj.AddPair('endDate', Q.FieldByName('EndDate').AsString);
      Obj.AddPair('price', TJSONNumber.Create(Q.FieldByName('Price').AsFloat));
      Arr.AddElement(Obj);
      Q.Next;
    end;

    Result := Arr.ToJSON;
  finally
    Arr.Free;
    Q.Free;
    Conn.Free;
  end;
end;

function TWebModule1.HtmlPage(const Body: string): string;
begin
  Result :=
    '<!doctype html><html lang="ru"><head>' +
    '<meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1">' +
    '<title>Туризм</title>' +
    '<style>body{font-family:Arial;margin:40px;background:#f5f7fa;color:#222}' +
    '.card{background:#fff;padding:24px;border-radius:12px;max-width:900px;margin:auto}' +
    'table{border-collapse:collapse;width:100%}th,td{padding:10px;border-bottom:1px solid #ddd;text-align:left}' +
    'a{color:#1565c0}</style></head><body><div class="card">' +
    Body + '</div></body></html>';
end;

procedure TWebModule1.WebModule1DefaultHandlerAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
  Json: string;
  Html: string;
begin
  Handled := True;

  if SameText(Request.PathInfo, '/api/tours') then
  begin
    Json := ToursJson;
    Response.ContentType := 'application/json; charset=utf-8';
    Response.Content := Json;
    Exit;
  end;

  Html :=
    '<h1>Информационная система «Туризм»</h1>' +
    '<p>WEB-приложение на Delphi WebBroker + IIS + MS SQL Server.</p>' +
    '<p><a href="/api/tours">Открыть API списка туров</a></p>' +
    '<h2>Назначение системы</h2>' +
    '<p>Система предназначена для просмотра туристических предложений и получения данных о турах.</p>';

  Response.ContentType := 'text/html; charset=utf-8';
  Response.Content := HtmlPage(Html);
end;

end.
