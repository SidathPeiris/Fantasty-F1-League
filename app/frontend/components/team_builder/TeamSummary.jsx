import React from 'react'

const TeamSummary = ({ drivers, constructor, totalCost, onSubmit, isValid, onClearAll }) => {

  return (
    <div className="bg-white rounded-lg shadow-lg p-6 pb-8">
      <h2 className="text-xl font-bold text-gray-800 mb-4">Team Summary</h2>
      
      {/* Selected Drivers */}
      <div className="mb-4">
        <h3 className="font-semibold text-gray-700 mb-2">Selected Drivers ({drivers.length}/2)</h3>
        {drivers.length === 0 ? (
          <p className="text-gray-500 text-sm">No drivers selected</p>
        ) : (
          <div className="space-y-2">
            {drivers.map(driver => (
              <div key={driver.id} className="flex justify-between items-center p-2 bg-gray-50 rounded">
                <div>
                  <span className="font-medium text-sm">{driver.name}</span>
                  <span className="text-xs text-gray-500 ml-2">({driver.team})</span>
                </div>
                <div className="text-sm font-bold text-gray-800">
                  ${driver.current_price}M
                </div>
              </div>
            ))}
          </div>
        )}
      </div>

      {/* Selected Constructor */}
      <div className="mb-4">
        <h3 className="font-semibold text-gray-700 mb-2">Selected Constructor</h3>
        {constructor ? (
          <div className="flex justify-between items-center p-2 bg-gray-50 rounded">
            <span className="font-medium text-sm">{constructor.name}</span>
            <div className="text-sm font-bold text-gray-800">
              ${constructor.current_price}M
            </div>
          </div>
        ) : (
          <p className="text-gray-500 text-sm">No constructor selected</p>
        )}
      </div>

      {/* Action Buttons */}
      <div className="flex gap-3 mb-4">
        {/* Clear All Button */}
        <button
          onClick={onClearAll}
          disabled={drivers.length === 0 && !constructor}
          style={{
            backgroundColor: (drivers.length === 0 && !constructor) ? '#9ca3af' : '#dc2626', // gray-400 or red-600
            color: 'white'
          }}
          className={`
            flex-1 py-3 px-4 rounded-lg font-bold transition-all duration-200
            ${(drivers.length === 0 && !constructor)
              ? 'cursor-not-allowed' 
              : 'hover:bg-red-700 shadow-md hover:shadow-lg transform hover:scale-105'
            }
          `}
        >
          Clear All
        </button>
        
        {/* Submit Button */}
        <button
          onClick={onSubmit}
          disabled={!isValid}
          style={{
            backgroundColor: isValid ? '#16a34a' : '#9ca3af', // green-600 or gray-400
            color: 'white'
          }}
          className={`
            flex-1 py-3 px-4 rounded-lg font-bold transition-all duration-200
            ${isValid 
              ? 'hover:bg-green-700 shadow-lg hover:shadow-xl transform hover:scale-105' 
              : 'cursor-not-allowed'
            }
          `}
        >
          {isValid ? 'Create Team' : 'Complete Team Selection'}
        </button>
      </div>

      {/* Validation Messages */}
      {!isValid && (
        <div className="mt-3 text-xs text-gray-600">
          {drivers.length < 2 && <div>• Select exactly 2 drivers</div>}
          {drivers.length > 2 && <div>• Maximum 2 drivers allowed</div>}
          {!constructor && <div>• Select a constructor</div>}
          {totalCost > 100 && <div>• Team exceeds budget limit</div>}
        </div>
      )}
    </div>
  )
}

export default TeamSummary
