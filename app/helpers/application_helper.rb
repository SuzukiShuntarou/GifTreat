# frozen_string_literal: true

module ApplicationHelper
  def full_title(page_title = '')
    base_title = 'GifTreat'
    page_title.empty? ? base_title : "#{page_title} | #{base_title}"
  end

  def default_meta_tags
    {
      reverse: true,
      charset: 'utf-8',
      description: 'GifTreatは自分にご褒美をあげたい人向けのご褒美設定サービスです。',
      keywords: 'GifTreat,ご褒美,ご褒美の共有',
      og: {
        site_name: 'GifTreat',
        title: :title,
        description: :description,
        type: 'website',
        url: request.original_url,
        image: image_url('ogp.png'),
        local: 'ja-JP'
      },
      twitter: {
        card: 'summary_large_image',
        image: image_url('ogp.png')
      }
    }
  end
end
