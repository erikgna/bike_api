module RideUtils
    extend ActiveSupport::Concern
  
    def calculate_duration(start_date, end_date)        
        duration = (end_date - start_date).to_i        
        # Retorne a duração em um formato apropriado para o seu caso
        # Por exemplo, você pode retornar em minutos, horas, dias, etc.
        duration / 60
    end

    def calculate_value(duration)
        # Baseado na duração, calcule o valor da corrida, seguindo a regra:
        # A cada 1 minuto de corrida, será cobrado 0.5 real        
        duration * 0.5
    end

    def calculate_distance(lat1, lon1, lat2, lon2)
        radius = 6371  # Raio médio da Terra em quilômetros
      
        dlat = deg2rad(lat2 - lat1)
        dlon = deg2rad(lon2 - lon1)
      
        a = Math.sin(dlat / 2) * Math.sin(dlat / 2) +
            Math.cos(deg2rad(lat1)) * Math.cos(deg2rad(lat2)) *
            Math.sin(dlon / 2) * Math.sin(dlon / 2)
        c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a))
      
        distance = radius * c  # Distância em quilômetros
      
        return distance
    end

    private def deg2rad(deg)
        return deg * (Math::PI / 180)
    end
  end
  