#!/bin/bash

# 🏁 Fantasy F1 League - New Environment Setup Script
# This script sets up everything you need after cloning the repository

echo "🏎️  Fantasy F1 League - Environment Setup"
echo "=========================================="

# Check if we're in the right directory
if [ ! -f "Gemfile" ]; then
    echo "❌ Error: Please run this script from the project root directory"
    exit 1
fi

echo "📦 Installing Ruby dependencies..."
bundle install

echo "📦 Installing Node.js dependencies..."
npm install

echo "🗄️  Setting up database..."
bin/rails db:create
bin/rails db:migrate

echo "🌱 Seeding database with all data..."
bin/rails db:seed:all

echo "✅ Setup complete!"
echo ""
echo "🚀 You can now start the server with:"
echo "   bin/rails server"
echo ""
echo "📊 Your database now contains:"
echo "   - All drivers and constructors"
echo "   - Complete 2025 race schedule"
echo "   - Sample race results for all races"
echo "   - Qualifying results"
echo "   - Constructor results"
echo ""
echo "🌐 Visit http://localhost:3000 to access your Fantasy F1 League!"
echo ""
echo "📚 For more information, see SEEDING_GUIDE.md"
