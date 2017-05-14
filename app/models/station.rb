class Station < ApplicationRecord
  include Elasticsearch::Model

  #index_name "staion_names"

  settings index: {
    analysis: {
      analyzer: {
        katakana_analyzer: {
          tokenizer: 'kuromoji_tokenizer',
          filter: ['katakana_readingform']
        }
      },
      filter: {
        katakana_readingform: {
          type: 'kuromoji_readingform',
          use_romaji: false
        }
      }
    }
  } do
    mappings dynamic: 'false' do
      indexes :station, analyzer: 'kuromoji'

      indexes :suggest do
        indexes :name_raw, type: 'completion'
        indexes :name_hira, type: 'completion'
      end
    end
  end

  # method call as indexesing
  # return mapping dates
  def as_indexed_json(options = {})
    print("indexed_json")
    attributes
      .symbolize_keys
      .merge(suggest: {
        name_raw: station,
        })
  end

  SUGGEST_KEYS = %w(name_raw name_hira)

    # 次のようなサジェストのボディ(Hash)を作成
    #
    # name_raw: {
    #   text: <keyword>,
    #   completion: { field: "suggest.name_raw", size: 10 }
    # },
    # name_kana: {
    #   ...
    # }
    #
  def self.suggest(keyword)
    suggest_definition = SUGGEST_KEYS.inject({}) do |result, key|
      print("suggest")
      result.merge(
        key => {
          text: keyword,
          completion: {field: "suggest.#{key}", size: 10}
        }
      )
    end

    # elasticsearch-persistence を利用し、Elasticsearchにサジェストクエリを送る
    response = Elasticsearch::Persistence.client.suggest({
      index: Station.index_name,
      body: suggest_definition
    })

    # Elasticsearchからの結果を配列に変換する
    SUGGEST_KEYS.map do |key|
      response[key][0]['options'].map{|opt| opt.fetch('text', nil)}
    end.flatten.uniq
  end
end
