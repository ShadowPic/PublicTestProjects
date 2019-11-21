@Grab(group='commons-codec', module='commons-codec', version='1.13')
import org.apache.commons.codec.binary.Base64;
String jwtToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJtZXNzYWdlIjoiSldUIFJ1bGVzISIsImlhdCI6MTQ1OTQ0ODExOSwiZXhwIjoxNDU5NDU0NTE5fQ.-yIVBD5b73C75osbmwwshQNRC7frWUYrqaTjTpza2y4";
//String jwtToken = vars.get("bearer");
String[] split_string = jwtToken.split("\\.");
String base64EncodedHeader = split_string[0];
String base64EncodedBody = split_string[1];
String base64EncodedSignature = split_string[2];
Base64 base64Url = new Base64(true);
String header = new String(base64Url.decode(base64EncodedHeader));
String body = new String(base64Url.decode(base64EncodedBody));
printf header;
printf body;
//vars.put("jwtHeader",header)
//vars.put("jwtBody",body)