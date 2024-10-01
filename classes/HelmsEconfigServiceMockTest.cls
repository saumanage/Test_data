@isTest
public class HelmsEconfigServiceMockTest implements HttpCalloutMock{
	public HTTPResponse respond(HTTPRequest request) {
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        string respBody='{\"mot\":{\"db_results\":{\"@when_cached\":\"\",\"@from_cache\":\"false\",\"@cached_by\":\"\",\"messages\":{\"message\":{\"@msg_type\":\"Informational\",\"@msg_number\":\"5000\",\"#text\":\"Nowarnings.\"}},\"models\":{\"model\":[{\"@id\":\"YG1H3PETW\",\"@model_name\":\"PILOTAWDSPORTBD\",\"@model_year\":\"2023\",\"@msrp\":\"999999.99\",\"attributes\":{\"attribute\":[{\"@id\":\"3787\",\"@is_standard\":\"Y\"}]},\"colors\":{\"exteriorcolor\":[{\"@id\":\"8083\",\"interiorcolor\":[{\"@id\":\"401\",\"@exterior_color_cd\":\"BK\"}]},{\"@id\":\"8386\",\"interiorcolor\":[{\"@id\":\"401\",\"@exterior_color_cd\":\"BU\"}]},{\"@id\":\"8573\",\"interiorcolor\":[{\"@id\":\"401\",\"@exterior_color_cd\":\"SI\"}]},{\"@id\":\"8783\",\"interiorcolor\":[{\"@id\":\"401\",\"@exterior_color_cd\":\"GA\"}]},{\"@id\":\"8889\",\"interiorcolor\":[{\"@id\":\"401\",\"@exterior_color_cd\":\"WX\"}]},{\"@id\":\"9126\",\"interiorcolor\":[{\"@id\":\"401\",\"@exterior_color_cd\":\"RL\"}]}]},\"accessories\":{\"accessory\":[{\"@op_cd\":\"PILOT23001\",\"@part_number\":\"08F20-T90-100A\"},{\"@op_cd\":\"PILOT23002\",\"@part_number\":\"08P04-T90-100\",\"rules\":{\"rule\":[{\"@cd\":\"E\",\"@msrp\":\"425.00\",\"@op_cd\":\"PILOT23020\",\"@derived\":\"0\"}]}},{\"@op_cd\":\"PILOT23003\",\"colors\":{\"color\":[{\"@id\":\"8083\",\"@part_number\":\"08P05-T90-110\"},{\"@id\":\"8573\",\"@part_number\":\"08P05-T90-130\"},{\"@id\":\"8783\",\"@part_number\":\"08P05-T90-140\"},{\"@id\":\"8889\",\"@part_number\":\"08P05-T90-150\"},{\"@id\":\"8386\",\"@part_number\":\"08P05-T90-160\"},{\"@id\":\"9126\",\"@part_number\":\"08P05-T90-180\"}]}},{\"@op_cd\":\"PILOT23004\",\"@part_number\":\"08P17-T90-110\",\"rules\":{\"reverserules\":{\"rule\":[{\"@cd\":\"I\",\"@msrp\":\"478.00\",\"@op_cd\":\"PILOT23202\"},{\"@cd\":\"I\",\"@msrp\":\"510.00\",\"@op_cd\":\"PILOT23201\"}]}}},{\"@op_cd\":\"PILOT23005\",\"@part_number\":\"08P20-T90-100\",\"rules\":{\"rule\":[{\"@cd\":\"E\",\"@msrp\":\"125.00\",\"@op_cd\":\"PILOT23010\",\"@derived\":\"0\"}],\"reverserules\":null}},{\"@op_cd\":\"PILOT23006\",\"@part_number\":\"08P48-T90-100\"},{\"@op_cd\":\"PILOT23007\",\"@part_number\":\"08U35-T90-P10\",\"rules\":{\"reverserules\":{\"rule\":[{\"@cd\":\"I\",\"@msrp\":\"405.00\",\"@op_cd\":\"PILOT23471\"}]}}},{\"@op_cd\":\"PILOT23008\",\"@part_number\":\"08W48-PL4-100A\",\"rules\":{\"rule\":[{\"@cd\":\"E\",\"@msrp\":\"23.00\",\"@op_cd\":\"PILOT23013\",\"@derived\":\"0\"}],\"reverserules\":null}},{\"@op_cd\":\"PILOT23009\",\"@part_number\":\"08L96-T90-100\"},{\"@op_cd\":\"PILOT23010\",\"colors\":{\"color\":[{\"@id\":\"8083\",\"@part_number\":\"08P20-T90-110A\"},{\"@id\":\"8573\",\"@part_number\":\"08P20-T90-130A\"},{\"@id\":\"8783\",\"@part_number\":\"08P20-T90-140A\"},{\"@id\":\"8889\",\"@part_number\":\"08P20-T90-150A\"},{\"@id\":\"8386\",\"@part_number\":\"08P20-T90-160A\"},{\"@id\":\"9126\",\"@part_number\":\"08P20-T90-180A\"}]},\"rules\":{\"rule\":[{\"@cd\":\"E\",\"@msrp\":\"55.00\",\"@op_cd\":\"PILOT23005\",\"@derived\":\"0\"}],\"reverserules\":null}},{\"@op_cd\":\"PILOT23011\",\"@part_number\":\"08W20-T90-100\",\"rules\":{\"rule\":[{\"@cd\":\"E\",\"@msrp\":\"1800.00\",\"@op_cd\":\"PILOT23485\",\"@derived\":\"0\"},{\"@cd\":\"E\",\"@msrp\":\"1800.00\",\"@op_cd\":\"PILOT23486\",\"@derived\":\"0\"},{\"@cd\":\"E\",\"@msrp\":\"2100.00\",\"@op_cd\":\"PILOT23031\",\"@derived\":\"0\"},{\"@cd\":\"E\",\"@msrp\":\"2100.00\",\"@op_cd\":\"PILOT23073\",\"@derived\":\"0\"},{\"@cd\":\"E\",\"@msrp\":\"2950.00\",\"@op_cd\":\"PILOT23474\",\"@derived\":\"0\"},{\"@cd\":\"E\",\"@msrp\":\"2950.00\",\"@op_cd\":\"PILOT23476\",\"@derived\":\"0\"}],\"reverserules\":null}},{\"@op_cd\":\"PILOT23013\",\"@part_number\":\"08W48-PL4-100\",\"rules\":{\"rule\":[{\"@cd\":\"E\",\"@msrp\":\"23.00\",\"@op_cd\":\"PILOT23008\",\"@derived\":\"0\"}],\"reverserules\":null}},{\"@op_cd\":\"PILOT23014\",\"@part_number\":\"08F20-3V0-100B\"},{\"@op_cd\":\"PILOT23016\",\"@part_number\":\"08F30-T90-100\",\"rules\":{\"rule\":[{\"@cd\":\"E\",\"@msrp\":\"350.00\",\"@op_cd\":\"PILOT23067\",\"@derived\":\"0\"}],\"reverserules\":null}},{\"@op_cd\":\"PILOT23017\",\"@part_number\":\"08L07-E09-101\",\"@rolled_up\":\"466.00\",\"rules\":{\"rule\":[{\"@cd\":\"R\",\"@msrp\":\"255.00\",\"@op_cd\":\"PILOT23077\",\"@derived\":\"0\"}]}},{\"@op_cd\":\"PILOT23018\",\"@part_number\":\"08L33-T90-100\",\"rules\":{\"rule\":[{\"@cd\":\"E\",\"@msrp\":\"130.00\",\"@op_cd\":\"PILOT23024\",\"@derived\":\"0\"},{\"@cd\":\"E\",\"@msrp\":\"730.00\",\"@op_cd\":\"PILOT23028\",\"@derived\":\"0\"}],\"reverserules\":null}},{\"@op_cd\":\"PILOT23019\",\"@part_number\":\"08865-FAK-100\"},{\"@op_cd\":\"PILOT23020\",\"@part_number\":\"08E12-T90-100\",\"rules\":{\"rule\":[{\"@cd\":\"E\",\"@msrp\":\"100.00\",\"@op_cd\":\"PILOT23002\",\"@derived\":\"0\"}],\"reverserules\":null}},{\"@op_cd\":\"PILOT23021\",\"@part_number\":\"08L03-E09-100C\",\"@rolled_up\":\"516.25\",\"rules\":{\"rule\":[{\"@cd\":\"R\",\"@msrp\":\"255.00\",\"@op_cd\":\"PILOT23077\",\"@derived\":\"0\"}]}},{\"@op_cd\":\"PILOT23022\",\"@part_number\":\"08L09-E09-101\",\"@rolled_up\":\"519.00\",\"rules\":{\"rule\":[{\"@cd\":\"R\",\"@msrp\":\"255.00\",\"@op_cd\":\"PILOT23077\",\"@derived\":\"0\"}]}},{\"@op_cd\":\"PILOT23024\",\"@part_number\":\"08P00-T90-100\",\"rules\":{\"rule\":[{\"@cd\":\"E\",\"@msrp\":\"600.00\",\"@op_cd\":\"PILOT23018\",\"@derived\":\"0\"},{\"@cd\":\"E\",\"@msrp\":\"730.00\",\"@op_cd\":\"PILOT23028\",\"@derived\":\"0\"}],\"reverserules\":{\"rule\":[{\"@cd\":\"I\",\"@msrp\":\"358.00\",\"@op_cd\":\"PILOT23200\"},{\"@cd\":\"I\",\"@msrp\":\"510.00\",\"@op_cd\":\"PILOT23201\"}]}}},{\"@op_cd\":\"PILOT23025\",\"@part_number\":\"08F20-T90-100C\"},{\"@op_cd\":\"PILOT23026\",\"@part_number\":\"08L05-E09-100\",\"@rolled_up\":\"424.00\",\"rules\":{\"rule\":[{\"@cd\":\"R\",\"@msrp\":\"255.00\",\"@op_cd\":\"PILOT23077\",\"@derived\":\"0\"}]}},{\"@op_cd\":\"PILOT23027\",\"@part_number\":\"08L07-E09-100A\",\"@rolled_up\":\"446.00\",\"rules\":{\"rule\":[{\"@cd\":\"R\",\"@msrp\":\"255.00\",\"@op_cd\":\"PILOT23077\",\"@derived\":\"0\"}]}},{\"@op_cd\":\"PILOT23028\",\"@part_number\":\"08L33-T90-100B\",\"rules\":{\"rule\":[{\"@cd\":\"E\",\"@msrp\":\"130.00\",\"@op_cd\":\"PILOT23024\",\"@derived\":\"0\"},{\"@cd\":\"E\",\"@msrp\":\"600.00\",\"@op_cd\":\"PILOT23018\",\"@derived\":\"0\"}],\"reverserules\":null}},{\"@op_cd\":\"PILOT23029\",\"@part_number\":\"08L92-T90-100B\",\"rules\":{\"rule\":[{\"@cd\":\"E\",\"@msrp\":\"310.00\",\"@op_cd\":\"PILOT23056\",\"@derived\":\"0\"}],\"reverserules\":null}},{\"@op_cd\":\"PILOT23031\",\"@part_number\":\"08W20-T90-100A\",\"rules\":{\"rule\":[{\"@cd\":\"E\",\"@msrp\":\"1800.00\",\"@op_cd\":\"PILOT23485\",\"@derived\":\"0\"},{\"@cd\":\"E\",\"@msrp\":\"1800.00\",\"@op_cd\":\"PILOT23486\",\"@derived\":\"0\"},{\"@cd\":\"E\",\"@msrp\":\"2100.00\",\"@op_cd\":\"PILOT23011\",\"@derived\":\"0\"},{\"@cd\":\"E\",\"@msrp\":\"2100.00\",\"@op_cd\":\"PILOT23073\",\"@derived\":\"0\"},{\"@cd\":\"E\",\"@msrp\":\"2950.00\",\"@op_cd\":\"PILOT23474\",\"@derived\":\"0\"},{\"@cd\":\"E\",\"@msrp\":\"2950.00\",\"@op_cd\":\"PILOT23476\",\"@derived\":\"0\"}],\"reverserules\":null}},{\"@op_cd\":\"PILOT23032\",\"@part_number\":\"08P42-T90-100A\",\"rules\":{\"reverserules\":{\"rule\":[{\"@cd\":\"I\",\"@msrp\":\"700.00\",\"@op_cd\":\"PILOT23703\"}]}}},{\"@op_cd\":\"PILOT23033\",\"@part_number\":\"08R04-T90-100\"},{\"@op_cd\":\"PILOT23034\",\"@part_number\":\"08P32-T90-110C\"},{\"@op_cd\":\"PILOT23035\",\"@part_number\":\"08P32-T90-110F\"},{\"@op_cd\":\"PILOT23036\",\"@part_number\":\"08P48-T90-100A\"},{\"@op_cd\":\"PILOT23037\",\"@part_number\":\"08T44-SNA-103\"},{\"@op_cd\":\"PILOT23038\",\"@part_number\":\"08U20-S9V-101\"},{\"@op_cd\":\"PILOT23039\",\"@part_number\":\"08U25-S5D-116\"},{\"@op_cd\":\"PILOT23041\",\"@part_number\":\"08F04-T90-100\"},{\"@op_cd\":\"PILOT23043\",\"@part_number\":\"08L20-E09-100B\",\"@rolled_up\":\"778.00\",\"rules\":{\"rule\":[{\"@cd\":\"R\",\"@msrp\":\"255.00\",\"@op_cd\":\"PILOT23077\",\"@derived\":\"0\"}]}},{\"@op_cd\":\"PILOT23044\",\"@part_number\":\"08L92-S9V-100G\"},{\"@op_cd\":\"PILOT23045\",\"@part_number\":\"08L92-S9V-100H\"},{\"@op_cd\":\"PILOT23046\",\"@part_number\":\"08L92-SJC-100A\"},{\"@op_cd\":\"PILOT23048\",\"@part_number\":\"08P21-T90-100\"},{\"@op_cd\":\"PILOT23049\",\"@part_number\":\"08P32-T90-110A\"},{\"@op_cd\":\"PILOT23050\",\"@part_number\":\"08U45-T90-100\",\"rules\":{\"reverserules\":{\"rule\":[{\"@cd\":\"I\",\"@msrp\":\"358.00\",\"@op_cd\":\"PILOT23200\"},{\"@cd\":\"I\",\"@msrp\":\"478.00\",\"@op_cd\":\"PILOT23202\"},{\"@cd\":\"I\",\"@msrp\":\"510.00\",\"@op_cd\":\"PILOT23201\"}]}}},{\"@op_cd\":\"PILOT23054\",\"@part_number\":\"08L20-E09-100A\",\"@rolled_up\":\"810.00\",\"rules\":{\"rule\":[{\"@cd\":\"R\",\"@msrp\":\"255.00\",\"@op_cd\":\"PILOT23077\",\"@derived\":\"0\"}]}},{\"@op_cd\":\"PILOT23055\",\"@part_number\":\"08L20-E09-101C\",\"@rolled_up\":\"649.00\",\"rules\":{\"rule\":[{\"@cd\":\"R\",\"@msrp\":\"255.00\",\"@op_cd\":\"PILOT23077\",\"@derived\":\"0\"}]}},{\"@op_cd\":\"PILOT23056\",\"@part_number\":\"08L92-T90-100\",\"@rolled_up\":\"565.00\",\"rules\":{\"rule\":[{\"@cd\":\"E\",\"@msrp\":\"135.00\",\"@op_cd\":\"PILOT23029\",\"@derived\":\"0\"},{\"@cd\":\"R\",\"@msrp\":\"255.00\",\"@op_cd\":\"PILOT23062\",\"@derived\":\"0\"}]}},{\"@op_cd\":\"PILOT23057\",\"@part_number\":\"08L92-T90-100A\"},{\"@op_cd\":\"PILOT23059\",\"@part_number\":\"08W42-PL4-100A\"},{\"@op_cd\":\"PILOT23060\",\"@part_number\":\"08W42-TG7-101A\",\"rules\":{\"reverserules\":{\"rule\":[{\"@cd\":\"I\",\"@msrp\":\"358.00\",\"@op_cd\":\"PILOT23200\"},{\"@cd\":\"I\",\"@msrp\":\"478.00\",\"@op_cd\":\"PILOT23202\"}]}}},{\"@op_cd\":\"PILOT23062\",\"@part_number\":\"08L91-T90-100\",\"rules\":{\"reverserules\":{\"rule\":[{\"@cd\":\"R\",\"@msrp\":\"310.00\",\"@op_cd\":\"PILOT23056\"}]}}},{\"@op_cd\":\"PILOT23063\",\"@part_number\":\"08P42-T90-100B\",\"rules\":{\"reverserules\":{\"rule\":[{\"@cd\":\"I\",\"@msrp\":\"700.00\",\"@op_cd\":\"PILOT23703\"}]}}},{\"@op_cd\":\"PILOT23064\",\"@part_number\":\"08Z04-SCV-110B\"},{\"@op_cd\":\"PILOT23065\",\"@part_number\":\"08F30-T90-100C\",\"rules\":{\"rule\":[{\"@cd\":\"E\",\"@msrp\":\"200.00\",\"@op_cd\":\"PILOT23071\",\"@derived\":\"0\"}],\"reverserules\":null}},{\"@op_cd\":\"PILOT23066\",\"@part_number\":\"08F20-T90-100\"},{\"@op_cd\":\"PILOT23067\",\"@part_number\":\"08F30-T90-100B\",\"rules\":{\"rule\":[{\"@cd\":\"E\",\"@msrp\":\"350.00\",\"@op_cd\":\"PILOT23016\",\"@derived\":\"0\"}],\"reverserules\":null}},{\"@op_cd\":\"PILOT23068\",\"@part_number\":\"08U97-T90-110\"},{\"@op_cd\":\"PILOT23069\",\"@part_number\":\"08U35-T90-100A\",\"rules\":{\"reverserules\":{\"rule\":[{\"@cd\":\"I\",\"@msrp\":\"700.00\",\"@op_cd\":\"PILOT23703\"}]}}},{\"@op_cd\":\"PILOT23071\",\"@part_number\":\"08F30-T90-100A\",\"rules\":{\"rule\":[{\"@cd\":\"E\",\"@msrp\":\"200.00\",\"@op_cd\":\"PILOT23065\",\"@derived\":\"0\"}]}},{\"@op_cd\":\"PILOT23072\",\"@part_number\":\"08V27-T90-100F\"},{\"@op_cd\":\"PILOT23073\",\"@part_number\":\"08W20-T90-100B\",\"rules\":{\"rule\":[{\"@cd\":\"E\",\"@msrp\":\"1800.00\",\"@op_cd\":\"PILOT23485\",\"@derived\":\"0\"},{\"@cd\":\"E\",\"@msrp\":\"1800.00\",\"@op_cd\":\"PILOT23486\",\"@derived\":\"0\"},{\"@cd\":\"E\",\"@msrp\":\"2100.00\",\"@op_cd\":\"PILOT23011\",\"@derived\":\"0\"},{\"@cd\":\"E\",\"@msrp\":\"2100.00\",\"@op_cd\":\"PILOT23031\",\"@derived\":\"0\"},{\"@cd\":\"E\",\"@msrp\":\"2950.00\",\"@op_cd\":\"PILOT23474\",\"@derived\":\"0\"},{\"@cd\":\"E\",\"@msrp\":\"2950.00\",\"@op_cd\":\"PILOT23476\",\"@derived\":\"0\"}],\"reverserules\":null}},{\"@op_cd\":\"PILOT23077\",\"@part_number\":\"08L04-T90-100\",\"rules\":{\"reverserules\":{\"rule\":[{\"@cd\":\"R\",\"@msrp\":\"169.00\",\"@op_cd\":\"PILOT23026\"},{\"@cd\":\"R\",\"@msrp\":\"191.00\",\"@op_cd\":\"PILOT23027\"},{\"@cd\":\"R\",\"@msrp\":\"211.00\",\"@op_cd\":\"PILOT23017\"},{\"@cd\":\"R\",\"@msrp\":\"261.25\",\"@op_cd\":\"PILOT23021\"},{\"@cd\":\"R\",\"@msrp\":\"264.00\",\"@op_cd\":\"PILOT23022\"},{\"@cd\":\"R\",\"@msrp\":\"394.00\",\"@op_cd\":\"PILOT23055\"},{\"@cd\":\"R\",\"@msrp\":\"523.00\",\"@op_cd\":\"PILOT23043\"},{\"@cd\":\"R\",\"@msrp\":\"555.00\",\"@op_cd\":\"PILOT23054\"}]}}},{\"@op_cd\":\"PILOT23200\",\"rules\":{\"rule\":[{\"@cd\":\"E\",\"@msrp\":\"478.00\",\"@op_cd\":\"PILOT23202\",\"@derived\":\"0\"},{\"@cd\":\"E\",\"@msrp\":\"510.00\",\"@op_cd\":\"PILOT23201\",\"@derived\":\"0\"},{\"@cd\":\"I\",\"@msrp\":\"98.00\",\"@op_cd\":\"PILOT23060\",\"@derived\":\"0\"},{\"@cd\":\"I\",\"@msrp\":\"130.00\",\"@op_cd\":\"PILOT23024\",\"@derived\":\"0\"},{\"@cd\":\"I\",\"@msrp\":\"130.00\",\"@op_cd\":\"PILOT23050\",\"@derived\":\"0\"}],\"reverserules\":null}},{\"@op_cd\":\"PILOT23201\",\"rules\":{\"rule\":[{\"@cd\":\"E\",\"@msrp\":\"358.00\",\"@op_cd\":\"PILOT23200\",\"@derived\":\"0\"},{\"@cd\":\"E\",\"@msrp\":\"478.00\",\"@op_cd\":\"PILOT23202\",\"@derived\":\"0\"},{\"@cd\":\"I\",\"@msrp\":\"130.00\",\"@op_cd\":\"PILOT23024\",\"@derived\":\"0\"},{\"@cd\":\"I\",\"@msrp\":\"130.00\",\"@op_cd\":\"PILOT23050\",\"@derived\":\"0\"},{\"@cd\":\"I\",\"@msrp\":\"250.00\",\"@op_cd\":\"PILOT23004\",\"@derived\":\"0\"}],\"reverserules\":null}},{\"@op_cd\":\"PILOT23202\",\"rules\":{\"rule\":[{\"@cd\":\"E\",\"@msrp\":\"358.00\",\"@op_cd\":\"PILOT23200\",\"@derived\":\"0\"},{\"@cd\":\"E\",\"@msrp\":\"510.00\",\"@op_cd\":\"PILOT23201\",\"@derived\":\"0\"},{\"@cd\":\"I\",\"@msrp\":\"98.00\",\"@op_cd\":\"PILOT23060\",\"@derived\":\"0\"},{\"@cd\":\"I\",\"@msrp\":\"130.00\",\"@op_cd\":\"PILOT23050\",\"@derived\":\"0\"},{\"@cd\":\"I\",\"@msrp\":\"250.00\",\"@op_cd\":\"PILOT23004\",\"@derived\":\"0\"}],\"reverserules\":null}},{\"@op_cd\":\"PILOT23204\",\"@part_number\":\"08L04-T90-100\",\"rules\":{\"reverserules\":null}},{\"@op_cd\":\"PILOT23471\",\"colors\":{\"color\":[{\"@id\":\"8083\"},{\"@id\":\"8386\"},{\"@id\":\"8573\"},{\"@id\":\"8783\"},{\"@id\":\"8889\"},{\"@id\":\"9126\"}]},\"rules\":{\"rule\":[{\"@cd\":\"I\",\"@msrp\":\"31.65\",\"@op_cd\":\"PILOT23490\",\"@derived\":\"0\"},{\"@cd\":\"I\",\"@msrp\":\"70.00\",\"@op_cd\":\"PILOT23493\",\"@derived\":\"0\"},{\"@cd\":\"I\",\"@msrp\":\"300.00\",\"@op_cd\":\"PILOT23007\",\"@derived\":\"0\"}]}},{\"@op_cd\":\"PILOT23474\",\"colors\":{\"color\":[{\"@id\":\"8083\"},{\"@id\":\"8386\"},{\"@id\":\"8573\"},{\"@id\":\"8783\"},{\"@id\":\"8889\"},{\"@id\":\"9126\"}]},\"rules\":{\"rule\":[{\"@cd\":\"E\",\"@msrp\":\"2100.00\",\"@op_cd\":\"PILOT23011\",\"@derived\":\"0\"},{\"@cd\":\"E\",\"@msrp\":\"2100.00\",\"@op_cd\":\"PILOT23031\",\"@derived\":\"0\"},{\"@cd\":\"E\",\"@msrp\":\"2100.00\",\"@op_cd\":\"PILOT23073\",\"@derived\":\"0\"},{\"@cd\":\"E\",\"@msrp\":\"2950.00\",\"@op_cd\":\"PILOT23476\",\"@derived\":\"0\"},{\"@cd\":\"I\",\"@msrp\":\"50.00\",\"@op_cd\":\"PILOT23498\",\"@derived\":\"0\"},{\"@cd\":\"I\",\"@msrp\":\"108.20\",\"@op_cd\":\"PILOT23504\",\"@derived\":\"0\"},{\"@cd\":\"I\",\"@msrp\":\"300.00\",\"@op_cd\":\"PILOT23499\",\"@derived\":\"0\"},{\"@cd\":\"I\",\"@msrp\":\"350.00\",\"@op_cd\":\"PILOT23505\",\"@derived\":\"0\"},{\"@cd\":\"I\",\"@msrp\":\"600.00\",\"@op_cd\":\"PILOT23496\",\"@derived\":\"0\"},{\"@cd\":\"I\",\"@msrp\":\"1800.00\",\"@op_cd\":\"PILOT23485\",\"@derived\":\"0\"}],\"reverserules\":null}},{\"@op_cd\":\"PILOT23476\",\"colors\":{\"color\":[{\"@id\":\"8083\"},{\"@id\":\"8386\"},{\"@id\":\"8573\"},{\"@id\":\"8783\"},{\"@id\":\"8889\"},{\"@id\":\"9126\"}]},\"rules\":{\"rule\":[{\"@cd\":\"E\",\"@msrp\":\"2100.00\",\"@op_cd\":\"PILOT23011\",\"@derived\":\"0\"},{\"@cd\":\"E\",\"@msrp\":\"2100.00\",\"@op_cd\":\"PILOT23031\",\"@derived\":\"0\"},{\"@cd\":\"E\",\"@msrp\":\"2100.00\",\"@op_cd\":\"PILOT23073\",\"@derived\":\"0\"},{\"@cd\":\"E\",\"@msrp\":\"2950.00\",\"@op_cd\":\"PILOT23474\",\"@derived\":\"0\"},{\"@cd\":\"I\",\"@msrp\":\"50.00\",\"@op_cd\":\"PILOT23498\",\"@derived\":\"0\"},{\"@cd\":\"I\",\"@msrp\":\"108.20\",\"@op_cd\":\"PILOT23504\",\"@derived\":\"0\"},{\"@cd\":\"I\",\"@msrp\":\"300.00\",\"@op_cd\":\"PILOT23499\",\"@derived\":\"0\"},{\"@cd\":\"I\",\"@msrp\":\"350.00\",\"@op_cd\":\"PILOT23494\",\"@derived\":\"0\"},{\"@cd\":\"I\",\"@msrp\":\"600.00\",\"@op_cd\":\"PILOT23496\",\"@derived\":\"0\"},{\"@cd\":\"I\",\"@msrp\":\"1800.00\",\"@op_cd\":\"PILOT23486\",\"@derived\":\"0\"}],\"reverserules\":null}},{\"@op_cd\":\"PILOT23478\",\"colors\":{\"color\":[{\"@id\":\"8083\"},{\"@id\":\"8386\"},{\"@id\":\"8573\"},{\"@id\":\"8783\"},{\"@id\":\"8889\"},{\"@id\":\"9126\"}]},\"rules\":{\"rule\":[{\"@cd\":\"I\",\"@msrp\":\"100.00\",\"@op_cd\":\"PILOT23495\",\"@derived\":\"0\"}]}},{\"@op_cd\":\"PILOT23480\",\"colors\":{\"color\":[{\"@id\":\"8083\"},{\"@id\":\"8386\"},{\"@id\":\"8573\"},{\"@id\":\"8783\"},{\"@id\":\"8889\"},{\"@id\":\"9126\"}]},\"rules\":{\"rule\":[{\"@cd\":\"I\",\"@msrp\":\"46.00\",\"@op_cd\":\"PILOT23492\",\"@derived\":\"0\"},{\"@cd\":\"I\",\"@msrp\":\"135.00\",\"@op_cd\":\"PILOT23502\",\"@derived\":\"0\"},{\"@cd\":\"I\",\"@msrp\":\"255.00\",\"@op_cd\":\"PILOT23500\",\"@derived\":\"0\"},{\"@cd\":\"I\",\"@msrp\":\"310.00\",\"@op_cd\":\"PILOT23501\",\"@derived\":\"0\"}]}},{\"@op_cd\":\"PILOT23485\",\"@part_number\":\"08W20-T90-P00B\",\"rules\":{\"rule\":[{\"@cd\":\"E\",\"@msrp\":\"1800.00\",\"@op_cd\":\"PILOT23486\",\"@derived\":\"0\"},{\"@cd\":\"E\",\"@msrp\":\"2100.00\",\"@op_cd\":\"PILOT23011\",\"@derived\":\"0\"},{\"@cd\":\"E\",\"@msrp\":\"2100.00\",\"@op_cd\":\"PILOT23031\",\"@derived\":\"0\"},{\"@cd\":\"E\",\"@msrp\":\"2100.00\",\"@op_cd\":\"PILOT23073\",\"@derived\":\"0\"}],\"reverserules\":{\"rule\":[{\"@cd\":\"I\",\"@msrp\":\"2950.00\",\"@op_cd\":\"PILOT23474\"}]}}},{\"@op_cd\":\"PILOT23486\",\"@part_number\":\"08W20-T90-P00A\",\"rules\":{\"rule\":[{\"@cd\":\"E\",\"@msrp\":\"1800.00\",\"@op_cd\":\"PILOT23485\",\"@derived\":\"0\"},{\"@cd\":\"E\",\"@msrp\":\"2100.00\",\"@op_cd\":\"PILOT23011\",\"@derived\":\"0\"},{\"@cd\":\"E\",\"@msrp\":\"2100.00\",\"@op_cd\":\"PILOT23031\",\"@derived\":\"0\"},{\"@cd\":\"E\",\"@msrp\":\"2100.00\",\"@op_cd\":\"PILOT23073\",\"@derived\":\"0\"}],\"reverserules\":{\"rule\":[{\"@cd\":\"I\",\"@msrp\":\"2950.00\",\"@op_cd\":\"PILOT23476\"}]}}},{\"@op_cd\":\"PILOT23490\",\"@part_number\":\"08865-FAK-P00\",\"rules\":{\"reverserules\":{\"rule\":[{\"@cd\":\"I\",\"@msrp\":\"405.00\",\"@op_cd\":\"PILOT23471\"}]}}},{\"@op_cd\":\"PILOT23492\",\"@part_number\":\"08L92-T90-P00A\",\"rules\":{\"reverserules\":{\"rule\":[{\"@cd\":\"I\",\"@msrp\":\"750.00\",\"@op_cd\":\"PILOT23480\"}]}}},{\"@op_cd\":\"PILOT23493\",\"@part_number\":\"08L96-T90-P00\",\"rules\":{\"reverserules\":{\"rule\":[{\"@cd\":\"I\",\"@msrp\":\"405.00\",\"@op_cd\":\"PILOT23471\"}]}}},{\"@op_cd\":\"PILOT23494\",\"@part_number\":\"08F30-T90-P00\",\"rules\":{\"reverserules\":{\"rule\":[{\"@cd\":\"I\",\"@msrp\":\"2950.00\",\"@op_cd\":\"PILOT23476\"}]}}},{\"@op_cd\":\"PILOT23495\",\"@part_number\":\"08P04-T90-P00\",\"rules\":{\"reverserules\":{\"rule\":[{\"@cd\":\"I\",\"@msrp\":\"290.00\",\"@op_cd\":\"PILOT23478\"}]}}},{\"@op_cd\":\"PILOT23496\",\"@part_number\":\"08P21-T90-P00\",\"rules\":{\"reverserules\":{\"rule\":[{\"@cd\":\"I\",\"@msrp\":\"2950.00\",\"@op_cd\":\"PILOT23474\"},{\"@cd\":\"I\",\"@msrp\":\"2950.00\",\"@op_cd\":\"PILOT23476\"}]}}},{\"@op_cd\":\"PILOT23498\",\"@part_number\":\"08F20-T90-P00C\",\"rules\":{\"reverserules\":{\"rule\":[{\"@cd\":\"I\",\"@msrp\":\"2950.00\",\"@op_cd\":\"PILOT23474\"},{\"@cd\":\"I\",\"@msrp\":\"2950.00\",\"@op_cd\":\"PILOT23476\"}]}}},{\"@op_cd\":\"PILOT23499\",\"@part_number\":\"08F04-T90-P00\",\"rules\":{\"reverserules\":{\"rule\":[{\"@cd\":\"I\",\"@msrp\":\"2950.00\",\"@op_cd\":\"PILOT23474\"},{\"@cd\":\"I\",\"@msrp\":\"2950.00\",\"@op_cd\":\"PILOT23476\"}]}}},{\"@op_cd\":\"PILOT23500\",\"@part_number\":\"08L91-T90-P00\",\"rules\":{\"reverserules\":{\"rule\":[{\"@cd\":\"I\",\"@msrp\":\"750.00\",\"@op_cd\":\"PILOT23480\"}]}}},{\"@op_cd\":\"PILOT23501\",\"@part_number\":\"08L92-T90-P00\",\"rules\":{\"reverserules\":{\"rule\":[{\"@cd\":\"I\",\"@msrp\":\"750.00\",\"@op_cd\":\"PILOT23480\"}]}}},{\"@op_cd\":\"PILOT23502\",\"@part_number\":\"08L92-T90-P00B\",\"rules\":{\"reverserules\":{\"rule\":[{\"@cd\":\"I\",\"@msrp\":\"750.00\",\"@op_cd\":\"PILOT23480\"}]}}},{\"@op_cd\":\"PILOT23504\",\"@part_number\":\"42753-T3R-A04\",\"rules\":{\"reverserules\":{\"rule\":[{\"@cd\":\"I\",\"@msrp\":\"2950.00\",\"@op_cd\":\"PILOT23474\"},{\"@cd\":\"I\",\"@msrp\":\"2950.00\",\"@op_cd\":\"PILOT23476\"}]}}},{\"@op_cd\":\"PILOT23505\",\"@part_number\":\"08F30-T90-P00B\",\"rules\":{\"reverserules\":{\"rule\":[{\"@cd\":\"I\",\"@msrp\":\"2950.00\",\"@op_cd\":\"PILOT23474\"}]}}},{\"@op_cd\":\"PILOT23510\",\"@part_number\":\"08R79-PS8-100B\"},{\"@op_cd\":\"PILOT23703\",\"rules\":{\"rule\":[{\"@cd\":\"I\",\"@msrp\":\"110.00\",\"@op_cd\":\"PILOT23032\",\"@derived\":\"0\"},{\"@cd\":\"I\",\"@msrp\":\"110.00\",\"@op_cd\":\"PILOT23063\",\"@derived\":\"0\"},{\"@cd\":\"I\",\"@msrp\":\"480.00\",\"@op_cd\":\"PILOT23069\",\"@derived\":\"0\"}]}}]}}]},\"colors\":{\"color\":[{\"@id\":\"401\",\"@name\":\"Black\",\"@color_cd\":\"BK\",\"@color_type\":\"I\"},{\"@id\":\"8083\",\"@name\":\"CrystalBlackPearl\",\"@color_cd\":\"BK\",\"@mfg_color_cd\":\"NH-731P\",\"@color_type\":\"E\"},{\"@id\":\"8386\",\"@name\":\"ObsidianBluePearl\",\"@color_cd\":\"BU\",\"@mfg_color_cd\":\"B-588P\",\"@color_type\":\"E\"},{\"@id\":\"8573\",\"@name\":\"LunarSilverMetallic\",\"@color_cd\":\"SI\",\"@mfg_color_cd\":\"NH-830M\",\"@color_type\":\"E\"},{\"@id\":\"8783\",\"@name\":\"SonicGrayPearl\",\"@color_cd\":\"GA\",\"@mfg_color_cd\":\"NH-877P\",\"@color_type\":\"E\"},{\"@id\":\"8889\",\"@name\":\"PlatinumWhitePearl\",\"@color_cd\":\"WB\",\"@mfg_color_cd\":\"NH-883P\",\"@color_type\":\"E\"},{\"@id\":\"9126\",\"@name\":\"RadiantRedMetallicII\",\"@color_cd\":\"RE\",\"@mfg_color_cd\":\"R-580M\",\"@color_type\":\"E\"}]},\"accessories\":{\"accessory\":[{\"@op_cd\":\"PILOT23001\",\"@name\":\"Emblems-RearAWD,GlossBlack\",\"@quantity\":\"1\",\"@labor_time\":\"0.20\",\"@msrp\":\"35.00\",\"@invoice_price\":\"21.0000\"},{\"@op_cd\":\"PILOT23002\",\"@name\":\"DoorSillProtectionFilm\",\"@quantity\":\"1\",\"@labor_time\":\"0.40\",\"@msrp\":\"100.00\",\"@invoice_price\":\"60.0000\"},{\"@op_cd\":\"PILOT23003\",\"@name\":\"BodySideMolding\",\"@quantity\":\"1\",\"@labor_time\":\"0.40\",\"@msrp\":\"250.00\",\"@invoice_price\":\"150.0000\"},{\"@op_cd\":\"PILOT23004\",\"@name\":\"All-SeasonFloorMats\",\"@quantity\":\"1\",\"@labor_time\":\"0.10\",\"@msrp\":\"250.00\",\"@invoice_price\":\"150.0000\"},{\"@op_cd\":\"PILOT23005\",\"@name\":\"DoorEdgeFilm\",\"@quantity\":\"1\",\"@labor_time\":\"0.40\",\"@msrp\":\"55.00\",\"@invoice_price\":\"33.0000\"},{\"@op_cd\":\"PILOT23006\",\"@name\":\"RearBumperApplique\",\"@quantity\":\"1\",\"@labor_time\":\"0.20\",\"@msrp\":\"80.00\",\"@invoice_price\":\"48.0000\"},{\"@op_cd\":\"PILOT23007\",\"@name\":\"CargoCover\",\"@is_ppo\":\"1\",\"@quantity\":\"1\",\"@labor_time\":\"0.10\",\"@msrp\":\"300.00\",\"@invoice_price\":\"225.0000\"},{\"@op_cd\":\"PILOT23008\",\"@name\":\"ValveStemCaps,Black\",\"@quantity\":\"1\",\"@labor_time\":\"0.10\",\"@msrp\":\"23.00\",\"@invoice_price\":\"13.8000\"},{\"@op_cd\":\"PILOT23009\",\"@name\":\"CargoNet\",\"@quantity\":\"1\",\"@labor_time\":\"0.10\",\"@msrp\":\"70.00\",\"@invoice_price\":\"42.0000\"},{\"@op_cd\":\"PILOT23010\",\"@name\":\"DoorEdgeGuards\",\"@quantity\":\"1\",\"@labor_time\":\"0.40\",\"@msrp\":\"125.00\",\"@invoice_price\":\"75.0000\"},{\"@op_cd\":\"PILOT23011\",\"@name\":\"20-inMachineCutBlackAlloyWheels\",\"@is_ppo\":\"1\",\"@quantity\":\"4\",\"@labor_time\":\"1.60\",\"@msrp\":\"2100.00\",\"@invoice_price\":\"1260.0000\"},{\"@op_cd\":\"PILOT23013\",\"@name\":\"ValveStemCaps,Chrome\",\"@quantity\":\"1\",\"@labor_time\":\"0.10\",\"@msrp\":\"23.00\",\"@invoice_price\":\"13.8000\"},{\"@op_cd\":\"PILOT23014\",\"@name\":\"Emblems-RearSport,GlossBlack\",\"@quantity\":\"1\",\"@labor_time\":\"0.20\",\"@msrp\":\"35.00\",\"@invoice_price\":\"21.0000\"},{\"@op_cd\":\"PILOT23016\",\"@name\":\"SideDecal,Bronze,HPD\",\"@quantity\":\"1\",\"@labor_time\":\"0.40\",\"@msrp\":\"350.00\",\"@invoice_price\":\"210.0000\"},{\"@op_cd\":\"PILOT23017\",\"@name\":\"BikeAttachment,FrameMount\",\"@quantity\":\"1\",\"@labor_time\":\"0.40\",\"@msrp\":\"211.00\",\"@invoice_price\":\"145.9100\"},{\"@op_cd\":\"PILOT23018\",\"@name\":\"RunningBoards\",\"@quantity\":\"1\",\"@labor_time\":\"0.70\",\"@msrp\":\"600.00\",\"@invoice_price\":\"360.0000\"},{\"@op_cd\":\"PILOT23019\",\"@name\":\"First-AidKit\",\"@quantity\":\"1\",\"@msrp\":\"34.00\",\"@invoice_price\":\"20.4000\"},{\"@op_cd\":\"PILOT23020\",\"@name\":\"DoorSillTrim-Illuminated\",\"@quantity\":\"1\",\"@labor_time\":\"1.50\",\"@msrp\":\"425.00\",\"@invoice_price\":\"255.0000\"},{\"@op_cd\":\"PILOT23021\",\"@name\":\"Ski/SnowboardAttachment\",\"@quantity\":\"1\",\"@labor_time\":\"0.20\",\"@msrp\":\"261.25\",\"@invoice_price\":\"156.7500\"},{\"@op_cd\":\"PILOT23022\",\"@name\":\"KayakAttachment\",\"@quantity\":\"1\",\"@labor_time\":\"0.40\",\"@msrp\":\"264.00\",\"@invoice_price\":\"171.6100\"},{\"@op_cd\":\"PILOT23024\",\"@name\":\"SplashGuardSet\",\"@quantity\":\"1\",\"@labor_time\":\"0.40\",\"@msrp\":\"130.00\",\"@invoice_price\":\"78.0000\"},{\"@op_cd\":\"PILOT23025\",\"@name\":\"Emblems-RearHPD,GlossBlack\",\"@quantity\":\"1\",\"@labor_time\":\"0.10\",\"@msrp\":\"50.00\",\"@invoice_price\":\"37.5000\"},{\"@op_cd\":\"PILOT23026\",\"@name\":\"Surf/PaddleboardAttachment\",\"@quantity\":\"1\",\"@labor_time\":\"0.40\",\"@msrp\":\"169.00\",\"@invoice_price\":\"101.4000\"},{\"@op_cd\":\"PILOT23027\",\"@name\":\"BikeAttachment,ForkMount\",\"@quantity\":\"1\",\"@labor_time\":\"0.40\",\"@msrp\":\"191.00\",\"@invoice_price\":\"117.9900\"},{\"@op_cd\":\"PILOT23028\",\"@name\":\"RunningBoard,TubeStep\",\"@quantity\":\"1\",\"@labor_time\":\"0.70\",\"@msrp\":\"730.00\",\"@invoice_price\":\"438.0000\"},{\"@op_cd\":\"PILOT23029\",\"@name\":\"TrailerHitchPanel,Black\",\"@quantity\":\"1\",\"@msrp\":\"135.00\",\"@invoice_price\":\"81.0000\"},{\"@op_cd\":\"PILOT23031\",\"@name\":\"20-inMatteBronzeAlloyWheels-HPD\",\"@is_ppo\":\"1\",\"@quantity\":\"4\",\"@labor_time\":\"1.60\",\"@msrp\":\"2100.00\",\"@invoice_price\":\"1260.0000\"},{\"@op_cd\":\"PILOT23032\",\"@name\":\"CargoSidePanelProtectors\",\"@quantity\":\"1\",\"@labor_time\":\"0.70\",\"@msrp\":\"110.00\",\"@invoice_price\":\"66.0000\"},{\"@op_cd\":\"PILOT23033\",\"@name\":\"DoorVisors\",\"@quantity\":\"1\",\"@labor_time\":\"0.60\",\"@msrp\":\"300.00\",\"@invoice_price\":\"180.0000\"},{\"@op_cd\":\"PILOT23034\",\"@name\":\"SeatCover-2ndRow8P\",\"@quantity\":\"1\",\"@labor_time\":\"0.20\",\"@msrp\":\"300.00\",\"@invoice_price\":\"180.0000\"},{\"@op_cd\":\"PILOT23035\",\"@name\":\"SeatCover-3rdRow\",\"@quantity\":\"1\",\"@labor_time\":\"0.20\",\"@msrp\":\"270.00\",\"@invoice_price\":\"162.0000\"},{\"@op_cd\":\"PILOT23036\",\"@name\":\"DoorHandleFilm\",\"@quantity\":\"1\",\"@labor_time\":\"0.40\",\"@msrp\":\"55.00\",\"@invoice_price\":\"33.0000\"},{\"@op_cd\":\"PILOT23037\",\"@name\":\"EngineBlockHeater\",\"@quantity\":\"1\",\"@labor_time\":\"1.40\",\"@msrp\":\"90.00\",\"@invoice_price\":\"56.2500\"},{\"@op_cd\":\"PILOT23038\",\"@name\":\"CargoOrganizer\",\"@quantity\":\"1\",\"@labor_time\":\"0.10\",\"@msrp\":\"88.00\",\"@invoice_price\":\"53.0200\"},{\"@op_cd\":\"PILOT23039\",\"@name\":\"Ashtray-CupholderType\",\"@quantity\":\"1\",\"@msrp\":\"26.13\",\"@invoice_price\":\"15.6800\"},{\"@op_cd\":\"PILOT23041\",\"@name\":\"SkidPlate-Side\",\"@quantity\":\"1\",\"@labor_time\":\"0.50\",\"@msrp\":\"400.00\",\"@invoice_price\":\"240.0000\"},{\"@op_cd\":\"PILOT23043\",\"@name\":\"RoofBox-Short\",\"@quantity\":\"1\",\"@labor_time\":\"0.20\",\"@msrp\":\"523.00\",\"@invoice_price\":\"336.2300\"},{\"@op_cd\":\"PILOT23044\",\"@name\":\"TrailerHitchBall-17/8-in\",\"@quantity\":\"1\",\"@msrp\":\"21.00\",\"@invoice_price\":\"12.8300\"},{\"@op_cd\":\"PILOT23045\",\"@name\":\"TrailerHitchBall-2-in\",\"@quantity\":\"1\",\"@msrp\":\"21.00\",\"@invoice_price\":\"12.8300\"},{\"@op_cd\":\"PILOT23046\",\"@name\":\"TrailerHitchLockingPin\",\"@quantity\":\"1\",\"@msrp\":\"77.72\",\"@invoice_price\":\"46.6300\"},{\"@op_cd\":\"PILOT23048\",\"@name\":\"FenderFlares\",\"@quantity\":\"1\",\"@labor_time\":\"1.00\",\"@msrp\":\"650.00\",\"@invoice_price\":\"390.0000\"},{\"@op_cd\":\"PILOT23049\",\"@name\":\"SeatCover-1stRow\",\"@quantity\":\"1\",\"@labor_time\":\"0.20\",\"@msrp\":\"300.00\",\"@invoice_price\":\"180.0000\"},{\"@op_cd\":\"PILOT23050\",\"@name\":\"CargoTray\",\"@is_ppo\":\"1\",\"@quantity\":\"1\",\"@labor_time\":\"0.10\",\"@msrp\":\"130.00\",\"@invoice_price\":\"78.0000\"},{\"@op_cd\":\"PILOT23054\",\"@name\":\"RoofBox-Midsize\",\"@quantity\":\"1\",\"@labor_time\":\"0.20\",\"@msrp\":\"555.00\",\"@invoice_price\":\"357.5800\"},{\"@op_cd\":\"PILOT23055\",\"@name\":\"RoofBasket\",\"@quantity\":\"1\",\"@labor_time\":\"0.40\",\"@msrp\":\"394.00\",\"@invoice_price\":\"256.2600\"},{\"@op_cd\":\"PILOT23056\",\"@name\":\"TrailerHitchw/Harness&Panel\",\"@quantity\":\"1\",\"@labor_time\":\"1.20\",\"@msrp\":\"310.00\",\"@invoice_price\":\"186.0000\"},{\"@op_cd\":\"PILOT23057\",\"@name\":\"TrailerHitchBallMount\",\"@quantity\":\"1\",\"@msrp\":\"46.00\",\"@invoice_price\":\"27.6000\"},{\"@op_cd\":\"PILOT23059\",\"@name\":\"WheelLugNutsSet,Black(Qty20)\",\"@quantity\":\"1\",\"@labor_time\":\"0.40\",\"@msrp\":\"211.00\",\"@invoice_price\":\"126.6000\"},{\"@op_cd\":\"PILOT23060\",\"@name\":\"WheelLocks,Black\",\"@quantity\":\"1\",\"@labor_time\":\"0.20\",\"@msrp\":\"98.00\",\"@invoice_price\":\"58.5700\"},{\"@op_cd\":\"PILOT23062\",\"@name\":\"TrailerHitchHarness\",\"@quantity\":\"1\",\"@labor_time\":\"0.60\",\"@msrp\":\"255.00\",\"@invoice_price\":\"153.0000\"},{\"@op_cd\":\"PILOT23063\",\"@name\":\"SeatBackProtectors-8P\",\"@quantity\":\"1\",\"@labor_time\":\"0.20\",\"@msrp\":\"110.00\",\"@invoice_price\":\"66.0000\"},{\"@op_cd\":\"PILOT23064\",\"@name\":\"TailgateTent\",\"@quantity\":\"1\",\"@msrp\":\"408.00\",\"@invoice_price\":\"252.0600\"},{\"@op_cd\":\"PILOT23065\",\"@name\":\"HoodDecal,Silver,HPD\",\"@quantity\":\"1\",\"@labor_time\":\"0.20\",\"@msrp\":\"200.00\",\"@invoice_price\":\"120.0000\"},{\"@op_cd\":\"PILOT23066\",\"@name\":\"Emblems-RearH-Mark,GlossBlack\",\"@quantity\":\"1\",\"@labor_time\":\"0.20\",\"@msrp\":\"40.00\",\"@invoice_price\":\"24.0000\"},{\"@op_cd\":\"PILOT23067\",\"@name\":\"SideDecal,Silver,HPD\",\"@quantity\":\"1\",\"@labor_time\":\"0.40\",\"@msrp\":\"350.00\",\"@invoice_price\":\"210.0000\"},{\"@op_cd\":\"PILOT23068\",\"@name\":\"SteeringWheel-Heated\",\"@quantity\":\"1\",\"@labor_time\":\"0.80\",\"@msrp\":\"533.00\",\"@invoice_price\":\"319.8000\"},{\"@op_cd\":\"PILOT23069\",\"@name\":\"CargoBarrier\",\"@quantity\":\"1\",\"@labor_time\":\"0.40\",\"@msrp\":\"480.00\",\"@invoice_price\":\"288.0000\"},{\"@op_cd\":\"PILOT23071\",\"@name\":\"HoodDecal,Bronze,HPD\",\"@quantity\":\"1\",\"@labor_time\":\"0.20\",\"@msrp\":\"200.00\",\"@invoice_price\":\"120.0000\"},{\"@op_cd\":\"PILOT23072\",\"@name\":\"LogoPatternProjector\",\"@quantity\":\"1\",\"@labor_time\":\"1.00\",\"@msrp\":\"200.00\",\"@invoice_price\":\"120.0000\"},{\"@op_cd\":\"PILOT23073\",\"@name\":\"20-inMatteBlackAlloyWheels-HPD\",\"@is_ppo\":\"1\",\"@quantity\":\"4\",\"@labor_time\":\"1.60\",\"@msrp\":\"2100.00\",\"@invoice_price\":\"1260.0000\"},{\"@op_cd\":\"PILOT23077\",\"@name\":\"Crossbars(Spt,Tour,Trail,Elite)\",\"@is_ppo\":\"1\",\"@quantity\":\"1\",\"@labor_time\":\"0.20\",\"@msrp\":\"255.00\",\"@invoice_price\":\"153.0000\"},{\"@op_cd\":\"PILOT23200\",\"@name\":\"ProtectionI-Sport\",\"@quantity\":\"1\",\"@labor_time\":\"0.70\",\"@msrp\":\"358.00\",\"@invoice_price\":\"214.5700\",\"@is_package\":\"1\"},{\"@op_cd\":\"PILOT23201\",\"@name\":\"AllSeasonProtectionI-Sport\",\"@quantity\":\"1\",\"@labor_time\":\"0.60\",\"@msrp\":\"510.00\",\"@invoice_price\":\"260.1000\",\"@is_package\":\"1\"},{\"@op_cd\":\"PILOT23202\",\"@name\":\"AllSeasonProtectionII-Sport\",\"@quantity\":\"1\",\"@labor_time\":\"0.40\",\"@msrp\":\"478.00\",\"@invoice_price\":\"243.5800\",\"@is_package\":\"1\"},{\"@op_cd\":\"PILOT23204\",\"@name\":\"Crossbars\",\"@is_ppo\":\"1\",\"@quantity\":\"1\",\"@labor_time\":\"0.20\",\"@msrp\":\"255.00\",\"@invoice_price\":\"153.0000\"},{\"@op_cd\":\"PILOT23471\",\"@name\":\"FunctionPackage\",\"@is_ppo\":\"1\",\"@quantity\":\"1\",\"@msrp\":\"405.00\",\"@invoice_price\":\"373.0000\",\"@is_package\":\"1\"},{\"@op_cd\":\"PILOT23474\",\"@name\":\"HPDBlackPackage\",\"@is_ppo\":\"1\",\"@quantity\":\"1\",\"@msrp\":\"2950.00\",\"@invoice_price\":\"2714.0000\",\"@is_package\":\"1\"},{\"@op_cd\":\"PILOT23476\",\"@name\":\"HPDBronzePackage\",\"@is_ppo\":\"1\",\"@quantity\":\"1\",\"@msrp\":\"2950.00\",\"@invoice_price\":\"2714.0000\",\"@is_package\":\"1\"},{\"@op_cd\":\"PILOT23478\",\"@name\":\"ProtectionFilmPackage\",\"@is_ppo\":\"1\",\"@quantity\":\"1\",\"@msrp\":\"290.00\",\"@invoice_price\":\"267.0000\",\"@is_package\":\"1\"},{\"@op_cd\":\"PILOT23480\",\"@name\":\"TowingPackage\",\"@is_ppo\":\"1\",\"@quantity\":\"1\",\"@msrp\":\"750.00\",\"@invoice_price\":\"690.0000\",\"@is_package\":\"1\"},{\"@op_cd\":\"PILOT23485\",\"@name\":\"20\\\"ALLOYWHEEL,HPD\",\"@is_ppo\":\"1\",\"@quantity\":\"4\",\"@msrp\":\"1800.00\",\"@invoice_price\":\"1350.0000\"},{\"@op_cd\":\"PILOT23486\",\"@name\":\"20\\\"WHEELHPD\",\"@is_ppo\":\"1\",\"@quantity\":\"4\",\"@msrp\":\"1800.00\",\"@invoice_price\":\"1350.0000\"},{\"@op_cd\":\"PILOT23490\",\"@name\":\"FIRSTAIDKIT\",\"@is_ppo\":\"1\",\"@quantity\":\"1\",\"@msrp\":\"31.65\",\"@invoice_price\":\"29.1200\"},{\"@op_cd\":\"PILOT23492\",\"@name\":\"KIT,BALLMOUNT\",\"@is_ppo\":\"1\",\"@quantity\":\"1\",\"@msrp\":\"46.00\",\"@invoice_price\":\"34.5000\"},{\"@op_cd\":\"PILOT23493\",\"@name\":\"KIT,CARGONET\",\"@is_ppo\":\"1\",\"@quantity\":\"1\",\"@msrp\":\"70.00\",\"@invoice_price\":\"52.5000\"},{\"@op_cd\":\"PILOT23494\",\"@name\":\"KIT,DECALS\",\"@is_ppo\":\"1\",\"@quantity\":\"1\",\"@msrp\":\"350.00\",\"@invoice_price\":\"262.5000\"},{\"@op_cd\":\"PILOT23495\",\"@name\":\"KIT,DRSILLFILM\",\"@is_ppo\":\"1\",\"@quantity\":\"1\",\"@msrp\":\"100.00\",\"@invoice_price\":\"75.0000\"},{\"@op_cd\":\"PILOT23496\",\"@name\":\"KIT,FENDERFLARES\",\"@is_ppo\":\"1\",\"@quantity\":\"1\",\"@msrp\":\"600.00\",\"@invoice_price\":\"450.0000\"},{\"@op_cd\":\"PILOT23498\",\"@name\":\"KIT,HPDEMBLEM\",\"@is_ppo\":\"1\",\"@quantity\":\"1\",\"@msrp\":\"50.00\",\"@invoice_price\":\"37.5000\"},{\"@op_cd\":\"PILOT23499\",\"@name\":\"KIT,SIDESKIDGARN\",\"@is_ppo\":\"1\",\"@quantity\":\"1\",\"@msrp\":\"300.00\",\"@invoice_price\":\"225.0000\"},{\"@op_cd\":\"PILOT23500\",\"@name\":\"KIT,TRAILERHARN\",\"@is_ppo\":\"1\",\"@quantity\":\"1\",\"@msrp\":\"255.00\",\"@invoice_price\":\"191.2500\"},{\"@op_cd\":\"PILOT23501\",\"@name\":\"KIT,TRAILERHITCH\",\"@is_ppo\":\"1\",\"@quantity\":\"1\",\"@msrp\":\"310.00\",\"@invoice_price\":\"232.5000\"},{\"@op_cd\":\"PILOT23502\",\"@name\":\"KIT,TRLRHTCPNLBLK\",\"@is_ppo\":\"1\",\"@quantity\":\"1\",\"@msrp\":\"135.00\",\"@invoice_price\":\"101.2500\"},{\"@op_cd\":\"PILOT23504\",\"@name\":\"SENSORASSY.,TPMS\",\"@is_ppo\":\"1\",\"@quantity\":\"4\",\"@msrp\":\"108.20\",\"@invoice_price\":\"64.9200\"},{\"@op_cd\":\"PILOT23505\",\"@name\":\"SIDEDECAL,SILVHPD\",\"@is_ppo\":\"1\",\"@quantity\":\"1\",\"@msrp\":\"350.00\",\"@invoice_price\":\"262.5000\"},{\"@op_cd\":\"PILOT23510\",\"@name\":\"PremiumCabinAirFilter\",\"@quantity\":\"1\",\"@labor_time\":\"0.20\",\"@msrp\":\"60.00\",\"@invoice_price\":\"36.0000\"},{\"@op_cd\":\"PILOT23703\",\"@name\":\"CargoPetProtection-8P\",\"@quantity\":\"1\",\"@labor_time\":\"1.30\",\"@msrp\":\"700.00\",\"@invoice_price\":\"420.0000\",\"@is_package\":\"1\"}]},\"attributes\":{\"attribute\":{\"@id\":\"3787\",\"@type\":\"FUEL_TYP_CD\",\"@name\":\"G\"}},\"dependency_info\":{\"dependency\":{\"@name\":\"Honda.2023.ModelGroup\",\"@filename\":\"\",\"@type\":\"ModelGroup\"},\"cache\":{\"@filename\":\"\"}}},\"private\":{\"server_info\":{\"@server_ip\":\"10.177.9.61\",\"@host_name\":\"CUA43362WEB326\"},\"errors\":{\"@base_exception_guid\":\"\",\"@exception_level\":\"\",\"@exception_type\":\"\"}}}}"troller.Get"}]}}}';
        response.setBody(respBody);
        response.setStatusCode(200);
        return response; 
        
    }
}