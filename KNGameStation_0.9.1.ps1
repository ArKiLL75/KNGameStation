param(
$AppName = "KN-GameStation $Version",
$Version = "0.9.1"
)

##################

function Box_MenuEmuls {
param(
$Path = "C:\Users\ArKiLL\Documents\Powershell\Scripts\GameStation_v2\EMULS" # $PSScriptRoot + "\EMULS",
)
$form = New-Object System.Windows.Forms.Form
$form.Text = $AppName
$form.Size = New-Object System.Drawing.Size(400,400)
$form.StartPosition = 'CenterScreen'

$okButton = New-Object System.Windows.Forms.Button
$okButton.Location = New-Object System.Drawing.Point(70,220)
$okButton.Size = New-Object System.Drawing.Size(50,23)
$okButton.Text = 'OK'
$okButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
$form.AcceptButton = $okButton
$form.Controls.Add($okButton)

$cancelButton = New-Object System.Windows.Forms.Button
$cancelButton.Location = New-Object System.Drawing.Point(170,220)
$cancelButton.Size = New-Object System.Drawing.Size(50,23)
$cancelButton.Text = 'Quit'
$cancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
$form.CancelButton = $cancelButton
$form.Controls.Add($cancelButton)

$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(10,20)
$label.Size = New-Object System.Drawing.Size(280,20)
$label.Text = "Choose your station"
$form.Controls.Add($label)

$listBox = New-Object System.Windows.Forms.ListBox
$listBox.Location = New-Object System.Drawing.Point(10,40)
$listBox.Size = New-Object System.Drawing.Size(260,20)
$listBox.Height = 60
Get-ChildItem $Path | %{[void] $listBox.Items.Add($_.BaseName)}
$listBox.SelectedItem = $listBox.Items[0]
$listBox.add_SelectedIndexChanged({"CHANGE"
                        $listBox2.Items.Clear()
                        $RomsList = Get-ChildItem $($Path + "\" + $($listBox.SelectedItem) + "\ROMS") | ?{$_.Extension -eq ".smc"}
                        $RomsList | %{[void] $listBox2.Items.Add($_.BaseName)}
                        $listBox2.SelectedItem = $listBox2.Items[0]
                        $form.Controls.Add($listBox2)
                        })
$form.Controls.Add($listBox)

$label2 = New-Object System.Windows.Forms.Label
$label2.Location = New-Object System.Drawing.Point(10,110)
$label2.Size = New-Object System.Drawing.Size(280,20)
$label2.Text = "Choisis ton jeu"
$form.Controls.Add($label2)

$listBox2 = New-Object System.Windows.Forms.ListBox
$listBox2.Location = New-Object System.Drawing.Point(10,130)
$listBox2.Size = New-Object System.Drawing.Size(260,20)
$listBox2.Height = 80
$RomsList = Get-ChildItem $($Path + "\" + $($listBox.SelectedItem) + "\ROMS") | ?{$_.Extension -eq ".smc"}
$RomsList | %{[void] $listBox2.Items.Add($_.BaseName)}
$form.Controls.Add($listBox2)

#$($Path + "\" + $($listBox.SelectedItem) + "\ROMS") |set-content c:\temp\test.txt

$form.Topmost = $true

Do{

$result_Menu01 = $($form).ShowDialog()
Switch ($result_Menu01)
{
OK{ If($listBox.SelectedItem -AND $listBox2.SelectedItem){$x =  New-Object -TypeName psobject #$listBox.SelectedItem
#$listBox2.SelectedItem |set-content c:\temp\test.txt
#$RomsList
#$($RomsList |?{$_.Basename -eq $listBox2.SelectedItem}).Name |add-content c:\temp\test.txt
    $x | Add-Member -MemberType NoteProperty -Name Rom -Value $($RomsList |?{$_.Basename -eq $listBox2.SelectedItem}).Name
$(Get-ChildItem -Path $($Path + "\" + $($listBox.SelectedItem)) | ?{$_.Extension -eq ".exe"}).Name |add-content c:\temp\test.txt
    $x | Add-Member -MemberType NoteProperty -Name Emul -Value $(Get-ChildItem -Path $($Path + "\" + $($listBox.SelectedItem)) | ?{$_.Extension -eq ".exe"}).Name
    }
    Else{}
    }
Cancel{Exit}
Default{}
}
}
Until($x)
$x
}

Function Menu
{
Do{
$Rom = Box_MenuEmuls
#$Rom |select * | export-csv c:\temp\expo.csv

#$Rom = Box_MenuRoms $Emul
#If($Rom -ne "retry")
#{
Start-zsnesw $Rom
#}
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
    $ImportConfFile = Get-Content ".\EMULS\$Rom.Emul\$($rom.emul.replace("exe","cfg"))"
    $ExportConfFile = $ImportConfFile | %{
                        If($_ -match "cvidmode="){"cvidmode=40"}
                        ElseIf($_ -match "CustomResX="){"CustomResX=$(($resolutionAll|?{$_ -match $($resolution.Height)}).Split("x")[0])"}
                        ElseIf($_ -match "CustomResY="){"CustomResY=$($resolution.Height)"}
                        Else{$_}
                            }
    $ExportConfFile | Set-Content ".\EMULS\$Emul\$($rom.emul.replace("exe","cfg"))"

Start-Process ".\EMULS\$Emul\$($Rom.Emul)" -ArgumentList "$('"').\EMULS\$Emul\ROMS\$($Rom.Rom)$('"')" -Wait
}

