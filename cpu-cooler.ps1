# --- 設定（基準となる温度） ---
$MaxTemperature = 75  # 75度を超えたら冷やすモードにします

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "   CPU温度監視 ＆ 冷却スクリプト" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

# 1. 現在の温度を取得して正しい「℃」に計算
$rawTemp = Get-CimInstance -Namespace root\wmi -ClassName MSAcpi_ThermalZoneTemperature | Select-Object -First 1
$currentTemp = $rawTemp.CurrentTemperature - 273.2

Write-Host "現在のCPU温度: $currentTemp ℃" -ForegroundColor White

# 2. 温度が基準値を超えているかチェック
if ($currentTemp -ge $MaxTemperature) {
    Write-Host "【警告】温度が $MaxTemperature ℃ を超えています！冷却モードを起動します。" -ForegroundColor Red
    powercfg /setacvalueindex SCHEME_CURRENT SUB_PROCESSOR PROCTHROTTLEMAX 70
    powercfg /setdcvalueindex SCHEME_CURRENT SUB_PROCESSOR PROCTHROTTLEMAX 70
    powercfg /setactive SCHEME_CURRENT
    Write-Host "👉 CPUの最大パワーを70%に制限しました。温度が下がります。" -ForegroundColor Yellow
} else {
    Write-Host "【安全】正常な温度です。通常モード（100%）を維持します。" -ForegroundColor Green
    powercfg /setacvalueindex SCHEME_CURRENT SUB_PROCESSOR PROCTHROTTLEMAX 100
    powercfg /setdcvalueindex SCHEME_CURRENT SUB_PROCESSOR PROCTHROTTLEMAX 100
    powercfg /setactive SCHEME_CURRENT
}
Write-Host "========================================" -ForegroundColor Cyan
