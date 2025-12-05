#!/bin/bash

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

cd "$(dirname "$0")"

echo ""
echo "========================================"
echo "   CI/CD Pipeline - Full Auto Setup"
echo "========================================"
echo ""

echo -e "${GREEN}[1/8]${NC} Stopping old containers..."
docker-compose down -v 2>/dev/null || true

echo -e "${GREEN}[2/8]${NC} Building Jenkins image..."
docker-compose build jenkins

echo -e "${GREEN}[3/8]${NC} Starting infrastructure..."
docker-compose up -d

echo -e "${GREEN}[4/8]${NC} Waiting for services..."

wait_http() {
    local url=$1
    local max=90
    for i in $(seq 1 $max); do
        if curl -s -o /dev/null -w "%{http_code}" "$url" 2>/dev/null | grep -qE "200|401|403"; then
            return 0
        fi
        sleep 3
    done
    return 1
}

echo -n "   Jenkins: "
wait_http "http://localhost:8080/login" && echo "ready" || echo "timeout"

echo -n "   Nexus: "
wait_http "http://localhost:8081" && echo "ready" || echo "timeout"

echo -n "   SonarQube: "
wait_http "http://localhost:9000/api/system/status" && echo "ready" || echo "timeout"

echo -e "${GREEN}[5/8]${NC} Waiting for SonarQube to fully initialize..."
sleep 30
until curl -s "http://localhost:9000/api/system/status" 2>/dev/null | grep -q '"status":"UP"'; do
    sleep 5
done
echo "   SonarQube is UP"

echo -e "${GREEN}[6/8]${NC} Configuring SonarQube..."
curl -s -u admin:admin -X POST "http://localhost:9000/api/users/change_password?login=admin&previousPassword=admin&password=admin123" 2>/dev/null || true
sleep 2
curl -s -u admin:admin123 -X POST "http://localhost:9000/api/settings/set?key=sonar.forceAuthentication&value=false" 2>/dev/null
sleep 2
curl -s -u admin:admin123 -X POST "http://localhost:9000/api/permissions/add_group?groupName=Anyone&permission=scan" 2>/dev/null
sleep 1
curl -s -u admin:admin123 -X POST "http://localhost:9000/api/permissions/add_group?groupName=Anyone&permission=provisioning" 2>/dev/null
echo "   Done"

echo -e "${GREEN}[7/8]${NC} Configuring Nexus..."
sleep 20
NEXUS_INIT_PASS=$(docker exec nexus cat /nexus-data/admin.password 2>/dev/null || echo "")
if [ -n "$NEXUS_INIT_PASS" ]; then
    echo "   Changing password..."
    curl -s -u "admin:$NEXUS_INIT_PASS" -X PUT "http://localhost:8081/service/rest/v1/security/users/admin/change-password" \
        -H "Content-Type: text/plain" -d "admin123" 2>/dev/null || true
else
    echo "   Using default password admin123"
fi
sleep 3
echo "   Enabling anonymous access..."
curl -s -u admin:admin123 -X PUT "http://localhost:8081/service/rest/v1/security/anonymous" \
    -H "Content-Type: application/json" -d '{"enabled":true,"userId":"anonymous","realmName":"NexusAuthorizingRealm"}' 2>/dev/null || true
sleep 2
echo "   Configuring maven-releases for redeploy..."
curl -s -u admin:admin123 -X PUT "http://localhost:8081/service/rest/v1/repositories/maven/hosted/maven-releases" \
    -H "Content-Type: application/json" \
    -d '{"name":"maven-releases","online":true,"storage":{"blobStoreName":"default","strictContentTypeValidation":true,"writePolicy":"ALLOW"},"maven":{"versionPolicy":"RELEASE","layoutPolicy":"STRICT","contentDisposition":"INLINE"}}' 2>/dev/null || true
echo "   Done"

echo -e "${GREEN}[8/8]${NC} Installing Ansible in Jenkins..."
docker exec -u root jenkins bash -c "apt-get update && apt-get install -y ansible sshpass" >/dev/null 2>&1 || true
echo "   Done"

echo ""
echo "========================================"
echo -e "   ${GREEN}Setup Complete!${NC}"
echo "========================================"
echo ""
echo "Services (all configured automatically):"
echo "  Jenkins:   http://localhost:8080  (admin / admin123)"
echo "  Nexus:     http://localhost:8081  (admin / admin123)"
echo "  SonarQube: http://localhost:9000  (admin / admin123)"
echo "  Allure:    http://localhost:5050"
echo ""
echo "Run: Jenkins -> build-pipeline -> Build Now"
echo ""
echo "========================================"
