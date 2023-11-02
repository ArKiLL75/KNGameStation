param(
$Version = "0.9.3",
$AppName = "KN-GameStation - $Version"
)
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
##################
function Unlock-OKButton {
If($Script:X.Emulateur -AND $Script:X.Rom)
    {
    $okButton.Enabled = $true
    $form.Controls.Add($okButton)
    }
Else{$okButton.Enabled = $false
    $form.Controls.Add($okButton)
    }
}

function Box_MenuEmuls {
param(
$Path_Stations = "$(Get-Location)\Stations",
$Script:CheckBox_List = @('Checkbox_NIN_SNES','Checkbox_SEG_MDRV','Checkbox_NIN_NES'),
$Script:X =  $(New-Object -TypeName psobject)
)

$form = New-Object System.Windows.Forms.Form
$form.Text = $AppName
$form.Size = New-Object System.Drawing.Size(400,400)
$form.StartPosition = 'CenterScreen'
$form.Topmost = $true

$okButton = New-Object System.Windows.Forms.Button
$okButton.Location = New-Object System.Drawing.Point(20,320)
$okButton.Size = New-Object System.Drawing.Size(50,23)
$okButton.Text = 'Jouer'
$okButton.Enabled = $false
$okButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
$form.AcceptButton = $okButton
$form.Controls.Add($okButton)

$cancelButton = New-Object System.Windows.Forms.Button
$cancelButton.Location = New-Object System.Drawing.Point(310,320)
$cancelButton.Size = New-Object System.Drawing.Size(50,23)
$cancelButton.Text = 'Quit'
$cancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
$form.CancelButton = $cancelButton
$form.Controls.Add($cancelButton)

### EMUL
## Labels
$label_choose_emul = New-Object System.Windows.Forms.Label
$label_choose_emul.Location = New-Object System.Drawing.Point(30,10)
$label_choose_emul.Size = New-Object System.Drawing.Size(105,20)
$label_choose_emul.Text = "Choose your station"
$form.Controls.Add($label_choose_emul)

## Checkbox
$Checkbox_NIN_SNES = New-Object System.Windows.Forms.Checkbox 
$Checkbox_NIN_SNES.Location = New-Object System.Drawing.Size(30,40) 
$Checkbox_NIN_SNES.Size = New-Object System.Drawing.Size(150,20)
$Checkbox_NIN_SNES.Text = "Nintendo - Super NES"
#$Checkbox_NIN_SNES.Checked = $false
$Checkbox_NIN_SNES.Add_CheckStateChanged({If($Checkbox_NIN_SNES.Checked){$Checkbox_NIN_SNES.Enabled = $false
                                        If($Script:X.folder){$Script:X.folder = $null};If($Script:X.emulateur){$Script:X.emulateur = $null}
                                        $Script:X | Add-Member -MemberType NoteProperty -Name Folder -Value $($Path_Stations + "\NIN-SNES") -Force
                                        $Script:X | Add-Member -MemberType NoteProperty -Name Emulateur -Value $($Script:X.Folder + "\EMUL\zsnesw\zsnesw.exe") -Force
                                        Unlock-OKButton
                                        $Checkbox_NIN_NES.Checked = $false;$Checkbox_NIN_NES.Enabled = $true
                                        $Checkbox_SEG_MDRV.Checked = $false;$Checkbox_SEG_MDRV.Enabled = $true
                                        $listBox_Roms.Items.Clear()
                                        Get-ChildItem $($Path_Stations + "\NIN-SNES\ROMS") | ?{$_.Extension -eq ".smc"} | %{[void] $listBox_Roms.Items.Add($_.BaseName)}
                                        $form.Controls.Add($listBox_Roms)}
                                        })
$form.Controls.Add($Checkbox_NIN_SNES)

$Checkbox_NIN_NES = New-Object System.Windows.Forms.Checkbox 
$Checkbox_NIN_NES.Location = New-Object System.Drawing.Size(30,70) 
$Checkbox_NIN_NES.Size = New-Object System.Drawing.Size(150,20)
$Checkbox_NIN_NES.Text = "Nintendo - NES"
#$Checkbox_NIN_NES.Checked = $false
$Checkbox_NIN_NES.Add_CheckStateChanged({If($Checkbox_NIN_NES.Checked){$Checkbox_NIN_NES.Enabled = $false
                                        If($Script:X.folder){$Script:X.folder = $null};If($Script:X.emulateur){$Script:X.emulateur = $null}
                                        $Script:X | Add-Member -MemberType NoteProperty -Name Folder -Value $($Path_Stations + "\NIN-SNES") -Force
                                        $Script:X | Add-Member -MemberType NoteProperty -Name Emulateur -Value $($Script:X.Folder + "\EMUL\zsnesw\zsnesw.exe") -Force
                                        Unlock-OKButton
                                        $Checkbox_SEG_MDRV.Checked = $false;$Checkbox_SEG_MDRV.Enabled = $true
                                        $Checkbox_NIN_SNES.Checked = $false;$Checkbox_NIN_SNES.Enabled = $true
                                        $listBox_Roms.Items.Clear()
                                        Get-ChildItem $($Path_Stations + "\NIN-NES\ROMS") | ?{$_.Extension -eq ".smc"} | %{[void] $listBox_Roms.Items.Add($_.BaseName)}
                                        $form.Controls.Add($listBox_Roms)}
                                        })
$form.Controls.Add($Checkbox_NIN_NES)

$Checkbox_SEG_MDRV = New-Object System.Windows.Forms.Checkbox 
$Checkbox_SEG_MDRV.Location = New-Object System.Drawing.Size(240,40) 
$Checkbox_SEG_MDRV.Size = New-Object System.Drawing.Size(150,20)
$Checkbox_SEG_MDRV.Text = "Sega - Megadrive"
#$Checkbox_SEG_MDRV.Checked = $false
$Checkbox_SEG_MDRV.Add_CheckStateChanged({If($Checkbox_SEG_MDRV.Checked){$Checkbox_SEG_MDRV.Enabled = $false
                                        If($Script:X.folder){$Script:X.folder = $null};If($Script:X.emulateur){$Script:X.emulateur = $null}
                                        $Script:X | Add-Member -MemberType NoteProperty -Name Folder -Value $($Path_Stations + "\SEG-MDRV") -Force
                                        $Script:X | Add-Member -MemberType NoteProperty -Name Emulateur -Value $($Script:X.Folder + "\EMUL\Gens-2.14\gens.exe") -Force
                                        Unlock-OKButton
                                        $Checkbox_NIN_NES.Checked = $false;$Checkbox_NIN_NES.Enabled = $true
                                        $Checkbox_NIN_SNES.Checked = $false;$Checkbox_NIN_SNES.Enabled = $true
                                        $listBox_Roms.Items.Clear()
                                        Get-ChildItem $($Path_Stations + "\SEG-MDRV\ROMS") | ?{$_.Extension -eq ".md"} | %{[void] $listBox_Roms.Items.Add($_.BaseName)}
                                        $form.Controls.Add($listBox_Roms)}
                                        })
$form.Controls.Add($Checkbox_SEG_MDRV)

### ROMS
## Label
$label_choose_rom = New-Object System.Windows.Forms.Label
$label_choose_rom.Location = New-Object System.Drawing.Point(30,150)
$label_choose_rom.Size = New-Object System.Drawing.Size(105,20)
$label_choose_rom.Text = "Choose your game"
$form.Controls.Add($label_choose_rom)

## Roms list
$listBox_Roms = New-Object System.Windows.Forms.ListBox
$listBox_Roms.Location = New-Object System.Drawing.Point(30,180)
$listBox_Roms.Size = New-Object System.Drawing.Size(260,20)
$listBox_Roms.Height = 130
$listBox_Roms.add_SelectedIndexChanged({$Script:X | Add-Member -MemberType NoteProperty -Name Game -Value $listBox_Roms.SelectedItem -Force                                        
                                    $Script:X | Add-Member -MemberType NoteProperty -Name Rom -Value $(Get-ChildItem $($Script:X.Folder + "\ROMS") |?{$_.Basename -eq $listBox_Roms.SelectedItem}).FullName -Force
                                    Unlock-OKButton
                                    })
$form.Controls.Add($listBox_Roms)


Do{
$result_Menu01 = $($form).ShowDialog()
Switch ($result_Menu01)
{
OK{Return $Script:X}
Cancel{Exit}
Default{}
}
}
Until($Script:X)
}

Function Menu
{
#Do{
$Game_Selected = Box_MenuEmuls

Switch($Game_Selected.Emulateur.Split("\")[-1])
    {
    zsnesw.exe{Start-zsnesw $Game_Selected}
    gens.exe{}
    Default{}
    }
#$Rom |select * | export-csv c:\temp\expo.csv

#$Rom = Box_MenuRoms $Emul
#If($Rom -ne "retry")
#{
#Start-zsnesw $Rom
#}
#}
#While($Rom)
}


function Start-zsnesw
{
param(
$Game_Selected
)
    $resolution = New-Object -TypeName psobject
    $resolution | Add-Member -MemberType NoteProperty -Name Width -Value $([System.Windows.Forms.SystemInformation]::PrimaryMonitorSize.Width)
    $resolution | Add-Member -MemberType NoteProperty -Name Height -Value $(If($([System.Windows.Forms.SystemInformation]::PrimaryMonitorSize.Height) -le "1200"){$([System.Windows.Forms.SystemInformation]::PrimaryMonitorSize.Height)}Else{"1200"})
    #$resolution |FT *

    $resolutionAll = "640x480","800x600","1024x768","1280x1024","1600x1200"
    $ImportConfFile = Get-Content "$($Game_Selected.emulateur.replace("exe","cfg"))"
    $ExportConfFile = $ImportConfFile | %{
                        If($_ -match "cvidmode="){"cvidmode=40"}
                        ElseIf($_ -match "CustomResX="){"CustomResX=$(($resolutionAll|?{$_ -match $($resolution.Height)}).Split("x")[0])"}
                        ElseIf($_ -match "CustomResY="){"CustomResY=$($resolution.Height)"}
                        Else{$_}
                            }
    $ExportConfFile | Set-Content "$($Game_Selected.emulateur.replace("exe","cfg"))"

Start-Process $Game_Selected.Emulateur -ArgumentList "$('"')$($Game_Selected.Rom)$('"')" -Wait

}
