module RideUtils
    extend ActiveSupport::Concern
  
    def calculate_duration(start_date, end_date)
        start_time = DateTime.parse(start_date)
        end_time = DateTime.parse(end_date)
        duration = (end_time - start_time).to_i
        # Retorne a duração em um formato apropriado para o seu caso
        # Por exemplo, você pode retornar em minutos, horas, dias, etc.
        duration.minutes
    end

    def calculate_value(duration)
        # Baseado na duração, calcule o valor da corrida, seguindo a regra:
        # A cada 1 minuto de corrida, será cobrado 1.5 real        
        duration * 0.9
    end
  end
  