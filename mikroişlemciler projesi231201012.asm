 ORG 100h

.DATA
    ; Gun isimleri
    GUNLER       DB 'Pazar    $'
                 DB 'Pazartesi$'
                 DB 'Sali     $'
                 DB 'Carsamba $'
                 DB 'Persembe $'
                 DB 'Cuma     $'
                 DB 'Cumartesi$'

    SAAT_TXT     DB '00:00:00$'
    TARIH_TXT    DB '00/00/0000$'
    TIRE         DB '  -  $'

.CODE  

BASLA:
    ; Ekrani temizle
    MOV AX, 03h
    INT 10h

DONGU:
    ; Imleci ekranin ortasina koy (Satir 12, Sutun 25)
    MOV AH, 02h
    MOV BH, 0
    MOV DH, 12
    MOV DL, 25
    INT 10h

    ; --- SAAT ISLEMLERI ---
    ; Sistem saatini al (CH=Saat, CL=Dakika, DH=Saniye) 
    
    MOV AH, 2Ch       ,
    INT 21h
    
    ; Saati ayarla
    MOV AL, CH
    CALL RAKAM_CEVIR
    MOV SAAT_TXT[0], AH
    MOV SAAT_TXT[1], AL
    
    ; Dakikayi ayarla
    MOV AL, CL
    CALL RAKAM_CEVIR
    MOV SAAT_TXT[3], AH
    MOV SAAT_TXT[4], AL
    
    ; Saniyeyi ayarla
    MOV AL, DH
    CALL RAKAM_CEVIR
    MOV SAAT_TXT[6], AH
    MOV SAAT_TXT[7], AL

    ; --- TARIH ISLEMLERI ---
    ; Tarihi al (DL=Gun, DH=Ay, CX=Yil, AL=Haftanin Gunu)
    MOV AH, 2Ah
    INT 21h
    PUSH AX              ; Gun bilgisini sakla 
    
    ; Gunu yaz DL = gun
    MOV AL, DL
    CALL RAKAM_CEVIR
    MOV TARIH_TXT[0], AH
    MOV TARIH_TXT[1], AL
    
    ; Ayi yaz
    MOV AL, DH
    CALL RAKAM_CEVIR
    MOV TARIH_TXT[3], AH
    MOV TARIH_TXT[4], AL
    
    ; Yili yaz
    MOV AX, CX
    MOV BL, 100
    DIV BL               ; Yili ikiye bol
    MOV CL, AH           ; Yilin son iki hanesi
    MOV AL, CL
    CALL RAKAM_CEVIR
    MOV TARIH_TXT[8], AH
    MOV TARIH_TXT[9], AL
    
    ; yilin ilk iki rakami
    MOV TARIH_TXT[6], '2'
    MOV TARIH_TXT[7], '0'

    ; --- YAZDIRMA KISMI ---
    ; Saati ekrana bas
    LEA DX, SAAT_TXT
    MOV AH, 09h
    INT 21h
    
    ; Araya tire koy
    LEA DX, TIRE
    MOV AH, 09h
    INT 21h
    
    ; Tarihi ekrana bas
    LEA DX, TARIH_TXT
    MOV AH, 09h
    INT 21h
    
    ; Ufak bi bosluk
    MOV AH, 02h
    MOV DL, ' '
    INT 21h

    ; --- GUN ISMI ---
    POP AX               ; Haftanin gununu geri cagirma
    MOV AH, 0
    MOV BL, 10           ; Her kelime 10 harflik yer kapliyor
    MUL BL
    LEA DX, GUNLER
    ADD DX, AX           ; Dogru gunu bul
    MOV AH, 09h
    INT 21h

    ; Bekleme yap (Islemci cok hizli calismasin diye)
    MOV AH, 86h
    MOV CX, 000Fh
    MOV DX, 4240h        ; 1 saniye bekle
    INT 15h

    JMP DONGU            ; Basa don

; Sayilari yaziya ceviren alt program AH=onlar basamagi AL=birler bas.
RAKAM_CEVIR PROC
    AAM                  ; Sayiyi basamaklara ayir
    ADD AH, 30h          ; ASCII koduna cevir
    ADD AL, 30h
    RET
RAKAM_CEVIR ENDP

END BASLA