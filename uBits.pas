unit uBits;

interface

/// <summary> round to fractional display</summary>
/// <remarks> max accuracy 1 / 64
///  1/2, 1/4, 1/8, 1/16, 1/32, 1/64
/// </remarks>
function FloatToFrac(const d: double): double; overload;

/// <summary> round to fractional display</summary>
/// <remarks> max accuracy 1 / 64
///  (1/2, 1/4, 1/8, 1/16, 1/32, 1/64)
///  <para> "Teiler" used divider</para>
/// </remarks>
function FloatToFrac(const d: double; var Teiler : byte): double; overload;

/// <summary> round to fractional display and output as string</summary>
/// <remarks> max accuracy 1 / 64
///  (1/2, 1/4, 1/8, 1/16, 1/32, 1/64)
/// </remarks>
function FloatToFracStr(const d:double):string;

/// <summary> mathematically round to specific fraction</summary>
function RoundToFrac(Value : Double; Teiler: byte):double;

/// <summary> round down to specific fraction</summary>
function FloorToFrac(Value : Double; Teiler: byte):double;

/// <summary> round up to specific fraction</summary>
function CeilToFrac(Value : Double; Teiler: byte):double;

implementation

uses
  Math,
  SysUtils;

{******************************************************************************}

function FloatToFrac(const d:double):double;

var
  Teiler:Byte;

begin
  result  := FloatToFrac(d, Teiler);
end;

{******************************************************************************}

function FloatToFracStr(const d:double):string;

var
  Teiler  : Byte;
  r       : double;
  z       : byte;
  g       : integer;

begin

  result :='';

  r := FloatToFrac(d, Teiler);

  // Ganzzahl
  g := trunc(r);

  if (g > 0) then begin

    result  := IntToStr(g);

    if (teiler > 0)then
      result := result + ' ';

  end;

  z := round((r - g) * Teiler);

  if z > 0 then
    result := result + inttostr(z) + '/' +inttostr(Teiler);

end;

{******************************************************************************}

function FloatToFrac(const d:double;var Teiler : byte):double;

var
  lower, upper    : double;
  i               : integer;
  deltaL, deltaU  : double;
  bSuccess        : boolean;

const
  cAccuracy = 0.015625;{ kleinster gewünschter Bruch  1 / 64 = 0.015625}
  cTeiler : array of byte =[2, 4, 8, 16, 32, 64];

begin
  bSuccess:= false;
  Teiler  := 0;

   for i := 0 to 5 do begin

    // Nächstes Vielfaches
    lower := 1.0 / cTeiler[i] * floor(cTeiler[i] * d);
    upper := 1.0 / cTeiler[i] * floor(cTeiler[i] * d + 1.0);

    // Grenzen
    deltaL := abs(d - lower);
    deltaU := abs(upper - d);

    // obere Grenze
    if deltaU <= cAccuracy then begin
      result    := upper;
      bSuccess  := true;
    end;

    // untere Grenze
    if deltaL <= cAccuracy then begin

      if bSuccess and (deltaL < deltaU) then
        result  := lower
      else
        result := lower;

      bSuccess  := true;
    end;

    if bSuccess then begin
      Teiler := cTeiler[i];
      exit;
    end;

   end;

end;

{******************************************************************************}

function RoundToFrac(Value : Double; Teiler: byte):double;
begin
  result := Math.SimpleRoundTo(Value * Teiler, 0) / Teiler;
end;

{******************************************************************************}

function FloorToFrac(Value : Double; Teiler: byte):double;
begin
  result := Math.Floor(Value * Teiler) / Teiler;
end;

{******************************************************************************}

function CeilToFrac(Value : Double; Teiler: byte):double;
begin
  result := Math.Ceil(Value * Teiler) / Teiler;
end;

{******************************************************************************}

end.
