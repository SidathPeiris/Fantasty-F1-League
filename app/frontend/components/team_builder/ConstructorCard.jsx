import React from 'react'

const ConstructorCard = ({ constructor, isSelected, onSelect, disabled, isCurrent, isSold }) => {
  const getRatingColor = (rating) => {
    if (rating >= 4.8) return '#eab308' // Gold for highest rated (4.8+)
    if (rating > 4.0) return '#15803d' // British racing green for above 4
    if (rating >= 2.0 && rating <= 4.0) return '#2563eb' // Blue for 2-4
    return '#dc2626' // Red for below 2
  }

  const getConstructorColor = (name) => {
    const constructorColors = {
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
    return constructorColors[name] || { border: '#9CA3AF', background: '#F3F4F6' }
  }

  return (
    <div
      className={`
        relative border-2 rounded-lg p-2 transition-all duration-200
        ${isSelected ? 'shadow-lg scale-105 cursor-pointer' : disabled ? 'opacity-50 cursor-not-allowed' : 'cursor-pointer hover:border-gray-400 hover:shadow-md'}
        ${isCurrent && !isSold ? 'border-green-500 cursor-not-allowed opacity-75' : isCurrent ? 'border-green-500' : ''}
        ${isSold ? 'border-red-600 bg-red-50 cursor-not-allowed opacity-75' : ''}
      `}
      style={{
        borderColor: isSelected ? getConstructorColor(constructor.name).border : 
                     isCurrent ? '#10B981' : 
                     isSold ? '#DC2626' : 
                     disabled ? '#9CA3AF' : '#D1D5DB',
        backgroundColor: isSelected ? `${getConstructorColor(constructor.name).background}20` : 
                          isCurrent ? '#F0FDF4' : 
                          isSold ? '#FEF2F2' : 
                          disabled ? '#F3F4F6' : '#F3F4F6'
      }}
      onClick={() => {
        console.log('ConstructorCard clicked:', constructor.name, 'isSold:', isSold, 'isCurrent:', isCurrent, 'disabled:', disabled)
        if (disabled || isSold || (isCurrent && !isSold)) {
          console.log('ConstructorCard click blocked - disabled, sold, or current team member')
          return
        }
        onSelect()
      }}
      title={isSold ? `${constructor.name} is sold and cannot be selected` : disabled ? `${constructor.name} would exceed budget` : isSelected ? `Click to deselect ${constructor.name}` : `Click to select ${constructor.name}`}
    >
      {/* Selection Indicator */}
      {isSelected && (
        <div className="absolute -top-1 -right-1 bg-f1-red-500 text-white rounded-full w-4 h-4 flex items-center justify-center text-xs font-bold">
          ✓
        </div>
      )}
      
      {/* Current Team Indicator */}
      {isCurrent && !isSelected && (
        <div className="absolute -top-1 -right-1 bg-green-500 text-white rounded-full w-4 h-4 flex items-center justify-center text-xs font-bold">
          🏎️
        </div>
      )}
      
      {/* Sold Indicator */}
      {isSold && (
        <div className="absolute -top-1 -right-1 bg-red-600 text-white rounded-full w-4 h-4 flex items-center justify-center text-xs font-bold">
          💰
        </div>
      )}
      
      {/* Budget Exceeded Indicator */}
      {disabled && !isSelected && !isCurrent && !isSold && (
        <div className="absolute -top-1 -right-1 bg-gray-500 text-white rounded-full w-4 h-4 flex items-center justify-center text-xs font-bold">
          $
        </div>
      )}
      


      {/* Constructor Car Image */}
      <div className="w-16 h-16 bg-gray-200 rounded-full mx-auto mb-2 flex items-center justify-center overflow-hidden border-2 border-red-500">
        {constructor.logo_url ? (
          <img 
            src={constructor.logo_url} 
            alt={constructor.name}
            className="w-full h-full rounded-full object-contain"
            onError={(e) => {
              e.target.style.display = 'none'
              e.target.nextSibling.style.display = 'flex'
            }}
            onLoad={(e) => {
              e.target.nextSibling.style.display = 'none'
            }}
          />
        ) : null}
        <div className="text-xs font-bold text-gray-500" style={{ display: constructor.logo_url ? 'none' : 'flex' }}>
          {constructor.name.split(' ').map(n => n[0]).join('')}
        </div>
      </div>

      {/* Constructor Info */}
      <div className="text-center">
        <h3 className="font-bold text-xs mb-1" style={{ color: getConstructorColor(constructor.name).border }}>
          {constructor.name}
        </h3>
        
        {/* Rating and Price in same line */}
        <div className="flex items-center justify-center space-x-2 text-xs">
          <span 
            className="font-bold"
            style={{ color: getRatingColor(constructor.current_rating) }}
          >
            ★ {constructor.current_rating}
          </span>
          <span className="font-bold text-green-600">
            ${constructor.current_price}M
          </span>
        </div>
      </div>

      {/* Hover Effect */}
      {!disabled && (
        <div className="absolute inset-0 bg-f1-red-500 bg-opacity-0 hover:bg-opacity-10 transition-all duration-200 rounded-lg" />
      )}
    </div>
  )
}

export default ConstructorCard
