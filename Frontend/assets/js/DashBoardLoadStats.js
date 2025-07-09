document.addEventListener('DOMContentLoaded', () => {
  // Fetch table data from the API
  const token = localStorage.getItem('token')
  fetch(`${base_url}/api/admin/stats`, {
    method: 'GET',
    headers: {
      'Content-Type': 'application/json',
      Authorization: 'Bearer ' + token
    }
  })
    .then(response => {
      if (!response.ok) {
        throw new Error('Network response was not ok')
      }
      return response.json()
    })
    .then(data => {
      // Update the stats cards with the fetched data
      document.getElementById('totalUsers').textContent = data.total_users
      document.getElementById('totalCustomers').textContent =
        data.total_customers
      document.getElementById('totalHalls').textContent = data.total_halls
      document.getElementById('totalBookings').textContent = data.total_bookings

      // Format revenue with commas for thousands
      const formattedRevenue = new Intl.NumberFormat().format(data.revenue)
      document.getElementById('totalRevenue').textContent = formattedRevenue
    })
    .catch(error => {
      console.error('Error fetching stats:', error)
      // Update cards with error message
      const errorElements = document.querySelectorAll('.cards .text-xl')
      errorElements.forEach(el => {
        el.textContent = 'Error'
        el.classList.add('text-red-500')
      })
    })
})
