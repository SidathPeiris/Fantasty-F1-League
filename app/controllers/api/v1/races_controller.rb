class Api::V1::RacesController < Api::V1::BaseController
  def results
    race = Race.find(params[:id])
    
    driver_results = DriverResult.where(race_id: race.id)
    constructor_results = ConstructorResult.where(race_id: race.id)
    qualifying_results = QualifyingResult.where(race_id: race.id)
    
    # Get sprint results if this is a sprint race
    sprint_results = race.sprint_race? ? SprintResult.where(race_id: race.id).map { |sr| { position: sr.position, driver_id: sr.driver_id, points: sr.points } } : []
    sprint_qualifying_results = race.sprint_race? ? SprintQualifyingResult.where(race_id: race.id).map { |sqr| { position: sqr.position, driver_id: sqr.driver_id, points: sqr.points } } : []
    constructor_sprint_results = race.sprint_race? ? ConstructorSprintResult.where(race_id: race.id).map { |csr| { position: csr.position, constructor_name: csr.constructor.name, points: csr.points } } : []
    
    render json: {
      success: true,
      results: {
        driver_results: driver_results.map { |dr| { position: dr.position, driver_id: dr.driver } },
        constructor_results: constructor_results.map { |cr| { position: cr.position, constructor: cr.constructor } },
        qualifying_results: qualifying_results.map { |qr| { position: qr.position, driver_id: qr.driver_id } },
        sprint_results: sprint_results,
        sprint_qualifying_results: sprint_qualifying_results,
        constructor_sprint_results: constructor_sprint_results
      }
    }
  rescue ActiveRecord::RecordNotFound
    render json: { success: false, error: 'Race not found' }, status: :not_found
  end

  def update_sprint_status
    race = Race.find(params[:id])
    
    if race.update(sprint_race: params[:sprint_race])
      render json: { success: true, sprint_race: race.sprint_race }
    else
      render json: { success: false, error: race.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound
    render json: { success: false, error: 'Race not found' }, status: :not_found
  end
end
