//= require jquery3

$(document).ready(function() {
    $(":input").each(function() {
        $(this).change(function() {
            update_recommendations();
        });
    });
});

function update_recommendations() {
    $.ajax({
        url: 'recommendations',
        type: 'get',
        dataType: 'json',
        data: data_from_inputs(),
        success: function(data) { set_data(data) }
    });
}

function data_from_inputs() {
    data = {};
    $(":input").each(function() {
        input = $(this);

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
        tableBody.append(row);
    }
}