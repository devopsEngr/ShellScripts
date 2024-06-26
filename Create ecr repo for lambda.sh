#Replace Reponame with your lambda name
export RepoName=sns-sms-delivery-logs-lambda
export  RepoPermissionPolicy='{"Version":"2008-10-17","Statement":[{"Sid":"LambdaECRImageCrossOrgRetrievalPolicy","Effect":"Allow","Principal":{"Service":"lambda.amazonaws.com"},"Action":["ecr:BatchCheckLayerAvailability","ecr:BatchGetImage","ecr:CompleteLayerUpload","ecr:GetDownloadUrlForLayer","ecr:GetRepositoryPolicy","ecr:InitiateLayerUpload","ecr:ListImages","ecr:PutImage","ecr:UploadLayerPart"],"Condition":{"StringLike":{"aws:ResourceOrgID":"o-8xzqiyhvw3"}}},{"Sid":"CrossOrgPermission","Effect":"Allow","Principal":"*","Action":["ecr:BatchCheckLayerAvailability","ecr:BatchGetImage","ecr:CompleteLayerUpload","ecr:GetDownloadUrlForLayer","ecr:GetRepositoryPolicy","ecr:InitiateLayerUpload","ecr:ListImages","ecr:PutImage","ecr:UploadLayerPart"],"Condition":{"StringLike":{"aws:PrincipalOrgID":"o-8xzqiyhvw3"}}}]}'
export  RepoLifecyclePolicy='{"rules":[{"rulePriority":1,"description":"Remove untagged images after 1 day","selection":{"tagStatus":"untagged","countType":"sinceImagePushed","countUnit":"days","countNumber":1},"action":{"type":"expire"}},{"rulePriority":2,"description":"Remove development images after 90 days","selection":{"tagStatus":"tagged","tagPrefixList":["dev","merge","p-","d-","v-"],"countType":"sinceImagePushed","countUnit":"days","countNumber":90},"action":{"type":"expire"}},{"rulePriority":3,"description":"Remove all images after 3 years","selection":{"tagStatus":"any","countType":"sinceImagePushed","countUnit":"days","countNumber":1095},"action":{"type":"expire"}}]}'
regions=("ap-southeast-2" "us-west-2" "ap-east-1" "eu-west-2" "ca-central-1" "eu-west-1")

for region in "${regions[@]}"; do
    export RegionName="$region"
    echo "RegionName set to: $RegionName"
    aws ecr create-repository --region "$RegionName" --repository-name "$RepoName" --image-tag-mutability IMMUTABLE
    echo $RepoLifecyclePolicy > lifecycle-policy.json 
    aws ecr put-lifecycle-policy --region "$RegionName"  --repository-name "$RepoName" --lifecycle-policy-text "file://lifecycle-policy.json"
    rm -rf lifecycle-policy.json
    echo $RepoPermissionPolicy > permission-policy.json 
    aws ecr set-repository-policy --region "$RegionName" --repository-name "$RepoName" --policy-text "file://permission-policy.json"
    rm -rf permission-policy.json
done
