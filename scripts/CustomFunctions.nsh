; CustomFuctions.nsh
;
; Include in your script using:
; !include "CustomFuctions.nsh"

;--------------------------------

!ifndef CUSTOM_FUNCTIONS_INCLUDED
!define CUSTOM_FUNCTIONS_INCLUDED

Function TickCountStart
  !define TickCountStart `!insertmacro TickCountStartCall`
 
  !macro TickCountStartCall
    Call TickCountStart
  !macroend
 
  Push $0
  System::Call 'kernel32::GetTickCount()i .r0'
  Exch $0
FunctionEnd
 
Function TickCountEnd
  !define TickCountEnd `!insertmacro TickCountEndCall`
 
  !macro TickCountEndCall _RESULT
    Call TickCountEnd
    Pop ${_RESULT}
  !macroend
 
  Exch $0
  Push $1
  System::Call 'kernel32::GetTickCount()i .r1'
  System::Int64Op $1 - $0
  Pop $0
  Pop $1
  Exch $0
FunctionEnd

!endif