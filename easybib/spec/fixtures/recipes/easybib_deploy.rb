test_deploy_data = {
  "deploy_to" => "/srv/www/some-app",
  "document_root" => "public",
  "group" => "deploy",
  "user" => "deploy"
}

easybib_deploy "some-app" do
  deploy_data test_deploy_data
  app "some-app"
end
