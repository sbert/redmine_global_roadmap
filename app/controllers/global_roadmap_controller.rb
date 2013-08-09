class GlobalRoadmapController < ApplicationController
  unloadable

  helper :projects
  helper :versions


  def index
    @project = Project.find(params[:project_id])
    @versions = @project.shared_versions || []
    @versions = @versions.uniq.sort

    #remove closed versions
    @completed_versions = @versions.select {|version| version.closed? || version.completed? }
    @versions -= @completed_versions

    @issues_by_version = {}

      issues = Issue.visible.all(
          :include => [:project, :status, :tracker, :priority, :fixed_version],
          :conditions => {:project_id => @project.id},
          :order => "#{Project.table_name}.lft, #{Tracker.table_name}.position, #{Issue.table_name}.id"
      )
      @issues_by_version = issues.group_by(&:fixed_version)

    @global_versions = Hash.new{|h, k| h[k] = []}
    @versions.each do |version|
      @global_versions[version.name[/(.*)\./] + 'x'] << version
    end
  end
end
