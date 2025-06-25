// Function to view hall photos
async function viewHallPhotos (hallId) {
  try {
    const token = localStorage.getItem('token')

    // Show loading
    Swal.fire({
      title: 'Loading Photos',
      html: 'Please wait while we fetch the hall photos...',
      allowOutsideClick: false,
      didOpen: () => {
        Swal.showLoading()
      }
    })

    // Fetch photos from API
    const response = await fetch(`${base_url}/api/halls/${hallId}/photos`, {
      headers: {
        Authorization: 'Bearer ' + token
      }
    })

    if (!response.ok) throw new Error('Failed to fetch photos')

    const data = await response.json()
    if (!data.photos || data.photos.length === 0) {
      Swal.fire({
        icon: 'info',
        title: 'No Photos Found',
        text: 'This hall has no photos yet.',
        confirmButtonText: 'OK'
      })
      return
    }

    // Separate cover photo from other photos
    const coverPhoto = data.photos.find(photo => photo.is_cover)
    const otherPhotos = data.photos.filter(photo => !photo.is_cover)

    // Create HTML content for the modal
    let photosHTML = `
      <div class="hall-photos-container">
        <h3 class="text-lg font-semibold mb-4">Hall Photos</h3>
    `

    // Add cover photo section if exists
    if (coverPhoto) {
      const newPath = coverPhoto.url.replace('/public', '')
      photosHTML += `
        <div class="cover-photo-section mb-6">
          <h4 class="font-medium mb-2">Cover Photo</h4>
          <div class="relative rounded-lg shadow-xl hover:shadow-2xl transition-shadow duration-300">
            <img src="${base_url}${newPath}" crossorigin="anonymous" class="w-full h-64 object-cover" style="width: auto; margin: auto;" />
            <div class="absolute top-2 right-2 flex gap-2">
              <button onclick="nondeletePhoto(${hallId}, ${coverPhoto.id}, event)" 
                      class="bg-red-500 text-white rounded-full hover:bg-red-600"
                      style="width: 30px; height: 30px; display: flex; justify-content: center; align-items: center;">
                <i class="fas fa-trash text-xs"></i>
              </button>
            </div>
          </div>
        </div>
      `
    }

    // Add other photos section if there are other photos
    if (otherPhotos.length > 0) {
      photosHTML += `
        <div class="other-photos-section">
          <h4 class="font-medium mb-2">${
            coverPhoto ? 'Other Photos' : 'All Photos'
          }</h4>
          <div class="grid grid-cols-3 gap-4">
      `

      // Add other photos
      otherPhotos.forEach(photo => {
        const newPathphoto = photo.url.replace('/public', '')

        photosHTML += `
          <div class="relative rounded-lg shadow-xl hover:shadow-2xl transition-shadow duration-300">
            <img src="${base_url}${newPathphoto}" crossorigin="anonymous" class="w-full h-40 object-cover" style="width: auto; margin: auto;" />
            <div class="absolute top-2 right-2 flex gap-2">
              <button onclick="deletePhoto(${hallId}, ${photo.id}, event)" 
                      class="bg-red-500 text-white rounded-full hover:bg-red-600"
                      style="width: 30px; height: 30px; display: flex; justify-content: center; align-items: center;">
                <i class="fas fa-trash text-xs"></i>
              </button>
              <button onclick="setAsCoverPhoto(${hallId}, ${photo.id}, event)" 
                      class="bg-blue-500 text-white rounded-full hover:bg-blue-600"
                      style="width: 30px; height: 30px; display: flex; justify-content: center; align-items: center;">
                <i class="fas fa-star text-xs"></i>
              </button>
            </div>
          </div>
        `
      })

      photosHTML += `
          </div>
        </div>
      `
    }

    photosHTML += `</div>`

    // Show photos in modal
    Swal.fire({
      title: `Hall Photos (${data.photos.length})`,
      html: photosHTML,
      width: '80%',
      showConfirmButton: false,
      showCloseButton: true
    })
  } catch (error) {
    console.error('Error loading photos:', error)
    Swal.fire({
      icon: 'error',
      title: 'Error',
      text: 'Failed to load photos: ' + error.message,
      confirmButtonText: 'OK'
    })
  }
}
// Function to delete a photo
async function nondeletePhoto (hallId, photoId, event) {
  await Swal.fire({
    icon: 'warning',
    title: 'Cannot Delete Cover',
    html: `You cannot delete the cover photo directly.<br>
                Please set another photo as cover first.`,
    confirmButtonText: 'OK'
  })
  return
}
// Function to delete a photo
async function deletePhoto (hallId, photoId, event) {
  event.stopPropagation()

  // Confirmation dialog
  const result = await Swal.fire({
    title: 'Delete Photo?',
    text: "You won't be able to revert this!",
    icon: 'warning',
    showCancelButton: true,
    confirmButtonColor: '#d33',
    cancelButtonColor: '#3085d6',
    confirmButtonText: 'Yes, delete it!'
  })

  if (!result.isConfirmed) return

  try {
    const token = localStorage.getItem('token')

    // Send delete request
    const response = await fetch(
      `${base_url}/api/halls/${hallId}/photos/${photoId}`,
      {
        method: 'DELETE',
        headers: {
          Authorization: `Bearer ${token}`,
          'Content-Type': 'application/json'
        }
      }
    )

    // Handle response without throwing errors
    if (response.status === 400) {
      const data = await response.json()
      if (data.error?.includes('cover photo')) {
        await Swal.fire({
          icon: 'warning',
          title: 'Cannot Delete Cover',
          html: `You cannot delete the cover photo directly.<br>
                Please set another photo as cover first.`,
          confirmButtonText: 'OK'
        })
        return
      }
    }

    if (!response.ok) {
      throw new Error('Failed to delete photo')
    }

    // Success case
    await Swal.fire({
      icon: 'success',
      title: 'Deleted!',
      text: 'Photo was deleted successfully.',
      confirmButtonText: 'OK'
    })

    viewHallPhotos(hallId)
  } catch (error) {
    // Only show generic error if not already handled
    if (!error.message.includes('cover photo')) {
      await Swal.fire({
        icon: 'error',
        title: 'Deletion Failed',
        text: error.message,
        confirmButtonText: 'OK'
      })
    }
  }
}
// Function to set a photo as cover
async function setAsCoverPhoto (hallId, photoId, event) {
  event.stopPropagation()

  try {
    const token = localStorage.getItem('token')

    const response = await fetch(
      `${base_url}/api/halls/${hallId}/photos/${photoId}/cover`,
      {
        method: 'PATCH',
        headers: {
          Authorization: 'Bearer ' + token
        }
      }
    )

    if (!response.ok) throw new Error('Failed to set as cover photo')

    Swal.fire({
      icon: 'success',
      title: 'Success!',
      text: 'Photo has been set as cover.',
      confirmButtonText: 'OK'
    }).then(() => {
      viewHallPhotos(hallId) // Refresh the photos view
    })
  } catch (error) {
    console.error('Error setting cover photo:', error)
    Swal.fire({
      icon: 'error',
      title: 'Error',
      text: 'Failed to set as cover photo: ' + error.message,
      confirmButtonText: 'OK'
    })
  }
}
