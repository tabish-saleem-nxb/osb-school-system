module SimpleInvoice
  module ApplicationHelper

    def query_string(params)
      "&page=#{params[:page]}&per=#{params[:per]}&company_id=#{params[:company_id]}&sort=#{params[:sort]}&direction=#{params[:direction]}"
    end

    def get_count(params)
      elem = params[:controller]
      model = elem.classify.constantize
      company_id = session['current_company'] || current_user.current_company || current_user.first_company_id

      if %(clients items staffs tasks).include?(elem)
        account = params[:user].current_account
        (account.send(elem).send(params[:status]) + Company.find(company_id).send(elem).send(params[:status])).size
      else
        model.where("company_id IN(?)", company_id).send(params[:status]).count
      end
    end

    def sortable_class(column)
      if column == sort_column
        sort_direction == "asc" ? "sortup" : "sortdown"
      else
        ''
      end
    end

    def sortable(column, title = nil)
      title ||= column.titleize
      css_class = column == sort_column ? "current #{sort_direction}" : nil
      direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
      link_to title, params.merge(:sort => column, :direction => direction, :page => 1), {:class => "#{css_class} sortable", :remote => true}
    end

    def editable_for_clerk?(invoice)
      !(invoice.status.eql?('paid') && (current_user.roles.include?(Role.find_by_name :clerk)))
    end

    def custom_per_page
      content_tag(:select,
                  options_for_select([5, 10, 20, 50, 100], @per_page),
                  :data => {
                      :remote => true,
                      :url => url_for(:action => action_name, :params => params.except(:page), :flag => "per_page")},
                  :name => "per",
                  :class => "per_page chzn-select"
      )
    end

    def get_url
      if current_user.settings.currency.present? and current_user.settings.currency == "On"
        main_app.dashboard_path(currency: currencies.first.try(:id))
      else
        main_app.dashboard_path
      end
    end

    def currencies
      #Currency.where(id: filter_by_company(Invoice,'invoices').group_by(&:currency_id).keys.compact)
      currencies = Currency.where(id: (Invoice.select("DISTINCT(currency_id)").map &:currency_id) )
      currencies = Currency.where(unit: 'USD') if currencies.empty?
      currencies
    end

    #Get company name
    def get_company_name
      company_id = session['current_company'] || current_user.current_company || current_user.first_company_id
      Company.find(company_id).company_name
    end

  end

  # # generate drop down to filter listings by company
  # def filter_by_companies
  #   companies = current_user.current_account.companies
  #   content_tag(:ul) do
  #     companies.each do |company|
  #       params[:company_id] = company.id
  #       if params[:controller] == "dashboard"
  #         url_param = "javascript:"
  #         remote_status = false
  #       else
  #         url_param = url_for(params: params)
  #         remote_status = true
  #       end
  #       link_options = {:remote => remote_status, :class => 'header_company_link', :company_id => company.id, :controller => params[:controller], :action => params[:action]}
  #       concat(content_tag(:li) { link_to(company.company_name, url_param, link_options) })
  #     end
  #   end
  # end

  # def has_access_right?(method, klass)
  #   can? method, klass
  # end

end
