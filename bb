import com.amazonaws.auth.InstanceProfileCredentialsProvider;
import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.AmazonS3ClientBuilder;
import com.cloudbees.groovy.cps.NonCPS;
import groovy.json.JsonSlurperClassic;

public class GlobalVars implements Serializable {
    private static Map globalVars = [:];
    private static String bucketName = "dal-prod-coc-metadata-us-east-1";
    private static String keyName = "ddpProperties/globalVars/master/globalVars.json";
    private static boolean isInitialized = false;
    private static final Object lock = new Object();
    
    static {
        loadGlobalVarsFromS3();
    }

    public GlobalVars() {
        initialize();
    }

    @NonCPS
    private void initialize() {
        synchronized (lock) {
            if (!isInitialized) {
                loadGlobalVarsFromS3();
                isInitialized = true;
            }
        }
    }

    @NonCPS
    static void loadGlobalVarsFromS3() throws Exception {
        try {
            loadFromBucket("dal-prod-coc-metadata-us-east-1");
        } catch (Exception e) {
            System.out.println("Failed to load from us-east-1, trying us-west-2");
            try {
                loadFromBucket("dal-prod-coc-metadata-us-west-2");
            } catch (Exception ex) {
                throw new Exception("Unable to load global variables from both us-east-1 and us-west-2 buckets due to: " + ex.getMessage());
            }
        }
    }

    @NonCPS
    private static void loadFromBucket(String bucketName) throws Exception {
        AmazonS3 s3Client = AmazonS3ClientBuilder
                .standard()
                .withCredentials(new InstanceProfileCredentialsProvider(true))
                .build();
        
        String jsonContent = s3Client.getObjectAsString(bucketName, keyName);
        globalVars = new JsonSlurperClassic().parseText(jsonContent);
        addDynamicPropertyAccess();
        createStaticFields();
    }

    private static void addDynamicPropertyAccess() {
        // Your logic here
    }

    private static void createStaticFields() {
        // Your logic here
    }
}