module HeroHeaderTagHelper
  def hero_header_tag(object, options = {}, image = nil, &block)
    image ||= object.hero_image_url || '/assets/event-billetter.jpg'
    content_tag :header, capture(&block),
      # class: [:hero, options[:class], image],
      class: [:hero, options[:class]],
      style: "background: url(#{image}) no-repeat center;background-size: cover;",
      data: { 'image-url' => image_url(image) }
  end
end
