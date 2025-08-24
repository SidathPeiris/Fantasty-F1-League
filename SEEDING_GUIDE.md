# 🌍 Race Data Seeding Guide

This guide explains how to populate your Fantasy F1 League database with race data after cloning the repository.

## 📋 What's Included

The race data seeds include:
- **13 races** for the 2025 F1 season
- **130 driver results** (top 10 for each race)
- **39 constructor results** (top 3 for each race)
- **39 qualifying results** (top 3 for each race)

## 🚀 Quick Start

After cloning the repository and setting up your database, you have several options:

### Option 1: Seed Everything at Once (Recommended)
```bash
bin/rails db:seed:all
```
This will populate:
- Base drivers and constructors
- Race schedule
- All race results
- Qualifying results
- Constructor results

### Option 2: Seed Race Data Only
```bash
bin/rails db:seed:race_data
```
This will populate only the race-related data (useful if you already have base data).

### Option 3: Seed Base Data Only
```bash
bin/rails db:seed
```
This will populate only the base drivers and constructors (default Rails behavior).

## 📊 What Gets Created

### Races (13 total)
1. Australian Grand Prix - March 16, 2025
2. Saudi Arabian Grand Prix - March 23, 2025
3. Bahrain Grand Prix - March 30, 2025
4. Japanese Grand Prix - April 6, 2025
5. Chinese Grand Prix - April 13, 2025
6. Miami Grand Prix - May 4, 2025
7. Emilia Romagna Grand Prix - May 18, 2025
8. Monaco Grand Prix - May 25, 2025
9. Spanish Grand Prix - June 1, 2025
10. Canadian Grand Prix - June 15, 2025
11. Austrian Grand Prix - June 29, 2025
12. British Grand Prix - July 6, 2025
13. Belgian Grand Prix - July 27, 2025
14. Hungarian Grand Prix - August 3, 2025

### Sample Results Pattern
Each race includes:
- **Driver Results**: Top 10 positions with realistic points distribution
- **Constructor Results**: Top 3 teams based on driver performance
- **Qualifying Results**: Top 3 qualifying positions

## 🔧 Database Setup

Before running seeds, ensure your database is set up:

```bash
# Create and migrate database
bin/rails db:create
bin/rails db:migrate

# Then run seeds
bin/rails db:seed:all
```

## 📝 Customizing Results

The race results in `db/seeds_race_data.rb` are sample data. You can:

1. **Edit the file** to change race results
2. **Add more races** by extending the `races_data` array
3. **Modify driver positions** for each race
4. **Adjust points distribution** if needed

## 🎯 Use Cases

### For Development
- Quick setup of a working fantasy league
- Testing team building functionality
- Demonstrating the rating system

### For Production
- Initial season setup
- Historical race data preservation
- Consistent starting point for all users

### For Cloning
- Preserve all your entered race data
- No need to re-enter results manually
- Consistent experience across machines

## 🚨 Important Notes

- **Data is idempotent**: Running seeds multiple times won't create duplicates
- **Existing data is cleared**: The race data seeds will clear existing results before creating new ones
- **Base data is preserved**: Drivers and constructors from main seeds are not affected
- **Ratings are updated**: All driver and constructor ratings are recalculated after seeding

## 🐛 Troubleshooting

### Common Issues

**"Driver not found" errors**
- Ensure main seeds ran first: `bin/rails db:seed`
- Check that all drivers exist in the database

**"Race already exists" warnings**
- This is normal - seeds use `find_or_create_by`
- No duplicate races will be created

**Database connection errors**
- Verify database configuration in `config/database.yml`
- Ensure database server is running

### Reset Everything
If you need to start completely fresh:

```bash
bin/rails db:drop
bin/rails db:create
bin/rails db:migrate
bin/rails db:seed:all
```

## 📚 Related Files

- `db/seeds.rb` - Base data (drivers, constructors)
- `db/seeds_race_data.rb` - Race data (races, results, qualifying)
- `lib/tasks/seed_race_data.rake` - Rake tasks for seeding

## 🤝 Contributing

To add new race data or modify existing results:
1. Edit `db/seeds_race_data.rb`
2. Test with `bin/rails db:seed:race_data`
3. Commit your changes
4. Update this guide if needed

---

**Happy Racing! 🏁**
