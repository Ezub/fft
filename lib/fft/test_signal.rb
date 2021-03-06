# coding: UTF-8
require 'fft/function'

# Public: Класс, реализующий джентельменский набор сигналов
class TestSignal < Function

  # Public: Дефолное значение отношения частот дискретизации и сигнала
  F_DIVISION = 2

  # Public: Дефолное значение частоты дискретизации
  F_DISCRET = 10

  # Public: Дефолное значение колличества отсчетов сигнала
  COUNT = 128

  # Public: Метод создает тестовый косинусоидальный сигнал
  #
  # count       - Fixnum, колличество отсчетов при дискретизации, по умолчанию 128
  # ampl        - Fixnum, амплитуда сигнала
  # phase       - Fixnum, начальная фаза сигнала
  # f_division  - Fixnum, отношение частоты дисректизации к частоте сигнала
  #
  # Examples
  #
  #   TestSignal.cos_signal(1, 0, 4)
  #
  # Returns TestSignal
  def self.cos_signal(ampl = 1, phase = 0, f_division = F_DIVISION)
    self.new { |n| ampl * Math.cos(2 * Math::PI * n / f_division + phase) }
  end

  # Public: Метод создает тестовый cинусоидальный сигнал
  #
  # count       - Fixnum, колличество отсчетов при дискретизации, по умолчанию 128
  # ampl        - Fixnum, амплитуда сигнала
  # phase       - Fixnum, начальная фаза сигнала
  # f_division  - Fixnum, отношение частоты дисректизации к частоте сигнала
  #
  # Examples
  #
  #   TestSignal.sin_signal(1, 0, 4)
  #
  # Returns TestSignal
  def self.sin_signal(ampl = 1, phase = 0, f_division = F_DIVISION)
    self.new { |n| ampl * Math.sin(2 * Math::PI * n / f_division + phase) }
  end

  def self.radio_impulse(ampl = 1, q = 4, phase = 0, ti = 10, t0 = 1, f_division = F_DIVISION, f_discret = F_DISCRET)
    f_s = TestSignal.f_signal(f_division, f_discret)

    self.new do |n|
      if n.to_f / f_s > t0 + ti  
        t0 = t0 + q * ti
      end

      window = h(t0).result(n.to_f / f_s) - h((t0 + ti)).result(n.to_f / f_s)
      window * ampl * Math.cos(2 * Math::PI * n / f_division + phase)
    end
  end

  def self.radio_impulse1(ampl = 1, q = 4, phase = 0, f_division = F_DIVISION, count = 64)
    self.new do |n|
      if n < count / q 
        ampl * Math.cos(2 * Math::PI * n / f_division + phase)
      else
        0
      end
    end
  end

  def self.h(t0)
    self.new do |x|
      x - t0 < 0 ? 0:1    
    end
  end

  def self.mix(fdiv1 = 0.5, fdiv2 = 2/1.2, a1 = 1, a2 = 5)
    self.new { |n| a1 * Math.cos(2 * Math::PI * n / fdiv1) + a2 * Math.cos(2 * Math::PI * n / fdiv2) }
  end

  def self.cos_signal_with_noise(ampl = 1, phase = 0, f_division = F_DIVISION, n1 = 60)
    self.new do |n|
      if n < n1
        ampl * Math.cos(2 * Math::PI * n / f_division + phase)
      else
        0
      end
    end
  end

  def self.f_signal(f_division, f_discret)
    f_discret / f_division
  end
end