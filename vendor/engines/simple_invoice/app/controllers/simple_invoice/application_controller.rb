module SimpleInvoice
  class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception

    #set session of company_id
    def set_company_session
      unless params[:company_id].blank?
        session['current_company'] = params[:company_id]
        current_user.update_attributes(current_company: params[:company_id])
      end
    end

    def get_company_id
      session['current_company'] || current_user.current_company || current_user.first_company_id
    end

    def filter_by_company(elem, tbl=params[:controller])
      # set company dropdown session and save in database if company is changed
      unless params[:company_id].blank?
        session['current_company'] = params[:company_id]
        current_user.update_attributes(current_company: params[:company_id])
      end
      elem.where("#{tbl[/([^\/]+)$/]}.company_id IN(?)", get_company_id())
    end

    def choose_layout
      %w(preview payments_history).include?(action_name) ? 'preview_mode' : 'application'
    end
  end
end
