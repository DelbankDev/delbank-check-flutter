SdkDelbank Plugin
O SdkDelbank é um plugin Flutter que integra o SDK Delbank em aplicativos Flutter, permitindo a execução de validações de autenticação usando o FastValidade via comunicação nativa Android. Este plugin fornece uma interface para o SDK nativo por meio de um MethodChannel.

Estrutura do Código
Classes e Interfaces
SdkDelbank: Classe principal que implementa FlutterPlugin, MethodCallHandler, ActivityAware, e ActivityResultListener. Esta classe gerencia a comunicação entre Flutter e o código nativo Android.

FlutterPlugin: Interface usada para registrar e desregistrar o plugin no ambiente Flutter.

MethodCallHandler: Interface usada para lidar com chamadas de métodos provenientes de Flutter.

ActivityAware: Interface que permite que o plugin interaja com o Activity que o hospeda.

ActivityResultListener: Interface usada para escutar e lidar com os resultados das atividades iniciadas pelo plugin.

Propriedades
channel: Um MethodChannel para comunicação entre o código Flutter e o código nativo Android.

result: Um MethodChannel.Result para enviar de volta os resultados das operações ao Flutter.

activity: Referência para a Activity corrente.

activityBinding: Referência para a ligação da Activity com o plugin.

context: Referência para o Context da aplicação.

Métodos
onMethodCall: Método que lida com chamadas de métodos do Flutter. O plugin atualmente suporta o método startCheck.

start: Método privado que inicializa a FastValidade a partir do SDK Delbank.

onAttachedToEngine: Método chamado quando o plugin é registrado no FlutterPluginBinding. Ele inicializa o MethodChannel.

onDetachedFromEngine: Método chamado quando o plugin é desregistrado do FlutterPluginBinding. Ele limpa as referências ao MethodChannel e ao context.

onAttachedToActivity: Método chamado quando o plugin é associado a uma Activity. Ele inicializa a Activity e registra o ActivityResultListener.

onDetachedFromActivityForConfigChanges: Método chamado quando o Activity é configurado para mudanças, porém não está implementado no momento.

onReattachedToActivityForConfigChanges: Método chamado quando o Activity é reanexado após mudanças de configuração.

onDetachedFromActivity: Método chamado quando o plugin é desanexado de uma Activity. Ele remove o ActivityResultListener e limpa as referências à Activity.

onActivityResult: Método que lida com os resultados das atividades iniciadas pelo plugin, como o retorno da FastValidade. Ele verifica o código de resultado e extrai os dados relevantes, como o SucessModel ou ErrorModel, para retornar ao Flutter.

Constantes
REQUEST_CODE: Código usado para identificar o resultado da atividade iniciada pelo plugin.

CHANNEL_NAME: Nome do MethodChannel utilizado para a comunicação.

CALL_METHOD: Método de chamada suportado pelo canal.

FIELD_NAME_RESULT_SUCCESS_OBJECT: Campo que contém o objeto de sucesso retornado da FastValidade.

FIELD_NAME_RESULT_ERROR_OBJECT: Campo que contém o objeto de erro retornado da FastValidade.

FIELD_NAME_RESULT_SUCCESS_ID: Campo que contém o ID de autorização em caso de sucesso.

FIELD_NAME_RESULT_ID: Campo que contém o ID do erro em caso de falha.

FIELD_NAME_RESULT_ERROR_CODE: Código de erro em caso de falha.

FIELD_NAME_RESULT_ERROR_DESCRIPTION: Descrição do erro em caso de falha.

Uso
Para utilizar este plugin em seu projeto Flutter, você deve seguir os seguintes passos:

Configuração do Gradle: Adicione o .aar do SDK Delbank ao seu projeto e configure o build.gradle do módulo conforme necessário.

Registro do Plugin: No seu projeto Flutter, registre o plugin para que ele possa ser utilizado nas chamadas Flutter.

Chamadas de Método: Use o método startCheck para iniciar a validação. O resultado da validação será retornado via MethodChannel.Result, contendo o SucessModel ou ErrorModel.