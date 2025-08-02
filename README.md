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

### 🎮 **Upcoming Fantasy League Features**

#### **Core Features**
- **👤 User Authentication** - Sign up, login, and user profiles
- **🏎️ F1 Teams & Drivers Database** - Complete current F1 data
- **⚔️ Fantasy Team Creation** - Users build their fantasy teams
- **🏁 Race Results Tracking** - Real-time race outcomes and points
- **📊 Live Leaderboards** - Real-time standings and rankings
- **⚙️ Admin Panel** - Manage races, results, and league settings

#### **Advanced Features**
- **⚡ Real-time Race Updates** - Turbo Streams for live race day
- **📈 Driver Performance Analytics** - Historical data and trends
- **🔄 Team Management** - Add/drop drivers, transfer windows
- **⚙️ League Settings** - Customizable scoring and rules
- **📱 Mobile Responsive** - Works perfectly on all devices
- **🔔 Push Notifications** - Race start alerts and results

#### **Technical Features**
- **🎨 Tailwind CSS** - Modern, responsive styling
- **🔌 RESTful API** - Clean, well-structured endpoints
- **🗄️ Database Migrations** - Version-controlled schema changes
- **🧪 Testing Suite** - Comprehensive test coverage
- **🚀 Deployment Ready** - Kamal configuration included

## 🛠️ Technology Stack

| Component | Technology | Version |
|-----------|------------|---------|
| **Backend** | Ruby on Rails | 8.0.2 |
| **Database** | SQLite3 (dev) / PostgreSQL (prod) | Latest |
| **Frontend** | Hotwire, Stimulus, Tailwind CSS | Latest |
| **JavaScript** | Importmap | Latest |
| **Server** | Puma | Latest |
| **Deployment** | Kamal | Included |

## 📦 Installation

### **Prerequisites**
- Ruby 3.4.4+
- Rails 8.0.2+
- Node.js (for asset compilation)
- Git

### **Setup Instructions**

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

4. **Start the development server**
   ```bash
   rails s
   ```

5. **Visit the application**
   Open your browser and go to `http://localhost:3000`

## 🎮 Development Workflow

### **Starting the Server**
```bash
rails s
```

### **Database Operations**
```bash
# Create database
rails db:create

# Run migrations
rails db:migrate

# Reset database
rails db:reset
```

### **Adding New Features**
```bash
# Generate a new model
rails generate model ModelName

# Generate a new controller
rails generate controller ControllerName

# Generate a new migration
rails generate migration MigrationName
```

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

## 🎯 Roadmap

### **Phase 1: Foundation** ✅
- [x] Rails 8 application setup
- [x] Database configuration
- [x] Basic project structure
- [x] Development environment

### **Phase 2: Core Features** 🚧
- [ ] User authentication system
- [ ] F1 teams and drivers database
- [ ] Basic fantasy team creation
- [ ] Simple race results tracking

### **Phase 3: Advanced Features** 📋
- [ ] Real-time updates with Turbo Streams
- [ ] Live leaderboards
- [ ] Driver performance analytics
- [ ] Admin panel for data management

### **Phase 4: Polish & Deploy** 📋
- [ ] Mobile responsive design
- [ ] Push notifications
- [ ] Performance optimization
- [ ] Production deployment

## 🤝 Contributing

We welcome contributions! Here's how you can help:

1. **Fork the repository**
2. **Create a feature branch** (`git checkout -b feature/amazing-feature`)
3. **Commit your changes** (`git commit -m 'Add amazing feature'`)
4. **Push to the branch** (`git push origin feature/amazing-feature`)
5. **Open a Pull Request**

### **Development Guidelines**
- Follow Rails conventions
- Write tests for new features
- Update documentation
- Keep commits clean and descriptive

## 📄 License

This project is licensed under the **MIT License** - see the [LICENSE](LICENSE) file for details.

## 🏆 About

**Fantasy F1 League** is a comprehensive web application that allows users to create and manage fantasy Formula 1 teams. Built with modern Rails 8 features, it provides a smooth, real-time experience for F1 fans to compete in their own fantasy league.

### **Key Benefits**
- **⚡ Real-time Updates** - Live race data and standings
- **👥 User-Friendly** - Intuitive interface for all skill levels
- **📈 Scalable** - Built to handle growing user bases
- **🛠️ Modern** - Latest web technologies and best practices

## 📞 Support

- **Issues**: [GitHub Issues](https://github.com/SidathPeiris/Fantasty-F1-League/issues)
- **Discussions**: [GitHub Discussions](https://github.com/SidathPeiris/Fantasty-F1-League/discussions)
- **Email**: sidathpeiris@gmail.com

---

<div align="center">

**Built with ❤️ using Ruby on Rails 8**

[![GitHub stars](https://img.shields.io/github/stars/SidathPeiris/Fantasty-F1-League?style=social)](https://github.com/SidathPeiris/Fantasty-F1-League)
[![GitHub forks](https://img.shields.io/badge/github-forks-blue?style=social)](https://github.com/SidathPeiris/Fantasty-F1-League)

</div>
