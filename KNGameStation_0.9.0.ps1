param(
$AppName = "KN-GameStation",
$Version = "0.9.0",
$repositoryroot = "https://github.com",
$repositoryfolder = "ArKiLL75/KNGameStation",
$WavBannerPath = "269595.wav",
$PictureBannerPath = 'Dwarfmini.png',
$Script:CountDown = 5
)

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

 Function ClearAndClose()
 {
    $Timer.Stop(); 
    $Form.Close();
    $PlayWav.Stop();
    $Form.Dispose();
    $Timer.Dispose()  
 }

 Function Button_Click()
 {
    "button_click"
    ClearAndClose
 }

 Function Timer_Update_Tick()
 {
         --$Script:CountDownCheckUpdate
         "count"
         if ($Script:CountDownCheckUpdate -lt 0)
         {
           $label.Text = $BoxText + $(Check-Update)
           $TimerCheckUpdate.Stop()
         }
 }

 Function Timer_Tick()
 {
    # $Label.Text = "$Script:CountDown" #"Your system will reboot in $Script:CountDown seconds"
         --$Script:CountDown
         if ($Script:CountDown -lt 0)
         {
           $form.DialogResult = 'Ok'
           ClearAndClose
         }
 }

Function Start-ProgressBar
{
    While ($i -le 100) {
        $progress.Value = $i
        Start-Sleep -m 1
        $i
        $i += 1
        }
}

Function Check-Update
{
$r = $(Invoke-WebRequest -Uri $($repositoryroot + "/" + $repositoryfolder) -UseBasicParsing).Links |?{$_.title -match ".ps1"}
If(($r.Title.split("_")[1]).Replace(".ps1","") -gt $Version)
{
$BoxTextVersion = $("Version "+ $($r.Title.split("_")[1]).Replace('.ps1','')) + " available."
#Invoke-WebRequest -uri $($repositoryroot+$($r.href)) -OutFile $MyInvocation.MyCommand.Name
}
Else{$BoxTextVersion = "No Update available."}
$BoxTextVersion
}
 
Function Create-BaseBox
{
param(
$BoxText
)
$form = New-Object System.Windows.Forms.Form
$form.MaximizeBox = $False
$form.MinimizeBox = $False
$form.Text = $AppName
$form.Size = New-Object System.Drawing.Size(400,400)
$form.StartPosition = 'CenterScreen'
$form.Topmost = $true

$okButton = New-Object System.Windows.Forms.Button
$okButton.Location = New-Object System.Drawing.Point(20,320)
$okButton.Size = New-Object System.Drawing.Size(50,23)
$okButton.Text = 'OK'
$okButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
$form.AcceptButton = $okButton
$form.Controls.Add($okButton)
 
$cancelButton = New-Object System.Windows.Forms.Button
$cancelButton.Location = New-Object System.Drawing.Point(320,320)
$cancelButton.Size = New-Object System.Drawing.Size(50,23)
$cancelButton.Text = 'Quit'
$cancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
$form.CancelButton = $cancelButton
$form.Controls.Add($cancelButton)

$form
}

Function Add-UpdateButton
{
param(
$form,
$BoxText = "Checking for Update:"
)

#Label
$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(20,20)
$label.Size = New-Object System.Drawing.Size(280,20)
$label.Text = $BoxText
$form.Controls.Add($label)
 

#ProgressBar
$progress = New-Object System.Windows.Forms.ProgressBar
$progress.Location = New-Object System.Drawing.Point(20,40)
$progress.Size = New-Object System.Drawing.Size(350,20)
$progress.Maximum = 100
$progress.Minimum = 0
$i = 0
$form.Controls.Add($progress)

#Button
$updateButton = New-Object System.Windows.Forms.Button
$updateButton.Location = New-Object System.Drawing.Point(20,65)
$updateButton.Size = New-Object System.Drawing.Size(50,23)
$updateButton.Text = 'Update'
$updateButton.Add_Click(
       {
    Start-ProgressBar
       })
$form.AcceptButton = $updateButton
$form.Controls.Add($updateButton)

$TimerCheckUpdate = New-Object System.Windows.Forms.Timer
$TimerCheckUpdate.Interval = 1000
$Script:CountDownCheckUpdate = 1
$TimerCheckUpdate.Add_Tick({Timer_Update_Tick})
$TimerCheckUpdate.Start()

#$Timer = New-Object System.Windows.Forms.Timer
#$Timer.Interval = 1000
#$Timer.Add_Tick({Timer_Tick})
#$Timer.Start()

Switch ($($form).ShowDialog())
{
OK{Button_Click} #$PlayWav.Stop();$Timer.Stop();Exit}
Cancel{Button_Click;exit} #$PlayWav.Stop();$Timer.Stop()}
Default{"default"}
}
}

Add-UpdateButton $(Create-BaseBox)
