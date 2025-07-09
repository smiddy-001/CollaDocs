package nz.co.colladocs.service;

import io.swagger.v3.oas.models.OpenAPI;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.ws.rs.core.Context;
import jakarta.ws.rs.core.UriInfo;
import nz.co.colladocs.utils.OpenApiEndpointGenerator;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class DynamicEndpointService {
    private static final Logger LOG = LoggerFactory.getLogger(DynamicEndpointService.class);

    public void registerEndpoints(OpenAPI openApi) {
        try {
            // Validate OpenAPI configuration
            if (openApi == null) {
                LOG.warn("Received null OpenAPI configuration");
                return;
            }

            // Generate endpoints
            OpenApiEndpointGenerator.generateEndpoints(openApi);

            LOG.info("Endpoints registered successfully for API: {}",
                    openApi.getInfo() != null ? openApi.getInfo().getTitle() : "Unknown");
        } catch (Exception e) {
            LOG.error("Error registering endpoints", e);
            throw new RuntimeException("Failed to register dynamic endpoints", e);
        }
    }
}
