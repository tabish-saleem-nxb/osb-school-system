module SimpleInvoice
  class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception
    before_action :set_locale
    before_filter :set_per_page

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

    def get_clients_and_items
      parent = Company.find(params[:company_id] || get_company_id)
      @get_clients = get_clients(parent)
      @get_items = get_items(parent)
      @parent_class = parent.class.to_s
    end

    def get_clients(parent)
      options = ''
      parent.clients.each { |client| options += "<option value=#{client.id} type='company_level'>#{client.organization_name}</option>" } if parent.clients.present?
      options
    end

    # generate items options associated with company
    def get_items(parent)
      options = ''
      parent.items.each { |item| options += "<option value=#{item.id} type='company_level'>#{item.item_name}</option>" } if parent.items.present?
      options
    end

    def set_per_page
      @per_page = if params[:per]
                    params[:per]
                  else
                    if current_user.present?
                      current_user.settings.records_per_page
                    else
                      session["#{controller_name}-per_page"]
                    end
                  end
    end

    protected

    def set_locale
      I18n.locale = params[:locale] || current_user.settings.language.try(:to_sym) || I18n.default_locale if current_user
    end

    def default_url_options(options = {})
      { locale: I18n.locale }.merge options
    end

  end
end
