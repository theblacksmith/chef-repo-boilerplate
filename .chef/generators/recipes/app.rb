require_relative '../helpers'

cookbooks_dir = TemplateHelpers.cookbooks_root
cookbook_dir = TemplateHelpers.cookbook_dir
template_vars = {
  :config => Chef::Config,
  :helper => TemplateHelpers
}

context = ChefDK::Generator.context
app_dir = File.join(context.app_root, context.app_name)

# app root dir
directory app_dir

# Top level files

# TK
template "#{app_dir}/.kitchen.yml" do
  source 'kitchen.yml.erb'
  helpers(ChefDK::Generator::TemplateHelper)
  variables template_vars
end

directory "#{app_dir}/test/integration/default/serverspec" do
  recursive true
end

directory "#{app_dir}/test/integration/helpers/serverspec" do
  recursive true
end

cookbook_file "#{app_dir}/test/integration/helpers/serverspec/spec_helper.rb" do
  source 'serverspec_spec_helper.rb'
  action :create_if_missing
end

template "#{app_dir}/test/integration/default/serverspec/default_spec.rb" do
  source 'serverspec_default_spec.rb.erb'
  helpers(ChefDK::Generator::TemplateHelper)
  variables template_vars
  action :create_if_missing
end

# README
template "#{app_dir}/README.md" do
  helpers(ChefDK::Generator::TemplateHelper)
  variables template_vars
end

# Generated Cookbook:

# cookbook collection dir
directory cookbooks_dir

# cookbook collection dir
directory cookbook_dir

# metadata.rb
template "#{cookbook_dir}/metadata.rb" do
  helpers(ChefDK::Generator::TemplateHelper)
  variables template_vars
end

# chefignore
cookbook_file "#{cookbook_dir}/chefignore"

# Berks
cookbook_file "#{cookbook_dir}/Berksfile"

# Recipes

directory "#{cookbook_dir}/recipes"

template "#{cookbook_dir}/recipes/default.rb" do
  source "recipe.rb.erb"
  helpers(ChefDK::Generator::TemplateHelper)
  variables template_vars
end

# Chefspec
directory "#{cookbook_dir}/spec/unit/recipes" do
  recursive true
end

cookbook_file "#{cookbook_dir}/spec/spec_helper.rb" do
  action :create_if_missing
end

template "#{cookbook_dir}/spec/unit/recipes/default_spec.rb" do
  source "recipe_spec.rb.erb"
  helpers(ChefDK::Generator::TemplateHelper)
  variables template_vars
  action :create_if_missing
end

# git
if context.have_git
  if !context.skip_git_init
    execute("initialize-git") do
      command("git init .")
      cwd app_dir
    end
  end
  cookbook_file "#{app_dir}/.gitignore" do
    source "gitignore"
  end
end
