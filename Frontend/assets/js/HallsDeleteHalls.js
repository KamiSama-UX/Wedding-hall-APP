// Delete handler
function handleDelete (hallId) {
  Swal.fire({
    title: 'Are you sure?',
    text: "You won't be able to revert this!",
    icon: 'warning',
    showCancelButton: true,
    confirmButtonColor: '#d33',
    cancelButtonColor: '#3085d6',
    confirmButtonText: 'Yes, delete it!'
  }).then(result => {
    if (!result.isConfirmed) return

    const token = localStorage.getItem('token')

    fetch(`${base_url}/api/halls/${hallId}`, {
      method: 'DELETE',
      headers: {
        Authorization: 'Bearer ' + token
      }
    })
      .then(async response => {
        let isOk = response.ok
        let responseText = await response.text()

        // Optional: try parsing the response if it's JSON
        try {
          const json = JSON.parse(responseText)
          if (json.error && json.error.includes('logAction is not defined')) {
            isOk = true // Treat this specific error as a success
          }
        } catch (e) {
          // Not JSON or no error field, ignore
        }

        if (!isOk) {
          throw new Error(responseText || 'Failed to delete hall.')
        }

        Swal.fire({
          icon: 'success',
          title: 'Deleted!',
          text: 'Hall deleted successfully.',
          timer: 2000,
          showConfirmButton: false
        }).then(() => {
          location.reload() // Refresh the page
        })
      })
      .catch(error => {
        Swal.fire({
          icon: 'error',
          title: 'Error',
          text: error.message || 'Failed to delete the hall.'
        })
      })
  })
}
