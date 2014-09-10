class AppLogger

  def initialize(app, logger)
    @app, @logger = app, logger
  end

  def call(env)
    env['app.loger'] = @logger
    @app.call(env)
  end

end
