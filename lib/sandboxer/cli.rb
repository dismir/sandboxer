module Sandboxer
  class CLI
    extend Forwardable

    def self.call
      new.call
    end

    def initialize
      @config     = YAML.load_file(File.open('config/sandboxer.yml'))
      @client     = JenkinsApi::Client.new(config[:jenkins])
      @git        = Git.open(Dir.pwd)
    end

    def call
      if ARGV.include?('-l') || ARGV.include?('--list')
        list_jobs
      else
        update_job
        build_job
      end
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

    def list_jobs
      jobs_list = job.list_all
      jobs_list.map! { |env_job_name| job.list_details(env_job_name) }

      jobs_list.each do |job|
        puts job['name']

        job['jobs'].each do |sub_job|
          puts "  -j #{ job['name'] } -s #{ sub_job['name'] }"
        end
      end
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
      execute_shell.text.sub(/github_branch=.* build_user/, "github_branch=#{ branch_name } build_user")
    end

    def branch_name
      @branch_name ||= cli_config['-b'] || cli_config['--branch_name'] || current_branch
    end

    def cli_config
      @cli_config ||= Hash[*ARGV]
    end
  end
end
