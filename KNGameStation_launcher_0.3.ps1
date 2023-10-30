param(
$VersionLauncher = "0.3",
$LauncherName = "KN-GameStation Launcher - $VersionLauncher",
$ScriptName = "KNGameStation",
$repositoryroot = "https://github.com",
$repositoryfolder = "ArKiLL75/KNGameStation",
$WavBannerPath = "banner.wav",
$PictureBannerPath = 'banner.png',
$Script:CountDown = 20
)



Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

    $Script = Get-ChildItem |? {$_.Name -like $($ScriptName + "_" + "*" + ".ps1") -AND $_.Name -notmatch "Launcher"} |Sort Name -Descending |Select -First 1
    . .\"$($Script.Name)"
#$AppName  |set-content c:\temp\v1.txt

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

 Function Check-Update
{
$UpdateCheck = New-Object psobject
### Launcher

$r = $(Invoke-WebRequest -Uri $($repositoryroot + "/" + $repositoryfolder) -UseBasicParsing).Links |?{$_.title -match ".ps1" -AND`
                                                                                                     $_.title -like "$ScriptName*" -AND`
                                                                                                     $_.title -like "*launcher*"} |Sort title -Descending |Select -First 1
If($r.Title.split("_")[2].Replace(".ps1","") -gt $VersionLauncher)
    {
    $UpdateCheck |Add-Member -MemberType NoteProperty -Name "Status" -Value "$($r.title): Version $(($r.Title.split("_")[2]).Replace('.ps1','')) available (Installed: $VersionLauncher)."
    $UpdateCheck |Add-Member -MemberType NoteProperty -Name "Color" -Value "BLUE"
    $UpdateCheck |Add-Member -MemberType NoteProperty -Name "Font" -Value $([System.Drawing.Font]::new("Microsoft Sans Serif", 8.5, [System.Drawing.FontStyle]::Bold))
    $UpdateCheck |Add-Member -MemberType NoteProperty -Name "Button" -Value $True
    $UpdateCheck |Add-Member -MemberType NoteProperty -Name "Title" -Value $($r.title)
    $UpdateCheck |Add-Member -MemberType NoteProperty -Name "Link" -Value "https://raw.githubusercontent.com/ArKiLL75/$ScriptName/master/$($UpdateCheck.Title)"
    $UpdateCheck |Add-Member -MemberType NoteProperty -Name "Script" -Value $ScriptLauncherName
    Return $UpdateCheck
    }
ElseIf(
        $r = $(Invoke-WebRequest -Uri $($repositoryroot + "/" + $repositoryfolder) -UseBasicParsing).Links |?{$_.title -match ".ps1" -AND`
                                                                                                     $_.title -like "$ScriptName*" -AND`
                                                                                                     $_.title -notmatch "Launcher"} |Sort title -Descending |Select -First 1
      )
      {
      If($r.Title.split("_")[1].Replace(".ps1","") -gt $Version)
        {
        $UpdateCheck |Add-Member -MemberType NoteProperty -Name "Status" -Value "$($r.title): Version $(($r.Title.split("_")[1]).Replace('.ps1','')) available (Installed: $Version)."
        $UpdateCheck |Add-Member -MemberType NoteProperty -Name "Color" -Value "BLUE"
        $UpdateCheck |Add-Member -MemberType NoteProperty -Name "Font" -Value $([System.Drawing.Font]::new("Microsoft Sans Serif", 8.5, [System.Drawing.FontStyle]::Bold))
        $UpdateCheck |Add-Member -MemberType NoteProperty -Name "Button" -Value $True
        $UpdateCheck |Add-Member -MemberType NoteProperty -Name "Title" -Value $($r.title)
        $UpdateCheck |Add-Member -MemberType NoteProperty -Name "Link" -Value "https://raw.githubusercontent.com/ArKiLL75/$ScriptName/master/$($UpdateCheck.Title)"
        $UpdateCheck |Add-Member -MemberType NoteProperty -Name "Script" -Value $ScriptLauncherName
        Return $UpdateCheck
        }
    Else{
        $UpdateCheck |Add-Member -MemberType NoteProperty -Name "Status" -Value "No Updates available."
        $UpdateCheck |Add-Member -MemberType NoteProperty -Name "Color" -Value "BLACK"
        $UpdateCheck |Add-Member -MemberType NoteProperty -Name "Button" -Value $False
        Return $UpdateCheck
        }
      }
### Script

#$UpdateCheck = New-Object psobject

Else{$UpdateCheck |Add-Member -MemberType NoteProperty -Name "Status" -Value "No Updates available."
    $UpdateCheck |Add-Member -MemberType NoteProperty -Name "Color" -Value "BLACK"
    $UpdateCheck |Add-Member -MemberType NoteProperty -Name "Button" -Value $False
    Return $UpdateCheck
    }
#$UpdateCheck
}

function Box_Banner {
param(
$UpdateCheck = $(Check-Update) #KibilNala - GameStation"
)
$form = New-Object System.Windows.Forms.Form
$form.Text = $LauncherName
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

$UpdateLinkButton = New-Object System.Windows.Forms.Button
$UpdateLinkButton.Location = New-Object System.Drawing.Point(300,15)
$UpdateLinkButton.Size = New-Object System.Drawing.Size(70,23)
$UpdateLinkButton.Text = 'Update'
$UpdateLinkButton.Enabled = $UpdateCheck.Button
$UpdateLinkButton.Add_Click({$(
                            Invoke-WebRequest -Uri $UpdateCheck.Link -OutFile .\$($UpdateCheck.Title)
                            Start-Process Powershell.exe $UpdateCheck.Script
                            ClearAndClose
                            )})
$form.Controls.Add($UpdateLinkButton)

$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(10,20)
$label.Size = New-Object System.Drawing.Size(20,20)
$label.Text = ""
$form.Controls.Add($label)

$label2 = New-Object System.Windows.Forms.Label
$label2.Location = New-Object System.Drawing.Point(70,20)
$label2.Size = New-Object System.Drawing.Size(280,20)
$label2.Text = $UpdateCheck.Status #$BoxText
$label2.ForeColor = $UpdateCheck.Color
$label2.Font = $UpdateCheck.Font
$form.Controls.Add($label2)

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
OK{Menu} #$PlayWav.Stop();$Timer.Stop();Exit}
Cancel{ClearAndClose;exit} #$PlayWav.Stop();$Timer.Stop()}
Default{"default"}
}
}
Box_Banner