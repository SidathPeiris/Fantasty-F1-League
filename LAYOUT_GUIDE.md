# Fantasy F1 League - Layout Guide

## Consistent Page Layout Pattern

All pages in the Fantasy F1 League application follow a consistent layout pattern to ensure a cohesive user experience.

### 1. Page Structure

```erb
<!-- Page Name -->
<div class="min-h-screen bg-gradient-to-br from-gray-900 via-red-900 to-black">
  <%= render 'shared/header' %>

  <!-- Main Content -->
  <div class="container mx-auto px-4 py-8">
    <!-- Page Header -->
    <%= render 'shared/page_header', title: '🏎️ Page Title', subtitle: 'Optional subtitle text' %>
    
    <!-- Page Content -->
    <!-- Your page content here -->
  </div>
</div>
```

### 2. Shared Components

#### `shared/_header.html.erb`
- **Purpose**: User authentication and navigation
- **Position**: Top right corner of every page
- **Content**: 
  - Welcome message with user's name
  - Admin button (only for SidathPeiris)
  - Logout button
  - Login link (for non-authenticated users)

#### `shared/_page_header.html.erb`
- **Purpose**: Page title and navigation
- **Position**: Below the main header
- **Content**:
  - Fantasy F1 League button (left)
  - Page title (center)
  - Empty space (right) for balance
  - Optional subtitle

### 3. Layout Rules

#### Header Positioning
- **User info**: Always in top right corner
- **Admin button**: Only visible for username "SidathPeiris"
- **Logout**: Red text with hover effects
- **Login**: Blue text with hover effects

#### Page Header Positioning
- **Fantasy F1 League button**: Left side, links to dashboard
- **Page title**: Center, large and bold
- **Spacing**: Consistent margins and padding

#### Content Spacing
- **Main container**: `container mx-auto px-4 py-8`
- **Page header**: `mb-12` (margin bottom)
- **Content sections**: Use appropriate spacing

### 4. Usage Examples

#### Dashboard Page
```erb
<%= render 'shared/page_header', title: '🏎️ Your F1 Command Center', subtitle: 'Manage your fantasy team, track races, and dominate the leaderboard!' %>
```

#### My Team Page
```erb
<%= render 'shared/page_header', title: '🏎️ My Team', subtitle: 'Build your dream F1 team with the best drivers and constructors' %>
```

#### Create Team Page
```erb
<%= render 'shared/page_header', title: '🏎️ Create My Team' %>
```

### 5. Styling Guidelines

#### Colors
- **Primary**: Red gradient (`from-red-600 to-red-700`)
- **Secondary**: Gray gradients for cards
- **Text**: White for headings, gray-300 for body text
- **Links**: Blue for login, red for logout

#### Typography
- **Page titles**: `text-5xl font-bold text-white`
- **Subtitles**: `text-xl text-gray-300`
- **Card titles**: `text-2xl font-bold text-white`
- **Body text**: `text-gray-400`

#### Spacing
- **Container padding**: `px-4 py-8`
- **Section margins**: `mb-12` for major sections
- **Card spacing**: `gap-8` for grids

### 6. Future Development

When creating new pages:
1. Always use `shared/_header` for user authentication
2. Use `shared/_page_header` for consistent page titles
3. Follow the established color scheme and spacing
4. Test the layout on different screen sizes
5. Ensure the admin button only appears for SidathPeiris

This ensures all pages maintain a consistent, professional appearance while providing a great user experience.
