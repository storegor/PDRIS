import jenkins.model.*
import hudson.model.*
import hudson.tools.*
import hudson.tasks.*

def instance = Jenkins.getInstance()

def jdkDesc = instance.getDescriptor("hudson.model.JDK")
def jdkInstalls = (jdkDesc.installations as List)
jdkInstalls.add(new JDK("jdk17", "/opt/java/openjdk"))
jdkDesc.installations = jdkInstalls.toArray(new JDK[0])

def mvnDesc = instance.getDescriptor("hudson.tasks.Maven")
def mvnInstaller = new Maven.MavenInstaller("3.9.9")
def mvnInstallSource = new InstallSourceProperty([mvnInstaller])
def mvnInstalls = (mvnDesc.installations as List)
mvnInstalls.add(new Maven.MavenInstallation("maven3", "", [mvnInstallSource]))
mvnDesc.installations = mvnInstalls.toArray(new Maven.MavenInstallation[0])

instance.save()

