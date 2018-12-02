module Sandboxer
  class CLI
    extend Forwardable

    def self.call
      new.call
    end

    def initialize
      @cli_config = Hash[*ARGV]
      @config     = YAML.load_file(File.open('config/sandboxer.yml'))
      @client     = JenkinsApi::Client.new(config[:jenkins])
      @git        = Git.open(Dir.pwd)
    end

    def call
      update_job
      build_job
    end

    private

    attr_reader :config, :client, :git, :cli_config

    def_delegators :git, :current_branch
    def_delegators :client, :job

    def update_job
      update_job_config
      job.update(job_name, job_config.to_xml)
    end

    def build_job
      job.build(job_name, {}, options)
    end

    def job_name
      return @job_name if defined?(@job_name)

      job_prefix = cli_config['-j'] || cli_config['--job_name'] || config[:sandboxer][:job_name]
      sandbox_name = cli_config['-s'] || cli_config['--sandbox_name'] || config[:sandboxer][:sandbox_name]

      @job_name = "#{ job_prefix }/job/#{ sandbox_name }"
    end

    def job_config
      @job_config ||= Nokogiri::XML(job.get_config(job_name))
    end

    def options
      { build_start_timeout: 30 }
    end

    def update_job_config
      execute_shell.content = updated_execute_shell
    end

    def execute_shell
      job_config.search("command").first
    end

    def updated_execute_shell
      execute_shell.text.sub(/"github_branch=.*\"/, "\"github_branch=#{ branch_name }\"")
    end

    def branch_name
      @branch_name ||= cli_config['-b'] || cli_config['--branch_name'] || current_branch
    end
  end
end
