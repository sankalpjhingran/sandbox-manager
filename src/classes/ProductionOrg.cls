/**
 * Created by sankalp.jhingran on 3/8/23.
 */

public with sharing class ProductionOrg {
    private final String id;
    private final String name;
    private final String username;
    private final String securityToken;
    private final String password;

    private ProductionOrg(){} // no public construction

    private ProductionOrg(ProductionOrg.Builder b) {
        this.id = b.id;
        this.name = b.name;
        this.username = b.username;
        this.securityToken = b.securityToken;
        this.password = b.password;
    }

    public String getName() {
        return this.name;
    }

    public String getUsername() {
        return this.username;
    }

    public String getPassword() {
        return this.password;
    }

    public String getSecurityToken() {
        return this.securityToken;
    }

    public class Builder {
        private String id;
        private String name;
        private String username;
        private String securityToken;
        private String password;

        public Builder withId(String id) {
            this.id = id;
            return this;
        }

        public Builder withName(String name) {
            this.name = name;
            return this;
        }

        public Builder withUsername(String username) {
            this.username = username;
            return this;
        }

        public Builder withPassword(String password) {
            this.password = password;
            return this;
        }

        public Builder withSecurityToken(String securityToken) {
            this.securityToken = securityToken;
            return this;
        }

        public ProductionOrg build() {
            return new ProductionOrg(this);
        }
    }
}