import jenkins.model.*
import com.cloudbees.plugins.credentials.*
import com.cloudbees.plugins.credentials.domains.*
import com.cloudbees.plugins.credentials.impl.*

def instance = Jenkins.getInstance()
def domain = Domain.global()
def store = instance.getExtensionList("com.cloudbees.plugins.credentials.SystemCredentialsProvider")[0].getStore()

def nexusCred = new UsernamePasswordCredentialsImpl(
    CredentialsScope.GLOBAL,
    "nexus_cred",
    "Nexus Credentials",
    "admin",
    "admin123"
)

store.addCredentials(domain, nexusCred)

instance.save()

