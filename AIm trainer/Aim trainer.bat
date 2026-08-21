@echo off
set "BASE=%~dp0"

powershell.exe -NoProfile -ExecutionPolicy Bypass -Command ^
"$basePath=$env:BASE; ^
$bgImagePath=Join-Path $basePath 'vky.png'; ^
Add-Type -AssemblyName System.Windows.Forms; ^
Add-Type -AssemblyName System.Drawing; ^

$f=New-Object Windows.Forms.Form; ^
$f.Text='Aim Trainer'; ^
$f.FormBorderStyle='None'; ^
$f.WindowState='Maximized'; ^
$f.BackColor=[Drawing.Color]::FromArgb(8,10,16); ^
$f.KeyPreview=$true; ^

$score=0; ^
$time=30; ^
$mode=''; ^
$playing=$false; ^
$rnd=New-Object Random; ^

$ballSize=65; ^
$ballColorName='RED'; ^
$ballColor=[Drawing.Color]::FromArgb(255,55,75); ^

$dark=[Drawing.Color]::FromArgb(8,10,16); ^
$panelColor=[Drawing.Color]::FromArgb(18,22,32); ^
$buttonColor=[Drawing.Color]::FromArgb(30,36,50); ^
$white=[Drawing.Color]::White; ^
$gray=[Drawing.Color]::FromArgb(165,175,190); ^
$accent=[Drawing.Color]::FromArgb(255,55,75); ^

$menu=New-Object Windows.Forms.Panel; ^
$menu.Dock='Fill'; ^
$menu.BackColor=$dark; ^
$f.Controls.Add($menu); ^

if(Test-Path $bgImagePath){ ^
    try{ ^
        $menu.BackgroundImage=[Drawing.Image]::FromFile($bgImagePath); ^
        $menu.BackgroundImageLayout='Zoom' ^
    }catch{} ^
}; ^

$shade=New-Object Windows.Forms.Panel; ^
$shade.Dock='Fill'; ^
$shade.BackColor=[Drawing.Color]::FromArgb(130,5,8,14); ^
$menu.Controls.Add($shade); ^

$card=New-Object Windows.Forms.Panel; ^
$card.Width=560; ^
$card.Height=650; ^
$card.BackColor=[Drawing.Color]::FromArgb(245,12,16,25); ^
$card.Location=New-Object Drawing.Point(50,50); ^
$menu.Controls.Add($card); ^
$card.BringToFront(); ^

$title=New-Object Windows.Forms.Label; ^
$title.Text='AIM TRAINER'; ^
$title.ForeColor=$white; ^
$title.BackColor=[Drawing.Color]::Transparent; ^
$title.Font=New-Object Drawing.Font('Segoe UI',38,[Drawing.FontStyle]::Bold); ^
$title.AutoSize=$true; ^
$title.Location=New-Object Drawing.Point(40,30); ^
$card.Controls.Add($title); ^

$subtitle=New-Object Windows.Forms.Label; ^
$subtitle.Text='PRECISION  /  REACTION  /  TRACKING'; ^
$subtitle.ForeColor=$gray; ^
$subtitle.Font=New-Object Drawing.Font('Segoe UI',10,[Drawing.FontStyle]::Bold); ^
$subtitle.AutoSize=$true; ^
$subtitle.Location=New-Object Drawing.Point(43,88); ^
$card.Controls.Add($subtitle); ^

$line=New-Object Windows.Forms.Panel; ^
$line.Width=480; ^
$line.Height=3; ^
$line.BackColor=$accent; ^
$line.Location=New-Object Drawing.Point(40,120); ^
$card.Controls.Add($line); ^

$settings=New-Object Windows.Forms.Panel; ^
$settings.Dock='Fill'; ^
$settings.BackColor=$dark; ^
$settings.Visible=$false; ^
$f.Controls.Add($settings); ^

$settingsCard=New-Object Windows.Forms.Panel; ^
$settingsCard.Width=600; ^
$settingsCard.Height=680; ^
$settingsCard.BackColor=$panelColor; ^
$settingsCard.Location=New-Object Drawing.Point(50,40); ^
$settings.Controls.Add($settingsCard); ^

$settingsTitle=New-Object Windows.Forms.Label; ^
$settingsTitle.Text='SETTINGS'; ^
$settingsTitle.ForeColor=$white; ^
$settingsTitle.Font=New-Object Drawing.Font('Segoe UI',34,[Drawing.FontStyle]::Bold); ^
$settingsTitle.AutoSize=$true; ^
$settingsTitle.Location=New-Object Drawing.Point(40,30); ^
$settingsCard.Controls.Add($settingsTitle); ^

$credits=New-Object Windows.Forms.Panel; ^
$credits.Dock='Fill'; ^
$credits.BackColor=$dark; ^
$credits.Visible=$false; ^
$f.Controls.Add($credits); ^

if(Test-Path $bgImagePath){ ^
    try{ ^
        $credits.BackgroundImage=[Drawing.Image]::FromFile($bgImagePath); ^
        $credits.BackgroundImageLayout='Zoom' ^
    }catch{} ^
}; ^

$creditsShade=New-Object Windows.Forms.Panel; ^
$creditsShade.Dock='Fill'; ^
$creditsShade.BackColor=[Drawing.Color]::FromArgb(130,5,8,14); ^
$credits.Controls.Add($creditsShade); ^

$creditsCard=New-Object Windows.Forms.Panel; ^
$creditsCard.Width=700; ^
$creditsCard.Height=500; ^
$creditsCard.BackColor=$panelColor; ^
$creditsCard.Location=New-Object Drawing.Point(50,50); ^
$credits.Controls.Add($creditsCard); ^

$creditsTitle=New-Object Windows.Forms.Label; ^
$creditsTitle.Text='CREDITS'; ^
$creditsTitle.ForeColor=$white; ^
$creditsTitle.Font=New-Object Drawing.Font('Segoe UI',38,[Drawing.FontStyle]::Bold); ^
$creditsTitle.AutoSize=$true; ^
$creditsTitle.Location=New-Object Drawing.Point(45,40); ^
$creditsCard.Controls.Add($creditsTitle); ^

$credit1=New-Object Windows.Forms.Label; ^
$credit1.Text='Koodi : Puustinen (ChatGPT)'; ^
$credit1.ForeColor=$white; ^
$credit1.Font=New-Object Drawing.Font('Segoe UI',20,[Drawing.FontStyle]::Bold); ^
$credit1.AutoSize=$true; ^
$credit1.Location=New-Object Drawing.Point(50,160); ^
$creditsCard.Controls.Add($credit1); ^

$credit2=New-Object Windows.Forms.Label; ^
$credit2.Text='Kuva: Heiskanen (ChatGPT)'; ^
$credit2.ForeColor=$white; ^
$credit2.Font=New-Object Drawing.Font('Segoe UI',20,[Drawing.FontStyle]::Bold); ^
$credit2.AutoSize=$true; ^
$credit2.Location=New-Object Drawing.Point(50,220); ^
$creditsCard.Controls.Add($credit2); ^

$scoreLabel=New-Object Windows.Forms.Label; ^
$scoreLabel.Text='SCORE: 0'; ^
$scoreLabel.ForeColor=$white; ^
$scoreLabel.BackColor=[Drawing.Color]::FromArgb(220,15,19,29); ^
$scoreLabel.Font=New-Object Drawing.Font('Segoe UI',18,[Drawing.FontStyle]::Bold); ^
$scoreLabel.AutoSize=$true; ^
$scoreLabel.Padding=New-Object Windows.Forms.Padding(15,8,15,8); ^
$scoreLabel.Location=New-Object Drawing.Point(20,20); ^
$f.Controls.Add($scoreLabel); ^
$scoreLabel.Visible=$false; ^

$gameClock=New-Object Windows.Forms.Timer; ^
$gameClock.Interval=100; ^

$trackingClock=New-Object Windows.Forms.Timer; ^
$trackingClock.Interval=16; ^

$trackingPoints=New-Object Windows.Forms.Timer; ^
$trackingPoints.Interval=100; ^

function ClearBalls { ^
    foreach($c in @($f.Controls)){ ^
        if($c -is [Windows.Forms.Button] -and $c.Tag -ne $null){ ^
            $f.Controls.Remove($c); ^
            $c.Dispose(); ^
        } ^
    } ^
}; ^

function NewBall { ^
    $b=New-Object Windows.Forms.Button; ^
    $b.Width=$ballSize; ^
    $b.Height=$ballSize; ^
    $b.Text=''; ^
    $b.FlatStyle='Flat'; ^
    $b.FlatAppearance.BorderSize=0; ^
    $b.BackColor=$ballColor; ^
    $b.Tag='ball'; ^
    $b.Cursor=[Windows.Forms.Cursors]::Hand; ^

    $path=New-Object Drawing.Drawing2D.GraphicsPath; ^
    $path.AddEllipse(0,0,$ballSize,$ballSize); ^
    $b.Region=New-Object Drawing.Region($path); ^

    $mx=[Math]::Max(20,$f.ClientSize.Width-$ballSize-20); ^
    $my=[Math]::Max(100,$f.ClientSize.Height-$ballSize-20); ^

    $b.Location=New-Object Drawing.Point( ^
        $rnd.Next(10,$mx), ^
        $rnd.Next(90,$my) ^
    ); ^

    $b.Add_Click({ ^
        param($sender,$e); ^

        if($script:playing -and $script:mode -ne 'tracking'){ ^

            $script:score++; ^

            if($script:mode -eq '30'){ ^
                $scoreLabel.Text='SCORE: '+$script:score+'     TIME: '+([Math]::Round($script:time,1)) ^
            } ^
            else { ^
                $scoreLabel.Text='SCORE: '+$script:score+'     TIME: INFINITE' ^
            }; ^

            $f.Controls.Remove($sender); ^
            $sender.Dispose(); ^
            NewBall ^
        } ^
    }); ^

    $f.Controls.Add($b); ^
    $b.BringToFront(); ^
    $scoreLabel.BringToFront(); ^

    return $b ^
}; ^

function ShowMenu { ^
    $gameClock.Stop(); ^
    $trackingClock.Stop(); ^
    $trackingPoints.Stop(); ^
    $script:playing=$false; ^
    ClearBalls; ^
    $scoreLabel.Visible=$false; ^
    $settings.Visible=$false; ^
    $credits.Visible=$false; ^
    $menu.Visible=$true; ^
    $card.BringToFront(); ^
    $f.Activate() ^
}; ^

function ShowSettings { ^
    $gameClock.Stop(); ^
    $trackingClock.Stop(); ^
    $trackingPoints.Stop(); ^
    $script:playing=$false; ^
    ClearBalls; ^
    $scoreLabel.Visible=$false; ^
    $menu.Visible=$false; ^
    $credits.Visible=$false; ^
    $settings.Visible=$true; ^
    $settingsCard.BringToFront(); ^
    $f.Activate() ^
}; ^

function ShowCredits { ^
    $gameClock.Stop(); ^
    $trackingClock.Stop(); ^
    $trackingPoints.Stop(); ^
    $script:playing=$false; ^
    ClearBalls; ^
    $scoreLabel.Visible=$false; ^
    $menu.Visible=$false; ^
    $settings.Visible=$false; ^
    $credits.Visible=$true; ^
    $creditsCard.BringToFront(); ^
    $f.Activate() ^
}; ^

function StartGame($m) { ^
    $gameClock.Stop(); ^
    $trackingClock.Stop(); ^
    $trackingPoints.Stop(); ^
    ClearBalls; ^

    $script:score=0; ^
    $script:mode=$m; ^
    $script:playing=$true; ^
    $script:time=30; ^

    $menu.Visible=$false; ^
    $settings.Visible=$false; ^
    $credits.Visible=$false; ^
    $scoreLabel.Visible=$true; ^

    if($m -eq '30'){ ^
        $scoreLabel.Text='SCORE: 0     TIME: 30.0' ^
    } ^
    elseif($m -eq 'tracking'){ ^
        $scoreLabel.Text='SCORE: 0     TRACKING' ^
    } ^
    else { ^
        $scoreLabel.Text='SCORE: 0     TIME: INFINITE' ^
    }; ^

    $b=NewBall; ^

    if($m -eq 'tracking'){ ^

        $v=New-Object Drawing.Point( ^
            $rnd.Next(-16,17), ^
            $rnd.Next(-16,17) ^
        ); ^

        if($v.X -eq 0){$v.X=8}; ^
        if($v.Y -eq 0){$v.Y=8}; ^

        $b.Tag=$v; ^
        $trackingClock.Start(); ^
        $trackingPoints.Start() ^

    } ^
    elseif($m -eq '30'){ ^
        $gameClock.Start() ^
    }; ^

    $f.Activate() ^
}; ^

function MenuButton($text,$y,$action) { ^

    $b=New-Object Windows.Forms.Button; ^
    $b.Text=$text; ^
    $b.Font=New-Object Drawing.Font('Segoe UI',14,[Drawing.FontStyle]::Bold); ^
    $b.ForeColor=$white; ^
    $b.BackColor=$buttonColor; ^
    $b.FlatStyle='Flat'; ^
    $b.FlatAppearance.BorderSize=0; ^
    $b.Width=480; ^
    $b.Height=58; ^
    $b.Location=New-Object Drawing.Point(40,$y); ^
    $b.Cursor=[Windows.Forms.Cursors]::Hand; ^

    $b.Add_MouseEnter({ ^
        $this.BackColor=[Drawing.Color]::FromArgb(45,53,70) ^
    }); ^

    $b.Add_MouseLeave({ ^
        $this.BackColor=[Drawing.Color]::FromArgb(30,36,50) ^
    }); ^

    $b.Add_Click($action); ^
    $card.Controls.Add($b); ^
    $b.BringToFront(); ^

    return $b ^
}; ^

function SettingsButton($text,$y,$action) { ^

    $b=New-Object Windows.Forms.Button; ^
    $b.Text=$text; ^
    $b.Font=New-Object Drawing.Font('Segoe UI',14,[Drawing.FontStyle]::Bold); ^
    $b.ForeColor=$white; ^
    $b.BackColor=$buttonColor; ^
    $b.FlatStyle='Flat'; ^
    $b.FlatAppearance.BorderSize=0; ^
    $b.Width=500; ^
    $b.Height=58; ^
    $b.Location=New-Object Drawing.Point(40,$y); ^
    $b.Cursor=[Windows.Forms.Cursors]::Hand; ^
    $b.Add_Click($action); ^
    $settingsCard.Controls.Add($b); ^
    $b.BringToFront(); ^

    return $b ^
}; ^

function UpdateColorButtons { ^

    if($script:ballColorName -eq 'RED'){ ^
        $redButton.Text='SELECTED  -  RED'; ^
        $redButton.BackColor=[Drawing.Color]::FromArgb(130,55,35,45); ^
        $redButton.FlatAppearance.BorderColor=$accent; ^
        $redButton.FlatAppearance.BorderSize=2 ^
    } ^
    else { ^
        $redButton.Text='RED'; ^
        $redButton.BackColor=$buttonColor; ^
        $redButton.FlatAppearance.BorderSize=0 ^
    }; ^

    if($script:ballColorName -eq 'BLUE'){ ^
        $blueButton.Text='SELECTED  -  BLUE'; ^
        $blueButton.BackColor=[Drawing.Color]::FromArgb(30,70,125); ^
        $blueButton.FlatAppearance.BorderColor=[Drawing.Color]::FromArgb(70,140,255); ^
        $blueButton.FlatAppearance.BorderSize=2 ^
    } ^
    else { ^
        $blueButton.Text='BLUE'; ^
        $blueButton.BackColor=$buttonColor; ^
        $blueButton.FlatAppearance.BorderSize=0 ^
    }; ^

    if($script:ballColorName -eq 'GREEN'){ ^
        $greenButton.Text='SELECTED  -  GREEN'; ^
        $greenButton.BackColor=[Drawing.Color]::FromArgb(25,100,60); ^
        $greenButton.FlatAppearance.BorderColor=[Drawing.Color]::FromArgb(60,220,110); ^
        $greenButton.FlatAppearance.BorderSize=2 ^
    } ^
    else { ^
        $greenButton.Text='GREEN'; ^
        $greenButton.BackColor=$buttonColor; ^
        $greenButton.FlatAppearance.BorderSize=0 ^
    } ^
}; ^

MenuButton '30 SECONDS' 145 {StartGame '30'}; ^
MenuButton 'PRACTICE - INFINITE TIME' 215 {StartGame 'practice'}; ^
MenuButton 'TRACKING' 285 {StartGame 'tracking'}; ^
MenuButton 'SETTINGS' 355 {ShowSettings}; ^
MenuButton 'CREDITS' 425 {ShowCredits}; ^
MenuButton 'EXIT' 495 {$f.Close()}; ^

$sizeLabel=New-Object Windows.Forms.Label; ^
$sizeLabel.Text='BALL SIZE     '+$ballSize; ^
$sizeLabel.ForeColor=$gray; ^
$sizeLabel.Font=New-Object Drawing.Font('Segoe UI',12,[Drawing.FontStyle]::Bold); ^
$sizeLabel.AutoSize=$true; ^
$sizeLabel.Location=New-Object Drawing.Point(40,105); ^
$settingsCard.Controls.Add($sizeLabel); ^

$sizeTrack=New-Object Windows.Forms.TrackBar; ^
$sizeTrack.Minimum=30; ^
$sizeTrack.Maximum=120; ^
$sizeTrack.Value=$ballSize; ^
$sizeTrack.TickFrequency=10; ^
$sizeTrack.Width=500; ^
$sizeTrack.Location=New-Object Drawing.Point(35,135); ^
$sizeTrack.Add_ValueChanged({ ^
    $script:ballSize=$sizeTrack.Value; ^
    $sizeLabel.Text='BALL SIZE     '+$script:ballSize ^
}); ^
$settingsCard.Controls.Add($sizeTrack); ^

$colorLabel=New-Object Windows.Forms.Label; ^
$colorLabel.Text='BALL COLOR'; ^
$colorLabel.ForeColor=$gray; ^
$colorLabel.Font=New-Object Drawing.Font('Segoe UI',12,[Drawing.FontStyle]::Bold); ^
$colorLabel.AutoSize=$true; ^
$colorLabel.Location=New-Object Drawing.Point(40,205); ^
$settingsCard.Controls.Add($colorLabel); ^

$redButton=SettingsButton 'SELECTED  -  RED' 235 { ^
    $script:ballColorName='RED'; ^
    $script:ballColor=[Drawing.Color]::FromArgb(255,55,75); ^
    UpdateColorButtons ^
}; ^

$blueButton=SettingsButton 'BLUE' 305 { ^
    $script:ballColorName='BLUE'; ^
    $script:ballColor=[Drawing.Color]::FromArgb(50,130,255); ^
    UpdateColorButtons ^
}; ^

$greenButton=SettingsButton 'GREEN' 375 { ^
    $script:ballColorName='GREEN'; ^
    $script:ballColor=[Drawing.Color]::FromArgb(50,220,100); ^
    UpdateColorButtons ^
}; ^

SettingsButton 'BACK TO MENU' 475 {ShowMenu}; ^

$creditsBack=New-Object Windows.Forms.Button; ^
$creditsBack.Text='BACK TO MENU'; ^
$creditsBack.Font=New-Object Drawing.Font('Segoe UI',14,[Drawing.FontStyle]::Bold); ^
$creditsBack.ForeColor=$white; ^
$creditsBack.BackColor=$buttonColor; ^
$creditsBack.FlatStyle='Flat'; ^
$creditsBack.FlatAppearance.BorderSize=0; ^
$creditsBack.Width=600; ^
$creditsBack.Height=58; ^
$creditsBack.Location=New-Object Drawing.Point(45,350); ^
$creditsBack.Cursor=[Windows.Forms.Cursors]::Hand; ^
$creditsBack.Add_MouseEnter({ ^
    $this.BackColor=[Drawing.Color]::FromArgb(45,53,70) ^
}); ^
$creditsBack.Add_MouseLeave({ ^
    $this.BackColor=[Drawing.Color]::FromArgb(30,36,50) ^
}); ^
$creditsBack.Add_Click({ShowMenu}); ^
$creditsCard.Controls.Add($creditsBack); ^

UpdateColorButtons; ^

$gameClock.Add_Tick({ ^

    if(!$script:playing){return}; ^

    if($script:mode -eq '30'){ ^

        $script:time-=0.1; ^

        if($script:time -le 0){ ^

            $script:time=0; ^
            $script:playing=$false; ^
            $gameClock.Stop(); ^
            ClearBalls; ^
            $scoreLabel.Visible=$false; ^

            [Windows.Forms.MessageBox]::Show( ^
                'TIME IS UP!`n`nSCORE: '+$script:score, ^
                'Aim Trainer' ^
            ); ^

            ShowMenu ^

        } ^
        else { ^
            $scoreLabel.Text='SCORE: '+$script:score+'     TIME: '+([Math]::Round($script:time,1)) ^
        } ^
    } ^
}); ^

$trackingClock.Add_Tick({ ^

    if(!$script:playing -or $script:mode -ne 'tracking'){return}; ^

    $ball=$null; ^

    foreach($c in @($f.Controls)){ ^
        if($c -is [Windows.Forms.Button] -and $c.Tag -is [Drawing.Point]){ ^
            $ball=$c; ^
            break ^
        } ^
    }; ^

    if($null -ne $ball){ ^

        $v=$ball.Tag; ^
        $ball.Left+=$v.X; ^
        $ball.Top+=$v.Y; ^

        if($ball.Left -le 0){ ^
            $ball.Left=0; ^
            $v.X=[Math]::Abs($v.X) ^
        }; ^

        if($ball.Left+$ball.Width -ge $f.ClientSize.Width){ ^
            $ball.Left=$f.ClientSize.Width-$ball.Width; ^
            $v.X=-[Math]::Abs($v.X) ^
        }; ^

        if($ball.Top -le 80){ ^
            $ball.Top=80; ^
            $v.Y=[Math]::Abs($v.Y) ^
        }; ^

        if($ball.Top+$ball.Height -ge $f.ClientSize.Height){ ^
            $ball.Top=$f.ClientSize.Height-$ball.Height; ^
            $v.Y=-[Math]::Abs($v.Y) ^
        }; ^

        $ball.Tag=$v ^
    } ^
}); ^

$trackingPoints.Add_Tick({ ^

    if(!$script:playing -or $script:mode -ne 'tracking'){return}; ^

    $ball=$null; ^

    foreach($c in @($f.Controls)){ ^
        if($c -is [Windows.Forms.Button] -and $c.Tag -is [Drawing.Point]){ ^
            $ball=$c; ^
            break ^
        } ^
    }; ^

    if($null -ne $ball){ ^

        $mouse=$f.PointToClient([Windows.Forms.Cursor]::Position); ^
        $centerX=$ball.Left+($ball.Width/2); ^
        $centerY=$ball.Top+($ball.Height/2); ^
        $dx=$mouse.X-$centerX; ^
        $dy=$mouse.Y-$centerY; ^

        if(($dx*$dx)+($dy*$dy) -le ($ball.Width/2)*($ball.Width/2)){ ^
            $script:score++; ^
            $scoreLabel.Text='SCORE: '+$script:score+'     TRACKING' ^
        } ^
    } ^
}); ^

$f.Add_KeyDown({ ^

    if($_.KeyCode -eq 'Escape'){ ^

        $gameClock.Stop(); ^
        $trackingClock.Stop(); ^
        $trackingPoints.Stop(); ^

        $script:playing=$false; ^

        ClearBalls; ^

        $scoreLabel.Visible=$false; ^
        $settings.Visible=$false; ^
        $credits.Visible=$false; ^
        $menu.Visible=$true; ^

        $card.BringToFront(); ^
        $f.Activate() ^
    } ^
}); ^

$f.Add_Shown({ ^
    $f.Activate(); ^
    $card.BringToFront() ^
}); ^

[void]$f.ShowDialog()"

endlocal
