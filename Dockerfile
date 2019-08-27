# escape=`
FROM mcr.microsoft.com/windows/servercore/iis:windowsservercore-ltsc2016



SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

#RUN Enable-WindowsOptionalFeature -Online -FeatureName IIS-WebServerRole,IIS-WebServer,IIS-CommonHttpFeatures,IIS-Security,IIS-RequestFiltering,IIS-StaticContent,IIS-DefaultDocument,IIS-HttpErrors,IIS-HttpRedirect,IIS-ApplicationDevelopment,IIS-NetFxExtensibility45,IIS-ISAPIExtensions,IIS-ISAPIFilter,IIS-ASPNET45,IIS-HealthAndDiagnostics,IIS-HttpLogging,IIS-LoggingLibraries,IIS-CustomLogging,IIS-BasicAuthentication,IIS-WindowsAuthentication,IIS-IPSecurity,IIS-Performance,IIS-HttpCompressionStatic,IIS-HttpCompressionDynamic,IIS-WebServerManagementTools,IIS-ManagementConsole,IIS-ManagementScriptingTools,NetFx4Extended-ASPNET45,WAS-WindowsActivationService,WAS-ProcessModel,WAS-ConfigurationAPI,WCF-HTTP-Activation45,WCF-TCP-Activation45,SNMP,WMISnmpProvider,ServerCore-Drivers-General-WOW64,IIS-ASPNET45 -All

RUN Enable-WindowsOptionalFeature -Online -FeatureName IIS-WebServerRole -All; `
    Enable-WindowsOptionalFeature -Online -FeatureName IIS-WebServer -All; `
    Enable-WindowsOptionalFeature -Online -FeatureName IIS-CommonHttpFeatures -All; `
    Enable-WindowsOptionalFeature -Online -FeatureName IIS-HttpErrors -All; `
    Enable-WindowsOptionalFeature -Online -FeatureName IIS-HttpRedirect -All; `
    Enable-WindowsOptionalFeature -Online -FeatureName IIS-ApplicationDevelopment -All; `
    Enable-WindowsOptionalFeature -online -FeatureName NetFx4Extended-ASPNET45 -All; `
    Enable-WindowsOptionalFeature -Online -FeatureName IIS-NetFxExtensibility45 -All; `
    Enable-WindowsOptionalFeature -Online -FeatureName IIS-HealthAndDiagnostics -All; `
    Enable-WindowsOptionalFeature -Online -FeatureName IIS-HttpLogging -All; `
    Enable-WindowsOptionalFeature -Online -FeatureName IIS-LoggingLibraries -All; `
    Enable-WindowsOptionalFeature -Online -FeatureName IIS-RequestMonitor -All; `
    Enable-WindowsOptionalFeature -Online -FeatureName IIS-HttpTracing -All; `
    Enable-WindowsOptionalFeature -Online -FeatureName IIS-Security -All; `
    Enable-WindowsOptionalFeature -Online -FeatureName IIS-RequestFiltering -All; `
    Enable-WindowsOptionalFeature -Online -FeatureName IIS-Performance -All; `
    Enable-WindowsOptionalFeature -Online -FeatureName IIS-WebServerManagementTools -All; `
    Enable-WindowsOptionalFeature -Online -FeatureName IIS-BasicAuthentication -All; `
    Enable-WindowsOptionalFeature -Online -FeatureName IIS-WindowsAuthentication -All; `
    Enable-WindowsOptionalFeature -Online -FeatureName IIS-StaticContent -All; `
    Enable-WindowsOptionalFeature -Online -FeatureName IIS-DefaultDocument -All; `
    Enable-WindowsOptionalFeature -Online -FeatureName IIS-WebSockets -All; `
    Enable-WindowsOptionalFeature -Online -FeatureName IIS-ApplicationInit -All; `
    Enable-WindowsOptionalFeature -Online -FeatureName IIS-ISAPIExtensions -All; `
    Enable-WindowsOptionalFeature -Online -FeatureName IIS-ISAPIFilter -All; `
    Enable-WindowsOptionalFeature -Online -FeatureName IIS-HttpCompressionStatic -All; `
    Enable-WindowsOptionalFeature -Online -FeatureName IIS-HttpRedirect -All; `
    Enable-WindowsOptionalFeature -Online -FeatureName WCF-HTTP-Activation45 -All; `
    Enable-WindowsOptionalFeature -Online -FeatureName WCF-TCP-Activation45 -All; `
    Enable-WindowsOptionalFeature -Online -FeatureName IIS-ASPNET45 -All;

## define the path we will symbolic link to represent D:
RUN mkdir /data
RUN Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\DOS Devices' -Name 'D:' -Value "\??\C:\data" -Type String;

COPY ["wwwroot", "/data/inetpub/wwwroot"]
COPY ["SecureAuth0", "/data/SecureAuth/SecureAuth0"]
COPY ["SecureAuth1", "/data/SecureAuth/SecureAuth1"]
COPY ["SecureAuth998", "/data/SecureAuth/SecureAuth998"]
COPY ["IdpConfigurator", "/data/SecureAuth/IdpConfigurator"]
COPY ["SecureAuthWS", "/data/SecureAuthWS"]
COPY ["SecureAuthScepService", "/data/SecureAuthScepService"]
COPY ["Admin", "/data/SecureAuth/Admin"]
COPY ["Api", "/data/SecureAuth/Api"]
COPY ["AnalyzeApi", "/data/SecureAuth/AnalyzeApi"]
COPY ["ApplicationApi", "/data/SecureAuth/ApplicationApi"]
COPY ["HttpProxy", "/data/SecureAuth/HttpProxy"]
COPY ["SecureStorageApi", "/data/SecureAuth/SecureStorageApi"]

RUN Remove-Website 'Default Web Site';

# Set up website: Default Web Site
RUN New-Item -Path 'D:\inetpub\wwwroot' -Type Directory -Force; `
    New-Item -Path 'D:\SecureAuth\SecureAuth0' -Type Directory -Force; `
    New-Item -Path 'D:\SecureAuth\SecureAuth1' -Type Directory -Force; `
    New-Item -Path 'D:\SecureAuth\SecureAuth998' -Type Directory -Force; `
    New-Item -Path 'D:\SecureAuth\IdpConfigurator' -Type Directory -Force; `
    New-Item -Path 'D:\SecureAuthWS' -Type Directory -Force; `
    New-Item -Path 'D:\SecureAuthScepService' -Type Directory -Force; `
    New-Item -Path 'D:\SecureAuth\Admin' -Type Directory -Force; `
    New-Item -Path 'D:\SecureAuth\Api' -Type Directory -Force; `
    New-Item -Path 'D:\SecureAuth\AnalyzeApi' -Type Directory -Force; `
    New-Item -Path 'D:\SecureAuth\ApplicationApi' -Type Directory -Force; `
    New-Item -Path 'D:\SecureAuth\HttpProxy' -Type Directory -Force; `
    New-Item -Path 'D:\SecureAuth\SecureStorageApi' -Type Directory -Force;

RUN New-Website -Name 'Default Web Site' -PhysicalPath 'D:\inetpub\wwwroot' -Port 80 -ApplicationPool 'DefaultAppPool' -Force; `
    New-WebApplication -Name 'SecureAuth0' -Site 'Default Web Site' -PhysicalPath 'D:\SecureAuth\SecureAuth0' -Force; `
    New-WebApplication -Name 'SecureAuth1' -Site 'Default Web Site' -PhysicalPath 'D:\SecureAuth\SecureAuth1' -Force; `
    New-WebApplication -Name 'SecureAuth998' -Site 'Default Web Site' -PhysicalPath 'D:\SecureAuth\SecureAuth998' -Force; `
    New-WebApplication -Name 'IdP' -Site 'Default Web Site' -PhysicalPath 'D:\SecureAuth\IdpConfigurator' -Force; `
    New-WebApplication -Name 'SecureAuthWS' -Site 'Default Web Site' -PhysicalPath 'D:\SecureAuthWS' -Force; `
    New-WebApplication -Name 'SecureAuthScepService' -Site 'Default Web Site' -PhysicalPath 'D:\SecureAuthScepService' -Force; `
    New-WebApplication -Name 'Admin' -Site 'Default Web Site' -PhysicalPath 'D:\SecureAuth\Admin' -Force; `
    New-WebApplication -Name 'Api' -Site 'Default Web Site' -PhysicalPath 'D:\SecureAuth\Api' -Force; `
    New-WebApplication -Name 'AnalyzeApi' -Site 'Default Web Site' -PhysicalPath 'D:\SecureAuth\AnalyzeApi' -Force; `
    New-WebApplication -Name 'ApplicationApi' -Site 'Default Web Site' -PhysicalPath 'D:\SecureAuth\ApplicationApi' -Force; `
    New-WebApplication -Name 'HttpProxy' -Site 'Default Web Site' -PhysicalPath 'D:\SecureAuth\HttpProxy' -Force; `
    New-WebApplication -Name 'SecureStorageApi' -Site 'Default Web Site' -PhysicalPath 'D:\SecureAuth\SecureStorageApi' -Force;

EXPOSE 80
