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
        url: 'upload',
        type: 'post',
        data : formData,
        processData: false,
        contentType: false
    });
}