# Use the official Keycloak image as base
FROM quay.io/keycloak/keycloak:26.3.0 as builder

# Enable health and metrics support
ENV KC_HEALTH_ENABLED=true
ENV KC_METRICS_ENABLED=true

# Download OpenTelemetry Java agent for Application Insights integration
ADD https://github.com/microsoft/ApplicationInsights-Java/releases/download/3.7.3/applicationinsights-agent-3.7.3.jar /opt/applicationinsights-agent.jar

WORKDIR /opt/keycloak

RUN /opt/keycloak/bin/kc.sh build

FROM quay.io/keycloak/keycloak:26.3.0
COPY --from=builder /opt/keycloak/ /opt/keycloak/
COPY --from=builder /opt/applicationinsights-agent.jar /opt/applicationinsights-agent.jar

# Configure database
# ENV KC_DB=postgres
# ENV KC_DB_URL=jdbc:postgresql://postgres:5432/keycloak
# ENV KC_DB_USERNAME=postgres
# ENV KC_DB_PASSWORD=postgres

# Configure ports
#ENV KC_HOSTNAME=localhost
ENV KC_HTTP_ENABLED=true
ENV KC_PROXY_HEADERS=xforwarded
ENV KC_HOSTNAME_STRICT=false

# Configure admin user
#ENV KEYCLOAK_ADMIN=admin
#ENV KEYCLOAK_ADMIN_PASSWORD=admin
#ENV KC_BOOTSTRAP_ADMIN_USERNAME="admin"
#ENV KC_BOOTSTRAP_ADMIN_PASSWORD="admin"

# Copy custom themes if needed
COPY themes/ /opt/keycloak/themes/

# Copy custom realms if needed
COPY realms/ /opt/keycloak/data/import/

# Copy custom providers if needed
COPY providers/ /opt/keycloak/providers/

# Copy custom configuration if needed
COPY conf/ /opt/keycloak/conf/

EXPOSE 8080
EXPOSE 9000

# Start Keycloak in production mode with Application Insights agent
ENTRYPOINT ["java", "-javaagent:/opt/applicationinsights-agent.jar", "-Dapplicationinsights.configuration.file=/opt/keycloak/conf/applicationinsights.json", "-cp", "/opt/keycloak/lib/*", "org.keycloak.quarkus.runtime.cli.Main", "start", "--import-realm"]
