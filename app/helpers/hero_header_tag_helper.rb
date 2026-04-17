module HeroHeaderTagHelper
  # Hero banner at the top of project / event pages.
  #
  # We use `background-size: contain` (NOT cover) so the user's uploaded image
  # is ALWAYS shown in its entirety, without any crop. This is a deliberate UX
  # choice: users were frustrated because `cover` was cutting parts of the image
  # off whenever the container's aspect ratio did not match the uploaded image.
  #
  # Trade-off: when the image ratio differs from the header's ratio, empty
  # bands may appear on the sides (or top/bottom). We fill them with a neutral
  # dark background (`#1a1a1a`) for a clean, letterboxed look.
  def hero_header_tag(object, options = {}, image = nil, &block)
    image ||= object.hero_image_url || '/assets/event-billetter.jpg'
    content_tag :header, capture(&block),
      class: [:hero, options[:class]],
      style: "background-color: #1a1a1a; background-image: url(#{image}); " \
             "background-repeat: no-repeat; background-position: center; " \
             "background-size: contain;",
      data: { 'image-url' => image_url(image) }
  end
end
