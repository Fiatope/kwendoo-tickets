module UsersHelper
  def required_by_mangopay(for_element, text_content)
    label_tag for_element do
      concat content_tag(:abbr, '**', class: 'required_by_mangopay', title: I18n.t('users.edit.mangopay.required').capitalize)
      concat ' '
      concat text_content
    end
  end

  def kycs_available_type_to_display(user)
    res = {}
    user.document_types.each do |t|
      translation = t("users.settings.kyc.type.#{t.downcase}")
      res[t] = translation
    end
    res.invert
  end

  def kyc_translated_status(status)
    t("users.settings.kyc.type.#{status.downcase}")
  end
end
