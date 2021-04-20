unit uBits;

interface

/// <summary> mathematically round to specific fraction</summary>
function RoundToFrac(const aValue : Double; const aTeiler: byte = 64):double; 

/// <summary> mathematically round to fractional display</summary>
/// <remarks> output designed for multiple of 2 only
///  (1/2, 1/4, 1/8, 1/16, 1/32..)
///  <para> "aTeiler" used divider</para>
/// </remarks>
function RoundToFracStr(const aValue : Double; const aTeiler: byte = 64):string; 

/// <summary> round down to specific fraction</summary>
function FloorToFrac(const aValue : Double; const aTeiler: byte = 64):double; 

/// <summary> round down to fractional display</summary>
/// <remarks> output designed for multiple of 2 only
///  (1/2, 1/4, 1/8, 1/16, 1/32..)
///  <para> "aTeiler" used divider</para>
/// </remarks>
function FloorToFracStr(const aValue : Double; const aTeiler: byte = 64):string; 

/// <summary> round up to specific fraction</summary>
function CeilToFrac(const aValue : Double; const aTeiler: byte = 64):double;

/// <summary> round up to fractional display</summary>
/// <remarks> output designed for multiple of 2 only
///  (1/2, 1/4, 1/8, 1/16, 1/32..)
///  <para> "aTeiler" used divider</para>
/// </remarks>
function CeilToFracStr(const aValue : Double; const aTeiler: byte = 64):string; 

implementation

uses
  Math,
  SysUtils;
  
{******************************************************************************}

function ggT(A, B: Integer): Cardinal;
var
   Rest: Integer;
   
begin

  while B <> 0 do begin
    Rest := A mod B;
    A := B;
    B := Rest;
  end;
   
  Result := A;
   
end; 

{******************************************************************************}

function DisplayAsFraction(const aValue:double; const aMaxTeiler: byte): string;
var
  fract     : Double;
  s         : string;
  g, n, z , tmp  : Integer;
begin

  result := '';

  // Ganzzahl
  g := trunc(aValue);
  
  // Rest 
  fract := (avalue - g);

  // Zähler vom Rest
  z := aMaxTeiler;

  // Nenner vom Rest
  n :=  round(fract * aMaxTeiler);

  // nur für sinnvolle Gleitkommawete darstellen

    if fract > 0 then begin

    tmp := ggT(n,z);

    z := z div tmp;
    n := n div tmp;

    if (z > 0) then
      result := IntToStr(n) + '/' + IntToStr(z);

  end;

  if Result.IsEmpty then
    result := intToStr(g)
  else if (g > 0) then
    result := intToStr(g) + ' ' + result;

end;


{******************************************************************************}

function RoundToFrac(const aValue : Double; const aTeiler: byte):double;
begin
  result := Math.SimpleRoundTo(aValue * aTeiler, 0) / aTeiler;
end;

{******************************************************************************}

function RoundToFracStr(const aValue : Double; const aTeiler: byte):string;
var
  Value:double;
begin

  Value := RoundToFrac(aValue, aTeiler);

  result := DisplayAsFraction(value, aTeiler);
  
end;

{******************************************************************************}

function FloorToFrac(const aValue : Double; const aTeiler: byte):double;
begin
  result := Math.Floor(aValue * aTeiler) / aTeiler;
end;

{******************************************************************************}

function FloorToFracStr(const aValue : Double; const aTeiler: byte):string;
var
  Value:double;
begin

  Value := FloorToFrac(aValue, aTeiler);

  result := DisplayAsFraction(value, aTeiler);
  
end;

{******************************************************************************}

function CeilToFrac(const aValue : Double; const aTeiler: byte):double;
begin
  result := Math.Ceil(aValue * aTeiler) / aTeiler;
end;
{******************************************************************************}

function CeilToFracStr(const aValue : Double; const aTeiler: byte):string;
var
  Value:double;
begin

  Value := CeilToFrac(aValue, aTeiler);

  result := DisplayAsFraction(value, aTeiler);
  
end;

{******************************************************************************}

end.
