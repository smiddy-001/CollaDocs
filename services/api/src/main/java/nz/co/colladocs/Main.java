package nz.co.colladocs;
import nz.co.colladocs.utils.Config;
import nz.co.colladocs.service.DynamicEndpointService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class Main {
    private static final Logger LOG = LoggerFactory.getLogger(Main.class);

    public static void main(String[] args) {

        LOG.info("Starting dynamic endpoint generator...");
        new DynamicEndpointService().registerEndpoints(Config.userApiData);
        new DynamicEndpointService().registerEndpoints(Config.adminApiData);
        LOG.info("Dynamic endpoints successfully registered!");

    }
}

