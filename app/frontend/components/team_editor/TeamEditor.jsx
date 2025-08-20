import React, { useState, useEffect } from 'react'
import DriverCard from '../team_builder/DriverCard'
import ConstructorCard from '../team_builder/ConstructorCard'


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
        console.log('Current team data.current_balance:', currentTeamData.current_balance)
        console.log('typeof current_balance:', typeof currentTeamData.current_balance)
        
        setCurrentDrivers(currentTeamData.drivers || [])
        setCurrentConstructor(currentTeamData.constructor || null)
        setCurrentBalance(currentTeamData.current_balance || 0)
        
        console.log('Setting currentBalance to:', currentTeamData.current_balance || 0)
        
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
    // Prevent selecting/deselecting sold drivers
    if (soldDrivers.find(d => d.id === driver.id)) {
      return // Do nothing if driver is sold
    }
    
    // Prevent selecting/deselecting current team members who haven't been sold yet
    const isCurrentTeamMember = currentDrivers.find(d => d.id === driver.id)
    if (isCurrentTeamMember && !soldDrivers.find(d => d.id === driver.id)) {
      return // Do nothing if driver is in current team but not sold
    }
    
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
      if (wouldExceedAvailableBudget(driver.current_price)) {
        showEditBudgetWarning(driver.name, driver.current_price)
        return
      }
      
      setSelectedDrivers([...selectedDrivers, driver])
    }
  }

  const handleConstructorSelect = (constructor) => {
    // Prevent selecting/deselecting sold constructor
    if (soldConstructor && soldConstructor.id === constructor.id) {
      return // Do nothing if constructor is sold
    }
    
    // Prevent selecting/deselecting current constructor who hasn't been sold yet
    const isCurrentTeamMember = currentConstructor && currentConstructor.id === constructor.id
    if (isCurrentTeamMember && !(soldConstructor && soldConstructor.id === constructor.id)) {
      return // Do nothing if constructor is in current team but not sold
    }
    
    if (selectedConstructor && selectedConstructor.id === constructor.id) {
      // Deselecting constructor
      setSelectedConstructor(null)
    } else {
      // Selecting new constructor
      // Check budget constraint
      if (wouldExceedAvailableBudget(constructor.current_price)) {
        showEditBudgetWarning(constructor.name, constructor.current_price)
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

  const handleClearChanges = () => {
    // Reset selections back to current team
    setSelectedDrivers([...currentDrivers])
    setSelectedConstructor(currentConstructor)
    setSoldDrivers([])
    setSoldConstructor(null)
    
    alert('Changes cleared! Your selections have been reset to your current team.')
  }

  // Budget Tracker Functions for Edit Team Page
  const getSaleProceeds = () => {
    const driverSales = soldDrivers.reduce((total, driver) => total + driver.current_price, 0)
    const constructorSales = soldConstructor ? soldConstructor.current_price : 0
    return driverSales + constructorSales
  }

  const getAvailableBudget = () => {
    return currentBalance + getSaleProceeds() - getNewSelectionsCost()
  }

  const getAvailableBudgetColor = () => {
    const available = getAvailableBudget()
    if (available >= 50) return '#16a34a'      // $50M+ = Green
    if (available >= 25) return '#ca8a04'      // $25M-$49M = Yellow  
    if (available >= 10) return '#ea580c'      // $10M-$24M = Orange
    return '#dc2626'                            // $0M-$9M = Red
  }

  const getNewSelectionsCost = () => {
    // Only calculate cost of NEW selections (replacements)
    const newDriverCost = selectedDrivers
      .filter(driver => !currentDrivers.find(cd => cd.id === driver.id))
      .reduce((total, driver) => total + driver.current_price, 0)
    
    const newConstructorCost = selectedConstructor && 
      (!currentConstructor || selectedConstructor.id !== currentConstructor.id) 
      ? selectedConstructor.current_price : 0
    
    return newDriverCost + newConstructorCost
  }

  const getEditBudgetLimit = () => {
    return 100
  }

  const getBudgetUsagePercentage = () => {
    const cost = getAvailableBudget()
    const maxBudget = getEditBudgetLimit()
    // Cap at 100% to prevent slider from breaking
    const percentage = Math.round((cost / getEditBudgetLimit()) * 100)
    return Math.min(percentage, 100)
  }

  const getEditProgressBarColor = () => {
    const percentage = getBudgetUsagePercentage()
    if (percentage <= 50) return '#dc2626'      // 0-50% = Red 
    if (percentage <= 75) return '#ea580c'      // 51-75% = Orange
    if (percentage <= 90) return '#ca8a04'      // 76-90% = Yellow
    return '#16a34a'                            // 91-100% = Green
  }

  const isEditBudgetExceeded = () => {
    const available = getAvailableBudget()
    return available < 0
  }

  const wouldExceedEditBudget = (additionalCost) => {
    const currentCost = getNewSelectionsCost()
    return (currentCost + additionalCost) > getEditBudgetLimit()
  }

  const wouldExceedAvailableBudget = (additionalCost) => {
    const currentCost = getNewSelectionsCost()
    const totalAvailable = currentBalance + getSaleProceeds()
    // Check if adding this cost would exceed total available funds
    return (currentCost + additionalCost) > totalAvailable
  }

  const showEditBudgetWarning = (itemName, cost) => {
    const currentCost = getNewSelectionsCost()
    const newTotal = currentCost + cost
    const available = getAvailableBudget()
    const overBudget = newTotal - available
    
    alert(`⚠️ Insufficient Funds!\n\nAdding ${itemName} ($${cost}M) would make your new selections total $${newTotal}M, which is $${overBudget}M over your available budget of $${available}M.\n\nPlease sell more items or select cheaper replacements to stay within your available budget.`)
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
    
    if (isEditBudgetExceeded()) {
      alert('Team exceeds available budget. Please adjust your selections or sell more items.')
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
        alert(`Team updated successfully!`)
        
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
          {/* Left Column - Transfer Rules */}
          <div className="w-full">
            {/* Transfer Rules Box */}
            <div className="bg-gradient-to-br from-blue-800 to-blue-900 p-8 rounded-2xl border border-blue-600 h-full">
              <h2 className="text-2xl font-bold text-white mb-6">📋 Transfer Rules</h2>
              <div className="grid grid-cols-1 gap-6 text-gray-300">
                <div className="flex items-center space-x-3">
                  <span className="text-green-400 text-xl">✓</span>
                  <span className="text-lg">Sell current drivers/constructor at their current market value</span>
                </div>
                <div className="flex items-center space-x-3">
                  <span className="text-green-400 text-xl">✓</span>
                  <span className="text-lg">Use remaining balance + sale proceeds to buy replacements</span>
                </div>
                <div className="flex items-center space-x-3">
                  <span className="text-green-400 text-xl">✓</span>
                  <span className="text-lg">Maintain exactly 2 drivers + 1 constructor</span>
                </div>
                <div className="flex items-center space-x-3">
                  <span className="text-green-400 text-xl">✓</span>
                  <span className="text-lg">Stay within your available budget</span>
                </div>
              </div>
            </div>
          </div>

          {/* Right Column - Current Team */}
          <div className="w-full">
            {/* Current Team Box */}
            <div className="bg-white rounded-lg shadow-lg p-6 h-full">
              <h2 className="text-2xl font-bold text-black mb-4">🏎️ Current Team</h2>
              <div className="space-y-4">
                <div>
                  <h3 className="text-lg font-semibold text-black mb-2">Current Drivers:</h3>
                  <div className="grid grid-cols-1 gap-2">
                    {currentDrivers && currentDrivers.length > 0 ? (
                      currentDrivers.map(driver => (
                        <div key={driver.id} className="flex items-center justify-between bg-gray-100 p-3 rounded-lg border border-gray-200">
                          <div className="text-black">
                            <div className="font-medium">{driver.name} - <span style={{color: '#f97316'}}>${driver.current_price}M</span></div>
                            <div className="text-sm text-black">Bought Price: <span style={{color: '#43A047'}}>${driver.original_cost}M</span></div>
                          </div>
                          <button
                            onClick={() => handleDriverSale(driver)}
                            className="px-3 py-1 rounded text-sm font-medium transition-colors"
                            style={{
                              backgroundColor: soldDrivers.find(d => d.id === driver.id) ? '#dc2626' : '#2563eb',
                              color: soldDrivers.find(d => d.id === driver.id) ? '#ffffff' : '#f97316'
                            }}
                            onMouseEnter={(e) => {
                              if (!soldDrivers.find(d => d.id === driver.id)) {
                                e.target.style.backgroundColor = '#1d4ed8'
                                e.target.style.color = '#ffffff'
                              }
                            }}
                            onMouseLeave={(e) => {
                              if (!soldDrivers.find(d => d.id === driver.id)) {
                                e.target.style.backgroundColor = '#2563eb'
                                e.target.style.color = '#dc2626'
                              }
                            }}
                          >
                            {soldDrivers.find(d => d.id === driver.id) ? 'Selling' : 'Sell'}
                          </button>
                        </div>
                      ))
                    ) : (
                      <div className="text-black text-center py-4">No drivers in current team</div>
                    )}
                  </div>
                </div>
                <div>
                  <h3 className="text-lg font-semibold text-black mb-2">Current Constructor:</h3>
                  {currentConstructor ? (
                    <div className="flex items-center justify-between bg-gray-100 p-3 rounded-lg border border-gray-200">
                      <div className="text-black">
                        <div className="font-medium">{currentConstructor.name} - <span style={{color: '#f97316'}}>${currentConstructor.current_price}M</span></div>
                        <div className="text-sm text-black">Bought Price: <span style={{color: '#43A047'}}>${currentConstructor.original_cost}M</span></div>
                      </div>
                      <button
                        onClick={() => handleConstructorSale(currentConstructor)}
                        className="px-3 py-1 rounded text-sm font-medium transition-colors"
                        style={{
                          backgroundColor: soldConstructor && soldConstructor.id === currentConstructor.id ? '#dc2626' : '#2563eb',
                          color: soldConstructor && soldConstructor.id === currentConstructor.id ? '#ffffff' : '#f97316'
                        }}
                        onMouseEnter={(e) => {
                          if (!(soldConstructor && soldConstructor.id === currentConstructor.id)) {
                            e.target.style.backgroundColor = '#1d4ed8'
                            e.target.style.color = '#ffffff'
                          }
                        }}
                        onMouseLeave={(e) => {
                          if (!(soldConstructor && soldConstructor.id === currentConstructor.id)) {
                            e.target.style.backgroundColor = '#2563eb'
                            e.target.style.color = '#dc2626'
                          }
                        }}
                      >
                        {soldConstructor && soldConstructor.id === currentConstructor.id ? 'Selling' : 'Sell'}
                      </button>
                    </div>
                  ) : (
                    <div className="text-black text-center py-4">No constructor in current team</div>
                  )}
                </div>
              </div>
            </div>
          </div>
        </div>

        {/* Available Drivers and Constructors */}
        <div className="mt-8">
          <div className="grid grid-cols-1 lg:grid-cols-2 gap-8">
            {/* Drivers Section - Left Column */}
            <div className="bg-white rounded-lg shadow-lg p-6">
              <h2 className="text-2xl font-bold text-black mb-4">Select Drivers ({selectedDrivers.length}/{MAX_DRIVERS})</h2>
              <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
                {drivers.map(driver => (
                  <DriverCard
                    key={driver.id}
                    driver={driver}
                    isSelected={selectedDrivers.some(d => d.id === driver.id)}
                    isCurrent={currentDrivers.find(d => d.id === driver.id)}
                    isSold={!!soldDrivers.find(d => d.id === driver.id)}
                    onSelect={() => handleDriverSelect(driver)}
                    disabled={
                      selectedDrivers.length >= MAX_DRIVERS && !selectedDrivers.some(d => d.id === driver.id) ||
                      (!selectedDrivers.some(d => d.id === driver.id) && wouldExceedAvailableBudget(driver.current_price))
                    }
                  />
                ))}
              </div>
            </div>

            {/* Constructor Selection - Right Column */}
            <div className="bg-white rounded-lg shadow-lg p-6">
              <h2 className="text-2xl font-bold text-black mb-4">Select Constructor</h2>
              <div className="grid grid-cols-2 gap-6">
                {constructors.map(constructor => (
                  <ConstructorCard
                    key={constructor.id}
                    constructor={constructor}
                    isSelected={selectedConstructor?.id === constructor.id}
                    isCurrent={currentConstructor && currentConstructor.id === constructor.id}
                    isSold={!!(soldConstructor && soldConstructor.id === constructor.id)}
                    onSelect={() => handleConstructorSelect(constructor)}
                    disabled={
                      selectedConstructor && selectedConstructor.id !== constructor.id ||
                      (!selectedConstructor || selectedConstructor.id !== constructor.id) && wouldExceedAvailableBudget(constructor.current_price)
                    }
                  />
                ))}
              </div>
            </div>
          </div>
        </div>

        {/* Budget Tracker */}
        <div className="mt-8 bg-white rounded-lg shadow-lg p-6">
          <h2 className="text-2xl font-bold text-black mb-4">💰 Budget Tracker</h2>
          <div className="space-y-4">
            {/* Budget Information */}
            <div className="grid grid-cols-2 gap-4 text-center">
              <div>
                <div className="text-sm text-gray-600 mb-1">Sale Proceeds</div>
                <div className="text-2xl font-bold text-green-600">+${getSaleProceeds()}M</div>
              </div>
              <div>
                <div className="text-sm text-gray-600 mb-1">Available Budget</div>
                <div className="text-2xl font-bold" style={{color: getAvailableBudgetColor()}}>${getAvailableBudget()}M</div>
              </div>
            </div>

            {/* New Selections Cost */}
            <div className="bg-gray-50 p-4 rounded-lg">
              <div className="flex justify-between items-center mb-2">
                <span className="text-lg font-semibold text-black">New Selections Cost:</span>
                <span className="text-xl font-bold text-green-600">${getNewSelectionsCost()}M</span>
              </div>
              <div className="flex justify-between items-center">
                <span className="text-sm text-gray-600">Budget Limit:</span>
                <span className="text-lg font-bold text-red-600">${getEditBudgetLimit()}M</span>
              </div>
            </div>

            {/* Progress Bar */}
            <div className="space-y-2">
              <div className="flex justify-between text-sm">
                <span className="text-gray-600">Available Budget</span>
                <span className="text-gray-600">{getBudgetUsagePercentage()}%</span>
              </div>
              <div className="w-full bg-gray-200 rounded-full h-3">
                <div 
                  className="h-3 rounded-full transition-all duration-300"
                  style={{
                    backgroundColor: getEditProgressBarColor(),
                    width: `${Math.max(getBudgetUsagePercentage(), 1)}%`
                  }}
                ></div>
              </div>
            </div>

            {/* Budget Status */}
            <div className="text-center">
              {isEditBudgetExceeded() ? (
                <div className="text-red-800 font-semibold">⚠️ Budget Exceeded!</div>
              ) : (
                <div className="text-green-600 font-semibold">✅ Within Budget</div>
              )}
            </div>
          </div>
        </div>

        {/* Action Buttons */}
        <div className="mt-8 flex gap-4">
          <button
            onClick={handleClearChanges}
            className="flex-1 py-4 px-6 rounded-2xl font-bold text-lg transition-all duration-300 bg-gray-600 text-white hover:bg-gray-700 transform hover:scale-105"
          >
            Clear Changes
          </button>
          <button
            onClick={handleSubmitTeam}
            disabled={selectedDrivers.length !== MAX_DRIVERS || !selectedConstructor || isEditBudgetExceeded()}
            className={`flex-1 py-4 px-6 rounded-2xl font-bold text-lg transition-all duration-300 ${
              selectedDrivers.length !== MAX_DRIVERS || !selectedConstructor || isEditBudgetExceeded()
                ? 'bg-gray-500 text-gray-700 cursor-not-allowed'
                : 'bg-gradient-to-r from-green-700 text-white hover:from-green-800 hover:to-green-900 transform hover:scale-105'
            }`}
          >
            Update Team
          </button>
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
