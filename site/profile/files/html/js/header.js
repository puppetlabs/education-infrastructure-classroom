(function($) {
  $(document).ready(function() {
    var PH = {


      /**
       * Puppet Header initialization method.
       */
      init: function() {
        this.stickyHeader();
        this.mainMenu();
        this.mainMenuSearch();
        this.mobileMenu();
      },


      /**
       * Functionality related to the main menu's "sticky header".
       */
      stickyHeader: function() {
        if ('sticky' in $.fn) {
          var
            body        = $('body');

          // Initialize main navigation as sticky
          $('.global-header__row.__row2').sticky({
            start: 'top',
            end: 'top',
            smooth: true,
            stack: true,
            onStick: function(elm) {
              var
                drupal_toolbar_1       = $('#toolbar-bar'),
                drupal_toolbar_2       = $('#toolbar-item-administration-tray'),
                total_toolbar          = drupal_toolbar_1.outerHeight();

              // Calculate second tray height when not vertical
              if (!drupal_toolbar_2.hasClass('toolbar-tray-vertical')) {
                total_toolbar += drupal_toolbar_2.outerHeight();
              }

              // Offset global header by total height of drupal admin toolbars
              elm.css('margin-top', total_toolbar);

              // Indicate row 2 of global header is stuck
              body.addClass('global-header-row-2-fixed');
            },
            onUnstick: function(elm) {

              // Remove global header row 2 offset
              elm.css('margin-top', '');

              // Remove row 2 body class
              body.removeClass('global-header-row-2-fixed');
            }
          });
        }
      },


      /**
       * Handles main menu related functionality.
       */
      mainMenu: function() {
        var

          //
          // Populates search input on load from previous search
          //
          toggleDDMenu        = function(e) {
            var
              target        = $(e.currentTarget),
              target_menu   = target.next('.dropdown-menu');

            // Prevent following link
            e.preventDefault();

            if (!target.data('state')) {
              target.data('state', 'closed');
            } else if (target.data('state') == 'closed') {
              target.data('state', 'open');
            } else if (target.data('state') == 'open') {
              target.data('state', 'closed');
            }

            // Close any other open menus
            $('a.dropdown__tab:not(.search-a):not(.hamburger-a)').each(function(idx, elm) {
              var other_target = $(elm).next('.dropdown-menu');
              if (other_target.hasClass('open')) {
                other_target.removeClass('open');
                other_target.prev('.dropdown__tab').removeClass('open').data('state', 'open');
              }
            });

            // Toggle menu open/closed
            if (target.data('state') == 'closed') {
              target.addClass('open');
              target_menu.addClass('open');
            } else if (target.data('state') == 'open') {
              target.removeClass('open');
              target_menu.removeClass('open');
            }
          };

        // Attach drop down menu handlers
        $('a.dropdown__tab:not(.search-a):not(.hamburger-a)').on('click', toggleDDMenu);
      },


      /**
       * Functionality related to the main menu search functionality.
       */
      mainMenuSearch: function() {
        var
          search_button                           = $('.global-header__nav-main__item.search'),
          search_input                            = $('.search-slider-table__cell__input'),

          //
          // Populates search input on load from previous search
          //
          populateSearchInputOnLoadfunction       = function(e) {
            var
              search_input                              = $('.search-slider-table__cell__input'),
              search_input_mobile                       = $('.mobile-search__input'),
              actual_search_result_input                = $('#search-form input.form-search');
            search_input.val(actual_search_result_input.val());
            search_input_mobile.val(actual_search_result_input.val());
          },

          //
          // Handle main menu search
          //
          handleSearch          = function(e) {
            var
              search_slider             = $('.search-slider'),
              search_input              = $('.search-slider-table__cell__input'),
              search_string             = search_input.val(),
              actual_search_input       = $('.hidden-search input'),
              actual_search_form        = $('.hidden-search form');

            // Prevent default click action
            if (e.type == 'click') e.preventDefault();

            // Execute search
            if ((e.type == 'click' && search_slider.data('open') && search_string) || (e.keyCode == 13 && search_string)) {
              actual_search_input.val(search_string);
              actual_search_form.submit();
            }
          },

          //
          // Handle toggling the "search slider"
          //
          toggleSearch          = function(e) {
            e.preventDefault();
            var
              search_slider       = $('.search-slider'),
              search_input        = search_slider.find('input'),
              logo_col            = $('.global-header__row__col.__col1'),
              search_button_pos   = search_button.offset().left,
              logo_col_pos        = logo_col.offset().left,
              logo_col_width      = logo_col.outerWidth(),
              total_width         = search_button_pos - (logo_col_pos + logo_col_width);

            // Hide menu after inactive
            if (e.type == 'mouseenter') {
              clearTimeout(search_slider.data('leave_timeout'));
            }
            else if (e.type == 'mouseleave') {
              search_slider.data('leave_timeout', setTimeout(function() {
                if (search_slider.data('open')) {
                  search_slider.click();
                }
              }, 2000));
            }

            // Toggle menu
            else if (search_slider.outerWidth() <= 0 && !search_slider.data('open')) {

              // Show search
              search_slider.stop(true).show().animate({width: total_width}, {duration: 200, complete: function() {

                // Add body class
                $('body').addClass('search-open');

                // Set data flag
                search_slider.data('open', true);

                // Give input focus
                search_input.focus();
              }});
            }
            else if (search_slider.data('open')) {

              // Hide search
              search_slider.stop(true).animate({width: 0}, {duration: 200, complete: function() {

                // Attempt a search
                handleSearch(e);

                // Remove body class
                $('body').removeClass('search-open');

                // Set data flag
                search_slider.data('open', false);

                // Hide slider
                search_slider.hide();
              }});
            }
          };

        // Attach search handlers
        search_button.on('click', toggleSearch);
        search_button.on('mouseenter', toggleSearch);
        search_button.on('mouseleave', toggleSearch);
        search_input.on('keydown', handleSearch);
        search_input.on('click', function(e) {
          e.stopPropagation();
        });

        // Populate search with any previous searches
        populateSearchInputOnLoadfunction();
      },


      /**
       * Functionality related to the mobile menu.
       */
      mobileMenu: function() {
        var
          hamburger         = $('.hamburger-a'),
          overlay           = $('.global-header__mobile-menu-cover'),
          search_button     = $('.search-button');

        //
        // Handle mobile menu open/close
        //
        hamburger.on('click', function(e) {
          e.preventDefault();
          var
            win                     = $(window),
            body                    = $('body'),
            global_header           = $('.global-header'),
            header_row_1            = global_header.find('.__row1'),
            header_row_2            = global_header.find('.__row2'),
            layout_footer           = $('.layout-footer'),
            window_w                = $(window).outerWidth(),
            hasScrollBar            = $(document).height() > win.height();

          // Set styles on layout elements before toggling class
          if (!body.hasClass('mobile-menu-open')) {

            // Layout container
            win.data('last-scroll-pos', win.scrollTop());
            body.css({
              width: hasScrollBar ? window_w + 16 : window_w,
              top: -win.scrollTop()
            });

            // Global header
            global_header.css({
              width: hasScrollBar ? window_w + 16 : window_w,
              top: win.scrollTop()
            });

            // Hide row 2 of global header when global header is fixed
            if (header_row_2.css('position') == 'fixed') {
              header_row_1.css('display', 'none');
            }

            // Footer
            layout_footer.css('width', window_w);

          } else {
            body.css({
              width: '',
              top: ''
            });
            global_header.css({
              width: '',
              top: ''
            });
            header_row_1.css('display', '');
            layout_footer.css('width', '');
          }

          // Toggle mobile menu class
          body.toggleClass('mobile-menu-open');
        });

        //
        // Handle close of mobile menu via click on overlay
        //
        overlay.on('click', function() {
          hamburger.trigger('click');
        });

        //
        // Handle mobile menu search
        //
        search_button.on('click', function(e) {
          e.preventDefault();
          var
            mobile_search_input       = $('.mobile-search__input'),
            search_string             = mobile_search_input.val(),
            actual_search_input       = $('.hidden-search input'),
            actual_search_form        = $('.hidden-search form');

          // Execute search
          actual_search_input.val(search_string);
          actual_search_form.submit();
        });

        //
        // Handle resizing menu while menu is open
        //
        $(window).on('resize', function() {
          if ($('body').hasClass('mobile-menu-open')) {
            hamburger.trigger('click');
          }
        });

      }
    };

    /* faq menu expansion */
    $('#faq > li > .answer').hide();
    $('#faq > li').on("click", function() {
      $('#faq > li').not(this).children('.answer').hide(250);
      $(this).children('.answer').toggle(250);
    });

    // Initialize all header related code
    PH.init();
  });

})(jQuery);
