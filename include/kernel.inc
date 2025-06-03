; generic Linux system call, follows CDECL convention
; first param - system call number, other - system call parameters
; on success EAX contains system call return value, ECX - 0
; on failure EAX contains -1, ECX - error code
%macro kernel 1-*

; save registers depending on parameters count
%if %0 > 1
	push ebx
 %if %0 > 4
	push esi
  %if %0 > 5
	push edi
   %if %0 > 6
	push ebp
    %if %0 > 7
     %error "Can not do Linux system call with 7+ params"
    %endif
   %endif
  %endif
 %endif
%endif

; push parameters onto stack in reverse order
%rep %0
 %rotate -1
	push dword %1
%endrep

; pop parameters from the stack to registers with Linux syscall convention
	pop eax
%if %0 > 1
	pop ebx
 %if %0 > 2
	pop ecx
  %if %0 > 3
	pop edx
   %if %0 > 4
	pop esi
    %if %0 > 5
	pop edi
     %if %0 > 6
	pop ebp
     %endif
    %endif
   %endif
  %endif
 %endif
%endif

	int 0x80            ; make system call
	mov ecx, eax
	and ecx, 0xfffff000
	cmp ecx, 0xfffff000 ; test if systemcall executed successfully
	jne %%ok
	mov ecx, eax        ; if an error occured, move error code to ECX
	neg ecx
	mov eax, -1
	jmp short %%quit
%%ok:
	xor ecx, ecx        ; if executed successfully, zero ECX
%%quit:

; restore registers depending on parameter count
%if %0 > 1
 %if %0 > 4
  %if %0 > 5
   %if %0 > 6
	pop ebp
   %endif
	pop edi
  %endif
	pop esi
 %endif
	pop ebx
%endif

%endmacro
