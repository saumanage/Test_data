@isTest
public class OptionsJSON2ApexTest {
  
    @isTest
     static void test_OptionsJSON2Apex() {

        // String jsonContent = '{"option" :  {"optionname": "Sport", "stock": "100", "weighting": "65","price": [{"type": "invoice", "currency": "USD", "source": "Kelley Blue Book", "ele_text": "19500"}, {"type": "appraisal", "currency": "USD", "delta": "percentage", "relativeto": "invoice", "source": "KBB"}, {"type": "msrp", "currency": "USD", "delta": "relative", "relativeto": "invoice", "source": "KBB", "ele_text": "200"}, {"type": "quote", "currency": "USD", "delta": "absolute", "ele_text": "19000"}, {"type": "offer", "currency": "USD", "delta": "relative", "relativeto": "invoice", "source": "KBB", "ele_text": "200"}, {"type": "call", "currency": "USD", "delta": "percentage", "relativeto": "msrp", "ele_text": "2"}, {"type": "asking", "currency": "USD", "delta": "percentage", "relativeto": "msrp", "ele_text": "2"}]}}';
        String jsonContent = '{ "option": {"optionname": "Sport","stock": "100","weighting": "65","price": [{"ele_text": "19500"}]}}';

        OptionsJSON2Apex Jsondatawrapper =  OptionsJSON2Apex.parse(jsonContent);
        
       string json = '[{"optionname": "Sport","manufacturercode": "p394","stock": "100","weighting": "65"},{"optionname": "Sport","manufacturercode": "p394","stock": "100","weighting": "65"}]';
        System.JSONParser parser = System.JSON.createParser(json);
        OptionsJSON2Apex.consumeObject(parser);
        
        String jsonContent2 = '{"option" :  {"optionname": "Sport", "stock": "100", "weighting": "65","price": [{"type": "invoice", "currency": "USD", "source": "Kelley Blue Book", "ele_text": "19500"}, {"type": "appraisal", "currency": "USD", "delta": "percentage", "relativeto": "invoice", "source": "KBB"}, {"type": "msrp", "currency": "USD", "delta": "relative", "relativeto": "invoice", "source": "KBB", "ele_text": "200"}, {"type": "quote", "currency": "USD", "delta": "absolute", "ele_text": "19000"}, {"type": "offer", "currency": "USD", "delta": "relative", "relativeto": "invoice", "source": "KBB", "ele_text": "200"}, {"type": "call", "currency": "USD", "delta": "percentage", "relativeto": "msrp", "ele_text": "2"}, {"type": "asking", "currency": "USD", "delta": "percentage", "relativeto": "msrp", "ele_text": "2"}]}}';
        OptionsJSON2Apex.parse(json);
        OptionsJSON2Apex.consumeObject(System.JSON.createParser(jsonContent2));
        
        OptionsJSON2Apex Jsondatawrapper2 =  OptionsJSON2Apex.parse(jsonContent2);
        
        String Price ='{"type": "invoice","currency": "USD", "source": "Kelley Blue Book","text": "19500"}';
        OptionsJSON2Apex.Option p = new OptionsJSON2Apex.Option(System.JSON.createParser(jsonContent2));
       // OptionsJSON2Apex.Option(System.JSON.createParser(jsonContent2));
       
       OptionsJSON2Apex.Price pc = new OptionsJSON2Apex.Price(parser);
       pc.type='Invoice';
       pc.currency_Z ='USD';
       pc.source='cc';
      pc.ele_text='43';
        pc.delta ='kd';
        pc.relativeto='dd';
    }   
/*
    private static String makeXMLString() {
        String xmlString = '';
        xmlString += '<option>';
        xmlString += '<optionname>Sport</optionname>';
        xmlString += '<stock>100</stock>';
        xmlString += '<weighting>65</weighting>';
        xmlString += '<price type="invoice" currency="USD" source="Kelley Blue Book">19500</price>';
        xmlString += '<price type="appraisal" currency="USD" delta="percentage" relativeto="invoice" source="KBB"/>';
        xmlString += '<price type="msrp" currency="USD" delta="relative" relativeto="invoice" source="KBB">200</price>';
        xmlString += '<price type="quote" currency="USD" delta="absolute">19000</price>';
        xmlString += '<price type="offer" currency="USD" delta="relative" relativeto="invoice" source="KBB">200</price>';
        xmlString += '<price type="call" currency="USD" delta="percentage" relativeto="msrp">2</price>';
        xmlString += '<price type="asking" currency="USD" delta="percentage" relativeto="msrp">2</price>';
        xmlString += '</option>';

        return xmlString;
    } */
}