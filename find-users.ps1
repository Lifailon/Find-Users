# Что бы изменить подсеть, закомментируйте строки 15-18, раскомментируйте строку 19 и укажите в ней адрес

#region functions
function savefile {
$SaveFileDialog = New-Object System.Windows.Forms.SaveFileDialog
$SaveFileDialog.Filter = "All Files (*.txt)|*.txt"
$SaveFileDialog.InitialDirectory = "$env:USERPROFILE\desktop\"
$SaveFileDialog.Title = "Выберите файл"
$SaveFileDialog.ShowDialog()
$global:path = $SaveFileDialog.FileNames
$Status.Text = "file save to $path"
}

function fun-usr {
$ipconf = ipconfig
$ipconf = $ipconf -match "IPv4"
$ipconf = $ipconf -replace "   IPv4 Address. . . . . . . . . . . : "
$ip = $ipconf[0]
#$ip = "192.168.1.0"
$subnet = $ip -replace "\.\d{1,3}$",".0"
$ip = $ip -replace "\.\d{1,3}$"
$outputBox_1.text = "Сканирование подсети: $subnet" | out-string

$start_time = Get-Date # зафиксировать время до начала сканирования
$Status.Text = "ping subnet $subnet"
$list = 1..254
$iplist = foreach ($for in $list) {"$ip"+"."+"$for"}
$ping = foreach ($for in $iplist) {ping -n 1 -l 1 -w 50 -v 4 $for}
$ping = $ping -match "TTL"
$ping = $ping -replace "Reply from "
$ping = $ping -replace ": bytes=1 .+"
$count_ping = $ping.count
$outputBox_1.text += "Активных хостов: $count_ping" | out-string

$Status.Text = "resolve name $count_ping hosts"
$fqdn = foreach ($for in $ping) {nslookup $for}
$fqdn = $fqdn -match "Name:"
$fqdn = $fqdn -replace "Name:\s+"
$count_name = $fqdn.count
$outputBox_1.text += "Зарегистрированных в DNS: $count_name" | out-string

$Status.Text = "find users $count_name hosts"
$user_list = foreach ($for in $fqdn) {" ";"Сервер: $for" ; query user /server:$for}
$user_list = $user_list -replace "\s{1,50}"," "
$user_list = $user_list -replace "USERNAME.+","Пользователи:"
$user_list = $user_list -replace "rdp-tcp#(\d{1,4})\s"
$user_list = $user_list -replace "console "
$user_list = $user_list -replace "Active([\s\d\.]{1,20})","подключен"
$user_list = $user_list -replace "Disc","отключен"
$user_list = $user_list -replace "подключен.+","- Подключен"
$user_list = $user_list -replace "отключен.+","- Отключен"
$user_list = $user_list -replace "^\s"
$outputBox_1.text += $user_list | out-string
$end_time = Get-Date # зафиксировать время по окончанию сканирования

$time = $end_time - $start_time # высчитать время работы скрипта
$min = $time.minutes
$sec = $time.seconds
$time = "$min"+" минут "+"$sec"+" секунд"
$outputBox_1.text += " ","Время сканирования: $time" | out-string
$Status.Text = "completed"
}
#endregion

#region forms
Add-Type -assembly System.Windows.Forms
$main_form = New-Object System.Windows.Forms.Form
$main_form.Text = "Find-Users"
$main_form.ShowIcon = $false
$main_form.StartPosition = "CenterScreen"
$main_form.Font = "Arial,12"
$main_form.ForeColor = "Black"
$main_form.Size = New-Object System.Drawing.Size(450,650)
$main_form.AutoSize = $true

$button_scan = New-Object System.Windows.Forms.Button
$button_scan.Text = "Сканировать"
$button_scan.Location = New-Object System.Drawing.Point(10,20)
$button_scan.Size = New-Object System.Drawing.Size(120,35)
$main_form.Controls.Add($button_scan)
$button_scan.Add_Click({fun-usr})

$outputBox_1 = New-Object System.Windows.Forms.TextBox
$outputBox_1.Location = New-Object System.Drawing.Point(10,70)
$outputBox_1.Font = "Arial,12"
$outputBox_1.Size = New-Object System.Drawing.Size(400,450)
$outputBox_1.MultiLine = $True
$main_form.Controls.Add($outputBox_1)

$VScrollBar = New-Object System.Windows.Forms.VScrollBar
$outputBox_1.Scrollbars = "Vertical"

$button_save = New-Object System.Windows.Forms.Button
$button_save.Text = "Сохранить"
$button_save.Location = New-Object System.Drawing.Point(10,535)
$button_save.Size = New-Object System.Drawing.Size(120,35)
$main_form.Controls.Add($button_save)

$button_save.Add_Click({
savefile
$text = $outputBox_1.Text
$text > $path
})

$button_open = New-Object System.Windows.Forms.Button
$button_open.Text = "Открыть"
$button_open.Location = New-Object System.Drawing.Point(140,535)
$button_open.Size = New-Object System.Drawing.Size(120,35)
$main_form.Controls.Add($button_open)
$button_open.Add_Click({ii $path})

$StatusStrip = New-Object System.Windows.Forms.StatusStrip
$main_form.Controls.Add($statusStrip)
$Status = New-Object System.Windows.Forms.ToolStripMenuItem
$Status.Text = "Telegram @kup57"
$StatusStrip.Items.Add($Status)

$main_form.ShowDialog()
#endregion