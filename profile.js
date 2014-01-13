'use strict';

angular.module('nv.profile', [])

  .provider('Profile', function ProfileProvider () {


    /**
     * Location of profile service
     */

    var host, urls = {};

    this.configure = function (info) {
      host = this.host = info.host;
      urls.profile = host + '/v1/profile';
      this.urls = urls;
    };



    this.$get = ['$q', 'OAuth', function ($q, OAuth) {


      /**
       * Profile constructor
       */

      function Profile () {
        var data = localStorage['profile'];

        if (typeof data === 'string') {
          data = JSON.parse(data);
          angular.extend(this, data);
        }
      }


      /**
       * Get profile data
       */

      Profile.prototype.get = function () {
        var profile = this
          , deferred = $q.defer()
          ;

        function success (data) {
          angular.extend(profile, data);
          localStorage['profile'] = JSON.stringify(data);
          deferred.resolve(data);
        }

        function failure (fault) {
          deferred.reject(fault);
          profile.reset();
        }

        OAuth({
          url: urls.profile,
          method: 'GET'
        }).then(success, failure);

        return deferred.promise;
      };


      /**
       * Reset profile
       */

      Profile.prototype.reset = function () {
        var key;
        for (key in this) { delete this[key]; }
        localStorage.removeItem('profile');
      };


      /**
       * Initialize Profile
       */

      return new Profile();

    }];
  });
