# Fantasy F1 League - Page Template

Use this template for all new pages to maintain consistent navigation and styling.

## Basic Page Structure

```erb
<!-- [Page Name] Page -->
<div class="min-h-screen bg-gradient-to-br from-gray-900 via-red-900 to-black">
  <!-- CSRF Token for JavaScript functions (if needed) -->
  <meta name="csrf-token" content="<%= form_authenticity_token %>">

  <!-- Navigation Header -->
  <%= render 'shared/navigation' %>

  <!-- Page Title -->
  <div class="bg-gradient-to-br from-gray-900 to-gray-800 py-8">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
      <h1 class="text-4xl font-bold text-white text-center mb-2">[Page Title]</h1>
      <p class="text-xl text-gray-300 text-center">[Page subtitle/description]</p>
    </div>
  </div>

  <!-- Main Content -->
  <div class="container mx-auto px-4 py-8">
    <!-- Your page content goes here -->
  </div>
</div>
```

## Navigation Features

The `shared/navigation` partial provides:

- **Fantasy F1 League Button**: Top-left navigation back to dashboard
- **Welcome Message**: Shows "Welcome, [username]!"
- **Logout Button**: Top-right logout functionality
- **Consistent Styling**: Red gradient theme with hover effects

## Page Title Section

The page title section includes:

- **Large Heading**: 4xl font size, white text
- **Subtitle**: xl font size, gray-300 text
- **Gradient Background**: Dark gray to darker gray
- **Centered Layout**: Professional appearance

## Background Colors

- **Main Background**: `bg-gradient-to-br from-gray-900 via-red-900 to-black`
- **Title Section**: `bg-gradient-to-br from-gray-900 to-gray-800`
- **Navigation**: `bg-gradient-to-r from-red-800 to-red-900`

## Usage Examples

### Simple Content Page
```erb
<!-- Main Content -->
<div class="container mx-auto px-4 py-8">
  <div class="max-w-4xl mx-auto">
    <div class="bg-gradient-to-br from-gray-800 to-gray-900 p-8 rounded-2xl border border-gray-700">
      <h2 class="text-2xl font-bold text-white mb-4">Content Heading</h2>
      <p class="text-gray-300">Your content here...</p>
    </div>
  </div>
</div>
```

### Form Page
```erb
<!-- Main Content -->
<div class="container mx-auto px-4 py-8">
  <div class="max-w-2xl mx-auto">
    <%= form_with url: "/your-endpoint", method: :post, local: true do |form| %>
      <!-- Form fields here -->
      <div class="text-center mt-6">
        <%= form.submit "Submit", class: "bg-gradient-to-r from-red-600 to-red-700 text-white px-6 py-3 rounded-lg hover:from-red-700 hover:to-red-800 transform hover:scale-105 transition-all duration-300" %>
      </div>
    <% end %>
  </div>
</div>
```

## Important Notes

1. **Always include** the navigation partial: `<%= render 'shared/navigation' %>`
2. **Use consistent** background gradients and color schemes
3. **Include CSRF token** if the page has forms or JavaScript that needs it
4. **Follow the layout** structure for consistency across all pages
5. **Use the container classes** for proper spacing and responsiveness

## File Naming Convention

- **File names**: `snake_case.html.erb`
- **Route names**: `snake_case` (e.g., `/my-team`, `/create-team`)
- **Controller actions**: `snake_case` (e.g., `def my_team`, `def create_team`)

This template ensures all pages have the same professional look and feel while maintaining the F1 racing theme!
