param(
$AppName = "KN-GameStation",
$WavBannerPath = "269595.wav",
$PictureBannerPath = 'Dwarfmini.png',
$Script:CountDown = 10
)

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing


 Function ClearAndClose()
 {
    $Timer.Stop(); 
    $Form.Close();
    $PlayWav.Stop();
    $Form.Dispose();
    $Timer.Dispose();    
    $Script:CountDown=15
   
 }

 Function Button_Click()
 {
    ClearAndClose
 }

 Function Timer_Tick()
 {
     $Label.Text = "$Script:CountDown" #"Your system will reboot in $Script:CountDown seconds"
         --$Script:CountDown
         if ($Script:CountDown -lt 0)
         {
           $form.DialogResult = 'Ok'
           ClearAndClose
         }
 }

function Box_Banner {
param(
$BoxText = "" #KibilNala - GameStation"
)
$form = New-Object System.Windows.Forms.Form
$form.Text = $AppName
$form.Size = New-Object System.Drawing.Size(400,400)
$form.StartPosition = 'CenterScreen'

$okButton = New-Object System.Windows.Forms.Button
$okButton.Location = New-Object System.Drawing.Point(20,320)
$okButton.Size = New-Object System.Drawing.Size(50,23)
$okButton.Text = 'OK'
$okButton.DialogResult = [System.Windows.Forms.DialogResult]::Ok
$form.AcceptButton = $okButton
$form.Controls.Add($okButton)

$cancelButton = New-Object System.Windows.Forms.Button
$cancelButton.Location = New-Object System.Drawing.Point(320,320)
$cancelButton.Size = New-Object System.Drawing.Size(50,23)
$cancelButton.Text = 'Quit'
$cancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
$form.CancelButton = $cancelButton
$form.Controls.Add($cancelButton)

$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(10,20)
$label.Size = New-Object System.Drawing.Size(280,20)
$label.Text = $BoxText
$form.Controls.Add($label)

$file = (get-item $PictureBannerPath -ErrorAction SilentlyContinue)
If($file)
{
$img = [System.Drawing.Image]::Fromfile($file);
$pictureBox = new-object Windows.Forms.PictureBox
$pictureBox.Location = New-Object System.Drawing.Point(70,41)
$pictureBox.Width =  $img.Size.Width;
$pictureBox.Height =  $img.Size.Height;
$pictureBox.Image = $img;
$form.controls.add($pictureBox)
$form.Add_Shown( { $form.Activate() } )
}
##
 $Timer = New-Object System.Windows.Forms.Timer
 $Timer.Interval = 1000

# $Script:CountDown = 2

 $okButton.Add_Click({Button_Click})
 $cancelButton.Add_Click({Button_Click})
 $Timer.Add_Tick({Timer_Tick})


$Timer.Start() ## Demarrer le timer

$form.Topmost = $true

$PlayWav=New-Object System.Media.SoundPlayer
$PlayWav.SoundLocation= $(get-item $WavBannerPath).FullName
$PlayWav.Load()
$PlayWav.PlayLooping()

$result_Menu01 = $($form).ShowDialog()

Switch ($result_Menu01)
{
OK{} #$PlayWav.Stop();$Timer.Stop();Exit}
Cancel{ClearAndClose;exit} #$PlayWav.Stop();$Timer.Stop()}
Default{"default"}
}
}

function Box_MenuEmuls {
param(
$BoxText = "Choose your station",
$Path = $PSScriptRoot + "\EMULS"
)
$form = New-Object System.Windows.Forms.Form
$form.Text = $AppName
$form.Size = New-Object System.Drawing.Size(300,200)
$form.StartPosition = 'CenterScreen'

$okButton = New-Object System.Windows.Forms.Button
$okButton.Location = New-Object System.Drawing.Point(70,120)
$okButton.Size = New-Object System.Drawing.Size(50,23)
$okButton.Text = 'OK'
$okButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
$form.AcceptButton = $okButton
$form.Controls.Add($okButton)

$cancelButton = New-Object System.Windows.Forms.Button
$cancelButton.Location = New-Object System.Drawing.Point(170,120)
$cancelButton.Size = New-Object System.Drawing.Size(50,23)
$cancelButton.Text = 'Quit'
$cancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
$form.CancelButton = $cancelButton
$form.Controls.Add($cancelButton)

$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(10,20)
$label.Size = New-Object System.Drawing.Size(280,20)
$label.Text = $BoxText
$form.Controls.Add($label)

$listBox = New-Object System.Windows.Forms.ListBox
$listBox.Location = New-Object System.Drawing.Point(10,40)
$listBox.Size = New-Object System.Drawing.Size(260,20)
$listBox.Height = 80
Get-ChildItem $Path | %{[void] $listBox.Items.Add($_.BaseName)}

Do{
#$listBox.SelectedItem = $listBox[0]
$form.Controls.Add($listBox)

$form.Topmost = $true

$result_Menu01 = $($form).ShowDialog()
Switch ($result_Menu01)
{
OK{$x = $listBox.SelectedItem}
Cancel{Exit}
Default{}
}
}
Until($x)
$x
}

function Box_MenuRoms {
param(
[parameter(Mandatory=$true, Position = 0)][string]$Emul,
#[parameter(Mandatory=$true)][string]$Emulexe = ,
$BoxText =  "Choisis ton jeu",
$PathEmul = $PSScriptRoot + "\EMULS\$Emul",
#$Emulexe = $(Get-ChildItem -Path $PathEmul | ?{$_.Extension -eq ".exe"}),
$PathRoms = $PathEmul + "\ROMS"
)
$form = New-Object System.Windows.Forms.Form
$form.Text = $AppName
$form.Size = New-Object System.Drawing.Size(300,200)
$form.StartPosition = 'CenterScreen'

$okButton = New-Object System.Windows.Forms.Button
$okButton.Location = New-Object System.Drawing.Point(70,120)
$okButton.Size = New-Object System.Drawing.Size(50,23)
$okButton.Text = 'OK'
$okButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
$form.AcceptButton = $okButton
$form.Controls.Add($okButton)

$backButton = New-Object System.Windows.Forms.Button
$backButton.Location = New-Object System.Drawing.Point(120,120)
$backButton.Size = New-Object System.Drawing.Size(50,23)
$backButton.Text = 'Back'
$backButton.DialogResult = [System.Windows.Forms.DialogResult]::Ignore
#$form.AcceptButton = $backButton
$form.Controls.Add($backButton)

$cancelButton = New-Object System.Windows.Forms.Button
$cancelButton.Location = New-Object System.Drawing.Point(170,120)
$cancelButton.Size = New-Object System.Drawing.Size(50,23)
$cancelButton.Text = 'Quit'
$cancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
$form.CancelButton = $cancelButton
$form.Controls.Add($cancelButton)

$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(10,20)
$label.Size = New-Object System.Drawing.Size(280,20)
$label.Text = $BoxText
$form.Controls.Add($label)

$listBox = New-Object System.Windows.Forms.ListBox
$listBox.Location = New-Object System.Drawing.Point(10,40)
$listBox.Size = New-Object System.Drawing.Size(260,20)
$listBox.Height = 80
$RomsList = Get-ChildItem $PathRoms | ?{$_.Extension -eq ".smc"}
$RomsList | %{[void] $listBox.Items.Add($_.BaseName)}
Do{
$listBox.SelectedItem = $null
$form.Controls.Add($listBox)

$form.Topmost = $true
$result_Menu01 = $($form).ShowDialog()
Switch ($result_Menu01)
{
OK{
    If($listBox.SelectedItem){$x =  New-Object -TypeName psobject #$listBox.SelectedItem
    $x | Add-Member -MemberType NoteProperty -Name Rom -Value $($RomsList |?{$_.Basename -eq $listBox.SelectedItem}).Name
    $x | Add-Member -MemberType NoteProperty -Name Emul -Value $(Get-ChildItem -Path $PathEmul | ?{$_.Extension -eq ".exe"}).Name
    }
    Else{}
    }
Cancel{Exit}
Ignore{$x = "retry"}
Default{}
}
}
Until($x)
$x
}

Function Menu
{
Do{
$Emul = Box_MenuEmuls
$Rom = Box_MenuRoms $Emul
If($Rom -ne "retry")
{
Start-zsnesw $Rom
}
}
While($Rom)
}
function Start-zsnesw ($Rom)
{
    $resolution = New-Object -TypeName psobject
    $resolution | Add-Member -MemberType NoteProperty -Name Width -Value $([System.Windows.Forms.SystemInformation]::PrimaryMonitorSize.Width)
    $resolution | Add-Member -MemberType NoteProperty -Name Height -Value $(If($([System.Windows.Forms.SystemInformation]::PrimaryMonitorSize.Height) -le "1200"){$([System.Windows.Forms.SystemInformation]::PrimaryMonitorSize.Height)}Else{"1200"})
    #$resolution |FT *

    $resolutionAll = "640x480","800x600","1024x768","1280x1024","1600x1200"
    $ImportConfFile = Get-Content ".\EMULS\$Emul\$($rom.emul.replace("exe","cfg"))"
    $ExportConfFile = $ImportConfFile | %{
                        If($_ -match "cvidmode="){"cvidmode=40"}
                        ElseIf($_ -match "CustomResX="){"CustomResX=$(($resolutionAll|?{$_ -match $($resolution.Height)}).Split("x")[0])"}
                        ElseIf($_ -match "CustomResY="){"CustomResY=$($resolution.Height)"}
                        Else{$_}
                            }
    $ExportConfFile | Set-Content ".\EMULS\$Emul\$($rom.emul.replace("exe","cfg"))"

Start-Process ".\EMULS\$Emul\$($Rom.Emul)" -ArgumentList "$('"').\EMULS\$Emul\ROMS\$($Rom.Rom)$('"')" -Wait
}
Box_Banner
Menu
