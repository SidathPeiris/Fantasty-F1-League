import React from 'react'

const DriverCard = ({ driver, isSelected, onSelect, disabled, isCurrent, isSold }) => {
  // Debug logging
  console.log('DriverCard render for', driver.name, 'photo_url:', driver.photo_url)
  const getRatingColor = (rating) => {
    if (rating >= 4.8) return '#eab308' // Gold for highest rated (4.8+)
    if (rating > 4.0) return '#15803d' // British racing green for above 4
    if (rating >= 2.0 && rating <= 4.0) return '#2563eb' // Blue for 2-4
    return '#dc2626' // Red for below 2
  }

  const getTeamColor = (team) => {
    const teamColors = {
      'Mercedes': { border: '#00D7B6', background: '#00D7B6' },
      'Red Bull Racing': { border: '#4781D7', background: '#4781D7' },
      'Ferrari': { border: '#ED1131', background: '#ED1131' },
      'McLaren': { border: '#F47600', background: '#F47600' },
      'Alpine': { border: '#00A1E8', background: '#00A1E8' },
      'Racing Bulls': { border: '#6C98FF', background: '#6C98FF' },
      'Aston Martin': { border: '#229971', background: '#229971' },
      'Williams': { border: '#1868DB', background: '#1868DB' },
      'Kick Sauber': { border: '#01C00E', background: '#01C00E' },
      'Haas': { border: '#9C9FA2', background: '#9C9FA2' }
    }
    return teamColors[team] || { border: '#9CA3AF', background: '#F3F4F6' }
  }

  return (
    <div
      className={`
        relative border-2 rounded-lg p-3 cursor-pointer transition-all duration-200
        ${isSelected ? 'shadow-lg scale-105' : 'hover:border-gray-400 hover:shadow-md'}
        ${disabled ? 'opacity-50 cursor-not-allowed' : ''}
        ${isCurrent ? 'border-green-500' : ''}
        ${isSold ? 'border-red-600 bg-red-50' : ''}
      `}
      style={{
        borderColor: isSelected ? getTeamColor(driver.team).border : 
                     isCurrent ? '#10B981' : 
                     isSold ? '#DC2626' : '#D1D5DB',
        backgroundColor: isSelected ? `${getTeamColor(driver.team).background}20` : 
                          isCurrent ? '#F0FDF4' : 
                          isSold ? '#FEF2F2' : '#F3F4F6'
      }}
      onClick={() => !disabled && onSelect()}
    >
      {/* Selection Indicator */}
      {isSelected && (
        <div className="absolute -top-2 -right-2 bg-f1-red-500 text-white rounded-full w-5 h-5 flex items-center justify-center text-xs font-bold">
          ✓
        </div>
      )}
      
      {/* Current Team Indicator */}
      {isCurrent && !isSelected && (
        <div className="absolute -top-2 -right-2 bg-green-500 text-white rounded-full w-5 h-5 flex items-center justify-center text-xs font-bold">
          🏎️
        </div>
      )}
      
      {/* Sold Indicator */}
      {isSold && (
        <div className="absolute -top-2 -right-2 bg-red-600 text-white rounded-full w-5 h-5 flex items-center justify-center text-xs font-bold">
          💰
        </div>
      )}

      {/* Driver Photo */}
      <div className="w-12 h-12 bg-gray-200 rounded-full mx-auto mb-2 flex items-center justify-center overflow-hidden border-2 border-red-500">
        {driver.photo_url ? (
          <img 
            src={driver.photo_url} 
            alt={driver.name}
            className="w-12 h-12 rounded-full object-cover"
            onError={(e) => {
              console.log('Image failed to load for', driver.name, ':', driver.photo_url)
              e.target.style.display = 'none'
              e.target.nextSibling.style.display = 'flex'
            }}
            onLoad={(e) => {
              console.log('Image loaded successfully for', driver.name)
              e.target.nextSibling.style.display = 'none'
            }}
          />
        ) : null}
        <div className="text-lg font-bold text-gray-500" style={{ display: driver.photo_url ? 'none' : 'flex' }}>
          {driver.name.split(' ').map(n => n[0]).join('')}
        </div>
      </div>

      {/* Driver Info */}
      <div className="text-center">
        <h3 className="font-bold text-gray-800 text-xs mb-1">{driver.name}</h3>
        <p className="text-xs mb-1" style={{ color: getTeamColor(driver.team).border }}>
          {driver.team}
        </p>
        
        {/* Rating */}
        <div className="flex items-center justify-center mb-1">
          <span className="text-xs font-bold" style={{ color: getRatingColor(driver.current_rating) }}>
            ★ {driver.current_rating}
          </span>
        </div>

        {/* Price */}
        <div className="text-xs font-bold text-green-600">
          ${driver.current_price}M
        </div>
      </div>

      {/* Hover Effect */}
      {!disabled && (
        <div className="absolute inset-0 bg-f1-red-500 bg-opacity-0 hover:bg-opacity-10 transition-all duration-200 rounded-lg" />
      )}
    </div>
  )
}

export default DriverCard
