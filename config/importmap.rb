# Pin npm packages by running ./bin/importmap
pin '@hotwired/turbo-rails', to: '@hotwired--turbo-rails.js' # @2.1.0
pin '@hotwired/stimulus', to: 'stimulus.min.js'
pin '@hotwired/stimulus-loading', to: 'stimulus-loading.js'
pin_all_from 'app/javascript/controllers', under: 'controllers'
# pin 'bootstrap', to: 'bootstrap.bundle.min.js'

pin 'application'
# pin '@fortawesome/fontawesome-free', to: 'https://cdn.jsdelivr.net/npm/@fortawesome/fontawesome-free@6.7.2/css/all.min.css'
