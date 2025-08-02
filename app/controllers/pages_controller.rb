class PagesController < ApplicationController
  def home
  end

  def about
  end

  def features
  end

  def contact
  end

  def signup
  end

  def login
  end

  def dashboard
    require_login
  end
end
