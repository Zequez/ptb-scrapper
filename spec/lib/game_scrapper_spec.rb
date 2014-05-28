require 'spec_helper'

describe GameScrapper do
  def fixture(name)
    file_name = File.expand_path("../../fixtures/#{name}.html", __FILE__)
    File.read file_name
  end

  def stub_page(url, name)
    web_content = fixture name
    stub_request(:get, url).to_return body: web_content
  end

  def stub_game_request(game, name)
    stub_page(GameScrapper.url(game.steam_app_id), name)
  end

  describe '#scrap' do
    context 'valid markup' do
      it 'updates the categories of the game' do
        game = build :game_ar
        stub_game_request(game, 'categories_valid')
        scrapper = GameScrapper.new [game]
        scrapper.scrap
        game.categories.should eq ['Turn-based Strategy', 'Strategy', 'One More Turn',
                                   'Turn-based', 'Addictive', 'Multiplayer',
                                   '4X', 'Timesink', 'Historic', 'Singleplayer']
      end

      it 'updates the #game_updated_at attribute' do
        time_now = Time.now
        game = build :game_ar
        game.game_updated_at = time_now
        stub_game_request(game, 'categories_valid')
        scrapper = GameScrapper.new [game]
        scrapper.scrap
        game.game_updated_at.should_not eq time_now
      end
    end

    context 'region locked' do
      it 'should ignore the game' do
        game = build :game_ar
        stub_game_request(game, 'categories_region_locked_error')
        scrapper = GameScrapper.new [game]
        scrapper.scrap
        game.categories.should eq []
      end
    end

    context 'invalid markup' do
      it 'should raise an InvalidHTML error' do
        game = build :game_ar
        stub_game_request(game, 'categories_invalid')
        scrapper = GameScrapper.new [game]
        -> {scrapper.scrap}.should raise_error Scrapper::InvalidHTML
      end
    end

  end
end