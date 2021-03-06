def regions = ["select", "us-west-2", "eu-west-2"]
def operations = ["refresh", "build", "destroy"]

pipeline {

    // agent {
    //     docker {
    //     alwaysPull true
    //     image '694702677705.dkr.ecr.us-west-2.amazonaws.com/cloudops:cloudops-jenkins-base'
    //     args '-u root:root'
    //     registryUrl 'https://694702677705.dkr.ecr.us-west-2.amazonaws.com'
    //     registryCredentialsId 'ecr:us-west-2:aws-instance-role'
    //     }
    // }

    agent {docker { image 'node:16.13.1-alpine' }}


    parameters {
        choice(name: 'REGION', choices: regions, description: 'Choose a region to deploy the S3.') // todo: make select the default 
        string(name: 'BUCKET_NAME', description: 'Choose a name for the s3 bucket')
        choice(name: 'OPERATION', choices: operations, description: 'Build or destroy S3') // todo: make refresh the default 
    }

    stages {
        
        stage ('Check env variables') {
            steps {
                sh """
                echo -var ${REGION}
                echo -var ${BUCKET_NAME}
                aws sts get-caller-identity
                """
            }
        }

        stage ('Initialize terraform') {
            steps {
                sh """
                tfswitch --latest
                terraform init -var "bucket_name=${BUCKET_NAME}" -var "region=${REGION}"
                """
            }
        }

        stage ('Launch S3') {
            when {
                expression {params.OPERATION == 'build'}
                expression {params.OPERATION != 'refresh'}

            }
            steps {
                sh """
                terraform apply -auto-approve -var "bucket_name=${BUCKET_NAME}" -var "region=${REGION}"
                rm -rf .terraform/
                """
            }
        }

        stage ('Destroy S3') {
            when {
                expression {params.OPERATION == 'destroy'}
            }
            steps {
                sh """
                terraform destroy -auto-approve -var "bucket_name=${BUCKET_NAME}" -var "region=${REGION}"
                rm -rf .terraform/
                """
            }
        }
    }
}