import React, { useState, useEffect } from 'react'
import DriverCard from '../team_builder/DriverCard'
import ConstructorCard from '../team_builder/ConstructorCard'
import BudgetTracker from '../team_builder/BudgetTracker'

const MAX_DRIVERS = 2
const BUDGET_LIMIT = 100

export default function TeamEditor() {
  console.log('TeamEditor component is mounting!')
  console.log('Component props:', {})
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState(null)
  const [drivers, setDrivers] = useState([])
  const [constructors, setConstructors] = useState([])
  const [currentDrivers, setCurrentDrivers] = useState([])
  const [currentConstructor, setCurrentConstructor] = useState(null)
  const [selectedDrivers, setSelectedDrivers] = useState([])
  const [selectedConstructor, setSelectedConstructor] = useState(null)
  const [soldDrivers, setSoldDrivers] = useState([])
  const [soldConstructor, setSoldConstructor] = useState(null)
  const [currentBalance, setCurrentBalance] = useState(0)

  useEffect(() => {
    fetchData()
  }, [])

  const fetchData = async () => {
    try {
      setLoading(true)
      
      // Fetch all drivers and constructors
      const [driversResponse, constructorsResponse] = await Promise.all([
        fetch('/api/v1/drivers'),
        fetch('/api/v1/constructors')
      ])
      
      if (!driversResponse.ok || !constructorsResponse.ok) {
        throw new Error('Failed to fetch data')
      }
      
      const driversData = await driversResponse.json()
      const constructorsData = await constructorsResponse.json()
      
      // Sort by current price (highest first)
      const sortedDrivers = driversData.sort((a, b) => b.current_price - a.current_price)
      const sortedConstructors = constructorsData.sort((a, b) => b.current_price - a.current_price)
      
      setDrivers(sortedDrivers)
      setConstructors(sortedConstructors)
      
      // Extract current team data from the data-current-team prop
      const currentTeamElement = document.querySelector('[data-react-component="TeamEditor"]')
      console.log('Current team element found:', currentTeamElement)
      
      if (currentTeamElement) {
        const currentTeamData = JSON.parse(currentTeamElement.getAttribute('data-current-team'))
        console.log('Current team data:', currentTeamData)
        
        setCurrentDrivers(currentTeamData.drivers || [])
        setCurrentConstructor(currentTeamData.constructor || null)
        setCurrentBalance(currentTeamData.current_balance || 0)
        
        // Initialize selected items with current team
        setSelectedDrivers(currentTeamData.drivers || [])
        setSelectedConstructor(currentTeamData.constructor || null)
      } else {
        console.error('Could not find TeamEditor element!')
      }
      
    } catch (err) {
      setError(err.message)
    } finally {
      setLoading(false)
    }
  }

  const handleDriverSelect = (driver) => {
    if (selectedDrivers.find(d => d.id === driver.id)) {
      // Deselecting driver
      setSelectedDrivers(selectedDrivers.filter(d => d.id !== driver.id))
    } else {
      // Selecting new driver
      if (selectedDrivers.length >= MAX_DRIVERS) {
        alert(`You can only select ${MAX_DRIVERS} drivers`)
        return
      }
      
      // Check budget constraint
      if (wouldExceedBudget(driver.current_price)) {
        showBudgetWarning(driver.name, driver.current_price)
        return
      }
      
      setSelectedDrivers([...selectedDrivers, driver])
    }
  }

  const handleConstructorSelect = (constructor) => {
    if (selectedConstructor && selectedConstructor.id === constructor.id) {
      // Deselecting constructor
      setSelectedConstructor(null)
    } else {
      // Selecting new constructor
      if (wouldExceedBudget(constructor.current_price)) {
        showBudgetWarning(constructor.name, constructor.current_price)
        return
      }
      setSelectedConstructor(constructor)
    }
  }

  const handleDriverSale = (driver) => {
    console.log('handleDriverSale called for:', driver.name)
    console.log('Current soldDrivers:', soldDrivers)
    console.log('Current selectedDrivers:', selectedDrivers)
    
    if (soldDrivers.find(d => d.id === driver.id)) {
      // Unsell driver
      console.log('Unselling driver:', driver.name)
      setSoldDrivers(soldDrivers.filter(d => d.id !== driver.id))
      // Add back to selected drivers if it was selected
      if (!selectedDrivers.find(d => d.id === driver.id)) {
        setSelectedDrivers([...selectedDrivers, driver])
      }
    } else {
      // Sell driver
      console.log('Selling driver:', driver.name)
      setSoldDrivers([...soldDrivers, driver])
      // Remove from selected drivers
      setSelectedDrivers(selectedDrivers.filter(d => d.id !== driver.id))
    }
    
    console.log('After update - soldDrivers:', soldDrivers)
    console.log('After update - selectedDrivers:', selectedDrivers)
  }

  const handleConstructorSale = (constructor) => {
    console.log('handleConstructorSale called for:', constructor.name)
    console.log('Current soldConstructor:', soldConstructor)
    console.log('Current selectedConstructor:', selectedConstructor)
    
    if (soldConstructor && soldConstructor.id === constructor.id) {
      // Unsell constructor
      console.log('Unselling constructor:', constructor.name)
      setSoldConstructor(null)
      // Add back to selected constructor if it was selected
      if (!selectedConstructor || selectedConstructor.id !== constructor.id) {
        setSelectedConstructor(constructor)
      }
    } else {
      // Sell constructor
      console.log('Selling constructor:', constructor.name)
      setSoldConstructor(constructor)
      // Remove from selected constructor
      setSelectedConstructor(null)
    }
    
    console.log('After update - soldConstructor:', soldConstructor)
    console.log('After update - selectedConstructor:', selectedConstructor)
  }

  const wouldExceedBudget = (additionalCost) => {
    const currentCost = getTotalCost()
    const soldMoney = getSoldMoney()
    const availableBudget = currentBalance + soldMoney
    return (currentCost + additionalCost) > availableBudget
  }

  const getTotalCost = () => {
    const driversCost = selectedDrivers.reduce((sum, driver) => sum + driver.current_price, 0)
    const constructorCost = selectedConstructor ? selectedConstructor.current_price : 0
    return driversCost + constructorCost
  }

  const getSoldMoney = () => {
    // Use current market values for sold items
    const driversMoney = soldDrivers.reduce((sum, driver) => {
      const currentDriver = drivers.find(d => d.id === driver.id)
      return sum + (currentDriver ? currentDriver.current_price : 0)
    }, 0)

    const constructorMoney = soldConstructor ? 
      (constructors.find(c => c.id === soldConstructor.id)?.current_price || 0) : 0

    return driversMoney + constructorMoney
  }

  const getRemainingBudget = () => {
    const soldMoney = getSoldMoney()
    const availableBudget = currentBalance + soldMoney
    return availableBudget - getTotalCost()
  }

  const isBudgetExceeded = () => {
    return getRemainingBudget() < 0
  }

  const showBudgetWarning = (itemName, cost) => {
    alert(`Cannot add ${itemName} ($${cost}M) - would exceed available budget of $${getRemainingBudget()}M`)
  }

  const handleSubmitTeam = async () => {
    if (selectedDrivers.length !== MAX_DRIVERS) {
      alert(`Please select exactly ${MAX_DRIVERS} drivers`)
      return
    }
    
    if (!selectedConstructor) {
      alert('Please select a constructor')
      return
    }
    
    if (isBudgetExceeded()) {
      alert('Team exceeds available budget. Please adjust your selections.')
      return
    }

    try {
      const csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content')
      
      const data = new URLSearchParams({
        drivers: selectedDrivers.map(d => d.id).join(','),
        constructor: selectedConstructor.id,
        sold_drivers: soldDrivers.map(d => d.id).join(','),
        sold_constructor: soldConstructor ? soldConstructor.id : ''
      })

      const response = await fetch('/edit-team', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'X-Requested-With': 'XMLHttpRequest',
          'X-CSRF-Token': csrfToken
        },
        body: data
      })
      
      console.log('Response status:', response.status)

      if (response.ok) {
        const result = await response.json()
        alert(`Team updated successfully!\n\nTotal Cost: $${getTotalCost()}M\nBudget Remaining: $${getRemainingBudget()}M`)
        
        // Redirect to my-team page
        window.location.href = '/my-team'
      } else {
        console.log('Error response status:', response.status)
        const responseText = await response.text()
        console.log('Response text:', responseText)
        
        try {
          const errorData = JSON.parse(responseText)
          alert(`Failed to update team: ${errorData.message || 'Unknown error'}`)
        } catch (parseError) {
          console.error('Failed to parse error response:', parseError)
          alert(`Failed to update team: Server returned HTML instead of JSON. Status: ${response.status}\n\nResponse: ${responseText.substring(0, 200)}...`)
        }
      }
    } catch (err) {
      alert('Error updating team: ' + err.message)
    }
  }

  if (loading) {
    return (
      <div className="flex justify-center items-center min-h-64">
        <div className="text-f1-red-600 text-xl font-bold">Loading team editor...</div>
      </div>
    )
  }

  if (error) {
    return (
      <div className="text-red-600 text-center p-4">
        <div className="text-lg font-bold mb-2">Error loading team editor</div>
        <div className="text-sm">{error}</div>
        <button 
          onClick={fetchData}
          className="mt-4 bg-f1-red-600 text-white px-4 py-2 rounded hover:bg-f1-red-700"
        >
          Retry
        </button>
      </div>
    )
  }

  // Safety check for required data
  if (!currentDrivers || !Array.isArray(currentDrivers)) {
    console.error('currentDrivers is not properly initialized:', currentDrivers)
    return (
      <div className="text-red-600 text-center p-4">
        <div className="text-lg font-bold mb-2">Error: Team data not loaded properly</div>
        <div className="text-sm">Please refresh the page and try again.</div>
        <button 
          onClick={fetchData}
          className="mt-4 bg-f1-red-600 text-white px-4 py-2 rounded hover:bg-f1-red-700"
        >
          Retry
        </button>
      </div>
    )
  }

  try {
    return (
      <div className="w-full p-6">
        

        <div className="grid grid-cols-1 lg:grid-cols-2 gap-8 w-full">
          {/* Left Column - Current Team and Rules */}
          <div className="w-full space-y-6">
            {/* Current Team Box */}
            <div className="bg-green-500 rounded-lg shadow-lg p-6">
              <h2 className="text-2xl font-bold text-gray-800 mb-4">🏎️ Current Team</h2>
              <div className="space-y-4">
                <div>
                  <h3 className="text-lg font-semibold text-gray-700 mb-2">Current Drivers:</h3>
                  <div className="grid grid-cols-1 gap-2">
                    {currentDrivers && currentDrivers.length > 0 ? (
                      currentDrivers.map(driver => (
                        <div key={driver.id} className="flex items-center justify-between bg-gray-100 p-3 rounded-lg border border-gray-200">
                          <div className="text-gray-800">
                            <div className="font-medium">{driver.name} - ${driver.current_price}M</div>
                            <div className="text-sm text-gray-600">Original: ${driver.original_cost}M</div>
                          </div>
                          <button
                            onClick={() => handleDriverSale(driver)}
                            className={`px-3 py-1 rounded text-sm font-medium transition-colors ${
                              soldDrivers.find(d => d.id === driver.id)
                                ? 'bg-red-600 text-white hover:bg-red-700'
                                : 'bg-blue-600 text-white hover:bg-blue-700'
                            }`}
                          >
                            {soldDrivers.find(d => d.id === driver.id) ? 'Selling' : 'Sell'}
                          </button>
                        </div>
                      ))
                    ) : (
                      <div className="text-gray-500 text-center py-4">No drivers in current team</div>
                    )}
                  </div>
                </div>
                <div>
                  <h3 className="text-lg font-semibold text-gray-700 mb-2">Current Constructor:</h3>
                  {currentConstructor ? (
                    <div className="flex items-center justify-between bg-gray-100 p-3 rounded-lg border border-gray-200">
                      <div className="text-gray-800">
                        <div className="font-medium">{currentConstructor.name} - ${currentConstructor.current_price}M</div>
                        <div className="text-sm text-gray-600">Original: ${currentConstructor.original_cost}M</div>
                      </div>
                      <button
                        onClick={() => handleConstructorSale(currentConstructor)}
                        className={`px-3 py-1 rounded text-sm font-medium transition-colors ${
                          soldConstructor && soldConstructor.id === currentConstructor.id
                            ? 'bg-red-600 text-white hover:bg-red-700'
                            : 'bg-blue-600 text-white hover:bg-blue-700'
                        }`}
                      >
                        {soldConstructor && soldConstructor.id === currentConstructor.id ? 'Selling' : 'Sell'}
                      </button>
                    </div>
                  ) : (
                    <div className="text-gray-500 text-center py-4">No constructor in current team</div>
                  )}
                </div>
              </div>
            </div>

            {/* Transfer Rules Box */}
            <div className="bg-gradient-to-br from-blue-800 to-blue-900 p-6 rounded-2xl border border-blue-600">
              <h2 className="text-2xl font-bold text-white mb-4">📋 Transfer Rules</h2>
              <div className="grid grid-cols-1 gap-4 text-gray-300">
                <div className="flex items-center space-x-2">
                  <span className="text-green-400">✓</span>
                  <span>Sell current drivers/constructor at their current market value</span>
                </div>
                <div className="flex items-center space-x-2">
                  <span className="text-green-400">✓</span>
                  <span>Use remaining balance + sale proceeds to buy replacements</span>
                </div>
                <div className="flex items-center space-x-2">
                  <span className="text-green-400">✓</span>
                  <span>Maintain exactly 2 drivers + 1 constructor</span>
                </div>
                <div className="flex items-center space-x-2">
                  <span className="text-green-400">✓</span>
                  <span>Stay within your available budget</span>
                </div>
              </div>
            </div>

            {/* Budget Tracker */}
            <BudgetTracker 
              totalCost={getTotalCost()}
              totalBudget={currentBalance + getSoldMoney()}
              remainingBudget={getRemainingBudget()}
              soldMoney={getSoldMoney()}
              isExceeded={isBudgetExceeded()}
            />

            {/* Submit Button */}
            <button
              onClick={handleSubmitTeam}
              disabled={isBudgetExceeded() || selectedDrivers.length !== MAX_DRIVERS || !selectedConstructor}
              className={`w-full py-4 px-6 rounded-2xl font-bold text-lg transition-all duration-300 ${
                isBudgetExceeded() || selectedDrivers.length !== MAX_DRIVERS || !selectedConstructor
                  ? 'bg-gray-500 text-gray-300 cursor-not-allowed'
                  : 'bg-gradient-to-r from-green-600 to-green-700 text-white hover:from-green-700 hover:to-green-800 transform hover:scale-105'
              }`}
            >
              Update Team
            </button>
          </div>

          {/* Right Column - Available Drivers and Constructors */}
          <div className="space-y-6">
            {/* Drivers Section */}
            <div className="bg-white rounded-lg shadow-lg p-6">
              <h2 className="text-2xl font-bold text-gray-800 mb-4">Select Drivers ({selectedDrivers.length}/{MAX_DRIVERS})</h2>
              <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
                {drivers.map(driver => (
                  <DriverCard
                    key={driver.id}
                    driver={driver}
                    isSelected={selectedDrivers.some(d => d.id === driver.id)}
                    isCurrent={currentDrivers.find(d => d.id === driver.id)}
                    isSold={soldDrivers.find(d => d.id === driver.id)}
                    onSelect={() => handleDriverSelect(driver)}
                    disabled={selectedDrivers.length >= MAX_DRIVERS && !selectedDrivers.some(d => d.id === driver.id)}
                  />
                ))}
              </div>
            </div>

            {/* Constructor Selection */}
            <div className="bg-white rounded-lg shadow-lg p-6">
              <h2 className="text-2xl font-bold text-gray-800 mb-4">Select Constructor</h2>
              <div className="grid grid-cols-2 gap-3">
                {constructors.map(constructor => (
                  <ConstructorCard
                    key={constructor.id}
                    constructor={constructor}
                    isSelected={selectedConstructor?.id === constructor.id}
                    isCurrent={currentConstructor && currentConstructor.id === constructor.id}
                    isSold={soldConstructor && soldConstructor.id === constructor.id}
                    onSelect={() => handleConstructorSelect(constructor)}
                    disabled={wouldExceedBudget(constructor.current_price)}
                  />
                ))}
              </div>
            </div>
          </div>
        </div>
      </div>
    )
  } catch (renderError) {
    console.error('Error rendering TeamEditor:', renderError)
    return (
      <div className="text-red-600 text-center p-4">
        <div className="text-lg font-bold mb-2">Error rendering team editor</div>
        <div className="text-sm">Please refresh the page and try again.</div>
        <button 
          onClick={fetchData}
          className="mt-4 bg-f1-red-600 text-white px-4 py-2 rounded hover:bg-f1-red-700"
        >
          Retry
        </button>
      </div>
    )
  }
}
