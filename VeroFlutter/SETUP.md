# Vero Consultora – Flutter Setup

## Pré-requisitos (Windows)

1. **Flutter SDK** → https://docs.flutter.dev/get-started/install/windows
2. **Android Studio** → https://developer.android.com/studio
   - Instale o Android Emulator durante a configuração
3. **VS Code** (opcional) + extensão Flutter

---

## Configuração do Projeto

```bash
# 1. Crie um novo projeto Flutter
flutter create vero_consultora
cd vero_consultora

# 2. Substitua a pasta lib/ e o pubspec.yaml pelos arquivos deste repositório
#    (copie VeroFlutter/lib → vero_consultora/lib)
#    (copie VeroFlutter/pubspec.yaml → vero_consultora/pubspec.yaml)

# 3. Instale as dependências
flutter pub get

# 4. Rode no emulador Android
flutter run
```

## Permissões Android (obrigatório para upload de documentos)

Edite `android/app/src/main/AndroidManifest.xml` e adicione antes de `<application>`:

```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.READ_MEDIA_IMAGES"/>
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"
    android:maxSdkVersion="32"/>
<uses-permission android:name="android.permission.CAMERA"/>
```

---

## Rodar no Celular Android Real

```bash
# Ative o Modo Desenvolvedor no celular:
# Configurações → Sobre → toque 7x em "Número da versão"
# Ative "Depuração USB"

# Conecte o cabo USB e rode:
flutter devices   # deve listar seu celular
flutter run
```

## Estrutura do Projeto

```
lib/
├── main.dart                    # Entrada do app
├── app.dart                     # MaterialApp + localização pt_BR
├── theme/vero_theme.dart        # Cores e tema Vero
├── models/                      # Consultant, Address
├── services/                    # API (simulada), ViaCEP, Validação
├── providers/                   # AuthProvider, RegistrationProvider
├── utils/input_formatters.dart  # Máscaras CPF, Telefone, CEP, RG
├── widgets/                     # VeroTextField, VeroButton, StepIndicator, Picker
└── screens/
    ├── splash_screen.dart
    ├── login_screen.dart
    ├── registration/            # 6 passos + tela de sucesso
    └── dashboard/               # Dashboard da consultora
```

## Integração com API Real

Substitua as chamadas simuladas em `lib/services/api_service.dart`:
- `ApiService.login()` → POST /auth/login
- `ApiService.registerConsultant()` → POST /consultores/cadastro
