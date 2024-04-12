####Setup ecr repo lifecycle policy###
RepoLifecyclePolicy='{"rules":[{"rulePriority":1,"description":"Remove untagged images after 1 day","selection":{"tagStatus":"untagged","countType":"sinceImagePushed","countUnit":"days","countNumber":1},"action":{"type":"expire"}},{"rulePriority":2,"description":"Remove development images after 30 days","selection":{"tagStatus":"tagged","tagPrefixList":["dev","merge","p-","d-","v-"],"countType":"sinceImagePushed","countUnit":"days","countNumber":30},"action":{"type":"expire"}},{"rulePriority":3,"description":"Remove all images after 1 year","selection":{"tagStatus":"any","countType":"sinceImagePushed","countUnit":"days","countNumber":365},"action":{"type":"expire"}}]}'

regions=("ap-southeast-2" "us-west-2" "ap-east-1" "eu-west-2" "ca-central-1" "eu-west-1")

for region in "${regions[@]}"; do
    echo "Processing region: $region"

    repositories=($(aws ecr describe-repositories --region "$region" --query 'repositories[*].repositoryName' --output text))
    
    for repoName in "${repositories[@]}"; do
        aws ecr put-lifecycle-policy --region "$region" --repository-name "$repoName" --lifecycle-policy-text "$RepoLifecyclePolicy"
    done
done
