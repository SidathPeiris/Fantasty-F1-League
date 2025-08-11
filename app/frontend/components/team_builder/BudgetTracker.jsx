import React from 'react'

const BudgetTracker = ({ totalCost, budgetLimit, isExceeded }) => {
  const percentage = (totalCost / budgetLimit) * 100
  const getProgressColor = () => {
    if (isExceeded) return 'bg-red-500'
    if (percentage >= 80) return 'bg-yellow-500'
    return 'bg-green-500'
  }

  const getTextColor = () => {
    if (isExceeded) return 'text-red-600'
    if (percentage >= 80) return 'text-yellow-600'
    return 'text-green-600'
  }

  return (
    <div className="bg-white rounded-lg shadow-lg p-6">
      <h2 className="text-xl font-bold text-gray-800 mb-4">Budget Tracker</h2>
      
      {/* Budget Display */}
      <div className="mb-4">
        <div className="flex justify-between items-center mb-2">
          <span className="text-sm text-gray-600">Total Cost:</span>
          <span className={`font-bold text-lg ${getTextColor()}`}>
            ${totalCost}M
          </span>
        </div>
        <div className="flex justify-between items-center">
          <span className="text-sm text-gray-600">Budget Limit:</span>
          <span className="font-bold text-lg text-gray-800">
            ${budgetLimit}M
          </span>
        </div>
      </div>

      {/* Progress Bar */}
      <div className="mb-4">
        <div className="w-full bg-gray-200 rounded-full h-3">
          <div
            className={`h-3 rounded-full transition-all duration-300 ${getProgressColor()}`}
            style={{ width: `${Math.min(percentage, 100)}%` }}
          />
        </div>
        <div className="flex justify-between text-xs text-gray-500 mt-1">
          <span>0%</span>
          <span>{Math.round(percentage)}%</span>
          <span>100%</span>
        </div>
      </div>

      {/* Remaining Budget */}
      <div className="text-center">
        <span className="text-sm text-gray-600">Remaining:</span>
        <div className={`text-xl font-bold ${getTextColor()}`}>
          ${Math.max(0, budgetLimit - totalCost)}M
        </div>
      </div>

      {/* Warning Messages */}
      {isExceeded && (
        <div className="mt-3 p-3 bg-red-100 border border-red-300 rounded-lg">
          <div className="text-red-800 text-sm font-medium">
            ⚠️ Budget exceeded! Please adjust your selections.
          </div>
        </div>
      )}
      
      {percentage >= 80 && !isExceeded && (
        <div className="mt-3 p-3 bg-yellow-100 border border-yellow-300 rounded-lg">
          <div className="text-yellow-800 text-sm font-medium">
            ⚠️ Budget nearly full! Consider your remaining options.
          </div>
        </div>
      )}
    </div>
  )
}

export default BudgetTracker
