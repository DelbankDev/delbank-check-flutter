# DelCheck

O **DelCheck** é um SDK desenvolvido para a execução de validações de transações com o objetivo de garantir a segurança e integridade das transações realizadas. Este SDK proporciona uma solução robusta para autenticação e validação de processos transacionais, assegurando a conformidade com os padrões de segurança exigidos.

## Integração
Este manual fornece orientações detalhadas para a integração do SDK **DelCheck** em projetos desenvolvidos com Flutter e Android nativo. O objetivo é garantir a implementação adequada do SDK para maximizar a segurança e a eficácia das validações de transações.

### Configuração android

Para utilizar este plugin em seu projeto Flutter, você deve seguir os seguintes passos:
1. **Adicionar o Arquivo `.aar`**

   - Coloque o arquivo `.aar` do SDK Delbank na pasta `android/app/libs` do seu projeto.
2. **Configurar o `build.gradle`**

   - Abra o arquivo `build.gradle` localizado em `android/app/build.gradle`.
   - Adicione o seguinte código para incluir o diretório `libs` como uma fonte de dependências:

     ```groovy
     repositories {
         flatDir {
             dirs 'libs'
         }
     }
     ```

   - Adicione a dependência do SDK Delbank na seção `dependencies`:

     ```groovy
     dependencies {
         implementation(name: 'nome-do-arquivo-aar', ext: 'aar')
     }
     ```

     Substitua `'nome-do-arquivo-aar'` pelo nome real do arquivo `.aar` que você adicionou na pasta `libs`.

Esta configuração garante que o arquivo `.aar` do SDK Delbank seja corretamente incluído e reconhecido pelo seu projeto, permitindo que você utilize o SDK nas suas implementações.

3. **Adicionar o Arquivo `SdkDelbank.kt`**

   - Dentro da pasta `android`, localize o diretório `app/src/main/java/` (ou `kotlin/` dependendo da estrutura do seu projeto).
   - Navegue até o pacote onde deseja adicionar o arquivo `SdkDelbank.kt`. Por exemplo, se seu pacote é `com.example.my_flutter_app`, você deve navegar para `app/src/main/java/com/example/my_flutter_app/`.
   - Coloque o arquivo `SdkDelbank.kt` no diretório apropriado.

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


