class ApplicationController < ActionController::Base
  helper_method :current_user, :logged_in?, :get_driver_photo_url, :get_constructor_logo_url
  
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def logged_in?
    !!current_user
  end

  def require_login
    unless logged_in?
      redirect_to root_path, notice: "Please log in to access this page."
    end
  end
  
  def get_driver_photo_url(driver_name)
    # Map driver names to their correct F1 photo URLs
    driver_photos = {
      "Max Verstappen" => "https://media.formula1.com/image/upload/f_auto/q_auto/v1677245037/content/dam/fom-website/drivers/M/MAXVER01_Max_Verstappen/maxver01.png.transform/3col/image.png",
      "Lewis Hamilton" => "https://media.formula1.com/image/upload/f_auto/q_auto/v1677245037/content/dam/fom-website/drivers/L/LEWHAM01_Lewis_Hamilton/lewham01.png.transform/3col/image.png",
      "Charles Leclerc" => "https://media.formula1.com/image/upload/f_auto/q_auto/v1677245037/content/dam/fom-website/drivers/C/CHALEC01_Charles_Leclerc/chalec01.png.transform/3col/image.png",
      "Lando Norris" => "https://media.formula1.com/image/upload/f_auto/q_auto/v1677245037/content/dam/fom-website/drivers/L/LANNOR01_Lando_Norris/lannor01.png.transform/3col/image.png",
      "Oscar Piastri" => "https://media.formula1.com/image/upload/f_auto/q_auto/v1677245037/content/dam/fom-website/drivers/O/OSCPIA01_Oscar_Piastri/oscpia01.png.transform/3col/image.png",
      "George Russell" => "https://media.formula1.com/image/upload/f_auto/q_auto/v1677245037/content/dam/fom-website/drivers/G/GEORUS01_George_Russell/georus01.png.transform/3col/image.png",
      "Carlos Sainz" => "https://media.formula1.com/image/upload/f_auto/q_auto/v1677245037/content/dam/fom-website/drivers/C/CARSAI01_Carlos_Sainz/carsai01.png.transform/3col/image.png",
      "Fernando Alonso" => "https://media.formula1.com/image/upload/f_auto/q_auto/v1677245037/content/dam/fom-website/drivers/F/FERALO01_Fernando_Alonso/feralo01.png.transform/3col/image.png",
      "Lance Stroll" => "https://media.formula1.com/image/upload/f_auto/q_auto/v1677245037/content/dam/fom-website/drivers/L/LANSTR01_Lance_Stroll/lanstr01.png.transform/3col/image.png",
      "Alexander Albon" => "https://media.formula1.com/image/upload/f_auto/q_auto/v1677245037/content/dam/fom-website/drivers/A/ALEALB01_Alexander_Albon/alealb01.png.transform/3col/image.png",
      "Yuki Tsunoda" => "https://media.formula1.com/image/upload/f_auto/q_auto/v1677245037/content/dam/fom-website/drivers/Y/YUKTSU01_Yuki_Tsunoda/yuktsu01.png.transform/3col/image.png",
      "Nico Hulkenberg" => "https://media.formula1.com/image/upload/f_auto/q_auto/v1677245037/content/dam/fom-website/drivers/N/NICHUL01_Nico_Hulkenberg/nichul01.png.transform/3col/image.png",
      "Liam Lawson" => "https://media.formula1.com/image/upload/f_auto/q_auto/v1677245037/content/dam/fom-website/drivers/L/LIMLAW01_Liam_Lawson/limlaw01.png.transform/3col/image.png",
      "Esteban Ocon" => "https://media.formula1.com/image/upload/f_auto/q_auto/v1677245037/content/dam/fom-website/drivers/E/ESTOCON01_Esteban_Ocon/estocon01.png.transform/3col/image.png",
      "Pierre Gasly" => "https://media.formula1.com/image/upload/f_auto/q_auto/v1677245037/content/dam/fom-website/drivers/P/PIEGAS01_Pierre_Gasly/piegas01.png.transform/3col/image.png",
      "Kimi Antonelli" => "https://media.formula1.com/image/upload/f_auto/q_auto/v1677245037/content/dam/fom-website/drivers/K/KIMANT01_Kimi_Antonelli/kimant01.png.transform/3col/image.png",
      "Gabriel Bortoleto" => "https://media.formula1.com/image/upload/f_auto/q_auto/v1677245037/content/dam/fom-website/drivers/G/GABBOR01_Gabriel_Bortoleto/gabbor01.png.transform/3col/image.png",
      "Isack Hadjar" => "https://media.formula1.com/image/upload/f_auto/q_auto/v1677245037/content/dam/fom-website/drivers/I/ISAHAD01_Isack_Hadjar/isahad01.png.transform/3col/image.png",
      "Oliver Bearman" => "https://media.formula1.com/image/upload/f_auto/q_auto/v1677245037/content/dam/fom-website/drivers/O/OLIBEA01_Oliver_Bearman/olibea01.png.transform/3col/image.png",
      "Franco Colapinto" => "https://media.formula1.com/image/upload/f_auto/q_auto/v1677245037/content/dam/fom-website/drivers/F/FRACOL01_Franco_Colapinto/fracol01.png.transform/3col/image.png"
    }
    
    driver_photos[driver_name] || "https://media.formula1.com/image/upload/f_auto/q_auto/v1677245037/content/dam/fom-website/drivers/M/MAXVER01_Max_Verstappen/maxver01.png.transform/3col/image.png"
  end
  
  def get_constructor_logo_url(constructor_name)
    # Map constructor names to their correct RacingNews365 logo URLs
    constructor_logos = {
      "Red Bull Racing" => "https://cdn.racingnews365.com/_189x42_crop_center-center_none/red-bull-racing.png?v=1742305303",
      "Ferrari" => "https://cdn.racingnews365.com/_189x42_crop_center-center_none/ferrari-1.png?v=1742305435",
      "Mercedes" => "https://cdn.racingnews365.com/_189x42_crop_center-center_none/mercedes-1.png?v=1742305646",
      "McLaren" => "https://cdn.racingnews365.com/_189x42_crop_center-center_none/mclaren-1.png?v=1742305808",
      "Williams" => "https://cdn.racingnews365.com/_189x42_crop_center-center_none/williams-1.png?v=1742306095",
      "Aston Martin" => "https://cdn.racingnews365.com/_189x42_crop_center-center_none/aston-martin.png?v=1742305914",
      "Kick Sauber" => "https://cdn.racingnews365.com/_189x42_crop_center-center_none/stake-f1-team.png?v=1742305303",
      "Racing Bulls" => "https://cdn.racingnews365.com/_189x42_crop_center-center_none/visa-cash-app-rb.png?v=1742305303",
      "Haas" => "https://cdn.racingnews365.com/_189x42_crop_center-center_none/haas-f1.png?v=1742305303",
      "Alpine" => "https://cdn.racingnews365.com/_189x42_crop_center-center_none/alpine-1.png?v=1742305303"
    }
    
    constructor_logos[constructor_name] || "https://cdn.racingnews365.com/_189x42_crop_center-center_none/red-bull-racing.png?v=1742305303"
  end
end
