package nz.co.colladocs;

import jakarta.ws.rs.GET;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.Produces;
import jakarta.ws.rs.core.MediaType;

@Path("/user")
public class ColladocsResource {

    @GET
    @Produces(MediaType.APPLICATION_JSON)
    public String hello() {
        return "{\"message\":\"Hello, World!\"}";
    }
}
