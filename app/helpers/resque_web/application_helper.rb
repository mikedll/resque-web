module ResqueWeb
  module ApplicationHelper

    PER_PAGE = 20

    # I don't know why I had to put this here. Should be able to
    # include the proper url helper in the views. 4/16/15 -mikedll
    def engine_url
      ResqueWeb::Engine.app.url_helpers
    end

    def tabs
      t = {
        'overview' => engine_url.overview_path,
        'working'  => engine_url.working_index_path,
        'failures' => engine_url.failures_path,
        'queues' => engine_url.queues_path,
        'workers' => engine_url.workers_path,
        'stats' => engine_url.stats_path
      }
      ResqueWeb::Plugins.plugins.each do |p|
        p.tabs.each { |tab| t.merge!(tab) }
      end
      t
    end

    def tab(name,path)
      content_tag :li, link_to(name.capitalize, path), :class => current_tab?(name) ? "active" : nil
    end

    def current_tab
      params[:controller].gsub(/resque_web\//, "#{root_path}")
    end

    def current_tab?(name)
      params[:controller] == name.to_s
    end

    attr_reader :subtabs

    def subtab(name)
      content_tag :li, link_to(name, "#{current_tab}/#{name}"), :class => current_subtab?(name) ? "current" : nil
    end

    def current_subtab?(name)
      params[:id] == name.to_s
    end

    def pagination(options = {})
      start    = options[:start] || 1
      per_page = options[:per_page] || PER_PAGE
      total    = options[:total] || 0
      return if total < per_page

      markup = ""
      if start - per_page >= 0
        markup << link_to(raw("&laquo; less"), params.merge(:start => start - per_page), :class => 'btn less')
      end

      if start + per_page <= total
        markup << link_to(raw("more &raquo;"), params.merge(:start => start + per_page), :class => 'btn more')
      end

      content_tag :p, raw(markup), :class => 'pagination'
    end

    def poll(polling=false)
      if polling
        text = "Last Updated: #{Time.now.strftime("%H:%M:%S")}".html_safe
      else
        text = "<a href='#{h(request.path)}' rel='poll'>Live Poll</a>".html_safe
      end
      content_tag :p, text, :class => 'poll'
    end
  end
end
