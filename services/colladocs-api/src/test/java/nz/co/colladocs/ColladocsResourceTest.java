package nz.co.colladocs;

import static org.hamcrest.CoreMatchers.is;
import org.junit.jupiter.api.Test;

import io.quarkus.test.junit.QuarkusTest;
import static io.restassured.RestAssured.given;

@QuarkusTest
class ColladocsResourceTest {
    @Test
    void testHelloEndpoint() {
        String expectedString = "{\"message\":\"Hello, World!\"}";
        given()
          .when().get("/user")
          .then()
             .statusCode(200)
             .body(is(expectedString));
    }

}