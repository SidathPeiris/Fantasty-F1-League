# 🏎️ Fantasy F1 League

[![Ruby](https://img.shields.io/badge/Ruby-3.4.4+-red.svg)](https://ruby-lang.org)
[![Rails](https://img.shields.io/badge/Rails-8.0.2+-red.svg)](https://rubyonrails.org)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Status](https://img.shields.io/badge/Status-Development-blue.svg)](https://github.com/SidathPeiris/Fantasty-F1-League)

> A modern, full-stack Fantasy Formula 1 League application built with **Ruby on Rails 8**, featuring real-time updates, user authentication, and comprehensive F1 data management.

## 🚀 Quick Start

```bash
# Clone the repository
git clone https://github.com/SidathPeiris/Fantasty-F1-League.git
cd Fantasty-F1-League

# Install dependencies
bundle install

# Set up database
rails db:create
rails db:migrate

# Start the development server
rails s
```

Visit **http://localhost:3000** to see your Fantasy F1 League in action! 🏁

## ✨ Features

### 🎯 **Current Features**
- **⚡ Rails 8.0.2** - Latest Rails framework with modern features
- **🔥 Hotwire/Turbo** - Real-time updates and smooth interactions
- **🎮 Stimulus** - JavaScript interactions and dynamic UI
- **💾 SQLite3 Database** - Simple and reliable data storage
- **📦 Importmap** - Modern JavaScript package management
- **🚀 Puma Server** - Fast development web server
- **🎨 Tailwind CSS** - Modern, responsive design system
- **🔐 User Authentication** - Complete signup/login system with bcrypt
- **🏠 Dashboard** - Comprehensive user dashboard with F1-themed design
- **📱 Responsive Design** - Works perfectly on all devices

### 🔐 **Authentication System**
- **👤 User Registration** - Sign up with full name, email, username, and password
- **🔑 Secure Login** - Login with email or username and password
- **🔒 Password Security** - Bcrypt hashing for secure password storage
- **💾 Session Management** - Persistent user sessions
- **🚪 Logout Functionality** - Secure logout with redirect to landing page
- **✅ Form Validation** - Comprehensive validation for all user inputs
- **🎨 Beautiful UI** - F1-themed design for all authentication pages

### 🏠 **Dashboard Features**
- **🏎️ F1 Command Center** - Comprehensive dashboard with all app functions
- **👤 My Team** - Manage fantasy drivers and constructors
- **⏰ Live Races** - Watch real-time race updates and scoring
- **🏆 Leaderboard** - See rankings and personal stats
- **👤 Driver Database** - Browse all F1 drivers and stats
- **🏭 Constructor Database** - Explore F1 teams and performance
- **⚙️ Settings** - Account management and preferences
- **📊 Quick Stats** - Current rank, total points, races completed, podium finishes
- **📝 Recent Activity** - Track points earned, driver transfers, ranking changes

### 🏎️ **F1 Data Management System** ✅
- **📊 Complete F1 Database** - All 20 drivers and 10 constructors with real data
- **💰 Dynamic Pricing System** - Driver and constructor costs based on performance
- **📈 Rating Calculations** - Sophisticated algorithm considering performance, championship position, and history
- **🏆 Championship Integration** - Real-time standings from RacingNews365
- **🔄 Automatic Updates** - Scheduled race result imports and rating recalculations
- **⚙️ Admin Panel** - Comprehensive admin interface for data management
- **📊 Rating Summary** - Detailed breakdown of all driver and constructor ratings
- **🧮 Driver Calculations** - In-depth analysis of rating and price calculations
- **🎯 Price Organization** - All pages sorted by cost for strategic team building

### 🎮 **Upcoming Fantasy League Features**

#### **Core Features**
- **⚔️ Fantasy Team Creation** - Users build their fantasy teams
- **🏁 Race Results Tracking** - Real-time race outcomes and points
- **📊 Live Leaderboards** - Real-time standings and rankings
- **🔄 Team Management** - Add/drop drivers, transfer windows

#### **Advanced Features**
- **⚡ Real-time Race Updates** - Turbo Streams for live race day
- **📈 Driver Performance Analytics** - Historical data and trends
- **🏆 Season Championships** - Multiple championship formats
- **📱 Mobile App** - Native mobile experience
- **🔔 Push Notifications** - Race alerts and updates
- **📊 Advanced Statistics** - Detailed performance metrics
- **🎯 Predictions** - User race predictions and scoring

## 🛠️ Technology Stack

### **Backend**
- **Ruby 3.4.4** - Latest Ruby version with performance improvements
- **Rails 8.0.2** - Modern Rails framework with Hotwire
- **SQLite3** - Lightweight database for development
- **bcrypt** - Secure password hashing
- **Puma** - High-performance web server
- **Nokogiri** - Web scraping for F1 data integration

### **Frontend**
- **Tailwind CSS 3.3.1** - Utility-first CSS framework
- **Hotwire/Turbo** - Real-time updates without JavaScript
- **Stimulus** - Lightweight JavaScript framework
- **Importmap** - Modern JavaScript package management

### **Development Tools**
- **Brakeman** - Security vulnerability scanner
- **RuboCop** - Ruby code style checker
- **Debug** - Enhanced debugging experience
- **Web Console** - Interactive console on error pages

## 📁 Project Structure

```
Fantasty-F1-League/
├── app/
│   ├── controllers/
│   │   ├── application_controller.rb
│   │   ├── pages_controller.rb
│   │   ├── sessions_controller.rb
│   │   └── users_controller.rb
│   ├── models/
│   │   └── user.rb
│   ├── views/
│   │   ├── layouts/
│   │   │   └── application.html.erb
│   │   ├── pages/
│   │   │   ├── dashboard.html.erb
│   │   │   ├── home.html.erb
│   │   │   ├── login.html.erb
│   │   │   └── signup.html.erb
│   │   └── sessions/
│   └── assets/
│       └── stylesheets/
│           └── application.tailwind.css
├── config/
│   ├── routes.rb
│   └── tailwind.config.js
├── db/
│   ├── migrate/
│   │   └── 20250802111200_create_users.rb
│   └── schema.rb
└── README.md
```

## 🚀 Getting Started

### **Prerequisites**
- Ruby 3.4.4 or higher
- Rails 8.0.2 or higher
- SQLite3
- Node.js (for Tailwind CSS)

### **Installation**

1. **Clone the repository**
   ```bash
   git clone https://github.com/SidathPeiris/Fantasty-F1-League.git
   cd Fantasty-F1-League
   ```

2. **Install dependencies**
   ```bash
   bundle install
   ```

3. **Set up the database**
   ```bash
   rails db:create
   rails db:migrate
   ```

4. **Build Tailwind CSS**
   ```bash
   bin/rails tailwindcss:build
   ```

5. **Start the development server**
   ```bash
   rails s
   ```

6. **Visit the application**
   Open your browser and go to `http://localhost:3000`

### **Creating Your First Account**

1. **Visit the signup page** - Click "Get Started" on the landing page
2. **Fill in your details**:
   - Full Name: Your complete name
   - Email: Your email address
   - Username: Choose a unique username
   - Password: Create a strong password
3. **Submit the form** - You'll be automatically logged in and redirected to the dashboard
4. **Explore the dashboard** - Check out all the F1 features available

## 🎨 Design System

### **F1 Theme**
- **🏎️ Racing Red** - Primary brand color (#dc2626)
- **⚫ Dark Background** - Professional dark theme
- **🎯 Gradient Effects** - Modern gradient backgrounds
- **📱 Responsive** - Works perfectly on all devices

### **Typography**
- **Orbitron** - Futuristic font for headings
- **Inter** - Clean, readable font for body text
- **Consistent Hierarchy** - Clear visual hierarchy

### **Components**
- **Buttons** - Gradient buttons with hover effects
- **Cards** - F1-themed dashboard cards
- **Forms** - Styled input fields with validation
- **Navigation** - Intuitive navigation system

## 🔧 Development

### **Running Tests**
```bash
bin/rails test
```

### **Code Quality**
```bash
# Run RuboCop
bundle exec rubocop

# Run Brakeman security scan
bundle exec brakeman
```

### **Database Management**
```bash
# Create database
rails db:create

# Run migrations
rails db:migrate

# Reset database
rails db:reset

# Seed data (when available)
rails db:seed
```

## 🎯 Roadmap

### **Phase 1: Foundation** ✅
- [x] Rails 8 application setup
- [x] Database configuration
- [x] Basic project structure
- [x] Development environment

### **Phase 2: Core Features** ✅
- [x] User authentication system
- [x] F1 teams and drivers database
- [x] Dynamic pricing and rating system
- [x] Admin panel for data management
- [x] Rating summary and calculations
- [x] Database consistency across all pages

### **Phase 3: Advanced Features** 🚧
- [ ] Fantasy team creation interface
- [ ] Real-time race updates with Turbo Streams
- [ ] Live leaderboards and rankings
- [ ] Driver performance analytics
- [ ] Team management (add/drop drivers)
- [ ] Transfer windows and budget management

### **Phase 4: Polish & Deploy** 📋
- [ ] Mobile responsive optimization
- [ ] Push notifications
- [ ] Performance optimization
- [ ] Production deployment

## 🏗️ Project Structure

```
Fantasty-F1-League/
├── 📁 app/                    # Application code
│   ├── 📁 controllers/       # Controllers
│   ├── 📁 models/           # Database models
│   ├── 📁 views/            # View templates
│   └── 📁 assets/           # CSS, JS, images
├── 📁 config/               # Configuration files
├── 📁 db/                   # Database files
├── 📁 lib/                  # Library modules
├── 📁 public/               # Static files
├── 📁 test/                 # Test files
└── 📁 vendor/               # Third-party code
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **Formula 1** - For the inspiration and racing excitement
- **Rails Team** - For the amazing framework
- **Tailwind CSS** - For the beautiful design system
- **Open Source Community** - For all the amazing tools and libraries

## 📞 Support

If you have any questions or need help, please open an issue on GitHub or contact the development team.

---

**🏎️ Ready to start your Fantasy F1 journey? Sign up today and join the race! 🏁**
