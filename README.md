# HWSCONTROL
##### Sistema de gerenciamento de conteúdo web

## :star: Run Debugging Web

```sh
flutter run -d chrome --web-renderer html
```

### :star: Build Release Web

```sh
flutter build web --web-renderer html --release
```

### :star: Gerar APK release da loja android

```sh
flutter build appbundle
```

### :star2: Gerar APK release com ofuscação de codigo
##### Deixa mais leve o app pois gera para cada versão de dispositivo

```sh
flutter build apk --split-per-abi
```

### :star2: Rodar no dispositovo mesmo que esteja tendo mistura de pacotes null-safety e legados
```
flutter run --no-sound-null-safety
``` 

### :gear: Configurações do firebase debug - ANDROID
Para que os dados do firebase não sejam poluidos com dados do desenvolvimento precisa ser utilizado o comando abaixo para que todos os logs e ações dentro do app de desenvolvimento seja realocada no setor de dev do proprio firebase. Este comando ativará o modo depuração do analytics até que seja desativado.

```
adb shell setprop debug.firebase.analytics.app br.com.pechinchadahoraadmin
```

Desativar depuração

```
adb shell setprop debug.firebase.analytics.app .none.
```

### :gear: Configurações do firebase debug - IOS
Utilizando o Xcode rode o comando abaixo na linha de comando para que o dispositivo fique cadastrado como dispositivo de depuração do analytics e demais plugins do firebase habilitados para o projeto.

```
FIRDebugEnabled
```

Desativar depuração

```
FIRDebugDisabled
```



### :gear: Configurações do projeto ANDROID
alterar o arquivo build.gradle a nivel app
caminho: android > app > build.gradle

alterar a versão minima do android para a 18 por que o plugin flutter_secure_storage não é compativel com versões anteriores que essa

### :gear: Configurações do projeto IOS
instalar as dependencias do Firebase
caminho: ios

```sh
// caso não tenha sido iniciado o arquivo pod
pod init

// no arquivo pod gerado adicione esta linha
pod 'Firebase/Analytics'

// instale as dependencias
pod install

// compilar o app
flutter build ios

// abrir o projeto
xcode->projeto->ios->Runner.xwcworkspace
```

### :gear: Ubuntu Setup

precisei rodar no vs-Code
Para fazer a instalação do plugin flutter siga os seguintes comandos em versões superiores a 16.* do Linux

```sh
// instala o flutter e  já deixa ele em variaveis globais
sudo snap install flutter --classic

// saber o diretorio de instalação SDK
flutter sdk-path

// verificar se o flutter está saudavel
flutter doctor

// para rodar no VS Code instalar as extensões
Dart, Flutter
```

### :gear: MacOS Setup

```sh
// Baixar e instalar a versão estavel Flutter_MacOs

// extrair o arquivo 
unzip ~/Downloads/flutter_macos_1.22.6-stable.zip

// adicionar o flutter ao path apenas da sessão atual terminal
// acesse a pasta do flutter descompactada e use o comando PWD para saber o caminho completo da pasta
export PATH="$PATH:`pwd`/flutter/bin"

// rode flutter doctor para saber a saude do flutter
flutter doctor
```

