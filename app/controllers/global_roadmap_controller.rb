class GlobalRoadmapController < ApplicationController
  unloadable

  menu_item :redmine_global_roadmap

  helper :projects
  helper :versions

  before_filter :find_project, :authorize, :only => :index


  def index
    @trackers = @project.trackers.sorted.all
    retrieve_selected_tracker_ids(@trackers, @trackers.select {|t| t.is_in_roadmap?})
    @versions = @project.shared_versions || []
    @versions = @versions.uniq.sort

    #remove closed versions
    #@completed_versions = @versions.select {|version| version.closed? || version.completed? }
    #@versions -= @completed_versions

    @issues_by_version = {}

    issues = Issue.visible.all(
        :include => [:project, :status, :tracker, :priority, :fixed_version],
        :conditions => {:tracker_id => @selected_tracker_ids, :project_id => @project.id},
        :order => "#{Project.table_name}.lft, #{Tracker.table_name}.position, #{Issue.table_name}.id"
    )
    @issues_by_version = issues.group_by(&:fixed_version)

    @global_versions = Hash.new{|h, k| h[k] = GlobalVersion.new(k)}
    @versions.each do |version|
      @global_versions[version.name[/(.*)\./] + 'x'].addList(version)
    end
    @global_versions.delete_if {|key, value| value.status == 'closed'}
  end

  private

  def find_project
    # @project variable must be set before calling the authorize filter
    @project = Project.find(params[:project_id])
  end

  def retrieve_selected_tracker_ids(selectable_trackers, default_trackers=nil)
    if ids = params[:tracker_ids]
      @selected_tracker_ids = (ids.is_a? Array) ? ids.collect { |id| id.to_i.to_s } : ids.split('/').collect { |id| id.to_i.to_s }
    else
      @selected_tracker_ids = (default_trackers || selectable_trackers).collect {|t| t.id.to_s }
    end
  end

end
