xml.instruct!
xml.urlset "xmlns" => "http://www.sitemaps.org/schemas/sitemap/0.9" do

  xml.url do
    xml.loc "http://www.kwendoo.com"
    xml.priority 1.0
    xml.changefreq "daily"
  end

    xml.url do
      xml.loc "http://www.kwendoo.com/"
      xml.priority 0.9
      xml.changefreq "daily"
    end
    %w[apropos commentçamarche définition privacy conditions tarifs originekwendoo pourquoikwendoo exemples successful faq jobs  ].each do |static|
      xml.url do
        xml.loc "http://www.kwendoo.com/#{static}"
        xml.priority 0.1
        xml.changefreq "monthly"
      end
    end


end




