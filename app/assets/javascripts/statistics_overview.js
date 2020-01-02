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
        url: 'overview_data',
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
    let chart_area = $('.charts');
    chart_area.empty();

    hide_error_text();
}

function show_error_text() {
    $('.error-text').removeClass('is-hidden');
}

function hide_error_text() {
    $('.error-text').addClass('is-hidden');
}