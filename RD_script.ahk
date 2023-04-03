#NoEnv
#SingleInstance Off
SetControlDelay -1

CoordMode, Mouse , Screen

Wave := 0
WaveType := 4
RDWin := 0
GUIWin := 0

ScreenX0 := 0
ScreenY0 := 0
ScreenX1 := 0
ScreenY1 := 0
ScreenX2 := 0
ScreenY2 := 0
Restart := 0
Time1 := 10000
Time2 := 25000
FxMode1 := 80
FxMode2 := 131
FxMode3 := 311
GxMode := 0
HxMode := 9999
playing := 0
PosSetting := 0
AlwaysOnTop := 0
AutoScreenshot := 0
Ver := "v1.2.0"

step := 1
GuiCreated := 0

steps := Array(Array("進王關，停止充電","已停止充電，正在等小關","等等充對面王","開始充對面王，一邊等小關","偵測到史萊姆，不吸對面王，正在等小關"),Array("進小關，開始充電","已開始充電，正在等王關","已停止充電，正在等王關"),Array("開始了，下一回合才會開始動作"),Array("還沒開始"))


;開始執行程式
;RAlt::

;InputBox, Password, 請輸入密碼, , , 150, 100
;if(Password != 1033){
;    msgbox % "Error 404"
;    ExitApp
;}

if(!GuiCreated=1){
    Gui, Add, Button, x10 y10 gButton4, 指定視窗
    Gui, Add, Text, x80 y15  vNumber9, 0000000000000000000000000000000
    Gui, Add, Button, x10 y30 gButton2 vButton2, 左上定位
    Gui, Add, Button, x80 y30 gButton3 vButton3, 右下定位
    Gui, Add, Button, x150 y30 gButton1, 重新開始
    Gui, Add, Text, x10 y60  vNumber1, 目前第10333333回合
    Gui, Add, Text, x10 y80  vNumber2, 正在把地雷不知道拿到哪裡去那個字都不顯示到底是怎樣

    Gui, Add, Text, x10 y105 , 　吸對面王
    Gui, Add, ComboBox, x80 y100 w50 vDDL2a gAction2a Choose2, 0|80|100|150
    Gui, Add, Text, x135 y105 , ~
    Gui, Add, ComboBox, x145 y100 w50 vDDL2c gAction2c Choose3, 0|203|311|9999
    Gui, Add, Text, x200 y105 , 回

    Gui, Add, Text, x10 y125 , 　充電時間
    Gui, Add, ComboBox, x80 y120 w50 vDDL1 gAction1 Choose2, 6|10
    Gui, Add, Text, x135 y125 , ~
    Gui, Add, ComboBox, x145 y120 w50 vDDL2 gAction2 Choose2, 15|25
    Gui, Add, Text, x200 y125 , 秒

    Gui, Add, ComboBox, x20 y140 w50 vDDL2b gAction2b Choose3, 0|59|203|311|9999
    Gui, Add, Text, x80 y145 , 回開始一王是史王就不吸

    Gui, Add, Text, x10 y165 , 　　吸小怪
    Gui, Add, ComboBox, x80 y160 w50 vDDL3 gAction3 Choose4, 0|203|311|9999
    Gui, Add, Text, x135 y165 , 回以前

    Gui, Add, Button, x10 y180 gButton14, 自動升劍
    Gui, Add, Text, x80 y185 vNumber8, 131、149、167、185 回

    Gui, Add, Button, x10 y200 gButton5, 視窗置頂
    Gui, Add, Text, x80 y205 vNumber11, OFF

    ;Gui, Add, Button, x10 y220 gButton6, 王關截圖
    ;Gui, Add, Text, x80 y225 vNumber12, OFF


    Gui, Add, StatusBar, vBar, 充電腳本 %Ver%　　　　　　By 烏骨雞
    GuiCreated := 1
}
UpdateGui()

loop{
    playing := 0
    while(!Restart){
        UpdateGui()
        sleep 250
    }
    Restart := 0
    if(!RDWin){
        msgbox % "你還沒指定視窗"
        continue
    }
    if(!ScreenX1 || !ScreenX2){
        msgbox % "你還沒定位"
        continue
    }
    InputBox, Wave, Wave, , , 150, 100
    if(!Wave){
        Wave := 0
        continue
    }
    playing := 1
    step := 1 ;"開始了，下一回合才會開始動作"
    WaveType := 3

    while(!NextWave() && !Restart){    ;等待下一回再開始動作
        UpdateGui()
        sleep 250
    }
    if(Restart){
        continue
    }
    Wave += 1
    while(!Restart){
        step := 1
        Run(Wave)
        Wave += 1
    }
    WaveType := 4
    step := 1
    Wave := 0
    UpdateGui()
}
;Return





ConvertX(X){
    global ScreenX0, ScreenX1, ScreenX2
    Return ScreenX0 + ScreenX1 + (ScreenX2 - ScreenX1) * X
}
ConvertY(Y){
    global ScreenY0, ScreenY1, ScreenY2
    Return ScreenY0 + ScreenY1 + (ScreenY2 - ScreenY1) * Y
}


;測試用
;Insert::
;MouseGetPos, X, Y
;msgbox % (X-ScreenX1-ScreenX0)/(ScreenX2-ScreenX1) . ", " . (Y-ScreenY1-ScreenY0)/(ScreenY2-ScreenY1)
;Return

End::
msgbox % GUIWin

Run(Wave){
    global step, WaveType, Restart, Time1, Time2, FxMode1, FxMode2, FxMode3, GxMode, HxMode, ScreenX0, ScreenY0, GUIWin, AutoScreenshot
    t0 := A_TickCount
    SwordLevelUp := 0
    if(GxMode){
        gx := Wave-GxMode
        if(gx=-1||gx=17||gx=35||gx=53){
            SwordLevelUp := 1
        }
        if(gx=0||gx=18||gx=36){
            ClickSword(1)
        }
        if(gx=54||gx=55||gx=56){
            ClickSword(10)
        }
    }
    HaveSlime := 0
    while(!Restart){
        if((Mod(Wave, 2)&&Wave>45)||(Mod(Wave, 5)=0&&Wave<=45)){
            WaveType := 1
        }else{
            WaveType := 2
        }

        t1 := A_TickCount
        dt := t1 - t0
        if(Mod(dt, 250)<20){
            UpdateGui()
            if(WaveType=1 && AutoScreenshot && 6000<dt && dt<6500){
                ControlClick, x1 y1, ahk_id %GUIWin%,,,, Pos
                ;WinActivate, ahk_id %GUIWin%
                ControlSend,, {PrintScreen}, ahk_id %GUIWin%
            }
        }
        if(WaveType = 1){  ;王關
            if(step>=2 && 10000<dt){
                if(NextWave()){
                    Return
                }
            }

            if(step=1){
                Recharge(0, 0)
                if((FxMode1<Wave && FxMode3>Wave && (Mod(Wave-59, 18) || FxMode2>Wave)) || Wave=30){
                    step := 3 ;"等等充對面王"
                }else{
                    step := 2 ;"已停止充電，正在等小關"
                }
                continue
            }
            if(step=3 && Time1 < dt){
                Recharge(1, 0)
                step := 4 ;"開始充對面王"
                continue
            }
            if(step=4 && Time2 < dt){
                Recharge(0, 0)
                step := 2 ;"已停止充電，正在等小關"
                continue
            }
        }
        if(WaveType = 2){  ;小關
            if(step>=2 && 10000<dt){
                if(NextWave()){
                    Return
                }
                continue
            }
            if(step=1){
                if(HxMode>Wave){
                    if(SwordLevelUp){
                        Recharge(0, 0)
                        step := 4 ;"要存錢升劍，先不充"
                        continue
                    }
                    Recharge(1, 0)
                    step := 2 ;"已開始充電，正在等王關"
                }else{
                    Recharge(0, 0)
                    step := 3 ;"已停止充電，正在等王關"
                }
                continue
            }
        }
    }
    Return
}

Action1:
    Gui, Submit, NoHide
    Time1 := DDL1*1000
    return

Action2:
    Gui, Submit, NoHide
    Time2 := DDL2*1000
    return

Action2a:
    Gui, Submit, NoHide
    FxMode1 := DDL2a
    return

Action2b:
    Gui, Submit, NoHide
    FxMode2 := DDL2b
    return

Action2c:
    Gui, Submit, NoHide
    FxMode3 := DDL2c
    return

Action3:
    Gui, Submit, NoHide
    HxMode := DDL3
    return

Action4:
    if(!RDWin){
        msgbox % "你還沒指定視窗"
        Return
    }
    AlwaysOnTop := 1 - AlwaysOnTop
    if(AlwaysOnTop){
        Winset, Alwaysontop, 1, ahk_id %RDWin%
    }else{
        Winset, Alwaysontop, 0, ahk_id %RDWin%
    }
    Return

Button1:
    Restart := 1
    Return

Button2:
    if(!RDWin){
        msgbox % "你還沒指定視窗"
        Return
    }
    PosSetting := 1
    UpdateGui()

    WinGetPos wx, wy, ww, wh, ahk_id %RDWin%
    ScreenX0 := wx
    ScreenY0 := wy

    KeyWait, LButton, D
    MouseGetPos, ScreenX1, ScreenY1

    ScreenX1 -= ScreenX0
    ScreenY1 -= ScreenY0

    PosSetting := 0
    UpdateGui()
    Return

Button3:
    if(!RDWin){
        msgbox % "你還沒指定視窗"
        Return
    }
    PosSetting := 2
    UpdateGui()

    WinGetPos wx, wy, ww, wh, ahk_id %RDWin%
    ScreenX0 := wx
    ScreenY0 := wy

    KeyWait, LButton, D
    MouseGetPos, ScreenX2, ScreenY2

    ScreenX2 -= ScreenX0
    ScreenY2 -= ScreenY0

    PosSetting := 0
    UpdateGui()
    Return

Button4:
    WinGet, GUIWin, ID, A
    RDWin := -1
    UpdateGui()
    KeyWait, LButton, D
    WinGet, RDWin, ID, A

    WinGetPos wx, wy, ww, wh, ahk_id %RDWin%
    ScreenX0 := wx
    ScreenY0 := wy
    ;ScreenX1 := wx + ww * 0.085
    ;ScreenY1 := wy + wh * 0.008
    ;ScreenX2 := wx + ww * 0.975
    ;ScreenY2 := wy + wh * 0.423
    
    Return

Button5:
    if(!RDWin){
        msgbox % "你還沒指定視窗"
        Return
    }
    AlwaysOnTop := 1 - AlwaysOnTop
    if(AlwaysOnTop){
        Winset, Alwaysontop, 1, ahk_id %RDWin%
    }else{
        Winset, Alwaysontop, 0, ahk_id %RDWin%
    }
    Return

Button6:
    AutoScreenshot := 1 - AutoScreenshot

Button11:
    if(!ScreenX1 || !ScreenX2 || RDWin){
        return
    }
    ClickSword(5)
    Return

Button14:
    if(GxMode=77){
        GxMode := 0
    }else if(GxMode=0){
        GxMode := 113
    }else{
        GxMode -= 18
    }
    Return


NextWave(){
    Return NextWaveL() && NextWaveR()
}
NextWaveL(){
    Return Detector(0.07, 0.98, 0.10, 1.02, 0x171717)
}
NextWaveR(){
    Return Detector(0.90, 0.98, 0.93, 1.02, 0x171717)
}

FindSlime(){
    Return Detector(-0.05, 0.05, 0.05, 1.05, 0xaed023, 2)
}

RechargeType(){   ; 0是不能按，1是充電，2是放電
    t := 0
    if(Detector(0.22, 2.17, 0.34, 2.29, 0xd4dbc2)!=0){
        t := 1
    }
    if(Detector(0.22, 2.17, 0.34, 2.29, 0xfb6451)!=0){
        t := 2
    }
    return t
}

;m=1是充電，m=0是放電，a=1是一邊偵測下一回合了沒
Recharge(m, a:=1){
    global Restart
    sleep 100
    loop{
        t := RechargeType()
        if(m && t=1){
            break
        }
        if(!m && t=2){
            break
        }
        if(t!=0){
            ClickRecharge()
        }
        if((a&&NextWave())||Restart){
            Return
        }
    }
    Return
}

ClickRecharge(){
    global RDWin, ScreenX0, ScreenY0
    cx := ConvertX(0.28) - ScreenX0
    cy := ConvertY(2.23) - ScreenY0
    
    ControlClick, x%cx% y%cy%, ahk_id %RDWin%,,,, Pos
    Return
}

ClickSword(n:=1){
    global RDWin, ScreenX0, ScreenY0
    cx := ConvertX(0.67) - ScreenX0
    cy := ConvertY(2.23) - ScreenY0
    loop % n{
        ControlClick, x%cx% y%cy%, ahk_id %RDWin%,,,, Pos
        sleep 100
    }
    Return
}



;在(X1,Y1)與(X2,Y2)之間找顏色為Color的點
Detector(X1, Y1, X2, Y2, Color, S:=6){
    global ScreenX0, ScreenX1, ScreenX2
    if(!ScreenX0 || !ScreenX1 || !ScreenX2){
        Return 0
    }
    CoordMode Pixel
    X1 := ConvertX(X1)
    Y1 := ConvertY(Y1)
    X2 := ConvertX(X2)
    Y2 := ConvertY(Y2)
    PixelSearch, __FoundX, __FoundY, X1, Y1, X2, Y2, Color,S,Fast RGB
    CoordMode Mouse
    
    Return (ErrorLevel=0)
}

UpdateGui(){
    global Wave, WaveType, steps, step, ScreenX0, ScreenY0, GxMode, RDWin, PosSetting, AlwaysOnTop, AutoScreenshot, HaveSlime
    if(RDWin){
        WinGetPos wx, wy, ww, wh, ahk_id %RDWin%
        ScreenX0 := wx
        ScreenY0 := wy
    }
    text1 := steps[WaveType][step]
    GuiControl,, Number1, 目前第 %Wave% 回合
    GuiControl,, Number2, %text1%

    a := GxMode
    b := a+18
    c := a+36
    d := a+54
    if(a){
        GuiControl,, Number8, %a%、%b%、%c%、%d% 回
    }else{
        GuiControl,, Number8, OFF
    }
    
    a := RDWin
    if(a=0){
        GuiControl,, Number9, 尚未設定
    }else if(a=-1){
        GuiControl,, Number9, 請點選模擬器視窗
    }else{
        WinGetTitle, a, ahk_id %a%
        GuiControl,, Number9, %a%
    }

    a := PosSetting
    if(a=0){
        GuiControl,, Button2, 左上定位
        GuiControl,, Button3, 右下定位
    }
    if(a=1){
        GuiControl,, Button2, 設定中
    }
    if(a=2){
        GuiControl,, Button3, 設定中
    }

    a := ["OFF","ON"][AlwaysOnTop+1]
    GuiControl,, Number11, %a%

    a := ["OFF","ON"][AutoScreenshot+1]
    GuiControl,, Number12, %a%

    a := ["無","有"][HaveSlime+1]
    GuiControl,, Number13, %a%


    Gui, Show, w225 h255 NA, 充電腳本
    Return
}

GuiClose:
ExitApp
