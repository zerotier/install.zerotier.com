node('ubuntu-2204') {
	try {
		checkout scm
		def changelog = getChangeLog currentBuild
		mattermostSend "Building ${env.JOB_NAME} #${env.BUILD_NUMBER} \n Change Log: \n ${changelog}"

        def cluster = 'ztc-controller-us-central'
        def region = 'us-central1'
        def project = 'zerotier-central'

		stage('Build Docker Image') {
			sh("docker build -t registry.zerotier.com/zerotier/install.zerotier.com:${env.BUILD_TAG} .")
		}

		def shouldContinue = true

		stage('Approve Deployment') {
			try {
				timeout(time: 30, unit: 'MINUTES') {
					mattermostSend color: "#00ff00", message: "${env.JOB_NAME} #${env.BUILD_NUMBER} Ready to deploy (<${env.BUILD_URL}|Show More...>)"
					input message: "Deploy to production? ", ok: "Deploy"
				}
			} catch (err) {
				shouldContinue = false
				if ("SYSTEM" == getUserFromErr(err)) { // SYSTEM means timeout
					mattermostSend color: "#00ff00", message: "Deployment of ${env.JOB_NAME} #${env.BUILD_NUMBER} timed out.  Try again next time. (<${env.BUILD_URL}|Show More...>)"
				} else {
					mattermostSend color: "#00ff00", message: "Deployment of ${env.JOB_NAME} #${env.BUILD_NUMBER} aborted by ${getUserFromErr(err)}. (<${env.BUILD_URL}|Show More...>)"
				}
			}
		}

		if (shouldContinue) {
			stage("Push Docker Image") {
				sh("docker push registry.zerotier.com/zerotier/install.zerotier.com:${env.BUILD_TAG}")
			}

			stage("Deploy to Production") {
				sh("export CLOUDSDK_CORE_DISABLE_PROMPTS=1")
				sh("docker tag registry.zerotier.com/zerotier/install.zerotier.com:${env.BUILD_TAG} registry.zerotier.com/zerotier/install.zerotier.com:live")
				sh("docker push registry.zerotier.com/zerotier/install.zerotier.com:live")
				sh("gcloud container clusters get-credentials ${cluster} --project ${project} --region ${region}")
                sh("kubectl set image deployment install-zerotier-com install-zerotier-com=registry.zerotier.com/zerotier/install.zerotier.com:${env.BUILD_TAG}")
				mattermostSend color: "#00ff00", message: "${env.JOB_NAME} #${env.BUILD_NUMBER} Deployed (<${env.BUILD_URL}|Show More...>)"
			}
		}
	} catch (err) {
        currentBuild.result = "FAILURE"
        mattermostSend color: '#ff0000', message: "${env.JOB_NAME} broken (<${env.BUILD_URL}|Open>)"

        throw err
    }
}
@NonCPS
def getUserFromErr(err) {
    def user = err.getCauses()[0].getUser()
    return "${user}"
}
