# Vagrant VBox for Jenkins

This is the Debian package repository of Jenkins to automate installation and upgrade. To use this repository, first add the key to your system: 

	wget -q -O - http://pkg.jenkins-ci.org/debian/jenkins-ci.org.key | sudo apt-key add -

Then add the following entry in your /etc/apt/sources.list: 

	deb http://pkg.jenkins-ci.org/debian binary/

Update your local package index, then finally install Jenkins: 

	sudo apt-get update
	sudo apt-get install jenkins

## PHP Support

Using Template for Jenkins Jobs for PHP Projects - http://jenkins-php.org/

You need to install the following plugins for Jenkins:

Checkstyle (for processing PHP_CodeSniffer logfiles in Checkstyle format)
Clover (for processing PHPUnit code coverage xml output)
DRY (for processing phpcpd logfiles in PMD-CPD format)
HTML Publisher (for publishing the PHPUnit code coverage report, for instance)
JDepend (for processing PHP_Depend logfiles in JDepend format)
Plot (for processing phploc CSV output)
PMD (for processing PHPMD logfiles in PMD format)
Violations (for processing various logfiles)
xUnit (for processing PHPUnit logfiles in JUnit format)

### Job Template

- Click on "New Job".
- Enter a "Job name".
- Select "Copy existing job" and enter "php-template" into the "Copy from" field.
- Click "OK".
- Replace "localhost:8080" with the hostname and port of your Jenkins installation and replace the two occurrences of "job-name" with the name of your job in the "Description" text box.
- Disable the "Disable Build" option.
- Fill in your "Source Code Management" information.
- Configure a "Build Trigger", for instance "Poll SCM".
- Configure an Ant-based build.
- Click "Save".