require 'reco4life/version'
require 'http'
require 'json'

module Reco4life
  API_URL = 'http://api.reco4life.com/v/api.1.1'
  GET_TOKEN = "#{API_URL}/get_token?user_name=%s&api_key=%s"
  ITEM_LIST = "#{API_URL}/item_list?user_name=%s"
  ITEM_SWITCH = "#{API_URL}/item_switch?user_name=%s&sn=%s&status=%d"
  ERROR_CODE_MAP = {
      -1 => '操作失败',
      2 => 'TOKEN错误',
      3 => 'TOKEN失效',
      4 => 'TOKEN超出每小时使用次数',
      5 => 'TOKEN超出每天使用次数',
      6 => '用户名与API_KEY校验失败',
      7 => '用户没有权限操作对应的硬件',
      8 => '用户控制的硬件已断开连接',
      999 => '服务异常',
  }

  class << self
    attr_accessor :user_name, :api_key

    def devices
      fetch_devices.map { |h| h['sn'] }
    end

    def turn_on(sn)
      return if powered_on?(sn)
      switch(sn, 1)
    end

    def turn_off(sn)
      return unless powered_on?(sn)
      switch(sn, 0)
    end

    def online?(sn)
      check(sn, 'is_online')
    end

    def powered_on?(sn)
      check(sn, 'is_poweron')
    end

    private

    def refresh_token
      hash = JSON.parse HTTP.get(GET_TOKEN % [user_name, api_key]).to_s
      @token = hash['token']
      raise ERROR_CODE_MAP[hash['result'].to_i] if @token.nil?
      @token_expire_time = Time.parse(hash['expire_date'])
    end

    def token_valid?
      @token && !token_expired?
    end

    def fetch_devices
      refresh_token unless token_valid?
      hash = JSON.parse HTTP[token: @token].get(ITEM_LIST % user_name).to_s
      raise ERROR_CODE_MAP[hash['result'].to_i] if hash['result'] != '1'
      hash['list']
    end

    def check(sn, field_name)
      fetch_devices.each { |h| return h[field_name] == 1 if h['sn'] == sn }
      raise ERROR_CODE_MAP[7]
    end

    def switch(sn, status)
      hash = JSON.parse HTTP[token: @token].get(ITEM_SWITCH % [Reco4life.user_name, sn, status]).to_s
      raise ERROR_CODE_MAP[hash['result'].to_i] if hash['result'] != '1'
    end

    def token_expired?
      @token_expire_time && @token_expire_time < Time.now
    end
  end
end
