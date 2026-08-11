# 給 AI 助手的 Windows 中文編碼守則

請在這個 Windows 專案中遵守以下規則，避免中文內容在 PowerShell 或終端機中變成亂碼：

執行 PowerShell 腳本時，請優先安裝並使用 PowerShell 7.6.1 以上版本的 MSI 版 `pwsh`。Windows 上若用 winget 安裝，請優先使用：

```powershell
winget install --id Microsoft.PowerShell --source winget --installer-type wix
```

不要只執行沒有 `--installer-type wix` 的 winget 安裝指令，因為目前可能會裝到 MSIX / Microsoft Store 版。MSIX / Store 版可作為一般互動或政策限制下的備選，但不作為 AI 自動化與中文檔案工作流的預設。也不要把 Windows 內建的 Windows PowerShell 5.1 `powershell.exe` 當成中文 AI 工作流的主要執行環境。

1. 先確認目前使用的是 MSI 版 `pwsh` 7.x、MSIX / Store 版 `pwsh`、Windows PowerShell 5.1、Git Bash 還是 WSL。
2. 不要把 PowerShell 或終端機顯示出來的中文當成最終正確內容。
3. 如果你看到亂碼、`???`、`�`，不要把那些文字複製回文件、提示語、瀏覽器或任何要保存的地方。
4. 中文內容請以 VS Code 編輯器中的 UTF-8 文件、瀏覽器畫面、可靠的 diff，或能檢查實際 Unicode 內容的工具為準。
5. 不要用 PowerShell inline command、heredoc、`>`、`>>`、`Out-File` 直接產生或保存中文正式內容，除非你已確認 PowerShell 版本、指定編碼，並完成驗證。
6. 如果需要讀寫中文文字檔，請明確使用 UTF-8，例如 `Get-Content -Encoding utf8`、`Set-Content -Encoding utf8`，或使用能明確指定 UTF-8 no BOM 的工具。
7. 若要建立或修改含中文的文件，優先直接編輯 UTF-8 文件，不要從終端機輸出複製中文再貼回檔案。
8. `.ps1`、`.psm1`、`.psd1` 這類 PowerShell 原始檔請盡量保持 ASCII-only；若需要中文，請放在獨立的 UTF-8 資料檔中再讀取。
9. 在儲存、提交、上傳或發布前，如果曾經出現亂碼，請先停止並重新確認文件內容沒有被污染。

簡短版：

> 優先使用 MSI 版 PowerShell 7.x；終端機顯示的中文不可信；中文內容以 UTF-8 文件或瀏覽器畫面為準。看到亂碼就停止，不要複製、不保存、不發布。
