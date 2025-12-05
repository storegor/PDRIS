import jenkins.model.*
import hudson.plugins.sonar.*

def instance = Jenkins.getInstance()
def sonarDesc = instance.getDescriptor(SonarGlobalConfiguration.class)

def sonarInst = new SonarInstallation(
    "SonarQube",
    "http://sonarqube:9000",
    null, null, null, null, null, null, null
)

sonarDesc.setInstallations(sonarInst)
sonarDesc.save()

instance.save()

