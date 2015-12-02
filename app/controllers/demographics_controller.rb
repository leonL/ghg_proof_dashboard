class DemographicsController < ApplicationController

  def index
    @p = ThemePresenter::DemographicsPresenter.new
    render
  end

  def theme_title
    'Demographics'
  end

end