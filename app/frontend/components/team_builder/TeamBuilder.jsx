import React, { useState, useEffect } from 'react'
import DriverCard from './DriverCard'
import ConstructorCard from './ConstructorCard'
import BudgetTracker from './BudgetTracker'
import TeamSummary from './TeamSummary'

const TeamBuilder = () => {
  const [drivers, setDrivers] = useState([])
  const [constructors, setConstructors] = useState([])
  const [selectedDrivers, setSelectedDrivers] = useState([])
  const [selectedConstructor, setSelectedConstructor] = useState(null)
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState(null)

  const BUDGET_LIMIT = 100 // $100M budget
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
      
      // Debug: Check if photo_url is present
      driversData.forEach(driver => {
        console.log(`Driver ${driver.name}: photo_url =`, driver.photo_url)
      })

      setDrivers(driversData)
      setConstructors(constructorsData)
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

  const isBudgetExceeded = () => getTotalCost() > BUDGET_LIMIT
  
  // Check if adding an item would exceed budget
  const wouldExceedBudget = (itemPrice) => {
    const currentTotal = getTotalCost()
    return (currentTotal + itemPrice) > BUDGET_LIMIT
  }
  
  // Show budget warning
  const showBudgetWarning = (itemName, itemPrice) => {
    const currentTotal = getTotalCost()
    const newTotal = currentTotal + itemPrice
    const overBudget = newTotal - BUDGET_LIMIT
    
    alert(`⚠️ Budget Exceeded!\n\nAdding ${itemName} ($${itemPrice}M) would make your team total $${newTotal}M, which is $${overBudget}M over your $${BUDGET_LIMIT}M budget.\n\nPlease remove some drivers or select a cheaper constructor to stay within budget.`)
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
      alert('Team exceeds budget limit')
      return
    }

    try {
      // Generate team name based on selected drivers
      const teamName = `${selectedDrivers[0].name} & ${selectedDrivers[1].name} Team`
      
      console.log('Creating team:', { teamName, drivers: selectedDrivers.map(d => d.id), constructor_id: selectedConstructor.id })
      
      const response = await fetch('/api/v1/teams', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': document.querySelector('[name="csrf-token"]').content
        },
        body: JSON.stringify({
          team: {
            name: teamName,
            drivers: selectedDrivers.map(d => d.id),
            constructor_id: selectedConstructor.id
          }
        })
      })
      
      console.log('Response status:', response.status)
      console.log('Response headers:', response.headers)

      if (response.ok) {
        const teamData = await response.json()
        alert(`Team "${teamName}" created successfully!\n\nTotal Cost: $${teamData.total_cost}M\nStatus: ${teamData.status}`)
        
        // Reset selections
        setSelectedDrivers([])
        setSelectedConstructor(null)
        
        // Optionally redirect to team view
        // window.location.href = '/my-team'
      } else {
        console.log('Error response status:', response.status)
        const responseText = await response.text()
        console.log('Response text:', responseText)
        
        try {
          const errorData = JSON.parse(responseText)
          alert(`Failed to create team: ${errorData.error || 'Unknown error'}`)
        } catch (parseError) {
          console.error('Failed to parse error response:', parseError)
          alert(`Failed to create team: Server returned HTML instead of JSON. Status: ${response.status}`)
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
      <div className="text-center mb-8">
        <h1 className="text-4xl font-bold text-f1-red-600 mb-2">F1 Team Builder</h1>
        <p className="text-gray-400 text-lg">Select your drivers and constructor within the budget</p>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-2 gap-8 w-full">
        {/* Drivers Section - Left Half */}
        <div className="w-full">
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

        {/* Constructor and Budget Section - Right Half */}
        <div className="space-y-6">
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
                  disabled={wouldExceedBudget(constructor.current_price)}
                />
              ))}
            </div>
          </div>

          {/* Budget Tracker */}
          <BudgetTracker
            totalCost={getTotalCost()}
            budgetLimit={BUDGET_LIMIT}
            isExceeded={isBudgetExceeded()}
          />

          {/* Team Summary */}
          <TeamSummary
            drivers={selectedDrivers}
            constructor={selectedConstructor}
            totalCost={getTotalCost()}
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
