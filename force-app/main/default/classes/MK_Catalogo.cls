public with sharing class MK_Catalogo implements HttpCalloutMock {
    private String mockResponse;
    
    public MK_Catalogo(String response) {
        this.mockResponse = response;
    }
    
    public HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setBody(mockResponse);
        res.setStatusCode(200);
        return res;
    }
}
