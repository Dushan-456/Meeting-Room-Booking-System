/**
 * MRBS Custom Functionality
 * 1. Handles conditional field visibility for Zoom/Hybrid meeting links.
 * 2. Provides real-time validation for the 'How many participants' field.
 */

$(document).on('ready page_ready tableload', function() {
    
    // --- 0. Digital Clock ---
    function updateClock() {
        var $clock = $('#digital-clock');
        if ($clock.length === 0) return;

        var now = new Date();
        var hours = now.getHours();
        var minutes = now.getMinutes();
        var seconds = now.getSeconds();
        var ampm = hours >= 12 ? 'PM' : 'AM';
        
        hours = hours % 12;
        hours = hours ? hours : 12; 
        minutes = minutes < 10 ? '0'+minutes : minutes;
        seconds = seconds < 10 ? '0'+seconds : seconds;
        
        var timeString = hours + ':' + minutes + ':' + seconds + ' ' + ampm;
        $clock.text(timeString);
    }
    
    // Clear any existing interval to prevent multiple clocks running
    if (window.clockInterval) {
        clearInterval(window.clockInterval);
    }
    
    function initClock() {
        if ($('#digital-clock').length > 0) {
            updateClock();
            if (window.clockInterval) clearInterval(window.clockInterval);
            window.clockInterval = setInterval(updateClock, 1000);
        }
    }
    
    initClock();

    // --- 1. Hybrid Meeting Link & Zoom Times Toggle & Validation ---
    function checkHybridFieldsValidity() {
        var hybridSelected = $('input[name="f_hybrid_facility"]:checked').val() === '1';
        var fields = [
            { name: 'f_meeting_link', label: 'Zoom or Google Meet Link', errorId: 'meeting_link_error' },
            { name: 'f_zoom_start_time', label: 'Zoom Start Time', errorId: 'zoom_start_time_error' },
            { name: 'f_zoom_end_time', label: 'Zoom End Time', errorId: 'zoom_end_time_error' }
        ];

        var allValid = true;

        fields.forEach(function(f) {
            var input = $('[name="' + f.name + '"]');
            var errorDiv = $('#' + f.errorId);
            if (input.length === 0) return;

            if (hybridSelected && input.val().trim() === '') {
                if (input[0].setCustomValidity) {
                    input[0].setCustomValidity(f.label + ' is required.');
                }
                if (errorDiv.length) {
                    errorDiv.text(f.label + ' is required when Zoom/Hybrid facility is selected.').css('display', 'block');
                }
                input.css({
                    'border-color': '#ff5252',
                    'box-shadow': '0 0 0 3px rgba(255, 82, 82, 0.2)'
                });
                allValid = false;
            } else {
                if (input[0].setCustomValidity) {
                    input[0].setCustomValidity('');
                }
                if (errorDiv.length) errorDiv.hide();
                input.css({
                    'border-color': '',
                    'box-shadow': ''
                });
            }
        });

        return allValid;
    }

    function toggleMeetingLink() {
        var $hybridChecked = $('input[name="f_hybrid_facility"]:checked');
        var selectedValue = $hybridChecked.val();
        
        var fields = [
            { name: 'f_meeting_link', containerClass: 'meeting_link_field', errorId: 'meeting_link_error', label: 'Zoom Link' },
            { name: 'f_zoom_start_time', containerClass: 'zoom_start_time_field', errorId: 'zoom_start_time_error', label: 'Zoom Start Time' },
            { name: 'f_zoom_end_time', containerClass: 'zoom_end_time_field', errorId: 'zoom_end_time_error', label: 'Zoom End Time' }
        ];

        fields.forEach(function(f) {
            var container = $('.' + f.containerClass);
            var input = $('[name="' + f.name + '"]');
            var errorDiv = $('#' + f.errorId);

            // Create error div if it doesn't exist
            if (errorDiv.length === 0 && container.length > 0) {
                errorDiv = $('<div id="' + f.errorId + '" class="field_error" style="display: none; color: #ff5252; font-weight: bold; margin-top: 5px; font-size: 0.85rem; width: 100%;"></div>');
                container.append(errorDiv);
            }

            if (selectedValue === '1') {
                container.attr('style', 'display: flex !important; flex-wrap: wrap !important;');
                input.prop('required', true).attr('required', 'required');
            } else {
                container.attr('style', 'display: none !important');
                input.prop('required', false).removeAttr('required');
                input.val(''); 
                if (input[0] && input[0].setCustomValidity) {
                    input[0].setCustomValidity('');
                }
                if (errorDiv.length) errorDiv.hide();
            }
        });

        checkHybridFieldsValidity();
    }

    if ($('input[name="f_hybrid_facility"]').length > 0) {
        toggleMeetingLink();
        $(document).on('change', 'input[name="f_hybrid_facility"]', function() {
            toggleMeetingLink();
        });
        $(document).on('input change', '[name="f_meeting_link"], [name="f_zoom_start_time"], [name="f_zoom_end_time"]', function() {
            checkHybridFieldsValidity();
        });
    }

    // High-priority interceptor for form submission using Capture Phase
    document.addEventListener('submit', function(e) {
        if (e.target && e.target.id === 'main') {
            var isValid = checkHybridFieldsValidity();
            if (!isValid) {
                e.preventDefault();
                e.stopImmediatePropagation();
                
                var $form = $(e.target);
                $form.find('input[type=submit]').prop('disabled', false);
                $form.removeData('submit');
                
                // Focus the first empty required field
                var firstError = $form.find('[name="f_meeting_link"], [name="f_zoom_start_time"], [name="f_zoom_end_time"]').filter(function() {
                    return $(this).val().trim() === '';
                }).first();
                if (firstError.length) firstError.focus();
                
                return false;
            }
        }
    }, true); // True means capture phase, which runs before MRBS's listeners


    // --- 2. Time Picker Enhancements ---
    // Trigger native time picker when clicking anywhere in the input field
    $(document).on('click', '[name="f_zoom_start_time"], [name="f_zoom_end_time"]', function() {
        if (this.showPicker) {
            try {
                this.showPicker();
            } catch (err) {
                // Fallback for browsers that don't support showPicker() yet
                $(this).focus();
            }
        } else {
            $(this).focus();
        }
    });

    // --- 3. Seat Count Validation ---
    function validateSeatCount() {
        var seatCountField = $('input[name="f_seat_count"]');
        if (seatCountField.length === 0) return;

        var maxCapacity = parseInt(seatCountField.attr('max'));
        var seatCount = parseInt(seatCountField.val());
        var errorDiv = $('#seat_count_error');

        if (!isNaN(seatCount) && !isNaN(maxCapacity) && seatCount > maxCapacity) {
            seatCountField.css({
                'border-color': '#ff5252',
                'background-color': 'rgba(255, 82, 82, 0.1)'
            });
            errorDiv.text('Error: Number of participants (' + seatCount + ') cannot exceed room capacity (' + maxCapacity + ')!').show();
        } else {
            seatCountField.css({
                'border-color': '',
                'background-color': ''
            });
            errorDiv.hide();
        }
    }

    if ($('input[name="f_seat_count"]').length > 0) {
        validateSeatCount();
        $(document).off('input change', 'input[name="f_seat_count"]').on('input change', 'input[name="f_seat_count"]', function() {
            validateSeatCount();
        });
    }

    // --- 3. Message Ticker (Marquee Effect) ---
    $('.message_top').each(function() {
        var $this = $(this);
        if ($this.find('span').length === 0) {
            var text = $this.text();
            $this.empty().append($('<span>').text(text));
        }
    });

    // --- 4. Dynamic Room Capacity Update ---
    function updateMaxCapacity() {
        var $roomSelect = $('#rooms');
        if ($roomSelect.length === 0) return;

        var maxCapacity = 0;
        $roomSelect.find('option:selected').each(function() {
            var capacity = parseInt($(this).attr('data-capacity')) || 0;
            if (capacity > maxCapacity) {
                maxCapacity = capacity;
            }
        });

        // Ensure max capacity cannot be minus
        if (maxCapacity < 0) maxCapacity = 0;

        var $seatCountField = $('input[name="f_seat_count"]');
        if ($seatCountField.length > 0) {
            $seatCountField.attr('max', maxCapacity);
            $seatCountField.attr('min', 0); // Ensure cannot be minus
            
            // Update the hint text
            var $hint = $seatCountField.parent().find('.field_hint');
            if ($hint.length > 0) {
                $hint.text("Max room capacity: " + maxCapacity);
            }
            
            // Re-validate seat count
            validateSeatCount();
        }
    }

    // Listen for room selection changes
    $(document).on('change', '#rooms', function() {
        updateMaxCapacity();
    });

    // Also handle area changes which swap the rooms list
    $(document).on('change', 'select[name="area"]', function() {
        // MRBS dynamic room swapping takes a moment
        setTimeout(updateMaxCapacity, 200);
    });

    // Initial check on load
    updateMaxCapacity();
});
