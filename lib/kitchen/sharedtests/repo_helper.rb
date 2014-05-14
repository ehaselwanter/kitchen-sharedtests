class RepoHelper

  URL_PATTERNS = [
    /^(ssh:\/\/)?git@github.com:(?<user>[^\/]+)\/(?<repo>.+)\.git$/,
    /^https:\/\/github.com\/(?<user>[^\/]+)\/(?<repo>.+)\.git$/,
    /^git@bitbucket.org:(?<user>[^\/]+)\/(?<repo>.+)\.git$/,
    /^(ssh:\/\/)?git@bitbucket.org\/(?<user>[^\/]+)\/(?<repo>.+)\.git$/,
    /^https:\/\/([^@]+@)?bitbucket.org\/(?<user>[^\/]+)\/(?<repo>.+)\.git$/,
    /^(ssh:\/\/)?git@(?<host>[^:]*):(?<user>[^\/]+)\/(?<repo>.+)\.git$/
  ]

  def self.get_repo url
    # find the url pattern that matches the url
    URL_PATTERNS.map{|p| p.match url }.compact.first
  end
end  