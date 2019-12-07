//= require jquery3

$(document).ready(function() {
    $(":input").each(function() {
        $(this).change(function() {
            if (too_many_checked()) {
                alert("You can only select up to 5 artists");
                this.checked = false;
            } else {
                show_progress_bar();
                update_recommendations();
            }
        });
    });
});

function update_recommendations() {
    $.ajax({
        url: 'recommendations',
        type: 'get',
        dataType: 'json',
        data: data_from_inputs(),
        success: function(data) { set_data(data) },
        error: function(error) { handle_error(error) }
    });
}

function data_from_inputs() {
    let data = {};
    $(":input").each(function() {
        let input = $(this);

        if (input.attr('type') === 'checkbox') {
            if (input.prop('checked') === true) {
                data[input.attr('name')] = input.attr('value')
            }
        }

        if (input.attr('type') === 'range') {
            data[input.attr('name')] = input.val()
        }
    });
    return data
}

function set_data(data) {
    let tableBody = $('#recommendation-table tbody');
    tableBody.empty();
    for (let track of data) {
        let row = '<tr><td>' + track.name + '</td><td>' + track.artists.join(', ') + '</td><td>' + track.album + '</td></tr>';

        $('#help-text').hide();
        hide_progress_bar();
        tableBody.append(row);
    }
    $('#recommendation-table').show();
}

function show_progress_bar() {
    $('#progress-bar').removeClass('is-hidden');
}

function hide_progress_bar() {
    $('#progress-bar').addClass('is-hidden');
}

function handle_error(error) {
    hide_progress_bar();
    $('#help-text').show();
    $('#recommendation-table').hide();
}

function too_many_checked() {
    return ($('input[type=checkbox]:checked').length > 5)
}