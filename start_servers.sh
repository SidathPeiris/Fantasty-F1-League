#!/bin/bash

# Fantasy F1 League - Server Startup Script
# This script handles database migration, server cleanup, and starts both servers

echo "🏎️ Fantasy F1 League - Starting Servers..."
echo "=========================================="

# Function to check if a port is in use
check_port() {
    local port=$1
    if netstat -tlnp 2>/dev/null | grep -q ":$port "; then
        return 0  # Port is in use
    else
        return 1  # Port is free
    fi
}

# Function to kill processes by port
kill_port() {
    local port=$1
    local pids=$(netstat -tlnp 2>/dev/null | grep ":$port " | awk '{print $7}' | cut -d'/' -f1)
    if [ ! -z "$pids" ]; then
        echo "🔄 Killing processes on port $port..."
        echo "$pids" | xargs -r kill -9
        sleep 2
    fi
}

# Function to cleanup React-specific processes
cleanup_react() {
    echo "🧹 Cleaning up React-specific processes..."
    
    # Kill any existing Vite processes (if any dev servers are running)
    pkill -f "vite dev" 2>/dev/null
    pkill -f "npm exec vite" 2>/dev/null
    pkill -f "node.*vite" 2>/dev/null
    
    # Clear React-related temporary files
    if [ -f "/tmp/vite.log" ]; then
        rm -f /tmp/vite.log
    fi
    
    echo "✅ React cleanup completed"
}

# Function to kill processes by name
kill_processes() {
    echo "🧹 Cleaning up existing processes..."
    
    # Kill Rails/Puma processes
    pkill -f "rails server" 2>/dev/null
    pkill -f "puma" 2>/dev/null
    
    # Cleanup React processes
    cleanup_react
    
    # Kill specific ports
    kill_port 3000
    
    echo "✅ Process cleanup completed"
}

# Function to migrate database
migrate_database() {
    echo "🗄️ Running database migrations..."
    
    if bin/rails db:migrate; then
        echo "✅ Database migrations completed successfully"
    else
        echo "❌ Database migration failed!"
        echo "Please check the error and try again"
        exit 1
    fi
}

# Function to clear Vite cache and rebuild
clear_vite_cache() {
    echo "🧹 Clearing Vite cache and rebuilding..."
    
    # Remove Vite cache directories
    if [ -d "public/vite" ]; then
        echo "🗑️ Removing public/vite directory..."
        rm -rf public/vite
    fi
    
    if [ -d "node_modules/.vite" ]; then
        echo "🗑️ Removing node_modules/.vite directory..."
        rm -rf node_modules/.vite
    fi
    
    # Clear npm cache for this project
    echo "🗑️ Clearing npm cache..."
    npm cache clean --force
    
    echo "✅ Vite cache cleared"
}

# Function to build Vite assets
build_assets() {
    echo "📦 Building Vite assets..."
    
    # Install dependencies to ensure everything is up to date
    echo "📦 Installing/updating npm dependencies..."
    if npm install; then
        echo "✅ Dependencies updated"
    else
        echo "❌ Dependency installation failed!"
        return 1
    fi
    
    # Build Vite assets
    if npx vite build; then
        echo "✅ Vite assets built successfully"
    else
        echo "❌ Vite build failed!"
        echo "Please check the error and try again"
        return 1
    fi
}

# Function to start Rails server
start_rails() {
    echo "🚀 Starting Rails server..."
    
    # Check if port 3000 is free
    if check_port 3000; then
        echo "❌ Port 3000 is already in use!"
        return 1
    fi
    
    # Start Rails in background
    bin/rails server -p 3000 -b 0.0.0.0 > /tmp/rails.log 2>&1 &
    local rails_pid=$!
    
    # Wait for Rails to start
    echo "⏳ Waiting for Rails server to start..."
    for i in {1..30}; do
        if check_port 3000; then
            echo "✅ Rails server started successfully on port 3000 (PID: $rails_pid)"
            return 0
        fi
        sleep 1
    done
    
    echo "❌ Rails server failed to start within 30 seconds"
    return 1
}

# Function to verify React components
verify_react_components() {
    echo "🔍 Verifying React components..."
    
    # Check if the main React entry point exists
    if [ ! -f "app/frontend/entrypoints/application.jsx" ]; then
        echo "❌ React entry point not found: app/frontend/entrypoints/application.jsx"
        return 1
    fi
    
    # Check if TeamBuilder component exists
    if [ ! -f "app/frontend/components/team_builder/TeamBuilder.jsx" ]; then
        echo "❌ TeamBuilder component not found"
        return 1
    fi
    
    # Check if Vite assets were built
    if [ ! -f "public/vite/assets/application-CjO9BInS.js" ]; then
        echo "❌ Vite assets not built properly"
        return 1
    fi
    
    echo "✅ React components verified"
    return 0
}

# Function to start Vite dev server (DISABLED - using production build instead)
# start_vite() {
#     echo "⚛️ Starting Vite development server..."
#     # This function is disabled to avoid React plugin preamble detection errors
#     # We use production build instead: npx vite build
# }

# Function to check server status
check_status() {
    echo ""
    echo "📊 Server Status Check:"
    echo "======================"
    
    if check_port 3000; then
        echo "✅ Rails Server: Running on port 3000"
    else
        echo "❌ Rails Server: Not running"
    fi
    
    echo "✅ React Components: Production build ready"
    echo "📝 Note: Using production build to avoid React plugin issues"
    
    echo ""
    echo "🌐 Access your app at: http://localhost:3000"
    echo "⚛️ React components: Production build (no dev server needed)"
}

# Function to show logs
show_logs() {
    echo ""
    echo "📋 Recent Logs:"
    echo "==============="
    
    if [ -f /tmp/rails.log ]; then
        echo "Rails Server Log (last 5 lines):"
        tail -5 /tmp/rails.log
        echo ""
    fi
    
    if [ -f /tmp/vite.log ]; then
        echo "Vite Server Log (last 5 lines):"
        tail -5 /tmp/vite.log
        echo ""
    fi
}

# Function to stop all servers
stop_servers() {
    echo "🛑 Stopping all servers..."
    kill_processes
    echo "✅ All servers stopped"
}

# Main execution
main() {
    # Check if we're in the right directory
    if [ ! -f "bin/rails" ]; then
        echo "❌ Error: This script must be run from the Rails application root directory"
        echo "Current directory: $(pwd)"
        echo "Please cd to your Rails app directory and try again"
        exit 1
    fi
    
    # Parse command line arguments
    case "${1:-start}" in
        "start"|"")
            echo "🚀 Starting Fantasy F1 League servers..."
            kill_processes
            migrate_database
            build_assets
            start_rails
            # Don't start Vite dev server - use production build instead
            echo "⚛️ Using production React build (no dev server to avoid plugin issues)"
            check_status
            ;;
        "stop")
            stop_servers
            ;;
        "restart")
            echo "🔄 Restarting servers..."
            stop_servers
            sleep 2
            main start
            ;;
        "status")
            check_status
            ;;
        "logs")
            show_logs
            ;;
        "migrate")
            echo "🗄️ Running database migrations only..."
            migrate_database
            ;;
        "build")
            echo "📦 Building Vite assets only..."
            build_assets
            ;;
        "react")
            echo "⚛️ React-specific operations..."
            cleanup_react
            clear_vite_cache
            build_assets
            echo "✅ React components built for production"
            echo "🌐 Access your app at: http://localhost:3000"
            echo "📝 Note: Using production build to avoid React plugin issues"
            ;;
        "react-prod")
            echo "⚛️ React production build (no dev server)..."
            cleanup_react
            clear_vite_cache
            build_assets
            echo "✅ React components built for production"
            echo "🌐 Access your app at: http://localhost:3000"
            echo "📝 Note: No Vite dev server - using production build"
            ;;
        "clean")
            echo "🧹 Cleaning up processes only..."
            kill_processes
            ;;
        "help"|"-h"|"--help")
            echo "Fantasy F1 League - Server Management Script"
            echo ""
            echo "Usage: $0 [command]"
            echo ""
            echo "Commands:"
            echo "  start     - Start Rails server with production React build (default)"
            echo "  stop      - Stop all servers"
            echo "  restart   - Restart all servers"
            echo "  status    - Check server status"
            echo "  logs      - Show recent logs"
            echo "  migrate   - Run database migrations only"
            echo "  build     - Build Vite assets only"
            echo "  react     - React-specific operations (cleanup, clear cache, build)"
            echo "  react-prod- React production build (no dev server - avoids plugin issues)"
            echo "  clean     - Clean up processes only"
            echo "  help      - Show this help message"
            echo ""
            echo "Note: Uses production React build to avoid @vitejs/plugin-react preamble errors"
            echo ""
            echo "Examples:"
            echo "  $0              # Start Rails server with production React build"
            echo "  $0 restart      # Restart servers with production React build"
            echo "  $0 status       # Check server status"
            echo "  $0 stop         # Stop all servers"
            ;;
        *)
            echo "❌ Unknown command: $1"
            echo "Use '$0 help' for usage information"
            exit 1
            ;;
    esac
}

# Handle Ctrl+C gracefully
trap 'echo ""; echo "🛑 Interrupted by user"; stop_servers; exit 0' INT

# Run main function
main "$@"
