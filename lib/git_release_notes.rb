require 'ostruct'
require 'thor'
require 'git_release_notes/version'

BLANK_LINE = "\n\n"
HR = "\n\n* * *\n\n"

class Array
  def blank_line
    self.join(BLANK_LINE)
  end

  def hr
    self.join(HR)
  end
end

module GitReleaseNotes

  class ReleaseLog
    attr_accessor :release_notes

    def initialize text_log
      @release_notes = build_release_notes(build_log(text_log))
    end

    def get options = nil
      if options.filter_tags?
        tags_to_filter = options.filter_tags.split ','
        @release_notes.select{ |l| l.tags.any? { |t| tags_to_filter.include? t } }
      else
        @release_notes
      end
    end

    def build_log text
      log_rx = /=====BEGIN===== *:sha: *(.*?) *:time: *(.*?) *:body: *(.*?) *=====END=====/m
      log_matches = text.scan log_rx
      log_matches.map{|i| OpenStruct.new(Hash[*(["sha", "time", "body"].zip i).flatten])}
    end

    def build_release_notes(log)
      release_note_rx = /<%\s*release-note(\((.*?)\))?\s*(.*?)%>/m
      tmp = []
      log.each do |l|
        l.rn_scans = l.body.scan(release_note_rx)
        if l.rn_scans.empty?
          tmp.push nil
        else
          tmp.push l.rn_scans.map {|n|
            OpenStruct.new({sha: l.sha,  time: l.time, note: n[2], tags: (n[1].split(',') rescue [])})
          }
        end
      end
      tmp.compact.flatten
    end
  end

  class ReleaseNotesParser < Thor
    def initialize(args = [], local_options = {}, config = {})
      super args, local_options, config
      # ditch if we are not in a git repo!
      abort "You suck" unless git_repo?
    end

    package_name "Release notes parser"

    desc "list", "List all release notes from git log"
    method_option :sha, banner: "Specify the SHA of the starting commit (parses log from SHA to HEAD on current branch)", required: true
    method_option :reverse, banner: "List release notes in reverse chronological order (newest -> oldest)", type: :boolean
    method_option :show_time, banner: "List release notes with SHA1 & time of commit", type: :boolean
    method_option :show_tags, banner: "List release notes showing their tags", type: :boolean
    method_option :filter_tags, banner: "Specify a comma separated list of release note meta-tags to be included. See README for details"
    def list
      puts "# Listing release notes (#{options.sha} => HEAD)#{HR}"
      @release_notes = git_log(options.sha).get(options)
      if options.reverse?
        @release_notes.reverse!
      end
      output = @release_notes.map{ |r|
        out = []
        if options.show_time?
          out.push "**sha:** #{r.sha} / **time:** #{DateTime.strptime(r.time,'%s')}#{BLANK_LINE}"
        end
        if options.show_tags?
          out.push "**tags:** _#{r.tags.join(', ')}_#{BLANK_LINE}" unless r.tags.empty?
        end
        if options.show_time? || options.show_tags?
          out.push HR
        end
        out.push r.note, BLANK_LINE
        out.join
      }.hr
      puts output
    end

    private

    # execute git command on --git-dir
    def gitcmd(cmd)
      %x(git #{cmd})
    end

    def git_repo?
      ! git_root.include? "fatal: Not a git repository (or any of the parent directories): .git"
    end

    def git_root
      %x(git rev-parse --show-toplevel)
    end

    def git_log(a, b = 'HEAD')
      ReleaseLog.new gitcmd %Q(log #{a}..#{b} --pretty=format:"=====BEGIN===== :sha: %h :time: %at :body: %B =====END=====")
    end
  end
end
