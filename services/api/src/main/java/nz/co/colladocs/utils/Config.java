package nz.co.colladocs.utils;

import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.parser.OpenAPIV3Parser;
import org.slf4j.Logger;

public class Config {
    // CONFIG
    public static final String ADMIN_API_FILE_LOCATION = "./openapi/AdminApi.yaml";
    public static final String USER_API_FILE_LOCATION  = "./openapi/UserApi.yaml";

    // REST
    public final static OpenAPIV3Parser apiParser       = new OpenAPIV3Parser();
    public final static OpenAPI adminApiData            = apiParser.read(Config.ADMIN_API_FILE_LOCATION);
    public final static OpenAPI userApiData             = apiParser.read(Config.USER_API_FILE_LOCATION);
}
