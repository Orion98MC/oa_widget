namespace :oa_widget do
  desc "Sync the oa_widget resources (javascripts, stylesheets ...) to the public dir"
  task :sync_resources do
    system "rsync -ruv vendor/plugins/oa_widget/public/javascripts/ public/javascripts/oa_widget"
    system "rsync -ruv vendor/plugins/oa_widget/public/stylesheets/ public/stylesheets/oa_widget"
  end
end