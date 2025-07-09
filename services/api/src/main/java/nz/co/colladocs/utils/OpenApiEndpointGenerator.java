package nz.co.colladocs.utils;

import io.quarkus.runtime.annotations.RegisterForReflection;
import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.Operation;
import io.swagger.v3.oas.models.PathItem;
import io.swagger.v3.oas.models.media.Content;
import io.swagger.v3.oas.models.responses.ApiResponse;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.lang.annotation.Annotation;
import java.util.HashMap;
import java.util.Map;

public class OpenApiEndpointGenerator {
    private static final Logger LOG = LoggerFactory.getLogger(OpenApiEndpointGenerator.class);

    public static void generateEndpoints(OpenAPI openApi) {
        Map<String, PathItem> paths = openApi.getPaths();
        for (Map.Entry<String, PathItem> pathEntry : paths.entrySet()) {
            String path = pathEntry.getKey();
            PathItem pathItem = pathEntry.getValue();

            // Generate endpoints for HTTP methods
            generateMethodEndpoint(path, pathItem.getGet(), HttpMethod.GET);
            generateMethodEndpoint(path, pathItem.getPost(), HttpMethod.POST);
            generateMethodEndpoint(path, pathItem.getPut(), HttpMethod.PUT);
            generateMethodEndpoint(path, pathItem.getDelete(), HttpMethod.DELETE);
        }
    }

    private static void generateMethodEndpoint(String path, Operation operation, String httpMethod) {
        if (operation == null) return;

        String operationId = operation.getOperationId();
        LOG.info("Generating endpoint: {} {}", httpMethod, path);

        // Create a dynamic resource class for the endpoint
        Class<?> dynamicResourceClass = generateDynamicResourceClass(path, operation, httpMethod);
    }

    private static Class<?> generateDynamicResourceClass(String path, Operation operation, String httpMethod) {
        return new DynamicResourceBuilder()
                .withPath(path)
                .withHttpMethod(httpMethod)
                .withOperationId(operation.getOperationId())
                .withResponses(operation.getResponses())
                .build();
    }

    @RegisterForReflection
    public static class DynamicResourceBuilder {
        private String path;
        private String httpMethod;
        private String operationId;
        private Map<String, ApiResponse> responses;

        public DynamicResourceBuilder withPath(String path) {
            this.path = path;
            return this;
        }

        public DynamicResourceBuilder withHttpMethod(String httpMethod) {
            this.httpMethod = httpMethod;
            return this;
        }

        public DynamicResourceBuilder withOperationId(String operationId) {
            this.operationId = operationId;
            return this;
        }

        public DynamicResourceBuilder withResponses(Map<String, ApiResponse> responses) {
            this.responses = responses;
            return this;
        }

        public Class<?> build() {
            return new AbstractDynamicResource(path, httpMethod, operationId, responses).getClass();
        }

        @Path("/{path}")
        @ApplicationScoped
        private static class AbstractDynamicResource {
            private final String resourcePath;
            private final String httpMethod;
            private final String operationId;
            private final Map<String, ApiResponse> responses;

            public AbstractDynamicResource(String resourcePath, String httpMethod,
                                           String operationId, Map<String, ApiResponse> responses) {
                this.resourcePath = resourcePath;
                this.httpMethod = httpMethod;
                this.operationId = operationId;
                this.responses = responses;
            }

            @GET
            @Path("/")
            @Produces(MediaType.APPLICATION_JSON)
            public Response handleGet() {
                // Default implementation - can be overridden or enhanced
                Map<String, Object> responseBody = new HashMap<>();
                responseBody.put("message", "Dynamic endpoint for " + operationId);
                return Response.ok(responseBody).build();
            }

            @POST
            @Path("/")
            @Produces(MediaType.APPLICATION_JSON)
            public Response handlePost() {
                // Default implementation - can be overridden or enhanced
                Map<String, Object> responseBody = new HashMap<>();
                responseBody.put("message", "Dynamic POST endpoint for " + operationId);
                return Response.ok(responseBody).build();
            }

            // Similar methods for PUT, DELETE, etc.
        }
    }
}