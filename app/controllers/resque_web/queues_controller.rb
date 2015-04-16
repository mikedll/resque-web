module ResqueWeb
  class QueuesController < ResqueWeb::ApplicationController

    def index
    end

    def show
      set_subtabs view_context.queue_names
    end

    def destroy
      Resque.remove_queue(params[:id])
      redirect_to engine_url.queues_path
    end

    def clear
      Resque.redis.del("queue:#{params[:id]}")
      redirect_to engine_url.queue_path(params[:id])
    end

  end
end
