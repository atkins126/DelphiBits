unit uBitsWinAPI;

interface

/// <summary>
/// Register custom URI Handler by writing to the Registry.
/// Writing requires elevated user rights.
/// (Writing will only occur if its actually needed).
/// <param name="sScheme">URI scheme (without ":")</param>
/// <param name="sName"> scheme name "URL:" + sName </param>
/// <param name="sFullAppPath">Full path to the target application</param>
/// </summary>
function RegisterURIScheme(const sScheme, sName, sFullAppPath:string): boolean;

implementation

uses
  Registry,
  SysUtils,
  Windows;

function RegisterURIScheme(const sScheme, sName, sFullAppPath:string): boolean;
var
  Reg     : TRegistry;
  bOK     : Boolean;
  i       : integer;
  paths   : TArray<string>;


function WriteIfNeeded(sKey, sValue:string):boolean;
begin

  result := false;

  if Reg.ValueExists(sKey) then begin
    if Reg.ReadString(sKey).Equals(sValue) then begin
      result := true;
      exit;
    end;

  end;

  reg.Access := KEY_WRITE;
  Reg.WriteString(sKey, sValue);
end;

{
HKEY_CLASSES_ROOT
  alert
    (Default) = "URL:Alert Protocol"
    URL Protocol = ""
    DefaultIcon
    (Default) = "alert.exe,1"
    shell
      open
        command
          (Default) = "C:\Program Files\Alert\alert.exe" "%1"

as per:
https://docs.microsoft.com/en-us/previous-versions/windows/internet-explorer/ie-developer/platform-apis/aa767914(v=vs.85)

}



begin

  result := false;

  // first subkey (scheme name, without ":")
  paths  := [lowercase(sScheme)] + ['shell','open','command'];

  Reg := TRegistry.Create(KEY_READ);

  try

    Reg.RootKey := HKEY_CLASSES_ROOT;

    for i := 0 to high(paths) do begin

      if (not reg.KeyExists(paths[i])) then begin
        //  write if needed
        reg.Access := KEY_WRITE;
        bOK := reg.OpenKey(paths[i], True);
      end
      else begin
        // open otherwise
        bOK := reg.OpenKey(paths[i], false);
      end;

      if not bOK then
        exit;

      case i of

        0: begin

          // default value
          WriteIfNeeded('', 'URL:' + sName);

          // declares custom pluggable protocol handler.
          // Without this key, the handler application will not launch.
          // The value should be an empty string.
          WriteIfNeeded('URL Protocol', '');

          // optional add an icon of target application
          try

            if (not reg.KeyExists('DefaultIcon')) then
              reg.Access := KEY_WRITE;

            reg.OpenKey('DefaultIcon', true);

            WriteIfNeeded('', 'shell32.dll,26');
          finally
            reg.CloseKey;
            reg.OpenKey(paths[0], True);
          end;



        end;
        3: begin
          WriteIfNeeded('', '"' + sFullAppPath + '" "%1"');

        end;
      end;

    end;

    result := true;


    reg.CloseKey();
  finally
    Reg.Free;
  end;

end;


end.
