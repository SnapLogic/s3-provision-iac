def regions = ["us-west-2", "eu-west-2"]
def operations = ["build", "destroy"]

pipeline {

    agent {
        docker {
        alwaysPull true
        image '694702677705.dkr.ecr.us-west-2.amazonaws.com/cloudops:cloudops-jenkins-base'
        args '-u root:root'
        registryUrl 'https://694702677705.dkr.ecr.us-west-2.amazonaws.com'
        registryCredentialsId 'ecr:us-west-2:aws-instance-role'
        }
    }

    parameters {
        choice(name: 'REGION', choices: regions, description: 'Choose a region to deploy the S3.')
        string(name: 'BUCKET_NAME', description: 'Choose a name for the s3 bucket')
        choice(name: 'OPERATION', choices: operations, description: 'Build or destroy S3')

    }

    stages {
        
        stage ('Check env variables') {
            sh """
            echo -var ${REGION}
            echo -var ${BUCKET_NAME}
            """
        }

        stage ('Initialize terraform') {
            terraform init -var "bucket_name=${BUCKET_NAME}" -var "region=${REGION}"
        }

        stage ('Plan terraform') {
            terraform plan -var "bucket_name=${BUCKET_NAME}" -var "region=${REGION}"
        }

        stage ('Launch S3') {
            when {
                expression {params.OPERATION = 'build'}
            }
            steps {
                terraform apply -auto-approve -var "bucket_name=${BUCKET_NAME}" -var "region=${REGION}"
            }
        }

        stage ('Destroy S3') {
            when {
                expression {params.OPERATION = 'destroy'}
            }
            steps {
                terraform destroy -auto-approve -var "bucket_name=${BUCKET_NAME}" -var "region=${REGION}"
                rm -rf .terraform/
            }
        }
    }
}