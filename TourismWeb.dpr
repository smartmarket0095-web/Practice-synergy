library TourismWeb;

uses
  Web.WebBroker,
  Web.ISAPIApp,
  Web.ISAPIThreadPool,
  WebModuleUnit in 'WebModuleUnit.pas' {WebModule1: TWebModule};

exports
  GetExtensionVersion,
  HttpExtensionProc,
  TerminateExtension;

begin
  Application.Initialize;
  Application.WebModuleClass := WebModuleClass;
  Application.Run;
end.
