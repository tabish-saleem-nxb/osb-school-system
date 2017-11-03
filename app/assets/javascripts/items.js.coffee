# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->
  jQuery("#company_association").prop('checked', true)
    # Validate client
  jQuery("form#new_item, form.edit_item,form#create_item").submit ->
    flag = true
    if jQuery.trim(jQuery("#item_item_name").val()) is ""
      applyPopover(jQuery("#item_item_name"),"Item name is required")
      flag = false
    else if jQuery.trim(jQuery("#item_item_description").val()) is ""
      applyPopover(jQuery("#item_item_description"),"Description is required")
      flag = false
    else if (jQuery('#company_association').is(':checked') is  false and jQuery('#account_association').is(':checked') is  false)
      jQuery("#company_association").prop('checked', true);
      flag = false
    else if jQuery("#item_unit_cost").val() isnt "" and  isNaN(jQuery("#item_unit_cost").val())
      applyPopover(jQuery("#item_unit_cost"),"Must be numeric")
      flag = false
    else if jQuery("#item_item_type").val() is ""
      applyPopover(jQuery("#item_item_type_chzn"), "Select item type")
      flag = false
    else if jQuery('#company_association').is(':checked')
      if jQuery('.options_content input[type=checkbox]:checked').length is 0
       applyPopover(jQuery("#company_association"),"Select a company")
       flag = false
    flag

  applyPopover = (elem,message) ->
    elem.qtip
      content:
        text: message
      show:
        event: false
      hide:
        event: false
      position:
        at: "topRight"
      style:
        tip:
          corner: "leftMiddle"
    elem.qtip().show()
    elem.focus()

  hidePopover = (elem) ->
    elem.qtip("hide")

  jQuery("#item_item_name").click ->
    hidePopover(jQuery(this))

  # show grade dropdown in form if item type is Grade
  url = window.location.pathname
  this.showHideGradeDropDown = (type) ->
    if url.split('/')[2] is 'items' and url.split('/')[3] is 'new' or url.split('/')[4] is 'edit'
      if type is 'Grade'
        jQuery('#item_grade').removeClass('d-none')
      else
        jQuery('#item_grade').addClass('d-none')
        jQuery('#item_grade_id').val('').trigger('liszt:updated')

  jQuery(window).load ->
    if url.split('/')[2] is 'items' and url.split('/')[4] is 'edit'
      if jQuery('#item_item_type').val() is 'Grade'
        jQuery('#item_grade').removeClass('d-none')
