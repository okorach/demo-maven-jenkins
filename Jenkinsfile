projectKey = "demo:github-jenkins-maven"
tags = "github,jenkins,maven"

pipeline {
  agent any
  environment {
      SONAR_HOST_URL  = credentials('SONAR_HOST_URL')
      SONAR_TOKEN     = credentials('SONAR_TOKEN')
  }
  stages {
    stage('Code Checkout') {
      steps {
        checkout([$class: 'GitSCM', branches: [[name: '**']], extensions: [[$class: 'CloneOption', noTags: false, reference: '', shallow: false]], userRemoteConfigs: [[credentialsId: 'github-app', url: 'https://github.com/okorach/demo-maven-jenkins']]])
      }
    }
    stage('SonarQube LATEST analysis') {
      steps {
        withSonarQubeEnv('SQ Latest') {
          script {
            sh """
              cd comp-maven
              mvn sonar:sonar -B clean org.jacoco:jacoco-maven-plugin:prepare-agent install org.jacoco:jacoco-maven-plugin:report sonar:sonar
              curl -X POST -u $SONAR_TOKEN: \"$SONAR_HOST_URL/api/project_tags/set?project=${projectKey}&tags=${tags}\"
            """
          }
        }
      }
    }
    stage("SonarQube LATEST Quality Gate") {
      steps {
        timeout(time: 5, unit: 'MINUTES') {
          script {
            def qg = waitForQualityGate()
            if (qg.status != 'OK') {
              echo "Maven component quality gate failed: ${qg.status}, proceeding anyway"
            }
          }
        }
      }
    }
  }
}
