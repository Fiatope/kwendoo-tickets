class ChannelDecorator < Draper::Decorator
  delegate_all

  def display_video_embed_url
    "//#{object.video_embed_url}?title=0&byline=0&portrait=0&autoplay=0&color=ffffff&badge=0&modestbranding=1&showinfo=0&border=0&controls=2".gsub('http://', '') if object.video_embed_url
  end

  def application_url
    if object.application_url.present?
      object.application_url
    else
      h.new_project_path
    end
  end

  private
  def last_fragment(uri)
    uri.split("/").last
  end
end
