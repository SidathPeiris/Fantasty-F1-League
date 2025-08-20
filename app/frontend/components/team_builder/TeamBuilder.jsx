import React, { useState, useEffect } from 'react'
import DriverCard from './DriverCard'
import ConstructorCard from './ConstructorCard'

import TeamSummary from './TeamSummary'

const TeamBuilder = () => {
  const [drivers, setDrivers] = useState([])
  const [constructors, setConstructors] = useState([])
  const [selectedDrivers, setSelectedDrivers] = useState([])
  const [selectedConstructor, setSelectedConstructor] = useState(null)
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState(null)


  const MAX_DRIVERS = 2 // Changed from 5 to 2
  const MAX_DRIVERS_PER_TEAM = 2

  useEffect(() => {
    fetchData()
  }, [])



  const fetchData = async () => {
    try {
      setLoading(true)
      setError(null)
      
      console.log('Fetching drivers and constructors...')
      
      const [driversResponse, constructorsResponse] = await Promise.all([
        fetch('/api/v1/drivers'),
        fetch('/api/v1/constructors')
      ])
      
      console.log('Drivers response status:', driversResponse.status)
      console.log('Constructors response status:', constructorsResponse.status)
      
      if (!driversResponse.ok) {
        throw new Error(`Drivers API failed: ${driversResponse.status} ${driversResponse.statusText}`)
      }
      
      if (!constructorsResponse.ok) {
        throw new Error(`Constructors API failed: ${constructorsResponse.status} ${constructorsResponse.statusText}`)
      }

      const driversData = await driversResponse.json()
      const constructorsData = await constructorsResponse.json()

      console.log('Drivers data:', driversData)
      console.log('Constructors data:', constructorsData)
      
      // Sort drivers and constructors by price (highest first)
      const sortedDrivers = driversData.sort((a, b) => b.current_price - a.current_price)
      const sortedConstructors = constructorsData.sort((a, b) => b.current_price - a.current_price)
      
      console.log('Sorted drivers by price (highest first):', sortedDrivers.map(d => `${d.name}: $${d.current_price}M`))
      console.log('Sorted constructors by price (highest first):', sortedConstructors.map(c => `${c.name}: $${c.current_price}M`))
      
      // Debug: Check if photo_url is present
      sortedDrivers.forEach(driver => {
        console.log(`Driver ${driver.name}: photo_url =`, driver.photo_url)
      })

      setDrivers(sortedDrivers)
      setConstructors(sortedConstructors)
    } catch (err) {
      console.error('Error fetching data:', err)
      setError(err.message)
    } finally {
      setLoading(false)
    }
  }

  const handleDriverSelect = (driver) => {
    if (selectedDrivers.find(d => d.id === driver.id)) {
      // Deselecting a driver - always allowed
      setSelectedDrivers(selectedDrivers.filter(d => d.id !== driver.id))
    } else {
      // Selecting a new driver - check constraints
      if (selectedDrivers.length >= MAX_DRIVERS) {
        alert(`Maximum ${MAX_DRIVERS} drivers allowed`)
        return
      }
      
      const teamCount = selectedDrivers.filter(d => d.team === driver.team).length
      if (teamCount >= MAX_DRIVERS_PER_TEAM) {
        alert(`Maximum ${MAX_DRIVERS_PER_TEAM} drivers per team allowed`)
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
    // Toggle constructor selection - if already selected, deselect it
    if (selectedConstructor && selectedConstructor.id === constructor.id) {
      // Deselecting constructor - always allowed
      setSelectedConstructor(null)
    } else {
      // Selecting a new constructor - check budget constraint
      if (wouldExceedBudget(constructor.current_price)) {
        showBudgetWarning(constructor.name, constructor.current_price)
        return
      }
      
      setSelectedConstructor(constructor)
    }
  }



  const getTotalCost = () => {
    const driversCost = selectedDrivers.reduce((sum, driver) => sum + driver.current_price, 0)
    const constructorCost = selectedConstructor ? selectedConstructor.current_price : 0
    return driversCost + constructorCost
  }

  const getBudgetLimit = () => {
    return 100
  }

  const getRemainingBudget = () => {
    return getBudgetLimit() - getTotalCost()
  }

  const getRemainingBudgetColor = () => {
    const remaining = getRemainingBudget()
    if (remaining >= 50) return '#16a34a'      // $50M+ = Green
    if (remaining >= 25) return '#ca8a04'      // $25M-$49M = Yellow  
    if (remaining >= 10) return '#ea580c'      // $10M-$24M = Orange
    return '#dc2626'                           // $0M-$9M = Red
  }

  const getProgressBarColor = () => {
    const remaining = getRemainingBudget()
    if (remaining >= 50) return '#16a34a'      // $50M+ = Green
    if (remaining >= 25) return '#ca8a04'      // $25M-$49M = Yellow  
    if (remaining >= 10) return '#ea580c'      // $10M-$24M = Orange
    return '#dc2626'                           // $0M-$9M = Red
  }

  const isBudgetExceeded = () => {
    return getTotalCost() > getBudgetLimit()
  }

  const wouldExceedBudget = (additionalCost) => {
    return (getTotalCost() + additionalCost) > getBudgetLimit()
  }

  const showBudgetWarning = (itemName, cost) => {
    const currentTotal = getTotalCost()
    const newTotal = currentTotal + cost
    const overBudget = newTotal - getBudgetLimit()
    
    alert(`⚠️ Budget Exceeded!\n\nAdding ${itemName} ($${cost}M) would make your team total $${newTotal}M, which is $${overBudget}M over your $${getBudgetLimit()}M budget.\n\nPlease remove some drivers or select a cheaper constructor to stay within budget.`)
  }

  const handleClearAll = () => {
    setSelectedDrivers([])
    setSelectedConstructor(null)
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
      alert('Team exceeds budget limit. Please adjust your selections.')
      return
    }

    try {
      // Get CSRF token from meta tag
      const csrfToken = document.querySelector('meta[name="csrf-token"]')?.getAttribute('content')
      if (!csrfToken) {
        alert('CSRF token not found. Please refresh the page and try again.')
        return
      }
      
      // Use the working /create-team endpoint with proper data format and CSRF token
      const data = new URLSearchParams()
      data.append('drivers', selectedDrivers.map(d => d.id).join(','))
      data.append('constructor', selectedConstructor.id)
      
      console.log('Creating team via /create-team:', { 
        drivers: selectedDrivers.map(d => d.id), 
        constructor: selectedConstructor.id 
      })
      
      const response = await fetch('/create-team', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'X-Requested-With': 'XMLHttpRequest',
          'X-CSRF-Token': csrfToken
        },
        body: data
      })
      
      console.log('Response status:', response.status)
      console.log('Response headers:', response.headers)

      if (response.ok) {
        const result = await response.json()
        alert(`Team created successfully!\n\nStatus: Active`)
        
        // Reset selections
        setSelectedDrivers([])
        setSelectedConstructor(null)
        
        // Redirect to my-team page
        window.location.href = '/my-team'
      } else {
        console.log('Error response status:', response.status)
        const responseText = await response.text()
        console.log('Response text:', responseText)
        
        try {
          const errorData = JSON.parse(responseText)
          alert(`Failed to create team: ${errorData.message || 'Unknown error'}`)
        } catch (parseError) {
          console.error('Failed to parse error response:', parseError)
          alert(`Failed to create team: Server returned HTML instead of JSON. Status: ${response.status}\n\nResponse: ${responseText.substring(0, 200)}...`)
        }
      }
    } catch (err) {
      alert('Error creating team: ' + err.message)
    }
  }

  if (loading) {
    return (
      <div className="flex justify-center items-center min-h-64">
        <div className="text-f1-red-600 text-xl font-bold">Loading team builder...</div>
      </div>
    )
  }

  if (error) {
    return (
      <div className="text-red-600 text-center p-4">
        <div className="text-lg font-bold mb-2">Error loading team builder</div>
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

  return (
    <div className="w-full p-6">
    
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-8 w-full">
        {/* Left Column - Team Rules and Drivers */}
        <div className="w-full space-y-6">
          {/* Team Rules Box */}
          <div className="bg-gradient-to-br from-blue-800 to-blue-900 p-6 rounded-2xl border border-blue-600">
            <div className="flex gap-8">
              {/* Left Side - Team Rules */}
              <div className="flex-1">
                <h2 className="text-2xl font-bold text-white mb-4">📋 Team Rules</h2>
                <div className="grid grid-cols-1 gap-6 text-gray-300">
                  <div className="flex items-center space-x-2">
                    <span className="text-green-400">✓</span>
                    <span>Select exactly 2 drivers</span>
                  </div>
                  <div className="flex items-center space-x-2">
                    <span className="text-green-400">✓</span>
                    <span>Select exactly 1 constructor</span>
                  </div>
                  <div className="flex items-center space-x-2">
                    <span className="text-green-400">✓</span>
                    <span>Stay within $100M budget</span>
                  </div>
                  <div className="flex items-center space-x-2">
                    <span className="text-green-400">✓</span>
                    <span>Drivers sorted by price (highest first)</span>
                  </div>
                </div>
              </div>

              {/* Right Side - Empty for now */}
              <div className="flex-1">
                <h2 className="text-2xl font-bold text-white mb-4">🏆 Season Rules</h2>
                <div className="grid grid-cols-1 gap-4 text-gray-300">
                  <div className="flex items-center space-x-2">
                    <span className="text-yellow-400">★</span>
                    <span>Driver ratings update after each race</span>
                  </div>
                  <div className="flex items-center space-x-2">
                    <span className="text-yellow-400">★</span>
                    <span>Prices change based on performance</span>
                  </div>
                  <div className="flex items-center space-x-2">
                    <span className="text-yellow-400">★</span>
                    <span>Championship points determine rankings</span>
                  </div>
                </div>
              </div>
            </div>
          </div>

          {/* Drivers Section */}
          <div className="bg-white rounded-lg shadow-lg p-6">
            <h2 className="text-2xl font-bold text-gray-800 mb-4">Select Drivers ({selectedDrivers.length}/{MAX_DRIVERS})</h2>
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
              {drivers.map(driver => (
                <DriverCard
                  key={driver.id}
                  driver={driver}
                  isSelected={selectedDrivers.some(d => d.id === driver.id)}
                  onSelect={() => handleDriverSelect(driver)}
                  disabled={selectedDrivers.length >= MAX_DRIVERS && !selectedDrivers.some(d => d.id === driver.id)}
                />
              ))}
            </div>
          </div>
        </div>

        {/* Right Column - Season Rules, Constructor, Budget, and Team Summary */}
        <div className="space-y-6">
          {/* Blue Box Above Constructors */}
          <div className="bg-gradient-to-br from-blue-800 to-blue-900 p-6 rounded-2xl border border-blue-600">
            <h2 className="text-2xl font-bold text-white mb-4 text-center">📋 Additional Information</h2>
            <div className="text-gray-300 text-center">
              <p>BE CAREFUL when making your selections of drivers and constructor, in this Fantasy League you don't get to switch drivers and constructors between races, the team you make at the start of the season will be locked and will be the one you'll have till the mid-season break where you'll get the opportunity to "SELL" drivers or constructors at their current market value and use your remaining budget to complete your team. CHOOSE WISELY. Once the mid-season break is over your team will be locked again till the end of the season.</p>
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
                  onSelect={() => handleConstructorSelect(constructor)}

                />
              ))}
            </div>
          </div>

          {/* Budget Tracker */}
          <div className="bg-white rounded-lg shadow-lg p-6 border-2 border-purple-500">
            <h2 className="text-xl font-bold text-black mb-4">Budget Tracker</h2>
            
            {/* Budget Display */}
            <div className="mb-4">
              <div className="flex justify-between items-center mb-2">
                <span className="text-sm text-purple-100">Total Cost:</span>
                <span className="font-bold text-lg text-green-600">
                  ${getTotalCost()}M
                </span>
              </div>
              <div className="flex justify-between items-center">
                <span className="text-sm text-purple-100">Budget Limit:</span>
                <span className="font-bold text-lg text-red-600">
                  ${getBudgetLimit()}M
                </span>
              </div>
            </div>

            {/* Progress Bar */}
            <div className="mb-4">
              <div className="w-full bg-gray-200 rounded-full h-3">
                <div
                  className="h-3 rounded-full transition-all duration-300"
                  style={{ 
                    width: `${Math.max((getTotalCost() / getBudgetLimit()) * 100, 1)}%`,
                    backgroundColor: getProgressBarColor()
                  }}
                />
              </div>
              <div className="flex justify-between text-xs text-gray-600 mt-1">
                <span>0%</span>
                <span>{Math.round((getTotalCost() / getBudgetLimit()) * 100)}%</span>
                <span>100%</span>
              </div>
            </div>

                          {/* Remaining Budget */}
              <div className="text-center">
                <span className="text-sm text-gray-600">Remaining:</span>
                <span 
                  key={`remaining-${getRemainingBudget()}`}
                  className="text-xl font-bold"
                  style={{ 
                    color: getRemainingBudgetColor()
                  }}
                >
                  ${getRemainingBudget()}M
                </span>
              </div>
          </div>

          {/* Team Summary */}
          <TeamSummary
            drivers={selectedDrivers}
            constructor={selectedConstructor}

            onSubmit={handleSubmitTeam}
            onClearAll={handleClearAll}
            isValid={selectedDrivers.length === MAX_DRIVERS && selectedConstructor && !isBudgetExceeded()}
          />
        </div>
      </div>
    </div>
  )
}

export default TeamBuilder
