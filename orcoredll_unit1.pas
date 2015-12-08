unit orcoredll_unit1;

interface

// unit's public functions. use "C-style" stdcall stack
// for better compatibility to other applications.
function WideStringToAnsiString(const pw: PWideChar; const buf: PAnsiChar;
      var lenBuf: Cardinal): boolean; stdcall;
function URLDecodeUTF8(const s: PAnsiChar; const buf: PWideChar;
      var lenBuf: Cardinal): boolean; stdcall;
function URLDecodeUTF8A(const s: PAnsiChar; const buf: PAnsiChar;
      var lenBuf: Cardinal): boolean; stdcall;

implementation

uses SysUtils;

{
  Convert unicode WideString to AnsiString
  @param pw       widestring to be converted
  @outparam buf   buffer for resulting ansistring
  @outparam lenBuf number of characters in buffer
  @return         true if conversion was done or false
                  if only lenBuf was updated
}
function WideStringToAnsiString(const pw: PWideChar; const buf: PAnsiChar;
      var lenBuf: Cardinal): boolean; stdcall;
var
   sa: AnsiString;
   len: Cardinal;
begin
   sa := WideCharToString(pw);
   len := Length(sa);

   if Assigned(buf) and (len < lenBuf) then begin
      // copy result into the buffer, buffer must have
      // space for last null byte.
      //    lenBuf=num of chars in buffer, not counting null
      if (len > 0) then
         Move(PAnsiChar(sa)^, buf^, len * SizeOf(AnsiChar));
      buf[len] := #0;
      lenBuf := len;
      Result := True;
   end else begin
      // tell calling program how big the buffer
      // shoule be to store all decoded characters,
      // including trailing null value.
      if (len > 0) then
         lenBuf := len+1;
      Result := False;
   end;
end;

{
  URLDecode utf8 encoded string. Resulting widestring
  is copied to inout 'buf' buffer.
  @param s         encoded string
  @outparam buf    buffer for decoded string or nil
                   if should update lenBuf only
  @outparam lenBuf num of characters stored to buffer
  @return          true if string was decoder or false
                   if only lenBuf was updated.
}
function URLDecodeUTF8(const s: PAnsiChar; const buf: PWideChar;
      var lenBuf: Cardinal): boolean; stdcall;
var
   sAnsi: String;    // normal ansi string
   sUtf8: String;    // utf8-bytes string
   sWide: WideString; // unicode string

   i, len: Cardinal;
   ESC: string[2];
   CharCode: integer;
   c: char;
begin
   sAnsi := s; // null-terminated str to pascal str
   SetLength(sUtf8, Length(sAnsi));

   // Convert URLEncoded str to utf8 str, it must
   // use utf8 hex escaping for non us-ascii chars
   //    +      = space
   //    %2A    = *
   //    %C3%84 = Ä (A with diaeresis)
   i := 1;
   len := 1;
   while (i <= Cardinal(Length(sAnsi))) do begin
      if (sAnsi[i] <> '%') then begin
         if (sAnsi[i] = '+') then begin
            c := ' ';
         end else begin
            c := sAnsi[i];
         end;
         sUtf8[len] := c;
         Inc(len);
      end else begin
         Inc(i); // skip the % char
         ESC := Copy(sAnsi, i, 2); // Copy the escape code
         Inc(i, 1); // skip ESC, another +1 at end of loop
         try
            CharCode := StrToInt('$' + ESC);
            //if (CharCode > 0) and (CharCode < 256) then begin
               c := Char(CharCode);
               sUtf8[len] := c;
               Inc(len);
            //end;
         except end;
      end;
      Inc(i);
   end;
   Dec(len); // -1 to fix length (num of characters)
   SetLength(sUtf8, len);

   sWide := UTF8Decode(sUtf8); // utf8 string to unicode
   len := Length(sWide);

   if Assigned(buf) and (len < lenBuf) then begin
      // copy result into the buffer, buffer must have
      // space for last null byte.
      //    lenBuf=num of chars in buffer, not counting null
      if (len > 0) then
         Move(PWideChar(sWide)^, buf^, len * SizeOf(WideChar));
      buf[len] := #0;
      lenBuf := len;
      Result := True;
   end else begin
      // tell calling program how big the buffer
      // should be to store all decoded characters,
      // including trailing null value.
      if (len > 0) then
         lenBuf := len+1;
      Result := False;
   end;
end;

{
  URLDecode utf8 encoded string. Resulting widestring
  is copied to inout 'buf' buffer.
  @param s         encoded string
  @outparam buf    buffer for decoded string or nil
                   if should update lenBuf only
  @outparam lenBuf num of characters stored to buffer
  @return          true if string was decoder or false
                   if only lenBuf was updated.
}
function URLDecodeUTF8A(const s: PAnsiChar; const buf: PAnsiChar;
      var lenBuf: Cardinal): boolean; stdcall;
var
   len: Cardinal;
   pw: PWideChar;
   ok : boolean;
begin
   // decode to widestring
   len := lenBuf * SizeOf(WideChar) + 1;
   pw := AllocMem(len);
   try
      ok := URLDecodeUTF8(s, pw, len);

      if Not(ok) then begin
         lenBuf := len; // num of chars in pw buffer
         Result := ok;
         Exit;
      end;

      // convert to ansistring
      len := len * SizeOf(AnsiChar) + 1;
      ok := WideStringToAnsiString(pw, buf, len);

      lenBuf := len;
      Result := ok;
   finally
      FreeMem(pw);
   end;
end;

end.

