'use strict'


describe 'Profile', ->




  {ProfileProvider,Profile,$httpBackend} = {}

  url = 'https://profile.api.tld'

  profile =
    website: 'http://anvil.io'
    twitter: 'anvilhacks'
    avatar:  'http://www.gravatar.com/avatar/ac38fc165fe07b74d6ed5eb9fb9d35e9'




  beforeEach module 'anvil'
  beforeEach module 'nv.profile'

  beforeEach module ($injector) ->
    ProfileProvider = $injector.get 'ProfileProvider'
    ProfileProvider.configure host: url

  beforeEach inject ($injector) ->
    localStorage['profile'] = JSON.stringify profile
    #delete localStorage['profile']
    OAuth        = $injector.get 'OAuth'
    OAuth.setCredentials access_token: 'RANDOM'

    Profile      = $injector.get 'Profile'
    $httpBackend = $injector.get '$httpBackend'




  describe 'provider configuration', ->

    it 'should set the provider host', ->
      expect(ProfileProvider.host).toBe url

    it 'should set the profile url', ->
      expect(ProfileProvider.urls.profile).toContain '/v1/profile'




  describe 'service', ->

    it 'should deserialize localStorage', ->
      expect(Profile.website).toBe profile.website
      expect(Profile.twitter).toBe profile.twitter
      expect(Profile.avatar).toBe profile.avatar

    it 'should get the profile from configured host', ->
      headers =
        'Authorization': 'Bearer RANDOM'
        'Accept': 'application/json, text/plain, */*'
      $httpBackend.expectGET(ProfileProvider.urls.profile, headers).respond(200, {})
      Profile.get()
      $httpBackend.flush()


