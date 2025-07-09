const ctx = document.getElementById('barChart').getContext('2d')
const toggleBtn = document.getElementById('toggleBtn')
const sidebar = document.getElementById('sidebar')

toggleBtn.addEventListener('click', () => {
  sidebar.classList.toggle('collapsed')
})

const token = localStorage.getItem('token')

fetch(`${base_url}/api/admin/charts/bookings-per-day`, {
  headers: {
    Authorization: `Bearer ${token}`
  }
})
  .then(response => response.json())
  .then(data => {
    // تحويل الاستجابة إلى labels و values
    const labels = data.map(item => item.hall_name)
    const values = data.map(item => item.total_bookings)

    const maxValue = Math.max(...values)
    const minValue = Math.min(...values)

    function getColor (value) {
      const startColor = [59, 130, 246]
      const endColor = [191, 219, 254]
      const ratio =
        maxValue === minValue
          ? 0.5
          : 1 - (value - minValue) / (maxValue - minValue)
      const r = Math.round(
        startColor[0] + ratio * (endColor[0] - startColor[0])
      )
      const g = Math.round(
        startColor[1] + ratio * (endColor[1] - startColor[1])
      )
      const b = Math.round(
        startColor[2] + ratio * (endColor[2] - startColor[2])
      )
      return `rgb(${r}, ${g}, ${b})`
    }

    const backgroundColors = values.map(v => getColor(v))

    new Chart(ctx, {
      type: 'bar',
      data: {
        labels: labels,
        datasets: [
          {
            label: 'Bookings',
            data: values,
            backgroundColor: backgroundColors
          }
        ]
      },
      options: {
        plugins: {
          legend: {
            display: false
          }
        },
        indexAxis: 'y',
        responsive: true,
        scales: {
          x: {
            beginAtZero: true
          },
          y: {
            beginAtZero: true
          }
        }
      }
    })
  })
  .catch(error => {
    console.error('Error fetching chart data:', error)
  })

document.addEventListener('DOMContentLoaded', () => {
  // Fetch table data from the API
  const token = localStorage.getItem('token')
  fetch(`${base_url}/api/admin/charts/bookings`, {
    method: 'GET',
    headers: {
      'Content-Type': 'application/json',
      Authorization: 'Bearer ' + token
    }
  })
    .then(response => response.json())
    .then(apiData => {
      // Transform API data into chart format
      const statusCounts = {
        confirmed: 0,
        pending: 0,
        cancelled: 0
      }

      // Count each status from API response
      apiData.forEach(item => {
        if (item.status === 'confirmed') {
          statusCounts.confirmed = item.count
        } else if (item.status === 'pending') {
          statusCounts.pending = item.count
        } else if (item.status === 'declined' || item.status === 'cancelled') {
          statusCounts.cancelled += item.count // Combine declined and cancelled
        }
      })

      // Create the chart with dynamic data
      new Chart(document.getElementById('statusChart'), {
        type: 'doughnut',
        data: {
          labels: ['Confirmed', 'Pending', 'Cancelled'],
          datasets: [
            {
              data: [
                statusCounts.confirmed,
                statusCounts.pending,
                statusCounts.cancelled
              ],
              backgroundColor: ['#3b82f6', '#6ee7b7', '#f87171'],
              borderWidth: 0
            }
          ]
        },
        options: {
          cutout: '50%',
          hoverOffset: 10,
          responsive: false,
          layout: {
            padding: {
              right: 0,
              left: 0
            }
          },
          animation: {
            animateRotate: true,
            animateScale: true
          },
          plugins: {
            legend: {
              position: 'right',
              labels: {
                usePointStyle: true,
                pointStyle: 'circle',
                padding: 20,
                font: {
                  size: 12
                }
              }
            }
          }
        }
      })
    })
    .catch(error => {
      console.error('Error fetching chart data:', error)
      // Display error message or fallback chart
      document.getElementById('statusChart').parentElement.innerHTML =
        '<div class="text-red-500 p-4">Failed to load chart data</div>'
    })
})
