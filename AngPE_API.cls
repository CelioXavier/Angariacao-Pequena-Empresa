public class AngPE_API {
    
    public static HttpResponse makePostCallout(String ContractPE, String CNPJ, String CompanyName, String Name, String Email, String Agencia) {
        API_Profile__mdt eb = APIProfileHelper.retriveAPIProfile('Ang_PE');
        if(Agencia == null){Agencia = '0';}
        String agencia_convert = Agencia.remove('-').mid(0, 4);
        Integer branch = integer.valueOf(agencia_convert);  
        String CNPJ_conv = CNPJ.remove('.').remove('/').remove('-').mid(0,14);       
        
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(eb.Path__c); 
        request.setMethod('PUT');
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('x-api-key', eb.API_Key__c);
        
        JSONGenerator gen = JSON.createGenerator(true);        
        gen.writeStartObject();
        gen.writeStringField('idContrato', ContractPE);
        gen.writeStringField('nomeContrato', 'Pequena Empresa'); 
        gen.writeNumberField('idGbc', 1);        
        gen.writeFieldName('empresa');
        gen.writeStartObject();         
        gen.writeStringField('cnpj', CNPJ_conv);
        gen.writeStringField('razaoSocial', CompanyName);        
        gen.writeFieldName('destinatario');
        gen.writeStartObject();         
        gen.writeStringField('nome', Name); 
        gen.writeStringField('email', Email);
        gen.writeEndObject();
        gen.writeEndObject();
        gen.writeNumberField('txPremiosPeriodicos', 0);
        gen.writeNumberField('txResgates', 0);
        gen.writeNumberField('txAporteExtraInicial', 0);
        gen.writeNumberField('carenciaPrimeiroResgate', 0);
        gen.writeNumberField('intervaloEntreResgates', 0);
        gen.writeNumberField('carenciaPortabilidadeExterna', 0);
        gen.writeNumberField('intervaloEntrePortabilidade', 0);
        gen.writeNumberField('carenciaPortabilidadeInterna', 0);
        gen.writeNumberField('carenciaRiscoMorte', 0);
        gen.writeNumberField('periodoCoberturaRisco', 0);
        gen.writeNumberField('txRisco', 0);
        gen.writeNumberField('numeroAgencia', branch);
        gen.writeEndObject();
        
        String Jsons = gen.getAsString();
        System.debug(Jsons);
        request.setBody(Jsons);
        HttpResponse response = http.send(request);
        System.debug(response.getStatusCode());
        System.debug(response);
        if(response.getStatusCode() == 200) {
            System.debug(response.getBody());
        }else{
            System.debug('The status code returned was not expected: ' +
                         response.getStatusCode() + ' ' + response.getStatus());
        }
        return response; 
    }
}