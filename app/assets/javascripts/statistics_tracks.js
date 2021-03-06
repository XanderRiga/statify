//= require jquery3

$(document).ready(function() {
    $(".track-change").each(function() {
        $(this).change(function() {
            get_updated_stats();
        });
    });
});

function get_updated_stats() {
    $.ajax({
        url: 'top_tracks',
        type: 'post',
        dataType: 'json',
        data: dates(),
        success: function(data) { update_results(data) },
        error: function(error) {}
    });
}

function dates() {
    return {
        start_date: $('#start-date').val(),
        end_date: $('#end-date').val()
    }
}

function update_results(data) {
    let tableBody = $('#result-table tbody');
    tableBody.empty();

    if (data.length <= 3) {
        $('#result-table').hide();
        show_error_text();
        return;
    }
    for (let record of data) {
        let link = '/spotify/' + record[1]['artist_id'] + '/artist';
        let row = '<tr><td>'  + record[0] + '</td><td><a href=' + link + '>'  + record[1]['artist'] + '</a></td><td>' + record[1]['occurrences'] + '</td></tr>';

        tableBody.append(row);
    }
    $('#result-table').show();
    hide_error_text();
}

function show_error_text() {
    $('.error-text').removeClass('is-hidden');
}

function hide_error_text() {
    $('.error-text').addClass('is-hidden');
}