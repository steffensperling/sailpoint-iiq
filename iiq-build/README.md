# IdentityIQ Maven Build chain

based on the article: Creating SailPoint IdentityIQ WAR file with Maven
24. März 2015 Mario Enrico Ragucci    
https://www.whisperedshouts.de/dokumente/creating-sailpoint-identityiq-war-file-with-maven

Using SailPoint’s Service Standard Build is okay if you need a quick and easy to setup buildenvironment. However, when you enter projects at bigger companies, you will realize that those companies rely on build systems around git/mercurial and Maven. This is a way of setting up a build using maven.

To create an IdentityIQ-based web application I decided to create a Maven archetype „iiq-webapp-archetype“. You can find this in the Maven central repository: search.maven.org

This archetype requires to have Release, Patches and ETN checked in to a private repository in a special way.  I decided to store these artifacts using the following structure:

    sailpoint.release:identityiq:6.3:war
    This is the release version. I checked in the WAR file of the release.
    sailpoint.patch:identityiq:6.3p3:war
    This is a patch. Instead of storing it as a JAR file I decided to also store it as a WAR file.
    sailpoint.etn:identityiq:6.3ETNXYZ:war
    This is an Efix. Analogue to storing release and patches this has also to be checked in to the repository as a WAR file.

If these requirements are fulfilled the pom itself is self explanatory. I added comments to each of the properties the user has to modify in order to build a release.

The „iiqentities-maven-plugin“ basically concatenates all XML files found in src/main/entities.
