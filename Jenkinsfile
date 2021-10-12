pipeline {
  agent any
  stages {
    stage('git') {
      steps {
        script {
          sh 'git branch -r | grep -v '\->' | while read remote; do git branch --track "${remote#origin/}" "$remote"; done'
          sh 'git fetch --all'
          sh 'git pull --all'
        }
      }
    }
    stage('SonarQube LATEST analysis') {
      steps {
        withSonarQubeEnv('SQ Latest') {
          script {
            sh 'cd comp-maven; mvn sonar:sonar -B clean org.jacoco:jacoco-maven-plugin:prepare-agent install org.jacoco:jacoco-maven-plugin:report sonar:sonar'
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
            sh 'rm -f comp-maven/target/sonar/report-task.txt'
          }
        }
      }
    }
  }
}
