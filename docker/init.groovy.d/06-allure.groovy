import jenkins.model.*
import ru.yandex.qatools.allure.jenkins.tools.*

def instance = Jenkins.getInstance()
def allureDesc = instance.getDescriptorByType(AllureCommandlineInstallation.DescriptorImpl.class)

def installer = new AllureCommandlineInstaller("2.27.0")
def installSource = new hudson.tools.InstallSourceProperty([installer])
def allureInstall = new AllureCommandlineInstallation("allure", "", [installSource])

allureDesc.setInstallations(allureInstall)
allureDesc.save()

instance.save()

