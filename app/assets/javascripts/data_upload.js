//= require jquery3

$(document).ready(function() {
    const input = $('#file-input');
    input.change(function() { upload_files(); });
});

function upload_files() {
    let formData = new FormData();
    let files = Array.from($('#file-input').prop('files'));
    files.forEach((file, index) => {
        formData.append('file_' + index, file)
    });

    $.ajax({
        url: 'upload_files',
        type: 'post',
        data : formData,
        processData: false,
        contentType: false,
        success: function(data) { success_response() },
        error: function(error) { error_response() }
    });
}

function success_response() {
    alert("Files successfully uploaded. It may take some time for all of your data to be stored");
}

function error_response() {
    alert("One or more files was not formatted correctly. Make sure you upload them directly as given from Spotify.");
}