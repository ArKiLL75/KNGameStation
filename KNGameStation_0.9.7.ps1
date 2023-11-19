param(
$Version = "0.9.7",
$AppName = "KN-GameStation - $Version",
$RootPath = $(get-item $PSScriptRoot).FullName.Replace("$((get-item $PSScriptRoot).Name)",""),
$AresPath = $RootPath + "ares-v133\ares.exe"
)
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
##################

$RootPath

function Unlock-OKButton {
param(

)

If($Script:X.Folder -AND $Script:X.Rom)
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

$Path_Stations = $RootPath + "Stations",
$Script:CheckBox_List = @('Checkbox_NIN_SNES','Checkbox_SEG_MDRV','Checkbox_COL_VIS','Checkbox_NEO_AES','Checkbox_SON_PS1'),
$Script:X =  $(New-Object -TypeName psobject)
)

$form = New-Object System.Windows.Forms.Form
$form.Text = $AppName
$form.Size = New-Object System.Drawing.Size(400,400)
$form.StartPosition = 'CenterScreen'
$form.Topmost = $true

$form.KeyPreview = $True
$form.Add_KeyDown({if ($_.KeyCode -eq "f")
    {Start-ares $(Start-Frogger)}})


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

$FroggerButton = New-Object System.Windows.Forms.Button
$FroggerButton.Location = New-Object System.Drawing.Point(310,180)
$FroggerButton.Size = New-Object System.Drawing.Size(50,50)
#$FroggerButton.Enabled = $True
$FroggerButton.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$FroggerButton.FlatAppearance.BorderSize  = 0
$FroggerButton.BackgroundImage = [System.Drawing.Image]::FromFile($(get-item 'frogger.png' -ErrorAction SilentlyContinue))
#$FroggerButton.Padding = New-Object -TypeName System.Windows.Forms.Padding -ArgumentList (0,0,0,0)
#$FroggerButton.Add_Click({})
$FroggerButton.DialogResult = [System.Windows.Forms.DialogResult]::Yes
$form.HelpButton = $FroggerButton
$form.Controls.Add($FroggerButton)


### EMUL
## Labels
$label_choose_emul = New-Object System.Windows.Forms.Label
$label_choose_emul.Location = New-Object System.Drawing.Point(30,10)
$label_choose_emul.Size = New-Object System.Drawing.Size(105,20)
$label_choose_emul.Text = "Choose your station"
$form.Controls.Add($label_choose_emul)

## Checkbox
###SNES
$Checkbox_NIN_SNES = New-Object System.Windows.Forms.Checkbox 
$Checkbox_NIN_SNES.Location = New-Object System.Drawing.Size(30,40) 
$Checkbox_NIN_SNES.Size = New-Object System.Drawing.Size(150,20)
$Checkbox_NIN_SNES.Text = "Nintendo - Super NES"
$Checkbox_NIN_SNES.Add_CheckStateChanged({If($Checkbox_NIN_SNES.Checked){$Checkbox_NIN_SNES.Enabled = $false
                                        <#If($Script:X.folder){$Script:X.folder = $null};If($Script:X.rom){$Script:X.rom = $null}
                                        If($Script:X.Game){$Script:X.Game = $null};If($Script:X.extension){$Script:X.extension = $null}
                                        If($Script:X.System){$Script:X.System = $null}#>
                                        $Script:X | Add-Member -MemberType NoteProperty -Name Folder -Value $($Path_Stations + "\NIN-SNES") -Force
                                        $Script:X | Add-Member -MemberType NoteProperty -Name System -Value "Super Famicom" -Force
                                        $Script:X | Add-Member -MemberType NoteProperty -Name Extension -Value ".smc",".sfc" -Force
                                        
                                        Unlock-OKButton
                                        $Checkbox_COL_VIS.Checked = $false;$Checkbox_COL_VIS.Enabled = $true
                                        $Checkbox_SEG_MDRV.Checked = $false;$Checkbox_SEG_MDRV.Enabled = $true
                                        $Checkbox_NEO_AES.Checked = $false;$Checkbox_NEO_AES.Enabled = $true
                                        $Checkbox_SON_PS1.Checked = $false;$Checkbox_SON_PS1.Enabled = $true
                                        $listBox_Roms.Items.Clear()
                                        Get-ChildItem $($Path_Stations + "\NIN-SNES\ROMS") | ?{$Script:X.extension -contains $_.Extension} | %{[void] $listBox_Roms.Items.Add($_.BaseName)}
                                        $form.Controls.Add($listBox_Roms)}
                                        })
$form.Controls.Add($Checkbox_NIN_SNES)

### Colecovision
$Checkbox_COL_VIS = New-Object System.Windows.Forms.Checkbox 
$Checkbox_COL_VIS.Location = New-Object System.Drawing.Size(30,70) 
$Checkbox_COL_VIS.Size = New-Object System.Drawing.Size(150,20)
$Checkbox_COL_VIS.Text = "ColecoVision"
$Checkbox_COL_VIS.Add_CheckStateChanged({If($Checkbox_COL_VIS.Checked){$Checkbox_COL_VIS.Enabled = $false
                                        <#If($Script:X.folder){$Script:X.folder = $null};If($Script:X.rom){$Script:X.rom = $null}
                                        If($Script:X.Game){$Script:X.Game = $null};If($Script:X.extension){$Script:X.extension = $null}
                                        If($Script:X.System){$Script:X.System = $null}#>
                                        
                                        $Script:X | Add-Member -MemberType NoteProperty -Name Folder -Value $($Path_Stations + "\COL-VIS") -Force
                                        $Script:X | Add-Member -MemberType NoteProperty -Name System -Value "ColecoVision" -Force
                                        $Script:X | Add-Member -MemberType NoteProperty -Name Extension -Value ".col" -Force
                                        Unlock-OKButton
                                        $Checkbox_SEG_MDRV.Checked = $false;$Checkbox_SEG_MDRV.Enabled = $true
                                        $Checkbox_NIN_SNES.Checked = $false;$Checkbox_NIN_SNES.Enabled = $true
                                        $Checkbox_NEO_AES.Checked = $false;$Checkbox_NEO_AES.Enabled = $true
                                        $Checkbox_SON_PS1.Checked = $false;$Checkbox_SON_PS1.Enabled = $true
                                        $listBox_Roms.Items.Clear()
                                        Get-ChildItem $($Path_Stations + "\COL-VIS\ROMS") | ?{$_.Extension -eq $Script:X.extension} | %{[void] $listBox_Roms.Items.Add($_.BaseName)}
                                        $form.Controls.Add($listBox_Roms)}
                                        })
$form.Controls.Add($Checkbox_COL_VIS)

### PS1
$Checkbox_SON_PS1 = New-Object System.Windows.Forms.Checkbox 
$Checkbox_SON_PS1.Location = New-Object System.Drawing.Size(30,100) 
$Checkbox_SON_PS1.Size = New-Object System.Drawing.Size(150,20)
$Checkbox_SON_PS1.Text = "Sony - Playstation 1"
$Checkbox_SON_PS1.Add_CheckStateChanged({If($Checkbox_SON_PS1.Checked){$Checkbox_SON_PS1.Enabled = $false
                                        <#If($Script:X.folder){$Script:X.folder = $null};If($Script:X.rom){$Script:X.rom = $null}
                                        If($Script:X.Game){$Script:X.Game = $null};If($Script:X.extension){$Script:X.extension = $null}
                                        If($Script:X.System){$Script:X.System = $null}#>
                                        $Script:X | Add-Member -MemberType NoteProperty -Name Folder -Value $($Path_Stations + "\SON-PS1") -Force
                                        $Script:X | Add-Member -MemberType NoteProperty -Name System -Value "PlayStation" -Force
                                        $Script:X | Add-Member -MemberType NoteProperty -Name Extension -Value ".cue" -Force
                                        Unlock-OKButton
                                        $Checkbox_SEG_MDRV.Checked = $false;$Checkbox_SEG_MDRV.Enabled = $true
                                        $Checkbox_NIN_SNES.Checked = $false;$Checkbox_NIN_SNES.Enabled = $true
                                        $Checkbox_NEO_AES.Checked = $false;$Checkbox_NEO_AES.Enabled = $true
                                        $Checkbox_COL_VIS.Checked = $false;$Checkbox_COL_VIS.Enabled = $true
                                        $listBox_Roms.Items.Clear()
                                        Get-ChildItem $($Path_Stations + "\SON-PS1\ROMS") -Recurse | ?{$_.Extension -eq $Script:X.extension} | %{[void] $listBox_Roms.Items.Add($_.BaseName)}
                                        $form.Controls.Add($listBox_Roms)}
                                        })
$form.Controls.Add($Checkbox_SON_PS1)

### Megadrive
$Checkbox_SEG_MDRV = New-Object System.Windows.Forms.Checkbox 
$Checkbox_SEG_MDRV.Location = New-Object System.Drawing.Size(190,40) 
$Checkbox_SEG_MDRV.Size = New-Object System.Drawing.Size(150,20)
$Checkbox_SEG_MDRV.Text = "Sega - Megadrive"
$Checkbox_SEG_MDRV.Add_CheckStateChanged({If($Checkbox_SEG_MDRV.Checked){$Checkbox_SEG_MDRV.Enabled = $false
                                       <# If($Script:X.folder){$Script:X.folder = $null};If($Script:X.rom){$Script:X.rom = $null}
                                        If($Script:X.Game){$Script:X.Game = $null};If($Script:X.extension){$Script:X.extension = $null}
                                        If($Script:X.System){$Script:X.System = $null}#>
                                        $Script:X | Add-Member -MemberType NoteProperty -Name Folder -Value $($Path_Stations + "\SEG-MDRV") -Force
                                        $Script:X | Add-Member -MemberType NoteProperty -Name System -Value "Mega Drive" -Force
                                        $Script:X | Add-Member -MemberType NoteProperty -Name Extension -Value ".md" -Force
                                        Unlock-OKButton
                                        $Checkbox_COL_VIS.Checked = $false;$Checkbox_COL_VIS.Enabled = $true
                                        $Checkbox_NIN_SNES.Checked = $false;$Checkbox_NIN_SNES.Enabled = $true
                                        $Checkbox_NEO_AES.Checked = $false;$Checkbox_NEO_AES.Enabled = $true
                                        $Checkbox_SON_PS1.Checked = $false;$Checkbox_SON_PS1.Enabled = $true
                                        $listBox_Roms.Items.Clear()
                                        Get-ChildItem $($Path_Stations + "\SEG-MDRV\ROMS") | ?{$_.Extension -eq $Script:X.extension} | %{[void] $listBox_Roms.Items.Add($_.BaseName)}
                                        $form.Controls.Add($listBox_Roms)}
                                        })
$form.Controls.Add($Checkbox_SEG_MDRV)

### NEOGEO
$Checkbox_NEO_AES = New-Object System.Windows.Forms.Checkbox 
$Checkbox_NEO_AES.Location = New-Object System.Drawing.Size(190,70) 
$Checkbox_NEO_AES.Size = New-Object System.Drawing.Size(150,20)
$Checkbox_NEO_AES.Text = "Neo-Geo - AES"
$Checkbox_NEO_AES.Add_CheckStateChanged({If($Checkbox_NEO_AES.Checked){$Checkbox_NEO_AES.Enabled = $false
                                        <#If($Script:X.folder){$Script:X.folder = $null};If($Script:X.rom){$Script:X.rom = $null}
                                        If($Script:X.Game){$Script:X.Game = $null};If($Script:X.extension){$Script:X.extension = $null}
                                        If($Script:X.System){$Script:X.System = $null}#>
                                        $Script:X | Add-Member -MemberType NoteProperty -Name Folder -Value $($Path_Stations + "\NEO-AES") -Force
                                        $Script:X | Add-Member -MemberType NoteProperty -Name System -Value "Neo Geo AES" -Force
                                        $Script:X | Add-Member -MemberType NoteProperty -Name Extension -Value ".zip" -Force
                                        Unlock-OKButton
                                        $Checkbox_COL_VIS.Checked = $false;$Checkbox_COL_VIS.Enabled = $true
                                        $Checkbox_NIN_SNES.Checked = $false;$Checkbox_NIN_SNES.Enabled = $true
                                        $Checkbox_SEG_MDRV.Checked = $false;$Checkbox_SEG_MDRV.Enabled = $true
                                        $Checkbox_SON_PS1.Checked = $false;$Checkbox_SON_PS1.Enabled = $true
                                        $listBox_Roms.Items.Clear()
                                        Get-ChildItem $($Path_Stations + "\NEO-AES\ROMS") | ?{$_.Extension -eq $Script:X.extension} | Sort BaseName | %{[void] $listBox_Roms.Items.Add($_.BaseName)}
                                        $form.Controls.Add($listBox_Roms)}
                                        })
$form.Controls.Add($Checkbox_NEO_AES)

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
                                    $Script:X | Add-Member -MemberType NoteProperty -Name Rom -Value $(Get-ChildItem $($Script:X.Folder + "\ROMS") -Recurse -File |?{$_.Basename -eq $listBox_Roms.SelectedItem -AND $Script:X.extension -contains  $_.extension}).FullName -Force
                                    Unlock-OKButton
                                    })
$form.Controls.Add($listBox_Roms)


Do{
$result_Menu01 = $($form).ShowDialog()
Switch ($result_Menu01)
{
OK{Start-ares $Script:X}
Cancel{Exit}
Yes{Start-ares $(Start-Frogger)}
Default{}
}
}
While($Script:X)
}

function Start-ares
{
param(
$Game_Selected
)
Write-Host $('X' * $Game_Selected.System.length + 'X' * 4) -ForegroundColor Yellow
Write-Host 'X ' -NoNewline -ForegroundColor Yellow
Write-Host $Game_Selected.System -NoNewline
Write-Host ' X' -ForegroundColor Yellow
Write-Host $('X' * $Game_Selected.System.length + 'X' * 4) -ForegroundColor Yellow

$Argument = "$('"')$($Game_Selected.Rom)$('"') --fullscreen --system $('"')$($Game_Selected.System)$('"')"
#$Argument

Start-Process $AresPath -ArgumentList "$Argument" -Wait
"`r"
}

function Start-Frogger
{
$Script:X | Add-Member -MemberType NoteProperty -Name Folder -Value $($Path_Stations + "\ATA-2600") -Force
$Script:X | Add-Member -MemberType NoteProperty -Name System -Value "Atari 2600" -Force
$Script:X | Add-Member -MemberType NoteProperty -Name Extension -Value ".zip" -Force
$Script:X | Add-Member -MemberType NoteProperty -Name Game -Value "Frogger (1982)" -Force                                        
$Script:X | Add-Member -MemberType NoteProperty -Name Rom -Value $(Get-ChildItem $($Script:X.Folder + "\ROMS") -Recurse -File |?{$_.Basename -eq $Script:X.Game -AND $Script:X.extension -contains  $_.extension}).FullName -Force

Return $Script:X
}
