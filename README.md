# DelCheck

O **DelCheck** é um SDK desenvolvido para a execução de validações de transações com o objetivo de garantir a segurança e integridade das transações realizadas. Este SDK proporciona uma solução robusta para autenticação e validação de processos transacionais, assegurando a conformidade com os padrões de segurança exigidos.

## Integração
Este manual fornece orientações detalhadas para a integração do SDK **DelCheck** em projetos desenvolvidos com Flutter e Android nativo. O objetivo é garantir a implementação adequada do SDK para maximizar a segurança e a eficácia das validações de transações.

### Configuração android

 

Para utilizar este plugin em seu projeto Flutter, você deve seguir os seguintes passos:

1. **Baixar e extrair o arquivo `SDK.zip`que se encontra neste repositório nele contém os arquivos necessário que você usará para executar este passo a passo.**

2. **Adicione o Arquivo `.aar`**

   - Adicione o arquivo `.aar` do SDK Delbank na pasta `android/app/libs` do seu projeto.
3. **Configurar o `build.gradle`**

   - Abra o arquivo `build.gradle` localizado em `android/app/build.gradle`.
   - Adicione o seguinte código para incluir o diretório `libs` como uma fonte de dependências juntamente com o maven indicando o url do jitpack.io ele será necessário para utilização da lib OtpView:

     ```groovy
     repositories {
         flatDir {
             dirs 'libs'
         }
         maven { url 'https://jitpack.io' }
     }
     ```

   - Adicione a dependência do SDK Delbank na seção `dependencies` substituindo `'nome-do-arquivo-aar'` pelo nome real do arquivo `.aar` que você adicionou na pasta `libs`:   

     ```groovy
     dependencies {
         implementation(name: 'nome-do-arquivo-aar', ext: 'aar')
     }
     ```
     Esta configuração garante que o arquivo `.aar` do SDK Delbank seja corretamente incluído e reconhecido pelo seu projeto, permitindo que você utilize o SDK nas suas implementações. 

   - Em seguida adicione as dependências que estão no modelo abaixo elas são necessárias para rodar o SDK Delbank:   

     ```groovy
     dependencies {
      implementation 'com.github.aabhasr1:OtpView:v1.1.2'
      implementation 'com.squareup.okhttp3:okhttp:4.9.3'
      implementation 'com.squareup.okhttp3:logging-interceptor:4.9.3'
      implementation 'com.squareup.retrofit2:retrofit:2.9.0'
      implementation 'com.squareup.retrofit2:converter-gson:2.9.0'
      implementation 'com.google.android.material:material:1.5.0'
      implementation 'androidx.core:core-ktx:1.8.0'
      implementation 'com.google.firebase:firebase-messaging-ktx:24.0.0'
      implementation(platform("com.google.firebase:firebase-bom:33.1.2"))
      implementation(name: 'nome-do-arquivo-aar', ext: 'aar')
    }
     ```
   - Após isso no android studio  abra o arquivo `build.gradle` localizado em `android/app/build.gradle` dê um Sync now este comando irá baixar e sincronizar as dependências do projeto. 
    


4. **Adicionar o Arquivo `SdkDelbank.kt`**

   - Dentro da pasta `android`, localize o diretório `app/src/main/java/` (ou `kotlin/` dependendo da estrutura do seu projeto).
   - Navegue até o pacote onde deseja adicionar o arquivo `SdkDelbank.kt`. Por exemplo, se seu pacote é `com.example.my_flutter_app`, você deve navegar para `app/src/main/java/com/example/my_flutter_app/`.
   - Coloque o arquivo `SdkDelbank.kt` no diretório apropriado.

5. **Importar o Arquivo `SdkDelbank.kt`**

   - Dentro da pasta `android`, localize o diretório `app/src/main/java/` (ou `kotlin/` dependendo da estrutura do seu projeto).
   - No arquivo `MainActivity.kt`. Por exemplo, se seu pacote é `com.example.my_flutter_app`, você deve navegar para `app/src/main/java/com/example/my_flutter_app/MainActivity.kt`.
   - Adicione a seguinte linha no configureFlutterEngine:  `flutterEngine.plugins.add(SdkDelbank())` e em seguida importe o arquivo.

      ```kotlin
            @@ class MainActivity: FlutterFragmentActivity() {
            override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
            super.configureFlutterEngine(flutterEngine)
      
            flutterEngine.plugins.add(SdkDelbank())
      }
      ```
   

### Configuração projeto flutter
Para facilitar a comunicação entre o Flutter e o código nativo Android, utilizaremos o MethodChannel. O MethodChannel proporciona uma interface que permite ao código Dart no Flutter invocar métodos definidos no código nativo e receber os resultados de volta. Esse mecanismo de comunicação é essencial para integrar funcionalidades específicas do SDK Delbank no aplicativo Flutter, permitindo a execução de operações nativas e a obtenção de resultados diretamente na aplicação Flutter. Segue abaixo um exemplo do arquivo de integração:

```dart
import 'package:flutter/services.dart';

const channelName = "delbank.sdk/antiCheat";
const eventStartCheck = "startCheck";

const keyResultId = "authorizationId";
const keyResultErrorCode = "code";
const keyResultErrorDescription = "description";

const keySuccess = "sucess";
const keyFailure = "fail";

const platform = MethodChannel(channelName);

void startAntiCheat({
  required Map params,
  required Function(Map success) onSuccess,
  required Function(Map error) onError,
}) async {
  try {
    Map result =
        await platform.invokeMethod<Map>(eventStartCheck, params) as Map;
    if (result.containsKey(keyResultId)) {
      onSuccess(result);
    } else {
      onError(result);
    }
  } on PlatformException catch (e) {
    Map genericError = <String, Object>{};
    genericError[keyResultErrorCode] = -1;
    genericError[keyResultId] = "";
    genericError[keyResultErrorDescription] = e.message;
    onError(genericError);
  }
}
```
Para utilizar a função startAntiCheat e comunicar o Flutter com o código nativo Android, você pode realizar a chamada da seguinte forma:
```dart
startAntiCheat(
  params: {}, // Adicione os parâmetros necessários para a validação
  onSuccess: (result) {
    setState(() {
      uuid = result[keyResultId]; // Atualiza o estado com o ID de autorização retornado
    });
  },
  onError: (error) {
    setState(() {
      // Atualiza o estado com as informações de erro
      this.error = error;
    });
  },
);
```
Essa chamada permite que o método nativo seja invocado e que o aplicativo reaja adequadamente aos resultados da validação, ajustando o estado do widget conforme necessário.

## Mapeamento de erros

