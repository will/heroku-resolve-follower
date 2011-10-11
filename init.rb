module PGResolver
  class Resolver
    alias :resolve_without_follwer :resolve

    def resolve
      follower_check
      resolve_without_follwer
    end

    def follower_check
      if "-F" == @db_id || "--FOLLOWER" == @db_id
        primary = URI.parse  @dbs.fetch("DATABASE")
        follower = @dbs.find {|id,url|
          cannidate = URI.parse(url)

          cannidate.host != primary.host &&
          cannidate.user == primary.user &&
          cannidate.password == primary.password &&
          cannidate.path == primary.path
        }
        if follower
          @db_id = follower.first
        else
          abort(" !  unable to find a follower")
        end
      end
    end
  end

end
