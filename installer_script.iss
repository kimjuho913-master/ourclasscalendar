; Inno Setup 스크립트 (수정된 최종 버전)

; --- [수정] 앱 이름과 실행 파일 이름을 변수로 먼저 정의합니다 ---
#define MyAppName "우리반 캘린더"
#define MyAppExeName "class_calendar.exe"

[Setup]
; --- 앱 기본 정보 ---
AppName={#MyAppName}
AppVersion=1.0.0
AppPublisher=kimjuho913
DefaultDirName={autopf}\{#MyAppName}
DefaultGroupName={#MyAppName}

; --- 설치 파일 설정 ---
OutputDir=.\installers
OutputBaseFilename=OurClassCalendar_Setup
Compression=lzma
SolidCompression=yes
WizardStyle=modern
SetupIconFile=windows\runner\resources\app_icon.ico

[Languages]
Name: "korean"; MessagesFile: "compiler:Languages\Korean.isl"

[Tasks]
; --- 설치 옵션: "바탕화면에 바로 가기 만들기" 체크박스를 추가합니다 ---
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
; --- [가장 중요] Flutter로 빌드한 모든 파일을 설치 폴더로 복사합니다 ---
Source: "build\windows\x64\runner\Release\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
; --- 바로 가기 아이콘 설정 ---
; 시작 메뉴에 바로 가셔를 만듭니다.
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
; 바탕화면에 바로 가기를 만듭니다.
Name: "{autodesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon

[Run]
; --- 설치 완료 후 앱 실행 옵션을 추가합니다 ---
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent