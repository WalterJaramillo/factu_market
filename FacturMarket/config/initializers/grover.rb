# config/initializers/grover.rb
Grover.configure do |config|
  config.options = {
    # Ajusta opciones como formato, margin, timeout
    format: 'A4',
    margin: { top: '10mm', bottom: '10mm' }
  }
end
