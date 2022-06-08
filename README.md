# snyk-container-log4shell

A simple script for recursively running "snyk log4shell" against JAR files found in a container image.

#### Requirements
- *docker* (or equivalent)
- *snyk* 
- *jq*
- Temp storage sufficient to hold image contents

#### Usage
    snyk-container-log4shell.sh [IMAGE NAME]
