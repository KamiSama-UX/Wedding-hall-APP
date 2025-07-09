// Function to open modal for adding photos to a hall
function openAddPhotosModal (hallId) {
  const input = document.createElement('input')
  input.type = 'file'
  input.accept = 'image/*'
  input.multiple = true

  input.onchange = async () => {
    const files = input.files
    if (!files.length) return

    // Show loading alert with progress bar
    let timerInterval
    Swal.fire({
      title: 'Uploading Photos',
      html: `
            <div style="margin: 20px 0;">
              <div class="progress" style="height: 20px; background: #f1f1f1; border-radius: 10px;">
                <div id="upload-progress" style="height: 100%; width: 0%; background: #4CAF50; border-radius: 10px; transition: width 0.3s;"></div>
              </div>
              <p id="progress-text" style="text-align: center; margin-top: 10px;">0%</p>
            </div>
            <div id="upload-preview" style="display: none; margin-top: 20px;">
              <p>Uploaded Images:</p>
              <div id="preview-container" style="display: flex; flex-wrap: wrap; gap: 10px;"></div>
            </div>
          `,
      showConfirmButton: false,
      allowOutsideClick: false,
      didOpen: () => {
        Swal.showLoading()
      },
      willClose: () => {
        clearInterval(timerInterval)
      }
    })

    const token = localStorage.getItem('token')
    const previewContainer = document.getElementById('preview-container')
    const uploadPreview = document.getElementById('upload-preview')
    const progressBar = document.getElementById('upload-progress')
    const progressText = document.getElementById('progress-text')

    try {
      // Upload each file sequentially
      for (let i = 0; i < files.length; i++) {
        const file = files[i]
        const formData = new FormData()
        formData.append('photo', file)

        // Create XMLHttpRequest for progress tracking
        const xhr = new XMLHttpRequest()
        xhr.open('POST', `${base_url}/api/halls/${hallId}/photos`, true)
        xhr.setRequestHeader('Authorization', 'Bearer ' + token)

        xhr.upload.onprogress = e => {
          if (e.lengthComputable) {
            const percentComplete = Math.round((e.loaded / e.total) * 100)
            progressBar.style.width = percentComplete + '%'
            progressText.textContent = `Uploading ${i + 1}/${
              files.length
            }: ${percentComplete}%`
          }
        }

        await new Promise((resolve, reject) => {
          xhr.onload = () => {
            if (xhr.status >= 200 && xhr.status < 300) {
              // Show preview of uploaded image
              const reader = new FileReader()
              reader.onload = e => {
                const imgElement = document.createElement('img')
                imgElement.src = e.target.result
                imgElement.style.width = '100px'
                imgElement.style.height = '100px'
                imgElement.style.objectFit = 'cover'
                previewContainer.appendChild(imgElement)
                uploadPreview.style.display = 'block'
              }
              reader.readAsDataURL(file)
              resolve(xhr.response)
            } else {
              reject(new Error('Upload failed'))
            }
          }
          xhr.onerror = () => reject(new Error('Upload failed'))
          xhr.send(formData)
        })
      }

      // Update to show completion
      progressBar.style.width = '100%'
      progressBar.style.background = '#4CAF50'
      progressText.textContent = `Upload complete! ${files.length} files uploaded`

      // Show success message with preview
      Swal.fire({
        title: 'Upload Successful!',
        html: `
              <p>${files.length} photos uploaded successfully</p>
              <div style="display: flex; flex-wrap: wrap; gap: 10px; margin-top: 20px; max-height: 300px; overflow-y: auto;">
                ${Array.from(files)
                  .map(
                    file => `
                  <img src="${URL.createObjectURL(
                    file
                  )}" style="width: 100px; height: 100px; object-fit: cover;" />
                `
                  )
                  .join('')}
              </div>
            `,
        icon: 'success',
        confirmButtonText: 'OK'
      })
    } catch (error) {
      console.error('Error uploading photos:', error)
      Swal.fire({
        icon: 'error',
        title: 'Upload Failed',
        text: 'Error uploading photos: ' + error.message,
        confirmButtonText: 'OK'
      })
    }
  }

  input.click()
}
