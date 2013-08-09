Redmine::Plugin.register :redmine_global_roadmap do
  name 'Redmine Global Roadmap plugin'
  author 'Sbert'
  description 'This plugin is used to see aggregation of roadmap'
  version '0.0.1'
  url 'http://example.com/path/to/plugin'
  author_url 'http://example.com/about'

  permission :global_roadmap, { :global_roadmap => [:index, :vote] }, :public => true
  menu :project_menu, :redmine_global_roadmap, { :controller => 'global_roadmap', :action => 'index' }, :caption => 'Global Roadmap', :after => :activity, :param => :project_id
end
